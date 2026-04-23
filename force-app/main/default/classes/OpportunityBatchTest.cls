@isTest
private class OpportunityBatchTest {
    @isTest
    static void testBatch(){
        Opportunity opp = new Opportunity(
            Name = 'Stale Opp', StageName = 'Prospecting',
            Amount = 5000, CloseDate = Date.today()
        );
        insert opp;
    
        Test.startTest();
        OpportunityCleanupBatch.isTesting = true;
		Database.executeBatch(new OpportunityCleanupBatch(),200);
        Test.stopTest();
    
        Opportunity result = [SELECT Is_Stale__c FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(true, result.Is_Stale__c,'Matching stale status');
    }
}