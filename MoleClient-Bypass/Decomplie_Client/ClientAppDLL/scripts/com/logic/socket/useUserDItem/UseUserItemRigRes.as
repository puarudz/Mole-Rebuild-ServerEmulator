package com.logic.socket.useUserDItem
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class UseUserItemRigRes extends EventDispatcher
   {
      
      public static var USE_USER_ITEM_RIG:String = "use_user_item_rig";
      
      public function UseUserItemRigRes()
      {
         super();
      }
      
      public function useUserRig() : void
      {
         var ItemIDObj:Object = null;
         var userRigObj:Object = new Object();
         var userRigArr:Array = new Array();
         userRigObj.UserID = GV.onlineSocket.readUnsignedInt();
         userRigObj.Count = GV.onlineSocket.readUnsignedInt();
         for(var i:int = 0; i < userRigObj.Count; i++)
         {
            ItemIDObj = new Object();
            ItemIDObj.ItemID = GV.onlineSocket.readUnsignedInt();
            ItemIDObj = GF.getPropData(ItemIDObj.ItemID);
            ItemIDObj.Flag = GV.onlineSocket.readUnsignedByte();
            userRigArr.push(ItemIDObj);
         }
         userRigObj.userArr = userRigArr;
         GV.onlineSocket.dispatchEvent(new EventTaomee(USE_USER_ITEM_RIG,userRigObj));
      }
   }
}

