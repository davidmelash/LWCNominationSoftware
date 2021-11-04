trigger NewVoteTrigger on Vote__c (before insert, before update) {

    Vote__c userVote = trigger.new[0];
    
    List<Vote__c> record = [SELECT Id
                            FROM Vote__c 
                            WHERE Voter__c = :userVote.Voter__c AND Candidate__r.Nomination__c = :userVote.Candidate__r.Nomination__c];
    
    If(record.isEmpty() == false){
        userVote.addError('You can only vote one time per nomination!');
    }
}
