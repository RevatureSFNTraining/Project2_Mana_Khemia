public with sharing class BidTrigger_Helper {
  // Display error messages if required field is null
  public static void requiredFields(List<Bid__c> bids){
    for (Bid__c bid : bids) {
      if (bid.Product__c == null) {
        bid.Product__c.addError('Product is required');
      }
      if (bid.Price__c == null) {
        bid.Price__c.addError('Price is required');
      }
    }
  }
  // Update highest current bid on listing
  public static void updateCurrentHighestBid(List<Bid__c> bids){
    for (Bid__c bid : bids) {
      try {
        // Query for listing associated with bid
        Product2 listing = [
          SELECT Id, Current_Highest_Bid__c
          FROM Product2 
          WHERE Id =: bid.Product__c
          LIMIT 1
        ];
        // Check if bid is greater than current highest bid on listing
        if (bid.Price__c > listing.Current_Highest_Bid__c || listing.Current_Highest_Bid__c == null) {
          // Update current highest bid
          listing.Current_Highest_Bid__c = bid.Price__c;
          update listing;
        }
      } catch (Exception e) {
        System.debug('An unexpected error has occurred: ' + e.getMessage());
      }
    }
  }
}
