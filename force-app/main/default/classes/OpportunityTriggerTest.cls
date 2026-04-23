@isTest
private class OpportunityTriggerTest {  

    @isTest
    static void testAfterInsert() {
        Opportunity opp = new Opportunity(Name = 'Test Opportunity', StageName = 'Prospecting', Amount = 1000, CloseDate = Date.TODAY()); 
        insert opp;
        Opportunity insertedOpp = [SELECT Id, Name, CloseDate FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(System.today(), insertedOpp.CloseDate, 'CloseDate should be set to today\'s date');
    }
    
    @isTest
    static void testBeforeInsert(){
        Opportunity opp = new Opportunity(Name = 'Test Opportunity', StageName = 'Prospecting', Amount = 1000001, CloseDate = Date.TODAY()); 
        Test.startTest();
        insert opp;
        Opportunity insertedOpp = [SELECT Id, Name,Amount, CloseDate,Set_is_Major_deal__c FROM Opportunity WHERE Id = :opp.Id];
        Test.stopTest();
        System.assertEquals(insertedOpp.Set_is_Major_deal__c, true);
    }

    @isTest
    static void testBeforeUpdate(){
        
    }

    @isTest
    static void testBeforeDelete(){
        Opportunity opp = new Opportunity(Name = 'Test Opportunity', StageName = 'Closed Won', Amount = 1000001, CloseDate = Date.TODAY()); 
        insert opp;
        Opportunity inserted = [SELECT StageName FROM Opportunity WHERE Id = :opp.Id];
		System.debug('Inserted Stage name:'+ inserted.StageName);
        Test.startTest();
        //insert opp;
        try {
    		delete opp;
		    //System.assert(false, 'Exception expected');
		} catch(Exception e) {		
	    	System.debug(e.getMessage());
		    System.assert(e.getMessage().contains('Closed Won'));
		}
        Test.stopTest();
    }
    @isTest
    static void testAfterDelete(){
        Opportunity opp = new Opportunity(Name = 'Test Opportunity', StageName = 'Prospecting', Amount = 1000001, CloseDate = Date.TODAY()); 
        Test.startTest();
        insert opp;
        Delete opp;
        List<Audit_Log__c> logs = [Select id from Audit_Log__c where Record_Name__c = :opp.Name limit 1];        
        Test.stopTest();
        System.assertEquals(1,logs.size());
    }
    @isTest
    static void testAfterUpdate(){
        Opportunity opp = new Opportunity(Name = 'Test Opportunity', StageName = 'Prospecting', Amount = 1000001, CloseDate = Date.TODAY()); 
        Test.startTest();
        insert opp;
        opp.StageName = 'Closed Won';
        update opp;
        List<Task> tList = [Select id from Task where whatId = :opp.Id];
		Test.stopTest();
        System.assertEquals(1,tList.size());
    }
    @isTest
    static void testAfterUndelete(){
        Opportunity opp = new Opportunity(Name = 'Test Opportunity', StageName = 'Prospecting', Amount = 1000001, CloseDate = Date.TODAY()); 
        Test.startTest();
        insert opp;
        Delete opp;
        Test.stopTest();
        List<Audit_Log__c> logs = [Select id from Audit_Log__c where Record_Name__c = :opp.Name limit 1];                
        System.assertEquals(1,logs.size());
        Undelete opp;
        try{
        	logs = [Select id from Audit_Log__c where Record_Name__c = :opp.Name limit 1];
        }catch(Exception e){
            system.debug(e.getMessage());
        }
    }

}