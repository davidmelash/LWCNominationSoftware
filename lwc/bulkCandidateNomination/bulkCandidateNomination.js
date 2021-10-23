import { LightningElement, track, wire, api} from 'lwc';
import { tableServiece } from 'c/utils';
import queryCandidatesNominationByCampaignId from '@salesforce/apex/ModeratorListController.queryCandidatesNominationByCampaignId';
export default class BulkCandidateNomination extends LightningElement {
    nextStage = 'Vote';
    @api campaignId;
    objects;

    
    @wire(queryCandidatesNominationByCampaignId, { campaignId: '$campaignId' })
    wiredObject({ error, data }) {
        if (data) {
            this.objects = {data};
            tableServiece.getRecords.call(this);
        } else if (error) {
            // this.error = error;
            this.objects = undefined;
        }
    }

    fields = [
        {fieldName: 'Nominee__c', value: ''}, 
        {fieldName: 'Nomination__c', value: ''}
    ]
    keyIndex = 0;
    @track itemList = [];

    addRow = tableServiece.addRow.bind(this);
    removeRow = tableServiece.removeRow.bind(this);
    handleSubmit = tableServiece.handleSubmit.bind(this);

}
