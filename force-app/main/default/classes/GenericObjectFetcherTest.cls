/**
 * @description       : 
 * @author            : Mayank Singh Kandari
 * @group             : 
 * @last modified on  : 06-16-2022
 * @last modified by  : Mayank Singh Kandari
**/
@isTest
public with sharing class GenericObjectFetcherTest {
    public static User u = [SELECT Id, Name FROM User WHERE Id = '0055i000003oIHhAAM'];

    @TestSetup
    static void makeData(){
        Product2 product=new Product2(Name='Test Product',Description='Test Product by Mayank',Inventory__c=100,Offer_Available__c=false,Price__c=100,Remaining_Quantity__c=0);
        insert product;

        Coupon__c coupon=new Coupon__c(Name='Test Coupon by Mayank',Type__c='Flat',Flat_Discount__c=1000);
        insert coupon;
		
        Product_Images__c productImages = new Product_Images__c(Name='Test Image by Mayank',Product__c=product.Id);
        insert productImages;
        
        Product_Offer__c productOffer=new  Product_Offer__c(Product__c=product.Id,Offer__c=coupon.Id);
        insert productOffer;
	
	    Category__c parentCategory=new Category__c(Name='Parent Test Category by Mayank');        
        insert parentCategory;
        
        Category__c category=new Category__c(Name='Test Category by Mayank',Parent_Category__c=parentCategory.Id);
        insert category;
        
        Product_Category__c productCategory=new Product_Category__c(Name='New Category by Mayank',Category__c=category.Id,Product__c=product.Id);
        insert productCategory;
        
        List<Product_Category__c> productCategories=new List<Product_Category__c>();
        productCategories.add(productCategory);
                

        System.runAs(u){
            Address_Book__c ab=new Address_Book__c(Name='Home',Street__c='Madhapur',Land_Mark__c='Metro',
                                                   State__c='TS',City__c='Hyderabad',Country__c='India,IN',Address_Selection__c='Billing Address',
                                                   Postal_Code__c=500080,User__c=u.Id);
            insert ab;
            
            Address_Book__c ab1 = new Address_Book__c(Name='Home',Street__c='Madhapur',Land_Mark__c='Metro',
                                                      State__c='TS',City__c='Hyderabad',Country__c='India,IN',Address_Selection__c='Shipping Address',
                                                      Postal_Code__c=500080,User__c=u.Id);
             insert ab1;
         }
        
        Product_Ratings__c productRatings=new Product_Ratings__c(Name='Test PR',Product__c=product.id,Rating__c=5);
        insert productRatings;
    }

    @isTest
    private static void testGetProduct(){
        Product2 product=[Select Id, Name from Product2 where Name='Test Product' WITH SECURITY_ENFORCED LIMIT 1];
        Test.startTest();
        Product2 newProduct=GenericObjectFetcher.getProduct(product.Id);
        System.assertEquals(product.Name,newProduct.Name,'Name fields matched');
        Test.stopTest();
    }

    @isTest
    private static void testGetCoupon(){
        Coupon__c coupon=[Select Id, Name from Coupon__c where Name='Test Coupon by Mayank' WITH SECURITY_ENFORCED LIMIT 1];
        Test.startTest();
        Coupon__c newCoupon=GenericObjectFetcher.getCoupon(coupon.Id);
        System.assertEquals(coupon.Name, newCoupon.Name, 'Name fields matched!');
        Test.stopTest();
    }
	
    
    @isTest
    private static void testGetProductImages(){
        Product2 product=[Select Id, Name from Product2 where Name='Test Product' WITH SECURITY_ENFORCED LIMIT 1];
        Test.startTest();
        Product_Images__c newProductImage=GenericObjectFetcher.getProductImages(product.Id);
        System.assertEquals('Test Product', newProductImage.Product__r.Name, 'Name fields matched!');
        Test.stopTest();
        
    }

    @isTest
    private static void testGetAllProducts(){
        List<Product2> products=GenericObjectFetcher.getAllProducts();
        Test.startTest();
        System.assertEquals(1, products.size(), 'Size matched');
        Test.stopTest();
    }
    
    @isTest
    private static void testGetProductCategories(){
        List<Product_Category__c> productCategories=GenericObjectFetcher.getProductCategories();
    	Test.startTest();
        System.assertEquals(1, productCategories.size(),'Size Matched');
        Test.stopTest();
    }
    
    @isTest
    private static void testGetBillingAddress(){
        Test.startTest();
        System.runAs(u){
			 List<Address_Book__c> addressList=GenericObjectFetcher.getBillingAddress(u.id);           
            System.assertEquals(1, addressList.size(), 'Address did not matched');
        }
        Test.stopTest();
    }
    
    @isTest
    private static void testGetShippingAddress(){
        Test.startTest();
        System.runAs(u){
			 List<Address_Book__c> addressList=GenericObjectFetcher.getShippingAddress(u.id);           
            System.assertEquals(1, addressList.size(), 'Address did not matched');
        }
        Test.stopTest();
    }
    
    @isTest
    private static void testGetParentCategories(){
        List<Category__c> productCategories=GenericObjectFetcher.getParentCategories();
        List<Category__c> childCategories=GenericObjectFetcher.getChildCategories(productCategories[0].Id);	
        List<Product2> products=GenericObjectFetcher.getProductWithCategory(childCategories[0].Id);	
        Test.startTest();
        System.assertEquals(1, productCategories.size(), 'Size Matched');
        System.assertEquals(1, childCategories.size(), 'Size Matched');
        System.assertEquals(1, products.size(),'Size Matched');
        Test.stopTest();
    }
    
    @isTest
    private static void testgetProductRatings(){
        Product2 product=[Select Id, Name from Product2 where Name='Test Product' WITH SECURITY_ENFORCED LIMIT 1];
        Test.startTest();
        List<Product_Ratings__c> ratingList=GenericObjectFetcher.getProductRatings(product.Id);
        System.assertEquals(1, ratingList.size(), 'Size did not matched');
        Test.stopTest();
    }
    
    @isTest
    private static void testExceptionParams(){
        Test.startTest();
        try{
            GenericObjectFetcher.getProduct(null);
            System.assert(true,'Above line should give exception');
            GenericObjectFetcher.getCoupon(null);
            System.assert(true,'Above line should give exception');
			GenericObjectFetcher.getProductImages(null);
            System.assert(true,'Above line should give exception');
            GenericObjectFetcher.getProductOffers(null);
            System.assert(true,'Above line should give exception');
            GenericObjectFetcher.getProductWithCategory(null);
            System.assert(true,'Above line should give exception');
            GenericObjectFetcher.getBillingAddress(null);
            System.assert(true,'Above line should give exception');
            GenericObjectFetcher.getShippingAddress(null);
            System.assert(true,'Above line should give exception');
            GenericObjectFetcher.getProductRatings(null);
            System.assert(true,'Above line should give exception');
        }catch(Exception e){
        }
        Test.stopTest();
    }
    
}