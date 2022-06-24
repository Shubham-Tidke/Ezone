// import { LightningElement,api,track,wire } from 'lwc';
// import getRecentOrders from '@salesforce/apex/OpenCart.getRecentOrders';
// import User_ID from '@salesforce/user/Id';

// export default class RecentOrders extends LightningElement {

//     userId = User_ID;

//     @api recordId;
//     @track error;
//     @track recentorders ;

//  //   console.log('user id ' +this.userId);

  
//     @track columns =[
//         {label:'Name' ,fieldName: 'Name',sortable:false,
//         innerWidth:130,cellAttributes:{alignment:'left'}},

//         {label:'Amount' ,fieldName: 'Amount__c',sortable:false,
//         innerWidth:130,cellAttributes:{alignment:'left'}},
    
//         {label:'Shipping Address' ,fieldName: 'Shipping_Address__c',sortable:false,
//         innerWidth:130,cellAttributes:{alignment:'left'}},

//         {label:'Payment Status' ,fieldName: 'Payment_Status__c',sortable:false,
//         innerWidth:130,cellAttributes:{alignment:'left'}}
//     ];

//     @wire(getRecentOrders,{userId:'$userId'})
//     wiredAccounts({
//         error,
//         data
//     }) {
//         if (data) {
//             console.log("UserId "+ this.userId);
//             this.recentorders = data;
//         } else if (error) {
//             this.error = error;
//         }
//     }

//     get  NoRecords() {
//         var isDisplay = true;
//         if(this.recentorders){
//             if(this.recentorders.length == 0){
//                 isDisplay = true;
//             }else{
//                 isDisplay = false;
//             }
//         }
//         return isDisplay;
//     }

// }