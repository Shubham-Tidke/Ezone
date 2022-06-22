import { LightningElement, track, wire } from 'lwc';
import getAllProducts from '@salesforce/apex/GenericObjectFetcher.getAllProducts';

export default class ProductDetailComponent extends LightningElement {

    @track productList;

    @wire(getAllProducts)
    products({data, error}){
        if(data){  
            this.productList = data;
            console.log('Product List value :'+this.productList); 

        }
        else if(error){
            console.log('Inside else if');
            this.error = error;
        }
    }

    // get recordId() {
    //     return this.currentPageReference?.state?.c__recordId;
    // }

    // get objectType() {
    //     return this.currentPageReference?.state?.c__objectType;
    // }
    
}