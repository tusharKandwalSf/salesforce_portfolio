import { LightningElement,api,wire } from 'lwc';
import leaveRequests from '@salesforce/apex/LeaveRequestTrackerController.leaveRequests';
import saveLeaveRequest from '@salesforce/apex/LeaveRequestTrackerController.saveLeaveRequest';
import { refreshApex } from '@salesforce/apex';

export default class LeaveRequestChild extends LightningElement {

    @api employeeName;
    @api employeeID;
    leaves = [];
    error;
    leaveObj = {};
    wiredResult;

    columns = [
        { label: 'Leave Type', fieldName: 'Leave_Type__c' },
        { label: 'From Date', fieldName: 'From_Date__c', type: 'date' },
        { label: 'To Date', fieldName: 'To_Date__c', type: 'date' },
        { label: 'Reason', fieldName: 'Reason__c' },
        { label: 'Status', fieldName: 'Status__c' }
    ]

    @wire(leaveRequests, {employeeId: '$employeeID'})
    wiredLeaveRequestsResult (result){
        this.wiredResult = result;
        const { data, error } = result;
        if(data){
            this.leaves = data;
            console.log('Leave Requests: ', this.leaves);
            this.error = undefined;
        } else if(error){
            this.error = error;
            this.leaves = [];
        }
    }

    sickLeaveCount;
    casualLeaveCount;
    earnedLeaveCount;

    value = '';
    options = [
        { label: 'Sick Leave', value: 'sick' },
        { label: 'Casual Leave', value: 'casual' },
        { label: 'Earned Leave', value: 'earned' }
    ];

    connectedCallback(){
        this.sickLeaveCount = 5;
        this.casualLeaveCount = 10;
        this.earnedLeaveCount = 15;
    }

    get availableLeaveBalance(){
        if(this.value === 'sick') return this.sickLeaveCount;
        if(this.value === 'casual') return this.casualLeaveCount;
        if(this.value === 'earned') return this.earnedLeaveCount;
    }

    handleChange(event){
        this.value = event.detail.value;
    }

    handleFromDateChange(event){
        this.fromDate = event.target.value;
    }

    handleToDateChange(event){
        this.toDate = event.target.value;
    }

    handleReasonChange(event){
        this.reason = event.target.value;
    }

    verifyLeaveBalance(leaveType){
        switch(leaveType){
            case 'sick':
                if(this.sickLeaveCount > 0){
                    this.sickLeaveCount--;
                }
                break;
            case 'casual':
                if(this.casualLeaveCount > 0){
                    this.casualLeaveCount--;
                }
                break;
            case 'earned':
                if(this.earnedLeaveCount > 0){
                    this.earnedLeaveCount--;
                }
                break;
        }
    }

    handleLeaveRequest(){
        if(!this.value || !this.fromDate || !this.toDate || !this.reason){
            alert('Please fill all the fields before submitting the leave request.');
            return;
        }
        const leaveRequestEvent = new CustomEvent('leaverequest',
            {detail:{
                leaveType: this.value,
                fromDate: this.fromDate,
                toDate: this.toDate,
                reason: this.reason                
            }});
        if(this.availableLeaveBalance <= 0){
            alert('Insufficient leave balance for the selected leave type.');
            return;
        }
        this.verifyLeaveBalance(this.value);
        this.dispatchEvent(leaveRequestEvent);
        this.leaveObj = {Employee_ID__c:this.employeeID, Employee_Name__c:this.employeeName, Leave_Type__c:this.value, From_Date__c:this.fromDate, To_Date__c:this.toDate, Reason__c:this.reason, Status__c:'Pending'};
        saveLeaveRequest({leaveRequest: this.leaveObj})
        .then(()=>{
            return refreshApex(this.wiredResult);
        }).catch(error=>{
            console.error('Error saving leave request: ', error);
        })
    }

}