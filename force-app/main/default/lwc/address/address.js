import { LightningElement,api, track, wire } from 'lwc';
import fetchAddr from '@salesforce/apex/fetchAccount.getAddressList';
import Id from '@salesforce/user/Id';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {refreshApex} from '@salesforce/apex';
import { NavigationMixin } from 'lightning/navigation';
import { deleteRecord } from 'lightning/uiRecordApi';
import { updateRecord } from 'lightning/uiRecordApi';

const actions = [
    { label: 'Edit', name: 'edit' },
    { label: 'Delete', name: 'delete' },
];
export default class Address extends LightningElement {
    @api userId;
    userId = Id;
    @api recordId;
    @track addr;
    isVisible;
    wiredData;

    @track columns =[
        {label:'Name' ,fieldName: 'Name',sortable:false,
        innerWidth:130,cellAttributes:{alignment:'left'}},
        {label:'Street' ,fieldName: 'Street__c',sortable:false,
        innerWidth:130,cellAttributes:{alignment:'left'}},
        {label:'Land Mark' ,fieldName: 'Land_Mark__c',sortable:false,
        innerWidth:130,cellAttributes:{alignment:'left'}},
        {label:'City' ,fieldName: 'City__c',sortable:false,
        innerWidth:130,cellAttributes:{alignment:'left'}},
        {label:'State' ,fieldName: 'State__c',sortable:false,
        innerWidth:130,cellAttributes:{alignment:'left'}},
        {label:'Country' ,fieldName: 'Country__c',sortable:false,
        innerWidth:130,cellAttributes:{alignment:'left'}},
        {label:'Postal Code' ,fieldName: 'Postal_Code__c',sortable:false,
        innerWidth:130,cellAttributes:{alignment:'left'}},{
            type: 'action',
            typeAttributes: { rowActions: actions },
        }, 
    ];

    @wire(fetchAddr, { rId: '$userId' })
    wireuser(result){
        this.wiredData = result;
        if(result.data){
            this.addr = result.data;
            //console.log('1'+ data);
            console.log('Hey');
            //console.log(JSON.stringify(data));
        }if(result.error){
            console.error('In Error');
            console.error(error);
        }
    }

    addAddr(){
        this.isVisible = !this.isVisible;
    }


    handleSuccess(event) {
        this.recordId = event.detail.id;
        const toastEvent= new ShowToastEvent(
            {title: "Address Created",
             message: "Record ID: " + event.detail.id,
             variant: "success"
            })
        this.dispatchEvent(toastEvent);  
        this.isVisible = false;
        return refreshApex(this.wiredData);
    }

    handleReset() {
        const inputFields = this.template.querySelectorAll( 'lightning-input-field' );
        if ( inputFields ) {
            inputFields.forEach( field => {
                field.reset();
            } );
        }
        //this.isVisible = false;
    }

    


    handleRowAction(event){
        console.log('In handle');
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        const r = JSON.stringify(row);
        let v = JSON.parse(r);
        let f = v.Id;
        console.log('In handle'+ f);
        switch ( actionName ) {
            case 'edit':
                //console.log('In handle'+ f);
                this[NavigationMixin.Navigate]({
                    type: 'standard__component',
                    attributes: {
                        recordId: f,
                        objectApiName: 'address',
                        actionName: 'edit'
                    }
                });
                break;
            case 'delete':
                //console.log('In handle'+ f);
                break;
            default:
        }
    }
}