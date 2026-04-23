@isTest
private class OpportunityCleanupSchedulerTest {

    @isTest
    static void schedulerTestMethod(){
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Prospecting', CloseDate=Date.today().addDays(30));
        insert opp;
        Test.startTest();
        System.schedule('TestJob', '0 0 0 ? * * *', new OpportunityCleanupScheduler());
        Test.stopTest();
        List<CronTrigger> cronJobs = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name = 'TestJob'];
        System.assertEquals(1, cronJobs.size(),'Scheduled job was created successfully.');
    }

}