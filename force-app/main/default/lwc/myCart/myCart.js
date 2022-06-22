import { LightningElement,api,track,wire } from 'lwc';
import getOpenCart from '@salesforce/apex/OpenCart.getOpenCart';
import User_ID from '@salesforce/user/Id';

export default class MyCart extends LightningElement {

    userId = User_ID;

    @api recordId;
    @track error;
    @track opencart ;
    prodid;

 //   console.log('user id ' +this.userId);

  
    // @track columns =[
    //     {label:'Product' ,fieldName: 'Product__c',sortable:false,hideDefaultActions: 'true',
    //     innerWidth:130,cellAttributes:{alignment:'left'}},

    //     {label:'Total Amount' ,fieldName: 'Total_Amount__c',sortable:false,hideDefaultActions: 'true',
    //     innerWidth:130,cellAttributes:{alignment:'left'}}
    // ];

    @wire(getOpenCart,{userId:'$userId'})
    wiredAccounts({
        error,
        data
    }) {
        if (data) {
         //   console.log("UserId "+ this.userId);
            this.opencart = data;

        const r = JSON.stringify(data);
        console.log("test1"+r);

        let v = JSON.parse(r[1]);
        console.log("test2"+v);
        let f = v.Product__c;
        console.log("test3"+f);

            
          //  console.log("opencart "+ this.opencart);
         console.log(JSON.stringify(data))
         //this.redirect = "https://eorderzone-developer-edition.ap26.force.com/s/product-detail-page?Id="+this.product.Id;
         // this.imageURL = data.fields.URL__c.value;
        //  console.log(JSON.stringify(this.imageURL))
        this.prodid=data.Product__c.value;
        console.log("teste123444"+this.prodid);

        } else if (error) {
            this.error = error;
        }
    }

    // @wire(getOpenCart,{userId:'$userId'})
    // wiredAccounts({
    //     error,
    //     data
    // }) {
    //     if (data) {
    //      //   console.log("UserId "+ this.userId);
    //         this.opencart = data;
            
    //       //  console.log("opencart "+ this.opencart);
    //      console.log(JSON.stringify(data))
    //      // this.imageURL = data.fields.URL__c.value;
    //     //  console.log(JSON.stringify(this.imageURL))
    //     } else if (error) {
    //         this.error = error;
    //     }
    // }

    get  NoRecords() {
        var isDisplay = true;
        if(this.opencart){
            if(this.opencart.length == 0){
                isDisplay = true;
            }else{
                isDisplay = false;
            }
        }
        return isDisplay;
    }

  

}