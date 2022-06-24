@isTest
public class InvoiceGenerationControllerTest {
	@testSetup
    static void makeData(){
        Account acc = TestDataFactory.createAccount('Test Account', 1, true)[0];
        Contact con = TestDataFactory.createContact('Test', 'Contact', acc.Id,'abcd1@apisero.com', 1, true)[0];
        Order__c order=new Order__c(Customer__c=con.id);
        insert order;
        Order_Line_Item__c orderLine=new Order_Line_Item__c(Name='Test Order Line Item',Quantity__c=12,Order__c=order.id);
        insert orderLine;
    }
    
    @isTest
    private static void testGetOrderDetails(){
        Test.startTest();
        List<Order__c> order=[Select id from Order__c];
        System.debug(order[0]);
        PageReference pageRef = Page.InvoiceGeneration;
        List<Order_Line_Item__c> orderLine= [SELECT id FROM Order_Line_Item__c where Order__c=:order[0].id];
        System.debug(orderLine);
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', String.valueOf(order[0].id));
        ApexPages.StandardController sc = new ApexPages.StandardController(order[0]);
        InvoiceGenerationController controller = new InvoiceGenerationController(sc);
        controller.getOrderDetails();
       System.assertEquals(orderLine[0].id,controller.orderLineItems[0].id ,'Invoice records are not same');
        Test.stopTest();     
    }
}