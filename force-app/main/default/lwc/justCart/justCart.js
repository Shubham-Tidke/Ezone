import { LightningElement, api, wire,track  } from 'lwc';
import Id from '@salesforce/user/Id';
import getContactId from '@salesforce/apex/JustCartController.getContactId';
import getCart from '@salesforce/apex/JustCartController.getCart';

const columns = [{
    label: 'Name',
    fieldName: 'Name'
},
{
    label: 'Status',
    fieldName: 'Status'
},

];
export default class JustCart extends LightningElement {
    @track Cart_Id__c = '';
    @track carts;
    @track columns = columns;
    //  invoke apex method with wire property and fetch picklist options.
    // pass 'object information' and 'picklist field API name' method params which we need to fetch from apex
    @wire(getContactId) contacts;
    onValueSelection(event) {
        // eslint-disable-next-line no-alert
        const selectedAccount = event.target.value;
        this.Cart_Id__c = event.target.value;
        if (selectedAccount != null) {
            getCart({
                Cart_Id__c: selectedAccount
                })
                .then(result => {
                    this.carts = result;
                    // eslint-disable-next-line no-console
                    console.log('result' + JSON.stringify(result) + selectedAccount);
                })
                .catch(error => {
                    this.error = error;
                });
        }
    }
}