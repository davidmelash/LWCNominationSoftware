import { LightningElement, track, api, wire} from 'lwc';
import { tableServiece } from 'c/utils';
import queryContactsByAccountId from '@salesforce/apex/ModeratorListController.queryContactsByAccountId';

export default class BulkCandidateCreation extends LightningElement {
    nextStage = 'Nominations';

    @api campaignId;
    @api idAccount;
    objects;

    @track itemList = [];
    @wire(queryContactsByAccountId, { idAccount: '$idAccount' })
    wiredObject({ error, data }) {
        if (data) {
            this.objects = {data};
            tableServiece.getRecords.call(this);
        } else if (error) {
            this.objects = undefined;
        }
    }
    keyIndex = 0;
   
    

    addRow = tableServiece.addRow.bind(this);
    removeRow = tableServiece.removeRow.bind(this);
    handleSubmit = tableServiece.handleSubmit.bind(this);

    fields = [
    {fieldName: 'FirstName', value: ''}, 
    {fieldName: 'LastName', value: ''},
    {fieldName: 'Email', value: ''},
    {fieldName: 'AccountId', value: ''}]
}
