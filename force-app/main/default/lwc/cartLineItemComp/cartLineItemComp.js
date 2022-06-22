import { api, LightningElement, track } from 'lwc';

export default class CartLineItemComp extends LightningElement {
    @api cart;
    @track quantity;

    connectedCallback(){
        console.log('Cart Value is :'+ JSON.stringify(this.cart));
        this.quantity = this.cart.Quantity__c;
    }
    
    counter(event){
        if(event.target.dataset.name == 'Down' && this.quantity > 0){
               this.quantity--;
        }

        else if(event.target.dataset.name == 'Up'){
            this.quantity++;
            
        }

    }
}