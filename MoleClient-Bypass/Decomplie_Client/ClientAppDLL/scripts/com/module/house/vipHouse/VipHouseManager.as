package com.module.house.vipHouse
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.getSceneUserInfo.GetSceneUserInfoReq;
   import com.logic.socket.getSceneUserInfo.GetSceneUserRes;
   import com.logic.switchMapLogic.switchMapLogic;
   import com.mole.app.map.MapManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.system.ApplicationDomain;
   import flash.text.TextField;
   
   public class VipHouseManager
   {
      
      private static var app:ApplicationDomain;
      
      private static var POSITION:Array = [{
         "x":491,
         "y":298
      },{
         "x":391,
         "y":106
      },{
         "x":460,
         "y":85
      },{
         "x":549,
         "y":84
      },{
         "x":272,
         "y":131
      },{
         "x":345,
         "y":150
      },{
         "x":438,
         "y":138
      },{
         "x":520,
         "y":125
      },{
         "x":228,
         "y":170
      },{
         "x":305,
         "y":189
      },{
         "x":410,
         "y":185
      },{
         "x":495,
         "y":176
      },{
         "x":227,
         "y":221
      },{
         "x":285,
         "y":240
      },{
         "x":368,
         "y":227
      },{
         "x":452,
         "y":235
      },{
         "x":345,
         "y":282
      },{
         "x":418,
         "y":300
      },{
         "x":514,
         "y":253
      },{
         "x":560,
         "y":195
      }];
      
      private var npc_linkage_array:Array = [{
         "x":315,
         "y":63,
         "str":"silky_house",
         "id":58,
         "name":"絲爾特"
      }];
      
      private var __root:DisplayObjectContainer;
      
      private var dataArray:Array;
      
      private var vipDataArray:Array;
      
      private var positionArray:Array;
      
      private var houseIconArray:Array;
      
      private var alertMC:MovieClip;
      
      private var quickDoor:MovieClip;
      
      private var txt:TextField;
      
      private var yesBtn:SimpleButton;
      
      private var getSceneUserInfoReq:GetSceneUserInfoReq;
      
      public function VipHouseManager()
      {
         super();
         this.positionArray = [];
         this.houseIconArray = [];
      }
      
      public static function getMovieClip(str:String) : MovieClip
      {
         var cls:Class = app.getDefinition(str) as Class;
         return new cls() as MovieClip;
      }
      
      public function setHouseRoot(i:Loader) : void
      {
         this.__root = i.content as DisplayObjectContainer;
         app = i.contentLoaderInfo.applicationDomain;
         this.alertMC = this.__root["alertMC"];
         this.quickDoor = this.__root["quickDoor"];
         this.txt = this.alertMC["txt"];
         this.yesBtn = this.alertMC["yes_btn"];
         this.initHandler();
      }
      
      private function initHandler() : void
      {
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeMapHandler);
         this.quickDoor.buttonMode = true;
         this.quickDoor.addEventListener(MouseEvent.CLICK,this.quickDoorHandler);
         this.yesBtn.addEventListener(MouseEvent.CLICK,this.yesBtnHandler);
         GV.onlineSocket.addEventListener(GetSceneUserRes.GET_SCENE_INFO,this.getSenceUserInfor);
      }
      
      private function removeMapHandler(event:Event) : void
      {
         GV.onlineSocket.removeEventListener(GetSceneUserRes.GET_SCENE_INFO,this.getSenceUserInfor);
      }
      
      private function quickDoorHandler(event:MouseEvent) : void
      {
         this.__root.addChild(this.alertMC);
         MainManager.centerObj(this.alertMC);
      }
      
      private function yesBtnHandler(event:MouseEvent) : void
      {
         if(this.txt.text.length < 5 || this.txt.text.length > 9 || int(this.txt.text) <= 50000)
         {
            Alert.showAlert(GV.MC_AppLever,"你填入的米米號不存在！","",6,"D");
            return;
         }
         var userID:int = int(this.txt.text);
         this.alertMC.y = -1000;
         this.txt.text = "";
         this.getSceneUserInfoReq = new GetSceneUserInfoReq();
         this.getSceneUserInfoReq.getSeceeUserInfo(userID);
      }
      
      private function getSenceUserInfor(event:EventTaomee) : void
      {
         var obj:Object = event.EventObj;
         var mapID:int = obj.UserID + GV.TwentyBillion;
         if(mapID == LocalUserInfo.getUserID() + GV.TwentyBillion)
         {
            if(GV.Room_DefaultRoomID != GV.MyInfo_userID && !GV.isChangeMap)
            {
               if(GV.MapInfo_mapID < 1000)
               {
                  GV.MyInfo_PrevMap = GV.MapInfo_mapID;
               }
               GV.Room_DefaultRoomID = GV.MyInfo_userID;
               MapManager.enterMap(mapID);
            }
            return;
         }
         if(!GF.BT(obj.Vip,2))
         {
            if(GV.MapInfo_mapID < 1000)
            {
               GV.MyInfo_PrevMap = GV.MapInfo_mapID;
            }
            if(GV.MapInfo_mapID != mapID)
            {
               GV.Room_DefaultRoomID = mapID;
               switchMapLogic.switchMapLogicHandler(mapID);
            }
         }
         else
         {
            Alert.showAlert(GV.MC_AppLever,"這個小摩爾現在不在家哦，他出門前把門鎖起來了，下次再來拜訪吧！","",6,"D");
         }
      }
      
      public function setHouseDataArray(arr:Array, vipArray:Array = null) : void
      {
         this.dataArray = arr.slice();
         this.vipDataArray = vipArray.slice();
      }
      
      public function destroy() : void
      {
         var i:VipHouseIconView = null;
         GV.onlineSocket.removeEventListener(GetSceneUserRes.GET_SCENE_INFO,this.getSenceUserInfor);
         this.quickDoor.removeEventListener(MouseEvent.CLICK,this.quickDoorHandler);
         this.yesBtn.removeEventListener(MouseEvent.CLICK,this.yesBtnHandler);
         for each(i in this.houseIconArray)
         {
            i.clear();
         }
         this.positionArray = [];
         this.houseIconArray = [];
         this.txt = null;
         this.yesBtn = null;
         this.quickDoor = null;
         this.alertMC = null;
         this.__root = null;
      }
      
      public function showRandomHouse() : void
      {
         var pos:Array = null;
         var j:Object = null;
         var houseIcon:VipHouseIconView = null;
         var npcHouseIcon:NpcHouseIconView = null;
         var arr:Array = this.getRandomArray();
         pos = this.getRandomPosition(arr.length);
         for(var i:int = 0; i < pos.length; i++)
         {
            houseIcon = new VipHouseIconView();
            houseIcon.setID(arr[i]["id"]);
            houseIcon.setName(arr[i]["name"]);
            houseIcon.getIconMC().x = pos[i]["x"];
            houseIcon.getIconMC().y = pos[i]["y"];
            this.__root.addChild(houseIcon.getIconMC());
            this.houseIconArray.push(houseIcon);
         }
         for each(j in this.npc_linkage_array)
         {
            npcHouseIcon = new NpcHouseIconView(j["str"]);
            npcHouseIcon.setID(j["id"]);
            npcHouseIcon.setName(j["name"]);
            npcHouseIcon.getIconMC().x = j["x"];
            npcHouseIcon.getIconMC().y = j["y"];
            this.__root.addChild(npcHouseIcon.getIconMC());
            this.houseIconArray.push(npcHouseIcon);
         }
      }
      
      private function getRandomArray() : Array
      {
         var tempArray:Array = null;
         var num:int = 0;
         var i:int = 0;
         if(this.vipDataArray.length <= 20)
         {
            return this.vipDataArray;
         }
         tempArray = [];
         for(i = 0; i < 20; i++)
         {
            num = Math.floor(Math.random() * this.vipDataArray.length);
            tempArray.push(this.vipDataArray[num]);
            this.vipDataArray.splice(num,1);
         }
         return tempArray;
      }
      
      private function getRandomPosition(len:int) : Array
      {
         var num:int = 0;
         var positionArrayClone:Array = POSITION.slice();
         var tempArray:Array = [];
         for(var i:int = 0; i < len; i++)
         {
            num = Math.floor(Math.random() * positionArrayClone.length);
            tempArray.push(positionArrayClone[num]);
            positionArrayClone.splice(num,1);
         }
         return tempArray;
      }
   }
}

