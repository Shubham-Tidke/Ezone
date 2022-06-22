@isTest
public class InvoiceGenerationControllerTest {
	 @isTest
    private static void testGetOrderDetails(){
        Test.startTest();
        List<Order__c> order=[Select id from Order__c];
        PageReference pageRef = Page.InvoiceGeneration;
        Order_Line_Item__c orderLine= [SELECT id FROM Order_Line_Item__c where id=:order[0].id][0];
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', String.valueOf(order[0].id));
        ApexPages.StandardController sc = new ApexPages.StandardController(order[0]);
        InvoiceGenerationController controller = new InvoiceGenerationController(sc);
        controller.getOrderDetails();
        System.assertEquals(orderLine.id,controller.orderLineItems[0].id ,'Invoice records are not same');
        Test.stopTest();     
    }
}