package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.util.MovieClipUtil;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.newloader.BaseMCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.PeopleCountLogic.PeopleCountLogic;
   import com.logic.socket.cottonSocket;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.logic.socket.finishSomething.finishedSomethingRes;
   import com.logic.socket.getServerTimer.getServerTimerReq;
   import com.logic.socket.getServerTimer.getServerTimerRes;
   import com.logic.socket.giveMeMoney.giveMeMoneyReq;
   import com.logic.socket.giveMeMoney.giveMeMoneyRes;
   import com.logic.socket.randomItemLogic.randomItemReq;
   import com.logic.socket.randomItemLogic.randomItemRes;
   import com.logic.socket.userSurvey.userSurveyDoneReq;
   import com.module.activityModule.Presented;
   import com.module.activityModule.checkItem;
   import com.module.pet.petLogic;
   import com.module.superPetModule.petItemModule;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.map.MapBase;
   import com.view.PeopleView.PeopleManageView;
   import com.view.mapView.source.map51.Map51Activity;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   
   public class AirMapView extends MapBase
   {
      
      private static var needFlowerID:uint;
      
      private var target_mc:MovieClip;
      
      private var depth_mc:MovieClip;
      
      private var botton_mc:MovieClip;
      
      private var effect_mc:MovieClip;
      
      private var topMC:MovieClip;
      
      private var setIntervalTimer:Timer;
      
      private var setTimeoutTimer:Timer;
      
      private var hasCheckUPlevel:Boolean = false;
      
      private var message:String;
      
      private var url:String;
      
      private var joinObj:Object;
      
      private var _activity:Map51Activity;
      
      private var colourflower:MovieClip;
      
      private var loadURL:String;
      
      private var goodNum:int = 1;
      
      private var arr1:Array = [180074,180075,180076,180077,180078,180079,180080,180081,180082,180083];
      
      private var arr2:Array = [180086,180087,180088,180089];
      
      public function AirMapView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         this.effect_mc = GV.MC_mapFrame["effect_mc"];
         this.topMC = GV.MC_mapFrame["top_mc"];
         this.target_mc.activMC.visible = false;
         getServerTimerReq.getServerTimer(this,"getServerTimer");
         BC.addEvent(this,this.topMC.magicStar,MouseEvent.CLICK,this.magicStarEvent);
         if(GV.MAN_PEOPLE.Petlevel == 101)
         {
            this.topMC.magicStar.visible = true;
            petItemModule.setPetEffectHandler(null,2);
         }
         this.initMagicCloud();
         this.target_mc.blower.buttonMode = true;
         BC.addEvent(this,this.target_mc.blower,MouseEvent.CLICK,this.blowerHandler);
         BC.addEvent(this,this.target_mc.blower,MouseEvent.MOUSE_OVER,this.overFun);
         BC.addEvent(this,this.topMC.hungryBtn,MouseEvent.MOUSE_OVER,this.overFun);
         BC.addEvent(this,this.botton_mc.colourflower,MouseEvent.MOUSE_OVER,this.overFun);
         BC.addEvent(this,this.target_mc.blower,MouseEvent.MOUSE_OUT,this.outFun);
         BC.addEvent(this,this.topMC.hungryBtn,MouseEvent.MOUSE_OUT,this.outFun);
         BC.addEvent(this,this.botton_mc.colourflower,MouseEvent.MOUSE_OUT,this.outFun);
         this.topMC.hungryBtn.buttonMode = true;
         BC.addEvent(this,this.topMC.hungryBtn,MouseEvent.CLICK,this.hungryHandler);
         BC.addEvent(this,this.botton_mc.colourflower,MouseEvent.CLICK,this.cblowerHandler);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1212,this.useSkill);
         this.colourflower = this.botton_mc.colourflower as MovieClip;
         BC.addEvent(this,this.colourflower,"play_over",this.cfPlayover);
      }
      
      override public function init() : void
      {
         super.init();
         this._activity = new Map51Activity(this);
      }
      
      private function overFun(e:MouseEvent) : void
      {
         if(e.currentTarget == this.target_mc.blower)
         {
            GF.showTip("快來製作飄飄棉花糖吧！");
         }
         else if(e.currentTarget == this.topMC.hungryBtn)
         {
            GF.showTip("颶風漢格瑞");
         }
         else if(e.currentTarget == this.botton_mc.colourflower)
         {
            GF.showTip("七色花");
         }
      }
      
      private function outFun(e:MouseEvent) : void
      {
         GF.clearTip();
      }
      
      public function useSkill(e:EventTaomee) : void
      {
         var action:int = 0;
         var p:PeopleManageView = null;
         var userID:int = int(e.EventObj.userID);
         action = int(e.EventObj.action);
         if(userID == LocalUserInfo.getUserID())
         {
            if(needFlowerID == 3 || needFlowerID == 5 || needFlowerID == 7)
            {
               p = GV.MAN_PEOPLE as PeopleManageView;
               if(Boolean(p.lamu))
               {
                  p.lamu["alpha"] = 0;
                  p.pet_hitBtn.visible = false;
               }
               setTimeout(function():void
               {
                  if(action % 3 == 2)
                  {
                     colourflower.gotoAndStop(2);
                  }
                  else if(action % 3 == 1)
                  {
                     colourflower.gotoAndStop(3);
                  }
                  else if(action % 3 == 0)
                  {
                     colourflower.gotoAndStop(4);
                  }
               },100);
            }
         }
      }
      
      private function cfPlayover(e:Event) : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(Boolean(p.lamu))
         {
            p.lamu["alpha"] = 1;
            p.pet_hitBtn.visible = true;
         }
      }
      
      private function cblowerHandler(event:MouseEvent) : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(Boolean(p.lamuinfo) && p.lamuinfo.Petlevel == 101)
         {
            this._activity.initFlower(new SystemEvent("",1));
         }
         else if(LocalUserInfo.isVIP())
         {
            mapSay(201);
         }
         else
         {
            Alert.SLAlart("    讓超級拉姆神奇的金葉子為你展開七色夢想，我們歡迎你的加入！");
         }
      }
      
      private function finishBack(e:EventTaomee) : void
      {
         var tempMC:Sprite = null;
         var mcloader:BaseMCLoader = null;
         GV.onlineSocket.removeEventListener(finishSomethingRes.FINISH_SOMETHING_SUCC,this.finishBack);
         var type:int = int(e.EventObj.Type);
         var num:int = int(e.EventObj.Done);
         if(num < 3)
         {
            if(MainManager.getTopLevel().getChildByName("hungryGame") == null)
            {
               tempMC = new Sprite();
               tempMC.name = "hungryGame";
               MainManager.getGameLevel().addChild(tempMC);
               this.loadURL = "module/external/Hungrygame.swf";
               mcloader = new BaseMCLoader(this.loadURL,tempMC);
               mcloader.addEventListener(MCLoadEvent.ON_SUCCESS,this.gameHandler);
               mcloader.doLoad();
            }
         }
         else
         {
            Alert.showAlert(MainManager.getAppLevel(),"    今天你都去了三次了，明天再來吧！你的超級拉姆好像飛不動了！","",6,"E");
         }
      }
      
      private function hungryHandler(e:MouseEvent) : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(Boolean(p.lamuinfo) && p.lamuinfo.Petlevel == 101)
         {
            GV.onlineSocket.addEventListener(finishSomethingRes.FINISH_SOMETHING_SUCC,this.finishBack);
            finishSomethingReq.sendReq(168);
         }
         else if(LocalUserInfo.isVIP())
         {
            Alert.showAlert(MainManager.getAppLevel(),"    不能讓貪吃的颶風漢格瑞偷走小摩爾們的工作果實，快帶著超級拉姆來幫忙！","",6,"E");
         }
         else
         {
            Alert.SLAlart("    被香味吸引而來的颶風漢格瑞企圖奪走我們所有的美食，超級拉姆們快點站出來捍衛莊園！");
         }
      }
      
      public function gameHandler(event:MCLoadEvent) : void
      {
         event.currentTarget.addEventListener(MCLoadEvent.ON_SUCCESS,this.gameHandler);
         var content:DisplayObject = event.getContent();
         var mc:Sprite = event.getParent() as Sprite;
         mc.addChild(content);
         BaseMCLoader(event.currentTarget).clear();
         switch(this.loadURL)
         {
            case "module/external/Hungrygame.swf":
               GV.onlineSocket.addEventListener("game_over",this.gameoverFun);
         }
      }
      
      public function gameoverFun(e:Event) : void
      {
         var id:int = 0;
         GV.onlineSocket.removeEventListener("game_over",this.gameoverFun);
         switch(this.loadURL)
         {
            case "module/external/Hungrygame.swf":
               this.loadURL = "";
               id = int((e as EventTaomee).EventObj.result);
               this.goodNum = (e as EventTaomee).EventObj.num;
               BC.addEvent(this,GV.onlineSocket,"read_" + 5700,this.getCottonBack);
               cottonSocket.getCotton(id);
         }
      }
      
      private function getCottonBack(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 5700,this.getCottonBack);
         var id:int = int(e.EventObj.ItemID);
         var typeID:int = int(e.EventObj.typeID);
         Alert.getIconByID_Alart(id,"    你得到了" + this.getNumString(typeID,id) + "個" + GoodsInfo.getItemNameByID(id) + "，快去" + GoodsInfo.getItemCollectionBoxNameByID(id) + "裡看看吧！");
      }
      
      private function getNumString(typeID:int, id:int) : String
      {
         switch(typeID)
         {
            case 6:
               return "兩";
            case 7:
               if(this.checkInArr(id,this.arr1))
               {
                  return "三";
               }
               return "兩";
               break;
            case 8:
               if(this.checkInArr(id,this.arr2))
               {
                  return "三";
               }
               return "一";
               break;
            default:
               return "一";
         }
      }
      
      private function checkInArr(id:int, arr:Array) : Boolean
      {
         for(var i:int = 0; i < arr.length; i++)
         {
            if(id == arr[i])
            {
               return true;
            }
         }
         return false;
      }
      
      private function blowerHandler(event:MouseEvent) : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(Boolean(p.lamuinfo) && p.lamuinfo.Petlevel == 101)
         {
            this._activity.initCotton();
         }
         else if(LocalUserInfo.isVIP())
         {
            mapSay(107);
         }
         else
         {
            Alert.SLAlart("    喲，新來的小拉姆呀，想要製作像雲朵一樣美麗的飄飄棉花糖需要超級拉姆的超能力哦！");
         }
      }
      
      private function magicStarEvent(evt:MouseEvent) : void
      {
         this.topMC.magicStar.visible = false;
         Presented.getInstance().FreeReceive(13);
         petItemModule.setPetEffectHandler();
      }
      
      private function crystalInit() : void
      {
         this.target_mc.activMC.visible = true;
         for(var i:int = 0; i < 5; i++)
         {
            this.target_mc.activMC["mc_" + i].mc.gotoAndStop(2);
            this.target_mc.activMC["mc_" + i].mc.mouseEnabled = false;
         }
         BC.addEvent(this,GV.onlineSocket,randomItemRes.RANMOM_ITEM,this.activeHandler);
         randomItemReq.randomItemReqAction();
      }
      
      private function activeHandler(evt:EventTaomee) : void
      {
         var tempArray:Array = null;
         var itemID:int = 0;
         var j:int = 0;
         var num:int = 0;
         var tempNum:int = 0;
         for(var k:int = 0; k < 5; k++)
         {
            this.target_mc.activMC["mc_" + k].mc.gotoAndStop(2);
            this.target_mc.activMC["mc_" + k].mc.mouseEnabled = false;
         }
         var itemArray:Array = evt.EventObj.itemArray;
         for(var i:int = 0; i < itemArray.length; i++)
         {
            tempArray = itemArray[i].itemArray;
            itemID = int(itemArray[i].itemID);
            for(j = 0; j < tempArray.length; j++)
            {
               num = int(tempArray[j]);
               tempNum = tempArray.length - j - 1;
               if(num == 1)
               {
                  this.target_mc.activMC["mc_" + tempNum].mc.gotoAndStop(1);
                  this.target_mc.activMC["mc_" + tempNum].mc.mouseEnabled = true;
                  this.target_mc.activMC["mc_" + tempNum].discreteness.changeBool = false;
               }
            }
         }
      }
      
      public function getServerTimer(E:Date) : void
      {
         GC.clearGInterval(this.setIntervalTimer);
         BC.removeEvent(this,null,PeopleManageView.ON_GO_OVER);
         BC.removeEvent(this,null,randomItemRes.RANMOM_ITEM);
         var hours:uint = E.getHours();
         if(hours >= 6 && hours < 8)
         {
            MovieClipUtil.gotoAndStop(this.depth_mc.cloud_mc,"万里无云");
            MovieClipUtil.gotoAndStop(this.effect_mc.weather_mc,"万里无云");
            this.target_mc.mask_mc.gotoAndStop(1);
            this.target_mc.activMC.visible = false;
            this.setIntervalTimer = GC.setGInterval(this.checkPondweed,2000);
            BC.addEvent(this,GV.MAN_PEOPLE.avatarClass,PeopleManageView.ON_GO_OVER,this.onGoOver);
         }
         else if(hours >= 8 && hours < 23)
         {
            MovieClipUtil.gotoAndStop(this.depth_mc.cloud_mc,"晴空万里");
            MovieClipUtil.gotoAndStop(this.effect_mc.weather_mc,"晴空万里");
            this.target_mc.mask_mc.gotoAndStop(2);
            this.target_mc.activMC.visible = true;
            this.crystalInit();
            this.setIntervalTimer = GC.setGInterval(this.checkPondweed,2000);
            BC.addEvent(this,GV.MAN_PEOPLE.avatarClass,PeopleManageView.ON_GO_OVER,this.onGoOver);
         }
         else if(hours < 6 || hours >= 23 && hours < 24)
         {
            MovieClipUtil.gotoAndStop(this.depth_mc.cloud_mc,"乌云密布");
            MovieClipUtil.gotoAndStop(this.effect_mc.weather_mc,"乌云密布");
            this.target_mc.mask_mc.gotoAndStop(2);
            this.target_mc.activMC.visible = true;
            this.crystalInit();
         }
         BC.addEvent(this,GV.onlineSocket,getServerTimerRes.GET_SERVER_TIMER,this.changeServerTimer);
      }
      
      private function changeServerTimer(E:EventTaomee) : void
      {
         var dateObj:* = E.EventObj;
         this.getServerTimer(dateObj);
      }
      
      private function onGoOver(E:*) : void
      {
         var thisObj:Object = null;
         var people:MovieClip = GV.MAN_PEOPLE;
         if(Boolean(this.depth_mc.pondweed_mc.hitMC.hitTestPoint(people.x,people.y,true)) && people.PetID > 0)
         {
            this.depth_mc.pondweed_mc.gotoAndStop(2);
            if(this.setTimeoutTimer == null && !this.hasCheckUPlevel)
            {
               this.setTimeoutTimer = GC.setGTimeout(this.upPetLevel,60000);
               thisObj = this;
               BC.addEvent(this,GV.MAN_PEOPLE,PeopleManageView.ON_BACK_PET,function(E:Event):void
               {
                  BC.removeEvent(thisObj,GV.MAN_PEOPLE,PeopleManageView.ON_BACK_PET);
                  GC.clearGTimeout(thisObj.setTimeoutTimer);
               });
            }
         }
         else
         {
            GC.clearGTimeout(this.setTimeoutTimer);
            this.setTimeoutTimer = null;
         }
      }
      
      private function upPetLevel() : void
      {
         if(petLogic.havePetFollow())
         {
            userSurveyDoneReq.sendReq(4);
            BC.addEvent(this,GV.onlineSocket,finishedSomethingRes.GET_PETLEVEL_SUCC,this.getresult);
         }
      }
      
      private function getresult(E:EventTaomee) : void
      {
         if(E.EventObj.count > 0)
         {
            GF.showAlert(GV.MC_AppLever,"你的拉姆從陽光水池中吸收了充分的陽光和水份,現在正在茁壯成長中哦!","",6,"E");
         }
         this.hasCheckUPlevel = true;
      }
      
      private function checkPondweed() : void
      {
         var people:* = undefined;
         var inSideArr:Array = new Array();
         var peopleList:Array = PeopleCountLogic.FloorLayerPList;
         for each(people in peopleList)
         {
            if(Boolean(this.depth_mc.pondweed_mc.hitMC.hitTestPoint(people.Instance.x,people.Instance.y,true)) && people.Instance.PetID > 0)
            {
               inSideArr.push(people.Instance);
            }
         }
         if(inSideArr.length > 0)
         {
            if(this.depth_mc.pondweed_mc.currentFrame != 2)
            {
               this.depth_mc.pondweed_mc.gotoAndStop(2);
            }
         }
         else
         {
            this.depth_mc.pondweed_mc.gotoAndStop(1);
         }
      }
      
      private function initMagicCloud() : void
      {
         BC.addEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.itemSucHandler);
         checkItem.checkItemHandler(190392);
      }
      
      private function itemSucHandler(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.itemSucHandler);
         if(evt.EventObj.num == 1)
         {
            BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.onMagicCloud);
            this.topMC.MagicCloud.visible = true;
            this.topMC.MagicCloud.buttonMode = true;
         }
      }
      
      private function onMagicCloud(evt:EventTaomee) : void
      {
         if(GV.MAN_PEOPLE.Petlevel == 101 || petLogic.getPetMagicClass(GV.MAN_PEOPLE as PeopleManageView).hasFinish)
         {
            BC.removeEvent(this,GV.onlineSocket,"fireAction_select",this.onMagicCloud);
            this.message = "    我是魔法雲朵，如果你有漂亮的圖紙，那就趕快給我吧!要是不漂亮我可不變哦。";
            this.url = "resource/allJob/AlertPic/simpleAlertIcon/magicCloud.swf";
            this.joinObj = Alert.showAlert(MainManager.getAppLevel(),this.url,this.message,Alert.CHANG_ALERT,"iknow",true,false,"EMP_BUY");
            BC.addEvent(this,this.joinObj,"CLICK" + 1,this.magicCloudMessage);
         }
         else
         {
            GF.showAlert(GV.MC_AppLever,"\t帶著你的超級拉姆一起過來吧，它的神奇能力能幫助我們哦。","",100,"iknow",true,false,"E");
         }
      }
      
      private function magicCloudMessage(evt:Event) : void
      {
         BC.removeEvent(this,this.joinObj,"CLICK" + 1,this.magicCloudMessage);
         BC.addEvent(this,this.topMC.MagicCloud,"MagicCloud_Over",this.onMagicCloudOver);
         this.topMC.MagicCloud.gotoAndStop(2);
      }
      
      private function onMagicCloudOver(evt:Event) : void
      {
         BC.removeEvent(this,this.topMC.MagicCloud,"MagicCloud_Over",this.onMagicCloudOver);
         BC.addEvent(this,this.topMC.MagicCloud.MagicCloud2.house,MouseEvent.CLICK,this.onGetHouse);
      }
      
      private function onGetHouse(evt:MouseEvent) : void
      {
         BC.removeEvent(this,this.topMC.MagicCloud.MagicCloud2.house,MouseEvent.CLICK,this.onGetHouse);
         this.topMC.MagicCloud.visible = false;
         this.message = "    魔法雲朵將拉姆雙層小屋圖紙變成真的啦，多謝你的幫忙，就將這座小屋送給你吧！";
         this.url = "resource/goods/icon/160419.swf";
         this.joinObj = Alert.showAlert(MainManager.getAppLevel(),this.url,this.message,Alert.CHANG_ALERT,"iknow",true,false,"EMP_BUY");
         BC.addEvent(this,this.joinObj,"CLICK" + 1,this.getHouseImageF);
      }
      
      private function getHouseImageF(evt:Event) : void
      {
         BC.removeEvent(this,this.joinObj,"CLICK" + 1,this.getHouseImageF);
         var throwArr:Array = [{
            "kind":190392,
            "num":1
         }];
         var getArr:Array = [{
            "kind":160419,
            "num":1
         }];
         BC.addEvent(this,GV.onlineSocket,giveMeMoneyRes.SERVER_GIVEMONEY,this.onImage);
         var giveCS:giveMeMoneyReq = new giveMeMoneyReq(throwArr,getArr);
      }
      
      private function onImage(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,giveMeMoneyRes.SERVER_GIVEMONEY,this.onImage);
         GF.showAlert(GV.MC_AppLever,"\t恭喜你，漂亮的魔法拉姆雙層小屋已放入你的小屋倉庫中了！","",100,"iknow",true,false,"E");
      }
      
      override public function destroy() : void
      {
         this.cfPlayover(null);
         GC.clearGInterval(this.setIntervalTimer);
         GC.clearGTimeout(this.setTimeoutTimer);
         this.target_mc = null;
         this.depth_mc = null;
         this.botton_mc = null;
         this.effect_mc = null;
         this._activity.destroy();
         super.destroy();
      }
   }
}

