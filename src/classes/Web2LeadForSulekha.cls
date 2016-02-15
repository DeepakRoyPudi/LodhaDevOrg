public class Web2LeadForSulekha{

    public static void CheckSulekha(List<Lead> leadlist){
        for(Lead l: leadlist)
        {
            if(l.WebBanner_Source__c == 'www.sulekha.com') 
            {   
                
                l.ISD_Code__c = '00'+l.ISD_Code__c;
                
                if(l.ISD_Code__c!='0091'){
                    l.Mobile__c = l.ISD_Code__c+l.Mobile__c;
                }
                
                /*  
                if(l.ISD_Code__c=='001'){ 
                    l.Country_R__c  = 'Canada';
                }
                */
                       
                if(l.ISD_Code__c=='001'){
                    l.Country_R__c  = 'United States';
                }
                
                
                
                if(l.ISD_Code__c=='00355'){ 
                    l.Country_R__c  = 'Albania';
                }
                if(l.ISD_Code__c=='00213'){
                    l.Country_R__c  = 'Algeria';
                }
                if(l.ISD_Code__c=='00244'){
                    l.Country_R__c  = 'Angola';
                }
                if(l.ISD_Code__c=='0054'){
                    l.Country_R__c  = 'Argentina';
                } 
                if(l.ISD_Code__c=='00374'){
                    l.Country_R__c  = 'Armenia';
                }
                if(l.ISD_Code__c=='0061'){ 
                    l.Country_R__c  = 'Australia';
                }
                if(l.ISD_Code__c=='0043'){ 
                    l.Country_R__c  = 'Austria';
                }
                if(l.ISD_Code__c=='00994'){ 
                    l.Country_R__c  = 'Azerbaijan';
                } 
                if(l.ISD_Code__c=='001242'){ 
                    l.Country_R__c  = 'Bahamas';
                } 
                if(l.ISD_Code__c=='001973'){ 
                    l.Country_R__c  = 'Bahrain';
                } 
                if(l.ISD_Code__c=='00880'){ 
                    l.Country_R__c  = 'Bangladesh';
                } 
                if(l.ISD_Code__c=='00375'){ 
                    l.Country_R__c  = 'Belarus';
                } 
                if(l.ISD_Code__c=='0032'){ 
                    l.Country_R__c  = 'Belgium';
                } 
                if(l.ISD_Code__c=='00229'){ 
                    l.Country_R__c  = 'Benin';
                } 
                if(l.ISD_Code__c=='001441'){
                    l.Country_R__c  = 'Bermuda';
                } 
                if(l.ISD_Code__c=='00591'){ 
                    l.Country_R__c  = 'Bolivia';
                } 
                if(l.ISD_Code__c=='00387'){
                    l.Country_R__c  = 'Bosnia and Herzegovina';
                } 
                if(l.ISD_Code__c=='00267'){ 
                    l.Country_R__c  = 'Botswana';
                } 
                if(l.ISD_Code__c=='0055'){
                    l.Country_R__c  = 'Brazil';
                } 
                if(l.ISD_Code__c=='00359'){ 
                    l.Country_R__c  = 'Bulgaria';
                } 
                 
                if(l.ISD_Code__c=='0056'){ 
                    l.Country_R__c  = 'Chile';
                } 
                if(l.ISD_Code__c=='0086'){ 
                    l.Country_R__c  = 'China';
                } 
                if(l.ISD_Code__c=='0057'){ 
                    l.Country_R__c  = 'Colombia';
                } 
                if(l.ISD_Code__c=='00682'){ 
                    l.Country_R__c  = 'Cook Islands';
                } 
                if(l.ISD_Code__c=='00506'){ 
                    l.Country_R__c  = 'Costa Rica';
                } 
                if(l.ISD_Code__c=='00385'){ 
                    l.Country_R__c  = 'Croatia';
                } 
                if(l.ISD_Code__c=='00357'){ 
                    l.Country_R__c  = 'Cyprus';
                } 
                if(l.ISD_Code__c=='00420'){ 
                    l.Country_R__c  = 'Czech Republic';
                } 
                if(l.ISD_Code__c=='0045'){ 
                    l.Country_R__c  = 'Denmark';
                } 
                if(l.ISD_Code__c=='001809'){ 
                    l.Country_R__c  = 'Dominican Republic';
                }
                if(l.ISD_Code__c=='00593'){ 
                    l.Country_R__c  = 'Ecuador';
                } 
                if(l.ISD_Code__c=='0020'){ 
                    l.Country_R__c  = 'Egypt';
                } 
                if(l.ISD_Code__c=='00503'){ 
                    l.Country_R__c  = 'El Salvador';
                } 
                if(l.ISD_Code__c=='00240'){ 
                    l.Country_R__c  = 'Equatorial Guinea';
                }
                if(l.ISD_Code__c=='00372'){ 
                    l.Country_R__c  = 'Estonia';
                } 
                if(l.ISD_Code__c=='00251'){ 
                    l.Country_R__c  = 'Ethiopia';
                }
                if(l.ISD_Code__c=='00298'){ 
                    l.Country_R__c  = 'Faroe Islands';
                }
                if(l.ISD_Code__c=='00358'){ 
                    l.Country_R__c  = 'Finland';
                } 
                if(l.ISD_Code__c=='0033'){ 
                    l.Country_R__c  = 'France';
                } 
                if(l.ISD_Code__c=='00689'){ 
                    l.Country_R__c  = 'French Polynesia';
                } 
                if(l.ISD_Code__c=='00241'){ 
                    l.Country_R__c  = 'Gabon';
                } 
                if(l.ISD_Code__c=='00220'){ 
                    l.Country_R__c  = 'Gambia';
                } 
                if(l.ISD_Code__c=='00995'){ 
                    l.Country_R__c  = 'Georgia';
                } 
                if(l.ISD_Code__c=='0049'){ 
                    l.Country_R__c  = 'Germany';
                } 
                if(l.ISD_Code__c=='00233'){ 
                    l.Country_R__c  = 'Ghana';
                } 
                if(l.ISD_Code__c=='00350'){ 
                    l.Country_R__c  = 'Gibraltar';
                } 
                if(l.ISD_Code__c=='0030'){ 
                    l.Country_R__c  = 'Greece';
                } 
                if(l.ISD_Code__c=='00299'){   
                    l.Country_R__c  = 'Greenland';
                } 
                if(l.ISD_Code__c=='00502'){ 
                    l.Country_R__c  = 'Guatemala';
                } 
                if(l.ISD_Code__c=='00504'){ 
                    l.Country_R__c  = 'Honduras';
                } 
                if(l.ISD_Code__c=='00852'){ 
                    l.Country_R__c  = 'Hong Kong';
                }
                if(l.ISD_Code__c=='0036'){ 
                    l.Country_R__c  = 'Hungary';
                } 
                if(l.ISD_Code__c=='00354'){   
                    l.Country_R__c  = 'Iceland';
                } 
                if(l.ISD_Code__c=='0091'){ 
                    l.Country_R__c  = 'India';
                } 
                if(l.ISD_Code__c=='0062'){ 
                    l.Country_R__c  = 'Indonesia';
                } 
                if(l.ISD_Code__c=='0098'){ 
                    l.Country_R__c  = 'Iran';
                } 
                if(l.ISD_Code__c=='00964'){ 
                    l.Country_R__c  = 'Iraq';
                }
                if(l.ISD_Code__c=='00353'){ 
                    l.Country_R__c  = 'Ireland';
                } 
                if(l.ISD_Code__c=='00972'){   
                    l.Country_R__c  = 'Israel';
                } 
                if(l.ISD_Code__c=='0039'){ 
                    l.Country_R__c  = 'Italy';
                } 
                if(l.ISD_Code__c=='0081'){    
                    l.Country_R__c  = 'Japan';
                } 
                if(l.ISD_Code__c=='00962'){ 
                    l.Country_R__c  = 'Jordan';
                }
                if(l.ISD_Code__c=='007'){ 
                    l.Country_R__c  = 'Kazakhstan';
                } 
                if(l.ISD_Code__c=='00254'){ 
                    l.Country_R__c  = 'Kenya';
                } 
                if(l.ISD_Code__c=='00182'){ 
                    l.Country_R__c  = 'South Korea';
                } 
                if(l.ISD_Code__c=='00850'){ 
                    l.Country_R__c  = 'North Korea';
                } 
                if(l.ISD_Code__c=='00965'){ 
                    l.Country_R__c  = 'Kuwait';
                }
                if(l.ISD_Code__c=='00965'){   
                    l.Country_R__c  = 'Kyrgyzstan';
                } 
                if(l.ISD_Code__c=='00371'){ 
                    l.Country_R__c  = 'Latvia';
                } 
                if(l.ISD_Code__c=='00961'){ 
                    l.Country_R__c  = 'Lebanon';
                } 
                if(l.ISD_Code__c=='00423'){ 
                    l.Country_R__c  = 'Liechtenstein';
                } 
                if(l.ISD_Code__c=='00370'){ 
                    l.Country_R__c  = 'Lithuania';
                } 
                if(l.ISD_Code__c=='00352'){ 
                    l.Country_R__c  = 'Luxembourg';
                } 
                if(l.ISD_Code__c=='00389'){ 
                    l.Country_R__c  = 'Macedonia';
                } 
                if(l.ISD_Code__c=='00261'){ 
                    l.Country_R__c  = 'Madagascar';
                } 
                if(l.ISD_Code__c=='0060'){ 
                    l.Country_R__c  = 'Malaysia';
                } 
                if(l.ISD_Code__c=='00353'){ 
                    l.Country_R__c  = 'Malta';
                } 
                if(l.ISD_Code__c=='0020230'){ 
                    l.Country_R__c  = 'Mauritius';
                } 
                if(l.ISD_Code__c=='0052'){ 
                    l.Country_R__c  = 'Mexico';
                }
                if(l.ISD_Code__c=='00373'){ 
                    l.Country_R__c  = 'Moldova';
                } 
                if(l.ISD_Code__c=='00212'){
                    l.Country_R__c  = 'Morocco';
                } 
                if(l.ISD_Code__c=='00264'){ 
                    l.Country_R__c  = 'Namibia';
                } 
                if(l.ISD_Code__c=='00977'){ 
                    l.Country_R__c  = 'Nepal';
                }
                if(l.ISD_Code__c=='0031'){ 
                    l.Country_R__c  = 'Netherlands';
                } 
                if(l.ISD_Code__c=='00599'){
                    l.Country_R__c  = 'Netherlands Antilles';
                } 
                if(l.ISD_Code__c=='0064'){ 
                    l.Country_R__c  = 'New Zealand';
                } 
                if(l.ISD_Code__c=='00505'){ 
                    l.Country_R__c  = 'Nicaragua';
                }
                if(l.ISD_Code__c=='00234'){ 
                    l.Country_R__c  = 'Nigeria';
                }
                if(l.ISD_Code__c=='0047'){
                    l.Country_R__c  = 'Norway';
                } 
                if(l.ISD_Code__c=='0092'){ 
                    l.Country_R__c  = 'Pakistan';
                } 
                if(l.ISD_Code__c=='00507'){ 
                    l.Country_R__c  = 'Panama';
                } 
                if(l.ISD_Code__c=='0051'){ 
                    l.Country_R__c  = 'Peru';
                }
                if(l.ISD_Code__c=='0063'){ 
                    l.Country_R__c  = 'Philippines';
                } 
                if(l.ISD_Code__c=='0048'){ 
                    l.Country_R__c  = 'Poland';
                } 
                if(l.ISD_Code__c=='00351'){ 
                    l.Country_R__c  = 'Portugal';
                } 
                if(l.ISD_Code__c=='00974'){   
                    l.Country_R__c  = 'Qatar';
                } 
                if(l.ISD_Code__c=='0040'){ 
                    l.Country_R__c  = 'Romania';
                } 
                if(l.ISD_Code__c=='007'){ 
                    l.Country_R__c  = 'Russian Federation';
                } 
                if(l.ISD_Code__c=='00966'){ 
                    l.Country_R__c  = 'Saudi Arabia';
                } 
                if(l.ISD_Code__c=='0065'){ 
                    l.Country_R__c  = 'Singapore';
                } 
                if(l.ISD_Code__c=='00421'){ 
                    l.Country_R__c  = 'Slovak Republic';
                } 
                if(l.ISD_Code__c=='00386'){
                    l.Country_R__c  = 'Slovenia';
                } 
                if(l.ISD_Code__c=='0027'){ 
                    l.Country_R__c  = 'South Africa';
                } 
                if(l.ISD_Code__c=='0034'){ 
                    l.Country_R__c  = 'Spain';
                } 
                if(l.ISD_Code__c=='0094'){ 
                    l.Country_R__c  = 'Sri Lanka';
                } 
                if(l.ISD_Code__c=='00968'){ 
                    l.Country_R__c  = 'Sultanate of Oman';
                } 
                if(l.ISD_Code__c=='0046'){ 
                    l.Country_R__c  = 'Sweden';
                } 
                if(l.ISD_Code__c=='0041'){ 
                    l.Country_R__c  = 'Switzerland';
                } 
                if(l.ISD_Code__c=='00963'){ 
                    l.Country_R__c  = 'Syria';
                } 
                if(l.ISD_Code__c=='00886'){ 
                    l.Country_R__c  = 'Taiwan';
                } 
                if(l.ISD_Code__c=='00256'){
                    l.Country_R__c  = 'Tanzania';
                } 
                if(l.ISD_Code__c=='0066'){ 
                    l.Country_R__c  = 'Thailand';
                } 
                if(l.ISD_Code__c=='00670'){
                    l.Country_R__c  = 'Timor-Leste';
                } 
                if(l.ISD_Code__c=='00228'){
                    l.Country_R__c  = 'Togo';
                } 
                if(l.ISD_Code__c=='001868'){ 
                    l.Country_R__c  = 'Trinidad and Tobago';
                } 
                if(l.ISD_Code__c=='00216'){ 
                    l.Country_R__c  = 'Tunisia';
                } 
                if(l.ISD_Code__c=='0090'){ 
                    l.Country_R__c  = 'Turkey';
                }
                if(l.ISD_Code__c=='006254'){ 
                    l.Country_R__c  = 'Uganda';
                } 
                if(l.ISD_Code__c=='00380'){ 
                    l.Country_R__c  = 'Ukraine';
                }
                if(l.ISD_Code__c=='00971'){ 
                    l.Country_R__c  = 'United Arab Emirates';
                } 
                if(l.ISD_Code__c=='0044'){ 
                    l.Country_R__c  = 'United Kingdom';
                } 
                if(l.ISD_Code__c=='00598'){
                    l.Country_R__c  = 'Uruguay';
                } 
                if(l.ISD_Code__c=='00998'){ 
                    l.Country_R__c  = 'Uzbekistan';
                }
                if(l.ISD_Code__c=='0058'){ 
                    l.Country_R__c  = 'Venezuela';
                } 
                if(l.ISD_Code__c=='0084'){
                    l.Country_R__c  = 'Viet Nam';
                } 
                if(l.ISD_Code__c=='00967'){ 
                    l.Country_R__c  = 'Yemen';
                } 
                if(l.ISD_Code__c=='00967'){ 
                    l.Country_R__c  = 'Yugoslavia';
                } 
                if(l.ISD_Code__c=='00263'){ 
                    l.Country_R__c  = 'Zimbabwe';
                } 
                if(l.ISD_Code__c=='001684'){
                    l.Country_R__c  = 'American Samoa';
                } 
                if(l.ISD_Code__c=='00376'){ 
                    l.Country_R__c  = 'Andorra';
                } 
                if(l.ISD_Code__c=='001264'){ 
                    l.Country_R__c  = 'Anguilla';
                } 
                if(l.ISD_Code__c=='00672'){ 
                    l.Country_R__c  = 'Antarctica';
                } 
                if(l.ISD_Code__c=='001268'){ 
                    l.Country_R__c  = 'Antigua and Barbuda';
                } 
                if(l.ISD_Code__c=='00297'){ 
                    l.Country_R__c  = 'Aruba';
                } 
                if(l.ISD_Code__c=='001246'){
                    l.Country_R__c  = 'Barbados';
                } 
                if(l.ISD_Code__c=='00501'){
                    l.Country_R__c  = 'Belize';
                } 
                if(l.ISD_Code__c=='00975'){ 
                    l.Country_R__c  = 'Bhutan';
                } 
                if(l.ISD_Code__c=='0047'){ 
                    l.Country_R__c  = 'Bouvet Island';
                } 
                if(l.ISD_Code__c=='001284'){ 
                    l.Country_R__c  = 'British Indian Ocean Territory';
                } 
                if(l.ISD_Code__c=='001284'){ 
                    l.Country_R__c  = 'British Virgin Islands';
                } 
                if(l.ISD_Code__c=='00673'){ 
                    l.Country_R__c  = 'Brunei';
                } 
                if(l.ISD_Code__c=='00226'){ 
                    l.Country_R__c  = 'Burkina Faso';
                } 
                if(l.ISD_Code__c=='00257'){ 
                    l.Country_R__c  = 'Burundi';
                } 
                if(l.ISD_Code__c=='00855'){ 
                    l.Country_R__c  = 'Cambodia';
                }
                if(l.ISD_Code__c=='00238'){ 
                    l.Country_R__c  = 'Cameroon';
                } 
                if(l.ISD_Code__c=='00238'){ 
                    l.Country_R__c  = 'Cape Verde';
                } 
                if(l.ISD_Code__c=='001345'){
                    l.Country_R__c  = 'Cayman Islands';
                } 
                if(l.ISD_Code__c=='00236'){ 
                    l.Country_R__c  = 'Central African Republic';
                } 
                if(l.ISD_Code__c=='00235'){ 
                    l.Country_R__c  = 'Chad';
                } 
                if(l.ISD_Code__c=='006189'){ 
                    l.Country_R__c  = 'Christmas Island';
                } 
                if(l.ISD_Code__c=='001161'){ 
                    l.Country_R__c  = 'Cocos Islands';
                } 
                if(l.ISD_Code__c=='00269'){
                    l.Country_R__c  = 'Comoros';
                } 
                if(l.ISD_Code__c=='00242'){
                    l.Country_R__c  = 'Congo';
                } 
                if(l.ISD_Code__c=='0053'){
                    l.Country_R__c  = 'Cuba';
                } 
                if(l.ISD_Code__c=='00253'){ 
                    l.Country_R__c  = 'Djibouti';
                } 
                if(l.ISD_Code__c=='001767'){ 
                    l.Country_R__c  = 'Dominica';
                } 
                if(l.ISD_Code__c=='00291'){ 
                    l.Country_R__c  = 'Eritrea';
                } 
                if(l.ISD_Code__c=='00500'){ 
                    l.Country_R__c  = 'Falkland Islands';
                } 
                if(l.ISD_Code__c=='00679'){ 
                    l.Country_R__c  = 'Fiji';
                } 
                if(l.ISD_Code__c=='00594'){ 
                    l.Country_R__c  = 'French Guiana';
                } 
                if(l.ISD_Code__c=='00689'){ 
                    l.Country_R__c  = 'French Southern Territories';
                } 
                if(l.ISD_Code__c=='001473'){ 
                    l.Country_R__c  = 'Grenada';
                } 
                if(l.ISD_Code__c=='00590'){ 
                    l.Country_R__c  = 'Guadeloupe';
                } 
                if(l.ISD_Code__c=='001671'){ 
                    l.Country_R__c  = 'Guam';
                } 
                if(l.ISD_Code__c=='00224'){ 
                    l.Country_R__c  = 'Guinea';
                } 
                if(l.ISD_Code__c=='00245'){ 
                    l.Country_R__c  = 'Guinea-Bissau';
                }
                if(l.ISD_Code__c=='00592'){ 
                    l.Country_R__c  = 'Guyana';
                } 
                if(l.ISD_Code__c=='00509'){ 
                    l.Country_R__c  = 'Haiti';
                } 
                if(l.ISD_Code__c=='00509'){ 
                    l.Country_R__c  = 'Heard and McDonald Islands';
                } 
                if(l.ISD_Code__c=='0093'){ 
                    l.Country_R__c  = 'Afghanistan';
                } 
                if(l.ISD_Code__c=='00225'){ 
                    l.Country_R__c  = 'Ivory Coast';
                } 
                if(l.ISD_Code__c=='001876'){ 
                    l.Country_R__c  = 'Jamaica';
                } 
                if(l.ISD_Code__c=='00686'){
                    l.Country_R__c  = 'Kiribati';
                } 
                if(l.ISD_Code__c=='00856'){ 
                    l.Country_R__c  = 'Laos';
                } 
                if(l.ISD_Code__c=='00266'){ 
                    l.Country_R__c  = 'Lesotho';
                } 
                if(l.ISD_Code__c=='00231'){ 
                    l.Country_R__c  = 'Liberia';
                } 
                if(l.ISD_Code__c=='00218'){ 
                    l.Country_R__c  = 'Libya';
                } 
                if(l.ISD_Code__c=='00853'){
                    l.Country_R__c  = 'Macau';
                } 
                if(l.ISD_Code__c=='00265'){ 
                    l.Country_R__c  = 'Malawi';
                } 
                if(l.ISD_Code__c=='00960'){ 
                    l.Country_R__c  = 'Maldives';
                } 
                if(l.ISD_Code__c=='00223'){ 
                    l.Country_R__c  = 'Mali';
                } 
                if(l.ISD_Code__c=='00692'){   
                    l.Country_R__c  = 'Marshall Islands';
                } 
                if(l.ISD_Code__c=='00596'){   
                    l.Country_R__c  = 'Martinique';
                } 
                if(l.ISD_Code__c=='00222'){ 
                    l.Country_R__c  = 'Mauritania';
                } 
                if(l.ISD_Code__c=='00269'){ 
                    l.Country_R__c  = 'Mayotte';
                } 
                if(l.ISD_Code__c=='00691'){ 
                    l.Country_R__c  = 'Micronesia';
                } 
                if(l.ISD_Code__c=='00377'){ 
                    l.Country_R__c  = 'Monaco';
                } 
                if(l.ISD_Code__c=='00976'){
                    l.Country_R__c  = 'Mongolia';
                } 
                if(l.ISD_Code__c=='001664'){
                    l.Country_R__c  = 'Montserrat';
                } 
                if(l.ISD_Code__c=='00258'){ 
                    l.Country_R__c  = 'Mozambique';
                } 
                if(l.ISD_Code__c=='0095'){ 
                    l.Country_R__c  = 'Myanmar';
                }
                if(l.ISD_Code__c=='00674'){
                    l.Country_R__c  = 'Nauru';
                }
                if(l.ISD_Code__c=='00687'){
                    l.Country_R__c  = 'New Caledonia';
                } 
                if(l.ISD_Code__c=='00227'){ 
                    l.Country_R__c  = 'Niger';
                } 
                if(l.ISD_Code__c=='00683'){ 
                    l.Country_R__c  = 'Niue';
                } 
                if(l.ISD_Code__c=='006723'){ 
                    l.Country_R__c  = 'Norfolk Island';
                } 
                if(l.ISD_Code__c=='001670 '){ 
                    l.Country_R__c  = 'Northern Mariana Islands';
                } 
                if(l.ISD_Code__c=='00680'){ 
                    l.Country_R__c  = 'Palau';
                } 
                if(l.ISD_Code__c=='00675'){ 
                    l.Country_R__c  = 'Papua New Guinea';
                } 
                if(l.ISD_Code__c=='002595'){ 
                    l.Country_R__c  = 'Paraguay';
                } 
                if(l.ISD_Code__c=='0063'){ 
                    l.Country_R__c  = 'Pitcairn Island';
                } 
                if(l.ISD_Code__c=='001939'){ 
                    l.Country_R__c  = 'Puerto Rico';
                } 
                if(l.ISD_Code__c=='00262'){ 
                    l.Country_R__c  = 'Reunion';
                } 
                if(l.ISD_Code__c=='00250'){ 
                    l.Country_R__c  = 'Rwanda';
                } 
                if(l.ISD_Code__c=='007'){ 
                    l.Country_R__c  = 'S. Georgia and S. Sandwich Isls.';
                } 
                if(l.ISD_Code__c=='001869'){
                    l.Country_R__c  = 'Saint Kitts and Nevis';
                } 
                if(l.ISD_Code__c=='001758'){ 
                    l.Country_R__c  = 'Saint Lucia';
                }
                if(l.ISD_Code__c=='001784 '){ 
                    l.Country_R__c  = 'Saint Vincent and The Grenadines';
                } 
                if(l.ISD_Code__c=='00685'){ 
                    l.Country_R__c  = 'Samoa';
                }
                if(l.ISD_Code__c=='00378'){
                    l.Country_R__c  = 'San Marino';
                } 
                if(l.ISD_Code__c=='00378'){ 
                    l.Country_R__c  = 'Sao Tome and Principe';
                } 
                if(l.ISD_Code__c=='00221'){   
                    l.Country_R__c  = 'Senegal';
                } 
                if(l.ISD_Code__c=='00248'){ 
                    l.Country_R__c  = 'Seychelles';
                } 
                if(l.ISD_Code__c=='00232'){
                    l.Country_R__c  = 'Sierra Leone';
                } 
                if(l.ISD_Code__c=='00421'){ 
                    l.Country_R__c  = 'Slovakia';
                } 
                if(l.ISD_Code__c=='00252'){
                  
                  l.Country_R__c  = 'Somalia';
                } 
                if(l.ISD_Code__c=='00290'){
                    l.Country_R__c  = 'St. Helena';
                } 
                if(l.ISD_Code__c=='00508'){ 
                    l.Country_R__c  = 'St. Pierre and Miquelon';
                }
                if(l.ISD_Code__c=='00249'){ 
                    l.Country_R__c  = 'Sudan';
                } 
                if(l.ISD_Code__c=='00597'){ 
                    l.Country_R__c  = 'Suriname';
                } 
                if(l.ISD_Code__c=='00597'){ 
                    l.Country_R__c  = 'Svalbard and Jan Mayen Islands';
                } 
                if(l.ISD_Code__c=='00268'){   
                    l.Country_R__c  = 'Swaziland';
                } 
                if(l.ISD_Code__c=='00992'){ 
                    l.Country_R__c  = 'Tajikistan';
                } 
                if(l.ISD_Code__c=='00690'){ 
                    l.Country_R__c  = 'Tokelau';
                } 
                if(l.ISD_Code__c=='00676'){ 
                    l.Country_R__c  = 'Tonga';
                } 
                if(l.ISD_Code__c=='00993'){ 
                    l.Country_R__c  = 'Turkmenistan';
                } 
                if(l.ISD_Code__c=='001649'){ 
                    l.Country_R__c  = 'Turks and Caicos Islands';
                } 
                if(l.ISD_Code__c=='00688'){ 
                    l.Country_R__c  = 'Tuvalu';
                } 
                if(l.ISD_Code__c=='00678'){   
                    l.Country_R__c  = 'Vanuatu';
                } 
                if(l.ISD_Code__c=='0039'){
                    l.Country_R__c  = 'Vatican City';
                } 
                if(l.ISD_Code__c=='001340'){ 
                    l.Country_R__c  = 'Virgin Islands';
                }
                if(l.ISD_Code__c=='00681'){ 
                    l.Country_R__c  = 'Wallis and Futuna Islands';
                } 
                if(l.ISD_Code__c=='00681'){   
                    l.Country_R__c  = 'Western Sahara';
                } 
                if(l.ISD_Code__c=='00243'){ 
                    l.Country_R__c  = 'Zaire';
                }
                if(l.ISD_Code__c=='00260'){ 
                    l.Country_R__c  = 'Zambia';

                }
            }
        }
    }
}