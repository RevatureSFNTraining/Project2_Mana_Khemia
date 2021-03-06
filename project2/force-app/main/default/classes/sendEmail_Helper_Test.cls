@isTest
public with sharing class sendEmail_Helper_Test {

@TestSetup
    static void makeData(){
        
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
        User u = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard Platform User'].Id,
        LastName = 'last',
        Email = 'vatsalp92@outlook.com',
        Username = 'vatsalp92@outlook.com',
        CompanyName = 'TEST',
        Title = 'title',
        Alias = 'alias',
        TimeZoneSidKey = 'America/Los_Angeles',
        EmailEncodingKey = 'UTF-8',
        LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US',
        UserRoleId = r.Id
        );

        insert u;
    }

    @isTest
    public static void singlePositiveTestCase() {
        Test.startTest();

        User uId =[select Id from User where Username = 'vatsalp92@outlook.com' limit 1];
            User user =[select Blocked__c from User where Id =: uId.Id limit 1];  
            user.Blocked__c = true;

        System.assertEquals(0, Limits.getEmailInvocations(), 'No emails should be sent');
        update user;
        System.assertEquals(1, Limits.getEmailInvocations(), 'Emails should be sent');

        Test.stopTest();
    }

    @isTest
    public static void bulkPositiveTestCase() {
        Test.startTest();

        Integer MAXITEMS = 4;

        List<User> users = new List<User>();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        for (Integer i = 0; i < MAXITEMS; i++) {
            User u = new User(
            LastName = 'last',
            Email = 'vatsalp92@outlook.com',
            Username = 'vatsalp92@outlook.com' + i,
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = P.id,
            Blocked__c = true
        ); 
            users.add(u);
        }

        System.assertEquals(0, Limits.getEmailInvocations(), 'No emails should be sent');
        insert users;
        System.assertEquals(1, Limits.getEmailInvocations(), 'Emails should be sent');

        Test.stopTest();
    } 

}