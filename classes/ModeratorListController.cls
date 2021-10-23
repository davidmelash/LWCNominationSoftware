public with sharing class ModeratorListController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> queryContactsByAccountId(Id idAccount) {
        return [
            SELECT FirstName, LastName, Email, AccountId
            FROM Contact
            WHERE AccountId = :idAccount
            
        ];
    }
    @AuraEnabled(cacheable=true)
    public static List<Nomination__c> queryNominationsByCampaignId(Id campaignId) {
        return [
            SELECT Name
            FROM Nomination__c
            WHERE Campaign__c = :campaignId
        ];
    }
    @AuraEnabled(cacheable=true)
    public static List<CandidateNomination__c> queryCandidatesNominationByCampaignId(Id campaignId) {
        return [
            SELECT Nominee__c, Nomination__c
            FROM CandidateNomination__c
            WHERE Nomination__r.Campaign__c = :campaignId
        ];
    }
}
