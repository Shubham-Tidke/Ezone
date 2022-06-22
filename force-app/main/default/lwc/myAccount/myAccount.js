import { LightningElement, api, wire,track } from 'lwc';
import USER_ID from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';
import ACCOUNT_ID from '@salesforce/schema/Account.Id';
import ACCOUNT_NAME from '@salesforce/schema/Account.Name';
import getAccount from '@salesforce/apex/MyAccountController.getAccountDetails';

export default class MyAccount extends LightningElement {
    userId = USER_ID
    @track accountId;
    @api recordId

    @track accounts;
    @track error;
    @track errors;
      
    @wire(getRecord, {
        recordId: "$userId",
        fields: [ACCOUNT_ID,
                ACCOUNT_NAME]
    }) wireuser({error, data}) {
        if (error) {
           this.error = error ; 
        } else if (data) {
            this.accountId = data.fields.accountId.value;
        }
    }
    
    //this is not working
    @wire (getAccount, {accountId: '$accId'}) wiredAccounts({data, error}){
      if(data) {
        this.accounts =data;
        this.errors = undefined;
      }else {
        this.accounts =undefined;
        this.errors = error;
        console.log("error - "+error);
      }
}
}