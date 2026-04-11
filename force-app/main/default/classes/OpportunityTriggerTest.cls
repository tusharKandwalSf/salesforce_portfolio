@isTest
private class OpportunityTriggerTest {  

    @isTest
    static void testAfterInsert() {
        Opportunity opp = new Opportunity(Name = 'Test Opportunity', StageName = 'Prospecting', Amount = 1000, CloseDate = Date.TODAY());
            
        insert opp;
        
        Opportunity insertedOpp = [SELECT Id, Name, CloseDate FROM Opportunity WHERE Id = :opp.Id];
        
        System.assertEquals(System.today(), insertedOpp.CloseDate, 'CloseDate should be set to today\'s date');
    }

}