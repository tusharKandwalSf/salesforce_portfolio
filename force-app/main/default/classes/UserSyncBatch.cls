public with sharing class UserSyncBatch implements Database.Batchable<ExternalUserService.ExternalUserWrapper> , Database.AllowsCallouts {


    public List<ExternalUserService.ExternalUserWrapper> start(Database.BatchableContext bc){
        List<ExternalUserService.ExternalUserWrapper> userWrappers = ExternalUserService.fetchExternalUsers();
        return userWrappers;
    }

    public void execute(Database.BatchableContext bc, List<ExternalUserService.ExternalUserWrapper> scope){
        List<Contact> contactsToUpsert = new List<Contact>();
        for(ExternalUserService.ExternalUserWrapper wrapper : scope){
            Contact contact = new Contact();
            contact.FirstName = wrapper.name.split(' ')[0];
            contact.LastName = wrapper.name.split(' ')[1];
            contact.Email = wrapper.email;
            contact.External_Id__c = String.valueOf(wrapper.id);         
            contactsToUpsert.add(contact);
        }
        upsert contactsToUpsert Contact.External_Id__c;
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Batch Process Completed');
    }

}