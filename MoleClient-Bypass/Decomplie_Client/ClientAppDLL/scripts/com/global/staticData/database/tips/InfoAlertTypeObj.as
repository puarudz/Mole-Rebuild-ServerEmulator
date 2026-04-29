package com.global.staticData.database.tips
{
   public class InfoAlertTypeObj
   {
      
      public static const AlertTypeObj:Object = new Object();
      
      AlertTypeObj[1] = {"slAlter":1};
      AlertTypeObj[2] = {
         "style":"100",
         "levelType":"2",
         "url":"",
         "bottomArray":"npcgo,notgo",
         "closeB":"true",
         "SOS":"",
         "picTip":"E"
      };
      AlertTypeObj[3] = {
         "style":"100",
         "levelType":"2",
         "url":"resource/allJob/icon/190301.swf",
         "bottomArray":"otherJob_konw",
         "closeB":"true",
         "SOS":"",
         "picTip":"EMP_BUY"
      };
      AlertTypeObj[4] = {
         "style":"100",
         "levelType":"2",
         "url":"",
         "bottomArray":"otherJob_konw",
         "closeB":"true",
         "SOS":"",
         "picTip":"E"
      };
      AlertTypeObj[5] = {
         "style":"100",
         "levelType":"2",
         "url":"",
         "bottomArray":"go",
         "closeB":"true",
         "SOS":"true",
         "picTip":"E"
      };
      
      public function InfoAlertTypeObj()
      {
         super();
      }
   }
}

