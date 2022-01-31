public without sharing class ProductTrigger_Helper {
    public ProductTrigger_Helper() {

    }



    public static void createAssociatedChatterGroup(Product2 listing) {

        CollaborationGroup chatterGroup = new CollaborationGroup();
            chatterGroup.CollaborationType = 'Private';
            chatterGroup.Description = 'Chatter Group for Item ' + listing.Name;
            chatterGroup.Name = listing.Name + ': ' + listing.Seller__c.Name;
            chatterGroup.isAutoArchiveDisabled = true;
        insert chatterGroup;

        listing.Chatter_Group_Id__c = chatterGroup.id;
        update listing;

        CollaborationGroupRecord associatedItem = new CollaborationGroupRecord();
            associatedItem.RecordId = listing.id;
            associatedItem.CollaborationGroupId = chatterGroup.id;
        insert associatedItem;

        CollaborationGroupMember sellerMember = new CollaborationGroupMember();
            sellerMember.MemberId = listing.Seller__c.id;
            sellerMember.CollaborationGroupId = chatterGroup.id;
        insert sellerMember;
    }

    public static void newHighestBidMessage(Product2 oldListing, Product2 newListing) {
        if(newListing.Current_Highest_Bid__c.Price__c > oldListing.Current_Highest_Bid__c.Price__c) {

            String message = 'A new highest bid has been posted for ' + newListing.Name + 
                                    ': ' + newListing.Current_Highest_Bid__c.Bidder__c.Price__c + ' by {' + newListing.Current_Highest_Bid__c.Bidder__c.id +
                                    '}, beating ' + oldListing.Current_Highest_Bid__c.Bidder__c.Price__c + ' by {' + oldListing.Current_Highest_Bid__c.Bidder__c.id + '}.';

            ConnectApi.FeedItem fi = (ConnectApi.FeedItem) ConnectApiHelper.postFeedItemWithMentions(Network.getNetworkId(), newListing.Chatter_Group_Id__c, message);

        }
    }

    public static void sendClosingMessage(Product2 listing) {
            if((listing.IsActive == false) && (System.now() > listing.Close_Date__c)) {

                String message = 'The bidding period for this item has now closed. Thank you to all participants.' +
                                        'The winner of the auction is: {' + listing.Current_Highest_Bid__c.Bidder__c.id + '} with amount ' +
                                        listing.Current_Highest_Bid__c.Price__c + '. The seller will contact you soon.';

                ConnectApi.FeedItem fi = (ConnectApi.FeedItem) ConnectApiHelper.postFeedItemWithMentions(Network.getNetworkId(), listing.Chatter_Group_Id__c, message);
            }
        }




    /* Due to governor limits (100 max schedulable Apex actions at a time), this will have to be implemented
        in Process Builder (which has a limit of 1000 per hour) instead, but we can call the process from this trigger at least
    public void handleCloseDate(Product listing) {


    } */
}
