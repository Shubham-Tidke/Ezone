import { LightningElement, wire, api } from 'lwc';
import { getRelatedListRecords } from 'lightning/uiRelatedListApi';

const COLUMNS = [   
    { label: 'Name', fieldName: 'Name' },
    { label: 'Email', fieldName: 'Email' }
];
export default class GetContacts extends LightningElement {

    @api recordId;
    recordCount;
    records;
    columns = COLUMNS;

    @wire( getRelatedListRecords, {

        parentRecordId: '$recordId',
        relatedListId: 'Contacts',
        fields: [ 'Contact.Id', 'Contact.Name', 'Contact.Email' ]

    } )listInfo( { error, data } ) {

        if ( data ) {

            console.log( 'Data is', JSON.stringify( data ) );
            let tempRecords = [];

            data.records.forEach( obj => {

                console.log( 'obj is', JSON.stringify( obj ) );
                let tempRecord = {};
                tempRecord.Id = obj.fields.Id.value;
                tempRecord.Name = obj.fields.Name.value;
                tempRecord.Email = obj.fields.Email.value;
                tempRecords.push( tempRecord );

            } );
            this.records = tempRecords;
            this.recordCount = data.count;
            console.log( 'Records are ' + JSON.stringify( this.records ) );
            
        } else if (error) {
            
            this.records = undefined;

        }
    }
 
}