trigger WatchlistItemTrigger on Watchlist_Item__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    Switch on Trigger.OperationType {
        when BEFORE_INSERT {
            // require product and user fields
            WatchlistItemTrigger_Helper.requireFields(Trigger.new);
        }
        when BEFORE_UPDATE {

        }
        when BEFORE_DELETE {

        }
        when AFTER_INSERT {
            // send user notification that item has been added to watchlist
            WatchlistItemTrigger_Helper.addedNotification(Trigger.new);
        }
        when AFTER_UPDATE {

        }
        when AFTER_DELETE {

        }
        when AFTER_UNDELETE {

        } 
    }
}