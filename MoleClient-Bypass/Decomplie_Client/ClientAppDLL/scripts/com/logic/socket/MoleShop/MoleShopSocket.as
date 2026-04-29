package com.logic.socket.MoleShop
{
   import com.adobe.crypto.MD5;
   import com.common.msgHead.MsgHead;
   import com.core.info.LocalUserInfo;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.event.EventTaomee;
   
   public class MoleShopSocket extends BaseOnlineSocketRequest
   {
      
      public function MoleShopSocket()
      {
         super();
      }
      
      public static function buyCommodity(ID:uint, Count:uint = 1, activity_id:uint = 0) : void
      {
         var Passwd:String = "";
         MsgHead.Result = 0;
         MsgHead.PkgLen = 17 + 42;
         initAction(2031);
         GV.onlineSocket.writeUnsignedInt(LocalUserInfo.getUserID());
         GV.onlineSocket.writeUnsignedInt(ID);
         GV.onlineSocket.writeShort(Count);
         GV.onlineSocket.writeUTFBytes(MD5.hash(Passwd));
         GV.onlineSocket.writeUnsignedInt(activity_id);
         flush();
      }
      
      public static function res_buyCommodity() : void
      {
         var Obj:Object = new Object();
         var Pay_num:uint = GV.onlineSocket.readUnsignedInt();
         var Balance_num:uint = GV.onlineSocket.readUnsignedInt();
         Obj.Pay_num = Pay_num / 100;
         Obj.Balance_num = Balance_num / 100;
         var obj_s:Object = {"obj":Obj};
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 2031,obj_s));
      }
      
      public static function buyDou(ID:uint, Passwd:*, Count:uint) : void
      {
         MsgHead.Result = 0;
         MsgHead.PkgLen = 17 + 42;
         initAction(2033);
         GV.onlineSocket.writeUnsignedInt(LocalUserInfo.getUserID());
         GV.onlineSocket.writeUnsignedInt(ID);
         GV.onlineSocket.writeShort(Count);
         GV.onlineSocket.writeUTFBytes(MD5.hash(Passwd));
         flush();
      }
      
      public static function res_buyDou() : void
      {
         var Obj:Object = new Object();
         var Pay_num:uint = GV.onlineSocket.readUnsignedInt();
         var Balance_num:uint = GV.onlineSocket.readUnsignedInt();
         Obj.Pay_num = Pay_num / 100;
         Obj.Balance_num = Balance_num / 100;
         Obj.Dou_num = GV.onlineSocket.readUnsignedInt();
         Obj.Balance_Dou_num = GV.onlineSocket.readUnsignedInt();
         Obj.Dou_num /= 100;
         Obj.Balance_Dou_num /= 100;
         var obj_s:Object = {"obj":Obj};
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 2033,obj_s));
      }
   }
}

