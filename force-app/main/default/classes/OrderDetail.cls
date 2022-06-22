public with sharing class OrderDetail {

    @AuraEnabled(cacheable=true)
    public static List<Order__c>  getOrderDetail(String userId) {
        Id cid = [select contactid from user where Id = :userId].contactid;
        List<Order__c> order = [SELECT Id,Name,Status__c,Total_Items__c,Shipping_Address__c,Expected_Delivery_Date__c,Payment_Status__c,Total__c
        from Order__C where Customer__c=:cid  WITH SECURITY_ENFORCED];

        return order;
    
    }

    @AuraEnabled(cacheable=true)
    public static List<Order_Line_Item__c>  getOrderItem(String itemid) {
        List<Order_Line_Item__c> orderid = [SELECT Name,Product_Name__c,Quantity__c,Unit_Price__c,Total__c, Product__r.Name, Product__r.Description from Order_Line_Item__c where Order__c=: itemid  WITH SECURITY_ENFORCED];
        return orderid;
    
    }
}