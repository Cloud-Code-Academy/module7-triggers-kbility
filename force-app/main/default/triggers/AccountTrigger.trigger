trigger AccountTrigger on Account (before insert, after insert) {

    switch on Trigger.operationType {
        when BEFORE_INSERT {
            AccountHandler.accountTypeProspect(Trigger.new);
            AccountHandler.copyShippingAddressToBillingAddress(Trigger.new);
            AccountHandler.setAccountRatingHot(Trigger.new);
        } 
        
        when AFTER_INSERT {
            AccountHandler.createRelatedAccountContact(Trigger.new);
        }
    }

}