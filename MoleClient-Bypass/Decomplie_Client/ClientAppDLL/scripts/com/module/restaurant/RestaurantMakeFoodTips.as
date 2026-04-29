package com.module.restaurant
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.soundControl.soundControl;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.net.URLRequest;
   
   public class RestaurantMakeFoodTips
   {
      
      private static var instance:RestaurantMakeFoodTips;
      
      private static var canotNew:Boolean = true;
      
      private var mft:MovieClip;
      
      private var mc_Class:Class;
      
      public const foodMakePath:String = "resource/restaurant/swf/";
      
      private var yunLoad:Loader;
      
      private var soundLib:soundControl = new soundControl();
      
      public function RestaurantMakeFoodTips()
      {
         super();
         if(canotNew)
         {
            throw new Error("RestaurantMakeFoodTips不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : RestaurantMakeFoodTips
      {
         if(!instance)
         {
            canotNew = false;
            instance = new RestaurantMakeFoodTips();
            canotNew = true;
         }
         return instance;
      }
      
      public function addMakeFoodTips(foodObj:Object) : void
      {
         this.mc_Class = GV.Lib_Map.getClass("makeFoodTips") as Class;
         this.mft = new this.mc_Class();
         var location:int = int(foodObj.foodLocation);
         this.mft.name = "makeFoodTips" + location;
         this.mft.x = RestaurantBeen.getInstance().getRestaurantMC().buttonLevel["zaoBtn" + location].x;
         this.mft.y = RestaurantBeen.getInstance().getRestaurantMC().buttonLevel["zaoBtn" + location].y;
         if(RestaurantBeen.getInstance().getRestaurantMC().depth_mc.getChildByName("makeFoodTips" + location) == null)
         {
            RestaurantBeen.getInstance().getRestaurantMC().depth_mc.addChild(this.mft);
         }
         trace(RestaurantBeen.getInstance().getRestaurantMC().depth_mc.getChildByName("makeFoodTips" + location));
      }
      
      public function changeFoodState(foodObj:Object) : void
      {
         var location:int = int(foodObj.foodLocation);
         var depth_mc:* = RestaurantBeen.getInstance().getRestaurantMC().depth_mc;
         var makeFoodTipsMc:MovieClip = depth_mc.getChildByName("makeFoodTips" + location) as MovieClip;
         if(foodObj.foodState == 1)
         {
            makeFoodTipsMc.foodObj = foodObj;
            this.zaoBtnMouseEnabled(location,false);
            RestaurantRandomSay.getInstance().randomEmpSay();
            BC.addEvent(this,this.mft.bar,"FoodNext",this.onFoodNext);
            makeFoodTipsMc.bar.gotoAndPlay(3);
         }
         else if(foodObj.foodState == 2)
         {
            makeFoodTipsMc.foodObj = foodObj;
            this.zaoBtnMouseEnabled(location,false);
            BC.addEvent(this,makeFoodTipsMc.bar,"FoodNext",this.onFoodNext);
            makeFoodTipsMc.bar.gotoAndPlay(3);
         }
         else
         {
            makeFoodTipsMc.foodObj = foodObj;
            this.zaoBtnMouseEnabled(location,false);
            BC.addEvent(this,makeFoodTipsMc.bar,"FoodNext",this.onFoodNext);
            makeFoodTipsMc.bar.gotoAndPlay(3);
         }
      }
      
      private function onFoodNext(evt:Event) : void
      {
         var downPot:Class = null;
         var downFood:Class = null;
         var foodOk:Class = null;
         BC.removeEvent(this,evt.currentTarget,"FoodNext",this.onFoodNext);
         var foodObj:Object = evt.currentTarget.parent.foodObj;
         var depth_mc:* = RestaurantBeen.getInstance().getRestaurantMC().depth_mc;
         var makeFoodTipsMc:MovieClip = depth_mc.getChildByName("makeFoodTips" + foodObj.foodLocation) as MovieClip;
         var foodId:int = int(foodObj.itemId);
         var currentTable:MovieClip = depth_mc["foodTable" + foodObj.foodLocation];
         var foodInfo:Object = GoodsInfo.getInfoById(foodId);
         if(foodObj.foodState == 1)
         {
            RestaurantView.getInstance().loadMcAndObj(this.foodMakePath + foodId + ".swf",foodObj);
            depth_mc["shuo" + foodObj.foodLocation].visible = false;
            this.addYunTips(foodObj.foodLocation,foodInfo);
            downPot = GV.Lib_Map.getClass("downPot") as Class;
            this.soundLib.getSound(downPot,0);
         }
         else if(foodObj.foodState == 2)
         {
            MovieClip(currentTable.getChildByName("mc")).gotoAndStop(foodObj.foodState);
            downFood = GV.Lib_Map.getClass("downFood") as Class;
            this.soundLib.getSound(downFood,0);
         }
         else if(foodObj.foodState == 3)
         {
            MovieClip(currentTable.getChildByName("mc")).gotoAndStop(foodObj.foodState);
            RestaurantFood.getInstance().foodState3Timer(foodObj);
            this.removeYunTips(foodObj.foodLocation);
            this.addBiaoTips(3,foodObj.foodLocation);
            this.changeBiao(3,foodObj.foodLocation,foodInfo,foodInfo.NeedTimer);
            foodOk = GV.Lib_Map.getClass("foodOk") as Class;
            this.soundLib.getSound(foodOk,0);
         }
         this.zaoBtnMouseEnabled(foodObj.foodLocation,true);
         this.removeMakeFoodTips(foodObj.foodLocation);
      }
      
      private function zaoBtnMouseEnabled(location:int, sign:Boolean) : void
      {
         RestaurantBeen.getInstance().getRestaurantMC().buttonLevel["zaoBtn" + location].mouseEnabled = sign;
         RestaurantBeen.getInstance().getRestaurantMC().buttonLevel["zaoBtn" + location].mouseChildren = sign;
      }
      
      public function showFoodMoveTips(state:int, location:int, foodInfo:Object = null, surplusTimer:int = 0) : void
      {
         var foodLocationMc:MovieClip = RestaurantBeen.getInstance().getRestaurantMC().depth_mc["foodTable" + location];
         var obj:Object = foodLocationMc.foodMakeObj;
         var fmtMc:MovieClip = RestaurantBeen.getInstance().getRestaurantMC().top_mc.getChildByName("foodMoveTips" + location);
         var yunMc:MovieClip = RestaurantBeen.getInstance().getRestaurantMC().depth_mc.getChildByName("yunTips" + location);
         if(fmtMc == null)
         {
            this.addFoodMoveTips(location,foodInfo,obj.foodState);
         }
         else if(state == 1)
         {
            if(yunMc != null)
            {
               yunMc.visible = false;
            }
            fmtMc.visible = true;
            fmtMc.foodNameTxt.text = "點擊灶台";
            fmtMc.foodStateTxt.text = "放入食材";
         }
         else if(state == 2)
         {
            if(yunMc != null)
            {
               yunMc.visible = false;
            }
            fmtMc.visible = true;
            fmtMc.foodNameTxt.text = "點擊灶台";
            fmtMc.foodStateTxt.text = "開始製作";
         }
         else
         {
            fmtMc.visible = true;
            if(yunMc != null)
            {
               this.removeYunTips(location);
            }
            fmtMc.foodNameTxt.text = foodInfo.Name;
            if(state == 3)
            {
               fmtMc.foodStateTxt.text = this.ChangeTimer(surplusTimer) + "後做好";
            }
            else if(state == 4)
            {
               if(surplusTimer <= 0)
               {
                  fmtMc.foodStateTxt.text = "食物已經做壞了";
               }
               else
               {
                  fmtMc.foodStateTxt.text = this.ChangeTimer(surplusTimer) + "後變壞";
               }
            }
            fmtMc.bar.gotoAndStop(this.ChangeBar(surplusTimer,fmtMc.bar.totalFrames,foodInfo.NeedTimer));
         }
      }
      
      private function addFoodMoveTips(location:int, foodInfo:Object, foodState:Object) : void
      {
         var fmt:Class = GV.Lib_Map.getClass("foodMoveTips") as Class;
         var fmtMc:MovieClip = new fmt();
         fmtMc.visible = false;
         fmtMc.name = "foodMoveTips" + location;
         fmtMc.x = RestaurantBeen.getInstance().getRestaurantMC().buttonLevel["zaoBtn" + location].x;
         fmtMc.y = RestaurantBeen.getInstance().getRestaurantMC().buttonLevel["zaoBtn" + location].y;
         RestaurantBeen.getInstance().getRestaurantMC().top_mc.addChild(fmtMc);
         trace(RestaurantBeen.getInstance().getRestaurantMC().top_mc.getChildByName("foodMoveTips" + location));
      }
      
      public function addYunTips(location:int, foodInfo:Object) : void
      {
         var yunMc:MovieClip = null;
         var yun:Class = GV.Lib_Map.getClass("yunTips") as Class;
         yunMc = new yun();
         yunMc.name = "yunTips" + location;
         yunMc.x = RestaurantBeen.getInstance().getRestaurantMC().buttonLevel["zaoBtn" + location].x;
         yunMc.y = RestaurantBeen.getInstance().getRestaurantMC().buttonLevel["zaoBtn" + location].y;
         RestaurantBeen.getInstance().getRestaurantMC().depth_mc.addChild(yunMc);
         trace(RestaurantBeen.getInstance().getRestaurantMC().depth_mc.getChildByName("yunTips" + location));
         this.yunLoad = new Loader();
         this.yunLoad.contentLoaderInfo.addEventListener(Event.COMPLETE,function(E:Event):void
         {
            var foodMc:MovieClip = E.currentTarget.content.mc as MovieClip;
            foodMc.gotoAndStop(6);
         });
         this.yunLoad.load(new URLRequest(this.foodMakePath + foodInfo.ID + ".swf"));
         yunMc.show.addChild(this.yunLoad);
      }
      
      public function addBiaoTips(state:int, location:int) : void
      {
         var biao:Class = GV.Lib_Map.getClass("biaoTips") as Class;
         var biaoMc:MovieClip = new biao();
         biaoMc.name = "biaoTips" + location;
         biaoMc.x = RestaurantBeen.getInstance().getRestaurantMC().buttonLevel["zaoBtn" + location].x;
         biaoMc.y = RestaurantBeen.getInstance().getRestaurantMC().buttonLevel["zaoBtn" + location].y;
         if(RestaurantBeen.getInstance().getRestaurantMC().depth_mc.getChildByName("biaoTips" + location) == null)
         {
            RestaurantBeen.getInstance().getRestaurantMC().depth_mc.addChild(biaoMc);
         }
         trace(RestaurantBeen.getInstance().getRestaurantMC().depth_mc.getChildByName("biaoTips" + location));
      }
      
      public function changeBiao(state:int, location:int, foodInfo:Object, surplusTimer:int) : void
      {
         var biaoMc:MovieClip = RestaurantBeen.getInstance().getRestaurantMC().depth_mc.getChildByName("biaoTips" + location);
         if(state == 3)
         {
            biaoMc.gotoAndStop(3);
            biaoMc.gotoAndStop(1);
            biaoMc.timer = GC.setGTimeout(this.onBiaoMcTimer,1000,biaoMc,surplusTimer,foodInfo);
         }
         else if(state == 4)
         {
            biaoMc.gotoAndStop(3);
            biaoMc.gotoAndStop(2);
         }
      }
      
      private function onBiaoMcTimer(biaoMc:MovieClip, surplusTimer:int, foodInfo:Object) : void
      {
         var fr:int = 0;
         surplusTimer -= 1;
         var biaoMctotalFrames:int = int(biaoMc.zhong.totalFrames);
         if(surplusTimer > 0)
         {
            fr = this.ChangeBar(surplusTimer,biaoMctotalFrames,foodInfo.NeedTimer);
            biaoMc.zhong.gotoAndStop(fr);
            biaoMc.timer = GC.setGTimeout(this.onBiaoMcTimer,1000,biaoMc,surplusTimer,foodInfo);
         }
         else
         {
            GC.clearGInterval(biaoMc.timer);
            biaoMc.gotoAndStop(3);
            biaoMc.gotoAndStop(2);
         }
      }
      
      public function hideFoodMoveTips(location:int) : void
      {
         var depth_mc:* = RestaurantBeen.getInstance().getRestaurantMC().depth_mc;
         var top_mc:* = RestaurantBeen.getInstance().getRestaurantMC().top_mc;
         var fmtMc:MovieClip = top_mc.getChildByName("foodMoveTips" + location) as MovieClip;
         var yunMc:MovieClip = depth_mc.getChildByName("yunTips" + location) as MovieClip;
         if(fmtMc != null)
         {
            fmtMc.visible = false;
         }
         if(yunMc != null)
         {
            yunMc.visible = true;
         }
      }
      
      private function ChangeTimer(timer:int) : String
      {
         var ret:String = "";
         var fenzhong:int = Math.ceil(timer / 60);
         var xiaoshi:int = fenzhong / 60;
         var h:int = fenzhong % 60;
         if(xiaoshi < 1)
         {
            ret = fenzhong + "分鐘";
         }
         else if(h < 1)
         {
            ret = xiaoshi + "小時";
         }
         else
         {
            ret = xiaoshi + "小時" + h + "分鐘";
         }
         return ret;
      }
      
      private function ChangeBar(timer:int, barTotalFrames:int, NeedTimer:int) : int
      {
         var ret:int = 0;
         var needM:int = Math.ceil(NeedTimer / 60);
         var timerM:int = Math.ceil(timer / 60);
         return int(barTotalFrames - Math.ceil(barTotalFrames / (needM / timerM)));
      }
      
      public function removeFoodMoveTips(location:int) : void
      {
         var top_mc:* = RestaurantBeen.getInstance().getRestaurantMC().top_mc;
         var fmtMc:MovieClip = top_mc.getChildByName("foodMoveTips" + location) as MovieClip;
         if(fmtMc != null)
         {
            top_mc.removeChild(fmtMc);
         }
      }
      
      public function removeMakeFoodTips(location:int) : void
      {
         var depth_mc:* = RestaurantBeen.getInstance().getRestaurantMC().depth_mc;
         var makeFoodTipsMc:MovieClip = depth_mc.getChildByName("makeFoodTips" + location) as MovieClip;
         depth_mc.removeChild(makeFoodTipsMc);
      }
      
      public function removeYunTips(location:int) : void
      {
         var depth_mc:* = RestaurantBeen.getInstance().getRestaurantMC().depth_mc;
         var yunMc:MovieClip = RestaurantBeen.getInstance().getRestaurantMC().depth_mc.getChildByName("yunTips" + location);
         depth_mc.removeChild(yunMc);
      }
      
      public function removeBiaoTips(location:int) : void
      {
         var depth_mc:* = RestaurantBeen.getInstance().getRestaurantMC().depth_mc;
         var biaoMc:MovieClip = RestaurantBeen.getInstance().getRestaurantMC().depth_mc.getChildByName("biaoTips" + location);
         if(biaoMc != null)
         {
            if(biaoMc.timer != null)
            {
               GC.clearGInterval(biaoMc.timer);
            }
            depth_mc.removeChild(biaoMc);
         }
      }
      
      public function clearBiaoMcTimer() : void
      {
         var biaoMc:MovieClip = null;
         var depth_mc:MovieClip = RestaurantBeen.getInstance().getRestaurantMC().depth_mc;
         var houseStoveNum:int = int(RestaurantBeen.getInstance().getRestaurantInfo().houseInfo.houseStoveNum);
         for(var ft:int = 1; ft <= houseStoveNum; ft++)
         {
            biaoMc = RestaurantBeen.getInstance().getRestaurantMC().depth_mc.getChildByName("biaoTips" + ft);
            if(biaoMc != null && biaoMc.timer != null)
            {
               GC.clearGInterval(biaoMc.timer);
               depth_mc.removeChild(biaoMc);
            }
         }
      }
      
      public function initshuo() : void
      {
         var depth_mc:MovieClip = RestaurantBeen.getInstance().getRestaurantMC().depth_mc;
         var houseStoveNum:int = int(RestaurantBeen.getInstance().getRestaurantInfo().houseInfo.houseStoveNum);
         for(var ft:int = 1; ft <= houseStoveNum; ft++)
         {
            if(!RestaurantBeen.getInstance().isMyRestaurant())
            {
               depth_mc["shuo" + ft].visible = false;
            }
         }
      }
      
      public function destroy() : void
      {
         RestaurantMakeFoodTips.instance = null;
      }
   }
}

