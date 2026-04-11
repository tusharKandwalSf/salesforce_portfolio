trigger OppotunityTrigger on Opportunity (before insert,after update, after insert) {

    OpportunityTriggerHandler oppTriggerHandler = new OpportunityTriggerHandler();
    oppTriggerHandler.handleTriggerLogic();

}