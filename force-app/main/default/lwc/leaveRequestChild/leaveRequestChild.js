import { LightningElement,api,track } from 'lwc';

export default class LeaveRequestChild extends LightningElement {

    @api employeeName;
    @api employeeID;

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
    }

}