public with sharing class CaseTriggerHandler {

    CaseTriggerService caseTriggerService = new CaseTriggerService();

    public void handleTriggerLogic(){
        switch on Trigger.OperationType{
            when BEFORE_INSERT{
                handleBeforeInsert(Trigger.new);
            }
            when BEFORE_UPDATE{
                handleBeforeUpdate(Trigger.new, (Map<Id,Case>)Trigger.oldMap);
            }
            when AFTER_UPDATE{
                handleAfterUpdate(Trigger.new, (Map<Id,Case>)Trigger.oldMap);
            }  
        }
    }


    private void handleBeforeInsert(List<Case> newCases){
        caseTriggerService.autoAssignQueue(newCases);
    }

    private void handleBeforeUpdate(List<Case> newCases, Map<Id,Case> oldCaseMap){
        caseTriggerService.validateCaseResolution(newCases, oldCaseMap);
    }

    private void handleAfterUpdate(List<Case> newCases, Map<Id,Case> oldCaseMap){
        caseTriggerService.validateStatusChange(newCases, oldCaseMap);
    }

}