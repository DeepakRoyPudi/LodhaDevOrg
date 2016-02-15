trigger Ownership on Lead (before update)
{
Restrictchangeownership.ownership(trigger.new);
}