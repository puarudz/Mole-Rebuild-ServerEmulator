package com.module.activityModule
{
   import com.event.EventTaomee;
   import com.interfaces.ExtendsInterface;
   
   public class deleteItemModule
   {
      
      public static var DELETE_ITEM_SUCESS:String = "delete_item_sucess";
      
      public function deleteItemModule()
      {
         super();
      }
      
      public static function doAction(itemID:int) : void
      {
         ExtendsInterface.addEventListener(ExtendsInterface.Read + "508",initAction);
         GF.delItem(itemID);
      }
      
      private static function initAction(evt:EventTaomee) : void
      {
         ExtendsInterface.removeEventListener(ExtendsInterface.Read + "508",initAction);
         GV.onlineSocket.dispatchEvent(new EventTaomee(DELETE_ITEM_SUCESS));
      }
   }
}

