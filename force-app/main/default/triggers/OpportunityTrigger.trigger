trigger OpportunityTrigger on Opportunity (before insert,before update, before delete) {

    switch on Trigger.operationType {
        when  BEFORE_INSERT {
            OpportunityHandler.validateOpportunityAmount(Trigger.new);
            
        }
        

        when BEFORE_UPDATE {
            OpportunityHandler.setPrimaryContactOnOpportunity(Trigger.new);
        } 

        when BEFORE_DELETE {
            OpportunityHandler.preventClosedWonOpportunityDeletion(Trigger.old);
        }

    }
   
   
}