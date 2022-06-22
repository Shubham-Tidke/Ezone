import { LightningElement, wire, api, track } from 'lwc';
import E_Zone_logos from '@salesforce/resourceUrl/E_Zone_logos';
import { NavigationMixin } from 'lightning/navigation';

const TILE_WRAPPER_SELECTED_CLASS = "tile-wrapper selected";
const TILE_WRAPPER_UNSELECTED_CLASS= "tile-wrapper";

export default class NewProductLists extends LightningElement {

    @track productId;
    @track error;
    @track productImage;
    @track redirect;
    @api product;

    get backgroundStyle() { 
        console.log(this.product);
        if(null!=this.product.Product_Images__r && undefined!=this.product.Product_Images__r){
                  this.productImage=this.product.Product_Images__r[0].ResourceURL__c;
            }
        else{
               this.productImage=E_Zone_logos+'/E_Zone_logo.png';
        }
            return `background-image:url(${this.productImage})`;   
         }
    

    selectProduct(){}

    get tileClass() { 
        console.log('product is'+this.product);
        this.productId==this.product.Id ? TILE_WRAPPER_SELECTED_CLASS : TILE_WRAPPER_UNSELECTED_CLASS;
        this.redirect = "https://eorderzone-developer-edition.ap26.force.com/s/product-detail-page?Id="+this.product.Id;
        return this.productId;

    }
}