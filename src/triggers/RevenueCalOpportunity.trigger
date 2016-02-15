trigger RevenueCalOpportunity on Opportunity(after insert, after update) {
        OpportunityInsert.RevenueCalculation(trigger.new);
}