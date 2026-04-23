public with sharing class CaseTriggerService {
    
    static Id tier2QueueId;
    static Id tier1QueueId;
    static Id billingSupportQueueId;

    public void autoAssignQueue(List<Case> newCases){
        if(tier2QueueId == null){
            tier2QueueId = getQueueId('Tier 2 Support');
        }
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
        for(Case cse: newCases){
            if(cse.Priority == 'Critical'){
                cse.OwnerId = tier2QueueId;
                emailsToSend.add(sendEmailToManager());
            }
        }
        if(!Test.isRunningTest() && !emailsToSend.isEmpty()){
            Messaging.sendEmail(emailsToSend);
        }
    }


    private ID getQueueId(String queueName){
        return [SELECT Id FROM Group WHERE Name =: queueName AND Type = 'Queue' LIMIT 1].Id;
            
    }

    private Messaging.SingleEmailMessage sendEmailToManager(){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {'tusharkandwal99@gmail.com'});
        mail.setSubject('Case Escalation Alert');
        mail.setPlainTextBody('A case has been escalated to Tier 2 Support. Please review it as soon as possible.');
        return mail;
    }

    public void validateStatusChange(List<Case> newCases, Map<Id,Case> oldCaseMap){
        List<Case> casesToUpdate = new List<Case>();
        for(Case cse: newCases){
            Case cseOld = oldCaseMap.get(cse.Id);
            if(cse.status == 'Closed' && cseOld.status!=cse.status){
                casesToUpdate.add(cse);
            }
        }
        if(!casesToUpdate.isEmpty()){
            setResolutionTime(casesToUpdate);
        }
    }

    public void setResolutionTime(List<Case> casesToUpdate){
        for(Case cse: casesToUpdate){
            Long diffMs = cse.ClosedDate.getTime() - cse.CreatedDate.getTime();
            Long diffHours = diffMs / (1000 * 60 * 60);
            cse.Resolution_Time__c = diffHours;
        }
        update casesToUpdate;
    }

    public void validateCaseResolution(List<Case> newCases, Map<Id,Case> oldCaseMap){
        for(Case cse: newCases){
            Case oldCase = oldCaseMap.get(cse.Id);
            if(cse.status == 'Closed' && oldCase.status != 'Closed' && (!cse.Is_Resolved__c || (String.isBlank(cse.Resolution_Notes__c)))){
                cse.addError('Resolution Notes are required when closing a case.');
            }
        }
    }
    
}