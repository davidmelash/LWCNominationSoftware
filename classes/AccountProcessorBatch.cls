public class AccountProcessorBatch implements
    Database.Batchable<SObject>, Database.Stateful {
        public Integer recordsProcessed = 0;

        private String phoneNumber;

        public AccountProcessorBatch(String phoneParam) {
            phoneNumber = phoneParam;
        }

        public Database.QueryLocator start(Database.BatchableContext bc){
            return Database.getQueryLocator([SELECT Id, (SELECT Id FROM Contacts ) FROM Account WHERE Phone LIKE :phoneNumber]);
        }
        
        public void execute(Database.BatchableContext bc, List<Account> scope){
            List<Contact> contacts = new List<Contact>();

            for(Account acc : scope){
                for(Contact cont : acc.Contacts){
                    cont.Description = 'Contact was updated';
                    contacts.add(cont);
                    recordsProcessed++;
                }
                
            }

            try {
                update contacts;
            } catch (DmlException e) {
                String errorMessage = e.getMessage();

                System.debug('Smth went wrong. The following exception has occurred: ' + errorMessage);
                EmailManager.sendMail('doctest327284@gmail.com', 'DML Exception in AccountProcessorBatch', errorMessage);
            }
            
        }
        public void finish(Database.BatchableContext bc){
            System.debug(recordsProcessed + ' records processed. Shazam!');
        }
    }
