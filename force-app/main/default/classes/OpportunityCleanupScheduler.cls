public class OpportunityCleanupScheduler implements System.Schedulable {
    
     public void execute(SchedulableContext sc){
        Database.executeBatch(new OpportunityCleanupBatch(), 200);
    }
    
    //System.schedule('Opportunity Cleanup Job', '0 0 2 * * ?', new OpportunityCleanupScheduler());

}