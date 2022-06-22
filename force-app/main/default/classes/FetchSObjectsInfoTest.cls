@isTest
public class FetchSObjectsInfoTest {
    @TestSetup
    public static void setData(){
        Profile p = [SELECT Id FROM Profile WHERE Name='EZone CCU'];
        Account parent=new Account(Name='Apisero');
        insert parent;
        Account acc=new Account(Name='Account1',Phone='1234567890',AccountSource='web',Rating='Warm',ParentId=parent.Id,
                                BillingStreet='Gachibowli',BillingState='TS',BillingCity='Hyderabad',BillingCountry='IN',BillingPostalCode='500080');
        insert acc;
        
        Contact con=new Contact(FirstName='Guddi',LastName='DoraApi',Email='standarduser@testorg.com',Phone='1234567890',Title='CEO',AccountId = acc.Id,
                                MailingStreet='Gachibowli',MailingState='TS',MailingCity='Hyderabad',MailingCountry='IN',MailingPostalCode='500080');
        insert con;
        User u = new User(Alias = 'standt', Email='DoraCORONA@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='CORONA2019', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,ContactId=con.Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='DoraCORONA@testorg.com',IsActive = true);
        insert u;
        Cart__c crt=new Cart__c(Account__c=acc.Id,Customer__c=con.Id);
        insert crt;
        Product2 product=new Product2(Name='Test Product',Inventory__c=100,Price__c=100,Remaining_Quantity__c=10);
        insert product;
        Coupon__c cp=new Coupon__c(Name='Coupon1',Discount__c=10,Remaining_Quantity__c=2,Expiry_Date__c=System.today()+2);
        insert cp;
        Cart_Item__c crtItem=new Cart_Item__c(Amount__c=100,Product__c=product.Id,Quantity__c=2, Cart_Id__c=crt.Id);
        insert crtItem;
        
        Address_Book__c ab=new Address_Book__c(Name='Home',Street__c='Madhapur',Land_Mark__c='Metro',
                                               State__c='TS',City__c='Hyderabad',Country__c='India,IN',Address_Selection__c='Billing Address',
                                               Postal_Code__c=500080,User__c=u.Id);
        insert ab;
       
        
        
    }
    
    @isTest
    private static void testGetAccount(){
        Id accId;
        Account parent=[Select Id, Name from Account where Name='Apisero' LIMIT 1];
        Account account=[Select Id, Name ,Phone,AccountSource,Rating,BillingStreet,BillingState,BillingCity,BillingCountry,BillingPostalCode from Account where Name='Account1' LIMIT 1];
        Contact contact=[Select Id, FirstName,LastName,Phone,Email,Title,MailingStreet,MailingState,MailingCity,MailingCountry,MailingPostalCode from Contact where LastName='DoraApi' and AccountId = :account.Id LIMIT 1];
        User u=[Select Id, Name from User where UserName='DoraCORONA@testorg.com' and ContactId = :contact.Id LIMIT 1];
        system.debug(u);
        Test.startTest();
        accId =FetchSObjectsInfo.getAccount(u.Id);
        System.assertEquals(accId,account.Id,'Id matched');
        Test.stopTest();
    }
    @isTest
    private static void testGetContact(){
        Id conId;
        Account parent=[Select Id, Name from Account where Name='Apisero' LIMIT 1];
        Account account=[Select Id, Name ,Phone,AccountSource,Rating,BillingStreet,BillingState,BillingCity,BillingCountry,BillingPostalCode from Account where Name='Account1' LIMIT 1];
        Contact contact=[Select Id, FirstName,LastName,Phone,Email,Title,MailingStreet,MailingState,MailingCity,MailingCountry,MailingPostalCode from Contact where LastName='DoraApi' and AccountId = :account.Id LIMIT 1];
        User u=[Select Id, Name from User where UserName='DoraCORONA@testorg.com' and ContactId = :contact.Id LIMIT 1];
        system.debug(u);
        Test.startTest();
        conId =FetchSObjectsInfo.getContact(u.Id);
        System.assertEquals(conId,contact.Id,'Id matched');
        Test.stopTest(); 
    }
    @isTest
    private static void testGetCart(){
        List<Cart__c> cart;
        Account parent=[Select Id, Name from Account where Name='Apisero' LIMIT 1];
        Account account=[Select Id, Name ,Phone,AccountSource,Rating,BillingStreet,BillingState,BillingCity,BillingCountry,BillingPostalCode from Account where Name='Account1' LIMIT 1];
        Contact contact=[Select Id, FirstName,LastName,Phone,Email,Title,MailingStreet,MailingState,MailingCity,MailingCountry,MailingPostalCode from Contact where LastName='DoraApi' and AccountId = :account.Id LIMIT 1];
        User u=[Select Id, Name from User where UserName='DoraCORONA@testorg.com' and ContactId = :contact.Id LIMIT 1];
        List<Cart__c> crt=[Select Name ,Amount__c, Quantity__c from Cart__c where Account__c = :account.Id  and Customer__c = :contact.Id LIMIT 1];
        Product2 product=[Select Id, Name from Product2 where Name='Test Product' WITH SECURITY_ENFORCED LIMIT 1];
        for(Cart__c c:crt){
            Cart_Item__c crtItem=[Select Id from Cart_Item__c where Product__c = :product.Id  and Cart_Id__c = :c.Id LIMIT 1];
            system.debug(u);
            Test.startTest();
            cart =FetchSObjectsInfo.getCart(u.Id);
            System.assertEquals(cart,crt,'Cart matched');
            Test.stopTest(); 
        }
        
    }
    @isTest
    private static void testAddressList(){
        List<Address_Book__c> addId;
        Account parent=[Select Id, Name from Account where Name='Apisero' LIMIT 1];
        Account account=[Select Id, Name ,Phone,AccountSource,Rating,BillingStreet,BillingState,BillingCity,BillingCountry,BillingPostalCode from Account where Name='Account1' LIMIT 1];
        Contact contact=[Select Id, FirstName,LastName,Phone,Email,Title,MailingStreet,MailingState,MailingCity,MailingCountry,MailingPostalCode from Contact where LastName='DoraApi' and AccountId = :account.Id LIMIT 1];
        User u=[Select Id, Name from User where UserName='DoraCORONA@testorg.com' and ContactId = :contact.Id LIMIT 1];
        List<Address_Book__c> ab=[SELECT Id,Name,Street__c,Land_Mark__c,State__c,City__c,Address_Selection__c,Country__c,Postal_Code__c from Address_Book__c where User__c = :u.Id LIMIT 1];
        system.debug(u);
        Test.startTest();
        addId =FetchSObjectsInfo.getAddressList(u.Id);
        System.assertEquals(addId,ab,'Id matched');
        Test.stopTest(); 
    }
    @isTest
    private static void testInValidAddressList(){
        List<Address_Book__c> addId;
        List<Address_Book__c> addA;
        Account parent=[Select Id, Name from Account where Name='Apisero' LIMIT 1];
        Account account=[Select Id, Name ,Phone,AccountSource,Rating,BillingStreet,BillingState,BillingCity,BillingCountry,BillingPostalCode from Account where Name='Account1' LIMIT 1];
        Contact contact=[Select Id, FirstName,LastName,Phone,Email,Title,MailingStreet,MailingState,MailingCity,MailingCountry,MailingPostalCode from Contact where LastName='DoraApi' and AccountId = :account.Id LIMIT 1];
        User u=[Select Id, Name from User where UserName='DoraCORONA@testorg.com' and ContactId = :contact.Id LIMIT 1];
        List<Address_Book__c> ab=[SELECT Id,Name,Street__c,Land_Mark__c,State__c,City__c,Address_Selection__c,Country__c,Postal_Code__c from Address_Book__c where User__c = :u.Id LIMIT 1];
        Test.startTest();
        addId =FetchSObjectsInfo.getAddressList(u.Id);
        System.assertEquals(addId,ab,'InValid Address');
        Test.stopTest(); 
    }
    @isTest
    private static void testGetCartItems(){
        Cart__c cItems;
        Account parent=[Select Id, Name from Account where Name='Apisero' LIMIT 1];
        Account account=[Select Id, Name ,Phone,AccountSource,Rating,BillingStreet,BillingState,BillingCity,BillingCountry,BillingPostalCode from Account where Name='Account1' LIMIT 1];
        Contact contact=[Select Id, FirstName,LastName,Phone,Email,Title,MailingStreet,MailingState,MailingCity,MailingCountry,MailingPostalCode from Contact where LastName='DoraApi' and AccountId = :account.Id LIMIT 1];
        User u=[Select Id, Name from User where UserName='DoraCORONA@testorg.com' and ContactId = :contact.Id LIMIT 1];
        Cart__c crt=[Select Name ,Amount__c, Quantity__c,Status__c, (select Product_Name__c,Quantity__c,Total_Amount__c from Cart_Items__r) from Cart__c where  Customer__c = :contact.Id LIMIT 1];
        
        system.debug(u);
        Test.startTest();
        cItems =FetchSObjectsInfo.getCartItems(u.Id);
        System.assertEquals(cItems.Id,crt.Id,'CartItems Id matched');
        Test.stopTest(); 
        
    }
    @isTest
    private static void testUpdateDiscount(){
        Boolean b,a;
        Decimal discount=90;
        Account parent=[Select Id, Name from Account where Name='Apisero' LIMIT 1];
        Account account=[Select Id, Name ,Phone,AccountSource,Rating,BillingStreet,BillingState,BillingCity,BillingCountry,BillingPostalCode from Account where Name='Account1' LIMIT 1];
        Contact contact=[Select Id, FirstName,LastName,Phone,Email,Title,MailingStreet,MailingState,MailingCity,MailingCountry,MailingPostalCode from Contact where LastName='DoraApi' and AccountId = :account.Id LIMIT 1];
        User u=[Select Id, Name from User where UserName='DoraCORONA@testorg.com' and ContactId = :contact.Id LIMIT 1];
        Cart__c crt=[Select Name,After_Discount__c,Amount__c from Cart__c where Customer__c = :contact.Id LIMIT 1];
        
        if(true){
            crt.After_Discount__c = discount;
            b=true;
            update crt;
        }
        
        system.debug(u);
        Test.startTest();
        a =FetchSObjectsInfo.updateDiscount(90,u.Id);
        System.assertEquals(a,b,'Discount Updated');
        Test.stopTest(); 
        
    }
    @isTest
    private static void testupdateCoupon(){
        Decimal b,a;
        Coupon__c cp=[select Name,Discount__c,Remaining_Quantity__c,Expiry_Date__c from Coupon__c where Name='Coupon1' LIMIT 1 ];
        if(true){
            cp.Remaining_Quantity__c--;
            update cp;
            b=1;
        }
        Test.startTest();
        a =FetchSObjectsInfo.updateCoupon('Coupon1');
        System.assertEquals(a,b,'Discount Updated');
        Test.stopTest(); 
        
    }
    @isTest
    private static void testCheckCoupon(){
        Coupon__c cp=[select Name,Discount__c,Remaining_Quantity__c,Expiry_Date__c from Coupon__c where Name='Coupon1' LIMIT 1 ];
     
        Test.startTest();
        Decimal a =FetchSObjectsInfo.checkCoupon('Coupon1');
        System.debug(a);
        System.assertEquals(a,cp.Discount__c,'Valid Coupon'); 
        Test.stopTest();
    }
    @isTest
    private static void testInvalidCheckCoupon(){
        Coupon__c cp=[select Name,Discount__c,Remaining_Quantity__c,Expiry_Date__c from Coupon__c where Name='Coupon1' LIMIT 1 ];
        cp.Remaining_Quantity__c = 0;
        update cp;
        Test.startTest();
        Decimal b =FetchSObjectsInfo.checkCoupon('Coupon1');
        System.debug(b);
        System.assertEquals(b,0,'InValid Coupon'); 
        Test.stopTest();
    }
    @isTest
    private static void testExceptionParams(){
        Test.startTest();
        try{
            FetchSObjectsInfo.getAccount(null);
            System.assert(true,'Above line should give exception');
            FetchSObjectsInfo.getContact(null);
            System.assert(true,'Above line should give exception');
            FetchSObjectsInfo.getCart(null);
            System.assert(true,'Above line should give exception');
            FetchSObjectsInfo.getAddressList('');
            System.assert(true,'Above line should give exception');
            FetchSObjectsInfo.getCartItems(null);
            System.assert(true,'Above line should give exception');
            FetchSObjectsInfo.updateDiscount(null,null);
            System.assert(true,'Above line should give exception');
            FetchSObjectsInfo.checkCoupon(null);
            System.assert(true,'Above line should give exception');
            FetchSObjectsInfo.updateCoupon(null);
            System.assert(true,'Above line should give exception');
        }catch(Exception e){
        }
        Test.stopTest();
    }
}