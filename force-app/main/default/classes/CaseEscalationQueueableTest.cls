@isTest
private class CaseEscalationQueueableTest {

    @isTest
    static void testCaseEscalationQueueable() {
        Case cse = new Case(
            Subject = 'Test Case',
            Priority = 'Medium',
            Status = 'New'
        );
        insert cse;
        Test.setCreatedDate(cse.Id, System.now().addHours(-25));
        Id tier1QueueId = [SELECT Id FROM Group WHERE Name = 'Tier 1 Support' AND Type = 'Queue' LIMIT 1].Id;
        cse.OwnerId = tier1QueueId;
        update cse;
        Test.startTest();
        System.enqueueJob(new CaseEscalationQueueable());
        Test.stopTest();
        Case cseFromDb = [SELECT Id, OwnerId, Priority, Status FROM Case WHERE Id = :cse.Id];
        Id tier2QueueId = [SELECT Id FROM Group WHERE Name = 'Tier 2 Support' AND Type = 'Queue' LIMIT 1].Id;
        System.assertEquals('Critical', cseFromDb.Priority, 'Case priority should be escalated to Critical');
        System.assertEquals(tier2QueueId, cseFromDb.OwnerId, 'Case owner should be changed to Tier 2 Support queue');
    }

    @isTest
    static void testCaseEscalationQueueableNew() {
        Case cse = new Case(
            Subject = 'Test Case',
            Priority = 'Medium',
            Status = 'New'
        );
        insert cse;        
        Id tier1QueueId = [SELECT Id FROM Group WHERE Name = 'Tier 1 Support' AND Type = 'Queue' LIMIT 1].Id;
        cse.OwnerId = tier1QueueId;
        update cse;
        Test.startTest();
        System.enqueueJob(new CaseEscalationQueueable());
        Test.stopTest();
        Case cseFromDb = [SELECT Id, OwnerId, Priority, Status FROM Case WHERE Id = :cse.Id];
        System.assertEquals('Medium', cseFromDb.Priority, 'Case priority should be escalated to Critical');
        System.assertEquals(tier1QueueId, cseFromDb.OwnerId, 'Case owner should be changed to Tier 2 Support queue');
    }
}