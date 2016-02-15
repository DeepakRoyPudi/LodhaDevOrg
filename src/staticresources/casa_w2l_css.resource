*{margin: 0; padding: 0;}
body{margin: 0; padding: 0;}

.clear{clear: both;}


/** CONTACTBOX AND HEADING **/
#casa_contact_box{
  width: 216px; 
  background: #fff;
  margin-left: 7px;
 }

#casa_contact_box h2 {font-size: 14px; font-family: Arial, Helvetica, sans-serif; color: #1c7b84; padding-bottom: 5px;}
#casa_contact_box span#bold_strip{width: 40px; height: 4px; background: #1c7b84;}
#casa_contact_box #heading_border {border-bottom: 1px solid #999; height: 3px; position: relative; margin-bottom: 14px;}
#casa_contact_box #heading_border span{background: #1c7b84; height: 3px; position: absolute;right: 10px; width: 20px; top: 2px;}

/** FORM STYLING **/
#casa_contact_box form{ font-size:11px; margin-left: 7px;}
#casa_contact_box form p{margin-bottom: 17px;}
#casa_contact_box form label{display: inline-block; width: 58px; color: #555; font-family:Arial,Tahoma,Verdana,Helvetica,Sans-serif;}
#casa_contact_box form label span{color: red; font-family: Tahoma,Verdana,helvetica,sans-serif,Arial;}
#casa_contact_box input{font-size: 11px; color: #999; width: 142px;font-family: Tahoma,Verdana,helvetica,sans-serif,Arial; border: 1px solid #999;}
#casa_contact_box select {border: 1px solid #999;}
#casa_contact_box label.label_full_width{width: 100%;}

#casa_contact_box input.country_code{width: 43px;}
#casa_contact_box input.mob_num{width: 87px;}
#casa_contact_box input.std_code{width: 27px;}
#casa_contact_box input.ll_num{width: 48px;}

/** FORM STYLING - SELECTBOX**/
#casa_contact_box select {width: 144px; font-size:10px; color: #999;}

/** FORM STYLING - RESIDENCE CHOICE**/
#casa_contact_box #residence_choice{margin-bottom: 17px;}
#casa_contact_box #residence_choice p{float: left; width: 64px;}
#casa_contact_box #residence_choice p label{width: auto; display: inline;}
#casa_contact_box #residence_choice p input{width: auto;margin-right: 3px;}
#casa_contact_box #residence_choice p:first-child{margin-bottom: 8px; width: 100%; float:none;}
#casa_contact_box #residence_choice input{border: none;}

/**override SF styling here **/
#casa_contact_box #residence_choice table td{width: 94px; float: left; padding-bottom: 4px;}
#casa_contact_box #residence_choice table td input { position: relative; top: -2px; vertical-align: middle; width: auto;}
#casa_contact_box #residence_choice table td label {display: inline-block; padding-left: 3px; width: 72px;}


/** override SF city styling **/

#casa_contact_box p#city_field{}
#casa_contact_box p#city_field input,#casa_contact_box p#city_field select{float: right; margin-right: 7px;}

span.ll_eg_code{font-size: 10px; color: #999; display: block; padding: 0 0 0 69px; font-family: Tahoma,Verdana,helvetica,sans-serif,Arial;}
span.ll_eg_code.eg_top { padding-bottom: 8px;}
span.ll_eg_code.eg_bottom {padding-top: 8px;}

/** SUBMIT BUTTON **/
#casa_contact_box input.casa_submit_btn {width: auto; border: 0; text-align: center; display: block; margin: 0 auto;}

/** ERROR MESSGAES **/
#casa_contact_box form span.err_msg {display: none; color: red; padding-left: 69px;font-family: Tahoma,Verdana,helvetica,sans-serif,Arial; font-size: 10px;}

