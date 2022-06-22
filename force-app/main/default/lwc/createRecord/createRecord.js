import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CreateRecord extends LightningElement {
    handleSuccess(event) {
        console.log('onsuccess event recordEditForm', event.detail.id);
        const evt = new ShowToastEvent({
            title: 'Success',
            message: 'Record Created!!',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }
    handleSubmit(event) {
        console.log('onsubmit event recordEditForm'+ event.detail.fields);
    }
}