trigger OppotunityTrigger on Opportunity (before insert,after update, after insert,before update,before delete, after delete, after undelete) {
	
    OpportunityTriggerHandler oppTriggerHandler = new OpportunityTriggerHandler();
    
    switch on Trigger.operationType{
        when BEFORE_INSERT {
            oppTriggerHandler.beforeInsert(Trigger.new);
        }
        when AFTER_INSERT {
        	oppTriggerHandler.afterInsert(Trigger.new);
    	}
    	when BEFORE_UPDATE {
        	oppTriggerHandler.beforeUpdate(Trigger.new);
    	}
    	when AFTER_UPDATE {
        	oppTriggerHandler.afterUpdate(Trigger.new,Trigger.oldMap);
    	}
        when BEFORE_DELETE {
        	oppTriggerHandler.beforeDelete(Trigger.old);
    	}
        when AFTER_DELETE {
        	oppTriggerHandler.afterDelete(Trigger.old,Trigger.oldMap);
    	}
        when AFTER_UNDELETE {
        	oppTriggerHandler.afterUndelete(Trigger.new);
    	}
    }
        
    /*OpportunityTriggerHandler oppTriggerHandler = new OpportunityTriggerHandler();
    oppTriggerHandler.handleTriggerLogic();*/

}