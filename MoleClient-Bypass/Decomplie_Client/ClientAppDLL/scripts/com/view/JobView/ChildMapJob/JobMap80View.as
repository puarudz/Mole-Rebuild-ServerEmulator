package com.view.JobView.ChildMapJob
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.JobLogic.JobLogic;
   import com.logic.socket.CSItems.*;
   import com.logic.socket.GetItemCount.*;
   import com.module.activityModule.SoundControlModule;
   import com.module.helpPanel.HelpPanel;
   import com.mole.app.map.MapManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class JobMap80View
   {
      
      public static var isHas:Boolean = false;
      
      private var Bln:Boolean = false;
      
      private var button_mc:MovieClip;
      
      private var target_mc:MovieClip;
      
      private var lamu_frame:int = 1;
      
      public function JobMap80View()
      {
         super();
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         this.init();
      }
      
      private function init() : void
      {
         this.button_mc = GV.MC_mapFrame["buttonLevel"];
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.button_mc.goto84.visible = false;
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.playMap84);
         BC.addEvent(this,this.button_mc.npc_mc.btn,MouseEvent.CLICK,this.clickHandler);
         BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getItemBack);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),12906,2);
      }
      
      private function getItemBack(e:EventTaomee) : void
      {
         if(Boolean(e.EventObj.arr) && Boolean(e.EventObj.arr.length) && e.EventObj.arr[0].id != 12906)
         {
            return;
         }
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getItemBack);
         var obj:Object = e.EventObj.obj;
         if(obj.Count > 0)
         {
            isHas = true;
         }
      }
      
      private function clickHandler(e:MouseEvent) : void
      {
         var url:String = "resource/allJob/AlertPic/rescue/79_02.swf";
         var msg:String = "    我的主人——曾經最偉大的魔法師尼爾拉，因為不被世人理解而創建了自己的地下之城。當人們再次接受魔法時，尼爾拉塔之門就會開啟。但這裡到底通往何處，誰也不知道……";
         Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
      }
      
      public function initJob() : void
      {
         this.target_mc.ball.moveBall.visible = false;
         this.initStone(null);
      }
      
      private function showNpcBtn(evt:Event = null) : void
      {
         this.button_mc.npc_mc.btn.visible = true;
      }
      
      private function initStone(evt:Event = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"79JobOver",this.initStone);
         this.target_mc.ball.visible = false;
         this.target_mc.lamu.visible = true;
      }
      
      private function onStoneBox(evt:MouseEvent) : void
      {
         var stoneNum:int = int(String(evt.currentTarget.name).slice(6));
         if(stoneNum == 1)
         {
            HelpPanel.getInstance().panelVisible("tips" + stoneNum);
         }
      }
      
      private function playMap84(evt:Event = null) : void
      {
         var msg:String = null;
         var towerMC:MovieClip = null;
         var loader:MCLoader = null;
         if(!isHas)
         {
            msg = "你還沒有在拉姆王那邊領取魔法之杖哦!";
            Alert.showAlert(MainManager.getAppLevel(),msg,"",6,"E");
            return;
         }
         if(JobLogic.hasGoneMap84 == 0)
         {
            towerMC = new MovieClip();
            towerMC.name = "towerMC";
            MainManager.getGameLevel().addChild(towerMC);
            loader = new MCLoader("resource/movie/joinTower.swf",towerMC,1,"正在加載動畫");
            loader.addEventListener(MCLoadEvent.ON_SUCCESS,this.towerLoadSuccess);
            loader.doLoad();
         }
         else
         {
            MapManager.enterMap(84);
         }
      }
      
      private function towerLoadSuccess(evt:MCLoadEvent = null) : void
      {
         SoundControlModule.getInstance().stopSund();
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:* = evt.getLoader();
         childMC.content.root.film.gotoAndPlay(2);
         mainMC.addChild(childMC);
         BC.addEvent(this,GV.onlineSocket,"joinTowerOk",this.towerMCEnd);
      }
      
      private function towerMCEnd(evt:Event = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"joinTowerOk",this.towerMCEnd);
         SoundControlModule.getInstance().playSund();
         JobLogic.hasGoneMap84 = 1;
         MapManager.enterMap(84);
      }
      
      private function removeEventHandler(evetn:EventTaomee) : void
      {
         this.target_mc.stone_1.removeEventListener(MouseEvent.CLICK,this.onStoneBox);
         this.target_mc.stone_2.removeEventListener(MouseEvent.CLICK,this.onStoneBox);
         BC.removeEvent(this);
      }
   }
}

