trigger CreateUserTrigger on Contact (after insert) {
    if(Trigger.isInsert){
        CreateUserTriggerHandler.NewUser(Trigger.new);
    }
}