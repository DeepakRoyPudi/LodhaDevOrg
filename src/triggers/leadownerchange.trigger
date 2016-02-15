trigger leadownerchange on Lead (before insert) 
{
ChangeOwnerID.Updatemethod1(Trigger.New);
}