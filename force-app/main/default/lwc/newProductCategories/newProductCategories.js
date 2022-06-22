import { LightningElement, api, track, wire} from 'lwc';
import getParentCategories from '@salesforce/apex/GenericObjectFetcher.getParentCategories';

export default class NewProductCategories extends LightningElement {

    selectedCategoryId='';

    @track searchOptions=[];
    @track error;

    @wire(getParentCategories)
    getCategories({data,error}){
       if(data){
        console.log(JSON.stringify(data));
        console.log('length'+data.length)
        this.searchOptions = data.map(type => {
           return  {
              label:type.Name,
              value: type.Id
            }
          });
       }else if(error){
        this.searchOptions=undefined;
        this.error=error;
       }
        
    }
    

    handleSearchOptionChange(event){
        this.selectedCategoryId=event.detail.value;
        const searchEvent=new CustomEvent('search',{
            detail:{categoryId:this.selectedCategoryId}
        })
        this.searchCategory(event);
        //this.dispatchEvent(searchEvent);
    }

    searchCategory(event){
        let catId=event.detail.value;
        console.log('==================================================================');
        console.log('category Id is'+catId);
        console.log('==================================================================');
        this.template.querySelector('c-product-category-search-result').searchCategory(catId);
        
    }
}