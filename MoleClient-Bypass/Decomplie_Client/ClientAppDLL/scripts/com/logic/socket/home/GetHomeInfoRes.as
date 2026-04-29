package com.logic.socket.home
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class GetHomeInfoRes extends EventDispatcher
   {
      
      public static var GET_HOME_INFO:String = "get_home_info";
      
      public static var GET_HOME_DEPOT_INFO:String = "get_home_depot_info";
      
      public static var SAVE_HOME_DEPOT_SUCC:String = "SAVE_HOME_DEPOT_SUCC";
      
      public static var SAVE_HOME_USED_SUCC:String = "SAVE_HOME_USED_SUCC";
      
      public static var USER_EXIST_SUCC:String = "USER_EXIST_SUCC";
      
      public static var USER_FLAG_SUCC:String = "USER_FLAG_SUCC";
      
      public static var GET_HOME_GUEST:String = "GET_HOME_GUEST";
      
      public static var GET_FRIENDBOX_LIST:String = "GET_FRIENDBOX_LIST";
      
      public static var GET_GOODS_IN_BOX:String = "GET_GOODS_IN_BOX";
      
      public function GetHomeInfoRes()
      {
         super();
      }
      
      public static function GetInfo() : void
      {
         var j:int = 0;
         var itemCountObj:Object = null;
         var getHomeInfoObj:Object = new Object();
         var getItemInfoArr:Array = new Array();
         var getPlantInfoArr:Array = new Array();
         getHomeInfoObj.UserID = GV.onlineSocket.readUnsignedInt();
         getHomeInfoObj.Name = GV.onlineSocket.readUTFBytes(16);
         getHomeInfoObj.Online = GV.onlineSocket.readUnsignedInt();
         getHomeInfoObj.HouseBackground = GV.onlineSocket.readUnsignedInt();
         getHomeInfoObj.ItemCount = GV.onlineSocket.readUnsignedInt();
         getHomeInfoObj.PlantCount = GV.onlineSocket.readUnsignedInt();
         for(j = 0; j < getHomeInfoObj.ItemCount; j++)
         {
            itemCountObj = new Object();
            itemCountObj.ID = GV.onlineSocket.readUnsignedInt();
            itemCountObj.PosX = GV.onlineSocket.readShort();
            itemCountObj.PosY = GV.onlineSocket.readShort();
            itemCountObj.Direction = GV.onlineSocket.readUnsignedByte();
            itemCountObj.Visible = GV.onlineSocket.readUnsignedByte();
            itemCountObj.Layer = GV.onlineSocket.readUnsignedByte();
            itemCountObj.Type = GV.onlineSocket.readUnsignedByte();
            itemCountObj.Other = GV.onlineSocket.readUnsignedInt();
            getItemInfoArr.push(itemCountObj);
         }
         for(j = 0; j < getHomeInfoObj.PlantCount; j++)
         {
            itemCountObj = seedRes.SeedParse();
            getPlantInfoArr.push(itemCountObj);
         }
         getHomeInfoObj.itemArr = getItemInfoArr;
         getHomeInfoObj.plantArr = getPlantInfoArr;
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_HOME_INFO,getHomeInfoObj));
      }
      
      public static function GetHomeDepotInfo() : void
      {
         var id:uint = 0;
         var count:uint = 0;
         var HomeDepotObj:Object = new Object();
         HomeDepotObj.Count = GV.onlineSocket.readUnsignedInt();
         HomeDepotObj.Arr = new Array();
         for(var i:int = 0; i < HomeDepotObj.Count; i++)
         {
            id = GV.onlineSocket.readUnsignedInt();
            count = GV.onlineSocket.readUnsignedInt();
            HomeDepotObj.Arr.push({
               "ID":id,
               "Count":count
            });
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_HOME_DEPOT_INFO,HomeDepotObj));
      }
      
      public static function SaveHomeDepot() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee(SAVE_HOME_DEPOT_SUCC));
      }
      
      public static function SaveHomeUsedGood() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee(SAVE_HOME_USED_SUCC));
      }
      
      public static function UserExistResult() : void
      {
         var bool:uint = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(USER_EXIST_SUCC,{"Bool":Boolean(bool)}));
      }
      
      public static function UserFlagResult() : void
      {
         var flag:uint = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(USER_FLAG_SUCC,{"Flag":flag}));
      }
      
      public static function getgoodsinboxList() : void
      {
         var visitor:Object = null;
         var obj:Object = new Object();
         var visitorArr:Array = new Array();
         var len:uint = GV.onlineSocket.readUnsignedInt();
         for(var i:uint = 0; i < len; i++)
         {
            visitor = new Object();
            visitor.UserID = GV.onlineSocket.readUnsignedInt();
            visitor.Flag = GV.onlineSocket.readUnsignedInt();
            visitor.Nick = GV.onlineSocket.readUTFBytes(16);
            visitor.Color = GV.onlineSocket.readUnsignedInt();
            visitor.Vip = GV.onlineSocket.readUnsignedByte();
            visitor.Time = GV.onlineSocket.readUnsignedInt();
            visitorArr.push(visitor);
         }
         obj.arr = visitorArr;
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_FRIENDBOX_LIST,obj));
      }
      
      public static function getgoodsinboxSucc() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_GOODS_IN_BOX));
      }
      
      public static function HomeGuestList() : void
      {
         var visitor:Object = null;
         var obj:Object = new Object();
         var visitorArr:Array = new Array();
         var len:int = GV.onlineSocket.readShort();
         for(var i:uint = 0; i < len; i++)
         {
            visitor = new Object();
            visitor.UserID = GV.onlineSocket.readUnsignedInt();
            visitor.Flag = GV.onlineSocket.readUnsignedInt();
            visitor.Nick = GV.onlineSocket.readUTFBytes(16);
            visitor.Color = GV.onlineSocket.readUnsignedInt();
            visitor.Vip = GV.onlineSocket.readUnsignedByte();
            visitor.Time = GV.onlineSocket.readUnsignedInt();
            visitorArr.push(visitor);
         }
         obj.arr = visitorArr;
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_HOME_GUEST,obj));
      }
      
      public static function getFriendHotSucc() : void
      {
         var tmp:Object = null;
         var obj:Object = new Object();
         var visitorArr:Array = new Array();
         var len:uint = GV.onlineSocket.readUnsignedInt();
         for(var i:uint = 0; i < len; i++)
         {
            tmp = new Object();
            tmp.id = GV.onlineSocket.readUnsignedInt();
            tmp.hot = GV.onlineSocket.readUnsignedInt();
            visitorArr.push(tmp);
         }
         obj.arr = visitorArr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_1456",obj));
      }
   }
}

