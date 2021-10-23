public class GetDataForMailBody {
    public static String getData(Id campaignId){
        List<CandidateNomination__c> scope = new List<CandidateNomination__c>();
        String result = '';

        for(sObject obj : [SELECT Nomination__r.Name, MAX(VotesTotal__c) FROM CandidateNomination__c WHERE Nomination__r.Campaign__c = :campaignId GROUP BY Nomination__r.Name]){
            String nominationName = String.valueOf(obj.get('Name'));
            Integer totalVotes = Integer.valueOf(obj.get('expr0'));
            scope.addAll([SELECT FullName__c,Nomination__r.Name, VotesTotal__c 
                            FROM CandidateNomination__c 
                            WHERE Nomination__r.Name = :nominationName 
                            AND VotesTotal__c = :totalVotes AND Nomination__r.Campaign__c = :campaignId]);
        }
        String previousNomination = '';
        for(CandidateNomination__c canNom: scope){
            If(previousNomination != canNom.Nomination__r.Name){
                result = result + canNom.Nomination__r.Name + ':\n\t' + canNom.FullName__c + ' ( ' + canNom.VotesTotal__c + ' votes )\n';
                previousNomination = canNom.Nomination__r.Name;
            }else{
                result = result + '\t' + canNom.FullName__c + ' ( ' + canNom.VotesTotal__c + ' votes )\n';
            }
        }
        return result;
    }
}