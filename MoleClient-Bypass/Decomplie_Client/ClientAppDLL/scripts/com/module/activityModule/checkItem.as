package com.module.activityModule
{
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   
   public class checkItem
   {
      
      public static var chekItem_suc:String = "CHECK_ITEM_SUC";
      
      public function checkItem()
      {
         super();
      }
      
      public static function checkItemHandler(itemID:int) : void
      {
         GV.onlineSocket.addEventListener(GetItemCountRes.GET_ITEMCOUNT,getItemCountLogic);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),itemID,2);
      }
      
      private static function getItemCountLogic(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(GetItemCountRes.GET_ITEMCOUNT,getItemCountLogic);
         var itemCount:int = int(evt.EventObj.obj.Count);
         var objCount:int = 0;
         if(itemCount > 0)
         {
            objCount = int(evt.EventObj.obj.arr[0].itemCount);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(chekItem_suc,{
            "count":itemCount,
            "num":objCount
         }));
      }
   }
}

