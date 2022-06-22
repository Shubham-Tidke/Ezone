import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

const FIELDS = [
    'Account.Name',
    'Account.Phone'
    
];

export default class MyAccountDetails extends LightningElement {
    @api recordId;
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    account;

    get name() {
        return this.account.data.fields.Name.value;
    }
    get phone() {
        return this.account.data.fields.Phone.value;
    }

}