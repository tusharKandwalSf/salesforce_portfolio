import { LightningElement } from 'lwc';

export default class LeaveRequestParent extends LightningElement {

    leaveType;
    fromDate;
    toDate;
    reason;
    
    employeeName = 'John Doe';
    employeeID = 'EMP12345';

    handleLeaveRequest(event){
        this.leaveType = event.detail.leaveType;
        this.fromDate = event.detail.fromDate;
        this.toDate = event.detail.toDate;
        this.reason = event.detail.reason;
    }

}