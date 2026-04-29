package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.global.staticData.CommandID;
   import com.logic.JoinGameLogic.JoinGameLogic;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.logic.socket.superlamuParty.superlamuPartySocket;
   import com.module.activityModule.Presented;
   import com.module.activityModule.checkItem;
   import com.module.clothBuyModule.clothBuyModule;
   import com.module.deal.Deal;
   import com.module.helpPanel.HelpPanel;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.npc.dialog.TalkEvent;
   import com.module.superPetModule.petItemModule;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.gameking.GameKingManager;
   import com.mole.app.manager.ActivityTmpDataManager;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.StatisticsManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.view.JobView.NPCLogic;
   import com.view.mapView.activity.InvitationGoActivity;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class PutiPoppaMapView extends MapBase
   {
      
      private var petStudyMC:MovieClip;
      
      private var petFileMC:MovieClip;
      
      private var childMC:*;
      
      private var naturalnessMC:MovieClip;
      
      private var petStudyBookUI:MovieClip;
      
      private var goodMoleImage:int;
      
      private var imageArr:Array = new Array(190629,190630,190631);
      
      public function PutiPoppaMapView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         BC.addEvent(this,GV.onlineSocket,"NPCwordMapChang_over",this.getNPCJobObj);
         GV.onlineSocket.addEventListener("fireAction_suc",this.petFileHanlder);
         controlLevel.book_btn.buttonMode = true;
         BC.addEvent(this,controlLevel.book_btn,MouseEvent.MOUSE_OVER,this.BookOverHandler);
         BC.addEvent(this,controlLevel.book_btn,MouseEvent.MOUSE_OUT,this.BookOutHandler);
         BC.addEvent(this,controlLevel.book_btn,MouseEvent.CLICK,this.bookClickHandler);
         BC.addEvent(this,controlLevel.petStudy_newBtn,MouseEvent.CLICK,this.petStudybookHandler);
         BC.addEvent(this,controlLevel.petStudy_btn,MouseEvent.CLICK,this.petStudybookHandler);
         BC.addEvent(this,controlLevel.petStudy_btn,MouseEvent.MOUSE_OVER,this.petStudybookOver);
         BC.addEvent(this,controlLevel.petStudy_btn,MouseEvent.MOUSE_OUT,this.petStudybookOut);
         controlLevel.petStudy_btn.buttonMode = true;
         BC.addEvent(this,controlLevel.mapBtn_1,MouseEvent.MOUSE_OVER,this.doorOverHandler);
         BC.addEvent(this,controlLevel.mapBtn_1,MouseEvent.MOUSE_OUT,this.doorOutHandler);
         BC.addEvent(this,controlLevel.naturalnessBook,MouseEvent.CLICK,this.naturalnessBookHandler);
         petItemModule.itemVisibleHandler(controlLevel);
         if(controlLevel["diaryBook"] != null)
         {
            controlLevel["diaryBook"].visible = false;
            this.checkDiary();
         }
         BC.addEvent(this,TalkEvent,"puti_temp_grapeClass",function(E:*):*
         {
            buttonLevel.bodhi_btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         });
         this.InitLearningMachine();
         SystemEventManager.addEventListener("putao_class",this.onPutaoClass);
         SystemEventManager.addEventListener("putao_Work",this.onPutaoWork);
         SystemEventManager.addEventListener("getYearsPack",this.getYearsPackHandler);
         GV.onlineSocket.addEventListener("sendData",this.sendData);
         SystemEventManager.addEventListener("letterTaskOver",this.hLetterTaskOver);
         BC.addEvent(this,GV.onlineSocket,"read_" + CommandID.TreasureBowl,this.back1242);
         SystemEventManager.addEventListener("openSearchGame",this.openSearchGame);
         SystemEventManager.addEventListener("musicLesson",this.musicLesson);
         SystemEventManager.addEventListener("beginGame",this.onEnterSeat);
         SystemEventManager.addEventListener("npcTalk",this.onNpcTalk);
         InvitationGoActivity.instance().queryInit(5);
         SystemEventManager.addEventListener("questionOver",this.firequestionOver);
         super.initView();
      }
      
      private function firequestionOver(e:SystemEvent) : void
      {
         GF.sendSocket(CommandID.cli_proto_recoder_older_entrust_times,500,1);
      }
      
      private function back1242(e:EventTaomee) : void
      {
         var msg:String = null;
         BC.removeEvent(this,GV.onlineSocket,"read_" + CommandID.TreasureBowl,this.back1242);
         var infoObj:Object = e.EventObj;
         if(infoObj.type == 229)
         {
            msg = GoodsInfo.getItemNameByID(infoObj.itemId) + "x" + infoObj.count;
            Alert.smileAlart("恭喜你獲得" + msg + "。");
         }
      }
      
      private function hLetterTaskOver(e:SystemEvent) : void
      {
         superlamuPartySocket.treasurebowl(229);
         ActivityTmpDataManager.curTaskId = 0;
      }
      
      private function onNpcTalk(e:*) : void
      {
         if(InvitationGoActivity._flag == 0)
         {
            Alert.smileAlart("   你現在沒有邀請函哦，去領取吧！",function():void
            {
               ModuleManager.openPanel("InvitationGoPanel");
            });
         }
         else if(InvitationGoActivity._flag == 1)
         {
            mapSay(32);
         }
         else
         {
            mapSay(30);
         }
      }
      
      private function onEnterSeat(e:*) : void
      {
         GameKingManager.instance.enterGameById(59);
      }
      
      private function musicLesson(e:*) : void
      {
         JoinGameLogic.joinGameAction(6,4,44,0);
         GF.loginGame(6,4,44,0);
         var obj:Object = new Object();
         obj.singleGameID = 6;
         obj.chairID = 4;
         obj.eventType = 44;
         obj.click_btn = new MovieClip();
         obj.click_btn.x = 400;
         obj.click_btn.y = 400;
         JoinGameLogic.loginInit(obj,"testOnload");
      }
      
      private function openSearchGame(e:*) : void
      {
         JoinGameLogic.joinGameAction(5,5,10,8);
         GF.loginGame(5,5,10,8);
         var obj:Object = new Object();
         obj.singleGameID = 8;
         obj.chairID = 5;
         obj.eventType = 10;
         obj.click_btn = new MovieClip();
         obj.click_btn.x = 400;
         obj.click_btn.y = 400;
         JoinGameLogic.loginInit(obj,"testOnload");
      }
      
      private function getYearsPackHandler(evt:Event) : void
      {
         if(LocalUserInfo.isVIP())
         {
            Presented.getInstance().celebrate1225(2068);
         }
         else
         {
            Presented.getInstance().celebrate1225(2067);
         }
      }
      
      private function sendData(e:*) : void
      {
         GV.onlineSocket.removeEventListener("sendData",this.sendData);
         StatisticsManager.send(6);
      }
      
      private function getNPCJobObj(e:*) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"NPCwordMapChang_over",this.getNPCJobObj);
         NPCLogic.init(buttonLevel.bodhiBox,buttonLevel.bodhi_btn,depthLevel.bangongzuo.bodhi_npcMC,53);
      }
      
      private function onPutaoWork(e:SystemEvent) : void
      {
         BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.CheckIsHelped);
         finishSomethingReq.sendReq(31021);
      }
      
      private function CheckIsHelped(e:EventTaomee) : void
      {
         var loader:Loader = null;
         if(e.EventObj.Type == 31021)
         {
            BC.removeEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.CheckIsHelped);
            if(e.EventObj.Done == 1)
            {
               Alert.smileAlart("    今天已經打過工了，太辛苦了，休息一下吧！");
            }
            else
            {
               loader = new Loader();
               loader.load(VL.getURLRequest("module/external/HelpPutiWork.swf"));
               MainManager.getAppLevel().addChild(loader);
            }
         }
      }
      
      private function onPutaoClass(e:Event) : void
      {
         buttonLevel.bodhi_btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
      }
      
      private function checkDiary() : void
      {
         BC.addEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.havediarykResult);
         checkItem.checkItemHandler(160410);
      }
      
      private function havediarykResult(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.havediarykResult);
         if(evt.EventObj.count < 1)
         {
            buttonLevel["diaryBook"].buttonMode = true;
            buttonLevel["diaryBook"].visible = true;
            BC.addEvent(this,buttonLevel["diaryBook"],MouseEvent.CLICK,this.diaryHandler);
         }
      }
      
      private function diaryHandler(e:MouseEvent) : void
      {
         BC.removeEvent(this,buttonLevel["diaryBook"],MouseEvent.CLICK,this.diaryHandler);
         buttonLevel.removeChild(buttonLevel["diaryBook"]);
         Deal.BuyItem(160410,1,function(... E):*
         {
            var msg:String = "    恭喜你發現了拉姆日記本，快去你的小屋倉庫看看吧！";
            var url:String = "resource/goods/icon/160410.swf";
            Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
         },function(... E):*
         {
            var msg:String = "    你已經有拉姆日記本了，不要太貪心哦!";
            var url:String = "resource/goods/icon/160410.swf";
            Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
         });
      }
      
      private function showTisEvent(eve:MouseEvent) : void
      {
         HelpPanel.getInstance().panelVisible("TIPS_MC");
      }
      
      private function balloonHandler(event:MouseEvent) : void
      {
         event.currentTarget.gotoAndPlay(2);
      }
      
      private function rkRunBtnHandler(event:MouseEvent) : void
      {
         GV.onlineSocket.addEventListener("RK_CATCH",this.rkCatchHandler);
         event.currentTarget.gotoAndPlay(2);
      }
      
      private function rkCatchHandler(event:Event) : void
      {
         GV.onlineSocket.removeEventListener("RK_CATCH",this.rkCatchHandler);
         BC.removeEvent(this,controlLevel.rkRunBtn,MouseEvent.CLICK,this.rkRunBtnHandler);
         controlLevel.rkRunBtn.catchRKBtn.addEventListener(MouseEvent.CLICK,this.catchRKHandler);
      }
      
      private function catchRKHandler(event:MouseEvent) : void
      {
         HelpPanel.getInstance().panelVisible("CARCH_RK");
      }
      
      private function naturalnessBookHandler(evt:MouseEvent) : void
      {
         var tempMC:MCLoader = null;
         if(!GV.MC_AppLever.getChildByName("naturalnessMC"))
         {
            this.naturalnessMC = new MovieClip();
            this.naturalnessMC.name = "naturalnessMC";
            GV.MC_AppLever.addChild(this.naturalnessMC);
            tempMC = new MCLoader("resource/besmearBook/naturalnessBook.swf",this.naturalnessMC,1,"正在打開自然課本......");
            tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.naturalnessBookLoadOveraa);
            tempMC.doLoad();
         }
      }
      
      private function naturalnessBookLoadOveraa(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         this.childMC = evt.getLoader();
         mainMC.addChild(this.childMC);
         var mcloader:MCLoader = evt.target as MCLoader;
         mcloader.removeEventListener(MCLoadEvent.ON_SUCCESS,this.naturalnessBookLoadOveraa);
         mcloader.clear();
         GV.onlineSocket.addEventListener("removeNaturalnessBook",this.removeEnaturalnessBookHandler);
      }
      
      private function removeEnaturalnessBookHandler(evt:Event) : void
      {
         GV.onlineSocket.removeEventListener("removeNaturalnessBook",this.removeEnaturalnessBookHandler);
         GC.stopAllMC(this.naturalnessMC);
         GC.clearChildren(this.naturalnessMC);
         this.naturalnessMC.parent.removeChild(this.naturalnessMC);
         this.naturalnessMC = null;
      }
      
      private function petFileHanlder(event:Event) : void
      {
         var tempMC:MCLoader = null;
         if(!GV.MC_AppLever.getChildByName("petFileMC"))
         {
            this.petFileMC = new MovieClip();
            this.petFileMC.name = "petFileMC";
            GV.MC_AppLever.addChild(this.petFileMC);
            tempMC = new MCLoader("module/external/PetStudyData.swf",this.petFileMC,1,"正在打開拉姆學習檔案......");
            tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.petFileLoadOveraa);
            tempMC.doLoad();
         }
      }
      
      private function petFileLoadOveraa(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         this.childMC = evt.getLoader();
         mainMC.addChild(this.childMC);
         var mcloader:MCLoader = evt.target as MCLoader;
         mcloader.removeEventListener(MCLoadEvent.ON_SUCCESS,this.petFileLoadOveraa);
         mcloader.clear();
      }
      
      private function doorOverHandler(evt:MouseEvent) : void
      {
         controlLevel.door_mc.gotoAndStop(2);
      }
      
      private function doorOutHandler(evt:MouseEvent) : void
      {
         controlLevel.door_mc.gotoAndStop(1);
      }
      
      private function petStudybookOver(evt:MouseEvent) : void
      {
         controlLevel.petStudy_btn.gotoAndPlay(2);
      }
      
      private function petStudybookOut(evt:MouseEvent) : void
      {
         controlLevel.petStudy_btn.gotoAndStop(1);
      }
      
      private function BookOverHandler(evt:MouseEvent) : void
      {
         depthLevel.bangongzuo.book_mc.gotoAndStop(2);
      }
      
      private function BookOutHandler(evt:MouseEvent) : void
      {
         depthLevel.bangongzuo.book_mc.gotoAndStop(1);
      }
      
      private function bookClickHandler(evt:MouseEvent) : void
      {
         GV.itemID = 3;
         var itemObj:Object = new Object();
         itemObj.id = 12194;
         itemObj.price = 0;
         itemObj.info = "教師的書本";
         clothBuyModule.buyAction(itemObj);
      }
      
      private function petStudybookHandler(evt:MouseEvent) : void
      {
         var tempMC:MCLoader = null;
         if(!MainManager.getGameLevel().getChildByName("petStudyMC"))
         {
            this.petStudyMC = new MovieClip();
            this.petStudyMC.name = "petStudyMC";
            MainManager.getGameLevel().addChild(this.petStudyMC);
            tempMC = new MCLoader("module/external/BooksUI/petStudyBook.swf",this.petStudyMC,1,"正在打開拉姆學習手冊......");
            tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.petBookLoadOver);
            tempMC.doLoad();
         }
      }
      
      private function petBookLoadOver(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         this.childMC = evt.getLoader();
         mainMC.addChild(this.childMC);
         this.petStudyBookUI = this.childMC.content.root["main"];
         GV.onlineSocket.addEventListener("removeGuideHandler",this.removePetStudyHandler);
         var mcloader:MCLoader = evt.target as MCLoader;
         mcloader.removeEventListener(MCLoadEvent.ON_SUCCESS,this.petBookLoadOver);
         mcloader.clear();
      }
      
      private function removePetStudyHandler(evt:Event = null) : void
      {
         GC.clearAllChildren(this.petStudyBookUI);
         this.petStudyMC.parent.removeChild(this.petStudyMC);
         this.petStudyMC = null;
         GV.onlineSocket.removeEventListener("removeGuideHandler",this.removePetStudyHandler);
      }
      
      private function InitLearningMachine() : void
      {
         var box_mc:MovieClip = controlLevel["box_mc"];
         tip.tipTailDisPlayObject(box_mc,"學習機");
         box_mc.buttonMode = true;
         BC.addEvent(this,box_mc,MouseEvent.CLICK,this.LoadLearningMachine);
      }
      
      private function LoadLearningMachine(e:MouseEvent) : void
      {
         var loadGame:LoadGame = new LoadGame("resource/movie/opengGameMC.swf","正在打開面板.....",MainManager.getAppLevel());
         loadGame = null;
      }
      
      override public function destroy() : void
      {
         SystemEventManager.removeEventListener("questionOver",this.firequestionOver);
         SystemEventManager.removeEventListener("letterTaskOver",this.hLetterTaskOver);
         SystemEventManager.removeEventListener("getMoonCakePrize",this.onEnterSeat);
         SystemEventManager.removeEventListener("openSearchGame",this.openSearchGame);
         GV.onlineSocket.removeEventListener("sendData",this.sendData);
         if(this.petStudyMC != null)
         {
            this.removePetStudyHandler();
         }
         SystemEventManager.removeEventListener("putao_class",this.onPutaoClass);
         SystemEventManager.removeEventListener("putao_Work",this.onPutaoWork);
         SystemEventManager.removeEventListener("musicLesson",this.musicLesson);
         GV.onlineSocket.removeEventListener("fireAction_suc",this.petFileHanlder);
         SystemEventManager.removeEventListener("beginGame",this.onEnterSeat);
         SystemEventManager.removeEventListener("npcTalk",this.onNpcTalk);
         super.destroy();
      }
   }
}

