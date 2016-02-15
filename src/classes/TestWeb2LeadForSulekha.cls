@isTest(seealldata=false) 
public class TestWeb2LeadForSulekha{
    
    //Test Method
    public Static testMethod void TestWeb2LeadForSulekha(){ 
        list<lead> allLeads = new  list<lead>();
        Lead l3 = new Lead();
        
        l3.WebBanner_Source__c = 'AskMe';
        l3.ISD_Code__c = '91';
        l3.Mobile__c = '8063000001';
        l3.LastName = 'Test Lead';
        l3.Project_Name__c = 'a092000000BaNrf';
        l3.Status = 'Open';
        l3.LeadSource = 'Web';
        l3.Next_Action__c = 'Establish Contact';
        l3.Company = 'CG';
        
        insert l3;
        
        
        l3.LeadSource = 'AskMe';
        l3.WebBanner_Source__c = 'AskMe';
        l3.Mobile__c = '4063000001';
        update l3;
        
        Lead l = new Lead();
        
        l.WebBanner_Source__c = 'www.sulekha.com';
        l.ISD_Code__c = '91';
        l.Mobile__c = '9663768196';
        l.LastName = 'Test Lead';
        l.Project_Name__c = 'a092000000BaNrf';
        l.Status = 'Open';
        l.LeadSource = 'Web';
        l.Next_Action__c = 'Establish Contact';
        l.Company = 'CG';
        
    
        allLeads.add(l);
        Lead l1 = new Lead();
        
        l1.WebBanner_Source__c = 'www.sulekha.com';
        l1.ISD_Code__c = '1';
        l1.Mobile__c = '9663000001';
        l1.LastName = 'Test Lead';
        l1.Project_Name__c = 'a092000000BaNrf';
        l1.Status = 'Open';
        l1.LeadSource = 'Web';
        l1.Next_Action__c = 'Establish Contact';
        l1.Company = 'CG';
        
       // insert l1;
           allLeads.add(l1);
        Lead l2 = new Lead();
        
        l2.WebBanner_Source__c = 'www.sulekha.com';
        l2.ISD_Code__c = '39';
        l2.Mobile__c = '9663000001';
        l2.LastName = 'Test Lead';
        l2.Project_Name__c = 'a092000000BaNrf';
        l2.Status = 'Open';
        l2.LeadSource = 'Web';
        l2.Next_Action__c = 'Establish Contact';
        l2.Company = 'CG';
        
     
         allLeads.add(l2);
        Lead l4 = new Lead();
        
        l4.WebBanner_Source__c = 'www.sulekha.com';
        l4.ISD_Code__c = '355';
        l4.Mobile__c = '9663000001';
        l4.LastName = 'Test Lead';
        l4.Project_Name__c = 'a092000000BaNrf';
        l4.Status = 'Open';
        l4.LeadSource = 'Web';
        l4.Next_Action__c = 'Establish Contact';
        l4.Company = 'CG';
         allLeads.add(l4);
       
        
        Lead l5 = new Lead();
        
        l5.WebBanner_Source__c = 'www.sulekha.com';
        l5.ISD_Code__c = '213';
        l5.Mobile__c = '9663000001';
        l5.LastName = 'Test Lead';
        l5.Project_Name__c = 'a092000000BaNrf';
        l5.Status = 'Open';
        l5.LeadSource = 'Web';
        l5.Next_Action__c = 'Establish Contact';
        l5.Company = 'CG';
         allLeads.add(l5);
        //insert l5;
        
        Lead l6 = new Lead();
        
        l6.WebBanner_Source__c = 'www.sulekha.com';
        l6.ISD_Code__c = '244';
        l6.Mobile__c = '9663000001';
        l6.LastName = 'Test Lead';
        l6.Project_Name__c = 'a092000000BaNrf';
        l6.Status = 'Open';
        l6.LeadSource = 'Web';
        l6.Next_Action__c = 'Establish Contact';
        l6.Company = 'CG';
         allLeads.add(l6);
    
        
        Lead l7 = new Lead();
        
        l7.WebBanner_Source__c = 'www.sulekha.com';
        l7.ISD_Code__c = '54';
        l7.Mobile__c = '9663000001';
        l7.LastName = 'Test Lead';
        l7.Project_Name__c = 'a092000000BaNrf';
        l7.Status = 'Open';
        l7.LeadSource = 'Web';
        l7.Next_Action__c = 'Establish Contact';
        l7.Company = 'CG';
         allLeads.add(l7);
       
       
        Lead la1 = new Lead(ISD_Code__c = '260',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000001',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
       
         allLeads.add(la1);
        Lead la2 = new Lead(ISD_Code__c = '267',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000002',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
       
         allLeads.add(la2);
         
        Lead ll1 = new Lead(ISD_Code__c = '374',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400001',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
            allLeads.add(ll1);

        Lead ll2 = new Lead(ISD_Code__c = '61',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400002',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
            allLeads.add(ll2);
            
        Lead ll3 = new Lead(ISD_Code__c = '43',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400003',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
            allLeads.add(ll3);
        
        Lead ll4 = new Lead(ISD_Code__c = '994',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400004',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
            allLeads.add(ll4);
            
        Lead ll5 = new Lead(ISD_Code__c = '1242',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400005',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
            allLeads.add(ll5);
        
        Lead ll6 = new Lead(ISD_Code__c = '1973',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400006',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
            allLeads.add(ll6);
            
        Lead ll7 = new Lead(ISD_Code__c = '880',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400007',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
            allLeads.add(ll7);
        
        Lead ll8 = new Lead(ISD_Code__c = '375',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400008',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
            allLeads.add(ll8);
            
        Lead ll9 = new Lead(ISD_Code__c = '32',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400009',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
            allLeads.add(ll9);
        
        Lead ll10 = new Lead(ISD_Code__c = '229',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400010',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
            allLeads.add(ll10);
            
        Lead ll11 = new Lead(ISD_Code__c = '1441',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400011',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
            allLeads.add(ll11);
        
        Lead ll12 = new Lead(ISD_Code__c = '591',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400012',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
            allLeads.add(ll12);
            
        Lead ll13 = new Lead(ISD_Code__c = '387',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400013',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
            allLeads.add(ll13);
        
        Lead ll14 = new Lead(ISD_Code__c = '267',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400014',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
            allLeads.add(ll14);
            
        Lead ll15 = new Lead(ISD_Code__c = '55',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400015',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
            allLeads.add(ll15);
        
        Lead ll16 = new Lead(ISD_Code__c = '359',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400016',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
            allLeads.add(ll16);
        
        Lead ll17 = new Lead(ISD_Code__c = '86',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400017',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
        allLeads.add(ll17);
        Lead ll18 = new Lead(ISD_Code__c = '57',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400018',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
        allLeads.add(ll18);
        Lead ll19 = new Lead(ISD_Code__c = '682',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400019',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
        allLeads.add(ll19);
        Lead ll20 = new Lead(ISD_Code__c = '506',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400020',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
        allLeads.add(ll20);
        Lead ll21 = new Lead(ISD_Code__c = '385',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400021',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
        allLeads.add(ll21);
        Lead ll22 = new Lead(ISD_Code__c = '357',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400022',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
        allLeads.add(ll22);
        Lead ll23 = new Lead(ISD_Code__c = '420',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400023',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
        allLeads.add(ll23);
        Lead ll24 = new Lead(ISD_Code__c = '45',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400024',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
        allLeads.add(ll24);
        Lead ll25 = new Lead(ISD_Code__c = '1809',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400025',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
        allLeads.add(ll25);
        Lead ll26 = new Lead(ISD_Code__c = '593',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400026',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
        allLeads.add(ll26);
        Lead ll27 = new Lead(ISD_Code__c = '503',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400027',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
        allLeads.add(ll27);
        Lead ll28 = new Lead(ISD_Code__c = '240',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400028',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
        allLeads.add(ll28);
        Lead ll29 = new Lead(ISD_Code__c = '372',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400029',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
        allLeads.add(ll29);
        Lead ll30 = new Lead(ISD_Code__c = '251',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400030',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
        allLeads.add(ll30);
        Lead ll31 = new Lead(ISD_Code__c = '298',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400031',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
        allLeads.add(ll31);
        Lead ll32 = new Lead(ISD_Code__c = '358',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400032',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
        allLeads.add(ll32);
        Lead ll33 = new Lead(ISD_Code__c = '33',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400033',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
        allLeads.add(ll33);
        Lead ll34 = new Lead(ISD_Code__c = '241',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400034',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
        allLeads.add(ll34);
        Lead ll35 = new Lead(ISD_Code__c = '220',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400035',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
        allLeads.add(ll35);
        Lead ll36 = new Lead(ISD_Code__c = '995',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400036',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
        allLeads.add(ll36);
        Lead ll37 = new Lead(ISD_Code__c = '49',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663400037',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
        allLeads.add(ll37);
        
        
        
        
        
        
        Lead lm1 = new Lead(ISD_Code__c = '260',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000001',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(lm1);
 
        Lead lm2 = new Lead(ISD_Code__c = '267',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000002',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
                 allLeads.add(lm2);
        
        Lead la3 = new Lead(ISD_Code__c = '423',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000003',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
                 allLeads.add(la3);
         
        Lead la4 = new Lead(ISD_Code__c = '370',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000004',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
                 allLeads.add(la4);
        
        Lead lb4 = new Lead(ISD_Code__c = '20',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663002004',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
                 allLeads.add(lb4);
        
        
        Lead la11 = new Lead(ISD_Code__c = '52',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000011',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
                 allLeads.add(la11);
         
        Lead la12= new Lead(ISD_Code__c = '373',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000012',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
                 allLeads.add(la12);
        
        Lead la13 = new Lead(ISD_Code__c = '212',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000013',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
                 allLeads.add(la13);
         
        Lead la14 = new Lead(ISD_Code__c = '264',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000014',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
                 allLeads.add(la14);
                 
        Lead la15 = new Lead(ISD_Code__c = '977',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000015',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la15);
 
        Lead la16 = new Lead(ISD_Code__c = '31',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000016',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
                 allLeads.add(la16);
        
        Lead la17 = new Lead(ISD_Code__c = '599',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000017',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
                 allLeads.add(la17);
         
        Lead la18 = new Lead(ISD_Code__c = '64',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000018',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
                 allLeads.add(la18);
        
        Lead la19 = new Lead(ISD_Code__c = '505',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000019',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
                 allLeads.add(la19);
         
        Lead la20 = new Lead(ISD_Code__c = '234',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000020',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
                 allLeads.add(la20);
        
        Lead la6 = new Lead(ISD_Code__c = '389',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000006',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
                 allLeads.add(la6);
        
        Lead la7 = new Lead(ISD_Code__c = '261',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000007',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
                 allLeads.add(la7);
                 
        Lead la8 = new Lead(ISD_Code__c = '60',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000008',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
                 allLeads.add(la8);
        
        Lead la9 = new Lead(ISD_Code__c = '353',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000009',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
                 allLeads.add(la9);
                 
        Lead la10 = new Lead(ISD_Code__c = '20230',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000010',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
                 allLeads.add(la10);
                 
                 
                 
        
        Lead la21 = new Lead(ISD_Code__c = '47',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000021',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la21);
 
Lead la22 = new Lead(ISD_Code__c = '92',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000022',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la22);

Lead la23 = new Lead(ISD_Code__c = '507',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000023',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la23);
 
Lead la24 = new Lead(ISD_Code__c = '51',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000024',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la24);

Lead la25 = new Lead(ISD_Code__c = '63',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000025',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la25);
 
Lead la26= new Lead(ISD_Code__c = '48',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000026',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la26);

Lead la27 = new Lead(ISD_Code__c = '351',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000027',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la27);
 
Lead la28 = new Lead(ISD_Code__c = '974',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000028',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la28);

 
Lead la29 = new Lead(ISD_Code__c = '40',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000029',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la29);

Lead la30 = new Lead(ISD_Code__c = '7',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000030',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la30);
 
Lead la31= new Lead(ISD_Code__c = '966',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000031',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la31);

Lead la32 = new Lead(ISD_Code__c = '65',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000032',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la32);
 
Lead la33 = new Lead(ISD_Code__c = '421',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000033',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la33);
         
         
         
         Lead la34 = new Lead(ISD_Code__c = '386',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000034',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la34);
 
Lead la35 = new Lead(ISD_Code__c = '27',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000035',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la35);
Lead la36 = new Lead(ISD_Code__c = '34',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000036',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la36);
 
Lead la37 = new Lead(ISD_Code__c = '94',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000037',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la37);
Lead la38 = new Lead(ISD_Code__c = '968',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000038',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la38);
 
Lead la39 = new Lead(ISD_Code__c = '46',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000039',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la39);
Lead la40 = new Lead(ISD_Code__c = '41',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000040',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la40);
 
Lead la41 = new Lead(ISD_Code__c = '963',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000041',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la41);
Lead la42 = new Lead(ISD_Code__c = '886',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000042',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la42);
 
Lead la43 = new Lead(ISD_Code__c = '256',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000043',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la43);
Lead la44 = new Lead(ISD_Code__c = '66',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000044',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la44);
 
Lead la45 = new Lead(ISD_Code__c = '670',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000045',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la45);
         
         
                 
        
        
        

Lead la46 = new Lead(ISD_Code__c = '228',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000046',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la46);
 
Lead la47 = new Lead(ISD_Code__c = '1868',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000047',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la47);

Lead la48 = new Lead(ISD_Code__c = '216',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000048',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la48);
 
Lead la49 = new Lead(ISD_Code__c = '90',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000049',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la49);

Lead la50 = new Lead(ISD_Code__c = '6254',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000050',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la50);
 
Lead la51 = new Lead(ISD_Code__c = '380',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000051',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la51);

Lead la52 = new Lead(ISD_Code__c = '971',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000052',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la52);
 
Lead la53 = new Lead(ISD_Code__c = '44',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000053',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la53);

Lead la54 = new Lead(ISD_Code__c = '598',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000054',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la54);
 
Lead la55 = new Lead(ISD_Code__c = '998',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000055',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la55);

Lead la56 = new Lead(ISD_Code__c = '58',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000056',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la56);
 
Lead la57= new Lead(ISD_Code__c = '84',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000057',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la57);

Lead la58 = new Lead(ISD_Code__c = '967',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000058',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la58);
 
Lead la59 = new Lead(ISD_Code__c = '263',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000059',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la59);

 
Lead la60 = new Lead(ISD_Code__c = '1684',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000060',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la60);

Lead la61 = new Lead(ISD_Code__c = '376',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000061',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la61);
 
Lead la62= new Lead(ISD_Code__c = '1264',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000062',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la62);

Lead la63 = new Lead(ISD_Code__c = '672',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000063',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la63);
 
Lead la64 = new Lead(ISD_Code__c = '1268',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000064',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la64);

Lead la65 = new Lead(ISD_Code__c = '297',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000065',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la65);
         
         
         
         Lead la67 = new Lead(ISD_Code__c = '1246',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000067',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la67);
Lead la68 = new Lead(ISD_Code__c = '501',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000068',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la68);
 
Lead la69 = new Lead(ISD_Code__c = '975',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000069',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la69);
Lead la70 = new Lead(ISD_Code__c = '47',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000070',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la70);
 
Lead la71 = new Lead(ISD_Code__c = '1284',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000071',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la71);
Lead la72 = new Lead(ISD_Code__c = '1284',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000072',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la72);
 
Lead la73 = new Lead(ISD_Code__c = '673',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000073',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la73);
Lead la74 = new Lead(ISD_Code__c = '226',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000074',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la74);
 
Lead la75 = new Lead(ISD_Code__c = '257',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000075',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la75);
Lead la76 = new Lead(ISD_Code__c = '855',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000076',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la76);
 
Lead la77 = new Lead(ISD_Code__c = '238',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000077',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la77);
Lead la78 = new Lead(ISD_Code__c = '238',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000078',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la78);
 
Lead la79 = new Lead(ISD_Code__c = '1345',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000079',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la79);
Lead la80 = new Lead(ISD_Code__c = '236',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000080',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la80);
 




Lead la81 = new Lead(ISD_Code__c = '235',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000081',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la81);
 
Lead la82 = new Lead(ISD_Code__c = '6189',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000082',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la82);

Lead la83 = new Lead(ISD_Code__c = '1161',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000083',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la83);
 
Lead la84 = new Lead(ISD_Code__c = '269',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000084',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la84);

Lead la85 = new Lead(ISD_Code__c = '242',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000085',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la85);
 
Lead la86 = new Lead(ISD_Code__c = '53',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000086',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la86);

Lead la87 = new Lead(ISD_Code__c = '253',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000087',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la87);
 
Lead la88 = new Lead(ISD_Code__c = '1767',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000088',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la88);

Lead la89 = new Lead(ISD_Code__c = '291',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000089',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la89);
 
Lead la90 = new Lead(ISD_Code__c = '500',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000090',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la90);

Lead la91 = new Lead(ISD_Code__c = '679',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000091',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la91);
 
Lead la92= new Lead(ISD_Code__c = '594',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000092',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la92);

Lead la93 = new Lead(ISD_Code__c = '689',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000093',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la93);
 
Lead la94 = new Lead(ISD_Code__c = '1473',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000094',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la94);

 
Lead la95 = new Lead(ISD_Code__c = '590',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000095',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la95);

Lead la96 = new Lead(ISD_Code__c = '1671',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000096',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la96);
 
Lead la97= new Lead(ISD_Code__c = '224',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000097',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la97);

Lead la98 = new Lead(ISD_Code__c = '245',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000098',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la98);
 
Lead la99 = new Lead(ISD_Code__c = '592',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000099',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la99);
         
         
         Lead la100 = new Lead(ISD_Code__c = '509',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000100',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la100);
 
Lead la101 = new Lead(ISD_Code__c = '509',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000101',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la101);
Lead la102 = new Lead(ISD_Code__c = '93',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000102',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la102);
 
Lead la103 = new Lead(ISD_Code__c = '225',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000103',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la103);
Lead la104 = new Lead(ISD_Code__c = '1876',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000104',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la104);
 
Lead la105 = new Lead(ISD_Code__c = '686',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000105',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la105);
Lead la106 = new Lead(ISD_Code__c = '856',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000106',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la106);
 
Lead la107 = new Lead(ISD_Code__c = '266',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000107',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la107);
Lead la108 = new Lead(ISD_Code__c = '231',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000108',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la108);
 
Lead la109 = new Lead(ISD_Code__c = '218',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000109',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la109);
Lead la110 = new Lead(ISD_Code__c = '853',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000110',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la110);
 
Lead la111 = new Lead(ISD_Code__c = '265',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000111',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la111);
Lead la112 = new Lead(ISD_Code__c = '960',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000112',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la112);
 
Lead la113 = new Lead(ISD_Code__c = '223',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000113',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la113);
Lead la114 = new Lead(ISD_Code__c = '692',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000114',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la114);
Lead la115 = new Lead(ISD_Code__c = '596',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead2', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000115',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la115);
Lead la116 = new Lead(ISD_Code__c = '222',Project_Name__c = 'a092000000BaNrf',LastName = 'Test Lead', Company = 'CG', WebBanner_Source__c = 'www.sulekha.com', Mobile__c = '9663000116',Status = 'Open',LeadSource = 'Web',Next_Action__c = 'Establish Contact' );
         allLeads.add(la116);
 


                 
                 
        
 
        
        
        insert allLeads;
    }
}