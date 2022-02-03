@isTest
public with sharing class BidTrigger_Helper_Test {
  @TestSetup
  static void makeTestData() {
    Product2 p = new Product2(Name='Test Product', Close_Date__c=datetime.newInstance(2022, 2, 2, 7, 0, 0), Minimum_Price__c=100);
    insert p;
  }
  
  /*@isTest
  public static void productNegativeTestCase() {
    // Start Test
    Test.startTest();
    // Query 
    Product2 p = [SELECT Id, Name
                FROM Product2
                WHERE name='Test Product' LIMIT 1];
    // New Bid
    Bid__c item = new Bid__c(Price__c=p.id);
    // Insert
    Database.saveResult sr = Database.insert(item, false);
    // Check if test passed
    System.assert(!sr.isSuccess());
    // Stop Test
    Test.stopTest();
  } 
  
  @isTest
  public static void priceNegativeTestCase() {
    // Start Test
    Test.startTest();
    // Query 
    Product2 p = [SELECT Id, Name
                FROM Product2
                WHERE name='Test Product' LIMIT 1];
    // New Bid
    Bid__c item = new Bid__c(Product__c=p.id);
    // Insert
    Database.saveResult sr = Database.insert(item, false);
    // Check if test passed
    System.assert(!sr.isSuccess());
    // Stop Test
    Test.stopTest();
  }*/
}