public with sharing class ProductOfferEmail {
    public static void sendEmail(){
        // First, reserve email capacity for the current Apex transaction to ensure
        // that we won't exceed our daily email limits when sending email after
        // the current transaction is committed.
        Messaging.reserveSingleEmailCapacity(2);
        
        // Processes and actions involved in the Apex transaction occur next,
        // which conclude with sending a single email.
        
        // Now create a new single email message object
        // that will send out a single email to the addresses in the To, CC & BCC list.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        // Strings to hold the email addresses to which you are sending the email.
        String[] toAddresses = new String[] {'ashutosh.r.pandey@apisero.com'}; 
        String[] ccAddresses = new String[] {'mayank.s.kandari@apisero.com'};
                
                
        // Assign the addresses for the To and CC lists to the mail object.
        mail.setToAddresses(toAddresses);
        mail.setCcAddresses(ccAddresses);
        
        // Specify the address used when the recipients reply to the email. 
        // mail.setReplyTo('support@acme.com');
        
        // Specify the name used as the display name.
        mail.setSenderDisplayName('Salesforce Support');
        
        // Specify the subject line for your email address.
        mail.setSubject('Image Email Test');
        
        // Set to True if you want to BCC yourself on the email.
        mail.setBccSender(false);
        
        // Optionally append the Salesforce email signature to the email.
        // The email address of the user executing the Apex Code will be used.
        mail.setUseSignature(false);
        
        // Specify the text content of the email.
        mail.setPlainTextBody('Image :');
        
        mail.setHtmlBody('<img src= "https://media.istockphoto.com/photos/red-apple-picture-id184276818?k=20&m=184276818&s=612x612&w=0&h=QxOcueqAUVTdiJ7DVoCu-BkNCIuwliPEgtAQhgvBA_g="/>');
        
        // Send the email you have created.
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}