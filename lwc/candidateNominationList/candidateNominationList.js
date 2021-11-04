import { LightningElement, api, wire, track} from 'lwc';
import searchNominees from '@salesforce/apex/CandidateListController.searchNominees';
import checkVoteDuplicate from '@salesforce/apex/CandidateListController.checkVoteDuplicate';
import getUserContactId from '@salesforce/apex/CandidateListController.getUserContactId';
import { createRecord, deleteRecord} from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import CANDIDATE_FIELD from '@salesforce/schema/Vote__c.Candidate__c';
import DESCRIPTION_FIELD from '@salesforce/schema/Vote__c.Description__c';
import VOTER_FIELD from '@salesforce/schema/Vote__c.Voter__c';
import VOTE_OBJECT from '@salesforce/schema/Vote__c';


export default class CandidateNominationList extends LightningElement {
    @api nominationId;
    nominees;
    nomineeId;
    // voterId = '0030900000ZxmlsAAB'; // for tests
    searchTerm = ''

    
    @wire(searchNominees, { nominationId: '$nominationId', searchTerm: '$searchTerm'})
    wiredObject(result) {
        if (result) {
            this.nominees = result;
        }
    }

    handleSearchTermChange(event) {
		// Debouncing this method: do not update the reactive property as
		// long as this function is being called within a delay of 300 ms.
		// This is to avoid a very large number of Apex method calls.
		window.clearTimeout(this.delayTimeout);
		const searchTerm = event.target.value;
		// eslint-disable-next-line @lwc/lwc/no-async-operation
		this.delayTimeout = setTimeout(() => {
			this.searchTerm = searchTerm;
		}, 300);
	}


    closeNomineeList(){
        this.dispatchEvent(new CustomEvent('close'));
    }


    handleCheck(event){
        this.template.querySelectorAll('lightning-input').forEach(input => {
            input.checked = event.target.name === input.name
            
        } );
        this.nomineeId = event.target.name;
    }


    async handleSave(){
        let voterId = await getUserContactId();
        let voteRecordId = await this.getVoteId();
        let successfulVoteMessage = 'Vote created'
        const fields = {};
        fields[CANDIDATE_FIELD.fieldApiName] = this.nomineeId;
        fields[DESCRIPTION_FIELD.fieldApiName] = 'Lorem Ipsum is simply dummy text of the printing and typesetting industry';
        fields[VOTER_FIELD.fieldApiName] = voterId;
        const recordInput = { apiName: VOTE_OBJECT.objectApiName, fields };

        if(voteRecordId){
            await deleteRecord(voteRecordId).then(()=> console.log('Deleted'));
            successfulVoteMessage = 'Vote updated'
        }
        this.createVoteRecord(recordInput, successfulVoteMessage);
    }

    async getVoteId(voterId){
        
        let voteRecordId = await checkVoteDuplicate({nominationId: this.nominationId, voterId: voterId}).then(result => {
            if(result){
                return result[0].Id;
            }
        })
        .catch(error => {
            this.error = error;
        });
        return voteRecordId;
    }



    createVoteRecord(recordInput, message){
        createRecord(recordInput)
            .then(() => {
                
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: message,
                        variant: 'success',
                    }),
                );
                this.closeNomineeList();
            }
            
            )
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });
    }
}