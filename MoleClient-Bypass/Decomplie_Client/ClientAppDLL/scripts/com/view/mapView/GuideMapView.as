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
   import com.global.links.Links;
   import com.logic.socket.PageSandMsg.sandMsgReq;
   import com.logic.socket.PageSandMsg.sandMsgRes;
   import com.logic.socket.gride.GridePatrolTaskProtocol;
   import com.logic.socket.smc.ListItem.getSMCLevelReq;
   import com.logic.socket.task.TaskOverProtocol;
   import com.module.activityModule.giftModule;
   import com.module.activityModule.superPetLogin;
   import com.module.clothBuyModule.clothBuyModule;
   import com.module.deal.Deal;
   import com.module.npc.dialog.TalkEvent;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.module.AppModuleControl;
   import com.mole.app.module.ModuleEvent;
   import com.mole.app.task.Task;
   import com.mole.app.task.TaskManager;
   import com.mole.app.type.ModuleType;
   import com.mole.app.utils.GetItem;
   import com.mole.app.utils.PlayMovie;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class GuideMapView extends MapBase
   {
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var Paper_mc:MovieClip;
      
      public var guide_mc:MovieClip;
      
      private var loadObj:MCLoader;
      
      private var testLoadObj:MCLoader;
      
      private var lilyMC:MovieClip;
      
      private var childMC:*;
      
      private var testChildMC:*;
      
      private var guideTestMC:MovieClip;
      
      public var buttonLev:MovieClip;
      
      public var eatMC:MovieClip;
      
      public var saleMC:MovieClip;
      
      private var moguMcLoad:Loader;
      
      private var thisMc:MovieClip;
      
      private var _movie2:PlayMovie;
      
      public function GuideMapView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.buttonLev = GV.MC_mapFrame["buttonLevel"];
         this.target_mc.room_mc.btn.addEventListener(MouseEvent.MOUSE_OVER,this.roomOverHandler);
         this.target_mc.room_mc.btn.addEventListener(MouseEvent.MOUSE_OUT,this.roomOutHandler);
         this.target_mc.paper_btn.buttonMode = true;
         this.target_mc.paper_btn.addEventListener(MouseEvent.CLICK,this.paperShowHandler);
         this.target_mc.paper_btn.addEventListener(MouseEvent.MOUSE_OVER,this.paperOverHandler);
         this.target_mc.paper_btn.addEventListener(MouseEvent.MOUSE_OUT,this.paperOutHandler);
         this.target_mc.newsPaper.addEventListener(MouseEvent.CLICK,this.showNewPaperHandler);
         this.target_mc.hotRushBtn.addEventListener(MouseEvent.CLICK,this.hotRushBtnHandler);
         this.target_mc.jmg_mc.addEventListener(MouseEvent.CLICK,this.getjmg_Handler);
         tip.tipTailDisPlayObject(this.target_mc.jmg_mc,"領取金蘑菇嚮導徽章");
         tip.tipTailDisPlayObject(this.target_mc.deskMC,"領取愛心嚮導桌");
         this.target_mc.test_btn.addEventListener(MouseEvent.CLICK,this.testGuideHandler);
         this.target_mc.sale_btn.addEventListener(MouseEvent.CLICK,this.showSaleHandler);
         this.target_mc.deskMC.addEventListener(MouseEvent.CLICK,this.drawDeskHandler);
         this.initMoguMC();
         BC.addEvent(this,TalkEvent,"jesse_joinSMCJesse",function(E:*):*
         {
            buttonLev.Jesse_npc.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         });
         BC.addEvent(this,this.target_mc["exchange_btn"],MouseEvent.CLICK,function(e:MouseEvent):void
         {
            ModuleManager.openPanel(ModuleType.MOLE_GRIDE_EXCHANGE_PANEL);
         });
         GV.onlineSocket.addEventListener("openMoleGridePanel",this.onOpenMoleGridePanel);
         GV.onlineSocket.addEventListener("openTopicMC",this.onOpenTopicMC);
         GV.onlineSocket.addEventListener("NPCOldJob",this.onNPCOldJob);
         GV.onlineSocket.addEventListener("OVERNPCOldJob",this.overTaskTip);
      }
      
      private function onNPCOldJob(e:Event) : void
      {
         var _t:MapBase = null;
         var Tasks:Task = null;
         var getItems:GetItem = null;
         var id:uint = 0;
         _t = this;
         Tasks = TaskManager.getTask(id);
         var State:uint = TaskManager.getTaskState(id);
         if(State == 1)
         {
            var _temp_4:* = BC;
            var _temp_3:* = _t;
            var _temp_2:* = getItems;
            var _temp_1:* = GetItem.BACKITEMNUM;
            with({})
            {
               
               _temp_4.addEvent(_temp_3,_temp_2,_temp_1,function getItemNum(e:EventTaomee):void
               {
                  BC.removeEvent(_t,getItems,GetItem.BACKITEMNUM,getItemNum);
                  getItems.destroy();
                  getItems = null;
                  Tasks.taskInfo.goodsNum = e.EventObj.arr;
                  if(e.EventObj.arr.indexOf(0) == -1 && LocalUserInfo.getCharm() >= 20)
                  {
                     Tasks.over();
                     Tasks.checkEnterMap(100000003);
                  }
                  else
                  {
                     Tasks.checkEnterMap(100000002);
                  }
               });
               getItems.itemNum(Tasks.taskInfo.goods);
            }
            else if(State == 0)
            {
               Tasks.checkEnterMap(100000001);
            }
            else if(State == 2)
            {
               Tasks.checkEnterMap(100000004);
            }
         }
         
         public function overTaskTip(evt:Event) : void
         {
            var url:String = GoodsInfo.getItemPathByID(12060) + "12060.swf";
            var msg:String = "    恭喜你獲得嚮導四件套！快穿齊它吧！";
            Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
         }
         
         private function onOpenTopicMC(e:Event) : void
         {
            this._movie2 = PlayMovie.play("resource/newTask/task1/movie/task_movie_1_2.swf",null,null,this.closeMC2,null,null,false);
         }
         
         private function closeMC2() : void
         {
            this._movie2.movie_mc["type_mc"].buttonMode = true;
            BC.addEvent(this,this._movie2.movie_mc["type_mc"],MouseEvent.CLICK,this.typeClickHandler);
         }
         
         private function typeClickHandler(evt:MouseEvent) : void
         {
            BC.removeEvent(this,this._movie2.movie_mc["type_mc"],MouseEvent.CLICK,this.typeClickHandler);
            this._movie2.destroy();
            this._movie2 = null;
            TaskOverProtocol.send(1);
            GridePatrolTaskProtocol.send(0);
            Alert.smileAlart("　　恭喜你獲得一套超級蘑菇套裝、一枚文明勳章!",function(e:*):void
            {
               mapSay(2);
            });
         }
         
         private function onOpenMoleGridePanel(e:Event) : void
         {
            var appControl:AppModuleControl = ModuleManager.openPanel(ModuleType.MOLE_GRIDE_PANEL);
            BC.addOnceEvent(this,appControl,ModuleEvent.DESTROY,this.backHandler);
         }
         
         private function backHandler(evt:ModuleEvent) : void
         {
            var task1:Task = null;
            if(evt.data == 1)
            {
               task1 = TaskManager.getTask(1);
               if(Boolean(task1))
               {
                  task1.setStepAndPanel(2);
                  Alert.smileAlart("   恭喜你，你通過本次考試，找傑西問問吧！");
               }
            }
            else if(evt.data == 2)
            {
               Alert.smileAlart("   很可惜，你沒有通過本次考試，超級蘑菇嚮導需要非常了解摩爾莊園，下次再來試試吧！",function(e:*):void
               {
                  onOpenMoleGridePanel(null);
               });
            }
         }
         
         private function initMoguMC() : void
         {
            this.moguMcLoad = new Loader();
            this.moguMcLoad.unload();
            this.moguMcLoad.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onMoguMcLoad);
            this.moguMcLoad.load(VL.getURLRequest(Links.getUrl("resource/allJob/guideMap/mogoMC.swf")));
         }
         
         private function onMoguMcLoad(evt:Event) : void
         {
            evt.currentTarget.content.moguMc.x = 300;
            evt.currentTarget.content.moguMc.y = 130;
            this.target_mc.addChild(evt.currentTarget.content.moguMc);
            this.thisMc = this.target_mc.getChildByName("moguMc") as MovieClip;
            tip.tipTailDisPlayObject(this.thisMc,"領取嚮導禮物");
            this.thisMc.btn.buttonMode = true;
            this.thisMc.btn.addEventListener(MouseEvent.MOUSE_OVER,this.roomOverHandler);
            this.thisMc.btn.addEventListener(MouseEvent.MOUSE_OUT,this.roomOutHandler);
            this.thisMc.addEventListener(MouseEvent.CLICK,this.moguBuyHandler);
         }
         
         private function getjmg_Handler(event:MouseEvent) : void
         {
            GV.onlineSocket.addEventListener("GET_SMC_LEVEL_SUCC",this.getMyProfession);
            getSMCLevelReq.dosend(GV.MyInfo_userID);
         }
         
         public function getMyProfession(e:EventTaomee) : void
         {
            var num:int;
            var msg:String = null;
            GV.onlineSocket.removeEventListener("GET_SMC_LEVEL_SUCC",this.getMyProfession);
            num = int(e.EventObj.num);
            if(num < 5500)
            {
               msg = "　　穿戴好全套嚮導服務套裝，努力將金蘑菇嚮導升到頂級，就可以領取金蘑菇嚮導徽章啦！";
               Alert.smileAlart(msg,null,"ok",108);
               return;
            }
            Deal.BuyItem(160172,1,function(... E):void
            {
               Alert.getIconByID_Alart(160172,"　　恭喜你！金蘑菇嚮導徽章已放入你的倉庫中。");
            },function(... E):void
            {
               Alert.smileAlart("　　你已經領取過金蘑菇嚮導徽章啦！");
            });
         }
         
         private function hotRushBtnHandler(event:MouseEvent) : void
         {
            superPetLogin.gotoHotRush();
         }
         
         private function showSaleHandler(evt:MouseEvent) : void
         {
            var tempMC:Class = null;
            if(!MainManager.getAppLevel().getChildByName("saleMC"))
            {
               tempMC = GV.Lib_Map.getClass("saleMC") as Class;
               this.saleMC = new tempMC();
               this.saleMC.name = "saleMC";
               MainManager.getAppLevel().addChild(this.saleMC);
               this.saleMC.x = (MainManager.getStageWidth() - this.saleMC.width) / 2;
               this.saleMC.y = (MainManager.getStageHeight() - this.saleMC.height) / 2;
               this.saleMC.close_btn.addEventListener(MouseEvent.CLICK,this.saleremoveHandler);
            }
         }
         
         private function saleremoveHandler(evt:MouseEvent = null) : void
         {
            this.saleMC.close_btn.removeEventListener(MouseEvent.CLICK,this.saleremoveHandler);
            GC.stopAllMC(this.saleMC);
            GC.clearChildren(this.saleMC);
            this.saleMC.parent.removeChild(this.saleMC);
            this.saleMC = null;
         }
         
         private function testGuideHandler(evt:MouseEvent) : void
         {
            var url:String = null;
            if(!GV.MC_AppLever.getChildByName("guideTestMC"))
            {
               this.guideTestMC = new MovieClip();
               this.guideTestMC.name = "guideTestMC";
               GV.MC_AppLever.addChild(this.guideTestMC);
               url = "module/external/Guide.swf";
               this.testLoadObj = new MCLoader(url,this.guideTestMC,1,"正在打開嚮導測試......");
               this.testLoadObj.addEventListener(MCLoadEvent.ON_SUCCESS,this.guideTestLoadOver);
               this.testLoadObj.doLoad();
            }
         }
         
         private function guideTestLoadOver(evt:MCLoadEvent) : void
         {
            var mainMC:DisplayObjectContainer = evt.getParent();
            this.testChildMC = evt.getLoader();
            mainMC.addChild(this.testChildMC);
            this.testLoadObj.removeEventListener(MCLoadEvent.ON_SUCCESS,this.guideTestLoadOver);
            this.testLoadObj.clear();
         }
         
         private function lilyClickHandler(evt:MouseEvent) : void
         {
            var tempMC:Class = null;
            if(!GV.MC_AppLever.getChildByName("lilyMC"))
            {
               tempMC = GV.Lib_Map.getClass("lilyClass") as Class;
               this.lilyMC = new tempMC();
               this.lilyMC.name = "lilyMC";
               GV.MC_AppLever.addChild(this.lilyMC);
               this.lilyMC.x = (GV.MC_AppLever.stage.stageWidth - this.lilyMC.width) / 2;
               this.lilyMC.y = (GV.MC_AppLever.stage.stageHeight - this.lilyMC.height) / 2;
               this.lilyMC.closeBtn.addEventListener(MouseEvent.CLICK,this.removelilyHandler);
               this.lilyMC.sendBtn.addEventListener(MouseEvent.CLICK,this.lilySendHandler);
            }
         }
         
         private function lilySendHandler(evt:MouseEvent) : void
         {
            var myAle:* = undefined;
            if(!GV.MC_AppLever.getChildByName("changAlert_sandUIMC"))
            {
               myAle = Alert.showAlert(GV.MC_AppLever,"郵箱","",Alert.CHANG_ALERT,"sandmsg",true,true,"sandUI","400,300");
               myAle.addEventListener(Alert.CLICK_ + "1",this.next);
            }
         }
         
         private function next(e:*) : void
         {
            var myAle:* = undefined;
            var info:String = null;
            e.target.removeEventListener(Alert.CLICK_ + "1",this.next);
            var pp:sandMsgReq = new sandMsgReq();
            var sandType:int = 1011;
            var msg:* = Alert.back_msg;
            var tit:* = Alert.back_tit;
            if(msg != "" && tit != "")
            {
               pp.sandFun(sandType,tit,msg);
               GV.onlineSocket.addEventListener(sandMsgRes.PAGESANDBACK_SUCCESS,this.showsandTit);
            }
            else
            {
               info = "一定要填寫標題和內容才可以哦~";
               myAle = Alert.showAlert(GV.MC_AppLever,info,"",Alert.CHANG_ALERT,"sure",true,false,"F");
            }
         }
         
         private function showsandTit(e:*) : void
         {
            var myAle:* = undefined;
            GV.onlineSocket.removeEventListener(sandMsgRes.PAGESANDBACK_SUCCESS,this.showsandTit);
            var info:String = "太好了！投稿成功\r摩爾莊園管理處感謝您的參與";
            myAle = Alert.showAlert(GV.MC_AppLever,info,"",Alert.CHANG_ALERT,"sure",true,false,"F");
         }
         
         private function removelilyHandler(evt:MouseEvent) : void
         {
            this.lilyMC.sendBtn.removeEventListener(MouseEvent.CLICK,this.lilySendHandler);
            this.lilyMC.closeBtn.removeEventListener(MouseEvent.CLICK,this.removelilyHandler);
            GC.stopAllMC(this.lilyMC);
            GC.clearChildren(this.lilyMC);
            this.lilyMC.parent.removeChild(this.lilyMC);
            this.lilyMC = null;
         }
         
         private function paperShowHandler(evt:MouseEvent) : void
         {
            var url:String = null;
            if(!MainManager.getAppLevel().getChildByName("guide_mc"))
            {
               this.guide_mc = new MovieClip();
               this.guide_mc.name = "guide_mc";
               MainManager.getAppLevel().addChild(this.guide_mc);
               url = "module/external/BooksUI/guideBook.swf";
               this.loadObj = new MCLoader(url,this.guide_mc,1,"正在打開嚮導手冊......");
               this.loadObj.addEventListener(MCLoadEvent.ON_SUCCESS,this.guideBookLoadOver);
               this.loadObj.doLoad();
            }
         }
         
         private function guideBookLoadOver(evt:MCLoadEvent) : void
         {
            var mainMC:DisplayObjectContainer = evt.getParent();
            this.childMC = evt.getLoader();
            mainMC.addChild(this.childMC);
            GV.onlineSocket.addEventListener("removeGuideHandler",this.removeGuideHandler);
            this.loadObj.removeEventListener(MCLoadEvent.ON_SUCCESS,this.guideBookLoadOver);
            this.loadObj.clear();
         }
         
         private function removeGuideHandler(evt:Event = null) : void
         {
            var main:MovieClip = this.childMC.content.root["main"];
            GC.clearAllChildren(main);
            this.guide_mc.parent.removeChild(this.guide_mc);
            this.guide_mc = null;
            GV.onlineSocket.removeEventListener("removeGuideHandler",this.removeGuideHandler);
         }
         
         private function showNewPaperHandler(evt:MouseEvent) : void
         {
            var tempMC:Class = null;
            if(!GV.MC_AppLever.getChildByName("PaperMC"))
            {
               tempMC = GV.Lib_Map.getClass("Paper_mc") as Class;
               this.Paper_mc = new tempMC();
               this.Paper_mc.name = "PaperMC";
               GV.MC_AppLever.addChild(this.Paper_mc);
               this.Paper_mc.x = (GV.MC_AppLever.stage.stageWidth - this.Paper_mc.width) / 2;
               this.Paper_mc.y = (GV.MC_AppLever.stage.stageHeight - this.Paper_mc.height) / 2;
               this.Paper_mc.closeBtn.addEventListener(MouseEvent.CLICK,this.removePaperHandler);
            }
         }
         
         private function removePaperHandler(evt:MouseEvent = null) : void
         {
            this.Paper_mc.closeBtn.removeEventListener(MouseEvent.CLICK,this.removePaperHandler);
            GC.clearAllChildren(this.Paper_mc);
            this.Paper_mc.parent.removeChild(this.Paper_mc);
            this.Paper_mc = null;
         }
         
         private function roomOverHandler(evt:MouseEvent) : void
         {
            evt.currentTarget.parent.gotoAndStop(2);
         }
         
         private function roomOutHandler(evt:MouseEvent) : void
         {
            evt.currentTarget.parent.gotoAndStop(1);
         }
         
         private function paperOverHandler(evt:MouseEvent) : void
         {
            evt.currentTarget.gotoAndPlay(2);
         }
         
         private function paperOutHandler(evt:MouseEvent) : void
         {
            evt.currentTarget.gotoAndStop(1);
         }
         
         private function drawDeskHandler(evt:MouseEvent) : void
         {
            var msg:String = null;
            if(!this.checkCloth())
            {
               msg = "　　親愛的嚮導，你需要穿上嚮導服才能領禮物";
               GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
               return;
            }
            GV.itemID = 3;
            var itemObj:Object = new Object();
            itemObj.id = 12326;
            itemObj.price = 0;
            itemObj.info = "桌子";
            clothBuyModule.buyAction(itemObj);
         }
         
         private function moguBuyHandler(evt:MouseEvent) : void
         {
            var msg:String = null;
            if(!this.checkCloth())
            {
               msg = "　　親愛的嚮導，你需要穿上嚮導服才能打開箱子";
               GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
               return;
            }
            this.ItemGiveHandler();
         }
         
         private function checkCloth() : Boolean
         {
            if(Boolean(GV.JobLogics.chartbagClothFun([[12060,12061,12062,12063]])))
            {
               return true;
            }
            return false;
         }
         
         private function ItemGiveHandler() : void
         {
            giftModule.giftHandlerNew(3);
         }
         
         override public function destroy() : void
         {
            if(this.Paper_mc != null)
            {
               this.removePaperHandler();
            }
            if(this.guide_mc != null)
            {
               this.removeGuideHandler();
            }
            if(this.saleMC != null)
            {
               this.saleremoveHandler();
            }
            GV.onlineSocket.removeEventListener(sandMsgRes.PAGESANDBACK_SUCCESS,this.showsandTit);
            this.thisMc.btn.removeEventListener(MouseEvent.MOUSE_OVER,this.roomOverHandler);
            this.thisMc.btn.removeEventListener(MouseEvent.MOUSE_OUT,this.roomOutHandler);
            this.thisMc.removeEventListener(MouseEvent.CLICK,this.moguBuyHandler);
            this.thisMc = null;
            this.moguMcLoad = null;
            this.target_mc.room_mc.btn.removeEventListener(MouseEvent.MOUSE_OVER,this.roomOverHandler);
            this.target_mc.room_mc.btn.removeEventListener(MouseEvent.MOUSE_OUT,this.roomOutHandler);
            this.target_mc.paper_btn.removeEventListener(MouseEvent.CLICK,this.paperShowHandler);
            this.target_mc.hotRushBtn.removeEventListener(MouseEvent.CLICK,this.hotRushBtnHandler);
            this.target_mc.paper_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.paperOverHandler);
            this.target_mc.paper_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.paperOutHandler);
            this.target_mc.newsPaper.removeEventListener(MouseEvent.CLICK,this.showNewPaperHandler);
            this.testChildMC = null;
            this.childMC = null;
            this.target_mc = null;
            this.depth_mc = null;
            GV.onlineSocket.removeEventListener("openMoleGridePanel",this.onOpenMoleGridePanel);
            GV.onlineSocket.removeEventListener("openTopicMC",this.onOpenTopicMC);
            GV.onlineSocket.removeEventListener("JesseNPCOldJob",this.onNPCOldJob);
            GV.onlineSocket.removeEventListener("OVERNPCOldJob",this.overTaskTip);
            super.destroy();
         }
      }
   }
   
   