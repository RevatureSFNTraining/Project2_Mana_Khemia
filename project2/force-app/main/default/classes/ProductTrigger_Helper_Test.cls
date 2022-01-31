@isTest
public without sharing class ProductTrigger_Helper_Test {
    public static Integer numberOfProducts = 30;

    @TestSetup
    static void setup() {
        List<Product2> testProducts = new List<Product2>();
        for(Integer i = 1; i <= numberOfProducts; i++) {
            testProducts.add(new Product2(Name= 'Test Product ' + i));
        }
        insert testProducts;
    }


    @isTest
    static void chatterGroupTest() {
        Integer successes = 0;
        for(Product2 prod: [SELECT Id,Name,Chatter_Group_Id__c FROM Product2]) {
            ID associatedGroupId = Id.valueOf(prod.Chatter_Group_Id__c);
            List<CollaborationGroup> associatedGroup = [SELECT Id,Name FROM CollaborationGroup WHERE Id = :associatedGroupId];

                // Each product should have exactly one group

                if(associatedGroup.size() == 1) {
                    for(CollaborationGroup cg: associatedGroup) {

                        // Each group's name should correspond to the item's name
                        if (cg.Name == prod.Name + ': ' + product.Seller__c.Name) {
                            successes++;
                        }
                    }
                }
        }


        System.assertEquals(numberOfProducts, successes);
    }

    @isTest
    static void closingMessageSentTest() {
        Integer successes = 0;
        Product2 testProduct = [SELECT Id,Name,Chatter_Group_Id__c,Close_Date__c FROM Product2 WHERE Name='Test Product 1' LIMIT 1];
        testProduct.Close_Date__c == DateTime.newInstance(1997, 1, 31, 7, 8, 16);
        testProduct.isActive = false;
        Id associatedGroupId = Id.valueOf(testProduct.Chatter_Group_Id__c);
        update testProduct;

        List<FeedItem> allFeedItems = [SELECT Id,Body,ParentId FROM FeedItem WHERE ParentId = :associatedGroupId];
        for(FeedItem fi: allFeedItems) {
            if(fi.Body.contains('The bidding period for this item has now closed.')) {
                successes++;
            }
        }


        System.assertEquals(successes, 1);
    }


}
