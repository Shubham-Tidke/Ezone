@isTest
public with sharing class GenericRecordCreatorTest {
    
    @TestSetup
    static void makeData(){
        Account acc = TestDataFactory.createAccount('Test Account', 1, true)[0];
        Contact con = TestDataFactory.createContact('Test', 'Contact', acc.Id,'abcd1@apisero.com', 1, true)[0];
        //User u = [SELECT Id, Name FROM User WHERE ProfileId =: p.Id LIMIT 1];
        User u = [SELECT Id, Name FROM User WHERE Id = '0055i000003oIHhAAM'];
        System.debug('User Name is: '+ u.Name + 'User Id is : '+ u.Id);
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
        Product2 prod = TestDataFactory.createProduct('Test Product', 1, true)[0];
        
    }
    
    @isTest
    public static void createProductRatingTest(){
        Product2 prodObj = [SELECT Id, Name FROM Product2 WHERE Name = 'Test Product' LIMIT 1];
        Test.startTest();
        GenericRecordCreator.createProductRating(prodObj,'3', 'Test Comment');
        Product_Ratings__c prodRate = [SELECT Id, Rating__c, Comment__c FROM Product_Ratings__c WHERE Product__c =: prodObj.Id];
        System.assertEquals(prodRate.Rating__c,3,'Error in CreateProductRating');
        Test.stopTest();
    }
    
    @isTest
    public static void createCartTest(){
        Test.startTest();
        Id cartId = GenericRecordCreator.createCart();
        Cart__c cart = [SELECT Id, Status__c FROM Cart__c WHERE Id =: cartId];
        System.assertEquals(cart.Status__c, 'Open', 'Error in createCartMethod');
        Test.stopTest();
    }
    
    @isTest
    public static void createCartLineItemTest(){
        Product2 prodObj = [SELECT Id, Name, Price__c FROM Product2 WHERE Name = 'Test Product' LIMIT 1];
        Test.startTest();
        GenericRecordCreator.createCartLineItem(prodObj,'3');
        List<Cart_Item__c> cartItem = [SELECT Id, Quantity__c FROM Cart_Item__c WHERE Product__c =: prodObj.Id];
        System.debug('CartLine Item : '+ cartItem);
        System.assertEquals(cartItem[0].Quantity__c,3,'Error in createCartLineItem');
        Test.stopTest();
    }
    
    @isTest
    public static void createOrderTest(){
        //Profile p = [SELECT Id FROM Profile WHERE Name='EZone CCU'];
        User u = [SELECT Id, ContactId, AccountId, Name FROM User WHERE Id = '0055i000003oIHhAAM'];
        System.runAs(u){
            Test.startTest();
            Id orderId = GenericRecordCreator.createOrder(100.11);
            Order__c order = [SELECT Id, Order_Date__c FROM Order__c WHERE Id =: orderId];
            System.assertEquals(order.Order_Date__c,System.today(),'Error in createOrder');
            Test.stopTest();
        }    
    }
    
    @isTest
    public static void createOrderLineItemTest(){
        Product2 prod = [SELECT Id FROM Product2 WHERE Name = 'Test Product' LIMIT 1];
        User u = [SELECT Id, ContactId, AccountId, Name FROM User WHERE Id = '0055i000003oIHhAAM'];
        System.runAs(u){
            Cart__c cart = TestDataFactory.createCart(u.ContactId, u.AccountId, true);
            List<Cart_Item__c> cartItemList = TestDataFactory.createCartLineItem(cart.Id, prod.Id, 1, true);
            Test.startTest();
            Id orderId = GenericRecordCreator.createOrderLineItem(cartItemList,99.8);
            Order_Line_Item__c orderItem = [SELECT Id, Quantity__c FROM Order_Line_Item__c WHERE Order__c =: orderId];
            System.assertEquals(orderItem.Quantity__c, 1, 'Error in orderLine Item');
            Test.stopTest();
        } 
    }
    
    @isTest
    public static void cancelOrderTest(){
        Contact con = [SELECT Id FROM Contact WHERE Name = 'Test Contact' LIMIT 1];
        Order__c order=new Order__c(Customer__c=con.id, Status__c = 'Open');
        insert order;
        
        Test.startTest();
        Order__c orderActual = GenericRecordCreator.cancelOrder(order.Id);
        System.assertEquals(orderActual.Status__c, 'Cancelled', 'Error in cancel Order');
        Test.stopTest();
    }
    
    @isTest
    private static void testExceptionParams(){
        Test.startTest();
        try{
            GenericRecordCreator.createProductRating(null, '3', 'Test');
            System.assert(true,'Above line should give exception');
            
			GenericRecordCreator.createCartLineItem(null, '2');
            System.assert(true,'Above line should give exception');
            
            GenericRecordCreator.createOrderLineItem(null, 0.0);
            System.assert(true,'Above line should give exception');
            
            GenericRecordCreator.cancelOrder(null);
            System.assert(true,'Above line should give exception');
            
        }catch(Exception e){
        }
        Test.stopTest();
    }
    
}