trigger NewProductOfferTrigger on Product_Offer__c (after insert) {
	EmailOnProductOffer.SendEmailOnNewOffer(Trigger.new);
}