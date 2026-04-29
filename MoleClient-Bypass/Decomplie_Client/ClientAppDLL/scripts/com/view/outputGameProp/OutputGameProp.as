package com.view.outputGameProp
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.util.XMLToObject;
   import com.core.MainManager;
   import com.global.staticData.XMLInfo;
   
   public class OutputGameProp
   {
      
      private static var gameTips:Object;
      
      public function OutputGameProp()
      {
         super();
      }
      
      public static function output(gameID:int, itemID:uint) : void
      {
         var l1:Array = null;
         var i:int = 0;
         var l2:uint = 0;
         var l3:String = null;
         var url:String = null;
         if(!gameTips)
         {
            gameTips = XMLToObject.convert(XMLInfo.gameTips_XML);
            gameTips = gameTips.tips;
         }
         if(Boolean(gameTips["game_" + gameID]))
         {
            l1 = gameTips["game_" + gameID].t;
            for(i = 0; i < l1.length; i++)
            {
               l2 = uint(l1[i].itemID);
               l3 = l1[i].msg;
               if(l2 == itemID)
               {
                  url = GoodsInfo.getItemPathByID(itemID) + itemID + ".swf";
                  Alert.showAlert(MainManager.getAppLevel(),url,l3,Alert.CHANG_ALERT,"iknow",true,false,"EMP_BUY");
                  break;
               }
            }
         }
      }
   }
}

