/**
 * @description       : 
 * @author            : Mayank Singh Kandari
 * @group             : 
 * @last modified on  : 06-13-2022
 * @last modified by  : Mayank Singh Kandari
**/
public with sharing class GenericObjectFetcher {
    
    //fetch product
    @AuraEnabled(Cacheable=true)
    public static Product2 getProduct(String productId){
        Product2 tempProduct;
        try{
       		tempProduct= [Select Id, Name, Description, Offer_Available__c, Price__c, Remaining_Quantity__c, (SELECT Id, ResourceURL__c FROM Product_Images__r) from Product2 where id=:productId WITH SECURITY_ENFORCED ];
        }catch(Exception e){
            	System.debug('Error while getting Product in getProduct :'+e.getMessage());
        }
        return tempProduct;
     }

     //fetch coupons
    public static Coupon__c getCoupon(String couponId){
        Coupon__c tempCoupon;
        try{
 			tempCoupon=[Select id, Name, Flat_Discount__c, Discount__c, Type__c from Coupon__c where id=:couponId WITH SECURITY_ENFORCED];           
        }catch(Exception e){
                System.debug('Error while getting Product in getCoupon :'+e.getMessage());
        }
        return tempCoupon;
     }

     //Fetch product images
     @AuraEnabled(Cacheable=true)
    public static Product_Images__c getProductImages(String productId){
       Product_Images__c tempPI;
        try{
            tempPI= [Select id, ResourceURL__c, Product__c,Product__r.Name from Product_Images__c where Product__c=:productId WITH SECURITY_ENFORCED];
        }catch(Exception e){
                System.debug('Error while getting Product in getProductImages :'+e.getMessage());
        }
        return tempPI;
    }

    @AuraEnabled()
    public static List<Address_Book__c> getBillingAddress(String currentUserId){
        List<Address_Book__c> addressList = new List<Address_Book__c>();
        try {
                addressList = [SELECT Id, City__c, Country__c, Land_Mark__c, Postal_Code__c, State__c, Street__c, Address_Selection__c 
                                            FROM Address_Book__c 
                                            WHERE User__c =: currentUserId AND Address_Selection__c ='Billing Address'];
            	System.debug('User Id in getBillFetch method is: '+ currentUserId);
            	System.debug('Billing Address returned by fetcher class is: '+ addressList);
            }
        catch (Exception e) {
            System.debug('Error while getting Address in getAddresses :'+e.getMessage());
        }

        return addressList;

    }

    @AuraEnabled(cacheable = true)
   public static List<Product_Ratings__c> getProductRatings(String productId){
    List<Product_Ratings__c> ratingList;
    try {
        ratingList = [SELECT Id FROM Product_Ratings__c WHERE Product__c =:productId];
    } catch (Exception e) {
        System.debug('Error while getting Address in getAddresses :'+e.getMessage());
    	
    }
    return ratingList;
   }

    @AuraEnabled()
    public static List<Address_Book__c> getShippingAddress(String currentUserId){
        List<Address_Book__c> addressList = new List<Address_Book__c>();
        try {
                addressList = [SELECT Id, City__c, Country__c, Land_Mark__c, Postal_Code__c, State__c, Street__c, Address_Selection__c 
                                            FROM Address_Book__c 
                                            WHERE User__c =: currentUserId AND Address_Selection__c ='Shipping Address'];
            }
        catch (Exception e) {
            System.debug('Error while getting Address in getAddresses :'+e.getMessage());
        }

        return addressList;

    }

    @AuraEnabled(cacheable=true)
    public static List<Product2> getAllProducts(){
        List<Product2> prodList;
        try{
            prodList = [SELECT Id, Name, Description,Offer_Available__c,
                        (SELECT Id, ResourceURL__c 
                            FROM Product_Images__r 
                            WHERE ResourceURL__c != NULL)
                        FROM Product2];
            System.debug('List value is :'+prodList);
        }catch(Exception e){
            System.debug('Error while getting Product in getAllProducts :'+e.getMessage());
        }
        
        return prodList;
    }
    
    //Fetch product offers
    public static Product_Offer__c getProductOffers(String productOfferId){
        Product_Offer__c tempPO;
        try{
         	tempPO=[Select id, Product__c, Offer__c from Product_Offer__c where id=:productOfferId WITH SECURITY_ENFORCED];   
        }catch(Exception e){
                System.debug('Error while getting Product in getProductOffers :'+e.getMessage());
        }
        return tempPO;
    }

    //Fetch Product Categories
    @AuraEnabled(cacheable=true)
    public static List<Product_Category__c> getProductCategories(){
        List<Product_Category__c> tempProductCategory;
        try{
            tempProductCategory=[Select id, Category__c, Product__c, Name, Sequence__c from Product_Category__c WITH SECURITY_ENFORCED];
        }catch(Exception e){
            System.debug('Error while getting Product Category in getProductCategories :'+e.getMessage());
        }
        return tempProductCategory;
    }

    @AuraEnabled(Cacheable=true)
    public static List<Category__c> getParentCategories(){
        List<Category__c> tempCategories;
        try {
            tempCategories=[Select Name, Id from Category__c where Parent_Category__c=NULL WITH SECURITY_ENFORCED];
        } catch (Exception e) {
            System.debug('Error while getting Product Category in getCategories :'+e.getMessage());
        }
        return tempCategories;
    }

    @AuraEnabled(Cacheable=true)
    public static List<Category__c> getChildCategories(String categoryId){
        List<Category__c> tempCategories;
        try {
            tempCategories=[Select Name,Parent_Category__c, Id from Category__c where Parent_Category__c=:categoryId WITH SECURITY_ENFORCED];
        } catch (Exception e) {
            System.debug('Error while getting Product Category in getCategories :'+e.getMessage());
        }
        return tempCategories;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Product2> getProductWithCategory(String categoryId){
        List<Product2> tempProduct;
        try {
            Set<Id> pid=new Set<Id>();
            List<Product_Category__c> productCategories=
                            [Select Id, Product__c,Category__c from Product_Category__c where Category__c=:categoryId WITH SECURITY_ENFORCED ];
            for(Product_Category__c productCategory:productCategories){
                pid.add(productCategory.Product__c);
            }
            tempProduct = [Select Id, Name,Description,Offer_Available__c,(SELECT Id, ResourceURL__c FROM Product_Images__r) from Product2 where Id in :pid WITH SECURITY_ENFORCED];
            
        }
        catch (Exception ex) {
            System.debug('Error while getting Product Category in getCategories :'+ex.getMessage());

        }
        return tempProduct;
    }

}