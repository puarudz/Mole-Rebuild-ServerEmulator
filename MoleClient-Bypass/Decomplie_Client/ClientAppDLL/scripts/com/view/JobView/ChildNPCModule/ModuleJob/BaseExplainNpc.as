package com.view.JobView.ChildNPCModule.ModuleJob
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.loading.Loading;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.logic.socket.RocExpliain.RocChangJobRes;
   import com.logic.socket.lockHome.lockHomeRes;
   import com.logic.socket.smc.smcStatus.StatusReq;
   import com.view.JobView.ChildNPCModule.BaseNPCModule;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class BaseExplainNpc extends BaseNPCModule
   {
      
      public var NPCurl_str:String = "";
      
      public var NPCurl_strs:String = "";
      
      public var StatusReqs:StatusReq;
      
      public var depth_mc:MovieClip;
      
      public var btnLevel:MovieClip;
      
      public var rocBookMC:MovieClip;
      
      public var tipUI_mc:*;
      
      public function BaseExplainNpc()
      {
         super();
         this.makeInfo();
      }
      
      private function makeInfo() : void
      {
         var app:String = "點擊下面鏈接完成注冊，一定要用正確的電郵地址才能收到開啟郵件，登錄後到城堡找洛克，他有一套寶寶裝送你。你會在好友列表中找到我。";
         this.NPCurl_str = app + "http://reg.51mole.com/index.php?u=" + GV.MyInfo_userID;
         this.NPCurl_strs = "http://reg.51mole.com/index.php?u=" + GV.MyInfo_userID;
         this.StatusReqs = new StatusReq();
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.btnLevel = GV.MC_mapFrame["btnLevel"];
      }
      
      override public function npcClientFun(a:* = null) : void
      {
         BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.chartGoodsFun);
         GetItemCountReq.getItemCount(GV.MyInfo_userID,190018,0);
      }
      
      private function chartGoodsFun(e:*) : void
      {
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.chartGoodsFun);
         var showExplainUI:Class = GV.Lib_Map.getClass("showExplainUI");
         var obj:* = e.EventObj.obj;
         if(Boolean(LocalUserInfo.getVip() >> 6 & 1))
         {
            if(!MainManager.getAppLevel().getChildByName("explain_UI"))
            {
               GV.JobViews.setExpFlag(0);
               GV.JobViews.showRocExplainUI();
            }
            this.dispatchEvent(new Event(SHOWNPCBTN));
         }
         else
         {
            if(Boolean(this.tipUI_mc))
            {
               return;
            }
            this.tipUI_mc = new showExplainUI();
            BC.addEvent(this,this.tipUI_mc.addBook_btn,MouseEvent.CLICK,this.rocAddBookMC);
            BC.addEvent(this,this.tipUI_mc.enter_btn,MouseEvent.CLICK,this.rocShowCopyUI);
            this.tipUI_mc.str = this.NPCurl_str;
            BC.addEvent(this,this.tipUI_mc.close_btn,MouseEvent.CLICK,this.rocRemoveUI);
            BC.addEvent(this,this.tipUI_mc.drag_mc,MouseEvent.MOUSE_DOWN,this.beginDragRocUI);
            BC.addEvent(this,this.tipUI_mc.drag_mc,MouseEvent.MOUSE_UP,this.stopDragRocUI);
            MainManager.getAppLevel().addChild(this.tipUI_mc);
            MainManager.centerObj(this.tipUI_mc);
         }
      }
      
      private function rocRemoveUI(event:* = null) : void
      {
         BC.removeEvent(this,this.tipUI_mc.close_btn,MouseEvent.CLICK,this.rocRemoveUI);
         BC.removeEvent(this,this.tipUI_mc.drag_mc,MouseEvent.MOUSE_DOWN,this.beginDragRocUI);
         BC.removeEvent(this,this.tipUI_mc.drag_mc,MouseEvent.MOUSE_UP,this.stopDragRocUI);
         GC.stopAllMC(this.tipUI_mc);
         GC.clearAllChildren(this.tipUI_mc);
         MainManager.getAppLevel().removeChild(this.tipUI_mc);
         this.tipUI_mc = null;
         this.showNpcBtn();
      }
      
      private function rocJobOverNow(event:EventTaomee) : void
      {
         var myAlert:* = undefined;
         BC.removeEvent(this,GV.onlineSocket,RocChangJobRes.ROC_CHANGJOB,this.rocJobOverNow);
         var url:String = "resource/allJob/AlertPic/roc.swf";
         var info:String = "    歡迎你成為摩爾莊園的正式公民！我將贈送你一套摩爾寶寶裝，寶寶裝是莊園新公民的標志，穿上寶寶裝，大家都會來幫助的。";
         myAlert = Alert.showAlert(MainManager.getAppLevel(),url,info,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
         BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.showRocGood);
      }
      
      private function showRocGood(event:Event) : void
      {
         var myAlert:* = undefined;
         var url:String = "resource/cloth/icon/12131.swf";
         var info:String = "一套摩爾寶寶裝已經放入你的百寶箱了!";
         myAlert = Alert.showAlert(MainManager.getAppLevel(),url,info,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
         BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.showNpcBtn);
      }
      
      private function rocShowCopyUI(event:MouseEvent = null) : void
      {
         if(Boolean(MainManager.getAppLevel().getChildByName("explain_UI")))
         {
            return;
         }
         BC.addEvent(this,GV.onlineSocket,lockHomeRes.USER_LOCKHOME,this.fristShowCopyUI);
         this.StatusReqs.status(7,1);
      }
      
      private function fristShowCopyUI(event:EventTaomee) : void
      {
         LocalUserInfo.setVip(event.EventObj.Vip);
         BC.removeEvent(this,GV.onlineSocket,lockHomeRes.USER_LOCKHOME,this.fristShowCopyUI);
         if(Boolean(this.tipUI_mc))
         {
            this.rocRemoveUI();
         }
         GV.JobViews.setExpFlag(15);
         GV.JobViews.showRocExplainUI();
      }
      
      private function beginDragRocUI(event:MouseEvent) : void
      {
         this.tipUI_mc.startDrag();
      }
      
      private function stopDragRocUI(event:MouseEvent) : void
      {
         this.tipUI_mc.stopDrag();
      }
      
      private function rocAddBookMC(event:MouseEvent = null) : void
      {
         var tempMC:MCLoader = null;
         if(!MainManager.getAppLevel().getChildByName("rocAddBook_mc"))
         {
            this.rocBookMC = new MovieClip();
            this.rocBookMC.name = "rocAddBook_mc";
            MainManager.getAppLevel().addChild(this.rocBookMC);
            tempMC = new MCLoader("module/external/BooksUI/ExplainBook.swf",this.rocBookMC,Loading.TITLE_AND_PERCENT,"正在打開摩爾大使手冊");
            BC.addEvent(this,tempMC,MCLoadEvent.ON_SUCCESS,this.BookLoadOver);
            tempMC.doLoad();
         }
      }
      
      private function BookLoadOver(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = null;
         var childMC:* = undefined;
         var mcloader:MCLoader = null;
         if(Boolean(this.tipUI_mc))
         {
            this.rocRemoveUI();
         }
         this.depth_mc.rocDesk_mc.ExplainBook_mc.gotoAndStop(1);
         if(!GV.isChangeMap)
         {
            mainMC = evt.getParent();
            childMC = evt.getLoader();
            mainMC.addChild(childMC);
            mainMC.x = 0;
            mainMC.y = 0;
            BC.addEvent(this,GV.onlineSocket,"rocbookCloseEvent",this.closeRocBook);
            mcloader = evt.target as MCLoader;
            mcloader.clear();
         }
      }
      
      private function closeRocBook(event:* = null) : void
      {
         if(Boolean(MainManager.getAppLevel().getChildByName("rocAddBook_mc")))
         {
            BC.removeEvent(this,GV.onlineSocket,"rocbookCloseEvent",this.closeRocBook);
            GC.stopAllMC(this.rocBookMC);
            GC.clearChildren(this.rocBookMC);
            MainManager.getAppLevel().removeChild(this.rocBookMC);
            this.rocBookMC = null;
         }
      }
      
      public function showNpcBtn(e:* = null) : void
      {
         BC.removeEvent(this);
         this.dispatchEvent(new Event(SHOWNPCBTN));
      }
      
      override public function removeEventFun() : void
      {
         BC.removeEvent(this);
      }
   }
}

