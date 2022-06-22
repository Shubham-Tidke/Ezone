import { LightningElement, api, track, wire } from 'lwc';
import getProductWithCategory from '@salesforce/apex/GenericObjectFetcher.getProductWithCategory';

export default class ProductListChildCategory extends LightningElement {

    @api childobj;
    @api passid;
    @track error;
    @track productList;
    @track categoId;

    @wire(getProductWithCategory,{categoryId:'$passid'})
    getProduct({data, error}){
        console.log('data from Child category is'+JSON.stringify(data));
        if(data){
            console.log('data from Child category is'+JSON.stringify(data));
            this.productList=data;
        }else if(error){
            this.error=error;
        }
    }
    
}