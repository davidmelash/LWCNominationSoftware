import { LightningElement, track, wire, api } from 'lwc';
import { tableServiece } from 'c/utils';
import queryNominationsByCampaignId from '@salesforce/apex/ModeratorListController.queryNominationsByCampaignId';
export default class BulkNominationCreation extends LightningElement {
    nextStage = 'Nominees';
    @api campaignId;
    objects;
    @api campaignName;

    @wire(queryNominationsByCampaignId, { campaignId: '$campaignId' })
    wiredObject({ error, data }) {
        if (data) {
            this.objects = {data};
            tableServiece.getRecords.call(this);
        } else if (error) {
            // this.error = error;
            this.objects = undefined;
        }
    }

    fields = [{fieldName: 'Name', value: ''}]
    keyIndex = 0;
    @track itemList = [];
    
    addRow = tableServiece.addRow.bind(this);
    removeRow = tableServiece.removeRow.bind(this);
    handleSubmit = tableServiece.handleSubmit.bind(this);

}
