package com.module.PK
{
   import com.common.Alert.Alert;
   import com.common.view.MCScrollBar.ScrollBarTop;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.module.changeClothsModule.prevView;
   import com.view.userPanelView.Impeach;
   import com.view.userPanelView.userPanelView;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class PKHePanel
   {
      
      public static var PKName:String;
      
      public static var PKUID:uint;
      
      public static var PKGID:uint;
      
      public static var tmpPKName:String;
      
      public static var tmpPKUID:uint;
      
      private static var ID:uint;
      
      private static var HotUI:*;
      
      private static var ListUI:*;
      
      private static var HotUIClass:Class;
      
      private static var ListUIClass:Class;
      
      private static var MudNum:uint;
      
      private static var sendBool:Boolean;
      
      private static var sendtype:uint;
      
      private static var visitorPanel:MovieClip;
      
      private static var Man:Class;
      
      private static var len:uint;
      
      private static var ScrollBar:*;
      
      private static var myTimeout:*;
      
      private static var MC:MovieClip;
      
      private static var Obj:Object;
      
      private static var VisitorArr:Array;
      
      private static var mcloader:MCLoader;
      
      private static var willPKMan:*;
      
      private static var TodayPKObj:Object;
      
      private static var checkPKTimer:Number;
      
      private static var HotNum:uint = 0;
      
      private static var FlowerNum:uint = 0;
      
      private static var arrMC:Array = new Array();
      
      public function PKHePanel()
      {
         super();
      }
      
      public static function init(gamearr:Array, userid:uint, username:String) : void
      {
         tmpPKUID = userid;
         tmpPKName = username;
         VisitorArr = gamearr;
         loadUI();
      }
      
      private static function removeEvent(e:Event) : void
      {
         ListUI.y = 1000;
      }
      
      private static function loadUI() : void
      {
         if(!ListUI)
         {
            mcloader = new MCLoader("module/PK/MyPKUI.swf",MainManager.getGameLevel(),1,"正在打開遊戲王面板...");
            mcloader.addEventListener(MCLoadEvent.ON_SUCCESS,loadSucc);
            mcloader.addEventListener(MCLoadEvent.ERROR,loadErr);
            mcloader.doLoad();
         }
         else
         {
            ListUI.x = userPanelView.userPanel.x + 256;
            ListUI.y = userPanelView.userPanel.y;
            GC.clearAllChildren(MC.manMC);
            showVisitor();
         }
      }
      
      private static function loadErr(event:MCLoadEvent) : void
      {
         trace("加載出錯");
      }
      
      private static function loadSucc(event:MCLoadEvent) : void
      {
         GV.onlineSocket.addEventListener("removeMapEvent",removeEvent);
         var a:DisplayObjectContainer = event.getParent();
         var b:Loader = event.getLoader();
         HotUIClass = b.contentLoaderInfo.applicationDomain.getDefinition("VSPanel") as Class;
         ListUIClass = b.contentLoaderInfo.applicationDomain.getDefinition("HePKUI") as Class;
         Man = b.contentLoaderInfo.applicationDomain.getDefinition("man") as Class;
         ListUI = new ListUIClass();
         ListUI.y = 1000;
         MainManager.getTopLevel().addChild(ListUI);
         var mcloader:MCLoader = event.target as MCLoader;
         mcloader.clear();
         visitorPanel = ListUI;
         visitorPanel.drag_mc.addEventListener(MouseEvent.MOUSE_DOWN,drag_start);
         visitorPanel.drag_mc.addEventListener(MouseEvent.MOUSE_UP,drag_stop);
         visitorPanel.drag_mc.addEventListener(MouseEvent.MOUSE_MOVE,drag_move);
         visitorPanel.close_btn.addEventListener(MouseEvent.CLICK,closeMC);
         showVisitor();
      }
      
      public static function ReportMsg(e:MouseEvent = null) : void
      {
         var impeach:Impeach = new Impeach(tmpPKUID,tmpPKName);
      }
      
      private static function showVisitor() : void
      {
         var i:uint = 0;
         arrMC = new Array();
         visitorPanel.bg_mc.height = 265;
         MC = visitorPanel.visitorUI;
         len = VisitorArr.length;
         if(len > 7)
         {
            while(i < len)
            {
               initMan(VisitorArr[i],false);
               i++;
            }
            initScrollBar();
         }
         else
         {
            while(i < len)
            {
               initMan(VisitorArr[i],false);
               i++;
            }
            initScrollBar();
         }
         visitorPanel.x = userPanelView.userPanel.x + 256;
         visitorPanel.y = userPanelView.userPanel.y;
      }
      
      private static function closeMC(e:MouseEvent) : void
      {
         visitorPanel.x = -1000;
      }
      
      private static function initMan(manInfo:*, bool:Boolean) : void
      {
         var temp:* = new Man();
         if(manInfo.GameScore >= PKManager.getGameName(manInfo.GameID).minscore)
         {
            temp.pkbtn.addEventListener(MouseEvent.CLICK,pk30);
            temp.pkbtn.buttonMode = true;
         }
         else
         {
            temp.pkbtn.gotoAndStop(2);
            temp.pkbtn.addEventListener(MouseEvent.CLICK,cantpk);
            temp.pkbtn.buttonMode = true;
         }
         temp.visible = false;
         temp.GameID = manInfo.GameID;
         temp.GameName.text = PKManager.getGameName(manInfo.GameID).name;
         temp.GameScore.text = manInfo.GameScore;
         temp.Score = manInfo.GameScore;
         temp.GameFlag = manInfo.GameFlag;
         arrMC.push(temp);
         MC.manMC.addChild(temp);
      }
      
      private static function cantpk(e:MouseEvent = null) : void
      {
         Alert.showAlert(MainManager.getTopLevel(),"    這個小摩爾的訓練成績還不夠哦，先去和其他小摩爾挑戰吧！","",6,"D");
      }
      
      private static function closeHotPanel(e:MouseEvent = null) : void
      {
         HotUI.y = 1000;
         HotUI.visible = false;
      }
      
      private static function pk30(e:MouseEvent) : void
      {
         willPKMan = e.currentTarget.parent;
         if(!TodayPKObj)
         {
            GV.onlineSocket.addEventListener(finishSomethingRes.FINISH_SOMETHING_SUCC,getTodayPkNum);
            finishSomethingReq.sendReq(139);
         }
         else
         {
            canPK();
         }
      }
      
      private static function canPK() : void
      {
         if(TodayPKObj.Done >= 30)
         {
            Alert.showAlert(MainManager.getGameLevel(),"    今天你已經競技了30次囉！休息一下，明天繼續吧！","",6,"D");
         }
         else
         {
            pk();
         }
      }
      
      private static function getTodayPkNum(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(finishSomethingRes.FINISH_SOMETHING_SUCC,getTodayPkNum);
         TodayPKObj = e.EventObj;
         canPK();
      }
      
      private static function pk() : void
      {
         var userInfo:Object = null;
         var tempObj:Object = null;
         PKGID = willPKMan.GameID;
         if(willPKMan.Score < PKManager.getGameName(PKGID).minscore)
         {
            Alert.showAlert(MainManager.getTopLevel(),"    這個小摩爾的訓練成績還不夠哦，先去和其他小摩爾挑戰吧！","",6,"D");
            return;
         }
         if(willPKMan.GameID == PKManager.getGameName(55).id)
         {
            checkPKTimer = ServerUpTime.getInstance().date.hours;
            if(checkPKTimer < 8 || checkPKTimer >= 22)
            {
               Alert.showAlert(MainManager.getGameLevel(),"    尤尤已經休息了，等到8：00~22：00才能挑戰" + PKManager.getGameName(55).name + "。","",6,"D");
               return;
            }
         }
         if(!Boolean(HotUI))
         {
            HotUI = new HotUIClass();
            HotUI.gotoAndStop(1);
            HotUI.close_btn.addEventListener(MouseEvent.CLICK,closeHotPanel);
            HotUI.yes_btn.addEventListener(MouseEvent.CLICK,PKGameInfo);
            HotUI.no_btn.addEventListener(MouseEvent.CLICK,closeHotPanel);
            MainManager.getTopLevel().addChild(HotUI);
            new prevView(HotUI.mymole_mc,LocalUserInfo.getFamily().toString(16),LocalUserInfo.getClothItem());
            userInfo = userPanelView.userInfo;
            tempObj = GF.getPeopleObj(tmpPKUID);
            new prevView(HotUI.hemole_mc,userInfo.Color.toString(16),userInfo.itemArr,tempObj);
         }
         HotUI.visible = true;
         HotUI.x = 200;
         HotUI.y = 90;
         HotUI.pkscore.text = willPKMan.Score;
         HotUI.myid.text = LocalUserInfo.getUserID();
         HotUI.heid.text = tmpPKUID;
         HotUI.myname.text = LocalUserInfo.getNickName();
         HotUI.hename.text = tmpPKName;
         HotUI.game.gotoAndStop("game" + PKGID);
      }
      
      private static function PKGameInfo(e:MouseEvent) : void
      {
         closeHotPanel();
         PKUID = tmpPKUID;
         PKName = tmpPKName;
         GF.switchMap(PKManager.getGameName(PKGID).mapid,true);
      }
      
      private static function initScrollBar() : void
      {
         var i:uint = 0;
         if(len > 7)
         {
            arrange(arrMC);
            MC.scroll_mc.visible = true;
            if(!ScrollBar)
            {
               ScrollBar = new ScrollBarTop(MC.scroll_mc,MC.manMC,178,253);
            }
            else
            {
               ScrollBar.reSet();
            }
            MC.scroll_mc.drag_mc.visible = true;
            MC.scroll_mc.line_mc.visible = true;
         }
         else
         {
            for(i = len; i < 7; i++)
            {
               addBG();
            }
            MC.scroll_mc.drag_mc.visible = false;
            MC.scroll_mc.line_mc.visible = false;
            arrange(arrMC);
         }
      }
      
      private static function addBG() : void
      {
         var temp:* = new Man();
         temp.pkbtn.visible = false;
         arrMC.push(temp);
         MC.manMC.addChild(temp);
      }
      
      private static function arrange(arr:Array) : void
      {
         for(var k:uint = 0; k < arr.length; k++)
         {
            arr[k].y = 36 * k;
            arr[k].visible = true;
         }
      }
      
      private static function drag_start(evt:MouseEvent) : void
      {
         visitorPanel.startDrag();
      }
      
      private static function drag_stop(evt:MouseEvent) : void
      {
         visitorPanel.stopDrag();
      }
      
      private static function drag_move(evt:MouseEvent) : void
      {
         evt.updateAfterEvent();
      }
      
      private static function goto2(e:Event) : void
      {
         e.target.parent.gotoAndStop(2);
      }
      
      private static function goto1(e:Event) : void
      {
         e.target.parent.gotoAndStop(1);
      }
   }
}

