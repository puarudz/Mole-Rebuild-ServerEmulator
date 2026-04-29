package com.logic.socket.randomItemLogic
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class randomItemRes extends EventDispatcher
   {
      
      public static var RANMOM_ITEM:String = "randomItem_Action";
      
      public function randomItemRes()
      {
         super();
      }
      
      public static function doAtcion() : void
      {
         var obj:Object = null;
         var itemid:uint = 0;
         var itemInfo:uint = 0;
         var itemInfoStr:String = null;
         var itemArray:Array = new Array();
         var itemCount:uint = GV.onlineSocket.readUnsignedShort();
         if(itemCount == 0)
         {
            return;
         }
         for(var i:int = 0; i < itemCount; i++)
         {
            obj = new Object();
            itemid = GV.onlineSocket.readUnsignedInt();
            itemInfo = GV.onlineSocket.readUnsignedInt();
            obj.itemID = itemid;
            itemInfoStr = itemInfo.toString(2);
            while(itemInfoStr.length < 32)
            {
               itemInfoStr = "0" + itemInfoStr;
            }
            obj.itemArray = itemInfoStr.split("");
            itemArray.push(obj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(RANMOM_ITEM,{"itemArray":itemArray}));
      }
   }
}

