import { LightningElement, api, wire } from 'lwc';
import FetchAccount from '@salesforce/apex/FetchSObjectsInfo.getAccount';
import Id from '@salesforce/user/Id';

export default class AccountDetails extends LightningElement {
    @api accID;
    @api userId;
    userId = Id;

    @wire(FetchAccount, { rId: '$userId' })
    wireuser({error,data}){
        if(data){
            this.accID = data;
            console.log('1'+ data);
            console.log('Hi');
        }if(error){
            console.error('In Error');
            console.error(error);
        }
    }
}