import { LightningElement,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import ACCOUNTREQUEST_NAME from'@salesforce/schema/Account_Request__c.Name';
import ACCOUNTREQUEST_CONTACTFIRSTNAME from '@salesforce/schema/Account_Request__c.Primary_Contact_First_Name__c';
import ACCOUNTREQUEST_CONTACTLASTNAME from '@salesforce/schema/Account_Request__c.Primary_Contact_Last_Name__c';
import ACCOUNTREQUEST_CONTACTEMAIL from '@salesforce/schema/Account_Request__c.Primary_Contact_Email__c';
import ACCOUNTREQUEST_SHIPPINGSTREET from '@salesforce/schema/Account_Request__c.Shipping_Street__c';
import ACCOUNTREQUEST_SHIPPINGCITY from '@salesforce/schema/Account_Request__c.Shipping_City__c';
import ACCOUNTREQUEST_SHIPPINGSTATE from '@salesforce/schema/Account_Request__c.Shipping_State__c';
import ACCOUNTREQUEST_SHIPPINGCOUNTRY from '@salesforce/schema/Account_Request__c.Shipping_Country__c';
import ACCOUNTREQUEST_SHIPPINGPOSTALCODE from '@salesforce/schema/Account_Request__c.Shipping_Postal_Code__c';
import ACCOUNTREQUEST_PRIMARYCONTACTPHONE from '@salesforce/schema/Account_Request__c.Primary_Contact_Phone__c';
import ACCOUNTREQUEST_PRIMARYCONTACTTITLE from '@salesforce/schema/Account_Request__c.Primary_Contact_Title__c';
export default class AccountRequestForm extends LightningElement {
    @api name=ACCOUNTREQUEST_NAME;
    @api contactFirstName=ACCOUNTREQUEST_CONTACTFIRSTNAME;
    @api contactLastName=ACCOUNTREQUEST_CONTACTLASTNAME;
    @api  contactEmail=ACCOUNTREQUEST_CONTACTEMAIL;
    @api shippingStreet=ACCOUNTREQUEST_SHIPPINGSTREET;
    @api  shippingCity=ACCOUNTREQUEST_SHIPPINGCITY;
    @api shippingCountry=ACCOUNTREQUEST_SHIPPINGCOUNTRY;
    @api shippingPostalCode=ACCOUNTREQUEST_SHIPPINGPOSTALCODE;
    @api shippingState=ACCOUNTREQUEST_SHIPPINGSTATE;
    @api  contactTitle=ACCOUNTREQUEST_PRIMARYCONTACTPHONE;
    @api contactPhone=ACCOUNTREQUEST_PRIMARYCONTACTTITLE;
    handleSuccess(event){
        const toastEvent= new ShowToastEvent(
            {title: "Account Request Created",
             message: "Record ID: " + event.detail.id,
             variant: "success"
            })
            this.dispatchEvent(toastEvent);
    }

}