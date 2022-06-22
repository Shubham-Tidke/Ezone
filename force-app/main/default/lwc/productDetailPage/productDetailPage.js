import { api, LightningElement, track, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import getProduct from '@salesforce/apex/GenericObjectFetcher.getProduct';
import E_Zone_logos from '@salesforce/resourceUrl/E_Zone_logos';
import createCartLineItem from '@salesforce/apex/GenericRecordCreator.createCartLineItem';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {NavigationMixin} from 'lightning/navigation';
import createProductRating from '@salesforce/apex/GenericRecordCreator.createProductRating';
import getProductRatings from '@salesforce/apex/GenericObjectFetcher.getProductRatings';

export default class ProductDetailPage extends NavigationMixin(LightningElement) {
    @api products;
    @track productImage;
    @api quantity = 0;
    @api finalQuantity;
    @track rating;
    @track error;
    @api proRatings;
    @api pId;
    currentPageReference = null; 
    urlStateParameters = null;
 
    /* Params from Url */
    urlId = null;
    urlLanguage = null;
    urlType = null;

    

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
          this.urlStateParameters = currentPageReference.state; 
          this.setParametersBasedOnUrl();
          
       }
    }
 
    setParametersBasedOnUrl() {
       this.urlId = this.urlStateParameters.Id|| null;
       this.urlLanguage = this.urlStateParameters.lang || null;
       this.urlType = this.urlStateParameters.type || null;  
    }

    @wire(getProduct,{productId : '$urlId'})
    product({data, error}){
        if(data){
            this.products = data;
            this.pId=this.products.Id;
            if(null!=this.products.Product_Images__r && undefined!=this.products.Product_Images__r){
                this.productImage=this.products.Product_Images__r[0].ResourceURL__c;
                }
            else{
                this.productImage=E_Zone_logos+'/E_Zone_logo.png';
            }
        }
        else if(error){
            this.error = error;
        }
    }

    counter(event){
        if(event.target.dataset.name == 'Down' && this.quantity > 0){
            this.quantity--;
        }

        else if(event.target.dataset.name == 'Up'){
            this.quantity++;
            
        }

    }

    handleOnClick(){
        if(this.products.Remaining_Quantity__c < this.quantity){
            console.log('Inside If');
            const toastEvent = new ShowToastEvent({
                title:'Out Of Stock!',
                message:'Sorry the product is Out Of Stock, We only have '+this.products.Remaining_Quantity__c+' available!!',
                variant:'error'
            });
            this.dispatchEvent(toastEvent);
        }
        else if(this.products.Remaining_Quantity__c >= this.quantity){
        createCartLineItem({product : this.products, quantityRequested : this.quantity}).then(result => {
            const toastEvent = new ShowToastEvent({
                title:'Success!',
                message:'Product has been successfully added to your cart',
                variant:'success'
            });
            this.dispatchEvent(toastEvent);

            const config = {
                type: 'standard__webPage',
                attributes: {
                    url: 'https://eorderzone-developer-edition.ap26.force.com/s/all-products'
                }
            };
            this[NavigationMixin.Navigate](config);
        }).catch(error =>{
            const toastEvent = new ShowToastEvent({
                title:'Failure!',
                message:'Technical Issue please contact Customer Support',
                variant:'error'
            });
            this.dispatchEvent(toastEvent);
            this.error = error;
            console.log(JSON.stringify(this.error));
        })
        }      
    }
    handleRate(event){
        this.rating = event.target.value;
    }
    handleRating(){
               
        let review = this.template.querySelector('textarea').value;
        createProductRating({product:this.products,rate:this.rating,comment:review})
        .then(result=>{
            const toastEvent = new ShowToastEvent({
                title:'Success!',
                message:'Thank you for your review!!',
                variant:'success'
            });
            this.dispatchEvent(toastEvent);
            window.location.reload();
        })
        .catch(error=>{
            this.error = error;
            console.log(JSON.stringify(this.error));
        });
        
    }

    @wire(getProductRatings,{productId:'$urlId'})
    getNewProductRatings({data,error}){
        console.log('Chala na!!');
        console.log('pid  is'+this.pId);
        if(data){
            this.proRatings=data;
            this.error=undefined;
            console.log('Pro Rating Id is'+JSON.stringify(this.proRatings));
        }else if(error){
            this.error=error;
        }else{
            console.log('Kuch hua')
        }
    }
}