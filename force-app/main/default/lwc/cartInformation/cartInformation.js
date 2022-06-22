import { LightningElement,api,wire,track } from 'lwc';
import cartItems from '@salesforce/apex/FetchSObjectsInfo.getCartItems';
import discountUpdate from '@salesforce/apex/FetchSObjectsInfo.updateDiscount';
import couponCheck from '@salesforce/apex/FetchSObjectsInfo.checkCoupon';
import updateCoupon from '@salesforce/apex/FetchSObjectsInfo.updateCoupon';
import createOrderLineItem from '@salesforce/apex/GenericRecordCreator.createOrderLineItem';
import getShippingAddress from '@salesforce/apex/GenericObjectFetcher.getShippingAddress';
import getBillingAddress from '@salesforce/apex/GenericObjectFetcher.getBillingAddress';
import Id from '@salesforce/user/Id';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {NavigationMixin} from 'lightning/navigation';
import { deleteRecord } from 'lightning/uiRecordApi';
import {refreshApex} from '@salesforce/apex';

export default class CartInformation extends NavigationMixin(LightningElement) {
    @api userId;
    userId = Id;
    @api cItems;
    @api cartName;
    @api indItem;
    @api cartAmount;
    isClicked;
    @api prod;
    @api productid;
    @track quantity;
    coup;
    @api updatedCost = 0;
    @track isBillingAddress = false;
    @track isShippingAddress = false;
    @track orderId;
    @track navUrl;

    connectedCallback(){
        getBillingAddress({currentUserId : this.userId}).then(result => {
            console.log('Billing---'+ result.length);
            if(result.length > 0){
                this.isBillingAddress = true;
                console.log('Billing True'+JSON.stringify(result));
            }
        }).catch(error =>{
            this.error = error;
            console.log(JSON.stringify(this.error));
        })

        getShippingAddress({currentUserId : this.userId}).then(result => {
            console.log('Shipping---'+ result.length);
            if(result.length > 0){
                this.isShippingAddress = true;
                console.log('Shipping True' + JSON.stringify(result));
            }
        }).catch(error =>{
            this.error = error;
            console.log(JSON.stringify(this.error));
        })
    }

    @wire(cartItems, { rId: '$userId' })
    wireuser(result){
        this.wiredData = result;
        if(result.data){
            this.cItems = result.data;
            this.cartName = this.cItems.Name;
            this.cartAmount = this.cItems.Amount__c;
            this.indItem = this.cItems.Cart_Items__r;
            //console.log('Updated Cost '+this.cItems.After_Discount__c);
            console.log('Hi');

        }if(result.error){
            console.error('In Error');
            this.error = result.error;
            console.error(error);
        }
    }

    textfield(){
        this.isClicked = !this.isClicked;
    }

    checkCoupon(){
        const temp = this.template.querySelector('lightning-input[data-name="temp"]').value;
        console.log(temp);
        couponCheck({ coupon: temp })
		.then(result => {
			this.coup = result;
            console.log('Check Coupon Value : '+this.coup);
            if(this.coup>0){
                //this.cartAmount = this.cartAmount - ( this.cartAmount * 0.01 * this.coup);
                this.updatedCost = this.cartAmount - ( this.cartAmount * 0.01 * this.coup);
                console.log('Value : '+this.updatedCost);
                const toastEvent= new ShowToastEvent(
                    {title: "Valid Coupon",
                     message: "Coupon : " + temp,
                     variant: "success"
                    })
                this.dispatchEvent(toastEvent);
                this.error = undefined;
            }
            else{
                const toastEvent= new ShowToastEvent(
                    {title: "Invalid Coupon",
                     message: "Enter Another Coupon",
                     variant: "error"
                    })
                this.dispatchEvent(toastEvent);
            }
            
		})
		.catch(error => {
			this.error = error;
            console.log(this.error);
			this.coup = undefined;
		})
    }
    
    goToOrder(){
        console.log('Checkout Clicked');

        if(this.updatedCost == 0){
            this.updatedCost = this.cartAmount;
        }
        else{
            const temp = this.template.querySelector('lightning-input[data-name="temp"]').value;
            console.log(temp);
            updateCoupon({coupon: temp })
            .then(result => {
                console.log('Coupon count Updated '+result);
            })
            .catch(error => {
                console.log('Error Updating Coupon Count '+JSON.stringify(error));
            })
        }

        discountUpdate({discount : this.updatedCost, rId: this.userId })
        .then(result => {
            console.log('Updated Succcessfully '+result);
        })
        .catch(error => {
            console.log('Error Updating '+JSON.stringify(error));
        })

        const btnDisable = this.template.querySelector('lightning-button[data-id="couponBtn"]');
        btnDisable.disabled = true; 
        this.isClicked = false;

        if(this.isBillingAddress == false || this.isShippingAddress == false){

            const toastEvent= new ShowToastEvent(
                {title: "Address not available",
                 message: "Please add Billing/Shipping Addresses",
                 variant: "error"
                })
            this.dispatchEvent(toastEvent);

            const config = {
                type: 'standard__webPage',
                attributes: {
                    url: 'https://eorderzone-developer-edition.ap26.force.com/s/profile/'+this.userId.substring(0,15)+'?tabset-e0492=f3e00'
                }
            };
            this[NavigationMixin.Navigate](config);
        }

        else{
            createOrderLineItem({cartLineItems : this.indItem, afterDiscount : this.updatedCost}).then(result =>{
                this.orderId = result;
                console.log('Result in Line Item is : '+this.orderId);
                this.navUrl = 'https://eorderzone-developer-edition.ap26.force.com/s/orderdetailpage?Id='+this.orderId;
                const config = {
                    type: 'standard__webPage',
                    attributes: {
                        url: this.navUrl
                    }
                };
                this[NavigationMixin.Navigate](config);
            }).catch(error =>{
                this.error = error;
                console.log(JSON.stringify(this.error));
            })
           
            
        }
        
    }

    removeRow(event){
        console.log('In removeRow');
        const row = event.target.dataset.id;
        console.log('row ' + row);
        deleteRecord(row)
                .then(() => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Record deleted',
                            variant: 'success'
                        })
                    );
                    return refreshApex(this.wiredData);
                })
                .catch(error => {
                    console.log(error);
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error deleting record',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                });
        
    }

    counter(event){
        const temp1 = this.template.querySelector('lightning-input[data-name="quantityLabel"]').value;
        this.quantity = temp1;
        console.log('Quantity value :'+ this.quantity );
        if(event.target.dataset.name == 'Down' && this.quantity > 0){
               this.quantity--;
        }

        else if(event.target.dataset.name == 'Up'){
            this.quantity++;
            
        }

    }

    handleChange(event){
        quantity = event.target.value;
        console.log('value in QUANTITY :'+ quantity);
    }
}