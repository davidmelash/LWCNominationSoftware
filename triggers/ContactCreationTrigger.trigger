trigger ContactCreationTrigger on Contact (after insert) {
    UserCreationHandler userCreation = new UserCreationHandler();
    userCreation.createUser(Trigger.new);

}
    