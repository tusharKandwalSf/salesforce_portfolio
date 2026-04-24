public with sharing class CaseEscalationScheduler implements Schedulable {

    public void execute(SchedulableContext context) {
        System.enqueueJob(new CaseEscalationQueueable());
    }
    
    // System.schedule('Case Escalation Job', '0 0 * * * ?', new CaseEscalationScheduler());

}