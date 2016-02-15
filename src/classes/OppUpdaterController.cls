public class OppUpdaterController {

    public OppUpdaterController() {
    }
    
	public void autoUpdate(){		
		
 				CallRatingUpdaterBatch cr = new CallRatingUpdaterBatch();
				database.ExecuteBatch(cr);
				return;		

	} 
 
}