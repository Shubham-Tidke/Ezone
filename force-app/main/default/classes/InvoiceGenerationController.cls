/**
 * @description       : 
 * @author            : Mayank Singh Kandari
 * @group             : 
 * @last modified on  : 06-20-2022
 * @last modified by  : Mayank Singh Kandari
**/
public with sharing class InvoiceGenerationController {
   
   public String orderId{set;get;} 
   public List<Order_Line_Item__c> orderLineItems{get;set;}
   public static Decimal qty{set;get;}
   public static Decimal total{set;get;}

   public InvoiceGenerationController (ApexPages.StandardController controller) {
        orderId=ApexPages.currentPage().getParameters().get('id');
    }
    
   public void getOrderDetails(){
        qty=0.0;
        total=0.0;
        orderLineItems=OrderDetail.getOrderItem(orderId);
        for(Order_Line_Item__c olc:orderLineItems){
            qty+=olc.Quantity__c;
            total+=olc.Total__c;
        }

   }
}