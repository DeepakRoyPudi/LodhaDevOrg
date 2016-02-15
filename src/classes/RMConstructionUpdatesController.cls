/*/*Description:
This class is used for ConstructionUpdates RM page
@Created by: Trupti Dhoka 
@Created Date:  20/03/15   

--------------------------------------------------------------------------------
| Modified By      | Modified Date       | Version        | Description         |
--------------------------------------------------------------------------------
|Trupti Dhoka      21/03/2015                  1.0        Added slider for images
--------------------------------------------------------------------------------
|Trupti Dhoka      27/04/2015                  1.1        Added slider for 6 videos
--------------------------------------------------------------------------------
|Sudeep Dube       24/07/2015                  1.2        Update Class for RM construction Update page      
-------------------------------------------------------------------------------------------------------
|Sudeep Dube	   30/07/2015				   1.2	      Update some code after review        
*/

public class RMConstructionUpdatesController {
    
    public String Customer_CRN {get;set;} //get parameter from component
    private list<Project_Image__c> projectImageslst; //get project images
    private list<Project_Image__c> CommonImagelst;//get common eminities project images
 
    public list<string> list_Videos{get;set;}
    public list<Construction_items> listConstrctionImg  {get;set;}
    public list<Construction_videos>listConstructionVideo {get;set;}
    public list<Construction_items> CommonEminitiesImageslst {get ; set;} //get common eminities project images from wrapper
    public list<Project_Name__c> project_videos {get;set;}
    
    //boolean variable to check if all project related videos are not empty
    //public boolean isContainVideo {get;set;}
    
    
    public boolean isProjectWise {get;set;}
    public string imageUrl{get;set;}
   
    public static final String partialThumbnailUrl1 ='http://img.youtube.com/vi/';
    public static final String partialThumbnailUrl2 ='/default.jpg';
    
    public static final String amp='amp;';
    public static final String startURL='http';
    
    public RMConstructionUpdatesController()
    {
        init();
    }
    
    public void init()
    {
        //get CRN of a/c 
        //String userId=Userinfo.getUserid();
        list_Videos = new list<String>();
        Customer_CRN = ApexPages.currentPage().getParameters().get('CRN');  
        //isContainVideo = false;
        listConstrctionImg = new list<Construction_items>();
        listConstructionVideo = new list <Construction_videos>();
        CommonEminitiesImageslst = new list<Construction_items>();
        project_videos = new list<Project_Name__c>();
        
        if(String.isNotBlank(Customer_CRN))
        {   
            //get project name on a/c into string variable
            
            List<Account> listAccountOfProject=[Select a.Project_Name__c,
                                                       id 
                                                From Account a 
                                                where CRN__C =: Customer_CRN]; 
            
            if(listAccountOfProject.size()>0){
                
                Account projectName=listAccountOfProject[0];
                
                if(String.isNOtBlank(projectName.Project_Name__c)){
                    //get Booking details
                    List<Booking_Details__c> BookDetailList = [SELECT Id, CLuster__c, Wing__c, Account__c 
                                                               from Booking_Details__c 
                                                               Where Account__c =: projectName.Id limit 1];
                    //get project name
                    String PName = projectName.Project_Name__c;
                    if(!String.isEmpty(PName))
                    {
                        project_videos  = [Select p.Id,p.Name,Project_video1__c,Project_video2__c,Project_video3__c,
                                           Project_video4__c,Project_video5__c,Project_video6__c
                                           From Project_Name__c p 
                                           where p.Name LIKE:PName limit 1]; 
                        
                        
                        //get associated project images
                        if(BookDetailList.size()>0 && BookDetailList != null && project_videos != null && project_videos.size() > 0)
                        {
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
                            
                            
                            if(projectImageslst.size()>0){
                                //add list into warpper
                                for(Project_Image__c p : projectImageslst){
                                    Construction_items  item=new Construction_items();
                                                        item.cluster  = p.Cluster__c;
                                                        item.name  = p.Name;
                                                        item.wing  = p.Wing__c;
                                                        item.project_Name = p.Project_Name__r.name;
                                                        item.image_Description  = p.Photo_Description__c;
                                                        String project_URL = '';
                                        
                                    if(String.isNotBlank(p.Project_View__c)){
                                        
                                        project_URL = ((String)p.Project_View__c).substringBetween('src="' ,'"></img>');
                                        if(String.isNotBlank(project_URL)  && project_URL.contains('"'))
                                            project_URL = project_URL.substringBefore('"'); 
                                            project_URL=  project_URL.remove(amp);
                                        
                                        if(!project_URL.contains(startURL))
                                        {
                                            project_URL =Site.getBaseUrl()+project_URL;
                                            project_URL= project_URL.remove(amp);
                                        }
                                        
                                        item.project_View  = project_URL;
                                        listConstrctionImg.add(item); 
                                    }
                                }
                            }
                            
                            //add common eminities into list
                            if(CommonImagelst.size()>0) {
                                
                                for(Project_Image__c p :CommonImagelst ){
                                    Construction_items item=new Construction_items();
                                                       item.cluster  = p.Cluster__c;
                                                       item.image_Description  = p.Photo_Description__c;
                                                       item.name  = p.Name;
                                                       item.wing  = p.Wing__c;
                                                       item.project_Name = p.Project_Name__r.name;
                                                       String project_URL = '';
                                    
                                    if(String.isNotBlank(p.Project_View__c)) {
                                        
                                        project_URL = ((String)p.Project_View__c).substringBetween('src="' ,'"></img>');
                                        if(String.isNotBlank(project_URL) && project_URL.contains('"'))
                                            project_URL = project_URL.substringBefore('"'); 
                                            project_URL = project_URL.remove(amp);
                                        
                                        if(!project_URL.contains(startURL))
                                        {
                                            project_URL =Site.getBaseUrl()+project_URL;
                                            project_URL= project_URL.remove(amp);
                                        }
                                        
                                        item.project_View  = project_URL;
                                        CommonEminitiesImageslst.add(item); 
                                    }
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
                        }
                    }
                }
                
            }
            
        }
    }
    public void createVideoslist(String videoUrl){
        if(! String.isBlank(videoUrl))
        {
            Construction_videos video1 = new Construction_videos();
            video1.youTube_URL = videoUrl;
            video1.youTubeThubnail_URL = createYoutubeThumbnailURL(videoUrl);
            listConstructionVideo.add(video1);
        }  
        
    }
    public String createYoutubeThumbnailURL(String url){
        String finalurl = '';
        System.debug('url::'+url);
        if(String.isNotBlank(url)){
            String vid  =  url.substringAfterLast('/');
            
            finalurl = partialThumbnailUrl1+vid+partialThumbnailUrl2;
        }
        return finalurl;
    }
    /* Function to determine if the Background image will be displayed project wise 
or the Default image will be displayed.*/
    public void checkBackgroundImage() {
        BackgroundImageHelper.populateBackgroundImgParam(Customer_CRN );
        isProjectWise = BackgroundImageHelper.isProjectWise;
        imageUrl = BackgroundImageHelper.imageUrl;            
    }
    //Wrapper class for showing images info and extracted URL from rich Text Area
    public class Construction_items {
        public String  project_View {get;set;} // contains image URL
        public String  cluster {get;set;}
        public String  project_Name {get;set;}
        public String  image_Description {get;set;}
        public String  wing {get;set;}
        public String  Name{get;set;}
    } 
    
    //Wrapper class for showing videos info 
    public class Construction_videos {
        public String youTube_URL {get;set;}
        public String youTubeThubnail_URL {get;set;}
        
    } 
}