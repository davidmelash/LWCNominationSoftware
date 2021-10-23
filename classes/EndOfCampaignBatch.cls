public class EndOfCampaignBatch implements
    Database.Batchable<SObject>, Database.Stateful {
        public Integer recordsProcessed = 0;

        private Id campaignId;
        private String emailBody;
        private String campaignName;

        public EndOfCampaignBatch(Id campaignIdParam, String campaignNameParam) {
            campaignId = campaignIdParam;
            campaignName = campaignNameParam;
            emailBody = GetDataForMailBody.getData(campaignIdParam);
        }

        public Database.QueryLocator start(Database.BatchableContext bc){
            return Database.getQueryLocator([SELECT FirstName, LastName, Email 
                                            FROM Contact 
                                            WHERE AccountId in (SELECT Company__c FROM Campaign WHERE Id = :campaignId)]);
        }
        
        public void execute(Database.BatchableContext bc, List<Contact> scope){
            List<Contact> contacts = new List<Contact>();
            String body = '';
            for(Contact cont: scope){
                body = 'Dear ' + cont.FirstName + ' ' + cont.LastName +
                    '\nWe\'re glad to inform you that campaign ' + campaignName + ' has ended!\n' + emailBody; 

                EmailManager.sendMail(cont.Email, 'End Of ' + campaignName, body);
                body = '';
                recordsProcessed++;
            }

        }
        public void finish(Database.BatchableContext bc){
            System.debug(recordsProcessed + ' records processed. Shazam!');
        }
    }


