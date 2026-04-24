public with sharing class CaseEmailHandler implements Messaging.InboundEmailHandler {

    public Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        String subject = email.subject;
        String body = email.plainTextBody;
        Case newCase = new Case();
        newCase.Subject = subject;
        newCase.Description = body;
        newCase.Status = 'New';
        newCase.Origin = 'Email';
        newCase.Priority = 'Medium';
        if (Schema.sObjectType.Group.isAccessible()) {
            Id tier1QueueId = [SELECT Id FROM Group WHERE Name = 'Tier 1 Support' AND Type = 'Queue' LIMIT 1].Id;
            newCase.OwnerId = tier1QueueId;
        }
        newCase.SuppliedEmail = envelope.fromAddress;
        if (Schema.sObjectType.Case.isCreateable()) {
            insert newCase;
        }
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        result.success = true;
        return result;
    }
}