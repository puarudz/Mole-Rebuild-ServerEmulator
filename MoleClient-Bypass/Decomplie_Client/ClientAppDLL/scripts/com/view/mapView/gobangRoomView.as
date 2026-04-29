package com.view.mapView
{
   import com.common.util.MovieClipUtil;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.core.loading.Loading;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.global.staticData.CommandID;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.logic.socket.fiveChess.FiveChessStatusReq;
   import com.logic.socket.fiveChess.FiveChessStatusRes;
   import com.logic.switchMapLogic.switchMapLogic;
   import com.module.activityModule.Presented;
   import com.module.clothBuyModule.clothBuyModule;
   import com.module.helpPanel.HelpPanel;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.OnlineManager;
   import com.mole.app.manager.QueryItemCntManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.map.MapManager;
   import com.mole.debug.DebugManager;
   import com.mole.info.ItemInfo;
   import com.mole.net.events.SocketEvent;
   import com.view.monthlyView.besmearView;
   import com.view.monthlyView.contributeBookView;
   import com.view.monthlyView.smcBookView;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class gobangRoomView extends MapBase
   {
      
      public var paperMC:MovieClip;
      
      private var besmear:besmearView;
      
      private var smcBook:smcBookView;
      
      private var contributeBook:contributeBookView;
      
      private var drawMC:MovieClip;
      
      private var cupMC:MovieClip;
      
      private var newCup2MC:MovieClip;
      
      private var clickNum:int = 0;
      
      private var curtain:MovieClip;
      
      private var openMc:MovieClip;
      
      public function gobangRoomView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         BC.addEvent(this,GV.onlineSocket,"petAction_suc",this.switchMapHandler);
         BC.addEvent(this,GV.onlineSocket,"GETBG_EVENT",this.getBGEvent);
         GV.onlineSocket.addEventListener(FiveChessStatusRes.SEACE_STATUS,this.changeMcAction);
         var tempFive:FiveChessStatusReq = new FiveChessStatusReq();
         tempFive.fiveChessStatus();
         controlLevel.newsPaper_mc.buttonMode = true;
         BC.addEvent(this,controlLevel.newsPaper_mc,MouseEvent.MOUSE_OVER,this.paperOverHandler);
         BC.addEvent(this,controlLevel.newsPaper_mc,MouseEvent.MOUSE_OUT,this.paperOutHandler);
         BC.addEvent(this,controlLevel.newsPaper_mc,MouseEvent.CLICK,this.paperClickHandler);
         controlLevel.ContributeMC.buttonMode = true;
         controlLevel.smcBookMC.buttonMode = true;
         controlLevel.storyBookMC.buttonMode = true;
         BC.addEvent(this,controlLevel.newBook_btn,MouseEvent.CLICK,this.addStoryBook);
         BC.addEvent(this,controlLevel.ContributeMC,MouseEvent.CLICK,this.addContributeBook);
         BC.addEvent(this,controlLevel.smcBookMC,MouseEvent.CLICK,this.addSmcBook);
         BC.addEvent(this,controlLevel.storyBookMC,MouseEvent.CLICK,this.addStoryBook);
         BC.addEvent(this,controlLevel.cup_mc,MouseEvent.CLICK,this.cupClickHandler);
         BC.addEvent(this,controlLevel.sport_mc,MouseEvent.CLICK,this.sportClickHandler);
         BC.addEvent(this,controlLevel.sport_mc_2,MouseEvent.CLICK,this.newSportTips);
         BC.addEvent(this,controlLevel.sport_mc_1,MouseEvent.CLICK,this.natureClickHandler);
         BC.addEvent(this,controlLevel.sport_mc_3,MouseEvent.CLICK,this.thirdCupSport);
         BC.addEvent(this,controlLevel.sport_mc_4,MouseEvent.CLICK,this.forthCupSport);
         controlLevel.hero_book.visible = false;
         controlLevel["item_12202"].visible = false;
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),12202,2);
         OnlineManager.addCmdListener(CommandID.ITEMCOUNT,this.onCheckItem12202);
         SystemEventManager.addEventListener("moliya",this.moLiYaHandle);
         this.addNewSceneEvent();
      }
      
      private function addNewSceneEvent() : void
      {
         this.curtain = GV.MC_mapFrame["control_mc"].curtain;
         this.curtain.buttonMode = true;
         this.openMc = GV.MC_mapFrame["control_mc"].openMc;
         this.openMc.visible = false;
         BC.addEvent(this,this.curtain,MouseEvent.CLICK,this.clickCurtain);
         if(this.haveCupState())
         {
            this.curtain["mc"]["foot_mc"].visible = true;
         }
         else
         {
            this.curtain["mc"]["foot_mc"].visible = false;
         }
      }
      
      private function haveCupState() : Boolean
      {
         var obj:Object = null;
         var arr:Array = LocalUserInfo.getClothItem();
         for each(obj in arr)
         {
            if(obj.ItemID == 15133)
            {
               return true;
            }
         }
         return false;
      }
      
      private function clickCurtain(e:MouseEvent) : void
      {
         ++this.clickNum;
         if(this.clickNum >= 3)
         {
            this.curtain.buttonMode = false;
            BC.removeEvent(this,GV.MC_mapFrame["control_mc"].curtain,MouseEvent.CLICK,this.clickCurtain);
            this.curtain.gotoAndPlay(2);
            MovieClipUtil.playAppointFrameAndFunc(this.curtain,40,this.curtainMovieEndFunc,null,false);
         }
      }
      
      private function curtainMovieEndFunc() : void
      {
         this.curtain.stop();
         this.curtain.ropeMc.buttonMode = true;
         BC.addEvent(this,this.curtain.ropeMc,MouseEvent.CLICK,this.clickRope);
      }
      
      private function clickRope(e:MouseEvent) : void
      {
         BC.removeEvent(this,this.curtain.ropeMc,MouseEvent.CLICK,this.clickRope);
         this.curtain.play();
         this.openMc.visible = true;
         this.openMc.gotoAndPlay(2);
         MovieClipUtil.playEndAndFunc(this.openMc,this.openMovieEndFunc);
      }
      
      private function openMovieEndFunc() : void
      {
         this.openMc.go_349.buttonMode = true;
         this.openMc.stop();
         BC.addEvent(this,this.openMc.go_349,MouseEvent.CLICK,this.go349);
      }
      
      private function go349(e:MouseEvent) : void
      {
         MapManager.enterMap(349);
      }
      
      private function moLiYaHandle(e:Event) : void
      {
         var dayTypeHanle:Function = null;
         var dayType:QueryItemCntManager = null;
         dayTypeHanle = function(e:EventTaomee):void
         {
            dayType.removeEventListener(QueryItemCntManager.DayTYPE_QUERY,dayTypeHanle);
            var times:uint = uint(e.EventObj);
            if(times == 0)
            {
               openStatePanel();
            }
            else
            {
               mapSay(3);
            }
         };
         dayType = new QueryItemCntManager();
         dayType.addEventListener(QueryItemCntManager.DayTYPE_QUERY,dayTypeHanle);
         dayType.dayTypeQuery(31590);
      }
      
      private function openStatePanel() : void
      {
         var month:Number = ServerUpTime.getInstance().chinaDate.month + 1;
         if(month != 8 && month != 9)
         {
            return;
         }
         var daytodat:Number = ServerUpTime.getInstance().chinaDate.date;
         switch(daytodat)
         {
            case 30:
               ModuleManager.openPanel("MoLiYaBigThing1");
               break;
            case 31:
               ModuleManager.openPanel("MoLiYaBigThing2");
               break;
            case 1:
               ModuleManager.openPanel("MoLiYaBigThing3");
               break;
            case 2:
               ModuleManager.openPanel("MoLiYaBigThing4");
               break;
            case 3:
               ModuleManager.openPanel("MoLiYaBigThing5");
               break;
            case 4:
               ModuleManager.openPanel("MoLiYaBigThing6");
               break;
            case 5:
               ModuleManager.openPanel("MoLiYaBigThing7");
               break;
            default:
               DebugManager.outMsg(" 伺服器時間不在30號到4號之間!");
         }
      }
      
      private function onGetItem12202(e:Event) : void
      {
         SystemEventManager.removeEventListener("getItem12202",this.onGetItem12202);
         controlLevel["item_12202"].visible = false;
         Presented.getInstance().celebrate1225(1642);
      }
      
      private function onCheckItem12202(evt:SocketEvent) : void
      {
         OnlineManager.removeCmdListener(CommandID.ITEMCOUNT,this.onCheckItem12202);
         var itemPro:GetItemCountRes = evt.bodyInfo;
         var itemInfo:ItemInfo = itemPro.itemHash.getValue(12202);
         if(Boolean(itemInfo) && itemInfo.count > 0)
         {
            controlLevel["item_12202"].visible = false;
         }
         else
         {
            controlLevel["item_12202"].visible = true;
            SystemEventManager.addEventListener("getItem12202",this.onGetItem12202);
         }
      }
      
      private function newSportTips(evt:MouseEvent) : void
      {
         HelpPanel.getInstance().panelVisible("newCupMC",false);
      }
      
      private function getBGEvent(evt:Event) : void
      {
         var itemObj:Object = new Object();
         itemObj.id = 12731;
         itemObj.price = 0;
         itemObj.info = "0";
         clothBuyModule.buyAction(itemObj);
      }
      
      private function sportClickHandler(evt:MouseEvent) : void
      {
         HelpPanel.getInstance().panelVisible("cup_sport",false);
      }
      
      private function natureClickHandler(evt:MouseEvent) : void
      {
         HelpPanel.getInstance().panelVisible("fireCupMC",false);
      }
      
      private function cupClickHandler(evt:MouseEvent) : void
      {
         var tempMC:Class = null;
         if(!GV.MC_TopLever.getChildByName("cupMC"))
         {
            tempMC = GV.Lib_Map.getClass("cupMC") as Class;
            this.cupMC = new tempMC();
            GV.MC_TopLever.addChild(this.cupMC);
            this.cupMC.close_btn.addEventListener(MouseEvent.CLICK,this.removeCupHandler);
         }
      }
      
      private function thirdCupSport(evt:MouseEvent) : void
      {
         var tempMC:Class = null;
         if(!GV.MC_TopLever.getChildByName("newCup2MC"))
         {
            tempMC = GV.Lib_Map.getClass("newCup2MC") as Class;
            this.newCup2MC = new tempMC();
            GV.MC_TopLever.addChild(this.newCup2MC);
            this.newCup2MC.close_btn.addEventListener(MouseEvent.CLICK,this.removeNewCupHandler);
         }
      }
      
      private function forthCupSport(evt:MouseEvent) : void
      {
         HelpPanel.getInstance().panelVisible("newCup3MC",false);
      }
      
      private function onHeroBook(e:MouseEvent) : void
      {
         ModuleManager.openPanel("WeenActivityPanel");
      }
      
      private function removeCupHandler(evt:MouseEvent = null) : void
      {
         this.cupMC.close_btn.removeEventListener(MouseEvent.CLICK,this.removeCupHandler);
         GC.clearAllChildren(this.cupMC);
         this.cupMC.parent.removeChild(this.cupMC);
         this.cupMC = null;
      }
      
      private function removeNewCupHandler(evt:MouseEvent = null) : void
      {
         this.newCup2MC.close_btn.removeEventListener(MouseEvent.CLICK,this.removeCupHandler);
         GC.clearAllChildren(this.newCup2MC);
         this.newCup2MC.parent.removeChild(this.newCup2MC);
         this.newCup2MC = null;
      }
      
      private function addStoryBook(event:MouseEvent) : void
      {
         var tempMC:MCLoader = null;
         if(!GV.isChangeMap)
         {
            this.drawMC = new MovieClip();
            this.drawMC.name = "drawbook_mc";
            MainManager.getTopLevel().addChild(this.drawMC);
            tempMC = new MCLoader("resource/besmearBook/other/besmearBook.swf?0908",this.drawMC,Loading.TITLE_AND_PERCENT,"正在打開書集");
            tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.drewBookLoadOver);
            tempMC.doLoad();
         }
      }
      
      private function addSmcBook(event:MouseEvent) : void
      {
         var tempMC:MCLoader = null;
         if(!GV.isChangeMap)
         {
            this.drawMC = new MovieClip();
            this.drawMC.name = "smcbook_mc";
            MainManager.getTopLevel().addChild(this.drawMC);
            tempMC = new MCLoader("resource/besmearBook/other/smcBook.swf?0908",this.drawMC,Loading.TITLE_AND_PERCENT,"正在打開書集");
            tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.drewBookLoadOver);
            tempMC.doLoad();
         }
      }
      
      private function addContributeBook(event:MouseEvent) : void
      {
         var tempMC:MCLoader = null;
         if(!GV.isChangeMap)
         {
            this.drawMC = new MovieClip();
            this.drawMC.name = "contributebook_mc";
            MainManager.getTopLevel().addChild(this.drawMC);
            tempMC = new MCLoader("resource/besmearBook/other/contributeBook.swf?0908",this.drawMC,Loading.TITLE_AND_PERCENT,"正在打開書集");
            tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.drewBookLoadOver);
            tempMC.doLoad();
         }
      }
      
      private function drewBookLoadOver(evt:MCLoadEvent) : void
      {
         var mcloader:MCLoader = null;
         var mainMC:DisplayObjectContainer = null;
         var childMC:* = undefined;
         if(!GV.isChangeMap)
         {
            mcloader = MCLoader(evt.target);
            mcloader.removeEventListener(MCLoadEvent.ON_SUCCESS,this.drewBookLoadOver);
            mainMC = evt.getParent();
            childMC = evt.getLoader();
            mainMC.addChild(childMC);
            childMC.visible = true;
            this.smcBook = new smcBookView(childMC);
            this.besmear = new besmearView(childMC);
            this.contributeBook = new contributeBookView(childMC);
            childMC.content.root.close_btn.addEventListener(MouseEvent.CLICK,this.removebesmear);
            mcloader.clear();
         }
      }
      
      private function removebesmear(evt:MouseEvent = null) : void
      {
         if(evt != null)
         {
            evt.currentTarget.removeEventListener(MouseEvent.CLICK,this.removebesmear);
         }
         MoveTo.CanMove = true;
         this.besmear.removeBtnHandler();
         GC.stopAllMC(this.drawMC);
         GC.clearChildren(this.drawMC);
         this.drawMC.parent.removeChild(this.drawMC);
         this.drawMC = null;
      }
      
      private function paperOverHandler(evt:MouseEvent) : void
      {
         evt.currentTarget.gotoAndStop(2);
      }
      
      private function paperOutHandler(evt:MouseEvent) : void
      {
         evt.currentTarget.gotoAndStop(1);
      }
      
      private function paperClickHandler(evt:MouseEvent) : void
      {
         var paper:Class = null;
         if(!MainManager.getAppLevel().getChildByName("paperMC"))
         {
            paper = GV.Lib_Map.getClass("new_mc") as Class;
            this.paperMC = new paper();
            this.paperMC.name = "paperMC";
            MainManager.getAppLevel().addChild(this.paperMC);
            this.paperMC.close_btn.addEventListener(MouseEvent.CLICK,this.removePaper);
         }
      }
      
      private function removePaper(evt:MouseEvent = null) : void
      {
         this.paperMC.close_btn.removeEventListener(MouseEvent.CLICK,this.removePaper);
         GC.stopAllMC(this.paperMC);
         GC.clearAllChildren(this.paperMC);
         this.paperMC.parent.removeChild(this.paperMC);
         this.paperMC = null;
      }
      
      private function changeMcAction(evt:EventTaomee) : void
      {
         var itemID:Object = null;
         var frameNum:Object = null;
         for(var i:int = 0; i < evt.EventObj.senceArr.length; i++)
         {
            itemID = evt.EventObj.senceArr[i].Itemid;
            frameNum = evt.EventObj.senceArr[i].started;
            depthLevel["chessboard_" + itemID].gotoAndStop(Number(frameNum) + 1);
         }
      }
      
      private function switchMapHandler(evt:Event) : void
      {
         var arr:Array = [26,34,9];
         var tempNum:int = Math.floor(Math.random() * 3);
         GV.Room_DefaultRoomID = 0;
         LocalUserInfo.setMapID(0);
         switchMapLogic.switchMapLogicHandler(arr[tempNum]);
      }
      
      override public function destroy() : void
      {
         SystemEventManager.removeEventListener("getItem12202",this.onGetItem12202);
         OnlineManager.removeCmdListener(CommandID.ITEMCOUNT,this.onCheckItem12202);
         if(this.paperMC != null)
         {
            this.removePaper();
         }
         if(this.drawMC != null)
         {
            this.removebesmear();
         }
         if(this.cupMC != null)
         {
            this.removeCupHandler();
         }
         GV.onlineSocket.removeEventListener(FiveChessStatusRes.SEACE_STATUS,this.changeMcAction);
         SystemEventManager.removeEventListener("moliya",this.moLiYaHandle);
         super.destroy();
      }
   }
}

