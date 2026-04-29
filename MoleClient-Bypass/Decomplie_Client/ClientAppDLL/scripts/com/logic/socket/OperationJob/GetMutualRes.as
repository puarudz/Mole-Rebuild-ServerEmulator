package com.logic.socket.OperationJob
{
   import com.event.EventTaomee;
   import flash.display.Sprite;
   import flash.utils.ByteArray;
   
   public class GetMutualRes extends Sprite
   {
      
      public static var GET_MUTUAL_BACK:String = "get_back_mutual";
      
      public function GetMutualRes()
      {
         super();
      }
      
      public function getBackFun() : void
      {
         var myArr:ByteArray = null;
         var i:uint = 0;
         var Obj:Object = new Object();
         Obj.type = GV.onlineSocket.readUnsignedInt();
         if(Obj.type == 327)
         {
            Obj.job = GV.onlineSocket.readByte();
            Obj.count = GV.onlineSocket.readUnsignedInt();
            myArr = new ByteArray();
            for(i = 0; i < 31; i++)
            {
               myArr.writeByte(0);
            }
            GV.onlineSocket.readBytes(myArr);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_MUTUAL_BACK,{"obj":Obj}));
      }
   }
}

