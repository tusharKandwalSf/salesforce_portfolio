trigger CaseTrigger on Case (before insert, before update, after update) {

    CaseTriggerHandler handler = new CaseTriggerHandler();

    handler.handleTriggerLogic();
    
}