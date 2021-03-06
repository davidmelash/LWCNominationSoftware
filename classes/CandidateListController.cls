public without sharing class CandidateListController {
    @AuraEnabled(cacheable=true)
    public static List<Campaign> getCampaigns() {
        Date currentDate = date.today();
        Id userId = getCurrentUserId();
        User currentUser = [SELECT CompanyName FROM User WHERE Id = :userId];

        return [
            SELECT Name, StartDate, EndDate
            FROM Campaign
            WHERE EndDate >= :currentDate AND IsActive = true AND Stage__c = 'Vote' 
            AND Company__r.Name = :currentUser.CompanyName
            ORDER BY Name
        ];
    }
    @AuraEnabled(cacheable=true)
    public static List<Nomination__c> getNominations(Id campaignId) {
        return [
            SELECT Name
            FROM Nomination__c
            WHERE Campaign__c = :campaignId
        ];
    }
    @AuraEnabled(cacheable=true)
    public static List<CandidateNomination__c> getAllNominees(Id nominationId) {
        return [
            SELECT FullName__c,Nominee__r.FirstName, Nominee__r.LastName, Nomination__r.Name, Description__c
            FROM CandidateNomination__c
            WHERE Nomination__c = :nominationId
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<CandidateNomination__c> searchNominees(Id nominationId, String searchTerm) {
        searchTerm = searchTerm.trim();
        if (searchTerm == '') {
            return getAllNominees(nominationId);
        }
        // Prepare query paramters
        searchTerm = '%' + searchTerm + '%';

        return [
            SELECT Nominee__r.FirstName, Nominee__r.LastName, Nomination__r.Name, Description__c
            FROM CandidateNomination__c
            WHERE Nomination__c = :nominationId AND FullName__c LIKE :searchTerm
        ];
    }


    @AuraEnabled
    public static List<Vote__c> checkVoteDuplicate(Id nominationId, Id voterId) {
        List<Vote__c> record = [
            SELECT ID
            FROM Vote__c
            WHERE Candidate__r.Nomination__c =:nominationId AND Voter__c = :voterId
        ];
        return record;
    }

    public static Id getCurrentUserId() {
        return UserInfo.getUserId();
    }
    
    @AuraEnabled
    public static Id getUserContactId(){
        Id userId = getCurrentUserId();
        User currentUser = [SELECT ContactId FROM User WHERE Id = :userId];
        return currentUser.ContactId;
    }


}
