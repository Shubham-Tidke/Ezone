import { LightningElement,track,wire,api} from 'lwc';
import User_ID from '@salesforce/user/Id';
import getOrderDetail from '@salesforce/apex/OrderDetail.getOrderDetail';


// const TILE_WRAPPER_SELECTED_CLASS = "tile-wrapper selected";
// const TILE_WRAPPER_UNSELECTED_CLASS= "tile-wrapper";

export default class OrderDetail extends LightningElement {

    userId= User_ID;

    @track error;
    @track allorders;

    @track redirect;
    @track orderitemId;

    connectedCallback(){
        console.log('userId id' + this.userId);   
    }


    @wire(getOrderDetail,{userId:'$userId'})
    wiredAccounts({
        error,
        data
    }) {
        if (data) {
            this.allorders = data;
            console.log('order id   ' + JSON.stringify(this.allorders));
            }
        else if (error)
             {
                this.error = error;
                console.log('error   '+error);
        }
    }

    get  NoRecords() {
        var isDisplay = true;
        if(this.allorders){
            if(this.allorders.length == 0){
                isDisplay = true;
            }else{
                isDisplay = false;
            }
        }
        return isDisplay;
    }   

     myFunc(event){
       // console.log('event '+event.currentTarget.dataset.id);
        this.orderitemId=event.currentTarget.dataset.id;
      //  console.log('event '+this.orderitemId);

    }

    get tileClass( ) { 
       // console.log('order is'+ this.orderitemId);

        //this.orderitemId==this.allorders.Id ? TILE_WRAPPER_SELECTED_CLASS : TILE_WRAPPER_UNSELECTED_CLASS;
        this.redirect = "https://eorderzone-developer-edition.ap26.force.com/s/orderdetailpage?Id="+ this.orderitemId;
        return this.orderitemId;

    }
}