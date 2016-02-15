/*!
 * jQuery JavaScript
 * 
 *
 * 
 * It is the propery of Eternus Solutions
 * 
 *
 * Created By Sudeep Dube 6/9/2015
 * 
 * Description The year range increase by the calling the funtion name : yearIncr(a,b)
 *  a=no of year from first option like first option is 2014 and a=2;  
 *  b=no of year from last(seventh) option like last option is 2020 and b=4;   
 *  older year range 2014 to 2020
 *  New year range  2012 to 2024
 * then year range become 
 * 
 */
  var boolvar=0;
  function yearIncr(){
       
        if(boolvar==0){
		boolvar=1;
		
     
	    //get current year stores in var n
	    var d = new Date();
        var n = d.getFullYear();
       
	   $("#calYearPicker option").remove();

	   for (var i=n-100;i<=n+100  ;i++){
          //console.log(i);
		  
          var optionvar  ='<option value=' +i+ '>' +i+ '</option>';  
          $('#calYearPicker').append(optionvar);       
          }
		  
         }
  }
  
  
 