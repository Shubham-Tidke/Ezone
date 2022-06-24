/**
 * @description       : 
 * @author            : Mayank Singh Kandari
 * @group             : 
 * @last modified on  : 06-17-2022
 * @last modified by  : Mayank Singh Kandari
**/
public with sharing class GenericRecordCreator {
    
   static Id userId = UserInfo.getUserId();
    
   static User currentUser = [SELECT Id, ContactId, AccountId FROM User WHERE Id =: userId];

    @AuraEnabled
    public static void createProductRating(Product2 product,String rate,String comment){
        try {
            
            Product_Ratings__c prod = new Product_Ratings__c();
            prod.Product__c = product.Id;
            prod.Rating__c = Integer.valueOf(rate);
            prod.Comment__c = comment;
            prod.User__c = currentUser.Id;
            insert prod;
            
        } catch (Exception e) {
            System.debug('Error in Rating '+e);
            throw e;
        }
    }
    @AuraEnabled
    public static string createCart(){
        
        List<Cart__c> cartList;
        Cart__c cart;
        List<Cart__c> checkIfCartExist;
        Id cartId = null;
        // need to update once 
        checkIfCartExist = [SELECT Id FROM Cart__c WHERE Customer__c =: currentUser.ContactId AND Status__c = 'Open'];
            try {
                if(checkIfCartExist == null || checkIfCartExist.size() == 0){
                    Integer len = 10;
                    Blob blobKey = crypto.generateAesKey(128);
                    String key = EncodingUtil.convertToHex(blobKey);
                    String cId = key.substring(0,len);
                    cartList = new List<Cart__c>();
                    cart = new Cart__c();
                    cart.Cart_Id__c = cId;
                    cart.Status__c = 'Open';
                    cart.Customer__c = currentUser.ContactId;
                    cart.Account__c = currentUser.AccountId;
                    cartList.add(cart);
                    insert cartList;
                }
                else{
                    cart = checkIfCartExist[0];
                }
                
                cartId = cart.Id;
            } catch (Exception e) {
                System.debug('Error at createCart'+e);
                throw e;
            }   
        return cartId;
        }
    

    @AuraEnabled
    public static void createCartLineItem(Product2 product, String quantityRequested){
        Cart_Item__c cartItem;
        List<Cart_Item__c> cartItemList;
        
        try {
            Id cartId = GenericRecordCreator.createCart();
            cartItemList = [SELECT Id, Quantity__c, Product__c FROM Cart_Item__c WHERE Cart_Id__c =: cartId AND Product__c =: product.Id];
            if(null != cartId){
                if( null == cartItemList || cartItemList.size() == 0){
                    cartItemList = new List<Cart_Item__c>();
                    cartItem = new Cart_Item__c();
                    cartItem.Cart_Id__c = cartId;
                    cartItem.Product__c = product.Id;
                    cartItem.Quantity__c = Integer.valueOf(quantityRequested.trim());
                    cartItem.Amount__c = product.Price__c;
                    cartItem.List_Price__c = product.Price__c;
                    cartItem.Unit_Price__c = product.Price__c;
                    cartItemList.add(cartItem);
                    insert cartItemList;
                }
                
                else{
                    for(Cart_Item__c cI : cartItemList){
                            cI.Quantity__c += Integer.valueOf(quantityRequested.trim()) ;
                    }
                    update cartItemList;
                }
                
            }
            
            
        } catch (Exception e) {
            System.debug('Error at createCartLineItem'+e);
            throw e;
        }

    }

    @AuraEnabled
    public static string createOrder(Decimal afterDiscountAmount){
        List<Order__c> orderList = new List<Order__c>();
        System.debug('User Id is : '+ currentUser.Id + ' Current Contact Id : '+ currentUSer.ContactId);
        List<Address_Book__c> userBillingAddress = GenericObjectFetcher.getBillingAddress(currentUser.Id);
        List<Address_Book__c> userShippingAddress = GenericObjectFetcher.getShippingAddress(currentUser.Id);
        System.debug('User Billing Add : '+userBillingAddress);
        System.debug('User Shipping Add : '+userShippingAddress);
        
        try {
                Order__c order = new Order__c();
                order.Customer__c = currentUser.ContactId;
                order.Account_Name__c = currentUser.AccountId;
                order.Payment_Method__c = 'COD';
                order.Status__c = 'Open';
                order.Order_Date__c = system.today();
                order.Payment_Status__c = 'COD';
                order.After_Discount_Total__c = afterDiscountAmount;
                order.Expected_Delivery_Date__c = system.today()+7;
                //shipping Address;
                if(!userBillingAddress.isEmpty()){
                    System.debug('User Billing : '+ userBillingAddress);
                    String street = String.isBlank(userBillingAddress[0].Street__c)? '' : userBillingAddress[0].Street__c  ;
                    String city = String.isBlank(userBillingAddress[0].City__c) ? '' : userBillingAddress[0].City__c;
                    String state = String.isBlank(userBillingAddress[0].State__c) ? '' : userBillingAddress[0].State__c;
                     
                    order.Billing_Address__c =  street+','+city+','+state+','+userBillingAddress[0].Postal_Code__c;
                }
                //Billing Address;
                if(userShippingAddress != null && userShippingAddress.size()>0){
                    System.debug('User Shipping : '+ userShippingAddress);
                    String street = String.isBlank(userShippingAddress[0].Street__c)? '' : userShippingAddress[0].Street__c  ;
                    String city = String.isBlank(userShippingAddress[0].City__c) ? '' : userShippingAddress[0].City__c;
                    String state = String.isBlank(userShippingAddress[0].State__c) ? '' : userShippingAddress[0].State__c;
                    
                    order.Shipping_Address__c =  street+','+city+','+state+','+userShippingAddress[0].Postal_Code__c;
                }

                orderList.add(order);
                insert orderList;
                
        } catch (Exception e) {
            System.debug('Error at createOrder'+e);
            throw e;
        }

        return orderList[0].Id;
    }

    @AuraEnabled
    public static String createOrderLineItem(List<Cart_Item__c> cartLineItems, Decimal afterDiscount){
        Id orderId = GenericRecordCreator.createOrder(afterDiscount);
        List<Order_Line_Item__c> orderItemList = new List<Order_Line_Item__c>();
        List<Cart__c> relatedCart = new List<Cart__c>();
        System.debug('Cart Line Item is : '+ cartLineItems);
        try {
            if(orderId != null){
                if(cartLineItems != null || cartLineItems.size() > 0){
                    relatedCart = [SELECT Id FROM Cart__c WHERE Id =: cartLineItems[0].Cart_Id__c];
                    Integer count = 1;
                    for(Cart_Item__c cartItem : cartLineItems){
                        Order_Line_Item__c orderItem = new Order_Line_Item__c();
                        orderItem.Name = 'OLI-'+count+'-'+cartItem.Cart_Id__r.Name ;
                        orderItem.List_Price__c = cartItem.List_Price__c;
                        orderItem.Order__c = orderId;
                        orderItem.Product__c = cartItem.Product__c;
                        orderItem.Quantity__c = cartItem.Quantity__c;
                        orderItem.List_Price__c = cartItem.List_Price__c;
                        orderItem.Unit_Price__c = cartItem.Unit_Price__c;
                        orderItemList.add(orderItem);
                        count++;
                    }

                    insert orderItemList;

                    if(relatedCart != null || relatedCart.size() > 0){
                        delete relatedCart;
                    }                
                }
            } 
        } catch (Exception e) {
            System.debug('Error at createOrderLineItem'+e);
            throw e;
        }
        
        return orderId;
    }

    @AuraEnabled
    public static Order__c  cancelOrder(String orderId){
       Order__c order ;
        try {
            order=[SELECT id, Status__c FROM Order__c WHERE id=:orderId];
            if(null!=order && (order.Status__c=='In Process' || order.Status__c=='Open' )){
                order.Status__c = 'Cancelled';
                update order; 
            }
        } catch (Exception e) {
            throw e;
        }

        return order;
    }
}