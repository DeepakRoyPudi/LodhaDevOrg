trigger CM_Validation_Updation on Case (Before Insert, Before Update) {
    
    List<Case> cList = new list<Case>();
    List<Case> cUpdateList = new list<Case>();
    set<Id> CaseIds = new set<Id>();
    
    CM_Upd_Val_SMS_Notification esc = new CM_Upd_Val_SMS_Notification();
    CM_FutureMethods future = new CM_FutureMethods();
    
    if(trigger.IsBefore){
        if(trigger.IsInsert){
            for (Case cs : Trigger.new){
                
                cs.Queue_Id__c = cs.ownerId;
                
                if(cs.TL_EmailId__c != ''){
                    cs.TL_Email_Id__c = cs.TL_EmailId__c;
                }
                if(cs.PIC_EmailId__c != ''){
                    cs.PIC_Email_Id__c = cs.PIC_EmailId__c;
                }
            }
        }
        
        if(trigger.IsUpdate){
            
        if(CM_FutureMethods.flag1 == true){
           CM_FutureMethods.flag1 = false;
              
            for (Case cs : Trigger.new){
                
                esc.updateEscalatedToEmail(Trigger.new);
                
                cs.Queue_Id__c = cs.ownerId;
                CaseIds.add(cs.id);
                
                for (Case c : Trigger.old){
                    if(c.OwnerId != cs.OwnerId){
                        cs.OldOwnerId__c = c.OwnerId;
                    }
                    
                    //Closed cases cannot be edited Validation
                    if(c.Status == 'Closed Satisfied' || c.Status == 'Closed UnSatisfied'){
                        //cs.addError('Cannot edit a Closed Case');
                    }
                }
            }
            
            Id recTypeDummyParentId = [SELECT Id,Name FROM RecordType WHERE Name = 'CM_Dummy_Parent' LIMIT 1].Id;        
            Id recTypeParentOnlyId = [SELECT Id,Name FROM RecordType WHERE Name = 'CM_Parent_Only' LIMIT 1].Id;
            Id recTypeChildCaseId = [SELECT Id,Name FROM RecordType WHERE Name = 'CM_Child_Case' LIMIT 1].Id;        
            Id recTypeActionItemId = [SELECT Id,Name FROM RecordType WHERE Name = 'CM_Action_Item' LIMIT 1].Id;
            
            cList = [Select Id, Status, CaseNumber, OwnerId, ParentId from Case Where (RecordTypeId =: recTypeChildCaseId or RecordTypeId =: recTypeActionItemId) and (Status != 'Closed Satisfied' and Status != 'Closed UnSatisfied') and ParentId IN: CaseIds ];
            
            system.debug('cList.size()' +cList.size());
            
            //Parent case closure validation
            if(cList.size() > 0){
                for (Case cs : Trigger.new){
                    
                    system.debug('## cs.Status : ' +cs.Status);
                    
                    if((cs.Status == 'Closed Satisfied' || cs.Status == 'Closed UnSatisfied') && (cs.RecordTypeId == recTypeDummyParentId || cs.RecordTypeId == recTypeParentOnlyId || cs.RecordTypeId == recTypeChildCaseId)){  
                        
                        for (Case chCase : cList){
                            if(cs.Id == chCase.ParentId){
                                cs.addError('Sub case '+chCase.CaseNumber+' is not yet closed');
                            }
                        }    
                    }
                }
            }
        }
        
        }
    
    }
}