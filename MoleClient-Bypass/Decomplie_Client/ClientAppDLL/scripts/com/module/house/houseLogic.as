package com.module.house
{
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerInfo;
   import com.core.socketlogic.ClientOnLineSerSocket;
   import com.event.EventTaomee;
   import com.logic.socket.ClientRegistUDPSocket;
   import com.logic.socket.getFrendList.GetFlowersReq;
   import com.logic.socket.getFrendList.GetFlowersRes;
   import com.logic.socket.getRoomInfo.GetRoomInfoReq;
   import com.logic.socket.getRoomInfo.GetRoomInfoRes;
   import com.logic.socket.lookBag.LookBagReq;
   import com.logic.socket.lookBag.LookBagRes;
   import com.logic.socket.savaRoomItem.SavaRoomItemReq;
   import com.logic.socket.savaRoomItem.SavaRoomItemRes;
   import com.module.newHouse.FlowersView;
   import com.module.newHouse.SpecialGoodsBasic;
   import com.module.newHouse.newHouseView;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class houseLogic extends EventDispatcher
   {
      
      private var ismyhouse:int;
      
      private var houseid:int;
      
      private var getRoomHotReq:ClientRegistUDPSocket;
      
      private var getRoomInfoReq:GetRoomInfoReq = new GetRoomInfoReq();
      
      private var savaRoomItemRes:SavaRoomItemRes = new SavaRoomItemRes();
      
      private var savaRoomItemReq:SavaRoomItemReq = new SavaRoomItemReq();
      
      private var houseMapArr:Array = [];
      
      private var depotGoodsArr:Array = [];
      
      public var lookBagClass:LookBagReq;
      
      public var sortArr:Array = [];
      
      public function houseLogic()
      {
         super();
         this.lookBagClass = new LookBagReq();
      }
      
      public function init() : void
      {
         try
         {
            this.getRoomInfoReq.getRoomInfo(LocalUserInfo.getUserID());
            GV.onlineSocket.addEventListener(GetRoomInfoRes.GET_ROOM_INFO,this.getRoomInfo);
         }
         catch(e:Error)
         {
         }
         this.lookBagClass = new LookBagReq();
      }
      
      public function getRoomInfo(e:EventTaomee) : void
      {
         e.EventObj.Tile = this.changeArr(e.EventObj.Tile);
         this.houseMapArr = e.EventObj.Tile;
         for(var i:uint = 0; i < 8; i++)
         {
         }
         GV.onlineSocket.removeEventListener(GetRoomInfoRes.GET_ROOM_INFO,this.getRoomInfo);
         dispatchEvent(new EventTaomee("dispatchHouseMap",e.EventObj));
      }
      
      public function showHouseShape() : void
      {
      }
      
      public function showPetGoods() : void
      {
         this.lookBagClass.lookBag(LocalUserInfo.getUserID(),64,0);
         try
         {
            GV.onlineSocket.addEventListener(LookBagRes.BAG_OVER,this.getPetGoods);
         }
         catch(e:*)
         {
         }
      }
      
      public function getPetGoods(e:EventTaomee) : void
      {
         var petGoodsArr:* = e.EventObj.obj.arr;
         GV.onlineSocket.removeEventListener(LookBagRes.BAG_OVER,this.getPetGoods);
         dispatchEvent(new EventTaomee("dispatchPetGoods",{"PetGoods":petGoodsArr}));
      }
      
      public function showDepotGoods() : void
      {
         this.lookBagClass.lookBag(LocalUserInfo.getUserID(),16,0);
         try
         {
            GV.onlineSocket.addEventListener(LookBagRes.BAG_OVER,this.getDepotGoods);
         }
         catch(e:*)
         {
         }
      }
      
      public function getDepotGoods(e:EventTaomee) : void
      {
         this.depotGoodsArr = e.EventObj.obj.arr;
         GV.onlineSocket.removeEventListener(LookBagRes.BAG_OVER,this.getDepotGoods);
         if(this.depotGoodsArr.length > 0)
         {
         }
         dispatchEvent(new EventTaomee("dispatchDepotGoods",{"DepotGoods":this.depotGoodsArr}));
      }
      
      public function changeArr(arr:Array) : Array
      {
         var temparr:Array = null;
         var j:uint = 0;
         var Arr:Array = [];
         for(var i:uint = 0; i < arr[0].length; i++)
         {
            temparr = new Array();
            for(j = 0; j < arr.length; j++)
            {
               temparr.push(arr[j][i]);
            }
            Arr.push(temparr);
         }
         return Arr;
      }
      
      public function saveGoods(houseArr:Array) : void
      {
         this.savaRoomItemReq.savaRoomItem(houseArr);
      }
      
      public function doSaveGoods() : void
      {
         newHouseView.getInstance().saveGoods(1);
         GV.onlineSocket.addEventListener("sava_room_item",this.saveItemSuccess);
      }
      
      public function saveItemSuccess(e:Event = null) : void
      {
         try
         {
            GV.onlineSocket.removeEventListener("sava_room_item",this.saveItemSuccess);
         }
         catch(e:*)
         {
         }
         GV.onlineClass.addEventListener(ClientOnLineSerSocket.GET_BASIC_MESSAGE,this.getAllUserInfo);
         GF.clearPeoples();
         GV.onlineClass.getUserListReq();
      }
      
      public function flowers(roomid:int) : void
      {
         var flowerreq:GetFlowersReq = new GetFlowersReq();
         GV.onlineSocket.addEventListener(GetFlowersRes.GET_FLOWERS_LIST,this.getFlowersInfo);
         flowerreq.sendreq(roomid);
      }
      
      public function getFlowersInfo(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(GetFlowersRes.GET_FLOWERS_LIST,this.getFlowersInfo);
         FlowersView.init(newHouseView.getInstance().RootMC,e.EventObj);
         SpecialGoodsBasic.init();
      }
      
      public function houseHotReq(roomid:int) : void
      {
         var tempObj:DisplayObject = MainManager.getRootMC();
         this.houseid = roomid;
         this.ismyhouse = 1;
         if(roomid == LocalUserInfo.getUserID())
         {
            this.ismyhouse = 0;
         }
         while(tempObj.parent != null)
         {
            tempObj = tempObj.parent;
            if(tempObj.name == "rootMC")
            {
               break;
            }
         }
         var ip:String = ServerInfo.getRegistSerInfo(ServerInfo.IP);
         var port:int = int(ServerInfo.getRegistSerInfo(ServerInfo.PORT));
         this.getRoomHotReq = new ClientRegistUDPSocket(ip,port);
         this.getRoomHotReq.addEventListener(ClientRegistUDPSocket.SOCKET_SUCCESS,this.connectSuccess);
         this.getRoomHotReq.addEventListener("get_room_host",this.getHouseHot);
      }
      
      private function connectSuccess(e:Event) : void
      {
         this.getRoomHotReq.removeEventListener(ClientRegistUDPSocket.SOCKET_SUCCESS,this.connectSuccess);
         this.getRoomHotReq.getRoomHot(this.houseid,this.ismyhouse);
      }
      
      private function getHouseHot(e:EventTaomee) : void
      {
         newHouseView.getInstance().showHouseHot(e.EventObj.Hot);
         this.getRoomHotReq.removeEventListener("get_room_host",this.getHouseHot);
         this.getRoomHotReq = null;
      }
      
      private function getAllUserInfo(evt:EventTaomee) : void
      {
         GV.onlineClass.removeEventListener(ClientOnLineSerSocket.GET_BASIC_MESSAGE,this.getAllUserInfo);
         var userArray:* = evt.EventObj.arr;
         var userObj:Object = {
            "data":userArray,
            "type":1
         };
         GV.PeopleCount.changeOnlinePeople(userObj);
      }
   }
}

