trigger CampaignUniqueName on Campaign (before insert, before update) {

    UniqueNameValidation Un = new UniqueNameValidation();
    
    if(trigger.Isinsert && trigger.Isbefore){
        Un.nameValidation(Trigger.new);
    }
    
    if(trigger.Isupdate && trigger.Isbefore){
        Un.nameValidation(Trigger.new);
    }

}