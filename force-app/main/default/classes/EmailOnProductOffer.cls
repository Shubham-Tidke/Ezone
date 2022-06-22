/**
 * @description       : 
 * @author            : Mayank Singh Kandari
 * @group             : 
 * @last modified on  : 06-17-2022
 * @last modified by  : Mayank Singh Kandari
**/
public with sharing class EmailOnProductOffer {
    
    public static Product2 product  {set; get;}
    public static Product_Offer__c productOffer {set;get;}
    public static Product_Images__c productImage {set;get;}

    public static void SendEmailOnNewOffer(List<Product_Offer__c> productOffers){
        Id productOfferId=productOffers[0].id;
        List<User> getCommunityUserList = [SELECT id, Name, Email
                                        FROM User 
                                        WHERE Profile.Name = 'Customer Community User' WITH SECURITY_ENFORCED];
        
                if(null!=productOfferId){
                    productOffer=GenericObjectFetcher.getProductOffers(productOfferId);
                }
                if(null!=productOffer){
                    product=GenericObjectFetcher.getProduct(productOffer.Product__c);
                }
               if(null!=product){   
                    productImage=GenericObjectFetcher.getProductImages(product.Id);   
               }
                    if(null!=productOffer){  
                   
                        // First, reserve email capacity for the current Apex transaction to ensure
                        // that we won't exceed our daily email limits when sending email after
                        // the current transaction is committed.
                        Messaging.reserveSingleEmailCapacity(2);
                        
                        //Single Email Object
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        
                        // Strings to hold the email addresses to which you are sending the email.
                        String[] toAddresses = new String[] {'ashutosh.r.pandey@apisero.com'}; 
                        String[] ccAddresses = new String[] {'mayank.s.kandari@apisero.com'};
                        
                        // Assign the addresses for the To and CC lists to the mail object.
                        mail.setToAddresses(toAddresses);
                        mail.setCcAddresses(ccAddresses);
                        
                        // Specify the address used when the recipients reply to the email. 
                        mail.setReplyTo('mayank.s.kandari@apisero.com');
                        
                        // Specify the name used as the display name.
                        mail.setSenderDisplayName('E-Zone');
                        
                        // Specify the subject line for your email address.
                        mail.setSubject('Hurray! We have got an amazing new offer for you!');
                        
                        //BCC yourself on the email - false
                        mail.setBccSender(false);
                        
                        // Optionally append the Salesforce email signature to the email.
                        // The email address of the user executing the Apex Code will be used.
                        mail.setUseSignature(false);
                        
                        // Specify the text content of the email.
                       // mail.setPlainTextBody('Dear User, Here we bring an amazing offer on your favourite product. Why don\'t you have a look?');
                        String link='https://eorderzone-developer-edition.ap26.force.com/s/product-detail-page?Id='+product.Id;
                        if(null!=productImage && null!=product){
                            System.debug('Product Name: '+product.Name+' '+productImage.ResourceURL__c);
                            mail.setHtmlBody('<p>Dear User,<br/><p>Here we bring an amazing offer on your favourite product.<br/>Why don\'t you have a look?</p><br/><img src='+productImage.ResourceURL__c+' height="500px" width="500px"/> <br/><br/><p> Here\'s your amazing product <b> '+product.Name+'! Click on the below button and avail your offer now.</b> <p/> <br/><a href="'+link +'">Avail Offer</a>');
                        }else if(null!=product){
                            System.debug('Product Name: '+product.Name);
                            mail.setHtmlBody('<p>Dear User,<br/><p>Here we bring an amazing offer on your favourite product.</p><br/><p>Why don\'t you have a look?</p><br/><p> Here\'s your amazing product <b> '+product.Name+'!</b>Click on the below button and avail your offer now.<p/><br/> <a style="background-color: #4CAF50;   border: none; color: white;padding: 15px 32px;  font-size: 16px;text-align: center;text-decoration: none;display: inline-block;" href='+link+'> Avail Offer</a>');      
                        }
                        // Send the email you have created.
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                   }else{
                        productOffer.addError('NO Image attached to Product!');
               		}
               }           
    }