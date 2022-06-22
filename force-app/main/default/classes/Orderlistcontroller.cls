public with sharing class Orderlistcontroller {
     
    @AuraEnabled(cacheable=true)//Get Order Records
    public static String getOrderLists(Integer pageSize, Integer pageNumber,Id customerId){

        // System.debug('inside apex 1'+ pageSize);
        // System.debug('inside apex 2' +pageNumber);
        // System.debug('inside apex 3' + customerId);
        String jsonDT = '';

        //System.debug('inside apex 4' + jsonDT);
        //Offset for SOQL
        Integer offset = (pageNumber - 1) * pageSize;

         
        //Total Records
        Integer totalRecords = [SELECT COUNT() FROM Order__c  WHERE Customer__c = :customerId WITH SECURITY_ENFORCED];
        Integer recordEnd = pageSize * pageNumber;
         
        AccountDTWrapper objDT =  new AccountDTWrapper();  
        objDT.pageSize = pageSize;
        objDT.pageNumber = pageNumber;
        objDT.recordStart = offset + 1;
        objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        objDT.totalRecords = totalRecords;
        objDT.orders = [SELECT Name, Status__c,Order_Date__c,Expected_Delivery_Date__c,Delivered_Date__c FROM Order__c  WHERE Customer__c = :customerId WITH SECURITY_ENFORCED LIMIT :pageSize OFFSET :offset];
        jsonDT = JSON.serialize(objDT);
        System.debug('inside apex 5' + jsonDT);
        return jsonDT;
        //System.debug('inside apex 4' + JSON.serialize(objDT));
    }
     
    public class AccountDTWrapper {
        public Integer pageSize {get;set;}
        public Integer pageNumber {get;set;}
        public Integer totalRecords {get;set;}
        public Integer recordStart {get;set;}
        public Integer recordEnd {get;set;}
        public List<Order__c> orders {get;set;}
    }
}