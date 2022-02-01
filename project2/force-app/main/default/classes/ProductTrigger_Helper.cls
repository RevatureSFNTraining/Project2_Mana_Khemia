public without sharing class ProductTrigger_Helper {
    public ProductTrigger_Helper() {

    }


    public static CollaborationGroup findAssociatedChatterGroup(Product2 listing) {
        String descriptionString = '%(ID: ' + String.valueOf(listing.Id) + ')';
        return [SELECT Name,Id,Description FROM CollaborationGroup WHERE Description LIKE :descriptionString LIMIT 1];
    }


    public static void createAssociatedChatterGroup(List<Product2> newListings) {
        List<CollaborationGroup> groupsToAdd = new List<CollaborationGroup>();
        List<CollaborationGroupMember> groupMembersToAdd = new List<CollaborationGroupMember>();
        for(Product2 listing: newListings) {
            User seller = [SELECT Id,Name FROM User WHERE Id = :listing.Seller__c LIMIT 1];

            CollaborationGroup listingChatterGroup = new CollaborationGroup();
                listingChatterGroup.CollaborationType = 'Private';
                //Very hacky solution necessary: cannot tie the Product ID to a CollaborationGroupRecord
                // (only supports Account, Campaign, Case, Contact, Contract, Lead, Opportunity) and we cannot update
                // a custom field containing the ID on the Product in this trigger because it's after-insert
                // So we encode the product's ID in the Description and query based on that
                listingChatterGroup.Description = 'Chatter Group for Item ' + listing.Name + ' (ID: ' + listing.Id + ')';
                listingChatterGroup.Name = listing.Name + ': ' + seller.Name;
                listingChatterGroup.isAutoArchiveDisabled = true;
            groupsToAdd.add(listingChatterGroup);

            
        }

        insert groupsToAdd;
        
        for(Product2 listing: newListings) {
            CollaborationGroup listingChatterGroup = findAssociatedChatterGroup(listing);
            CollaborationGroupMember sellerMember = new CollaborationGroupMember();
                    sellerMember.MemberId = listing.Seller__c;
                    sellerMember.CollaborationGroupId = listingChatterGroup.id;
                groupMembersToAdd.add(sellerMember);
        }
        insert groupMembersToAdd;
    }



    public static void newHighestBidMessage(List<Product2> oldListings, List<Product2> newListings) {
        for(Integer i; i < newListings.size(); i++) {
            Product2 oldListing = oldListings[i];
            Product2 newListing = newListings[i];
            Bid__c newHighestBid = [SELECT Id,Price__c,Bidder__c FROM Bid__c WHERE Id = :newListing.Current_Highest_Bid__c LIMIT 1];
            Bid__c oldHighestBid = [SELECT Id,Price__c,Bidder__c FROM Bid__c WHERE Id = :oldListing.Current_Highest_Bid__c LIMIT 1];

            if(newHighestBid.Price__c > oldHighestBid.Price__c) {
    
                String message = 'A new highest bid has been posted for ' + newListing.Name + 
                                        ': ' + newHighestBid.Price__c + ' by {' + newHighestBid.Bidder__c +
                                        '}, beating ' + oldHighestBid.Price__c + ' by {' + oldHighestBid.Bidder__c + '}.';
    
                ConnectApi.FeedItem fi = (ConnectApi.FeedItem) ConnectApiHelper.postFeedItemWithMentions(Network.getNetworkId(), findAssociatedChatterGroup(newListing).Id, message);
    
            }
        }
    }


    public static void sendClosingMessage(List<Product2> listings) {
        for(Product2 listing: listings) {
            Bid__c highestBid = [SELECT Id,Price__c,Bidder__c FROM Bid__c WHERE Id = :listing.Current_Highest_Bid__c LIMIT 1];
                if((listing.IsActive == false) && (System.now() > listing.Close_Date__c)) {
    
                    String message = 'The bidding period for this item has now closed. Thank you to all participants.' +
                                            'The winner of the auction is: {' + highestBid.Bidder__c + '} with amount ' +
                                            highestBid.Price__c + '. The seller will contact you soon.';
    
                    ConnectApi.FeedItem fi = (ConnectApi.FeedItem) ConnectApiHelper.postFeedItemWithMentions(Network.getNetworkId(), findAssociatedChatterGroup(listing).Id, message);
                }
        }
    }
    
    public static void deleteChatterGroups(List<Product2> listings) {
        List<CollaborationGroup> groupsToDelete = new List<CollaborationGroup>();
        for(Product2 listing: listings) {
            groupsToDelete.add(findAssociatedChatterGroup(listing));
        }
        delete groupsToDelete;
    }


       /* Due to governor limits (100 max schedulable Apex actions at a time),
        handling the closing of a bid would better be handled by using validation to not accept bids after the close time,
        then setting a scheduled Apex job at midnight to close all of the necessary auctions and send the messages
        */

}