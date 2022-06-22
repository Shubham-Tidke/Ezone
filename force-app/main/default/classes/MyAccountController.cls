public with sharing class MyAccountController {
    @AuraEnabled(cacheable=true)
    public static Account getAccountDetails(String accountId){
        Account accountDetails = [Select id, name FROM Account WHERE id=:accountId];
        return accountDetails;
    }
}