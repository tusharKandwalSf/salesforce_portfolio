@isTest
private class CaseEscalationSchedulerTest {
    @isTest
    static void testScheduler() {
        Test.startTest();
        System.schedule('Test Escalation Job', '0 0 * * * ?', new CaseEscalationScheduler());
        Test.stopTest();
    }
}