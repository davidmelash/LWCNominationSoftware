
import { LightningElement, wire } from 'lwc';
import CAMPAIGN_NAME from '@salesforce/schema/Campaign.Name';
import ENDDATE from '@salesforce/schema/Campaign.EndDate';
import STARTDATE from '@salesforce/schema/Campaign.StartDate';
import getCampaigns from '@salesforce/apex/CandidateListController.getCampaigns';

const COLUMNS = [
    {label: 'Name', fieldName: CAMPAIGN_NAME.fieldApiName, type: 'text'},
    {label: 'End date', fieldName: ENDDATE.fieldApiName, type: 'date'},
    {label: 'Start date', fieldName: STARTDATE.fieldApiName, type: 'date'}
];


export default class CampaignList extends LightningElement {
    columns = COLUMNS;
    campaigns;
    error;
    bShowModal = false;
    campaignId;

    
    @wire(getCampaigns)
    wiredObject({ error, data }) {
        if (data) {
            this.campaigns = data;
            console.log(this.campaigns)
        } else if (error) {
            this.error = error;
            this.objects = undefined;
        }
    }

    
    // JS function to open modal window by setting property as true
    openModal(event){
       this.campaignId = `${event.target.id}`.slice(0,18);
       this.bShowModal = true;
       
     }
 
     // JS function to close modal window by setting property as false 
     handleCloseModal(){
       this.bShowModal = false;
     }
    
    
}
