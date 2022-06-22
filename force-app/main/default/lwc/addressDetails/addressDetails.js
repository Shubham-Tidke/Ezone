import { LightningElement,api, track, wire } from 'lwc';
import fetchAddr from '@salesforce/apex/FetchSObjectsInfo.getAddressList';
import Id from '@salesforce/user/Id';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {refreshApex} from '@salesforce/apex';
import { NavigationMixin } from 'lightning/navigation';
import { deleteRecord } from 'lightning/uiRecordApi';

const actions = [
    { label: 'Edit', name: 'edit' },
    { label: 'Delete', name: 'delete' },
];

export default class AddressDetails extends NavigationMixin(LightningElement) {

    @api userId;
    userId = Id;
    @api recordId;
    @track addr;
    isVisible;
    wiredData;
    isdataPresent;


    @track columns =[
        {label:'Name' ,fieldName: 'Name',sortable:false,
        innerWidth:130,cellAttributes:{alignment:'left'}},
        {label:'Street' ,fieldName: 'Street__c',sortable:false,
        innerWidth:130,cellAttributes:{alignment:'left'}},
        {label:'Land Mark' ,fieldName: 'Land_Mark__c',sortable:false,
        innerWidth:130,cellAttributes:{alignment:'left'}},
        {label:'Address Selection' ,fieldName: 'Address_Selection__c',sortable:false,
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
            if(this.addr){
                if(this.addr.length == 0){
                    console.log('empty');
                    this.isdataPresent = false;
                }else{
                    console.log('present');
                    this.isdataPresent = true;
                }
            }
            //console.log('1'+ data);
            console.log('Hey');
        }if(result.error){
            console.error('In Error');
            console.error(error);
        }
    }


    addAddr(){
        if(this.addr.length == 2){
            const btnDisable = this.template.querySelector('lightning-button[data-id="AddBtn"]');
            btnDisable.disabled = true; 
        }
        else
            this.isVisible = !this.isVisible;

        console.log('In Address Button' + this.addr.length);
        console.log('Add Address Button');
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
        console.log('len '+this.addr.length );
        if(this.addr.length == 1){
            console.log('In Disable');
            const btnDisable = this.template.querySelector('lightning-button[data-id="AddBtn"]');
            btnDisable.disabled = true; 
        }
        const config = {
            type: 'standard__webPage',
            attributes: {
                url: 'https://eorderzone-developer-edition.ap26.force.com/s/profile/'+this.userId.substring(0,15)+'?tabset-e0492=f3e00'
            }
        };
        this[NavigationMixin.Navigate](config);
        
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
        switch ( actionName ) {
            case 'edit':
                this.isVisible = true;
                this.recordId = f;
                break;
            case 'delete':
                deleteRecord(f)
                .then(() => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Record deleted',
                            variant: 'success'
                        })
                    );
                    console.log('In Deleted' + this.addr.length);
                    if(this.addr.length == 2){
                        console.log('In Enable');
                        const btnDisable = this.template.querySelector('lightning-button[data-id="AddBtn"]');
                        btnDisable.disabled = false; 
                    }
                    
                    const config = {
                        type: 'standard__webPage',
                        attributes: {
                            url: 'https://eorderzone-developer-edition.ap26.force.com/s/profile/'+this.userId.substring(0,15)+'?tabset-e0492=f3e00'
                        }
                    };
                    this[NavigationMixin.Navigate](config);

                    return refreshApex(this.wiredData);
                })
                .catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error deleting record',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                });
                break;
            default:
        }
    }
}