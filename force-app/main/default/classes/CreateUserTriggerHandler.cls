public with sharing class CreateUserTriggerHandler {
    public static void NewUser(List<Contact> contacts){
        for(Contact co : contacts){
            Contact con = [select id,email,firstName,lastname,phone, title, accountId,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry from Contact where Id =:co.Id];
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.EmailHeader.triggerUserEmail = false;
            dmo.EmailHeader.triggerOtherEmail = false;
            dmo.EmailHeader.triggerAutoResponseEmail = false;
            dmo.optAllOrNone = false;
            
            string nick = con.email!=null?con.email.substring(0, con.email.indexOf('@')):'';
            nick += Datetime.now().getTime();
            User newUser1 = new User(
                email = con.email, 
                emailencodingkey = 'UTF-8', 
                firstname = con.firstName, 
                lastname = con.lastname, 
                languagelocalekey = 'en_US',
                localesidkey = 'en_US',
                contactId = con.Id,
                timezonesidkey = 'America/Los_Angeles',
                username = con.email+con.LastName,
                ProfileId =[Select Id from Profile where Name = 'EZone CCU'].Id, 
                Phone=con.Phone,
                Title=con.Title,
                alias=(con.lastname).substring(0,3),
                IsActive = true,
                Street = con.MailingStreet,
                City = con.MailingCity,
                State = con.MailingState,      
                PostalCode = con.MailingPostalCode,
                Country = con.MailingCountry);
            
            newUser1.setOptions(dmo);
            insert newUser1;
        }
    }
}