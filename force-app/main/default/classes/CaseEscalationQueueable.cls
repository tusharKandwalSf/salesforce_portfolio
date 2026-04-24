public with sharing class CaseEscalationQueueable implements Queueable{

    public void execute(QueueableContext context) {
        List<Case> casesToEscalate;
        if (Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isUpdateable()) {
            casesToEscalate = [Select id,OwnerId, Priority, Status from Case where createdDate <= :System.now().addHours(-24) and Status != 'Closed'];
        }        
        Id tier2QueueId = [SELECT Id FROM Group WHERE Name = 'Tier 2 Support' AND Type = 'Queue' LIMIT 1].Id;
        if(casesToEscalate == null || casesToEscalate.isEmpty()){
            return;
        }
        for(Case cse : casesToEscalate){
            cse.Priority = 'Critical';
            cse.OwnerId = tier2QueueId;
        }
        update casesToEscalate;

        if(!Test.isRunningTest()){
            System.enqueueJob(new CaseEscalationQueueable());
        }
    }
}