@isTest
private class CaseTriggerTest {
    
    @isTest
    static void testCaseTrigger() {
        Case cse = new Case(
            Subject = 'Test Case',
            Priority = 'Critical',
            Status = 'New'
        );
        Test.startTest();
        insert cse;
        cse.Resolution_Notes__c = 'Resolved the issue';
        cse.Is_Resolved__c = true;
        //cse.Status = 'Closed';
        update cse;
        Test.stopTest();
        Case cseFromDb = [SELECT Id, OwnerId, Resolution_Time__c,Resolution_Notes__c,Is_Resolved__c,Status FROM Case WHERE Id = :cse.Id];
        System.assertEquals('New', cseFromDb.Status, 'Case status should be New');
    }

    @isTest
    static void testCaseClosed(){
       Case cse = new Case(
            Subject = 'Test Case',
            Priority = 'Critical',
            Status = 'New'
        );
        Test.startTest();
        insert cse; 
        try{
            cse.Resolution_Notes__c = 'Resolved the issue';
            cse.Is_Resolved__c = true;
            cse.Status = 'Closed';
        }Catch(Exception e){
            System.debug('Exception: ' + e.getMessage());
        }
        update cse;
        Test.stopTest();
        Case cseFromDb = [SELECT Id, OwnerId, Resolution_Time__c,Resolution_Notes__c,Is_Resolved__c,Status FROM Case WHERE Id = :cse.Id];
        System.assertEquals('Closed', cseFromDb.Status, 'Case status should be Closed');
    }

}