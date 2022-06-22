import { LightningElement, wire, api, track} from 'lwc';
import getOrderLists from '@salesforce/apex/Orderlistcontroller.getOrderLists';
//import OrderList from '@salesforce/apex/OrderList.getOrderList';


export default class OrderListComponent extends LightningElement {

    @api recordId;

    @track loader = false;
    @track error = null;
    @track pageSize = 10;
    @track pageNumber = 1;
    @track totalRecords = 0;
    @track totalPages = 0;
    @track recordEnd = 0;
    @track recordStart = 0;
    @track isPrev = true;
    @track isNext = true;
    @track orders = [];

    @track columns =[
        {label:'Name' ,fieldName: 'Name',sortable:false,
        innerWidth:130,cellAttributes:{alignment:'left'}},
    
        {label:'Status' ,fieldName: 'Status__c',sortable:false,
        innerWidth:130,cellAttributes:{alignment:'left'}},
    
        {label:'Order Date' ,fieldName: 'Order_Date__c',sortable:false,
        innerWidth:130,cellAttributes:{alignment:'left'}},
    
        {label:'Expected Delivery Date' ,fieldName: 'Expected_Delivery_Date__c',sortable:false,
        innerWidth:130,cellAttributes:{alignment:'left'}},
    
        {label:'Delivered Date' ,fieldName: 'Delivered_Date__c',sortable:false,
        innerWidth:130,cellAttributes:{alignment:'left'}}
    ];

    connectedCallback() {
        this.getAccounts();
    }

    handleNext(){
        this.pageNumber = this.pageNumber+1;
        this.getAccounts();
    }
 
    //handle prev
    handlePrev(){
        this.pageNumber = this.pageNumber-1;
        this.getAccounts();
    }
    
   

    getAccounts(){
        this.loader = true;
        
        console.log("inside get acccount 1"+this.pageSize);
        console.log("1inside get acccount 2"+this.pageNumber);
        console.log("1inside get acccount 2 customerId: "+ this.recordId);
      
        getOrderLists({pageSize:this.pageSize,pageNumber:this.pageNumber,customerId:this.recordId}) 

        .then(result => {
           // console.log("1333331"+customerId);
            this.loader = false;
            if(result){
                var resultData = JSON.parse(result);
                this.orders = resultData.orders;
                this.pageNumber = resultData.pageNumber;
                this.totalRecords = resultData.totalRecords;
                this.recordStart = resultData.recordStart;
                this.recordEnd = resultData.recordEnd;
                this.totalPages = Math.ceil(resultData.totalRecords / this.pageSize);
                this.isNext = (this.pageNumber == this.totalPages || this.totalPages == 0);
                this.isPrev = (this.pageNumber == 1 || this.totalRecords < this.pageSize);
                // console.log("1111111"+this.orders);
                // console.log("1111112"+this.pageNumber);
                // console.log("1222222"+this.totalRecords);
                // console.log("133333"+this.recordStart);
                // console.log("333331"+this.recordEnd);
                // console.log("14444"+this.isNext);
                console.log("1444444"+this.isPrev);
            }
        })
        .catch(error => {
            this.loader = false;
            this.error = error;
        });
    }

     //display no records
     get isDisplayNoRecords() {
        var isDisplay = true;
        if(this.orders){
            if(this.orders.length == 0){
                isDisplay = true;
            }else{
                isDisplay = false;
            }
        }
        return isDisplay;
    }

   

   

}
   
    //