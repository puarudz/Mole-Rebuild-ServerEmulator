package com.module.restaurant
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.util.DisplayUtil;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.newloader.LoaderList;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.global.links.Links;
   import com.global.staticData.XMLInfo;
   import com.logic.FindPathLogic.*;
   import com.logic.PeopleCountLogic.PeopleCountLogic;
   import com.logic.socket.enterMapOrRoom.EnterMapOrRoomReq;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.logic.socket.finishSomething.finishedSomethingReq;
   import com.logic.socket.oneBigStreetSocket.oneBigStreetSocket;
   import com.module.activityModule.SoundControlModule;
   import com.module.npc.lamu.I_LamuNPC;
   import com.view.MapManageView.MapButtonView;
   import com.view.PeopleView.PeopleManageView;
   import com.view.mapView.activity.creatShareObject;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.net.URLRequest;
   
   public class RestaurantView
   {
      
      private static var instance:RestaurantView;
      
      private static var canotNew:Boolean = true;
      
      private var restaurantBeen:RestaurantBeen;
      
      private var backGrounLoader:MCLoader;
      
      private var mainMC:MovieClip;
      
      private var foodLocation:int;
      
      private var foodLoad:Loader;
      
      private var p:PeopleManageView;
      
      public const LocationByStove:int = 1;
      
      public const LocationByMove:int = 50;
      
      private var myalter:Object;
      
      public var isChangeStyle:Boolean;
      
      public var FoodMenucurrentPage:int;
      
      public function RestaurantView()
      {
         super();
         if(canotNew)
         {
            throw new Error("RestaurantView不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : RestaurantView
      {
         if(!instance)
         {
            canotNew = false;
            instance = new RestaurantView();
            canotNew = true;
         }
         return instance;
      }
      
      public function setValue(disObj:DisplayObject, restaurantInfoObj:Object) : void
      {
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         this.restaurantBeen = RestaurantBeen.getInstance();
         this.restaurantBeen.setInRestaurant(true);
         this.restaurantBeen.setRestaurantMC(disObj as MovieClip);
         SoundControlModule.getInstance().initSound();
         if(creatShareObject.getInstance().getFoodMenuCurrentPage() != 0)
         {
            this.FoodMenucurrentPage = creatShareObject.getInstance().getFoodMenuCurrentPage();
         }
         this.loadRestaurantBackGround(restaurantInfoObj);
      }
      
      private function loadRestaurantBackGround(restaurantInfoObj:Object) : void
      {
         this.restaurantBeen.setRestaurantInfo(restaurantInfoObj);
         var houseUserId:int = int(this.restaurantBeen.getRestaurantInfo().houseInfo.houseUserId);
         var isMyRestaurant:Boolean = false;
         if(houseUserId == LocalUserInfo.getUserID())
         {
            isMyRestaurant = true;
         }
         this.restaurantBeen.setMyRestaurant(isMyRestaurant);
         if(this.restaurantBeen.isMyRestaurant())
         {
            LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + this.restaurantBeen.getRestaurantInfo().houseInfo.peopMoney);
         }
         var backGroundPath:String = "resource/oneBigStree/swf/" + this.restaurantBeen.getRestaurantInfo().houseInfo.houseInnerStyle + ".swf";
         this.backGrounLoader = new MCLoader(Links.getUrl(backGroundPath),MainManager.getAppLevel(),1,"正在加載餐廳內背景...");
         BC.addEvent(this,this.backGrounLoader,MCLoadEvent.ON_SUCCESS,this.loadBGSucc);
         BC.addEvent(this,this.backGrounLoader,MCLoadEvent.ERROR,this.loadBGErr);
         LoaderList.getInstance().addItem(this.backGrounLoader,null,LoaderList.HIGH);
      }
      
      private function loadBGSucc(evt:MCLoadEvent) : void
      {
         BC.removeEvent(this,this.backGrounLoader,MCLoadEvent.ON_SUCCESS,this.loadBGSucc);
         this.restaurantBeen.setRestaurantBG(evt.getContent() as MovieClip);
         this.restaurantBeen.getRestaurantMC().addChildAt(this.restaurantBeen.getRestaurantBG().top_mc,1);
         this.restaurantBeen.getRestaurantMC().addChildAt(this.restaurantBeen.getRestaurantBG().type_mc,1);
         this.restaurantBeen.getRestaurantMC().addChildAt(this.restaurantBeen.getRestaurantBG().buttonLevel,1);
         this.restaurantBeen.getRestaurantMC().addChildAt(this.restaurantBeen.getRestaurantBG().depth_mc,1);
         this.restaurantBeen.getRestaurantMC().addChildAt(this.restaurantBeen.getRestaurantBG().control_mc,1);
         this.restaurantBeen.getRestaurantMC().addChildAt(this.restaurantBeen.getRestaurantBG().bg_mc,1);
         this.restaurantBeen.getRestaurantMC().bg_mc = this.restaurantBeen.getRestaurantBG().bg_mc;
         this.restaurantBeen.getRestaurantMC().control_mc = this.restaurantBeen.getRestaurantBG().control_mc;
         this.restaurantBeen.getRestaurantMC().depth_mc = this.restaurantBeen.getRestaurantBG().depth_mc;
         this.restaurantBeen.getRestaurantMC().buttonLevel = this.restaurantBeen.getRestaurantBG().buttonLevel;
         this.restaurantBeen.getRestaurantMC().type_mc = this.restaurantBeen.getRestaurantBG().type_mc;
         this.restaurantBeen.getRestaurantMC().top_mc = this.restaurantBeen.getRestaurantBG().top_mc;
         this.restaurantBeen.getRestaurantMC().depth_mc.mouseEnabled = true;
         this.restaurantBeen.getRestaurantMC().depth_mc.mouseChildren = true;
         var houseInfo:Object = GoodsInfo.getInfoById(this.restaurantBeen.getRestaurantInfo().houseInfo.houseInnerStyle);
         this.restaurantBeen.getRestaurantInfo().houseInfo.houseStoveNum = houseInfo.Stove;
         this.restaurantBeen.getRestaurantInfo().houseInfo.houseFoodTable = houseInfo.FoodTable;
         this.restaurantBeen.getRestaurantInfo().houseInfo.houseTable = houseInfo.Table;
         this.restaurantBeen.getRestaurantInfo().houseGuest = new Array();
         GV.onlineSocket.dispatchEvent(new EventTaomee("allRestaurantGoodsLoaded"));
         this.restaurantBeen.getRestaurantMC().bg_mc = new MovieClip();
         this.restaurantBeen.getRestaurantMC().addChildAt(this.restaurantBeen.getRestaurantMC().bg_mc,1);
         BC.addEvent(this,PeopleCountLogic.owner,PeopleCountLogic.onAddChildPeopleOver,this.peopOver);
      }
      
      private function peopOver(evt:Event) : void
      {
         var tempitem:Object = null;
         var p:Point = null;
         var item:PeopleManageView = null;
         BC.removeEvent(this,PeopleCountLogic.owner,PeopleCountLogic.onAddChildPeopleOver,this.peopOver);
         if(this.isChangeStyle)
         {
            for each(tempitem in PeopleCountLogic.peopleList)
            {
               p = MoveTo.getRandomFloorPoint();
               item = tempitem.Instance as PeopleManageView;
               item.x = p.x;
               item.y = p.y;
            }
            this.isChangeStyle = false;
         }
         this.initRestaurantFun();
         RestaurantFood.getInstance().init();
         RestaurantEmp.getInstance().init();
         RestaurantGuest.getInstance().init();
         this.initHouseName(this.restaurantBeen.getRestaurantInfo().houseInfo.houseName);
         RestaurantUI.getInstance().init();
         this.popOweMoney();
         this.businessing();
         RestaurantTheme.getInstance().init();
         RestaurantEvent.getInstance().init();
      }
      
      public function initHouseName(name:String) : void
      {
         var control_mc:MovieClip = this.restaurantBeen.getRestaurantMC().control_mc;
         control_mc.myNameMc.nameTxt.text = name;
      }
      
      public function businessing() : void
      {
         if(RestaurantGuest.getInstance().isJoin())
         {
            this.restaurantBeen.getRestaurantMC().control_mc.joinMc.gotoAndStop(1);
         }
         else
         {
            this.restaurantBeen.getRestaurantMC().control_mc.joinMc.gotoAndStop(2);
         }
      }
      
      private function popOweMoney() : void
      {
         if(this.restaurantBeen.isMyRestaurant())
         {
            BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.onPopOweMoney);
            finishSomethingReq.sendReq(169);
         }
      }
      
      private function onPopOweMoney(evt:EventTaomee) : void
      {
         var money:int = 0;
         var msg:String = null;
         BC.removeEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.onPopOweMoney);
         if(evt.EventObj.Type == 169 && evt.EventObj.Done == 0)
         {
            money = int(this.restaurantBeen.getRestaurantInfo().houseInfo.houseMoney);
            msg = "";
            if(money <= -100000)
            {
               msg = "     你的餐廳收入小於-100000摩爾豆，無法通過做菜來獲取餐廳經驗值了。";
               GF.showAlert(MainManager.getGameLevel(),msg,"",100,"iknow",true,false,"E");
               finishedSomethingReq.sendReq(169);
            }
            else if(money < -50000)
            {
               msg = "     你的餐廳收入小於-50000摩爾豆，每道菜做好之後只能獲取一半的經驗值。";
               GF.showAlert(MainManager.getGameLevel(),msg,"",100,"iknow",true,false,"E");
               finishedSomethingReq.sendReq(169);
            }
         }
      }
      
      private function initRestaurantFun() : void
      {
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.actionHandler);
         BC.addEvent(this,GV.onlineSocket,"read_1017",RestaurantFood.getInstance().changeMakeFood);
         BC.addEvent(this,GV.onlineSocket,"read_1021",RestaurantFood.getInstance().moveMakeFood);
         BC.addEvent(this,GV.onlineSocket,"read_1015",RestaurantEmp.getInstance().addEmpUser);
         BC.addEvent(this,GV.onlineSocket,"read_1016",RestaurantEmp.getInstance().removeEmpUser);
         BC.addEvent(this,GV.onlineSocket,"read_1019",RestaurantFood.getInstance().onClearFoodHandler);
         BC.addEvent(this,GV.onlineSocket,"read_1026",RestaurantUI.getInstance().levelUIFun);
         BC.addEvent(this,GV.onlineSocket,"read_1029",RestaurantUI.getInstance().honorFun);
         BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_-100182",RestaurantGuest.getInstance().notJoin);
         BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_-12648",RestaurantFood.getInstance().removeZheMc);
         BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_-12644",RestaurantFood.getInstance().removeZheMc);
         BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_-11017",RestaurantFood.getInstance().removeZheMc);
         BC.addEvent(this,GV.onlineSocket,"read_1047",RestaurantUI.getInstance().onFoodUpLevel);
         BC.addEvent(this,GV.onlineSocket,"FoodMenuCurrentPage",this.updateFoodMenuCurrentPage);
      }
      
      private function updateFoodMenuCurrentPage(evt:EventTaomee) : void
      {
         this.FoodMenucurrentPage = evt.EventObj.currentPage;
         creatShareObject.getInstance().setFoodMenuCurrentPage(this.FoodMenucurrentPage);
      }
      
      private function actionHandler(evt:EventTaomee) : void
      {
         var type:int = int(evt.EventObj.type);
         if(type == 0)
         {
            this.exitHouse();
         }
         else if(type >= 1 && type <= 50)
         {
            if(this.restaurantBeen.isMyRestaurant())
            {
               RestaurantFood.getInstance().makeFood(type);
            }
         }
         else if(type >= 51 && type <= 100)
         {
            if(this.restaurantBeen.isMyRestaurant())
            {
               this.getFood(type);
            }
         }
         else if(type >= 101 && type <= 200)
         {
            RestaurantGuest.getInstance().eatFood(type,evt.EventObj.directionS);
         }
      }
      
      private function exitHouse() : void
      {
         var grid:int = int(this.restaurantBeen.getRestaurantInfo().houseInfo.houseGrid);
         this.restaurantBeen.setInRestaurant(false);
         this.restaurantBeen.setMyRestaurant(false);
         LocalUserInfo.setMyInfo_Grid(grid);
         GV.Room_DefaultRoomID = 0;
         EnterMapOrRoomReq.OldMapID = EnterMapOrRoomReq.OldMapType = 0;
         GF.switchMap(150);
      }
      
      private function getFood(type:int) : void
      {
         var foodMakeMc:* = undefined;
         var mess:String = null;
         foodMakeMc = this.restaurantBeen.getRestaurantMC().depth_mc["foodTable" + type];
         if(foodMakeMc.foodMakeObj != null)
         {
            mess = "你願意支付100摩爾豆包裝費，將菜捐給流浪的拉姆嗎？";
            this.myalter = GF.showAlert(MainManager.getGameLevel(),mess,"",100,"sure,cancel",true,false,"E");
            this.myalter.addEventListener(Alert.CLICK_ + "1",function(e:Event):void
            {
               var foodArr:Array = restaurantBeen.getRestaurantInfo().houseFoodInfo.foodArr;
               for(var f:int = 0; f < foodArr.length; f++)
               {
                  if(foodArr[f].itemId == foodMakeMc.foodMakeObj.itemId)
                  {
                     foodArr.splice(f,1);
                     break;
                  }
               }
               oneBigStreetSocket.clearFood(foodMakeMc.foodMakeObj.itemId,foodMakeMc.foodMakeObj.foodIndex,type);
            });
         }
      }
      
      public function onExitHouse(evt:Event) : void
      {
         BC.removeEvent(this,evt.currentTarget,PeopleManageView.ON_GO_OVER,this.onExitHouse);
         addLamuByRestaurant.getInstance().clearLamu(MovieClip(evt.currentTarget));
      }
      
      public function loadMcAndObj(path:String, obj:Object, sign:int = 0, mc:MovieClip = null) : void
      {
         var foodMakeObj:Object = null;
         foodMakeObj = obj;
         this.foodLoad = new Loader();
         this.foodLoad.unload();
         this.foodLoad.contentLoaderInfo.addEventListener(Event.COMPLETE,function(E:Event):void
         {
            onFoodLoadComplete(E,foodMakeObj,sign,mc);
         });
         this.foodLoad.load(new URLRequest(path));
      }
      
      private function onFoodLoadComplete(evt:Event, obj:Object = null, sign:int = 0, mc:MovieClip = null) : void
      {
         var foodMc:MovieClip = evt.currentTarget.content.mc as MovieClip;
         if(sign == 0)
         {
            foodMc.gotoAndStop(obj.foodState);
            foodMc.x = -this.restaurantBeen.getRestaurantMC().depth_mc["foodTable" + obj.foodLocation].width;
            foodMc.y = -this.restaurantBeen.getRestaurantMC().depth_mc["foodTable" + obj.foodLocation].height;
            this.restaurantBeen.getRestaurantMC().depth_mc["foodTable" + obj.foodLocation].addChild(foodMc);
            trace(this.restaurantBeen.getRestaurantMC().depth_mc["foodTable" + obj.foodLocation].getChildByName("mc").totalFrames);
         }
         else if(sign == 1)
         {
            foodMc.gotoAndStop(6);
            foodMc.visible = false;
            foodMc.x = 50;
            foodMc.y = -50;
            if(mc.tableObj.emp != null && !mc.tableObj.emp.lamu.getChildByName("mc"))
            {
               I_LamuNPC(mc.tableObj.emp.lamu)["addChild"](foodMc);
               trace(mc.tableObj.emp.lamu.getChildByName("mc").totalFrames);
            }
         }
      }
      
      public function checkHouseFavor(type:int, exitGuest:MovieClip) : void
      {
         var favorlimit:int = 0;
         var eatlamuMc:MovieClip = null;
         var buttonLevel:MovieClip = this.restaurantBeen.getRestaurantMC().buttonLevel;
         if(type == 0)
         {
            favorlimit = int(XMLInfo.RestaurantUIObj.favorlimitByLevel[this.restaurantBeen.getRestaurantInfo().houseInfo.houseLevel]);
            this.restaurantBeen.getRestaurantInfo().houseInfo.houseFavor = this.restaurantBeen.getRestaurantInfo().houseInfo.houseFavor - 1;
            if(this.restaurantBeen.getRestaurantInfo().houseInfo.houseFavor < favorlimit)
            {
               this.restaurantBeen.getRestaurantInfo().houseInfo.houseFavor = 50;
            }
            RestaurantRandomSay.getInstance().say(2,exitGuest);
            if(this.restaurantBeen.isMyRestaurant())
            {
               oneBigStreetSocket.lowerHouseFavor();
            }
         }
         else if(type == 1)
         {
            this.restaurantBeen.getRestaurantInfo().houseInfo.houseFavor = this.restaurantBeen.getRestaurantInfo().houseInfo.houseFavor + 1;
            if(this.restaurantBeen.getRestaurantInfo().houseInfo.houseFavor >= 1000)
            {
               this.restaurantBeen.getRestaurantInfo().houseInfo.houseFavor = 1000;
            }
            RestaurantRandomSay.getInstance().say(1,exitGuest);
            exitGuest.alpha = 1;
            try
            {
               eatlamuMc = RestaurantBeen.getInstance().getRestaurantMC().depth_mc.getChildByName(exitGuest.eatlamuMcName);
               RestaurantBeen.getInstance().getRestaurantMC().depth_mc.removeChild(eatlamuMc);
            }
            catch(e:Error)
            {
            }
            exitGuest.eatTimer = null;
         }
         RestaurantUI.getInstance().favorUIFun(type);
         RestaurantGuest.getInstance().clearGuest(exitGuest as MovieClip);
         exitGuest.autoMove = false;
         BC.addEvent(this,exitGuest,PeopleManageView.ON_GO_OVER,this.onExitHouse);
         exitGuest.MoveTo(buttonLevel.exitPonit.x,buttonLevel.exitPonit.y);
      }
      
      private function loadBGErr(evt:MCLoadEvent) : void
      {
         throw new Error("加載餐廳內背景出錯");
      }
      
      private function clearTableWaitTimer() : void
      {
         var tableNum:int = int(this.restaurantBeen.getRestaurantInfo().houseInfo.houseTable);
         var depth_mc:MovieClip = this.restaurantBeen.getRestaurantMC().depth_mc;
         for(var tr:int = 0; tr < tableNum; tr++)
         {
            if(depth_mc["table" + (101 + tr)].tableObj != null)
            {
               GC.clearGInterval(depth_mc["table" + (101 + tr)].tableObj.waitTimer);
            }
            if(depth_mc["table" + (101 + tr)].tableObj != null && depth_mc["table" + (101 + tr)].tableObj.lamu != null && depth_mc["table" + (101 + tr)].tableObj.lamu.eatTimer != null)
            {
               GC.clearGInterval(depth_mc["table" + (101 + tr)].tableObj.lamu.eatTimer);
            }
         }
      }
      
      public function onChangeHouseInnerStyle(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_1013",this.onChangeHouseInnerStyle);
         if(RestaurantBeen.getInstance().isMyRestaurant())
         {
            LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() - evt.EventObj.InnerStyleMoney);
         }
         this.restaurantBeen.getRestaurantInfo().houseInfo.houseInnerStyle = evt.EventObj.InnerStyle;
         this.clearTableWaitTimer();
         addLamuByRestaurant.getInstance().claerGuestTimer();
         RestaurantGuest.getInstance().clearGuestTimer();
         RestaurantGuest.getInstance().clearEatTimer();
         RestaurantFood.getInstance().clearFoodTimer();
         RestaurantMakeFoodTips.getInstance().clearBiaoMcTimer();
         RestaurantEmp.getInstance().changeEmpState();
         GF.clearTip();
         GF.clearPeoples();
         RestaurantGuest.getInstance().removeGuest();
         RestaurantEmp.getInstance().removeEmp();
         BC.removeEvent(this);
         this.restaurantBeen.getRestaurantInfo().houseFoodInfo.allFoodCount = this.restaurantBeen.getRestaurantInfo().houseFoodInfo.foodArr.length;
         this.restaurantBeen.getRestaurantInfo().housePeopleInfo.employeCount = this.restaurantBeen.getRestaurantInfo().housePeopleInfo.peopArr.length;
         DisplayUtil.removeForParent(this.restaurantBeen.getRestaurantBG());
         DisplayUtil.removeForParent(this.restaurantBeen.getRestaurantMC().bg_mc);
         DisplayUtil.removeForParent(this.restaurantBeen.getRestaurantMC().control_mc);
         DisplayUtil.removeForParent(this.restaurantBeen.getRestaurantMC().depth_mc);
         DisplayUtil.removeForParent(this.restaurantBeen.getRestaurantMC().buttonLevel);
         DisplayUtil.removeForParent(this.restaurantBeen.getRestaurantMC().type_mc);
         DisplayUtil.removeForParent(this.restaurantBeen.getRestaurantMC().top_mc);
         MapButtonView.getTarget().destroy();
         this.loadRestaurantBackGround(this.restaurantBeen.getRestaurantInfo());
      }
      
      private function removeEventHandler(evt:Event) : void
      {
         this.restaurantBeen.setInRestaurant(false);
         this.restaurantBeen.setMyRestaurant(false);
         this.clearTableWaitTimer();
         addLamuByRestaurant.getInstance().claerGuestTimer();
         RestaurantGuest.getInstance().clearGuestTimer();
         RestaurantGuest.getInstance().clearEatTimer();
         RestaurantFood.getInstance().clearFoodTimer();
         RestaurantMakeFoodTips.getInstance().clearBiaoMcTimer();
         GF.clearTip();
         addLamuByRestaurant.getInstance().destroy();
         RestaurantGuest.getInstance().destroy();
         RestaurantFood.getInstance().destroy();
         RestaurantMakeFoodTips.getInstance().destroy();
         BC.removeEvent(this);
         GC.stopAllMC(this.restaurantBeen.getRestaurantMC());
      }
   }
}

