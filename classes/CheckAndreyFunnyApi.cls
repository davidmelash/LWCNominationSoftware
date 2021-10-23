public class CheckAndreyFunnyApi {

    public static void insertNewAccount(String yourName){
        Account acc = new Account(Name=yourName);

        insert acc;
        updateAccountName(acc.Id, yourName);
    }


    @future(callout=true)
    public static void updateAccountName(ID idAccount, String accountName) {

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://andreydevelopment-developer-edition.ap5.force.com/services/apexrest/updatename?name='+ accountName);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse response.
        if(response.getStatusCode() == 200) {
            List<Account> acc = [SELECT Id FROM Account WHERE Id = :idAccount];

            if (acc.isEmpty()){
                EmailManager.sendMail('doctest327284@gmail.com', 'Query result is empty in CheckAndreyFunnyApi', 
                '[SELECT Id FROM Account WHERE Id = :idAccount] didn\'t find any Account record with id: ' + String.valueOf(idAccount));

            } else {
                
                String resultOfRequest = response.getBody();
                acc[0].Name = resultOfRequest;
                
                try {
                    update acc;
                } catch (DmlException e) {
                    String errorMessage = e.getMessage();
    
                    System.debug('Smth went wrong. The following exception has occurred: ' + errorMessage);
                    EmailManager.sendMail('doctest327284@gmail.com', 'DML Exception in CheckAndreyFunnyApi', errorMessage);
                }
            }

            
        }

        else {
            String statusCode = String.valueOf(response.getStatusCode());
            System.debug('Status code: ' + statusCode);
            EmailManager.sendMail('doctest327284@gmail.com', 'HTTP response status code is not 200', 'Status code: ' + statusCode);
            
        }

    }
}


