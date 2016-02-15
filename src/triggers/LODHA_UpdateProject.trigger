trigger LODHA_UpdateProject on Lead (after Insert,after update) {
LODHA_UpdateProjectInterested.InsertUpdateReferral(Trigger.New);
}