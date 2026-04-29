package com.module.messageTips
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.global.staticData.XMLInfo;
   
   public class MT
   {
      
      public function MT()
      {
         super();
      }
      
      public static function getMsg(alertId:Number) : String
      {
         var retMsg:String = null;
         if(alertId >= 0)
         {
            retMsg = XMLInfo.AlertObj[alertId];
         }
         else
         {
            retMsg = XMLInfo.AlertErrorObj[alertId];
         }
         return retMsg;
      }
      
      public static function getLevelType(alertId:Number) : String
      {
         var ret:String = null;
         if(alertId >= 0)
         {
            ret = Boolean(XMLInfo.AlertTypeObj[alertId]) ? XMLInfo.AlertTypeObj[alertId].levelType : "";
         }
         else
         {
            ret = Boolean(XMLInfo.AlertErrorTypeObj[alertId]) ? XMLInfo.AlertErrorTypeObj[alertId].levelType : "";
         }
         return ret;
      }
      
      public static function getPicTip(alertId:Number) : String
      {
         var ret:String = null;
         if(alertId >= 0)
         {
            ret = Boolean(XMLInfo.AlertTypeObj[alertId]) ? XMLInfo.AlertTypeObj[alertId].picTip : "";
         }
         else
         {
            ret = Boolean(XMLInfo.AlertErrorTypeObj[alertId]) ? XMLInfo.AlertErrorTypeObj[alertId].picTip : "";
         }
         return ret;
      }
      
      public static function getStyle(alertId:Number) : String
      {
         var ret:String = null;
         if(alertId >= 0)
         {
            ret = Boolean(XMLInfo.AlertTypeObj[alertId]) ? XMLInfo.AlertTypeObj[alertId].style : "";
         }
         else
         {
            ret = Boolean(XMLInfo.AlertErrorTypeObj[alertId]) ? XMLInfo.AlertErrorTypeObj[alertId].style : "";
         }
         return ret;
      }
      
      public static function getUrl(alertId:Number) : String
      {
         var ret:String = null;
         if(alertId >= 0)
         {
            ret = XMLInfo.AlertTypeObj[alertId].url;
         }
         else
         {
            ret = XMLInfo.AlertErrorTypeObj[alertId].url;
         }
         return ret;
      }
      
      public static function getBottomArray(alertId:Number) : String
      {
         var ret:String = null;
         if(alertId >= 0)
         {
            ret = XMLInfo.AlertTypeObj[alertId].bottomArray;
         }
         else
         {
            ret = XMLInfo.AlertErrorTypeObj[alertId].bottomArray;
         }
         return ret;
      }
      
      public static function getCloseB(alertId:Number) : String
      {
         var ret:String = null;
         if(alertId >= 0)
         {
            ret = XMLInfo.AlertTypeObj[alertId].closeB;
         }
         else
         {
            ret = XMLInfo.AlertErrorTypeObj[alertId].closeB;
         }
         return ret;
      }
      
      public static function getSOS(alertId:Number) : String
      {
         var ret:String = null;
         if(alertId >= 0)
         {
            ret = XMLInfo.AlertTypeObj[alertId].SOS;
         }
         else
         {
            ret = XMLInfo.AlertErrorTypeObj[alertId].SOS;
         }
         return ret;
      }
      
      public static function getIsSLAlter(alertId:Number) : String
      {
         var ret:String = null;
         if(alertId >= 0)
         {
            ret = XMLInfo.AlertTypeObj[alertId].slAlter;
         }
         else
         {
            ret = XMLInfo.AlertErrorTypeObj[alertId].slAlter;
         }
         return ret;
      }
      
      public static function pop(alertId:Number) : Object
      {
         var isslAlter:int = 0;
         var ret:Object = "";
         var msg:String = getMsg(alertId);
         if(msg != null)
         {
            if(alertId >= 0)
            {
               isslAlter = int(getIsSLAlter(alertId));
               if(isslAlter == 1)
               {
                  ret = Alert.SLAlart(msg);
               }
               else
               {
                  ret = alertType(alertId,msg);
               }
            }
            else
            {
               ret = alertType(alertId,msg);
            }
         }
         return ret;
      }
      
      private static function alertType(alertId:Number, msg:String) : Object
      {
         var url:String = null;
         var bottomArray:String = null;
         var closeBS:String = null;
         var closeB:Boolean = false;
         var SOSS:String = null;
         var SOS:Boolean = false;
         var ret:Object = "";
         var levelType:String = getLevelType(alertId);
         var picTip:String = getPicTip(alertId);
         var style:String = getStyle(alertId);
         if(uint(style) == 6)
         {
            if(levelType == "0")
            {
               ret = Alert.showAlert(MainManager.getTopLevel(),msg,"",uint(style),picTip);
            }
            else if(levelType == "1")
            {
               ret = Alert.showAlert(MainManager.getAppLevel(),msg,"",uint(style),picTip);
            }
            else if(levelType == "2")
            {
               ret = Alert.showAlert(MainManager.getGameLevel(),msg,"",uint(style),picTip);
            }
            else if(levelType == "3")
            {
               ret = Alert.showAlert(MainManager.getAlertLevel(),msg,"",uint(style),picTip);
            }
         }
         else if(uint(style) == 100)
         {
            url = getUrl(alertId);
            bottomArray = getBottomArray(alertId);
            closeBS = getCloseB(alertId);
            closeB = new Boolean(closeBS);
            SOSS = getSOS(alertId);
            SOS = new Boolean(SOSS);
            if(levelType == "0")
            {
               if(url != null && url != "")
               {
                  ret = Alert.showAlert(MainManager.getTopLevel(),url,msg,uint(style),bottomArray,closeB,SOS,picTip);
               }
               else
               {
                  ret = Alert.showAlert(MainManager.getTopLevel(),msg,url,uint(style),bottomArray,closeB,SOS,picTip);
               }
            }
            else if(levelType == "1")
            {
               if(url != null && url != "")
               {
                  ret = Alert.showAlert(MainManager.getAppLevel(),url,msg,uint(style),bottomArray,closeB,SOS,picTip);
               }
               else
               {
                  ret = Alert.showAlert(MainManager.getAppLevel(),msg,url,uint(style),bottomArray,closeB,SOS,picTip);
               }
            }
            else if(levelType == "2")
            {
               if(url != null && url != "")
               {
                  ret = Alert.showAlert(MainManager.getGameLevel(),url,msg,uint(style),bottomArray,closeB,SOS,picTip);
               }
               else
               {
                  ret = Alert.showAlert(MainManager.getGameLevel(),msg,url,uint(style),bottomArray,closeB,SOS,picTip);
               }
            }
            else if(levelType == "3")
            {
               if(url != null && url != "")
               {
                  ret = Alert.showAlert(MainManager.getAlertLevel(),url,msg,uint(style),bottomArray,closeB,SOS,picTip);
               }
               else
               {
                  ret = Alert.showAlert(MainManager.getAlertLevel(),msg,url,uint(style),bottomArray,closeB,SOS,picTip);
               }
            }
         }
         else if(uint(style) == 7)
         {
            ret = Alert.imagesAlert(msg,"angry");
         }
         else
         {
            ret = Alert.smileAlart(msg);
         }
         return ret;
      }
   }
}

