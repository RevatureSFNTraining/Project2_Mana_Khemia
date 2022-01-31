@isTest
public with sharing class sendEmail_Helper_Test {
    @isTest
    public static void positiveTestCase() {
        User u = new User(
     LastName = 'last',
     Email = 'puser000@amamama.com',
     Username = 'puser000@amamama.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Title = 'title',
     Alias = 'alias',
     Status__c = true
);
        Database.saveResult sr = Database.insert(u, false);
        Database.saveResult s = Database.update(u, false);
                system.assert(sr.isSuccess());
                system.assert(s.isSuccess());
    }
} 
