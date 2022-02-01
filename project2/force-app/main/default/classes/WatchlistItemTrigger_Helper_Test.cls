@isTest
public with sharing class WatchlistItemTrigger_Helper_Test {
    @TestSetup
    static void makeData(){
        Product2 prod = new Product2(Name='Test Product', Close_Date__c=datetime.newInstance(2022, 2, 1, 12, 0, 0), Minimum_Price__c=100);
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', ProfileId = p.Id,
                            TimeZoneSidKey='America/Los_Angeles',
                            UserName='standarduser' + DateTime.now().getTime() + '@testorg.com');

        insert prod;
        insert u;
    }

    @isTest
    public static void singlePositiveTestCase() {
        Test.startTest();

        User user = [SELECT Id, Name, Email
                    FROM User 
                    WHERE LastName='Testing' LIMIT 1];
        Product2 prod = [SELECT Id, Name
                    FROM Product2
                    WHERE name='Test Product' LIMIT 1];

        Watchlist_Item__c item = new Watchlist_Item__c(Name='test item', User__c=user.id, Product__c=prod.id);

        System.assertEquals(0, Limits.getEmailInvocations(), 'No emails should be sent');
        insert item;
        System.assertEquals(1, Limits.getEmailInvocations(), 'Emails should be sent');

        Test.stopTest();
    }

    @isTest
    public static void bulkPositiveTestCase() {
        Test.startTest();

        User user = [SELECT Id, Name, Email
                    FROM User 
                    WHERE LastName='Testing' LIMIT 1];
        Product2 prod = [SELECT Id, Name
                    FROM Product2
                    WHERE name='Test Product' LIMIT 1];

        Integer MAX_ITEMS = 9;
        List<Watchlist_Item__c> items = new List<Watchlist_Item__c>();

        for (Integer i = 0; i < MAX_ITEMS; i++) {
            Watchlist_Item__c item = new Watchlist_Item__c(Name='test item: ' + i, User__c=user.id, Product__c=prod.id);
            items.add(item);
        }

        System.assertEquals(0, Limits.getEmailInvocations(), 'No emails should be sent');
        insert items;
        System.assertEquals(1, Limits.getEmailInvocations(), 'Emails should be sent');

        Test.stopTest();
    }

    @isTest
    public static void userNegativeTestCase() {
        
        Test.startTest();

        Product2 prod = [SELECT Id, Name
                    FROM Product2
                    WHERE name='Test Product' LIMIT 1];

        Watchlist_Item__c item = new Watchlist_Item__c(Name='test item', Product__c=prod.id);

        System.assertEquals(0, Limits.getEmailInvocations(), 'No emails should be sent');
        Database.saveResult sr = Database.insert(item, false);
        System.assert(!sr.isSuccess());
        System.assertEquals(0, Limits.getEmailInvocations(), 'No emails should be sent');

        Test.stopTest();
    }

    @isTest
    public static void productNegativeTestCase() {
        
        Test.startTest();

        User user = [SELECT Id, Name, Email
                    FROM User 
                    WHERE LastName='Testing' LIMIT 1];

        Watchlist_Item__c item = new Watchlist_Item__c(Name='test item', User__c=user.id);

        System.assertEquals(0, Limits.getEmailInvocations(), 'No emails should be sent');
        Database.saveResult sr = Database.insert(item, false);
        System.assert(!sr.isSuccess());
        System.assertEquals(0, Limits.getEmailInvocations(), 'No emails should be sent');

        Test.stopTest();
    }
}
