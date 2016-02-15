/*/*Description:
This class is used for ConstructionUpdatesCSS2_0 Component
@Created by: Trupti Dhoka 
@Created Date:  20/03/15   
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |Trupti Dhoka      21/03/2015                  1.0        Added slider for images
 --------------------------------------------------------------------------------
 |Trupti Dhoka      27/04/2015                  1.1        Added slider for 6 videos
 --------------------------------------------------------------------------------
*/

public class ConstructionUpdatesCSS2_0Controller {
    
    public String Customer_CRN {get;set;} //get parameter from component
    private list<Project_Image__c> projectImageslst; //get project images
    private list<Project_Image__c> CommonImagelst;//get common eminities project images
    public list<string> list_Videos{get;set;}
    public list<Construction_items> listConstrctionImg  {get;set;}
    public list<Construction_videos>listConstructionVideo {get;set;}
    public list<Construction_items> CommonEminitiesImageslst {get ; set;} //get common eminities project images from wrapper
    public list<Project_Name__c> project_videos {get;set;}
    
    public boolean isProjectWise {get;set;}
    public string imageUrl{get;set;}
    //Google Analytics variables
      
    public static String username{get;set;}
    public static String userCRN{get;set;}
    public static String userProject{get;set;}
    public static String userSeqment{get;set;}
    public static DateTime userLastLogin {get;set;}
    private static final String partialThumbnailUrl1 ='http://img.youtube.com/vi/';
    private static final String partialThumbnailUrl2 ='/default.jpg';
    private static final String value_Http = 'http';
    private static final String value_amp = 'amp;';
    public ConstructionUpdatesCSS2_0Controller(){
        init();
    }
    
