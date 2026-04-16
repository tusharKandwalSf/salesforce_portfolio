public class OpportunityCleanupBatch implements Database.Batchable<SObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        Date staleDate = Date.TODAY() - 90;
        return Database.getQueryLocator([
             SELECT Id, Name FROM Opportunity 
    		 WHERE StageName IN ('Prospecting','Needs Analysis') 
    		 AND LastModifiedDate < :staleDate
        ]);
    }
    
    public void execute(Database.BatchableContext bc, List<Opportunity> scope){
        for(Opportunity opp: scope){
            opp.Is_Stale__c = true;
        }
        update scope;
    }
    
    public void finish(Database.BatchableContext bc){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    	mail.setToAddresses(new List<String>{'tusharkandwal99@gmail.com'});
	    mail.setSubject('Opportunity Cleanup Batch Completed');
	    mail.setPlainTextBody('Stale opportunities have been marked successfully.');
	    Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});
    }

}