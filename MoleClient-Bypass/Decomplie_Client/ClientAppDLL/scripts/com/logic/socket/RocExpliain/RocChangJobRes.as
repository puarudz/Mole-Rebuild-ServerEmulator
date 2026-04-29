package com.logic.socket.RocExpliain
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class RocChangJobRes extends EventDispatcher
   {
      
      public static var ROC_CHANGJOB:String = "roc_changJob_back";
      
      public function RocChangJobRes()
      {
         super();
      }
      
      public function RocChangJobBack() : void
      {
         var Obj:Object = null;
         var GetGoodsArr:Array = new Array();
         var lg:uint = GV.onlineSocket.readUnsignedInt();
         for(var i:uint = 0; i < int(lg); i++)
         {
            Obj = new Object();
            Obj.ID = GV.onlineSocket.readUnsignedInt();
            Obj.Num = GV.onlineSocket.readUnsignedInt();
            GetGoodsArr.push(Obj);
         }
         var GetGoodsObj:Object = {
            "lg":lg,
            "GetGoodsArr":GetGoodsArr
         };
         GV.onlineSocket.dispatchEvent(new EventTaomee(ROC_CHANGJOB,GetGoodsObj));
      }
   }
}

