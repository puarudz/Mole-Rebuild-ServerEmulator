package com.module.newHouse
{
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.ClientRegistUDPSocket;
   import com.logic.socket.getRoomInfo.GetRoomInfoReq;
   import com.logic.socket.getRoomInfo.GetRoomInfoRes;
   import com.logic.socket.lookBag.LookBagReq;
   import com.logic.socket.lookBag.LookBagRes;
   import com.logic.socket.savaRoomItem.SavaRoomItemReq;
   import com.logic.socket.savaRoomItem.SavaRoomItemRes;
   import flash.events.EventDispatcher;
   
   public class newhouseLogic extends EventDispatcher
   {
      
      private var getRoomHotReq:ClientRegistUDPSocket;
      
      private var getRoomInfoReq:GetRoomInfoReq = new GetRoomInfoReq();
      
      private var savaRoomItemRes:SavaRoomItemRes = new SavaRoomItemRes();
      
      private var savaRoomItemReq:SavaRoomItemReq = new SavaRoomItemReq();
      
      private var houseMapArr:Array = [];
      
      private var depotGoodsArr:Array = [];
      
      public var lookBagClass:LookBagReq;
      
      public var sortArr:Array = [];
      
      public function newhouseLogic()
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
         HouseData.isUpset = e.EventObj.isUpset;
         e.EventObj.Tile = this.changeArr(e.EventObj.Tile);
         this.houseMapArr = e.EventObj.Tile;
         GV.onlineSocket.removeEventListener(GetRoomInfoRes.GET_ROOM_INFO,this.getRoomInfo);
         dispatchEvent(new EventTaomee("dispatchHouseMap",e.EventObj));
      }
      
      public function showHouseShape() : void
      {
      }
      
      public function showDepotGoods() : void
      {
         this.lookBagClass.lookBag(LocalUserInfo.getUserID(),16,0);
         GV.onlineSocket.addEventListener(LookBagRes.BAG_OVER,this.getDepotGoods);
      }
      
      public function getDepotGoods(e:EventTaomee) : void
      {
         this.depotGoodsArr = e.EventObj.obj.arr;
         GV.onlineSocket.removeEventListener(LookBagRes.BAG_OVER,this.getDepotGoods);
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
   }
}

