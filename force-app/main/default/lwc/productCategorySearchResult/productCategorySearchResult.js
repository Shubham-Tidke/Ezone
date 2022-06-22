import { LightningElement, api, wire, track } from 'lwc';
import getChildCategories from '@salesforce/apex/GenericObjectFetcher.getChildCategories';
import getProductWithCategory from '@salesforce/apex/GenericObjectFetcher.getProductWithCategory';

export default class ProductCategorySearchResult extends LightningElement {

    @track error;
    @track childCatObj;
    @track categoId;    //parentCatgoryId
    @api productList;
    @api product;

    ProductCategorySearchResult(){
        console.log('Kachra '+document.getElementById("item.id").innerHTML);
    
    }

    @wire(getChildCategories,{categoryId:'$categoId'})
    childCategory({data, error}){
        console.log('data is'+JSON.stringify(data));
        if(data){
            console.log('data'+JSON.stringify(data));
            this.childCatObj=data;
        }else if(error){
            this.error=error;
        }
    }

    @api searchCategory(categoryId){
        this.categoId=categoryId;
    }

    @wire(getProductWithCategory,{categoryId:'$categoId'})
    getProducts({data, error}){
        if(data){
            this.productList=data;
            console.log('Product list form category'+JSON.stringify(data));
            this.error=undefined;
        }else if(error){
            this.error=error;
        }
    }

    
    

}