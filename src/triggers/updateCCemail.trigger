trigger updateCCemail on Lead (before insert, before update) {
updateCC_email.updateCCemailOnLead(trigger.new);
}