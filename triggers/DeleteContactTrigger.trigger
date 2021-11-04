trigger DeleteContactTrigger on Contact (before delete) {
    DeleteContactHandler handler = new DeleteContactHandler();
}
