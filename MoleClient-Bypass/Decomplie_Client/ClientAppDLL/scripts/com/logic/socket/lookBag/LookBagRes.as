package com.logic.socket.lookBag
{
   import com.event.EventTaomee;
   
   public class LookBagRes
   {
      
      public static var BAG_OVER:String = "bag_over";
      
      public function LookBagRes()
      {
         super();
      }
      
      public function lookBagRes() : void
      {
         var bagArr:Array = null;
         var i:uint = 0;
         var itemObj:Object = null;
         var tempObj:* = undefined;
         var bagObj:Object = new Object();
         bagArr = new Array();
         bagObj.UserID = GV.onlineSocket.readUnsignedInt();
         bagObj.Count = GV.onlineSocket.readUnsignedInt();
         try
         {
            for(i = 0; i < bagObj.Count; i++)
            {
               itemObj = new Object();
               itemObj.id = GV.onlineSocket.readUnsignedInt();
               try
               {
                  if(itemObj.id < 160000 || itemObj.id > 170000)
                  {
                     tempObj = GF.getPropData(itemObj.id);
                     if(tempObj.id != null)
                     {
                        itemObj = tempObj;
                     }
                  }
               }
               catch(E:*)
               {
                  itemObj.itemCount = GV.onlineSocket.readUnsignedInt();
                  bagArr.push(itemObj);
                  continue;
               }
               itemObj.itemCount = GV.onlineSocket.readUnsignedInt();
               bagArr.push(itemObj);
            }
         }
         catch(E:*)
         {
         }
         bagObj.arr = bagArr;
         GV.onlineSocket.dispatchEvent(new EventTaomee(BAG_OVER,{"obj":bagObj}));
      }
   }
}