    public void init() {
        //get CRN of a/c 
        String userId=Userinfo.getUserid();
        list_Videos = new list<String>();
        Customer_CRN = CreateQueryHelper.getCustomerCRN(userId);  
        listConstrctionImg = new list<Construction_items>();
        listConstructionVideo = new list <Construction_videos>();
        CommonEminitiesImageslst = new list<Construction_items>();
        project_videos = new list<Project_Name__c>();
        
        if(String.isNotBlank(Customer_CRN)){   
            //get project name on a/c into string variable
            List<Account> lstprojectName =[Select a.Project_Name__c ,id 
                                                From Account a 
                                                    where CRN__C =: Customer_CRN]; 
            
            if(lstprojectName.size()>0)
            {
                Account projectName=lstprojectName[0];
                if(String.isNOtBlank(projectName.Project_Name__c)) {
                //get Booking details
                    List<Booking_Details__c> BookDetailList =[SELECT Id, CLuster__c, Wing__c, Account__c 
                                                                    from Booking_Details__c 
                                                                        Where Account__c =: projectName.Id 
                                                                            limit 1];
                    //get project name
                    String PName = projectName.Project_Name__c;
                    if(!String.isEmpty(PName)){
                        project_videos  = [Select p.Id,p.Name,Project_video1__c,Project_video2__c,
                                            Project_video3__c,Project_video4__c,Project_video5__c,
                                            Project_video6__c
                                                From Project_Name__c p 
                                                    where p.Name LIKE:PName limit 1]; 
                        
                    //get associated project images
                        if(BookDetailList.size()>0 && BookDetailList != null && 
                                project_videos != null && project_videos.size() > 0){
                            projectImageslst = [Select p.Project_View__c,Cluster__c,Photo_Description__c,
                                    Name,Wing__c, p.IsActive__c, p.Id ,p.Project_Name__r.name
                                        From Project_Image__c p 
                                                where p.Project_Name__c=: project_videos[0].id 
                                                    and IsActive__c = true and IsCommon__c=false 
                                                    and Cluster__c =: BookDetailList[0].CLuster__c 
                                                    and Wing__c =: BookDetailList[0].Wing__c
                                                        ORDER BY CreatedDate DESC ];
                  
                            CommonImagelst =[Select p.Project_View__c,Cluster__c,Photo_Description__c,
                                    Name,Wing__c, p.IsActive__c, p.Id ,p.Project_Name__r.name
                                        From Project_Image__c p 
                                            where p.Project_Name__c=: project_videos[0].id 
                                                and IsActive__c =true and IsCommon__c=true 
                                                    ORDER BY CreatedDate DESC];
                            for(Project_Image__c p : projectImageslst){
                                Construction_items item=new Construction_items();
                                item.Cluster  = p.Cluster__c;
                                //item.Name  = p.Name;
                                item.Wing  = p.Wing__c;
                                item.project_Name = p.Project_Name__r.name;
                                item.image_Description  = p.Photo_Description__c;
                                String project_URL = '';
                
                                if(String.isNotBlank(p.Project_View__c)){
                                   project_URL = ((String)p.Project_View__c).substringBetween('src="' ,'"></img>');
                                    if(String.isNotBlank(project_URL) && project_URL.contains('"'))
                                       project_URL = project_URL.substringBefore('"'); 
                                       project_URL= project_URL.remove(value_amp);
                                       if(String.isNotBlank(project_URL) && !project_URL.contains(value_Http))
                                    {
                                      project_URL = URL.getSalesforceBaseUrl().toExternalForm()+project_URL;
                                      project_URL= project_URL.remove(value_amp);
                                    }
                                     item.project_View  = project_URL;
                                     listConstrctionImg.add(item); 
                                     
                                }
                            }
            
                            //add common eminities into list
                            for(Project_Image__c p :CommonImagelst ){
                                Construction_items item=new Construction_items();
                                item.Cluster  = p.Cluster__c;
                                item.image_Description  = p.Photo_Description__c;
                                //item.Name  = p.Name;
                                item.Wing  = p.Wing__c;
                                item.project_Name = p.Project_Name__r.name;
                                String project_URL = '';
                                
                                if(String.isNotBlank(p.Project_View__c)){
                                   project_URL = ((String)p.Project_View__c).substringBetween('src="' ,'"></img>');
                                    if(String.isNotBlank(project_URL) && project_URL.contains('"'))
                                         project_URL = project_URL.substringBefore('"'); 
                                     project_URL= project_URL.remove(value_amp);
                                       if(String.isNotBlank(project_URL) && !project_URL.contains(value_Http)){
                                      project_URL = URL.getSalesforceBaseUrl().toExternalForm()+project_URL;
                                      project_URL= project_URL.remove(value_amp);
                                    }
                                     item.project_View  = project_URL;
                                     CommonEminitiesImageslst.add(item); 
                                }
                            }
            
                             //call createVideoslist method 
                            if(project_videos != null && project_videos.size() > 0){
                                 createVideoslist(project_videos[0].Project_video1__c)  ; 
                                 createVideoslist(project_videos[0].Project_video2__c)  ;
                                 createVideoslist(project_videos[0].Project_video3__c)  ;
                                 createVideoslist(project_videos[0].Project_video4__c)  ;
                                 createVideoslist(project_videos[0].Project_video5__c)  ;
                                 createVideoslist(project_videos[0].Project_video6__c)  ;
             
                            }               
           
                            // Google Analytics
                            GoogleAnalyticsHelper.GetReportParameters(userId); 
                            username = GoogleAnalyticsHelper.username;
                            userCRN = GoogleAnalyticsHelper.userCRN ;
                            userProject =GoogleAnalyticsHelper.userProject;
                            userSeqment = GoogleAnalyticsHelper.userSeqment;   
                            userLastLogin= GoogleAnalyticsHelper.userLastLogin;  
                            checkBackgroundImage();
                        } //(#EOF BookDetailList.size)
            
                    } //(EOF (!String.isEmpty(PName)))
                }   //EOF (not null projectName.project_Name__c)
            } //EOF(not null lstprojectName)
        }//EOF (Not null Customer_CRN)
    }//EOF init
       
    public void createVideoslist(String videoUrl){
        if(! String.isBlank(videoUrl)){
               Construction_videos video1 = new Construction_videos();
               video1.youTube_URL = videoUrl;
               video1.youTubeThumbnail_URL = createYoutubeThumbnailURL(videoUrl);
               listConstructionVideo.add(video1);
        }  
           
        }
        public String createYoutubeThumbnailURL(String url){
        String finalurl = '';
        if(String.isNotBlank(url)){
            String vid  =  url.substringAfterLast('/');
             finalurl = partialThumbnailUrl1+vid+partialThumbnailUrl2;
         }
         return finalurl;
        }
        /* Function to determine if the Background image will be displayed project wise 
         or the Default image will be displayed.*/
        public void checkBackgroundImage() {
        BackgroundImageHelper.populateBackgroundImgParam(userCRN);
        isProjectWise = BackgroundImageHelper.isProjectWise;
        imageUrl = BackgroundImageHelper.imageUrl;            
        }
        //Wrapper class for showing images info and extracted URL from rich Text Area
        public class Construction_items {
        public String project_View {get;set;} // contains image URL
        public String Cluster {get;set;}
        public String project_Name {get;set;}
        public String image_Description {get;set;}
        public String Wing {get;set;}
        //public String Name{get;set;}
        
        } 
        
         //Wrapper class for showing videos info 
        public class Construction_videos {
        public String youTube_URL {get;set;}
        public String youTubeThumbnail_URL {get;set;}
        } 
}