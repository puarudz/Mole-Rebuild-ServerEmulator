package com.module.farm
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.socketlogic.ClientOnLineSerSocket;
   import com.event.EventTaomee;
   import com.logic.socket.farm.farmSocket;
   import com.logic.socket.home.GetHomeInfoReq;
   import com.logic.socket.home.GetHomeInfoRes;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class FieldLogic extends EventDispatcher
   {
      
      private static var instance:FieldLogic;
      
      public static var GET_FARM_DEPOT_GOODS:String = "GET_FARM_DEPOT_GOODS";
      
      public var HomeObj:Object;
      
      public var DepotObj:Object;
      
      public var localArr:Array;
      
      public var serverArr:Array;
      
      public var sortArr:Array;
      
      public function FieldLogic()
      {
         super();
      }
      
      public static function getInstance() : FieldLogic
      {
         if(instance == null)
         {
            instance = new FieldLogic();
         }
         return instance;
      }
      
      public function setValue(Info:Object) : void
      {
         this.HomeObj = Info;
      }
      
      public function DepotReq() : void
      {
         GV.onlineSocket.addEventListener("read_" + 1362,this.getHomeDepot);
         farmSocket.farm_depot();
      }
      
      private function getHomeDepot(e:EventTaomee) : void
      {
         this.DepotObj = e.EventObj;
         this.getInfo();
      }
      
      public function getInfo() : void
      {
         this.serverArr = this.DepotObj.arr;
         this.localArr = new Array();
         for(var i:int = 0; i < this.serverArr.length; i++)
         {
            this.localArr[i] = GoodsInfo.getInfoById(this.serverArr[i].ID);
            if(Number(this.localArr[i].id) < 1280001)
            {
               if(Number(this.localArr[i].id) >= 1270076 && Number(this.localArr[i].id) <= 1270125)
               {
                  this.localArr[i].Type = 2;
               }
               else
               {
                  this.localArr[i].Type = 1;
               }
            }
            else
            {
               this.localArr[i].Type = 3;
            }
            this.localArr[i].ID = this.serverArr[i].ID;
            this.localArr[i].Count = this.serverArr[i].Count;
         }
         this.sortGoods();
      }
      
      public function sortGoods() : void
      {
         var kindlen:int = 0;
         var k:int = 0;
         var len:int = int(this.localArr.length);
         this.sortArr = null;
         this.sortArr = [[],[],[]];
         var sortarrlen:int = int(this.sortArr.length);
         for(var j:int = 0; j < len; j++)
         {
            this.sortArr[Number(this.localArr[j].Type)].push(this.localArr[j]);
         }
         for(var h:int = 1; h < sortarrlen; h++)
         {
            kindlen = int(this.sortArr[h].length);
            for(k = 0; k < kindlen; k++)
            {
               this.sortArr[0].push(this.sortArr[h][k]);
            }
         }
         dispatchEvent(new EventTaomee(GET_FARM_DEPOT_GOODS,{"arr":this.sortArr}));
      }
      
      public function showPeople() : void
      {
         GV.onlineClass.addEventListener(ClientOnLineSerSocket.GET_BASIC_MESSAGE,this.getAllUserInfo);
         GF.clearPeoples();
         GV.onlineClass.getUserListReq();
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
      
      public function savehome(depotarr:Array, usedarr:Array) : void
      {
         GV.onlineSocket.addEventListener(GetHomeInfoRes.SAVE_HOME_DEPOT_SUCC,this.saveHomeDepot);
         GetHomeInfoReq.saveHomeInfo(usedarr,depotarr);
      }
      
      private function saveHomeDepot(e:Event) : void
      {
         GV.onlineSocket.removeEventListener(GetHomeInfoRes.SAVE_HOME_DEPOT_SUCC,this.saveHomeDepot);
      }
   }
}

