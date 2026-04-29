package com.logic.socket.giveMeMoney
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   
   public class giveMeMoneyReq
   {
      
      public function giveMeMoneyReq(droparr:Array = null, givearr:Array = null)
      {
         super();
         this.sendInfo(droparr,givearr);
      }
      
      public static function givememoney() : void
      {
         MsgHead.Command = 1385;
         GF.writeHead();
      }
      
      public static function res_givememoney() : void
      {
         var obj:Object = new Object();
         obj.Itemid = GV.onlineSocket.readUnsignedInt();
         obj.Flag = GV.onlineSocket.readUnsignedInt();
         obj.Count = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1385,obj));
      }
      
      public function sendInfo(droparr:Array, givearr:Array) : void
      {
         if(droparr == null && givearr == null)
         {
            return;
         }
         MsgHead.PkgLen = 21 + droparr.length * 8 + givearr.length * 8;
         if(MsgHead.Result != 0)
         {
            MsgHead.Result = 0;
         }
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.GIVEMEMONEY);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeShort(droparr.length);
         GV.onlineSocket.writeShort(givearr.length);
         for(var i:uint = 0; i < droparr.length; i++)
         {
            GV.onlineSocket.writeUnsignedInt(droparr[i].kind);
            GV.onlineSocket.writeUnsignedInt(droparr[i].num);
         }
         for(var j:uint = 0; j < givearr.length; j++)
         {
            GV.onlineSocket.writeUnsignedInt(givearr[j].kind);
            GV.onlineSocket.writeUnsignedInt(givearr[j].num);
         }
         GV.onlineSocket.flush();
      }
      
      public function sendItemORMoney(droparr:Array = null, givearr:Array = null) : void
      {
         this.sendInfo(droparr,givearr);
      }
   }
}

