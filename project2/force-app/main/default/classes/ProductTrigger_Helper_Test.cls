// Current code coverage: 57% on Helper, 75% on Trigger
// (mostly due to ConnectApi issues, see closingMessageTest()



@isTest
public without sharing class ProductTrigger_Helper_Test {
    public static Integer numberOfProducts = 10;
    public static User dummySeller = [SELECT Id,Name FROM User WHERE Name = 'Dummy User' LIMIT 1];
    public static User dummyBuyer = [SELECT Id,Name FROM User WHERE Name = 'Dummy Buyer' LIMIT 1];

    @TestSetup
    static void setup() {
        List<Product2> testProducts = new List<Product2>();
        //User dummySeller = [SELECT Id,Name FROM User WHERE Name = 'Dummy User' LIMIT 1];
        for(Integer i = 0; i < numberOfProducts; i++) {
            testProducts.add(new Product2(Name= 'Test Product ' + i, Close_Date__c = DateTime.newInstance(2023, 1, 31, 7, 8, 16), Minimum_Price__c = 100.00, Seller__c = dummySeller.Id));
        }
        insert testProducts;
    }


    @isTest
    static void chatterGroupTest() {
        Product2 testProduct = [SELECT Id,Name FROM Product2 WHERE Name = 'Test Product 0' LIMIT 1];
        String testProductQuery = '%(ID: ' + testProduct.Id + ')';
        CollaborationGroup testProductCG = [SELECT Id,Name,Description FROM CollaborationGroup WHERE Description LIKE :testProductQuery];
        
		System.assertNotEquals(null, testProductCG);
    }
    
    @isTest
    static void batchChatterGroupTest() {
        Integer successes = 0;
        for(Integer i = 0; i < numberOfProducts; i++) {
            String nameQuery = 'Test Product ' + i;
            Product2 testProduct = [SELECT Id,Name FROM Product2 WHERE Name = :nameQuery LIMIT 1];
            String testProductQuery = '%(ID: ' + testProduct.id + ')';
            CollaborationGroup testProductCG = [SELECT Id,Name,Description FROM CollaborationGroup WHERE Description LIKE :testProductQuery];
            
            if(testProductCG != null) {
                successes++;
            }
        }
        System.assertEquals(numberOfProducts, successes);
    }
    
    
    
    
// ConnectAPI methods cannot be used in data siloed tests, so this would require a huge reworking to delete the
// test setup in order to function.    
/*
    @isTest
    static void closingMessageTest() {
        Boolean testSuccess = false;
        Product2 testProduct = [SELECT Id,Name,Close_Date__c FROM Product2 WHERE Name='Test Product 0' LIMIT 1];
        testProduct.Close_Date__c = DateTime.newInstance(1997, 1, 31, 7, 8, 16);
        testProduct.isActive = false;
        String testProductQuery = '%(ID: ' + String.valueOf(testProduct.id) + ')';
        
        Bid__c highestBid = new Bid__c(Product__c = testProduct.id, Bidder__c = dummyBuyer.id, Price__c = 1000.00);
		insert highestBid;
        
		testProduct.Current_Highest_Bid__c = highestBid.id;        
        update testProduct;
        
        
        CollaborationGroup associatedGroup = [SELECT Name,Id,Description FROM CollaborationGroup WHERE Description LIKE :testProductQuery LIMIT 1];
		List<FeedItem> allFeedItems = [SELECT Id,Body,ParentId FROM FeedItem WHERE ParentId = :associatedGroup.Id];
        for(FeedItem fi: allFeedItems) {
            if(fi.Body.contains('The bidding period for this item has now closed.')) {
                testSuccess = true;
            }
        }

		System.assert(testSuccess);
    }

    @isTest
    static void batchClosingMessageTest() {
        Integer successes = 0;
        for(Integer i = 0; i < numberOfProducts; i++) {
            String nameQuery = 'Test Product ' + i;
            Product2 testProduct = [SELECT Id,Name,Close_Date__c FROM Product2 WHERE Name = :nameQuery LIMIT 1];
            testProduct.Close_Date__c = DateTime.newInstance(1997, 1, 31, 7, 8, 16);
            testProduct.isActive = false;
            String testProductQuery = '%(ID: ' + String.valueOf(testProduct.id) + ')';
            
            Bid__c highestBid = new Bid__c(Product__c = testProduct.id, Bidder__c = dummyBuyer.id, Price__c = 1000.00);
			insert highestBid;
        
			testProduct.Current_Highest_Bid__c = highestBid.id; 
            update testProduct;
            
            
            CollaborationGroup associatedGroup = [SELECT Name,Id,Description FROM CollaborationGroup WHERE Description LIKE :testProductQuery LIMIT 1];
            List<FeedItem> allFeedItems = [SELECT Id,Body,ParentId FROM FeedItem WHERE ParentId = :associatedGroup.Id];
            for(FeedItem fi: allFeedItems) {
                if(fi.Body.contains('The bidding period for this item has now closed.')) {
                    successes++;
                }
            }
        }
        
        System.assertEquals(numberOfProducts, successes);
    }
    
*/
    
    
    
    
    @isTest
    static void deletedListingChatterGroupTest() {
        Product2 testProduct = [SELECT Id,Name FROM Product2 WHERE Name = 'Test Product 0' LIMIT 1];
        String testProductQuery = '%(ID: ' + testProduct.id + ')';
        delete testProduct;
        
        CollaborationGroup[] testProductCG = [SELECT Id,Name,Description FROM CollaborationGroup WHERE Description LIKE :testProductQuery];
        
        System.assertEquals(0, testProductCG.size());
    }
    
    @isTest
    static void batchDeletedListingChatterGroupTest() {
        Integer successes = 0;
        for(Integer i=0; i < numberOfProducts; i++) {
            String nameQuery = 'Test Product ' + i;
            Product2 testProduct = [SELECT Id,Name FROM Product2 WHERE Name = :nameQuery LIMIT 1];
            String testProductQuery = '%(ID: ' + String.valueOf(testProduct.id) + ')';
            delete testProduct;
            
            CollaborationGroup[] testProductCG = [SELECT Id,Name,Description FROM CollaborationGroup WHERE Description LIKE :testProductQuery];
            if(testProductCG.size() == 0) {
                successes++;
            }
        }
        
        System.assertEquals(numberOfProducts, successes);
    }
    
    
    
    
    
    
    
    
    
    @isTest
    static void findAssociatedChatterGroupTest() {
        User dummySeller = [SELECT Id,Name FROM User WHERE Name = 'Dummy User' LIMIT 1];
        Product2 testProduct = new Product2(Name= 'Test Product (AG Test)', Close_Date__c = DateTime.newInstance(2023, 1, 31, 7, 8, 16), Minimum_Price__c = 100.00, Seller__c = dummySeller.Id);
        
        insert testProduct;
        
        
        
        String testProductQuery = '%(ID: ' + String.valueOf(testProduct.id) + ')';
        
        CollaborationGroup expectedCG = [SELECT Name,Id,Description FROM CollaborationGroup WHERE Description LIKE :testProductQuery LIMIT 1];
        CollaborationGroup cg = ProductTrigger_Helper.findAssociatedChatterGroup(testProduct);
        
        System.assertEquals(expectedCG, cg);
    }


}