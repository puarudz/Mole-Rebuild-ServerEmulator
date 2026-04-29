package com.module.restaurant
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.soundControl.soundControl;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.socket.oneBigStreetSocket.oneBigStreetSocket;
   import com.module.loadExtentPanel.LoadGame;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class RestaurantFood
   {
      
      private static var instance:RestaurantFood;
      
      private static var canotNew:Boolean = true;
      
      private var foodObj:Object;
      
      private var foodObjArr:Array;
      
      private var restaurantBeen:RestaurantBeen;
      
      public const foodMakePath:String = "resource/restaurant/swf/";
      
      private var selectFoodLocation:int;
      
      private var myalter:Object;
      
      private var p:PeopleManageView;
      
      private var skillUpEffCC:MovieClip;
      
      private var skillUpEffU:MovieClip;
      
      public function RestaurantFood()
      {
         super();
         if(canotNew)
         {
            throw new Error("RestaurantFood不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : RestaurantFood
      {
         if(!instance)
         {
            canotNew = false;
            instance = new RestaurantFood();
            canotNew = true;
         }
         return instance;
      }
      
      public function init() : void
      {
         var foodId:int = 0;
         var foodState:int = 0;
         var foodLocation:int = 0;
         var foodInfo:Object = null;
         var foodLocationMc:MovieClip = null;
         var LocationByType:int = 0;
         var delay:int = 0;
         var lastTimer:int = 0;
         this.restaurantBeen = RestaurantBeen.getInstance();
         this.foodObj = this.restaurantBeen.getRestaurantInfo().houseFoodInfo;
         this.foodObjArr = this.foodObj.foodArr as Array;
         RestaurantMakeFoodTips.getInstance().initshuo();
         for(var foodObjArrRound:int = 0; foodObjArrRound < this.foodObj.allFoodCount; foodObjArrRound++)
         {
            foodId = int(this.foodObjArr[foodObjArrRound].itemId);
            foodState = int(this.foodObjArr[foodObjArrRound].foodState);
            foodLocation = int(this.foodObjArr[foodObjArrRound].foodLocation);
            foodInfo = GoodsInfo.getInfoById(foodId);
            foodLocationMc = this.restaurantBeen.getRestaurantMC().depth_mc["foodTable" + foodLocation];
            foodLocationMc.foodMakeObj = this.foodObjArr[foodObjArrRound];
            LocationByType = int(this.foodObjArr[foodObjArrRound].foodLocation);
            if(LocationByType >= RestaurantView.getInstance().LocationByStove && LocationByType <= RestaurantView.getInstance().LocationByMove)
            {
               this.restaurantBeen.getRestaurantMC().depth_mc["shuo" + foodLocation].visible = false;
            }
            if(foodState == 3)
            {
               lastTimer = int(this.foodObjArr[foodObjArrRound].foodMakeStartTimer);
               if(lastTimer >= foodInfo.NeedTimer + foodInfo.Timeout)
               {
                  this.foodObjArr[foodObjArrRound].foodState = 5;
                  RestaurantMakeFoodTips.getInstance().showFoodMoveTips(4,foodLocation,foodInfo,0);
               }
               else if(lastTimer >= foodInfo.NeedTimer)
               {
                  this.foodObjArr[foodObjArrRound].foodState = 4;
                  delay = (foodInfo.Timeout - (lastTimer - foodInfo.NeedTimer)) * 1000;
                  GC.clearGInterval(this.foodObjArr[foodObjArrRound].foodMakeTimer);
                  this.foodObjArr[foodObjArrRound].foodMakeTimer = GC.setGInterval(this.onFoodMakeTimerHandler,delay,this.foodObjArr[foodObjArrRound].foodLocation,this.foodObjArr[foodObjArrRound]);
                  foodLocationMc.foodMakeObj = this.foodObjArr[foodObjArrRound];
                  RestaurantMakeFoodTips.getInstance().showFoodMoveTips(4,foodLocation,foodInfo,delay);
                  RestaurantMakeFoodTips.getInstance().addBiaoTips(4,foodLocation);
                  RestaurantMakeFoodTips.getInstance().changeBiao(4,foodLocation,foodInfo,int(delay / 1000));
               }
               else
               {
                  delay = (foodInfo.NeedTimer - this.foodObjArr[foodObjArrRound].foodMakeStartTimer) * 1000;
                  GC.clearGInterval(this.foodObjArr[foodObjArrRound].foodMakeTimer);
                  this.foodObjArr[foodObjArrRound].foodMakeTimer = GC.setGInterval(this.onFoodMakeTimerHandler,delay,this.foodObjArr[foodObjArrRound].foodLocation,this.foodObjArr[foodObjArrRound]);
                  foodLocationMc.foodMakeObj = this.foodObjArr[foodObjArrRound];
                  RestaurantMakeFoodTips.getInstance().showFoodMoveTips(3,foodLocation,foodInfo,delay);
                  RestaurantMakeFoodTips.getInstance().addBiaoTips(3,foodLocation);
                  RestaurantMakeFoodTips.getInstance().changeBiao(3,foodLocation,foodInfo,int(delay / 1000));
               }
            }
            else if(foodState == 1)
            {
               RestaurantMakeFoodTips.getInstance().addYunTips(foodLocation,foodInfo);
               RestaurantMakeFoodTips.getInstance().showFoodMoveTips(1,foodLocation,foodInfo);
            }
            else if(foodState == 2)
            {
               RestaurantMakeFoodTips.getInstance().addYunTips(foodLocation,foodInfo);
               RestaurantMakeFoodTips.getInstance().showFoodMoveTips(2,foodLocation,foodInfo);
            }
            LocationByType = int(this.foodObjArr[foodObjArrRound].foodLocation);
            if(LocationByType >= RestaurantView.getInstance().LocationByStove && LocationByType <= RestaurantView.getInstance().LocationByMove)
            {
               if(this.restaurantBeen.isMyRestaurant())
               {
                  this.addZaobtn(this.restaurantBeen.getRestaurantMC().buttonLevel["zaoBtn" + foodLocationMc.foodMakeObj.foodLocation]);
               }
            }
            if(this.foodObjArr[foodObjArrRound].foodLocation > RestaurantView.getInstance().LocationByMove && this.restaurantBeen.isMyRestaurant())
            {
               this.addTaiBtn(this.restaurantBeen.getRestaurantMC().buttonLevel["taiBtn" + foodLocationMc.foodMakeObj.foodLocation]);
            }
            RestaurantView.getInstance().loadMcAndObj(this.foodMakePath + foodId + ".swf",this.foodObjArr[foodObjArrRound]);
         }
      }
      
      private function onFoodMakeTimerHandler(foodLocation:int, obj:Object) : void
      {
         var foodInfo:Object = null;
         var soundLib:soundControl = null;
         var foodSuccess:Class = null;
         var delay:int = 0;
         GC.clearGInterval(obj.foodMakeTimer);
         var currentTable:MovieClip = this.restaurantBeen.getRestaurantMC().depth_mc["foodTable" + foodLocation];
         if(currentTable.foodMakeObj != null)
         {
            foodInfo = GoodsInfo.getInfoById(currentTable.foodMakeObj.itemId);
            if(currentTable.foodMakeObj.foodState == 3)
            {
               MovieClip(currentTable.getChildByName("mc")).gotoAndStop(4);
               soundLib = new soundControl();
               foodSuccess = GV.Lib_Map.getClass("foodSuccess") as Class;
               soundLib.getSound(foodSuccess,0);
               currentTable.foodMakeObj.foodState = 4;
               delay = foodInfo.Timeout * 1000;
               GC.clearGInterval(currentTable.foodMakeObj.foodMakeTimer);
               currentTable.foodMakeObj.foodMakeTimer = GC.setGInterval(this.onFoodMakeTimerHandler,delay,currentTable.foodMakeObj.foodLocation,currentTable.foodMakeObj);
            }
            else if(currentTable.foodMakeObj.foodState == 4)
            {
               GC.clearGInterval(currentTable.foodMakeObj.foodMakeTimer);
               MovieClip(currentTable.getChildByName("mc")).gotoAndStop(5);
               RestaurantMakeFoodTips.getInstance().removeBiaoTips(foodLocation);
               currentTable.foodMakeObj.foodState = 5;
               currentTable.foodMakeObj.foodMakeTimer = null;
            }
         }
      }
      
      public function makeFood(type:int) : void
      {
         var foodMakeMc:* = undefined;
         var loadGame:LoadGame = null;
         var mess:String = null;
         var foodInfo:Object = null;
         var currenTimer:int = 0;
         var makeCurrenTimer:int = 0;
         var checkMoveLocationSign:int = 0;
         var zhe:MovieClip = null;
         foodMakeMc = this.restaurantBeen.getRestaurantMC().depth_mc["foodTable" + type];
         trace(this.restaurantBeen.getRestaurantMC().depth_mc["foodTable" + type].numChildren);
         if(!foodMakeMc.foodMakeObj)
         {
            this.selectFoodLocation = type;
            BC.addEvent(this,GV.onlineSocket,"SelectFoodOver",this.selectFoodOver);
            loadGame = new LoadGame("module/external/restaurantMenuMain.swf","正在加載食譜",MainManager.getGameLevel());
            loadGame = null;
         }
         else
         {
            foodInfo = GoodsInfo.getInfoById(foodMakeMc.foodMakeObj.itemId);
            if(foodMakeMc.foodMakeObj.foodState == 3)
            {
               currenTimer = int(new Date().getTime() / 1000);
               makeCurrenTimer = currenTimer - foodMakeMc.foodMakeObj.foodMakeStartTimer;
               if(makeCurrenTimer < foodInfo.NeedTimer)
               {
                  mess = "你願意支付100摩爾豆包裝費，將菜捐給流浪的拉姆嗎？";
                  this.myalter = GF.showAlert(MainManager.getGameLevel(),mess,"",100,"sure,cancel",true,false,"E");
                  this.myalter.addEventListener(Alert.CLICK_ + "1",function(e:Event):void
                  {
                     restaurantBeen.getRestaurantMC().depth_mc["shuo" + type].visible = true;
                     RestaurantMakeFoodTips.getInstance().removeBiaoTips(type);
                     oneBigStreetSocket.clearFood(foodMakeMc.foodMakeObj.itemId,foodMakeMc.foodMakeObj.foodIndex,type);
                  });
               }
            }
            else if(foodMakeMc.foodMakeObj.foodState == 4)
            {
               checkMoveLocationSign = this.checkMoveLocation(foodMakeMc.foodMakeObj.itemId);
               if(checkMoveLocationSign == 0)
               {
                  mess = "你沒有足夠的餐台來擺放這道菜了，你願意支付100摩爾豆包裝費，將菜捐給流浪的拉姆嗎？";
                  this.myalter = GF.showAlert(MainManager.getGameLevel(),mess,"",100,"sure,cancel",true,false,"E");
                  this.myalter.addEventListener(Alert.CLICK_ + "1",function(e:Event):void
                  {
                     restaurantBeen.getRestaurantMC().depth_mc["shuo" + type].visible = true;
                     RestaurantMakeFoodTips.getInstance().removeBiaoTips(type);
                     oneBigStreetSocket.clearFood(foodMakeMc.foodMakeObj.itemId,foodMakeMc.foodMakeObj.foodIndex,type);
                  });
               }
               else
               {
                  trace("端菜！！！");
                  if(this.restaurantBeen.isMyRestaurant())
                  {
                     zhe = this.restaurantBeen.getRestaurantMC().UI.zheMc;
                     zhe.gotoAndStop(2);
                     GV.MC_AppLever.addChild(zhe);
                  }
                  GC.clearGInterval(foodMakeMc.foodMakeObj.foodMakeTimer);
                  foodMakeMc.foodMakeObj.foodMakeTimer = null;
                  oneBigStreetSocket.moveMakeFoodLocation(foodMakeMc.foodMakeObj.itemId,foodMakeMc.foodMakeObj.foodIndex,type,checkMoveLocationSign);
               }
            }
            else if(foodMakeMc.foodMakeObj.foodState == 5)
            {
               trace("菜糊了！！！");
               mess = "你確定要花費100摩爾豆將燒糊的菜處理掉嗎？";
               this.myalter = GF.showAlert(MainManager.getGameLevel(),mess,"",100,"sure,cancel",true,false,"E");
               this.myalter.addEventListener(Alert.CLICK_ + "1",function(e:Event):void
               {
                  restaurantBeen.getRestaurantMC().depth_mc["shuo" + type].visible = true;
                  RestaurantMakeFoodTips.getInstance().removeBiaoTips(type);
                  oneBigStreetSocket.clearFood(foodMakeMc.foodMakeObj.itemId,foodMakeMc.foodMakeObj.foodIndex,type);
               });
            }
            else
            {
               this.changeFoodState(type);
            }
         }
      }
      
      private function changeFoodState(foodLocation:int) : void
      {
         var foodItemId:int = int(this.restaurantBeen.getRestaurantMC().depth_mc["foodTable" + foodLocation].foodMakeObj.itemId);
         var foodIndex:int = int(this.restaurantBeen.getRestaurantMC().depth_mc["foodTable" + foodLocation].foodMakeObj.foodIndex);
         oneBigStreetSocket.setMakeFoodState(foodItemId,foodIndex);
      }
      
      private function selectFoodOver(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"SelectFoodOver",this.selectFoodOver);
         var selectFoodItemId:int = int(evt.EventObj.itemId);
         oneBigStreetSocket.makeFood(selectFoodItemId,this.selectFoodLocation);
      }
      
      private function checkMoveLocation(itemId:int) : int
      {
         var foodMakeMc:* = undefined;
         var ret:int = 0;
         var foodLocation:int = RestaurantView.getInstance().LocationByMove + 1;
         var itemIdObj:Object = GoodsInfo.getInfoById(this.restaurantBeen.getRestaurantInfo().houseInfo.houseInnerStyle);
         var endRound:int = RestaurantView.getInstance().LocationByMove + itemIdObj.FoodTable;
         var isRepeat:int = this.checkFoodRepeat(itemId);
         if(isRepeat == 0)
         {
            while(foodLocation <= endRound)
            {
               foodMakeMc = this.restaurantBeen.getRestaurantMC().depth_mc["foodTable" + foodLocation];
               if(foodMakeMc.foodMakeObj == null)
               {
                  ret = foodLocation;
                  break;
               }
               foodLocation += 1;
            }
         }
         else
         {
            ret = isRepeat;
         }
         return ret;
      }
      
      private function checkFoodRepeat(itemId:int) : int
      {
         var foodMakeMc:* = undefined;
         var foodInfo:Object = null;
         var ret:int = 0;
         var foodLocation:int = RestaurantView.getInstance().LocationByMove + 1;
         var itemIdObj:Object = GoodsInfo.getInfoById(this.restaurantBeen.getRestaurantInfo().houseInfo.houseInnerStyle);
         var endRound:int = RestaurantView.getInstance().LocationByMove + itemIdObj.FoodTable;
         while(foodLocation <= endRound)
         {
            foodMakeMc = this.restaurantBeen.getRestaurantMC().depth_mc["foodTable" + foodLocation];
            if(foodMakeMc.foodMakeObj != null && foodMakeMc.foodMakeObj.itemId == itemId)
            {
               foodInfo = GoodsInfo.getInfoById(foodMakeMc.foodMakeObj.itemId);
               ret = foodLocation;
               foodMakeMc.foodMakeObj.foodCount += foodInfo.Count;
               break;
            }
            foodLocation += 1;
         }
         return ret;
      }
      
      private function changeFoodArrLocation(foodMcobj:Object) : void
      {
         var foodArr:Array = this.restaurantBeen.getRestaurantInfo().houseFoodInfo.foodArr;
         for(var f:int = 0; f < foodArr.length; f++)
         {
            if(foodArr[f].foodIndex == foodMcobj.foodIndex)
            {
               foodArr[f].foodLocation = foodMcobj.foodLocation;
               foodArr[f].foodState = 6;
               break;
            }
         }
      }
      
      private function addFoodArrBuItemId(mcobj:Object) : int
      {
         var ret:int = 0;
         var foodArr:Array = this.restaurantBeen.getRestaurantInfo().houseFoodInfo.foodArr;
         for(var f:int = 0; f < foodArr.length; f++)
         {
            if(foodArr[f].foodLocation == mcobj.foodLocation)
            {
               foodArr[f].foodCount = mcobj.foodCount;
               foodArr[f].foodIndex = mcobj.foodIndex;
               ret = int(foodArr[f].foodCount);
               break;
            }
         }
         return ret;
      }
      
      public function moveMakeFood(evt:EventTaomee) : void
      {
         var foodToLocation:int = int(evt.EventObj.foodToLocation);
         var foodLocation:int = int(evt.EventObj.foodLocation);
         var foodMakeMC:MovieClip = this.restaurantBeen.getRestaurantMC().depth_mc["foodTable" + foodLocation];
         this.restaurantBeen.setAddFoodCount(evt.EventObj.addFoodCount);
         if(this.restaurantBeen.getRestaurantMC().depth_mc["foodTable" + foodToLocation].foodMakeObj != null)
         {
            this.restaurantBeen.getRestaurantMC().depth_mc["foodTable" + foodToLocation].foodMakeObj.foodCount = evt.EventObj.foodCount;
         }
         this.addFoodArrBuItemId(evt.EventObj);
         var foodMc:MovieClip = foodMakeMC.getChildByName("mc") as MovieClip;
         foodMc.foodMakeObj = foodMakeMC.foodMakeObj;
         foodMc.foodMakeObj.foodState = 6;
         foodMc.foodMakeObj.foodIndex = evt.EventObj.foodIndex;
         foodMc.foodMakeObj.foodCount = evt.EventObj.foodCount;
         foodMc.foodMakeObj.foodLocation = foodToLocation;
         foodMc.gotoAndStop(foodMc.foodMakeObj.foodState);
         this.changeFoodArrLocation(foodMc.foodMakeObj);
         var skillUpEffC:Class = GV.Lib_Map.getClass("skillup") as Class;
         this.skillUpEffCC = new skillUpEffC();
         GV.MAN_PEOPLE.addChild(this.skillUpEffCC);
         this.skillUpEffCC.tipsTxt.value_txt.text = evt.EventObj.exp + "";
         this.skillUpEffCC.gotoAndPlay(2);
         RestaurantMakeFoodTips.getInstance().removeBiaoTips(foodLocation);
         RestaurantMakeFoodTips.getInstance().removeFoodMoveTips(foodLocation);
         this.restaurantBeen.getRestaurantMC().depth_mc["shuo" + foodLocation].visible = true;
         this.removeZaobtn(this.restaurantBeen.getRestaurantMC().buttonLevel["zaoBtn" + foodLocation]);
         this.p = GF.getPeopleByID(this.restaurantBeen.getRestaurantInfo().houseInfo.houseUserId);
         this.p.avatarMC.addChild(foodMc);
         var pointMc:MovieClip = this.restaurantBeen.getRestaurantMC().buttonLevel["point" + foodToLocation];
         var px:int = pointMc.x;
         var py:int = pointMc.y;
         GC.clearAll(foodMakeMC.getChildByName("mc"));
         foodMakeMC.foodMakeObj = null;
         BC.addEvent(this,this.p,PeopleManageView.ON_GO_OVER,this.onMoveToOver);
         MoveTo.AutoFind(px,py,this.p);
      }
      
      private function onMoveToOver(evt:Event) : void
      {
         var zhe:MovieClip = null;
         var empArr:Array = null;
         var mess:String = null;
         BC.removeEvent(this,this.p,PeopleManageView.ON_GO_OVER,this.onMoveToOver);
         var foodArr:Array = this.restaurantBeen.getRestaurantInfo().houseFoodInfo.foodArr;
         var foodMc:MovieClip = evt.currentTarget.avatarMC.getChildByName("mc");
         var foodObj:Object = foodMc.foodMakeObj;
         this.addFoodArrBuItemId(foodObj);
         if(this.checkHaveFood(foodObj) == false)
         {
            foodArr.unshift(foodObj);
         }
         GC.clearAll(foodMc);
         foodMc.gotoAndStop(foodMc.foodMakeObj.foodState);
         foodMc.x = -this.restaurantBeen.getRestaurantMC().depth_mc["foodTable" + foodMc.foodMakeObj.foodLocation].width;
         foodMc.y = -this.restaurantBeen.getRestaurantMC().depth_mc["foodTable" + foodMc.foodMakeObj.foodLocation].height;
         this.restaurantBeen.getRestaurantMC().depth_mc["foodTable" + foodMc.foodMakeObj.foodLocation].foodMakeObj = foodObj;
         var foodTableMc:MovieClip = this.restaurantBeen.getRestaurantMC().depth_mc["foodTable" + foodMc.foodMakeObj.foodLocation];
         if(foodTableMc.getChildByName("mc") == null)
         {
            this.restaurantBeen.getRestaurantMC().depth_mc["foodTable" + foodMc.foodMakeObj.foodLocation].addChild(foodMc);
         }
         var skillUpEffC:Class = GV.Lib_Map.getClass("skillupCount") as Class;
         this.skillUpEffU = new skillUpEffC();
         foodTableMc.addChild(this.skillUpEffU);
         this.skillUpEffU.tipsTxt.value_txt.text = this.restaurantBeen.getAddFoodCount() + "";
         this.skillUpEffU.gotoAndPlay(2);
         foodMc.foodMakeObj = null;
         if(this.restaurantBeen.isMyRestaurant())
         {
            zhe = this.restaurantBeen.getRestaurantMC().UI.zheMc;
            zhe.gotoAndStop(1);
            GV.MC_AppLever.removeChild(zhe);
         }
         if(this.restaurantBeen.isMyRestaurant())
         {
            this.addTaiBtn(this.restaurantBeen.getRestaurantMC().buttonLevel["taiBtn" + foodObj.foodLocation]);
            empArr = RestaurantBeen.getInstance().getRestaurantInfo().housePeopleInfo.peopArr;
            if(empArr.length < 1)
            {
               mess = "你還沒有僱傭員工哦！趕快僱傭一個員工為你端菜吧！";
               this.myalter = GF.showAlert(MainManager.getGameLevel(),mess,"",100,"iknow",true,false,"E");
               this.myalter.addEventListener("CLICK" + 1,this.openEmpPanel);
            }
         }
      }
      
      private function openEmpPanel(evt:Event) : void
      {
         this.myalter.removeEventListener("CLICK" + 1,this.openEmpPanel);
         var loadGame:LoadGame = new LoadGame("module/external/restaurantEmployePanelMain.swf","正在加載僱傭面板",MainManager.getGameLevel());
         loadGame = null;
      }
      
      private function checkHaveFood(foodObj:Object) : Boolean
      {
         var ret:Boolean = false;
         var foodArr:Array = this.restaurantBeen.getRestaurantInfo().houseFoodInfo.foodArr;
         var count:int = 0;
         for(var x:int = 0; x < foodArr.length; x++)
         {
            if(foodObj.foodIndex == foodArr[x].foodIndex)
            {
               count++;
               if(count == 2)
               {
                  foodArr.splice(x,1);
                  break;
               }
            }
         }
         for(var r:int = 0; r < foodArr.length; r++)
         {
            if(foodArr[r].foodIndex == foodObj.foodIndex)
            {
               ret = true;
               break;
            }
         }
         return ret;
      }
      
      private function foodMakeTimerHanler(evt:MouseEvent) : void
      {
         var foodInfo:Object = null;
         var makeCurrenTimer:int = 0;
         var currenTimer:int = 0;
         var surplusTimer:int = 0;
         var percentage:int = 0;
         var trashTimer:int = 0;
         var location:int = int(String(evt.currentTarget.name).slice(6));
         var currentTable:MovieClip = this.restaurantBeen.getRestaurantMC().depth_mc["foodTable" + location];
         if(currentTable.foodMakeObj != null)
         {
            foodInfo = GoodsInfo.getInfoById(currentTable.foodMakeObj.itemId);
            if(evt.type == MouseEvent.MOUSE_OVER)
            {
               if(currentTable.foodMakeObj.foodState == 1)
               {
                  RestaurantMakeFoodTips.getInstance().showFoodMoveTips(1,location,foodInfo);
               }
               else if(currentTable.foodMakeObj.foodState == 2)
               {
                  RestaurantMakeFoodTips.getInstance().showFoodMoveTips(2,location,foodInfo);
               }
               else
               {
                  makeCurrenTimer = 0;
                  if(currentTable.foodMakeObj.foodMakeStartTimer > 100000000)
                  {
                     currenTimer = int(new Date().getTime() / 1000);
                     makeCurrenTimer = currenTimer - currentTable.foodMakeObj.foodMakeStartTimer;
                  }
                  else
                  {
                     currenTimer = int(new Date().getTime() / 1000);
                     currentTable.foodMakeObj.foodMakeStartTimer = currenTimer - currentTable.foodMakeObj.foodMakeStartTimer;
                     makeCurrenTimer = currenTimer - currentTable.foodMakeObj.foodMakeStartTimer;
                  }
                  surplusTimer = foodInfo.NeedTimer - makeCurrenTimer;
                  percentage = makeCurrenTimer / foodInfo.NeedTimer * 100;
                  if(makeCurrenTimer >= foodInfo.NeedTimer)
                  {
                     trashTimer = foodInfo.Timeout - (makeCurrenTimer - foodInfo.NeedTimer);
                     RestaurantMakeFoodTips.getInstance().showFoodMoveTips(4,location,foodInfo,trashTimer);
                  }
                  else
                  {
                     RestaurantMakeFoodTips.getInstance().showFoodMoveTips(3,location,foodInfo,surplusTimer);
                  }
               }
            }
            else if(evt.type == MouseEvent.MOUSE_OUT)
            {
               RestaurantMakeFoodTips.getInstance().hideFoodMoveTips(location);
            }
         }
      }
      
      public function changeMakeFood(evt:EventTaomee) : void
      {
         var foodMakeObj:Object = evt.EventObj;
         var currentTable:MovieClip = this.restaurantBeen.getRestaurantMC().depth_mc["foodTable" + foodMakeObj.foodLocation];
         currentTable.foodMakeObj = foodMakeObj;
         if(this.restaurantBeen.isMyRestaurant())
         {
            LocalUserInfo.setYXQ(evt.EventObj.money);
         }
         RestaurantMakeFoodTips.getInstance().addMakeFoodTips(currentTable.foodMakeObj);
         RestaurantMakeFoodTips.getInstance().changeFoodState(currentTable.foodMakeObj);
         this.addZaobtn(this.restaurantBeen.getRestaurantMC().buttonLevel["zaoBtn" + currentTable.foodMakeObj.foodLocation]);
      }
      
      public function foodState3Timer(foodMakeObj:Object) : void
      {
         var currentTable:MovieClip = this.restaurantBeen.getRestaurantMC().depth_mc["foodTable" + foodMakeObj.foodLocation];
         var foodInfo:Object = GoodsInfo.getInfoById(currentTable.foodMakeObj.itemId);
         currentTable.foodMakeObj.foodMakeStartTimer = int(new Date().getTime() / 1000);
         var delay:int = foodInfo.NeedTimer * 1000;
         GC.clearGInterval(currentTable.foodMakeObj.foodMakeTimer);
         currentTable.foodMakeObj.foodMakeTimer = GC.setGInterval(this.onFoodMakeTimerHandler,delay,currentTable.foodMakeObj.foodLocation,currentTable.foodMakeObj);
      }
      
      public function onClearFoodHandler(evt:EventTaomee) : void
      {
         if(this.restaurantBeen.isMyRestaurant())
         {
            LocalUserInfo.setYXQ(evt.EventObj.money);
         }
         var foodArr:Array = this.restaurantBeen.getRestaurantInfo().houseFoodInfo.foodArr;
         var foodLocation:int = int(evt.EventObj.foodLocation);
         var foodMakeMc:* = this.restaurantBeen.getRestaurantMC().depth_mc["foodTable" + foodLocation];
         if(foodLocation > 50 && foodLocation < 101)
         {
            this.removeTaiBtn(this.restaurantBeen.getRestaurantMC().buttonLevel["taiBtn" + foodMakeMc.foodMakeObj.foodLocation]);
         }
         else if(foodLocation > 0 && foodLocation < 51)
         {
            this.removeZaobtn(this.restaurantBeen.getRestaurantMC().buttonLevel["zaoBtn" + foodMakeMc.foodMakeObj.foodLocation]);
         }
         for(var f:int = 0; f < foodArr.length; f++)
         {
            if(foodArr[f].foodLocation == foodLocation)
            {
               foodArr.splice(f,1);
               break;
            }
         }
         GC.clearGInterval(foodMakeMc.foodMakeObj.foodMakeTimer);
         foodMakeMc.foodMakeObj.foodMakeTimer = null;
         trace(foodMakeMc.getChildByName("mc"));
         GC.clearAll(foodMakeMc.getChildByName("mc"));
         foodMakeMc.foodMakeObj = null;
      }
      
      private function onShowFoodCOunt(evt:MouseEvent) : void
      {
         var fr:int = 0;
         var foodName:String = null;
         var foodCount:int = 0;
         var tipsS:String = null;
         var location:int = int(String(evt.currentTarget.name).slice(6));
         var foodObj:Object = this.restaurantBeen.getRestaurantInfo().houseFoodInfo;
         var foodObjArr:Array = foodObj.foodArr as Array;
         if(evt.type == MouseEvent.MOUSE_OVER)
         {
            for(fr = 0; fr < foodObjArr.length; fr++)
            {
               if(foodObjArr[fr].foodLocation == location)
               {
                  foodName = GoodsInfo.getItemNameByID(foodObjArr[fr].itemId);
                  foodCount = int(foodObjArr[fr].foodCount);
                  tipsS = foodName + " 還剩: " + foodCount + "份";
                  GF.showTip(tipsS);
               }
            }
         }
         else if(evt.type == MouseEvent.MOUSE_OUT)
         {
            GF.clearTip();
         }
      }
      
      public function addZaobtn(mc:MovieClip) : void
      {
         BC.addEvent(this,mc,MouseEvent.MOUSE_OVER,this.foodMakeTimerHanler);
         BC.addEvent(this,mc,MouseEvent.MOUSE_OUT,this.foodMakeTimerHanler);
      }
      
      public function removeZaobtn(mc:MovieClip) : void
      {
         BC.removeEvent(this,mc,MouseEvent.MOUSE_OVER,this.foodMakeTimerHanler);
         BC.removeEvent(this,mc,MouseEvent.MOUSE_OUT,this.foodMakeTimerHanler);
      }
      
      public function addTaiBtn(mc:MovieClip) : void
      {
         BC.addEvent(this,mc,MouseEvent.MOUSE_OVER,this.onShowFoodCOunt);
         BC.addEvent(this,mc,MouseEvent.MOUSE_OUT,this.onShowFoodCOunt);
      }
      
      public function removeTaiBtn(mc:MovieClip) : void
      {
         BC.removeEvent(this,mc,MouseEvent.MOUSE_OVER,this.onShowFoodCOunt);
         BC.removeEvent(this,mc,MouseEvent.MOUSE_OUT,this.onShowFoodCOunt);
      }
      
      public function clearFoodTimer() : void
      {
         var depth_mc:MovieClip = this.restaurantBeen.getRestaurantMC().depth_mc;
         var houseStoveNum:int = int(this.restaurantBeen.getRestaurantInfo().houseInfo.houseStoveNum);
         for(var ft:int = 1; ft <= houseStoveNum; ft++)
         {
            if(depth_mc["foodTable" + ft].foodMakeObj != null && depth_mc["foodTable" + ft].foodMakeObj.foodMakeTimer != null)
            {
               GC.clearGInterval(depth_mc["foodTable" + ft].foodMakeObj.foodMakeTimer);
            }
         }
      }
      
      public function removeZheMc() : void
      {
         var zhe:MovieClip = null;
         if(this.restaurantBeen.isMyRestaurant())
         {
            zhe = this.restaurantBeen.getRestaurantMC().UI.zheMc;
            zhe.gotoAndStop(1);
            GV.MC_AppLever.removeChild(zhe);
         }
      }
      
      public function destroy() : void
      {
         if(Boolean(this.skillUpEffCC))
         {
            GV.MAN_PEOPLE.removeChild(this.skillUpEffCC);
         }
         RestaurantFood.instance = null;
      }
   }
}

