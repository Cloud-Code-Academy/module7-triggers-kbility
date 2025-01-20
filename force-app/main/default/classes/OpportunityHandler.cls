public with sharing class OpportunityHandler {
    
    public static void validateOpportunityAmount(List<Opportunity> opportunitiesList){
        for(Opportunity opportunity : opportunitiesList){
            if(opportunity.Amount == null || opportunity.Amount <= 5000){
                opportunity.addError('Opportunity amount must be greater than 5000');
            }
        }
    }

    public static void preventClosedWonOpportunityDeletion(List<Opportunity> opportunitiesList){
       // Get the ids of the opportunities
        Set<Id> accountIds = new Set<Id>();
        for(Opportunity opportunity : opportunitiesList){
            if(opportunity.StageName == 'Closed Won'){
                accountIds.add(opportunity.AccountId);
            } 
        }

        // Query related accounts 
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Industry 
                                                            FROM Account 
                                                            WHERE Id IN :accountIds]);

        for(Opportunity opportunity : opportunitiesList){
            Account account = accountMap.get(opportunity.AccountId);
            if(opportunity.StageName == 'Closed Won' && account != null 
              && account.Industry == 'Banking'){
                opportunity.addError('Cannot delete closed opportunity for a banking account that is won');
            }
        }

    }

    public static void setPrimaryContactOnOpportunity(List<Opportunity> opportunitiesList){
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opportunity : opportunitiesList) {
                accountIds.add(opportunity.AccountId);
        }

        Map<Id, Account> accountAndContactMap = new Map<Id, Account>(
            [SELECT Id, 
                  (SELECT Id, AccountId 
                    FROM Contacts 
                    WHERE Title = 'CEO' 
                    ORDER BY FirstName ASC) 
            FROM Account 
            WHERE Id IN :accountIds]);
        for(Opportunity opp : opportunitiesList){
            if(opp.Primary_Contact__c == null ){
                Account acc = accountAndContactMap.get(opp.AccountId);
                if(!acc.Contacts.isEmpty()){
                    Contact cont = acc.Contacts.get(0);
                    opp.Primary_Contact__c = cont.Id;
                }
            }
        }

    }

    
}