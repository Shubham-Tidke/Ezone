import { LightningElement } from 'lwc';

export default class RegisterPage extends LightningElement {
    handleSuccess(event){
        const toastEvent= new ShowToastEvent(
            {title: "Account created",
             message: "Record ID: " + event.detail.id,
             variant: "success"
            })
            this.dispatchEvent(toastEvent);
    }
}