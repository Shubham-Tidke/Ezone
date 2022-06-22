import { LightningElement,api, track, wire } from 'lwc';
import fetchAddr from '@salesforce/apex/fetchAccount.getAddressList';
import Id from '@salesforce/user/Id';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

const columns = [
    {
        label: 'Name',
        fieldName: 'Name',
        type: 'text',
    }, {
        label: 'Street',
        fieldName: 'Street__c',
        type: 'text',
        editable: true,
    }, {
        label: 'State',
        fieldName: 'State__c',
        type: 'text',
        editable: true,
    },
];
export default class DupliacteAddress extends LightningElement {
    @api userId;
    userId = Id;
    columns = columns;
    @track contacts;
    saveDraftValues = [];

    @wire(fetchAddr)
    cons(result) {
        this.contacts = result;
        if (result.error) {
            this.contacts = undefined;
        }
    };

    handleSave(event) {
        this.saveDraftValues = event.detail.draftValues;
        const recordInputs = this.saveDraftValues.slice().map(draft => {
            const fields = Object.assign({}, draft);
            return { fields };
        });

        // Updateing the records using the UiRecordAPi
        const promises = recordInputs.map(recordInput => updateRecord(recordInput));
        Promise.all(promises).then(res => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Records Updated Successfully!!',
                    variant: 'success'
                })
            );
            this.saveDraftValues = [];
            return this.refresh();
        }).catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'An Error Occured!!',
                    variant: 'error'
                })
            );
        }).finally(() => {
            this.saveDraftValues = [];
        });
    }

    // This function is used to refresh the table once data updated
    async refresh() {
        await refreshApex(this.contacts);
    }
    
    
}