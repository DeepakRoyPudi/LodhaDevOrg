public with sharing class ActivitySearchController {
 
  // the soql without the order and limit
  private String soql {get;set;}
  public String accid {get;set;}
  // the collection of Activities to display
  public List<Task> tasks {get;set;}
  public String contId {get; set;}
  public Task tsk;

  // the current sort direction. defaults to asc
  public String sortDir {
    get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
    set;
  }
 
  // the current field to sort by. defaults to last name
  public String sortField {
    get  { if (sortField == null) {sortField = 'Subject'; } return sortField;  }
    set;
  }
 
  // format the soql for display on the visualforce page
  /*public String debugSoql {
    get { return soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20'; }
    set;
  }*/
    
    public ActivitySearchController.ActivitySearchController(ApexPages.StandardController stdcontroller){
        this.tsk = (Task)stdController.getRecord();
    string status = 'Completed';
    soql = 'select Subject, Query_Type__c, Query_Sub_Type__c,ActivityDate,CreatedDate from Task WHERE (WhatId =:accid OR WhoId = :contId) and Status LIKE \''+String.escapeSingleQuotes(Status)+'%\'';
    //soql += ' and Status LIKE \''+String.escapeSingleQuotes(Completed)+'%\'';
    accid = System.currentPagereference().getParameters().get('accid');
    if(accid != null){
        contId = [Select id from Contact where Accountid = :accid].id;
        }
    runQuery();
    }
  // init the controller and display some sample data when the page loads
  public ActivitySearchController () {
    

  }
 
  // toggles the sorting of query from asc<-->desc
  public void toggleSort() {
    // simply toggle the direction
    sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
    // run the query again
    runQuery();
  }
 
  // runs the actual query
  public void runQuery() {
 
    try {
      tasks = Database.query(soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20');
    } catch (Exception e) {
      //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'));
      ApexPages.addMessages(e);
    }
 
  }
 
  // runs the search with parameters passed via Javascript
  public PageReference runSearch() {
 
    String subject = Apexpages.currentPage().getParameters().get('subject');
    String queryType = Apexpages.currentPage().getParameters().get('queryType');
    String querySubtype = Apexpages.currentPage().getParameters().get('querySubtype');
    querySubtype = querySubtype.replace('_','');
    querySubtype = querySubtype.replace('','');

    String status = 'Completed';
    system.debug('querySubtype$$$: '+ (queryType.equals(null)));
    soql = 'select Subject, Query_Type__c, Query_Sub_Type__c,ActivityDate,CreatedDate from Task WHERE (WhatId =:accid OR WhoId = :contId)';
    soql += ' and Status LIKE \''+String.escapeSingleQuotes(Status)+'%\'';
    if (!subject.equals(''))
      soql += 'and Subject LIKE \'%'+String.escapeSingleQuotes(Subject)+'%\'';
    if (!queryType.equals(''))
      soql += 'and Query_Type__c LIKE \''+String.escapeSingleQuotes(queryType)+'%\''; 
    //if (!querySubtype.equals(''))
    if(querySubtype != null && querySubtype != '')
        {soql += 'and Query_Sub_Type__c LIKE \''+String.escapeSingleQuotes(querySubtype)+'\'';}
    // run the query again
    runQuery();
 
    return null;
  }
 
  // use apex describe to build the picklist values
  /*public List<String> querytype {
    get {
      if (querytype == null) {
 
        querytype = new List<String>();
        Schema.DescribeFieldResult field = Task.Query_Type__c.getDescribe();
 
        for (Schema.PicklistEntry f : field.getPicklistValues())
          querytype.add(f.getLabel());
 
      }
      return querytype;          
    }
    set;
  }
  public List<String> querySubtype {
    get {
      if (querySubtype == null) {
 
        querySubtype = new List<String>();
        Schema.DescribeFieldResult field = Task.Query_Sub_Type__c.getDescribe();
 
        for (Schema.PicklistEntry f : field.getPicklistValues())
          querySubtype.add(f.getLabel());
 
      }
      return querySubtype;          
    }
    set;
  }*/
 
}