@isTest
private class CaseEmailHandlerTest {

    @istest
    static void testEmailhandler(){
        Case cse = new Case(
            Subject = 'Test Case',
            Priority = 'Critical',
            Status = 'New'
        );
        Test.startTest();
        insert cse;
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.subject = 'Test Case';
        email.plainTextBody = 'This is a test case created from email.';
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        envelope.fromAddress = 'tusharkandwal99@gmail.com';
        CaseEmailHandler handler = new CaseEmailHandler();
        Messaging.InboundEmailResult result = handler.handleInboundEmail(email, envelope);
        Test.stopTest();
        System.assert(result.success, 'Email handler should return success');
        Case cseFromDb = [SELECT Id, Subject, Description, Status, Origin, Priority, SuppliedEmail FROM Case WHERE Subject = :email.subject AND SuppliedEmail = :envelope.fromAddress LIMIT 1];
        System.assertEquals(email.subject, cseFromDb.Subject, 'Case subject should match email subject');
        System.assertEquals(email.plainTextBody, cseFromDb.Description, 'Case description should match email body');
    }
    
}