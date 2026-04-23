public with sharing class OpportunityTriggerHandler {

	OpportunityTriggerService service = new OpportunityTriggerService();
    
    public void afterInsert(List<Opportunity> newList) {
       service.settleCloseDate(newList);
    }
    
    public void beforeInsert(List<Opportunity> newList) {
       service.setIsMajorDeal(newList);
    }
    
   	public void afterUpdate(List<Opportunity> newOpps, Map<Id, Opportunity> oldMap) {
    	service.createFollowUpTasks(newOpps, oldMap);
	}
    
    public void beforeUpdate(List<Opportunity> newList) {
       service.setIsMajorDeal(newList);
    }
    
    public void afterDelete(List<Opportunity> oldList, Map<Id, Opportunity> oldMap) {
       service.logAudits(oldList);
    }
    public void beforeDelete(List<Opportunity> oldList) {
       service.stopOpportunityDeletion(oldList);
    }
    public void afterUndelete(List<Opportunity> newList){
        
    }

}