public with sharing class FetchSObjectsInfo {
//Fetch Account Details
    @AuraEnabled(cacheable=true)
    public static Id getAccount(String rId){
        Id accid; 
        try{
            accid = [select accountid from user where Id = :rId].accountid;
            System.debug(accid);
        }
        catch(Exception e){
            System.debug('Error while getting Account Details in getAccount :'+e.getMessage());
        }
        return accid;
    }
    //Fetch Contact Details
    @AuraEnabled(cacheable=true)
    public static Id getContact(String rId){
        Id conid;
        try{
        conid = [select contactid from user where Id = :rId].contactid;
        System.debug(conid);
        }
        catch(Exception e){
            System.debug('Error while getting Contact Details in getContact :'+e.getMessage());
        }
        return conid;
    }
    //Fetch Cart Details
    @AuraEnabled(cacheable=true)
    public static List<Cart__c> getCart(String rId){
        Id conid; 
        List<Cart__c> cartdet;
        try{
        conid = [select contactid from user where Id = :rId].contactid;
        cartdet = [Select Name,Amount__c,Status__c, Quantity__c from Cart__c where Customer__c = :conid];
        System.debug(cartdet);
        }
        catch(Exception e){
            System.debug('Error while getting cart Details in getCart :'+e.getMessage());
        }
        return cartdet;
    }
    //Fetch Address details
    @AuraEnabled(cacheable=true)
    public static List<Address_Book__c> getAddressList(String rId){
        List<Address_Book__c> addr;
        try{
        addr= [select Name,Street__c,Land_Mark__c,Address_Selection__c,State__c,City__c,Country__c,Postal_Code__c from Address_Book__c where User__c = :rId];
        System.debug(addr);
        }
        catch(Exception e){
          
            System.debug('Error while getting Address details in getAddressList :'+e.getMessage());
        }
        return addr;
    }
    //Fetch Cart Items of Cart
    @AuraEnabled(cacheable=true)
    public static Cart__c getCartItems(String rId){
        Cart__c cartdet;
        try{
        Id conid = [select contactid from user where Id = :rId].contactid;
        cartdet = [Select Name,After_Discount__c,Amount__c,Quantity__c,Status__c, (select Product__c,Product_Name__c,Quantity__c,Unit_Price__c,List_Price__c,Total_Amount__c, Cart_Id__r.Name from Cart_Items__r) from Cart__c where Customer__c = :conid];
        System.debug(cartdet);
        System.debug(cartdet.Cart_Items__r);
        }
        catch(Exception e){
            System.debug('Error while getting Cart Items of Cart in getCartItems :'+e.getMessage());
        }
        return cartdet;
    }
    //Update After Discount Amount in Cart
    @AuraEnabled
    public static Boolean updateDiscount(Decimal discount,String rId){
        try{

            Id conid = [select contactid from user where Id = :rId].contactid;
            Cart__c cartdet = [Select Name,After_Discount__c,Amount__c from Cart__c where Customer__c = :conid];
            cartdet.After_Discount__c = discount;
            System.debug(cartdet.After_Discount__c);
            update cartdet;
            return true;

        }
        catch(Exception e){
            System.debug('Error while getting Discount Amount in updateDiscount :'+e.getMessage());
            return false;
        }
    }
    //Check if the Coupon is Valid or Not
    @AuraEnabled
    public static Decimal checkCoupon(String coupon){
        Coupon__c coup;
        try{
            coup= [select Name,Discount__c,Remaining_Quantity__c,Expiry_Date__c from Coupon__c where Name = :coupon];
            if(coup == null || coup.Expiry_Date__c <= System.today() || coup.Remaining_Quantity__c < 1){
                system.debug('Not Valid');
                return 0;
            }
            else{
                system.debug(coup.Discount__c);
                return coup.Discount__c;
            }
        }
        catch (Exception e) {
            System.debug('No Coupon Found'+e);
            return 0;
        }
    }
    @AuraEnabled
    public static Decimal updateCoupon(String coupon){
        Coupon__c coup;
        try{
            coup= [select Name,Discount__c,Remaining_Quantity__c,Expiry_Date__c from Coupon__c where Name = :coupon];
            system.debug(coup.Discount__c);
            coup.Remaining_Quantity__c --;
            update coup;
            return 1;
        }
        catch (Exception e) {
            System.debug('No Coupon Found'+e);
            return 0;
        }
    }
}