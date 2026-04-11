public with sharing class AccountHelpe {
    
    public void getTopAccounts(){
        List<Account> topAccounts = [SELECT Id, Name FROM Account ORDER BY CreatedDate DESC LIMIT 10];
        System.debug('Top Accounts: ' + topAccounts);
    } 

}