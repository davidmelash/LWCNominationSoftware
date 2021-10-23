import { LightningElement, api, wire, track} from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import STAGE_FIELD from '@salesforce/schema/Campaign.Stage__c';
import COMPANY_FIELD from '@salesforce/schema/Campaign.Company__c';
import NAME_FIELD from '@salesforce/schema/Campaign.Name';
const campaignFields = [STAGE_FIELD, COMPANY_FIELD, NAME_FIELD];
export default class ParentComponent extends LightningElement {
    @api recordId;
    @wire(getRecord, { recordId: '$recordId', fields: campaignFields})
    campaign;

    get getIdAccount(){
        return getFieldValue(this.campaign.data, COMPANY_FIELD);
    }

    get getCampaignName(){
        return getFieldValue(this.campaign.data, NAME_FIELD);
    }

    get isCandidates(){
        return this.currentStage() === 'Candidates';
    }
    get isNominatios(){
        return this.currentStage() === 'Nominations';
    }
    get isNominees(){
        return this.currentStage() === 'Nominees';
    }

    get isVote(){
        return this.currentStage() === 'Vote';
    }

    currentStage() {
        return getFieldValue(this.campaign.data, STAGE_FIELD);
    }

}