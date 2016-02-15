trigger ProjectURLforEbrochure on Lead (before Insert, before update) {
LeadPullProject.pullmethod(Trigger.New);
}