import { LightningElement, api, wire } from 'lwc';
import FetchContact from '@salesforce/apex/FetchSObjectsInfo.getContact';
import Id from '@salesforce/user/Id';

export default class ContactDetails extends LightningElement {
    @api conID;
    @api userId;
    userId = Id;

    @wire(FetchContact, { rId: '$userId' })
    wireuser({error,data}){
        if(data){
            this.conID = data;
            console.log('1'+ data);
            console.log('Hi');
        }if(error){
            console.error('In Error');
            console.error(error);
        }
    }
}