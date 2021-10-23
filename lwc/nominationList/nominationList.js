import { LightningElement, api, wire} from 'lwc';
import getNominations from '@salesforce/apex/CandidateListController.getNominations';



export default class NominationList extends LightningElement {
    @api campaignId;
    nominations;
    nominationId;
    showCandidateNomination = false;


    @wire(getNominations, { campaignId: '$campaignId' })
    wiredObject({ error, data }) {
        if (data) {
            this.nominations = data;
        } else if (error) {
            // this.error = error;
            this.nominations = undefined;
        }
    }

    closeModal(){
        this.dispatchEvent(new CustomEvent('close'));
    }

    showCandidateNominationList(event){
        this.nominationId = `${event.target.id}`.slice(0,18);
        this.showCandidateNomination= true;
    }

    closeCandidateNominationList(){
        this.showCandidateNomination = false;
    }
    

    handleNomineeId(event){
        this.nomineeId = event.detail.nomineeId;
    }


    
}