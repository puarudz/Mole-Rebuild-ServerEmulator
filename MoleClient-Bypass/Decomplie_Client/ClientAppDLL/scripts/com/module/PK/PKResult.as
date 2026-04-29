package com.module.PK
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.socket.PKsocket.GameKingSocket;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class PKResult
   {
      
      private static var instance:PKResult = null;
      
      private var GameResultObj:Object;
      
      private var mcloader:MCLoader;
      
      private var GameResultPanel:*;
      
      private var ResultClass:Class;
      
      private var visitorPanel:MovieClip;
      
      public var gameID:uint;
      
      public function PKResult()
      {
         super();
      }
      
      public static function getInstance() : PKResult
      {
         return instance = instance || new PKResult();
      }
      
      public function showResult(score:uint, gameid:uint) : void
      {
         this.gameID = gameid;
         GV.onlineSocket.addEventListener("read_" + 1463,this.getPKresult);
         GameKingSocket.SubmitScorePK(PKHePanel.PKUID,PKHePanel.PKGID,score);
      }
      
      private function getPKresult(e:EventTaomee) : void
      {
         this.GameResultObj = e.EventObj;
         this.loadUI();
      }
      
      private function initInfo() : void
      {
         this.GameResultPanel.HLB = this.GameResultObj.HLB;
         this.GameResultPanel.myid.text = this.GameResultObj.MyID;
         this.GameResultPanel.heid.text = this.GameResultObj.PKUserID;
         this.GameResultPanel.myscore.text = this.GameResultObj.MyScore;
         this.GameResultPanel.myname.text = LocalUserInfo.getNickName();
         this.GameResultPanel.hescore.text = this.GameResultObj.PKUserScore;
         this.GameResultPanel.hename.text = PKHePanel.PKName;
         this.GameResultPanel.game.gotoAndStop("game" + this.gameID);
         if(this.GameResultObj.MyScore > this.GameResultObj.PKUserScore)
         {
            this.GameResultPanel.winlose.gotoAndStop(1);
            this.GameResultPanel.know_btn.visible = false;
            this.GameResultPanel.again_btn.visible = false;
            this.GameResultPanel.ok_btn.visible = true;
         }
         else
         {
            this.GameResultPanel.winlose.gotoAndStop(2);
            this.GameResultPanel.know_btn.visible = true;
            this.GameResultPanel.again_btn.visible = true;
            this.GameResultPanel.ok_btn.visible = false;
         }
      }
      
      private function loadUI() : void
      {
         if(!this.GameResultPanel)
         {
            this.mcloader = new MCLoader("module/PK/MyPKUI.swf",MainManager.getGameLevel(),1,"正在打開遊戲王勝負面板...");
            this.mcloader.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadSucc);
            this.mcloader.addEventListener(MCLoadEvent.ERROR,this.loadErr);
            this.mcloader.doLoad();
         }
         else
         {
            this.GameResultPanel.x = 200;
            this.GameResultPanel.y = 64;
            this.initInfo();
         }
      }
      
      private function removeEvent(e:EventTaomee) : void
      {
      }
      
      private function loadErr(event:MCLoadEvent) : void
      {
         trace("加載出錯");
      }
      
      private function loadSucc(event:MCLoadEvent) : void
      {
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeEvent);
         var a:DisplayObjectContainer = event.getParent();
         var b:Loader = event.getLoader();
         this.ResultClass = b.contentLoaderInfo.applicationDomain.getDefinition("PKResultUI") as Class;
         this.GameResultPanel = new this.ResultClass();
         this.GameResultPanel.x = 200;
         this.GameResultPanel.y = 64;
         MainManager.getTopLevel().addChild(this.GameResultPanel);
         var mcloader:MCLoader = event.target as MCLoader;
         mcloader.clear();
         this.visitorPanel = this.GameResultPanel;
         this.visitorPanel.close_btn.addEventListener(MouseEvent.CLICK,this.closeMC);
         this.visitorPanel.ok_btn.addEventListener(MouseEvent.CLICK,this.closeMC);
         this.visitorPanel.know_btn.addEventListener(MouseEvent.CLICK,this.closeMC);
         this.visitorPanel.again_btn.addEventListener(MouseEvent.CLICK,this.againPK);
         this.initInfo();
      }
      
      private function againPK(e:MouseEvent) : void
      {
         var url:String = null;
         var msg:String = null;
         this.GameResultPanel.y = 1000;
         if(this.GameResultPanel.HLB == 190389)
         {
            url = "resource/allJob/icon/" + 190389 + ".swf";
            msg = "    一枚“勇士章”已經放入你的百寶箱了！";
            Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"sure",true,false,"EMP_BUY");
         }
      }
      
      private function closeMC(e:MouseEvent) : void
      {
         var url:String = null;
         var msg:String = null;
         PKHePanel.PKUID = 0;
         PKHePanel.PKGID = 0;
         this.GameResultPanel.y = 1000;
         if(this.GameResultPanel.HLB == 190389)
         {
            url = "resource/allJob/icon/" + 190389 + ".swf";
            msg = "    一枚“勇士章”已經放入你的百寶箱了！";
            Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"sure",true,false,"EMP_BUY");
         }
      }
   }
}

