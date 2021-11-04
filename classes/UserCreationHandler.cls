public class UserCreationHandler {
    public void createUser(List<Contact> contacts) {
        List<User> newUsers = new List<User>();

        for(Contact cont: contacts){
            string nickname = cont.FirstName.substring(0, 1) + cont.LastName;

            User u = new User();
            u.FirstName = cont.FirstName;
            u.LastName = cont.LastName;
            u.Email = cont.Email;
            u.Alias = nickname.abbreviate(8); // only 8 characters
            u.Username = cont.lastName + cont.Email;
            u.CommunityNickname = nickname.abbreviate(40);
            u.TimeZoneSidKey = 'Europe/London';
            u.LocaleSidKey = 'en_US';
            u.LanguageLocaleKey = 'en_US';
            u.profileId = '00e09000000qzIaAAI';
            u.EmailEncodingKey = 'UTF-8';
            u.ContactId = cont.Id;
            u.IsActive = true;

            newUsers.add(u);
        }
        
        Database.SaveResult[] userList = Database.insert(newUsers, false);
        List<Id> users = new List<Id>();

        Id permissionSetId = '0PS09000007kklpGAA'; // Custom_Candidate_Community_Plus
        for(Database.SaveResult u: userList){
            if (u.isSuccess()) {

                // Operation was successful, so get the ID of the record that was processed
                users.add(u.getId());
                
            } else {
                // Operation failed, so get all errors
                for(Database.Error err : u.getErrors()) {
                    System.debug('The following error has occurred.');
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Contact fields that affected this error: ' + err.getFields());
                }
            }
        }

        setPermissionSet(permissionSetId, users);
    }

    @future
    public static void setPermissionSet(Id myPermissionSetId, List<Id> userList){
        List<PermissionSetAssignment> newAssignments = new List<PermissionSetAssignment>();

        for(Id userId: userList){

            PermissionSetAssignment psa = new PermissionSetAssignment
            (PermissionSetId = myPermissionSetId, AssigneeId = userId);

            newAssignments.add(psa);
                
        }

        insert newAssignments;
    }
    
}
