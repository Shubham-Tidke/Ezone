public with sharing class JustCartController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactId() {
        return [SELECT Id, Name FROM Contact];
    }
    @AuraEnabled
    public static List<Cart__c> getCart(String usId){
        return [Select Name,Amount__c,Quantity__c,Status__c from Cart__c where Cart_Id__c =:usId];
         
    } 
}