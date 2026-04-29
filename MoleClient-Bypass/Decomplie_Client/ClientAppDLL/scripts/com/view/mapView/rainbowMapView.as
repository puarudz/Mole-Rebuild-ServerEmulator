package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.core.field.animalInfo.AnimalInfo;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.socket.farm.farmSocket;
   import com.logic.socket.moleAction.moleActionReq;
   import com.logic.socket.moleAction.moleActionRes;
   import com.logic.socket.presentGoods.PresentGoodsReq;
   import com.logic.socket.presentGoods.PresentGoodsRes;
   import com.logic.socket.randomItemLogic.randomItemReq;
   import com.logic.socket.randomItemLogic.randomItemRes;
   import com.logic.socket.traffic.trafficReq;
   import com.logic.socket.traffic.trafficRes;
   import com.module.activityModule.Presented;
   import com.module.clothBuyModule.clothBuyModule;
   import com.module.duck.BlackLahm;
   import com.module.farm.IAnimal_Follow;
   import com.module.helpPanel.HelpPanel;
   import com.module.throwThing.throwHitTest;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.NewStatisticsManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.view.PeopleView.PeopleManageView;
   import com.view.mapView.activity.BackToYouthMapManager;
   import com.view.mapView.activity.creatShareObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.utils.Timer;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class rainbowMapView extends MapBase
   {
      
      private static var isOverTask550:Boolean;
      
      public var top_mc:MovieClip;
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var effect_bg:MovieClip;
      
      public var button_mc:MovieClip;
      
      private var loadMC:MovieClip;
      
      private var infoClass:MCLoader;
      
      private var btnClass:*;
      
      private var GameTip:MovieClip;
      
      private var moleAction:moleActionReq;
      
      private var newTipMC:MovieClip;
      
      private var danceMusic:Sound;
      
      private var musicHand:SoundChannel;
      
      private var timer_num:Timer;
      
      private var petMC_arr:Array = [];
      
      private var Now_IP:uint = 0;
      
      private var pet_timer:Timer;
      
      private var temp_mc:MovieClip;
      
      private var sprite:Sprite;
      
      private var tarX:Number;
      
      private var tarY:Number;
      
      private var hitBool:Boolean;
      
      private var hitNum:int;
      
      private var eatCaoID:int;
      
      private var treeBool:Boolean;
      
      private var _isHaveGoddess:uint;
      
      private var _interval:uint;
      
      public function rainbowMapView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         var i:int = 0;
         var ap:BlackLahm = null;
         BackToYouthMapManager.instence.initView(controlLevel["npc_mc"]);
         this.top_mc = GV.MC_mapFrame["top_mc"];
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.effect_bg = GV.MC_mapFrame["effect_bg"];
         this.button_mc = GV.MC_mapFrame["buttonLevel"];
         this.target_mc.rainbow_mc.visible = false;
         GV.onlineSocket.addEventListener("move_for_game",this.loadGameHandler);
         GV.onlineSocket.addEventListener(trafficRes.TRAFFIC_OVER,this.rainBowHandler);
         trafficReq.trafficSend(6);
         trafficReq.trafficSend(7);
         GV.onlineSocket.addEventListener(randomItemRes.RANMOM_ITEM,this.activeHandler);
         randomItemReq.randomItemReqAction();
         for(i = 0; i < 2; i++)
         {
            this.target_mc.activMC["mc_" + i].mc.visible = false;
         }
         this.target_mc.lotus_mc_1.buttonMode = true;
         this.target_mc.lotus_mc_1.addEventListener(MouseEvent.CLICK,this.lotusGiveHandler);
         this.target_mc.mapBtn_2.addEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
         this.target_mc.mapBtn_2.addEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
         this.target_mc.btn_piaoliu.addEventListener(MouseEvent.CLICK,this.showGameTip);
         this.target_mc.lotusbtn_1.buttonMode = true;
         this.target_mc.lotusbtn_2.buttonMode = true;
         this.target_mc.lotusbtn_1.addEventListener(MouseEvent.CLICK,this.showLotusHandler);
         this.target_mc.lotusbtn_2.addEventListener(MouseEvent.CLICK,this.showLotusHandler);
         GV.onlineSocket.addEventListener(moleActionRes.MOLE_SLIDE,this.lotusCopyEvent);
         this.target_mc.tipBtn_new.buttonMode = true;
         this.target_mc.tipBtn_new.addEventListener(MouseEvent.CLICK,this.newTipHandler);
         this.target_mc.showTipBtn.visible = true;
         if(GV.MAN_PEOPLE.Petlevel == 101)
         {
            this.target_mc.rainbow_mc.visible = true;
            this.target_mc.mask_mc.x = -1000;
            this.target_mc.showTipBtn.visible = false;
         }
         else
         {
            tip.tipTailDisPlayObject(this.target_mc.showTipBtn,"進入力量之泉");
         }
         this.target_mc.showTipBtn.addEventListener(MouseEvent.CLICK,this.showErrorEvent);
         this.target_mc.blackCage.buttonMode = false;
         var obj0:Object = {
            "btn":this.target_mc.blackCage,
            "mc":this.target_mc.blackCage,
            "id":"swf150002",
            "fre":1,
            "hide":true
         };
         BC.addEvent(this,GV.onlineSocket,throwHitTest.HITTEST_SUC,this.hitItemFun);
         throwHitTest.HitTestMC(obj0);
         for(var p:uint = 1; p < 6; p++)
         {
            this.top_mc["petMC_" + p].buttonMode = true;
            ap = new BlackLahm(this.top_mc["petMC_" + p]);
            this.petMC_arr.push(ap);
         }
         BC.addEvent(this,this.target_mc.tipsBtn,MouseEvent.CLICK,this.showTisEvent);
         this.initGetSeed();
         this.target_mc["tomato_btn"].buttonMode = true;
         this.target_mc["tomato_btn"].id = 150002;
         this.target_mc["tomato_btn"].Price = 15;
         this.target_mc["tomato_btn"].clientName = "番茄";
         this.target_mc["tomato_btn"].addEventListener(MouseEvent.CLICK,this.tomatoBuyHandler);
      }
      
      private function bubbles() : void
      {
         var id:uint = Math.random() * 5 + 1;
         trace("id===================================" + id);
         var obj:MovieClip = this.top_mc["petMC_" + id];
         var tip:MovieClip = obj["tips"];
         tip.gotoAndPlay(2);
      }
      
      private function tomatoClick(evt:SystemEvent) : void
      {
         SystemEventManager.removeEventListener("tomatoClick",this.tomatoClick);
         trace("tomato");
      }
      
      private function tomatoBuyHandler(evt:MouseEvent = null) : void
      {
         var itemObj:Object = new Object();
         itemObj.id = evt.currentTarget.id;
         itemObj.price = evt.currentTarget.Price;
         itemObj.info = evt.currentTarget.clientName;
         clothBuyModule.buyAction(itemObj,false);
      }
      
      private function initBlackart() : void
      {
         if(creatShareObject.getInstance().get42ch() == 0)
         {
            this.target_mc.blackart_btn.addEventListener(MouseEvent.MOUSE_DOWN,this.blackartBtnHandler);
         }
         else
         {
            this.target_mc.blackart_btn.x = 1200;
            this.target_mc.blackart_btn.visible = false;
            this.hitNum = 5;
            this.hitMCPlay();
         }
         this.target_mc.blackart_btn.buttonMode = true;
         this.target_mc.tree_mc.btn.addEventListener(MouseEvent.CLICK,this.treeHandler);
      }
      
      private function treeHandler(event:MouseEvent) : void
      {
         var msg:String = null;
         var url:String = null;
         var myAle:* = undefined;
         if(this.treeBool)
         {
            msg = "     喔喔~魔法能量球真是太厲害啦，不但幫我恢復了生機，還把我變成了魔法樹！" + "看，我都結出美味的魔魔球啦。還有，愛心魔魔球食譜就藏在我身上，趕快找找吧！";
            url = "resource/allJob/AlertPic/bodhi/42_03.swf";
            myAle = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
         }
         else
         {
            if(GV.MAN_PEOPLE.Petlevel < 1)
            {
               msg = "     帶著你的小拉姆一起來尋找愛心魔魔球的食譜吧！";
               url = "resource/allJob/AlertPic/bodhi/42_01.swf";
               Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"iknow",true,false,"EMP_BUY");
               return;
            }
            msg = "    我是大樹伯伯，我的葉子開始枯黃了，你願意幫我找到魔法能量球，讓我恢復往日的生機嗎？";
            url = "resource/allJob/AlertPic/bodhi/42_02.swf";
            myAle = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"npcgo,notgo",true,false,"SMCUI");
         }
      }
      
      private function blackartBtnHandler(event:MouseEvent) : void
      {
         var msg:String = null;
         var url:String = null;
         var myAle:* = undefined;
         if(GV.MAN_PEOPLE.Petlevel < 1)
         {
            msg = "     帶著你的小拉姆一起來尋找愛心魔魔球的食譜吧！";
            url = "resource/allJob/AlertPic/bodhi/42_01.swf";
            Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"iknow",true,false,"EMP_BUY");
            return;
         }
         msg = "     我是木精靈的魔法能量球，我的魔法能力可以幫助生病的大樹伯伯，趕快把我拖到發黃的葉子上吧！";
         url = "resource/allJob/AlertPic/bodhi/42_04.swf";
         myAle = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
         myAle.addEventListener(Alert.CLICK_ + "1",this.getItemEvent);
      }
      
      private function getItemEvent(event:*) : void
      {
         this.target_mc.blackart_btn.visible = false;
         this.target_mc.blackart_mc.visible = true;
         this.sprite = this.target_mc.blackart_mc;
         this.target_mc.blackart_mc.addEventListener(MouseEvent.CLICK,this.shovelMCDownHandler);
         this.target_mc.blackart_mc.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.shovelMcMoveHandler);
      }
      
      private function shovelMcMoveHandler(event:MouseEvent) : void
      {
         this.sprite.x = event.stageX;
         this.sprite.y = event.stageY;
      }
      
      private function shovelMCDownHandler(event:MouseEvent) : void
      {
         this.hitNum = 0;
         for(var i:uint = 0; i < 5; i++)
         {
            if(Boolean(this.target_mc.tree_mc["hit_mc" + i].hitTestPoint(event.stageX,event.stageY,true)))
            {
               this.target_mc.tree_mc["hit_mc" + i].gotoAndStop(2);
            }
            if(this.target_mc.tree_mc["hit_mc" + i].currentFrame == 2)
            {
               ++this.hitNum;
            }
         }
         this.hitMCPlay();
      }
      
      private function hitMCPlay() : void
      {
         var i:int = 0;
         if(this.hitNum == 5)
         {
            creatShareObject.getInstance().set42ch(1);
            this.treeBool = true;
            this.target_mc.blackart_mc.visible = false;
            this.target_mc.blackart_mc.removeEventListener(MouseEvent.CLICK,this.shovelMCDownHandler);
            this.target_mc.blackart_mc.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.shovelMcMoveHandler);
            this.target_mc.tree_mc.gotoAndStop(3);
            for(i = 0; i < 7; i++)
            {
               this.target_mc.tree_mc["ball_mc" + i].visible = true;
               this.target_mc.tree_mc["ball_mc" + i].buttonMode = true;
               this.target_mc.tree_mc["ball_mc" + i].addEventListener(MouseEvent.CLICK,this.hitMCHandler);
            }
            this.target_mc.tree_mc.leafage_btn.visible = true;
            this.target_mc.tree_mc.leafage_btn.addEventListener(MouseEvent.CLICK,this.leafageHandler);
         }
      }
      
      private function leafageHandler(event:MouseEvent) : void
      {
         HelpPanel.getInstance().panelVisible("TIPS_MC");
      }
      
      private function hitMCHandler(event:MouseEvent) : void
      {
         event.currentTarget.visible = false;
         Presented.getInstance().FreeReceive(12);
      }
      
      private function showTisEvent(eve:MouseEvent) : void
      {
         if(!Boolean(MainManager.getGameLevel().getChildByName("hleptipsMC")))
         {
            HelpPanel.getInstance().panelVisible("tipsMC");
         }
      }
      
      private function hitItemFun(eve:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,throwHitTest.HITTEST_SUC,this.hitItemFun);
         NewStatisticsManager.send(596);
         this.Now_IP = uint(Math.random() * this.petMC_arr.length);
         if(this.petMC_arr.length == 0)
         {
            return;
         }
         this.temp_mc = this.petMC_arr[this.Now_IP].getMC();
         this.temp_mc.buttonMode = false;
         this.temp_mc.gotoAndStop(2);
         BC.addEvent(this,GV.onlineSocket,BlackLahm.Black_Lahm_Hit_Mole,this.hitBlackCage);
         this.petMC_arr[this.Now_IP].beginMoveMC(570,210);
      }
      
      private function hitBlackCage(eve:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,BlackLahm.Black_Lahm_Hit_Mole,this.hitBlackCage);
         BC.addEvent(this,this.target_mc.blackCage,MouseEvent.CLICK,this.hitOnePet);
         this.target_mc.blackCage.buttonMode = true;
         var timerNum:uint = uint(Math.random() * 3 + 1) * 1000;
         this.pet_timer = GC.setGTimeout(this.goBackPet,timerNum);
         if(Boolean(this.temp_mc))
         {
            this.temp_mc.gotoAndStop(25);
         }
      }
      
      private function hitOnePet(eve:MouseEvent) : void
      {
         var app:Timer = null;
         BC.removeEvent(this,this.target_mc.blackCage,MouseEvent.CLICK,this.hitOnePet);
         this.target_mc.blackCage.buttonMode = false;
         GC.clearGTimeout(this.pet_timer);
         this.pet_timer = null;
         this.temp_mc.visible = false;
         this.temp_mc = null;
         this.petMC_arr.splice(this.Now_IP,1);
         this.Now_IP = 0;
         this.target_mc.blackCage.gotoAndPlay(3);
         var _temp_2:* = §§newactivation();
         var _temp_1:* = GC;
         with({})
         {
            app = _temp_1.setGTimeout(function getPetF():void
            {
               GC.clearGTimeout(app);
               Presented.getInstance().FreeReceive(10);
            },2000);
         }
         
         private function goBackPet() : void
         {
            BC.removeEvent(this,this.target_mc.blackCage,MouseEvent.CLICK,this.hitOnePet);
            this.target_mc.blackCage.buttonMode = false;
            if(Boolean(this.temp_mc))
            {
               this.temp_mc.buttonMode = true;
            }
            GC.clearGTimeout(this.pet_timer);
            this.pet_timer = null;
            BC.addEvent(this,GV.onlineSocket,BlackLahm.Black_Lahm_Hit_Mole,this.hitBlackCageT);
            this.petMC_arr[this.Now_IP].beginMoveMC(400 + Math.random() * 300,300 + Math.random() * 50);
         }
         
         private function hitBlackCageT(eve:Event) : void
         {
            BC.removeEvent(this,GV.onlineSocket,BlackLahm.Black_Lahm_Hit_Mole,this.hitBlackCageT);
            this.temp_mc.gotoAndStop(23 + uint(Math.random() * 6));
            this.temp_mc = null;
            this.Now_IP = 0;
            BC.addEvent(this,GV.onlineSocket,throwHitTest.HITTEST_SUC,this.hitItemFun);
         }
         
         private function showErrorEvent(evt:MouseEvent) : void
         {
            GV.onlineSocket.dispatchEvent(new Event("move_for_game"));
         }
         
         private function newTipHandler(evt:MouseEvent) : void
         {
            var tempMC:Class = null;
            if(!GV.MC_AppLever.getChildByName("newTipMC"))
            {
               tempMC = GV.Lib_Map.getClass("MfmTip") as Class;
               this.newTipMC = new tempMC();
               GV.MC_AppLever.addChild(this.newTipMC);
               this.newTipMC.x = (GV.MC_AppLever.stage.stageWidth - this.newTipMC.width) / 2;
               this.newTipMC.y = (GV.MC_AppLever.stage.stageHeight - this.newTipMC.height) / 2;
               this.newTipMC.closeBtn.addEventListener(MouseEvent.CLICK,this.removeNewTipMCHandler);
            }
         }
         
         private function removeNewTipMCHandler(evt:MouseEvent = null) : void
         {
            this.newTipMC.closeBtn.removeEventListener(MouseEvent.CLICK,this.removeNewTipMCHandler);
            GC.clearAllChildren(this.newTipMC);
            this.newTipMC.parent.removeChild(this.newTipMC);
            this.newTipMC = null;
         }
         
         private function showLotusHandler(evt:MouseEvent = null) : void
         {
            this.target_mc.lotusbtn_1.buttonMode = false;
            this.target_mc.lotusbtn_2.buttonMode = false;
            this.target_mc.lotusbtn_1.removeEventListener(MouseEvent.CLICK,this.showLotusHandler);
            this.target_mc.lotusbtn_2.removeEventListener(MouseEvent.CLICK,this.showLotusHandler);
            var msg:String = "你要放河燈吧?\n";
            this.btnClass = GF.showAlert(GV.MC_AppLever,msg,"",6,"E");
            this.btnClass.addEventListener("CLICK" + 1,this.copyLotusHandler);
         }
         
         private function copyLotusHandler(evt:*) : void
         {
            if(this.moleAction == null)
            {
               this.moleAction = new moleActionReq();
            }
            this.moleAction.sendAction(10);
         }
         
         private function lotusCopyEvent(evt:EventTaomee) : void
         {
            var tempMC:Class = null;
            var lotusMC:MovieClip = null;
            var tempX:Number = NaN;
            var tempY:Number = NaN;
            if(evt.EventObj.Action == 10)
            {
               tempMC = GV.Lib_Map.getClass("lotusClass") as Class;
               lotusMC = new tempMC();
               this.target_mc.copyMC.addChild(lotusMC);
               tempX = Math.floor(Math.random() * 450);
               tempY = Math.floor(Math.random() * 40);
               lotusMC.x += tempX;
               lotusMC.y += tempY;
            }
         }
         
         private function showGameTip(evt:MouseEvent) : void
         {
            var tempMC:Class = null;
            if(!GV.MC_AppLever.getChildByName("GameTip"))
            {
               tempMC = GV.Lib_Map.getClass("GameTip");
               this.GameTip = new tempMC();
               this.GameTip.name = "GameTip";
               GV.MC_AppLever.addChild(this.GameTip);
               this.GameTip.x = (GV.MC_AppLever.stage.stageWidth - this.GameTip.width) / 2;
               this.GameTip.y = (GV.MC_AppLever.stage.stageHeight - this.GameTip.height) / 2;
               this.GameTip.closeBtn.addEventListener(MouseEvent.CLICK,this.removeTipHandler);
               this.GameTip.btn.addEventListener(MouseEvent.CLICK,this.gotoHandler);
            }
         }
         
         private function gotoHandler(evt:MouseEvent) : void
         {
            if(this.GameTip.currentFrame == 1)
            {
               this.GameTip.gotoAndStop(2);
               this.GameTip.btn.gotoAndStop(2);
            }
            else
            {
               this.GameTip.gotoAndStop(1);
               this.GameTip.btn.gotoAndStop(1);
            }
         }
         
         private function removeTipHandler(evt:MouseEvent = null) : void
         {
            this.GameTip.btn.removeEventListener(MouseEvent.CLICK,this.gotoHandler);
            this.GameTip.closeBtn.removeEventListener(MouseEvent.CLICK,this.removeTipHandler);
            GC.clearAllChildren(this.GameTip);
            this.GameTip.parent.removeChild(this.GameTip);
            this.GameTip = null;
         }
         
         private function overHandler(evt:MouseEvent) : void
         {
            this.target_mc.room_mc.gotoAndStop(2);
         }
         
         private function outHandler(evt:MouseEvent) : void
         {
            this.target_mc.room_mc.gotoAndStop(1);
         }
         
         private function lotusGiveHandler(evt:MouseEvent) : void
         {
            GV.itemID = 3;
            var itemObj:Object = new Object();
            itemObj.id = 12118;
            itemObj.price = 0;
            itemObj.info = "小荷葉傘";
            clothBuyModule.buyAction(itemObj);
         }
         
         private function rainBowHandler(evt:EventTaomee) : void
         {
            var type:int = int(evt.EventObj.type);
            var status:int = int(evt.EventObj.Status);
            if(type == 6)
            {
               if(status == 0)
               {
                  this.target_mc.rainbow_mc.visible = false;
               }
               else
               {
                  this.target_mc.rainbow_mc.visible = true;
               }
            }
         }
         
         private function activeHandler(evt:EventTaomee) : void
         {
            var tempArray:Array = null;
            var j:int = 0;
            var num:int = 0;
            var tempNum:int = 0;
            for(var k:int = 0; k < 2; k++)
            {
               this.target_mc.activMC["mc_" + k].mc.visible = false;
            }
            var itemArray:Array = evt.EventObj.itemArray;
            for(var i:int = 0; i < itemArray.length; i++)
            {
               tempArray = itemArray[i].itemArray;
               for(j = 0; j < tempArray.length; j++)
               {
                  num = int(tempArray[j]);
                  tempNum = tempArray.length - j - 1;
                  if(num == 1)
                  {
                     this.target_mc.activMC["mc_" + tempNum].mc.visible = true;
                     this.target_mc.activMC["mc_" + tempNum].discreteness.changeBool = false;
                  }
               }
            }
         }
         
         private function loadGameHandler(evt:Event = null) : void
         {
            var url:String = null;
            if(!MainManager.getGameLevel().getChildByName("gameMC"))
            {
               this.target_mc.action_mc.changeBool = false;
               this.loadMC = new MovieClip();
               this.loadMC.name = "gameMC";
               MainManager.getGameLevel().addChild(this.loadMC);
               url = "module/magic/Magic.swf";
               this.infoClass = new MCLoader(url,this.loadMC,1,"正在進入魔法門");
               this.infoClass.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadGameOverHandler);
               this.infoClass.doLoad();
            }
         }
         
         private function loadGameOverHandler(evt:MCLoadEvent) : void
         {
            var mainMC:DisplayObjectContainer = evt.getParent();
            var childMC:Loader = evt.getLoader();
            mainMC.addChild(childMC);
         }
         
         private function initGetSeed() : void
         {
            this.target_mc.dao.buttonMode = true;
            this.target_mc.dao.addEventListener(MouseEvent.CLICK,this.onDao);
            this.target_mc.cao.buttonMode = true;
            this.target_mc.cao.addEventListener(MouseEvent.CLICK,this.onCao);
         }
         
         public function sheepEatCao(e:*) : void
         {
            var animal:IAnimal_Follow = PeopleManageView(GV.MAN_PEOPLE).animal;
            animal.doSpecialAciotn();
            animal.MoveEngine.removeEventListener(PeopleManageView.ON_GO_OVER,this.sheepEatCao);
            animal.MoveEngine.addEventListener(PeopleManageView.ON_GO_START,this.sheepLeave);
            this.eatCaoID = setTimeout(this.eatCao,5000);
         }
         
         private function sheepLeave(e:EventTaomee) : void
         {
            var animal:IAnimal_Follow = PeopleManageView(GV.MAN_PEOPLE).animal;
            animal.MoveEngine.removeEventListener(PeopleManageView.ON_GO_START,this.sheepLeave);
            clearTimeout(this.eatCaoID);
         }
         
         private function eatCao() : void
         {
            var animal:IAnimal_Follow = PeopleManageView(GV.MAN_PEOPLE).animal;
            clearTimeout(this.eatCaoID);
            GV.onlineSocket.addEventListener("read_" + 1375,this.eatCaoOK);
            farmSocket.outMap_feed(animal.getAnimalData().NO);
         }
         
         private function eatCaoOK(e:EventTaomee) : void
         {
            var animalName:String = null;
            var animal:IAnimal_Follow = PeopleManageView(GV.MAN_PEOPLE).animal;
            GV.onlineSocket.removeEventListener("read_" + 1375,this.eatCaoOK);
            animal.MoveTo(300,300);
            animal.upAnimalData(e.EventObj as AnimalInfo);
            var ran:Number = Math.random();
            if(ran > 0.7)
            {
               this.getNanGua();
            }
            else if(ran < 0.3)
            {
               animalName = GoodsInfo.getItemNameByID(animal.getAnimalData().ID);
               Alert.showAlert(MainManager.getGameLevel(),"    你的" + animalName + "在覓食時吃到了苦味草，心情非常不好，帶著它去莊園四處散心吧！","",6,"D");
            }
         }
         
         public function getNanGua(type:int = 26) : void
         {
            GV.onlineSocket.addEventListener(PresentGoodsRes.PRESENT_GOODS_SUCC,this.getSeedSucc);
            GV.onlineSocket.addEventListener("ERROR_CMD_1116",this.getSeedError);
            PresentGoodsReq.req(type);
         }
         
         private function getSeedError(evt:EventTaomee) : void
         {
            GV.onlineSocket.removeEventListener(PresentGoodsRes.PRESENT_GOODS_SUCC,this.getSeedSucc);
            GV.onlineSocket.removeEventListener("ERROR_CMD_1116",this.getSeedError);
         }
         
         private function getSeedSucc(e:EventTaomee) : void
         {
            var animalName:String = null;
            var msg:String = null;
            var animal:IAnimal_Follow = PeopleManageView(GV.MAN_PEOPLE).animal;
            GV.onlineSocket.removeEventListener(PresentGoodsRes.PRESENT_GOODS_SUCC,this.getSeedSucc);
            GV.onlineSocket.removeEventListener("ERROR_CMD_1116",this.getSeedError);
            if(e.EventObj.Flag == 1)
            {
               animalName = GoodsInfo.getItemNameByID(animal.getAnimalData().ID);
               msg = "    哇！你的" + animalName + "在覓食時意外發現了1顆棉花種子，物品已經放入你的家園倉庫中。";
               Alert.getIconByID_Alart(e.EventObj.ItemID,msg);
            }
            else
            {
               animalName = GoodsInfo.getItemNameByID(animal.getAnimalData().ID);
               Alert.showAlert(MainManager.getAppLevel(),"    你的" + animalName + "已經吃飽了，帶著它去四處逛逛，有助於消化哦!",msg,Alert.IKNOW_ALERT);
            }
         }
         
         private function onCao(evt:MouseEvent) : void
         {
            var animalName:String = null;
            var animal:IAnimal_Follow = PeopleManageView(GV.MAN_PEOPLE).animal;
            if(Boolean(animal) && (animal.getAnimalData().ID == 1270006 || animal.getAnimalData().ID == 1270007 || animal.getAnimalData().ID == 1270036))
            {
               if(animal.getAnimalData().Flag >= 2)
               {
                  animal.aouoMove = false;
                  animal.Speed *= 3;
                  animal.MoveEngine.addEventListener(PeopleManageView.ON_GO_OVER,this.sheepEatCao);
                  animal.MoveTo(165,165);
               }
               else
               {
                  animalName = GoodsInfo.getItemNameByID(animal.getAnimalData().ID);
                  Alert.showAlert(MainManager.getAppLevel(),"","    你的" + animalName + "已經吃飽了，帶著它去四處逛逛，有助於消化哦！",Alert.IKNOW_ALERT);
               }
            }
         }
         
         private function onDao(evt:MouseEvent) : void
         {
            this.target_mc.dao.buttonMode = false;
            this.target_mc.dao.removeEventListener(MouseEvent.CLICK,this.onDao);
            GV.onlineSocket.addEventListener("Get_Seed",this.onGetSeed);
            this.target_mc.dao.gotoAndStop(2);
         }
         
         private function onGetSeed(evt:Event) : void
         {
            if(Math.random() * 10 < 8)
            {
               Presented.getInstance().FreeReceive(19);
            }
            this.target_mc.dao.buttonMode = true;
            this.target_mc.dao.addEventListener(MouseEvent.CLICK,this.onDao);
         }
         
         override public function destroy() : void
         {
            this.target_mc.dao.removeEventListener(MouseEvent.CLICK,this.onDao);
            GV.onlineSocket.removeEventListener("Get_Seed",this.onGetSeed);
            if(Boolean(this.pet_timer))
            {
               GC.clearGTimeout(this.pet_timer);
               this.pet_timer = null;
            }
            if(this.musicHand != null)
            {
               this.musicHand.stop();
            }
            this.musicHand = null;
            this.danceMusic = null;
            if(this.GameTip != null)
            {
               this.removeTipHandler();
            }
            if(this.newTipMC != null)
            {
               this.removeNewTipMCHandler();
            }
            BC.removeEvent(this);
            if(this.timer_num != null)
            {
               GC.clearGTimeout(this.timer_num);
            }
            GV.onlineSocket.removeEventListener(trafficRes.TRAFFIC_OVER,this.rainBowHandler);
            GV.onlineSocket.removeEventListener(randomItemRes.RANMOM_ITEM,this.activeHandler);
            this.target_mc.lotus_mc_1.addEventListener(MouseEvent.CLICK,this.lotusGiveHandler);
            this.target_mc.mapBtn_2.removeEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
            this.target_mc.mapBtn_2.removeEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
            GV.onlineSocket.removeEventListener("move_for_game",this.loadGameHandler);
            this.target_mc.lotusbtn_1.removeEventListener(MouseEvent.CLICK,this.showLotusHandler);
            this.target_mc.lotusbtn_2.removeEventListener(MouseEvent.CLICK,this.showLotusHandler);
            GV.onlineSocket.removeEventListener(moleActionRes.MOLE_SLIDE,this.lotusCopyEvent);
            this.target_mc = null;
            this.depth_mc = null;
            this.effect_bg = null;
            this.button_mc = null;
            clearInterval(this._interval);
            super.destroy();
         }
      }
   }
   
   