/**
 * @description This is the controller class for the Leave Request Tracker Lightning Web Component. It contains methods to retrieve leave requests for a specific employee based on their employee ID.
 */
public with sharing class LeaveRequestTrackerController {

    /**
     * @description This method retrieves the leave requests for a specific employee based on their employee ID.
     * @param employeeId The ID of the employee whose leave requests are to be retrieved.
     * @return A list of LeaveRequestTracker__c records that match the specified employee ID
     */
    @AuraEnabled(Cacheable=true)
    public static List<LeaveRequestTracker__c> leaveRequests(String employeeId){
        return [Select Id,name,Employee_ID__c,Employee_Name__c,From_Date__c,To_Date__c,Status__c,Leave_Type__c from LeaveRequestTracker__c where Employee_ID__c =: employeeId order by CreatedDate desc];
    }   

    @AuraEnabled
    public static void saveLeaveRequest(LeaveRequestTracker__c leaveRequest){
        insert leaveRequest;
    }

}