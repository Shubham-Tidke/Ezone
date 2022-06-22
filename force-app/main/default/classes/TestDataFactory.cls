public with sharing class TestDataFactory {

    public static List<Account> createAccount(String name, Integer size, Boolean isInsert){
        List<Account> accList = new List<Account>();

        for(Integer i=0; i< size; i++){
            Account acc = new Account();
            acc.Name = name;
            acc.AccountSource = 'Web';
            accList.add(acc);
        }

        if(isInsert){
            insert accList;
        }

        return accList;
    }
    
    public static void linkParentChidAccount(Account childAccount, Account parentAcount){
        childAccount.ParentId=parentAcount.Id;
        update childAccount;
    }

    public static List<Contact> createContact(String firstName, String lastName, String accountId, Integer size, Boolean isInsert){
        List<Contact> conList = new List<Contact>();

        for(Integer i=0; i< size; i++){
            Contact con = new Contact();
            con.FirstName = firstName;
            con.LastName = lastName;
            con.AccountId = accountId;
            conList.add(con);
        }

        if(isInsert){
            insert conList;
        }

        return conList;
    }

    public static List<Product2> createProduct(String prodName, Integer inventory, Integer remainingQty, Decimal price, Integer size, Boolean isInsert){
        List<Product2> prodList = new List<Product2>();

        for(Integer i=0; i<size; i++){
            Product2 prod = new Product2();
            prod.Name = prodName;
            prod.Inventory__c = inventory;
            prod.Remaining_Quantity__c = remainingQty;
            prod.Price__c = price;
            prodList.add(prod);
        }

        if(isInsert){
            insert prodList;
        }

        return prodList;
    }

    public static Cart__c createCart(String customerId, Id accountId, Boolean isInsert){
            Cart__c cart = new Cart__c();
            cart.Customer__c = customerId;
            cart.Account__c = accountId;
            cart.Status__c = 'Open';
            
            
            if(isInsert){
                insert cart;
            }
        return cart;
    }

    public static List<Cart_Item__c> createCartLineItem(String cartId, String productId, Integer size, Boolean isInsert){
        List<Cart_Item__c> cartItemList = new List<Cart_Item__c>();

        for (Integer i = 0; i < size; i++) {
            Cart_Item__c cartItem = new Cart_Item__c();
            cartItem.Cart_Id__c = cartId;
            cartItem.Quantity__c = 1;
            cartItem.Product__c = productId;
            cartItem.Unit_Price__c = 100;
            cartItem.List_Price__c = 100;
            cartItem.Amount__c = 100;
            cartItemList.add(cartItem);
        }

        if(isInsert){
            insert cartItemList;
        }
        return cartItemList;
    }

    public static Order__c createOrder(String cusotmerId, String accountId, Boolean isInsert){
        Order__c order = new Order__c();
        order.Account_Name__c = accountId;
        order.Customer__c = cusotmerId;
        order.Order_Date__c = system.today();
        order.Expected_Delivery_Date__c = system.today()+7;
        order.Payment_Method__c = 'COD';
        order.Status__c = 'Open';
        order.Shipping_Address__c = 'Test Shipping Addr';
        order.Billing_Address__c = 'Test Billing Addr';

        if(isInsert){
            insert order;
        }

        return order;
    }


    public static List<Order_Line_Item__c> createOrderLineItem(String orderId, String productId, Integer size, Boolean isInsert){
        List<Order_Line_Item__c> orderLineList = new List<Order_Line_Item__c>();

        for (Integer i = 0; i < size; i++) {
            Order_Line_Item__c orderItem = new Order_Line_Item__c();
            orderItem.Name = 'OLI-000'+i;
            orderItem.Order__c = orderId;
            orderItem.Product__c = productId;
            orderItem.Quantity__c = 1;
            orderItem.Unit_Price__c = 100;
            orderItem.List_Price__c = 100;
            orderLineList.add(orderItem);
        }

        if(isInsert){
            insert orderLineList;
        }

        return orderLineList;
    }

    public static Product_Ratings__c createProductRating(String productId, Boolean isInsert, String userId){
        Product_Ratings__c prodRating = new Product_Ratings__c();
        prodRating.Name = 'Test Rating';
        prodRating.Product__c = productId;
        prodRating.Rating__c = 4;
        prodRating.Comment__c = 'Test Data Factory Comment';
        prodRating.User__c = userId;

        if(isInsert){
            insert prodRating;
        }

        return prodRating;
    }

}