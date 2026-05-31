import { LightningElement,wire } from 'lwc';
import leaveRequests from '@salesforce/apex/LeaveRequestTrackerController.leaveRequests';

export default class LeaveRequestHistory extends LightningElement {

    employeeId;
    @wire(leaveRequests, {employeeId: '$employeeId'})
    leaveRequestsResult;



}