public class OpportunityTriggerService {
    
    
    public void settleCloseDate(List<Opportunity> newList){
     //List<Opportunity> oppList = new List<Opportunity>();
        for(Opportunity opp : newList){
            if(opp.CloseDate == null){
                opp.CloseDate = System.today();
            }
        }
    }
    
    public void createFollowUpTasks(List<Opportunity> newList, Map<Id,Opportunity> oldMap){
        List<Task> taskList = new List<Task>();
        for(Opportunity opp: newList){
            Opportunity oldOppty = oldMap.get(opp.Id);
            if(opp.StageName == 'Closed Won' && opp.StageName!=oldOppty.StageName){
                Task task = new Task();
				task.Subject = 'Follow Up';
				task.Status = 'Not Started';
				task.WhatId = opp.Id;           
				task.OwnerId = opp.OwnerId;
				task.ActivityDate = Date.TODAY()+7;
                taskList.add(task);
            }
        }
        insert taskList;
    }
    
    public void setIsMajorDeal(List<Opportunity> newList){
        for(Opportunity opp: newList){
            if(opp.Amount > 100000){
                opp.Set_is_Major_deal__c = true;
            }
        }
    }
    
    public void stopOpportunityDeletion(List<Opportunity> newList){
        for(Opportunity opp: newList){
            if(opp.StageName == 'Closed Won'){
                opp.StageName.addError('Closed Won opportunities cannot be deleted!');
            }
        }
    }
    
    public void logAudits(List<Opportunity> oldList){
        List<Audit_Log__c> logs = new List<Audit_Log__c>();
    	for(Opportunity opp : oldList){
        	logs.add(new Audit_Log__c(
            	Record_Name__c = opp.Name,
	            Deleted_By__c = UserInfo.getUserId(),
    	        Deleted_At__c = System.now()
        	));
    	}
    	insert logs;
    }

}