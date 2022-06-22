public class FetchUserId {
    @AuraEnabled
    public static Id ConvertId(String rId){
   		User currentUser = [SELECT Id FROM User WHERE Id = :rId];
        String s15digitId=String.valueof(currentUser.Id).substring(0,15);
        System.debug('15digitId '+s15digitId);
        return s15digitId;
    }
}