package com.logic.socket.CSItems
{
   import com.event.EventTaomee;
   
   public class CSEXRes
   {
      
      public static var EX_FINISH:String = "ex_finish";
      
      public function CSEXRes()
      {
         super();
      }
      
      public function getBackFun() : void
      {
         var i:uint = 0;
         var objb:Object = null;
         var obj:Object = new Object();
         obj.Cnt = GV.onlineSocket.readUnsignedInt();
         var Arr:Array = [];
         if(obj.Cnt != 0)
         {
            for(i = 0; i < obj.Cnt; i++)
            {
               objb = new Object();
               objb.ItemID = GV.onlineSocket.readUnsignedInt();
               objb.Cnt = GV.onlineSocket.readUnsignedInt();
               Arr.push(objb);
            }
            obj.Arr = Arr;
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("ex_finish",{"obj":obj}));
      }
   }
}

