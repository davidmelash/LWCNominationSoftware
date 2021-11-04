public class DeleteContactHandler {
    public void handlTrigger() {
        Id userId = Trigger.old[0].Id;
        deleteCandidateNomination(userId);
        disableUser(userId);
    }

    public void deleteCandidateNomination(Id userId){
        List<CandidateNomination__c> candidate = [SELECT Id FROM CandidateNomination__c WHERE Nominee__c = :userId];
        
        if(candidate.size() > 0){
            delete candidate;
        }
    }

    @future
    public static void disableUser(Id userId){
        List<User> currentUser = [SELECT IsActive FROM User WHERE ContactId = :userId];
        If(currentUser.isEmpty() == false){
            currentUser[0].IsActive = false;
            update currentUser;
        }
    }
}
