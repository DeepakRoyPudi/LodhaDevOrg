public class MapFieldsToAccountHandler{

    public void getFields(list<ProfileInfo__c> profileList){
            Account accObj = new Account();
            set<String> accCRN = new  set<String>();
            accObj = [Select CRN__c,Age__c,Ethinicity__c from account where CRN__c =:profileList[0].Profile_CRN__c limit 1];
            
        
            
            
            
            for(ProfileInfo__c profileObj : profileList)
            {
               accObj.Age__c = profileObj.Profile_Age__c;
               accObj.Ethinicity__c = profileObj.Profile_Ethinicity__c;
               accObj.DOB_Of_Client__c = profileObj.Profile_DOB_Of_Client__c;
               accObj.Marital_Status__c = profileObj.Profile_Marital_Status__c;
               accObj.Anniversary_Date__c = profileObj.Profile_Anniversary_Date__c;
               accObj.Spouse_Name__c = profileObj.ProfileSpouse_Name_c__c;
               accObj.DOB_of_Spouse__c = profileObj.Profile_DOB_of_Spouse__c;
               accObj.No_of_children__c = profileObj.Profile_No_of_children__c;
               accObj.Children_s_DOB__c = profileObj.Profile_Children_s_DOB__c;
               accObj.Children_Names__c = profileObj.Profile_Children_Names__c;
               accObj.Purpose_of_Purchase__c = profileObj.Profile_Purpose_of_Purchase__c;
               accObj.Hobbies__c = profileObj.Profile_Hobbies__c;
               accObj.Current_Home_ownership__c = profileObj.Current_residence_ownership__c;
               accObj.Assets_Owned_Homes__c = profileObj.Profile_Assets_Owned_Homes__c;
               accObj.Car_s_Owned__c = profileObj.Profile_Car_s_Owned__c;
               accObj.Club_Membership__pc = profileObj.Profile_Club_Membership_pc__c;
               accObj.Other_residences_owned_at_Lodha_Group_CC__c = profileObj.Other_residences_owned_at_Lodha_Group_CC__c;
               accObj.Specify_Residences_owned_at_Lodha_group__c = profileObj.Specify_Residences_owned_at_Lodha_group__c;
               accObj.Industry = profileObj.Profile_Industry__c;
               accObj.Type_of_Home__c = profileObj.Profile_Type_of_Home__c;
               accObj.Occupation_acc__c = profileObj.Profile_Occupation__c;
               accObj.TRAI_DND__c = profileObj.Profile_TRAI_DND__c;
               accObj.Preferred_Mode_of_Contact__c = profileObj.Profile_Preferred_Mode_of_Contact__c;
               
            }
            
          
            
          update accObj; 
            
            
            
            


        
    }



}