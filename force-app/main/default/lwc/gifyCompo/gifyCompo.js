import { LightningElement, track } from 'lwc';
import gify from '@salesforce/resourceUrl/gify';

export default class GifyCompo extends LightningElement {
    @track ash;
    connectedCallback(){
    this.ash = gify+'/gify.gif';
    }
}