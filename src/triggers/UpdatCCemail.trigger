trigger UpdatCCemail on Opportunity (before insert, before update) {
updateCC_email.updatccemailOnOppty(trigger.new);
}