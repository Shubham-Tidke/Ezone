import { LightningElement, api, wire, track } from 'lwc';
import getCart from '@salesforce/apex/FetchSObjectsInfo.getCart';
import Id from '@salesforce/user/Id';

export default class CartDetails extends LightningElement {
    @track cartItems;
    @api userId;
    userId = Id;
    isVisible;


    @wire(getCart, { rId: '$userId' })
    wireuser({error,data}){
        if(data){
            this.cartItems = data;
            //console.log('1'+ data);
            console.log('Hey');
            console.log(JSON.stringify(data));
            if(this.cartItems){
                if(this.cartItems.length == 0){
                    console.log('empty');
                    this.isVisible = false;
                }else{
                    console.log('present');
                    this.isVisible = true;
                }
            }
        }if(error){
            console.error('In Error');
            console.error(error);
        }
    }

    get goToCart() { 
        console.log('In gotoCart');
        this.redirect = "https://eorderzone-developer-edition.ap26.force.com/s/cart";
    }

}