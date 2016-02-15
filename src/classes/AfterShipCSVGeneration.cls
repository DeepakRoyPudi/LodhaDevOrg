global class AfterShipCSVGeneration {
	webService static String generateCSVString(){
		
		// Updating the Slug name depending on the Courier name from Custom setting
		List<Despatch__c> listDespatch = new List<Despatch__c>();
		List<Despatch__c> listDespatchToUpdate = new List<Despatch__c>();
		List<CourierSlugMapping__c> listCourier = new List<CourierSlugMapping__c>();
		Map<String, String> mapCourierNameSlug = new Map<String, String>();
		
		// Creating a map of Corier Name and Slug from CourierSlugMapping Custom Setting
		listCourier = [select Id,
		                      Name,
		                      Slug__c
		               from CourierSlugMapping__c];
		               
        for(CourierSlugMapping__c setting : listCourier){
        	mapCourierNameSlug.put(setting.Name, setting.Slug__c);
        }
		
		listDespatch = [select id, 
		                       Slug__c, 
		                       Waybill_No__c, 
		                       Courier_Name__c, 
		                       Last_Delivery_Status__c,
		                       Rec_Name__c 
		                from Despatch__c];
		                //where CreatedDate >= :date.parse('1/5/2014') and CreatedDate <= :date.parse('30/5/2014') limit 2];
		                
	   for(Despatch__c oDespatch : listDespatch){
	       if(oDespatch.Slug__c == null || String.isBlank(oDespatch.Slug__c)){
	           oDespatch.Slug__c = mapCourierNameSlug.get(oDespatch.Courier_Name__c);
	           listDespatchToUpdate.add(oDespatch);
	       }
	   }
	   if(!listDespatchToUpdate.isEmpty())
	       Database.Saveresult[] updateResult = Database.update(listDespatchToUpdate);             
		
		// Creating a CSV String for passing to the Java program where the webservice is getting consumed.
		String csvString = 'courier,tracking_number,email,sms,order_id,title,order_path,customer_name,origin_country,destination_country,custom_1,custom_2\n';
		
		for(Despatch__c oDespatch : listDespatch){

		        if(oDespatch.slug__c != '' && oDespatch.Waybill_No__c != null)
		            csvString = csvString + oDespatch.slug__c + ',' + oDespatch.Waybill_No__c +  ',' + '' + ',' + '' + ',' + '' + ',' + oDespatch.Courier_Name__c + ',' + '' + ',' + oDespatch.Rec_Name__c + '\n';
		}// end of for
		return csvString;
	}// end of generateCSVString()
}