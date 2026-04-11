public with sharing class OpportunityTriggerHandler {


    public void handleTriggerLogic(){
        if(Trigger.isAfter && Trigger.isInsert){
            oppTriggerHandler.afterInsert(Trigger.new);
        }
    }

    public void afterInsert(List<Opportunity> newList) {
        List<Opportunity> oppList = new List<Opportunity>();
        for(Opportunity opp : newList){
            if(opp.CloseDate == null){
                opp.CloseDate = System.today();
            }
        }
    }

}