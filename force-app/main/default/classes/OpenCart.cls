public with sharing class OpenCart {

  
 
    @AuraEnabled(cacheable=true)
    public static List<Cart_Item__c> getOpenCart(String userId) {

        Id conid = [select contactid from user where Id = :userId].contactid;

        List<Cart_Item__c> cartdet =[SELECT Product__c, Total_Amount__c,Quantity__c,Unit_Price__c
  from Cart_Item__c WHERE Cart_Id__c IN 
        (SELECT ID From Cart__c where Customer__c =:conid and Status__c='OPEN') WITH SECURITY_ENFORCED];

        return cartdet;

    }

    @AuraEnabled(cacheable=true)
    public static List<Order__c>  getOpenOrders(String userId){
        try {
            Id contid = [select contactid from user where Id = :userId].contactid;
            List<Order__c> orderdetails =[SELECT Name,Total__c,Shipping_Address__c,Payment_Status__c  From Order__c where Customer__c =: contid and Status__c='OPEN' WITH SECURITY_ENFORCED];
            return orderdetails;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Order__c>  getRecentOrders(String userId){
        try {
            Id contid = [select contactid from user where Id = :userId].contactid;
            List<Order__c> recentOrderdetails =[SELECT Name,Total__c,Shipping_Address__c,Payment_Status__c  From Order__c where Customer__c =: contid and Status__c !='OPEN' WITH SECURITY_ENFORCED];
            return recentOrderdetails;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    // @AuraEnabled
    // public static List<Product_Images__c> getProductimage(){
    //     try {
            
    //         List<Product_Images__c> image= [SELECT URL__c from Product_Images__c where 	Product__c=:cartdet  WITH SECURITY_ENFORCED];

    //         return image;
            
    //     } catch (Exception e) {
    //         throw new AuraHandledException(e.getMessage());
    //     }
    // }


}