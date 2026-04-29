package com.logic.socket.dragon
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.msgHead.MsgHead;
   import com.core.MainManager;
   import com.core.dragon.dragonInfo.DragonInfo;
   import com.core.info.LocalUserInfo;
   import com.core.info.MapInfo;
   import com.core.info.ServerUpTime;
   import com.event.EventTaomee;
   import com.event.dragon.DragonInfoEvent;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class DragonBagSocket
   {
      
      public function DragonBagSocket()
      {
         super();
      }
      
      public static function getDragonBagRequest() : void
      {
         MsgHead.Command = 1227;
         GF.writeHead();
      }
      
      public static function getDragonBagResponse() : void
      {
         var tmpdata:Date = null;
         var obj:Object = null;
         var _data_input:IDataInput = GV.onlineSocket;
         var _flag:uint = _data_input.readUnsignedInt();
         var count:uint = _data_input.readUnsignedInt();
         var _event_obj:Object = {};
         var arr:Array = [];
         var servertime:Date = ServerUpTime.getInstance().chinaDate;
         for(var i:uint = 0; i < count; i++)
         {
            obj = new Object();
            obj.id = _data_input.readUnsignedInt();
            obj.nickname = _data_input.readUTFBytes(16);
            obj.growth = _data_input.readUnsignedInt();
            obj.state = _data_input.readUnsignedInt();
            obj.lefttime = _data_input.readUnsignedInt();
            if(obj.lefttime != 0)
            {
               tmpdata = new Date(obj.lefttime * 1000);
               obj.lefttime = Math.max(0,(tmpdata.time - servertime.time) / 1000);
            }
            obj.dragonInfo = getDragonInfo(obj);
            arr.push(obj);
         }
         arr.sortOn("lefttime",Array.NUMERIC);
         arr = arr.reverse();
         _event_obj.arr = arr;
         _event_obj.flag = _flag;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1227,_event_obj));
      }
      
      public static function setDragonFreeRequest(dragonId:uint) : void
      {
         if(dragonId == 1350009 || dragonId == 1350004)
         {
            GC.clearAll(MainManager.getAppLevel().getChildByName("DragonBagModule_swf"));
            return;
         }
         MsgHead.Command = 1229;
         var byte:ByteArray = new ByteArray();
         byte.writeUnsignedInt(dragonId);
         GF.writeHead(byte);
      }
      
      public static function setDragonFreeResponse() : void
      {
         var _data_input:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.userID = _data_input.readUnsignedInt();
         obj.id = _data_input.readUnsignedInt();
         obj.state = _data_input.readUnsignedInt();
         obj.dragonInfo = getDragonInfo(obj);
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1229,obj));
         GV.onlineSocket.dispatchEvent(new DragonInfoEvent("getDragonInfo",obj.dragonInfo));
      }
      
      public static function setDragonStateRequest(dragonId:uint, state:uint) : void
      {
         if(Boolean(GV.MAN_PEOPLE.hasCar))
         {
            Alert.smileAlart("    先卸掉你車再騎龍吧！");
            GC.clearAll(MainManager.getAppLevel().getChildByName("DragonBagModule_swf"));
            return;
         }
         var mapInfo:MapInfo = MapInfo.currentMapInfo();
         if(Boolean(mapInfo.isLamuWorld) || mapInfo.hideMount)
         {
            Alert.smileAlart("    這裡似乎無法召喚坐騎！");
            GC.clearAll(MainManager.getAppLevel().getChildByName("DragonBagModule_swf"));
            return;
         }
         MsgHead.Command = 1228;
         var byte:ByteArray = new ByteArray();
         byte.writeUnsignedInt(dragonId);
         byte.writeUnsignedInt(state);
         GF.writeHead(byte);
      }
      
      public static function setDragonStateResponse() : void
      {
         var _data_input:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.userID = _data_input.readUnsignedInt();
         obj.id = _data_input.readUnsignedInt();
         obj.growth = _data_input.readUnsignedInt();
         obj.state = _data_input.readUnsignedInt();
         obj.dragonInfo = getDragonInfo(obj);
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1228,obj));
         GV.onlineSocket.dispatchEvent(new DragonInfoEvent("getDragonInfo",obj.dragonInfo));
      }
      
      public static function getDragonInfo(obj:Object) : DragonInfo
      {
         var newObj:Object = null;
         var dragonObj:Object = new Object();
         obj.count = Boolean(obj.count) ? obj.count : 0;
         obj.id = Boolean(obj.id) ? obj.id : 0;
         obj.nickname = Boolean(obj.nickname) ? obj.nickname : "??";
         obj.growth = Boolean(obj.growth) ? obj.growth : 0;
         obj.state = Boolean(obj.state) ? obj.state : 0;
         obj.lefttime = Boolean(obj.lefttime) ? obj.lefttime : 0;
         try
         {
            newObj = obj;
            newObj = GoodsInfo.getInfoById(obj.id);
            newObj.UserID = obj.userID;
            newObj.NickName = obj.nickname;
            newObj.Growth = obj.growth;
            newObj.State = obj.state;
            newObj.Count = obj.count;
            newObj.LeftTime = obj.lefttime;
         }
         catch(e:*)
         {
         }
         return new DragonInfo(newObj);
      }
      
      public static function checkHasDragon() : Boolean
      {
         if(Boolean(GV.MAN_PEOPLE.hasDragon))
         {
            Alert.smileAlart("    先卸掉你的龍坐騎再開車吧！");
            return true;
         }
         return false;
      }
      
      public static function updataDragon() : void
      {
         MsgHead.Command = 1238;
         GF.writeHead();
      }
      
      public static function updataResponse() : void
      {
         var _data_input:IDataInput = GV.onlineSocket;
         var dragonObj:Object = new Object();
         dragonObj.dragonID = _data_input.readUnsignedInt();
         dragonObj.dragonName = _data_input.readUTFBytes(16);
         dragonObj.dragonGrowth = _data_input.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1238,dragonObj));
      }
      
      public static function feedDragon(dragonId:uint, itemId:uint) : void
      {
         MsgHead.Command = 1231;
         var byte:ByteArray = new ByteArray();
         byte.writeUnsignedInt(dragonId);
         byte.writeUnsignedInt(itemId);
         GF.writeHead(byte);
      }
      
      public static function feedDragonResponse() : void
      {
         var _data_input:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.dragonID = _data_input.readUnsignedInt();
         obj.growth = _data_input.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1231,obj));
      }
      
      public static function changeDragonNameRequest(dragonId:uint, name:String) : void
      {
         MsgHead.Command = 1230;
         var byte:ByteArray = new ByteArray();
         byte.writeUnsignedInt(dragonId);
         byte.writeUTFBytes(name);
         byte.length = 20;
         GF.writeHead(byte);
      }
      
      public static function setBagLeavelUpRequest() : void
      {
         MsgHead.Command = 1252;
         GF.writeHead();
      }
      
      public static function setBagLeavelUpResponse() : void
      {
         LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() - 10000);
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1252));
      }
   }
}

