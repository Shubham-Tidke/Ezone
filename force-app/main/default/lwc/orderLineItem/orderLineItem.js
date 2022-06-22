import { LightningElement,api,wire,track } from 'lwc';
import  getOrderItem from '@salesforce/apex/OrderDetail.getOrderItem';
import { CurrentPageReference } from 'lightning/navigation';
import cancelOrder from '@salesforce/apex/GenericRecordCreator.cancelOrder';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {NavigationMixin} from 'lightning/navigation';

const TILE_WRAPPER_SELECTED_CLASS = "tile-wrapper selected";
const TILE_WRAPPER_UNSELECTED_CLASS= "tile-wrapper";

export default class OrderLineItem extends NavigationMixin(LightningElement){


    @track invoice;
    @api recordId;//='a045i000003xPUlAAM';
    @track allorderitem;
    @track loader = false;
    productids;
    recId;
    recordBool = false;
    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference){
        
        this.currentPageReference = currentPageReference;
        let tempRecId = this.currentPageReference.state.Id;
        console.log( 'Rec Id is ' + tempRecId );
        if ( tempRecId ) {

            this.recordBool = true;
            this.recId = tempRecId;
            console.log( 'Rec Id is ' + tempRecId );

        } else {

            this.recordBool = false;
            this.recId = undefined;
            console.log( 'Rec Id is 2 ' + recordBool );

        }
    }

        @wire( getOrderItem,{itemid:'$recId'})
        wiredAccount({
        error,
        data
    }) {
        if (data) {

            this.invoice='https://eorderzone-developer-edition.ap26.force.com/s/order-invoice?id='+this.recId;
            this.allorderitem = data;
            this.error = undefined;
            console.log("inside orderlineitem "+ this.allorderitem);
        } 
        else if (error) 
        {
            this.error = error;
            this.allorderitem = undefined;
            console.log('error  error '+JSON.stringify(error));
        }
    }

    

    get  NoRecords() {
        var isDisplay = true;
        if(this.allorderitem){
            if(this.allorderitem.length == 0){
                isDisplay = true;
                console.log("inside no record true");
            }else{
                isDisplay = false;
                console.log("inside no record true");
            }
        }
        return isDisplay;
    } 

    myFunc(event){
        // console.log('event '+event.currentTarget.dataset.id);
         this.productids=event.currentTarget.dataset.id;
 
     }
    
    
    get ProductredirectClass() { 
        console.log('product is  '+this.productids);
       // this.productids==this.productids ? TILE_WRAPPER_SELECTED_CLASS : TILE_WRAPPER_UNSELECTED_CLASS;
        this.redirect = "https://eorderzone-developer-edition.ap26.force.com/s/product-detail-page?Id="+this.productids;
        return this.productids;

    }

    cancelMyOrder(){

        console.log("In cancel Order"+JSON.stringify(this.recId ));

        cancelOrder({orderId: this.recId}).then(result => {

            if(result.Status__c!='In Process' || result.Status__c!='Open'){

                console.log(JSON.stringify(result));
            const toastEvent= new ShowToastEvent(
                {title: "Order Cancelled!!",
                 message: "Pencil bol pencil , tera order cancel",
                 variant: "success"
                })
            this.dispatchEvent(toastEvent);

            const config = {
                type: 'standard__webPage',
                attributes: {
                    url: 'https://eorderzone-developer-edition.ap26.force.com/s/recordlist/Order__c/Default'
                }
            };
            this[NavigationMixin.Navigate](config);}               

            else{
                
                const toastEvent= new ShowToastEvent(
                    {title: "Order Not Cancelled!!",
                     message: "Pencil bol pencil , tera order nahi karunga cancel!!",
                     variant: "success"
                    })
                this.dispatchEvent(toastEvent);}
            

        }).
        catch(error => { console.log(JSON.stringify(error))});

    }

}