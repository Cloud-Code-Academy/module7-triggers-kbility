public with sharing class AccountHandler {
   public static void accountTypeProspect(List<Account> accountList){

    for (Account acc : accountList) {
        if(acc.Type == null) {
            acc.Type = 'Prospect';
        } 
    }
   }

   public static void copyShippingAddressToBillingAddress(List<Account> accountList){

    for(Account acc : accountList){
        if(acc.ShippingCity != null){
            acc.BillingCity = acc.ShippingCity;
            acc.BillingCountry = acc.ShippingCountry;
            acc.BillingPostalCode = acc.ShippingPostalCode;
            acc.BillingStreet = acc.ShippingStreet;
            acc.BillingState = acc.ShippingState;
        }
     }
    }
  public static void setAccountRatingHot(List<Account> accountList){
      for(Account acc : accountList){
           if (acc.Phone != null && acc.Website != null && acc.Fax != null) {
              acc.Rating = 'Hot';
           }
      }
  }

  public static void createRelatedAccountContact(List<Account> accountList){
      List<Contact> contactsToInsert = new List<Contact>();
      
      for (Account acc : accountList){

        if(acc.Id != null){
            Contact defaultContact = new Contact(
                LastName = 'DefaultContact',
                Email = 'default@email.com',
                AccountId = acc.Id
            );

            contactsToInsert.add(defaultContact);
        }
      }
       
        if(contactsToInsert.size() > 0){
            try {
                insert contactsToInsert;
            } catch (DmlException e) {
                System.debug('ERROR: Not able to add contact: ' + e.getMessage());
            }
        }
  }
}
     