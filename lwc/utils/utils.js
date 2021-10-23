import ID_FIELD from '@salesforce/schema/Campaign.Id';
import STAGE_FIELD from '@salesforce/schema/Campaign.Stage__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { updateRecord, deleteRecord } from "lightning/uiRecordApi";

function addRow() {
        ++this.keyIndex;
        var newItem = { id: this.keyIndex,
                        recordId: '',
                        fields: this.fields};
        this.itemList.push(newItem);
    }

function removeRow(event) {
        if (this.itemList.length >= 2) {
            --this.keyIndex;
            this.itemList = this.itemList.filter(function (element) {
                if(parseInt(element.id) === parseInt(event.target.accessKey)){
                    if(element.recordId){
                        deleteRecord(element.recordId)

                    }
                    return false;
                }
                return true;
            });
        }
    }

function handleSubmit() {
        var isVal = true;
        this.template.querySelectorAll('lightning-input-field').forEach(element => {
            isVal = isVal && element.reportValidity();
        });
        if (isVal) {
            this.template.querySelectorAll('lightning-record-edit-form').forEach(element => {
                element.submit();
            });
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Successfully created/updated',
                    variant: 'success',
                }),
            );
            
            // update stage
            const fields = {};
            fields[ID_FIELD.fieldApiName] = this.campaignId;
            fields[STAGE_FIELD.fieldApiName] = this.nextStage;
            const recordInput = {
                fields
                };
        
            updateRecord(recordInput)

        } else {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error creating/updating record',
                    message: 'Please enter all the required fields',
                    variant: 'error',
                }),
            );
        }
    }

function getRecords(){

        for (const key in this.objects.data) {

            let newItem = {
                id : parseInt(key) + 1,
                recordId : this.objects.data[key].Id,
                fields : []
            };
            let i = 0;
            let len = Object.keys(this.objects.data[key]).length;
            for (const field in this.objects.data[key]) {
                if (i < len-1){
                    let newField = {
                        fieldName: field,
                        value: this.objects.data[key][field]
                    }
                    newItem.fields.push(newField);
                    
                }
                i++;
            }
            ++this.keyIndex;
            this.itemList.push(newItem);
        }
}

const tableServiece = {
    addRow,
    removeRow,
    handleSubmit,
    getRecords
}
export {tableServiece};