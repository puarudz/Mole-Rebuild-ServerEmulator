package com.module.home
{
   import com.common.Alert.*;
   import com.event.EventTaomee;
   import com.logic.MapManageLogic.MapDepthManageLogic;
   import com.logic.MapManageLogic.MapManageLogic;
   import com.logic.socket.home.GetHomeInfoReq;
   import com.logic.socket.home.GetHomeInfoRes;
   import com.module.home.special.HomeSpecialGoods;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class HomeEditView extends MovieClip
   {
      
      private static var instance:HomeEditView;
      
      public static var Editable:Boolean = false;
      
      public var changed:Boolean = false;
      
      public var RootMC:*;
      
      public var HomeObj:*;
      
      public var homeItemArr:Array;
      
      public var loadComplete:Boolean = false;
      
      public var loadNum:Number = 0;
      
      public var actionGoods:*;
      
      public var movingMC:MovieClip;
      
      public var parentMC:MovieClip;
      
      public var backDepot:Boolean = false;
      
      public var backOldPos:Boolean = false;
      
      public var oldx:Number;
      
      public var oldy:Number;
      
      public var oldIndex:int;
      
      public var index:int;
      
      public var goodsNum:uint;
      
      public var arry:Array = [];
      
      public function HomeEditView()
      {
         super();
      }
      
      public static function getInstance() : HomeEditView
      {
         if(instance == null)
         {
            instance = new HomeEditView();
         }
         return instance;
      }
      
      public function setValue(obj:*, root:*) : void
      {
         this.RootMC = root;
         this.HomeObj = obj;
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         BC.addEvent(this,GV.onlineSocket,GetHomeInfoRes.SAVE_HOME_USED_SUCC,this.SaveUsedGoodSucc);
         this.homeItemArr = this.HomeObj.itemArr;
         this.loadGoodsInHome();
      }
      
      private function loadGoodsInHome() : void
      {
         var len:uint = this.homeItemArr.length;
         this.goodsNum = len;
         trace("--------加載家園裡已經有的物品並顯示,有物品數量：",len);
         for(var i:uint = 0; i < len; i++)
         {
            this.homeItemArr[i].num = i;
            if(this.homeItemArr[i].Layer == 4 || this.homeItemArr[i].Layer == 6)
            {
               this.loadGoods(this.homeItemArr[i]);
            }
         }
         if(len == 0)
         {
            this.loadComplete = true;
         }
      }
      
      public function loadGoods(temp:Object) : void
      {
         var tempmc:MovieClip = new MovieClip();
         tempmc.name = "g" + temp.num;
         tempmc.num = temp.num;
         tempmc.ID = temp.ID;
         tempmc.PosX = temp.PosX;
         tempmc.PosY = temp.PosY;
         tempmc.Direction = temp.Direction;
         tempmc.Visible = temp.Visible;
         tempmc.Layer = temp.Layer;
         tempmc.Other = temp.Other;
         var tempLoader:Loader = new Loader();
         tempLoader.load(VL.getURLRequest("resource/home/item/swf/" + temp.ID + ".swf"));
         if(temp.Layer == 4)
         {
            this.RootMC.depth_mc.addChild(tempmc);
         }
         else if(temp.Layer == 6)
         {
            this.RootMC.floor_mc.addChild(tempmc);
         }
         tempmc.addChild(tempLoader);
         tempmc.addEventListener(Event.REMOVED_FROM_STAGE,this.removeFromStage);
         tempLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.completeHandler);
      }
      
      private function removeFromStage(evt:Event) : void
      {
      }
      
      public function loadNewGoods(temp:Object) : void
      {
         trace("loadGoodSWF加載單個物品");
         ++this.goodsNum;
         this.changed = true;
         var tempObj:Object = {
            "ID":temp.ID,
            "PosX":620,
            "PosY":300,
            "Direction":1,
            "Visible":1,
            "Layer":temp.Layer,
            "Type":temp.Type,
            "num":this.homeItemArr.length,
            "Other":0
         };
         this.homeItemArr.push(tempObj);
         this.loadGoods(tempObj);
      }
      
      public function completeHandler(e:Event) : void
      {
         this.isAllGoodsLoaded();
         var goodsMC:Object = e.target.content;
         var movingmc:Object = goodsMC.parent.parent;
         movingmc.x = movingmc.PosX;
         movingmc.y = movingmc.PosY;
         if(Boolean(movingmc.Rotation))
         {
            movingmc.rotation = movingmc.Rotation;
         }
         goodsMC.mc1.gotoAndStop(movingmc.Direction);
         goodsMC.mc2.gotoAndStop(movingmc.Direction);
         goodsMC.ID = movingmc.ID;
         goodsMC.num = movingmc.num;
         goodsMC.Other = movingmc.Other;
         BC.addEvent(this,goodsMC,"save_home_succ",this.initSpecialGood);
         HomeSpecialGoods.specialgood(goodsMC);
         if(movingmc.Visible == 0)
         {
            movingmc.Visible = 1;
         }
         setTimeout(this.gotoVisible,1000,goodsMC.mc2,movingmc);
         goodsMC.moving = false;
         if(HomeView.ismyhome)
         {
            goodsMC.btn.addEventListener(MouseEvent.CLICK,this.startdrag);
         }
      }
      
      public function initSpecialGood(e:Event) : void
      {
         HomeSpecialGoods.specialgood(e.currentTarget);
      }
      
      public function changeStatus(e:Event) : void
      {
      }
      
      public function startdrag(e:Event) : void
      {
         var topPosition:uint = 0;
         this.changed = true;
         if(Editable)
         {
            this.actionGoods = e.target.parent;
            this.actionGoods.moving = !this.actionGoods.moving;
            if(Boolean(this.actionGoods.moving))
            {
               this.movingMC = this.actionGoods.parent.parent;
               this.parentMC = this.actionGoods.parent.parent.parent;
               this.actionGoods.mc2.y -= 10;
               this.oldIndex = this.parentMC.getChildIndex(this.movingMC);
               this.index = this.movingMC.num;
               topPosition = this.parentMC.numChildren - 1;
               this.parentMC.setChildIndex(this.movingMC,topPosition);
               this.oldx = this.movingMC.x;
               this.oldy = this.movingMC.y;
               this.movingMC.startDrag();
               this.RootMC.addChild(this.movingMC);
               this.RootMC.addEventListener("changeDirection",this.updateDirection);
               this.RootMC.addEventListener("changeVisible",this.updateVisible);
               HomeHitTest.hitTesting(this.actionGoods,this.movingMC);
            }
            else
            {
               this.movingMC.stopDrag();
               this.actionGoods.mc2.y += 10;
               this.index = this.movingMC.num;
               this.homeItemArr[this.index].PosX = this.movingMC.x;
               this.homeItemArr[this.index].PosY = this.movingMC.y;
               this.doAction();
               HomeHitTest.stopHitTesting();
            }
         }
         else
         {
            trace("不在移動物品模式");
         }
      }
      
      private function updateVisible(e:EventTaomee) : void
      {
         this.homeItemArr[this.index].Visible = e.EventObj;
      }
      
      private function updateDirection(e:EventTaomee) : void
      {
         this.homeItemArr[this.index].Direction = e.EventObj;
      }
      
      private function doAction() : void
      {
         trace("----------doAction");
         if(this.movingMC.Layer == 4)
         {
            this.RootMC.depth_mc.addChild(this.movingMC);
         }
         else if(this.movingMC.Layer == 6)
         {
            this.RootMC.floor_mc.addChild(this.movingMC);
         }
         if(HomeHitTest.backOldPos)
         {
            this.movingMC.x = this.oldx;
            this.movingMC.y = this.oldy;
            this.homeItemArr[this.index].x = this.oldx;
            this.homeItemArr[this.index].y = this.oldy;
            this.movingMC.alpha = 1;
            this.parentMC.setChildIndex(this.movingMC,this.oldIndex);
         }
         else
         {
            this.levelCtrl();
         }
         if(HomeHitTest.backDepot)
         {
            this.RootMC.depot_mc.x = 1000;
            this.RootMC.depot_mc.y = 1000;
            this.moveGoodsToDepot();
         }
      }
      
      private function moveGoodsToDepot() : void
      {
         this.removeGoods(this.movingMC);
         dispatchEvent(new EventTaomee("HomeGoodsToDepot",{"obj":this.homeItemArr[this.index]}));
         this.homeItemArr[this.index] = "";
         --this.goodsNum;
      }
      
      private function removeGoods(mc:*) : void
      {
         var ld:Object = mc.getChildAt(0);
         if(ld is Loader)
         {
            if(Boolean(ld.content.mc2))
            {
               GC.stopAllMC(ld.content.mc2);
            }
         }
         if(mc.Layer == 4)
         {
            this.RootMC.depth_mc.removeChild(mc);
         }
         else if(this.movingMC.Layer == 6)
         {
            this.RootMC.floor_mc.removeChild(mc);
         }
      }
      
      private function levelCtrl() : void
      {
         this.arry = new Array();
         if(this.movingMC.Layer == 6)
         {
            this.getarry(this.RootMC.floor_mc);
         }
         else if(this.movingMC.Layer == 4)
         {
            this.getarry(this.RootMC.depth_mc);
         }
      }
      
      private function getarry(parentMC:DisplayObjectContainer) : void
      {
         for(var i:uint = 0; i < parentMC.numChildren; i++)
         {
            this.arry[i] = parentMC.getChildAt(i).y;
         }
         this.sort(parentMC,this.arry);
      }
      
      private function sort(parentMC:DisplayObjectContainer, arr:Array) : void
      {
         var j:uint = 0;
         for(var i:uint = 1; i < arr.length; i++)
         {
            for(j = 1; j < arr.length; j++)
            {
               if(arr[j] < arr[j - 1])
               {
                  arr[j] ^= arr[j - 1];
                  arr[j - 1] ^= arr[j];
                  arr[j] ^= arr[j - 1];
                  parentMC.swapChildrenAt(j,j - 1);
               }
            }
         }
      }
      
      public function gotoVisible() : void
      {
         var mc:MovieClip = null;
         var go:Object = null;
         if(arguments[0].numChildren > 0)
         {
            if(arguments[0].getChildAt(0) is MovieClip)
            {
               if(arguments[0].getChildAt(0).totalFrames != 1)
               {
                  arguments[0].getChildAt(0).gotoAndStop(arguments[1].Visible);
                  mc = arguments[0].getChildAt(0);
                  go = arguments[1].Visible;
                  mc.gotoAndStop(go);
                  if(Boolean(arguments[0].needPet))
                  {
                     arguments[0].getChildAt(0).gotoAndStop(1);
                  }
               }
            }
         }
      }
      
      public function isAllGoodsLoaded() : void
      {
         if(!this.loadComplete)
         {
            ++this.loadNum;
            if(this.loadNum == this.homeItemArr.length)
            {
               this.loadNum = 0;
               this.loadComplete = true;
               MapDepthManageLogic.compositorMapDepth();
            }
         }
      }
      
      public function getgoodsArr() : Array
      {
         var arr:Array = new Array();
         var len:uint = this.homeItemArr.length;
         for(var i:uint = 0; i < len; i++)
         {
            if(this.homeItemArr[i] != "")
            {
               arr.push(this.homeItemArr[i]);
            }
         }
         return arr;
      }
      
      public function changeBG(temp:Object) : void
      {
         this.changed = true;
         this.moveAllGoodsToDepot();
         this.goodsNum = 1;
         var tempObj:Object = {
            "ID":temp.ID,
            "PosX":0,
            "PosY":0,
            "Direction":1,
            "Visible":0,
            "Layer":temp.Layer,
            "Type":temp.Type,
            "Other":0,
            "num":this.homeItemArr.length
         };
         this.homeItemArr = new Array();
         this.homeItemArr.push(tempObj);
         this.loadNewBG(tempObj);
      }
      
      private function loadNewBG(tempObj:Object) : void
      {
         dispatchEvent(new EventTaomee("change_Home_BG",{"obj":tempObj}));
      }
      
      private function moveAllGoodsToDepot() : void
      {
         var len:uint = this.homeItemArr.length;
         for(var i:uint = 0; i < len; i++)
         {
            if(this.homeItemArr[i] != "")
            {
               dispatchEvent(new EventTaomee("HomeGoodsToDepot",{"obj":this.homeItemArr[i]}));
            }
         }
         this.removeAllGoods();
      }
      
      private function removeAllGoods() : void
      {
         var floorChild:DisplayObject = null;
         var loadMc:DisplayObject = null;
         MapManageLogic.removeBackgroud();
         GC.stopAllMC(this.RootMC.depth_mc);
         GC.stopAllMC(this.RootMC.floor_mc);
         for(var ix:int = 0; ix < DisplayObjectContainer(this.RootMC.depth_mc).numChildren; ix++)
         {
            floorChild = DisplayObjectContainer(this.RootMC.depth_mc).getChildAt(ix);
            if(floorChild is DisplayObjectContainer)
            {
               if(DisplayObjectContainer(floorChild).numChildren >= 1)
               {
                  loadMc = DisplayObjectContainer(floorChild).getChildAt(0);
                  if(loadMc is Loader)
                  {
                     Loader(loadMc).unloadAndStop(false);
                  }
               }
            }
         }
         GC.clearChildren(this.RootMC.depth_mc);
         GC.clearChildren(this.RootMC.floor_mc);
         GC.clearChildren(this.RootMC.type_mc);
      }
      
      public function SaveUsedGood() : void
      {
         GetHomeInfoReq.saveHomeUsedGoods(this.getgoodsArr());
      }
      
      private function SaveUsedGoodSucc(e:EventTaomee) : void
      {
         trace("----------SaveUsedGoodSucc");
      }
      
      private function removeEventHandler(E:Event) : void
      {
         this.removeAllGoods();
         instance = null;
         BC.removeEvent(this);
      }
   }
}

