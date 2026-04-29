package com.view.mapView
{
   import com.common.Alert.*;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.info.MapInfo;
   import com.core.manager.ServerListManager;
   import com.core.socketlogic.ClientOnLineSerSocket;
   import com.global.staticData.MapsConfig;
   import com.logic.socket.searchMole.*;
   import com.logic.switchMapLogic.switchMapLogic;
   import com.mole.app.map.MapBase;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   
   public class smcMapView extends MapBase
   {
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var buttonLev:MovieClip;
      
      public var otehr_mc:MovieClip;
      
      public var bookMC:MovieClip;
      
      public var closeJesseTimer:Timer;
      
      public var JesseTimer:Timer;
      
      public var kvTimes:Timer;
      
      public var titNum:int = 1;
      
      public var ppObj:*;
      
      public var myAle:*;
      
      public var id:*;
      
      public var searchIDMap:Number;
      
      public function smcMapView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.buttonLev = GV.MC_mapFrame["buttonLevel"];
         this.otehr_mc = GV.MC_mapFrame["other_mc"];
         this.target_mc.search_mc.search_txt.addEventListener(FocusEvent.FOCUS_IN,this.focusInHandler);
         this.target_mc.search_mc.search_txt.addEventListener(KeyboardEvent.KEY_UP,this.searchMoleKey);
         this.target_mc.search_mc.search_btn.addEventListener(MouseEvent.CLICK,this.searchMole);
         this.target_mc.search_mc.start_btn.addEventListener(MouseEvent.CLICK,this.startSearch);
         this.target_mc.search_mc.close_btn.addEventListener(MouseEvent.CLICK,this.goto1);
         this.target_mc.room_mc.btn.buttonMode = true;
         this.target_mc.room_mc.btn.addEventListener(MouseEvent.MOUSE_OVER,this.rooOverHandler);
         this.target_mc.room_mc.btn.addEventListener(MouseEvent.MOUSE_OUT,this.rooOutHandler);
         for(var i:int = 1; i <= 3; i++)
         {
            this.buttonLev.tvBtn_mc["btn_" + i].addEventListener(MouseEvent.CLICK,this.TvShowHandler);
         }
         this.buttonLev.right_btn.addEventListener(MouseEvent.CLICK,this.waterHandler);
      }
      
      public function searchMoleKey(e:*) : void
      {
         if(e.keyCode == Keyboard.ENTER)
         {
            this.searchMole();
         }
      }
      
      private function focusInHandler(event:FocusEvent) : void
      {
         this.target_mc.search_mc.search_txt.text = "";
      }
      
      private function startSearch(evt:MouseEvent) : void
      {
         evt.target.parent.gotoAndPlay(2);
      }
      
      private function goto1(evt:MouseEvent) : void
      {
         evt.target.parent.gotoAndStop(1);
      }
      
      private function searchMole(e:* = null) : void
      {
         this.id = Number(this.target_mc.search_mc.search_txt.text);
         if(this.target_mc.search_mc.search_txt.text.length > 0)
         {
            if(!isNaN(this.id))
            {
               if(this.id < 10000)
               {
                  Alert.showAlert(MainManager.getAppLevel(),"","這個米米號不存在，你可能記錯了。",Alert.IKNOW_ALERT);
               }
               else if(this.id == LocalUserInfo.getUserID() || GF.peopleInSameMap(this.id))
               {
                  Alert.showAlert(MainManager.getAppLevel(),"","太意外了，這個神秘的摩爾就在眼前。",Alert.IKNOW_ALERT);
               }
               else
               {
                  searchMoleReq.sendReq(Number(this.target_mc.search_mc.search_txt.text));
                  GV.onlineSocket.addEventListener(searchMoleRes.SEARCHMOLE_SUCC,this.searchSucc);
                  GV.onlineSocket.addEventListener(ClientOnLineSerSocket.OFF_LINE,this.offline);
               }
            }
            else
            {
               Alert.showAlert(MainManager.getAppLevel(),"","只能是數字，其它我可看不懂。",Alert.IKNOW_ALERT);
            }
         }
         else
         {
            Alert.showAlert(MainManager.getAppLevel(),"","你沒有填米米號，我去哪裡找啊？！",Alert.IKNOW_ALERT);
         }
      }
      
      private function offline(e:*) : void
      {
         GV.onlineSocket.removeEventListener("OFF_LINE",this.offline);
         Alert.showAlert(MainManager.getAppLevel(),"","這個摩爾肯定做作業去了，在摩爾莊園裡找不到他。",Alert.IKNOW_ALERT);
      }
      
      private function searchSucc(e:*) : void
      {
         var flag:Boolean = false;
         var mapinfo:MapInfo = null;
         var serName:String = null;
         if(e.EventObj.OnlineID == 0)
         {
            this.searchIDMap = e.EventObj.MapID;
            if(!MapsConfig.MapsInfo[this.searchIDMap])
            {
               flag = false;
            }
            else
            {
               flag = Boolean(MapsConfig.MapsInfo[this.searchIDMap].isLamuWorld);
            }
            mapinfo = MapInfo.getMapInfo(this.searchIDMap,LocalUserInfo.getMapType());
            if(Boolean(mapinfo.isHSL) || Boolean(mapinfo.isNewUserMap))
            {
               Alert.showAlert(MainManager.getAppLevel(),"","這個摩爾離你比較遠，在" + e.EventObj.MapName + "，我不能傳送你到那裡。",Alert.IKNOW_ALERT);
            }
            else if(mapinfo.digTreasureId > 0)
            {
               this.myAle = Alert.showAlert(MainManager.getAppLevel(),"你的好友正在地下城探險呢，快點\n過去找他吧！","",Alert.SURE_ALERT,"C");
               this.searchIDMap = 184;
               this.myAle.addEventListener(Alert.CLICK_ + "1",this.nextGameFun,false,0,true);
               this.myAle.addEventListener(Alert.CLICK_ + "2",this.noGameFun,false,0,true);
            }
            else if(!(flag || this.searchIDMap == 172 || this.searchIDMap == 173 || this.searchIDMap == 174 || this.searchIDMap == 64 || this.searchIDMap == 142 || this.searchIDMap == 0 || (this.searchIDMap >= 98 && this.searchIDMap <= 104 || this.searchIDMap >= 114 && this.searchIDMap <= 118 || this.searchIDMap >= 120 && this.searchIDMap <= 135 || this.searchIDMap == 66 || this.searchIDMap == 148)))
            {
               this.myAle = Alert.showAlert(MainManager.getAppLevel(),"這個摩爾在" + e.EventObj.MapName + "，你要\n立即到那裡嗎？","",Alert.SURE_ALERT,"C");
               this.myAle.addEventListener(Alert.CLICK_ + "1",this.nextGameFun,false,0,true);
               this.myAle.addEventListener(Alert.CLICK_ + "2",this.noGameFun,false,0,true);
            }
         }
         else
         {
            serName = ServerListManager.getServerName(e.EventObj.OnlineID);
            Alert.showAlert(MainManager.getAppLevel(),"","這個摩爾離你比較遠，在" + e.EventObj.OnlineID + "." + serName + "的伺服器上，我不能傳送你到那裡。",Alert.IKNOW_ALERT);
         }
         GV.onlineSocket.removeEventListener(searchMoleRes.SEARCHMOLE_SUCC,this.searchSucc);
      }
      
      public function nextGameFun(e:*) : void
      {
         this.myAle.removeEventListener(Alert.CLICK_ + "1",this.nextGameFun);
         if(!(this.searchIDMap == LocalUserInfo.getMapID() || this.searchIDMap == 0))
         {
            LocalUserInfo.setMapID(0);
            GV.Room_DefaultRoomID = 10000;
            switchMapLogic.switchMapLogicHandler(this.searchIDMap);
         }
      }
      
      public function noGameFun(e:*) : void
      {
         this.myAle.removeEventListener(Alert.CLICK_ + "2",this.noGameFun);
      }
      
      private function rooOverHandler(evt:MouseEvent) : void
      {
         evt.target.parent.gotoAndPlay(2);
      }
      
      private function rooOutHandler(evt:MouseEvent) : void
      {
         evt.target.parent.gotoAndStop(1);
      }
      
      private function TvShowHandler(evt:MouseEvent) : void
      {
         var tempName:* = evt.target.name;
         var num:* = tempName.substr(4);
         if(this.buttonLev["tv_" + num].currentFrame < this.buttonLev["tv_" + num].totalFrames)
         {
            this.buttonLev["tv_" + num].nextFrame();
         }
         else
         {
            this.buttonLev["tv_" + num].gotoAndStop(1);
         }
      }
      
      private function waterHandler(evt:MouseEvent) : void
      {
         if(evt.target.name == "right_btn")
         {
            if(this.otehr_mc.water_2.currentFrame == 1)
            {
               this.otehr_mc.water_1.gotoAndPlay(2);
               this.otehr_mc.water_2.gotoAndPlay(2);
               this.otehr_mc.water_3.gotoAndPlay(2);
               this.otehr_mc.water_4.gotoAndPlay(2);
            }
            else
            {
               this.otehr_mc.water_1.gotoAndStop(1);
               this.otehr_mc.water_2.gotoAndStop(1);
               this.otehr_mc.water_3.gotoAndStop(1);
               this.otehr_mc.water_4.gotoAndStop(1);
            }
         }
      }
      
      override public function destroy() : void
      {
         this.target_mc.search_mc.search_txt.removeEventListener(FocusEvent.FOCUS_IN,this.focusInHandler);
         this.target_mc.search_mc.search_txt.removeEventListener(KeyboardEvent.KEY_UP,this.searchMoleKey);
         this.target_mc.search_mc.search_btn.removeEventListener(MouseEvent.CLICK,this.searchMole);
         this.target_mc.search_mc.start_btn.removeEventListener(MouseEvent.CLICK,this.startSearch);
         this.target_mc.search_mc.close_btn.removeEventListener(MouseEvent.CLICK,this.goto1);
         this.target_mc.room_mc.btn.removeEventListener(MouseEvent.MOUSE_OVER,this.rooOverHandler);
         this.target_mc.room_mc.btn.removeEventListener(MouseEvent.MOUSE_OUT,this.rooOutHandler);
         for(var i:int = 1; i <= 3; i++)
         {
            this.buttonLev.tvBtn_mc["btn_" + i].removeEventListener(MouseEvent.CLICK,this.TvShowHandler);
         }
         this.buttonLev.right_btn.removeEventListener(MouseEvent.CLICK,this.waterHandler);
         this.target_mc = null;
         this.depth_mc = null;
         this.buttonLev = null;
         this.otehr_mc = null;
         super.destroy();
      }
   }
}

