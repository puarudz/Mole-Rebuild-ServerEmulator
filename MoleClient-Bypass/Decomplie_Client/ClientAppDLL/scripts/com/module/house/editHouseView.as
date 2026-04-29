package com.module.house
{
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.socket.lockHome.lockHomeReq;
   import com.logic.switchMapLogic.switchMapLogic;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.module.AppModuleControl;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class editHouseView extends MovieClip
   {
      
      public static var owner:editHouseView;
      
      private var tempLoaderBG:Loader;
      
      private var topLevel:Boolean;
      
      private var myTimeout:*;
      
      private var Kind:int;
      
      private var lockhomereq:lockHomeReq;
      
      private var houseTool:MovieClip;
      
      private var editMode:Boolean = false;
      
      private var houseObj:Object;
      
      public var myeditHouseLogic:*;
      
      public var houseBtnArr:Array;
      
      public var houseGoodsMCArr:Array;
      
      public var houseGoodsArr:Array;
      
      private var RootMC:MovieClip;
      
      public var OnlyMCArr:Array;
      
      public var MCArr:Array;
      
      public var actionGoods:Object;
      
      public var movingMC:*;
      
      public var index:int;
      
      public var isSelf:Boolean;
      
      public var bmd1:BitmapData;
      
      public var bmd2:BitmapData;
      
      public var bmdwall:BitmapData;
      
      public var arry:Array = [];
      
      public var arrmc:Array = [];
      
      public var backDepot:Boolean = false;
      
      public var backOldPos:Boolean = false;
      
      public var oldx:Number;
      
      public var oldy:Number;
      
      public var oldIndex:int;
      
      public var parentMC:MovieClip;
      
      public var Mode:int = -1;
      
      public var UIPosY:Number = 800;
      
      public var lockHome:Number;
      
      public var loadNum:Number = 0;
      
      public var loadComplete:Boolean;
      
      public var bookView:MovieClip;
      
      public var loadBookEvent:MCLoader;
      
      private var bookPanel:AppModuleControl;
      
      public function editHouseView(houseobj:Object, rootmc:MovieClip)
      {
         super();
         this.init(houseobj,rootmc);
      }
      
      public function init(houseobj:Object, rootmc:MovieClip) : void
      {
         owner = this;
         this.lockhomereq = new lockHomeReq();
         this.houseGoodsArr = new Array();
         this.houseGoodsMCArr = new Array();
         this.houseBtnArr = new Array();
         this.houseObj = houseobj;
         this.houseGoodsArr = this.houseObj.itemArr;
         this.RootMC = rootmc;
         this.OnlyMCArr = [this.RootMC.BGMC,this.RootMC.floorBg,this.RootMC.WALL,this.RootMC.bg_up_floor];
         this.MCArr = [this.RootMC.lineMC,this.RootMC.depth_mc,this.RootMC.rugMC,this.RootMC.floorMC,this.RootMC.floorLoadMC,this.RootMC.floorBg,this.RootMC.BGMC];
         this.houseTool = this.RootMC.houseTool;
         this.houseTool.depot_mc.visible = false;
         this.houseTool.wa_mc.visible = false;
         this.houseTool.bu_mc.visible = false;
         this.houseTool.key_mc.visible = false;
         this.initBtn();
         this.loadGoodsInHouse();
         if(this.houseObj.UserID == LocalUserInfo.getUserID())
         {
            this.isSelf = true;
            this.getHitBitMap(1);
            floorViewStatic.addEventListener("changeFloorMap",this.getHitBitMap);
         }
      }
      
      public function loadGoodsInHouse() : void
      {
         var len:uint = this.houseGoodsArr.length;
         for(var i:uint = 0; i < len; i++)
         {
            this.houseGoodsArr[i].num = i;
            if(this.houseGoodsArr[i].Layer >= 100)
            {
               this.loadHouseBG(this.houseGoodsArr[i]);
            }
            else
            {
               this.loadGoods(this.houseGoodsArr[i]);
            }
         }
         if(len == 0)
         {
            this.loadComplete = true;
            GV.onlineSocket.dispatchEvent(new EventTaomee("allGoodsLoaded",this.houseObj));
         }
      }
      
      public function changeHouseBG(temp:Object) : void
      {
         var i:uint;
         var pos:uint = 0;
         var onlyIndex:int = 0;
         var haveBG:Boolean = false;
         for(i = 0; i < this.houseGoodsArr.length; i++)
         {
            if(this.houseGoodsArr[i] != "")
            {
               if(this.houseGoodsArr[i].Layer == temp.Layer)
               {
                  haveBG = true;
                  pos = i;
                  break;
               }
            }
         }
         if(haveBG)
         {
            try
            {
               onlyIndex = this.houseGoodsArr[pos].Layer - 100;
               if(this.OnlyMCArr[onlyIndex].numChildren > 1)
               {
                  this.OnlyMCArr[onlyIndex].removeChild(this.houseGoodsMCArr[pos]);
                  dispatchEvent(new EventTaomee("dispatchGoodsToDepot",{"obj":this.houseGoodsArr[pos]}));
                  this.houseGoodsArr[pos] = "";
                  this.houseGoodsMCArr[pos] = "";
                  this.houseGoodsArr.push(temp);
                  this.loadHouseBG(temp);
               }
            }
            catch(err:Error)
            {
               trace("try error+++++++");
            }
         }
         else
         {
            this.houseGoodsArr.push(temp);
            this.loadHouseBG(temp);
         }
      }
      
      public function loadHouseBG(temp:Object) : void
      {
         var tempmc1:MovieClip = null;
         var temp1:Loader = null;
         ++this.loadNum;
         if(!this.loadComplete)
         {
            if(this.loadNum == this.houseGoodsArr.length)
            {
               GV.onlineSocket.dispatchEvent(new EventTaomee("allGoodsLoaded",this.houseObj));
               this.loadNum = 0;
               this.loadComplete = true;
               this.showSaveGoods(this.houseGoodsArr);
            }
         }
         var tempmc:MovieClip = new MovieClip();
         tempmc.name = "g" + temp.num;
         this.houseGoodsMCArr.push(tempmc);
         tempmc.num = temp.num;
         tempmc.ID = temp.ID;
         tempmc.PosX = temp.PosX;
         tempmc.PosY = temp.PosY;
         tempmc.Direction = temp.Direction;
         tempmc.Visible = temp.Visible;
         tempmc.Layer = temp.Layer;
         tempmc.Reserved = temp.Reserved;
         this.tempLoaderBG = new Loader();
         this.tempLoaderBG.load(VL.getURLRequest("resource/goods/swf/" + temp.ID + ".swf"));
         this.tempLoaderBG.contentLoaderInfo.addEventListener(Event.COMPLETE,this.BGCompleteHandle);
         this.OnlyMCArr[tempmc.Layer - 100].addChild(tempmc);
         if(temp.Layer == 103)
         {
            tempmc1 = new MovieClip();
            temp1 = new Loader();
            temp1.load(VL.getURLRequest("resource/goods/swf/" + temp.ID + ".swf"));
            temp1.contentLoaderInfo.addEventListener(Event.COMPLETE,this.landCompleteHandle);
            tempmc1.addChild(temp1);
            this.RootMC.BG.removeChild(this.RootMC.BG.getChildByName("oldbg"));
            this.RootMC.BG.addChild(tempmc1);
         }
         tempmc.addChild(this.tempLoaderBG);
      }
      
      public function landCompleteHandle(e:Event) : void
      {
         var tempMC:DisplayObject = e.target.content;
         var oldDoor:DisplayObject = this.RootMC.doorEmptyMC.getChildByName("door");
         this.RootMC.doorEmptyMC.removeChild(oldDoor);
         var oldStair:DisplayObject = this.RootMC.stairEmptyMC.getChildByName("stairMC");
         this.RootMC.stairEmptyMC.addChild(tempMC["stairMC"]);
         this.RootMC.stairEmptyMC.removeChild(oldStair);
         this.RootMC.doorEmptyMC.addChild(tempMC["door"]);
      }
      
      public function BGCompleteHandle(e:Event) : void
      {
      }
      
      public function loadGoods(temp:Object) : void
      {
         var tempmc:MovieClip = new MovieClip();
         tempmc.name = "g" + temp.num;
         this.houseGoodsMCArr.push(tempmc);
         tempmc.num = temp.num;
         tempmc.ID = temp.ID;
         tempmc.PosX = temp.PosX;
         tempmc.PosY = temp.PosY;
         tempmc.Direction = temp.Direction;
         tempmc.Visible = temp.Visible;
         tempmc.Layer = temp.Layer;
         tempmc.Reserved = temp.Reserved;
         var tempLoader:Loader = new Loader();
         tempLoader.load(VL.getURLRequest("resource/goods/swf/" + temp.ID + ".swf"));
         if(temp.Layer < 100)
         {
            if(Boolean(temp.Visible) && temp.Type != 4)
            {
               this.RootMC.topGoodsMC.addChild(tempmc);
            }
            else
            {
               this.MCArr[temp.Layer].addChild(tempmc);
            }
         }
         tempmc.addChild(tempLoader);
         tempLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.completeHandler);
      }
      
      public function loadNewGoods(temp:Object) : void
      {
         var tempObj:Object = null;
         if(temp.Layer >= 100)
         {
            tempObj = {
               "ID":temp.ID,
               "PosX":0,
               "PosY":0,
               "Direction":1,
               "Visible":0,
               "Layer":temp.Layer,
               "num":this.houseGoodsArr.length
            };
            this.changeHouseBG(tempObj);
         }
         else
         {
            tempObj = {
               "ID":temp.ID,
               "PosX":500,
               "PosY":300,
               "Direction":1,
               "Visible":0,
               "Layer":temp.Layer,
               "num":this.houseGoodsArr.length
            };
            this.houseGoodsArr.push(tempObj);
            this.loadGoods(tempObj);
         }
      }
      
      public function completeHandler(e:Event) : void
      {
         if(!this.loadComplete)
         {
            ++this.loadNum;
            if(this.loadNum == this.houseGoodsArr.length)
            {
               GV.onlineSocket.dispatchEvent(new EventTaomee("allGoodsLoaded",this.houseObj));
               this.loadNum = 0;
               this.loadComplete = true;
               this.showSaveGoods(this.houseGoodsArr);
            }
         }
         var goodsMC:Object = e.target.content;
         var movingmc:Object = goodsMC.parent.parent;
         goodsMC.x -= goodsMC.getBounds(movingmc).x;
         goodsMC.y -= goodsMC.getBounds(movingmc).y;
         movingmc.x = movingmc.PosX;
         movingmc.y = movingmc.PosY;
         goodsMC.mc1.gotoAndStop(movingmc.Direction);
         goodsMC.mc2.gotoAndStop(movingmc.Direction);
         goodsMC.moving = false;
         if(this.houseObj.UserID == LocalUserInfo.getUserID())
         {
            goodsMC.btn.addEventListener(MouseEvent.CLICK,this.startdrag);
         }
      }
      
      public function startdrag(e:MouseEvent) : void
      {
         var topPosition:uint = 0;
         if(this.Mode == 0 || this.Mode == 3)
         {
            this.actionGoods = e.target.parent;
            this.actionGoods.moving = !this.actionGoods.moving;
            if(Boolean(this.actionGoods.moving))
            {
               this.movingMC = this.actionGoods.parent.parent;
               this.parentMC = this.actionGoods.parent.parent.parent;
               try
               {
               }
               catch(err:Error)
               {
               }
               this.bmd1 = new BitmapData(this.actionGoods.mc1.width,this.actionGoods.mc1.height,true,0);
               this.bmd1.draw(this.actionGoods.mc1);
               this.actionGoods.mc2.y -= 10;
               this.oldIndex = this.parentMC.getChildIndex(this.movingMC);
               this.index = this.movingMC.num;
               topPosition = this.parentMC.numChildren - 1;
               this.parentMC.setChildIndex(this.movingMC,topPosition);
               this.oldx = this.movingMC.x;
               this.oldy = this.movingMC.y;
               this.movingMC.addEventListener(Event.ENTER_FRAME,this.moveOut);
               this.movingMC.stage.addEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
               this.movingMC.startDrag();
               this.RootMC.addChild(this.movingMC);
            }
            else
            {
               try
               {
               }
               catch(err:Error)
               {
               }
               this.movingMC.stopDrag();
               this.actionGoods.mc2.y += 10;
               this.movingMC.stage.removeEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
               this.movingMC.removeEventListener(Event.ENTER_FRAME,this.moveOut);
               this.index = this.movingMC.num;
               this.houseGoodsArr[this.index].PosX = this.movingMC.x;
               this.houseGoodsArr[this.index].PosY = this.movingMC.y;
               if(this.topLevel)
               {
                  this.RootMC.topGoodsMC.addChild(this.movingMC);
                  this.houseGoodsArr[this.index].Visible = 1;
               }
               else
               {
                  this.MCArr[this.movingMC.Layer].addChild(this.movingMC);
               }
               this.doAction();
               this.bmd1.dispose();
            }
         }
      }
      
      private function doAction() : void
      {
         if(this.backOldPos)
         {
            this.houseGoodsArr[this.index].x = this.oldx;
            this.houseGoodsArr[this.index].y = this.oldy;
            this.houseGoodsMCArr[this.index].x = this.oldx;
            this.houseGoodsMCArr[this.index].y = this.oldy;
            this.movingMC.alpha = 1;
            this.parentMC.setChildIndex(this.movingMC,this.oldIndex);
         }
         else
         {
            if(this.topLevel)
            {
            }
            this.levelCtrl();
         }
         if(this.backDepot)
         {
            this.RootMC.depot_mc.x = 1000;
            this.RootMC.depot_mc.y = 1000;
            this.moveGoodsToDepot();
         }
      }
      
      public function get goodsArr() : Array
      {
         var arr:Array = new Array();
         var len:uint = this.houseGoodsArr.length;
         for(var i:uint = 0; i < len; i++)
         {
            if(this.houseGoodsArr[i] != "")
            {
               arr.push(this.houseGoodsArr[i]);
            }
         }
         this.showSaveGoods(arr);
         return arr;
      }
      
      private function moveGoodsToDepot() : void
      {
         this.MCArr[this.houseGoodsArr[this.index].Layer].removeChild(this.houseGoodsMCArr[this.index]);
         dispatchEvent(new EventTaomee("dispatchGoodsToDepot",{"obj":this.houseGoodsArr[this.index]}));
         this.houseGoodsArr[this.index] = "";
         this.houseGoodsMCArr[this.index] = "";
      }
      
      private function moveOut(e:Event) : void
      {
         this.hit();
         if(Boolean(e.target.hitTestObject(this.RootMC.houseUIMC.backDepot_mc)) || Boolean(e.target.hitTestObject(this.RootMC.hitTestMC.right_hitmc)))
         {
            this.RootMC.depot_mc.x = e.target.x + e.target.width;
            this.RootMC.depot_mc.y = e.target.y;
            this.backDepot = true;
         }
         else
         {
            this.RootMC.depot_mc.x = 1000;
            this.RootMC.depot_mc.y = 1000;
            this.backDepot = false;
         }
      }
      
      private function keyUpHandler(event:KeyboardEvent) : void
      {
         if(event.keyCode == Keyboard.LEFT)
         {
            if(this.actionGoods.mc1.currentFrame != this.actionGoods.mc1.totalFrames)
            {
               this.gotonext();
            }
            else
            {
               this.gotostop(1);
            }
            this.houseGoodsArr[this.index].Direction = this.actionGoods.mc1.currentFrame;
         }
         if(event.keyCode == Keyboard.RIGHT)
         {
            if(this.actionGoods.mc1.currentFrame != 1)
            {
               this.gotoprev();
            }
            else
            {
               this.gotostop(this.actionGoods.mc1.totalFrames);
            }
            this.houseGoodsArr[this.index].Direction = this.actionGoods.mc1.currentFrame;
         }
         if(event.keyCode == Keyboard.UP)
         {
         }
         if(event.keyCode == Keyboard.DOWN)
         {
         }
      }
      
      private function gotostop(i:Object) : void
      {
         this.actionGoods.mc1.gotoAndStop(i);
         this.actionGoods.mc2.gotoAndStop(i);
         this.actionGoods.mc3.gotoAndStop(i);
      }
      
      private function gotoprev() : void
      {
         this.actionGoods.mc1.prevFrame();
         this.actionGoods.mc2.prevFrame();
         this.actionGoods.mc3.prevFrame();
      }
      
      private function gotonext() : void
      {
         this.actionGoods.mc1.nextFrame();
         this.actionGoods.mc2.nextFrame();
         this.actionGoods.mc3.nextFrame();
      }
      
      private function levelCtrl() : void
      {
         this.arry = new Array();
         for(var i:uint = 0; i < this.MCArr[this.movingMC.Layer].numChildren; i++)
         {
            this.arry[i] = this.MCArr[this.movingMC.Layer].getChildAt(i).y;
         }
         this.sort(this.arry);
      }
      
      private function sort(arr:Array) : void
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
                  this.MCArr[this.movingMC.Layer].swapChildrenAt(j,j - 1);
               }
            }
         }
      }
      
      private function getindex(num:Object) : int
      {
         var len:uint = this.houseGoodsArr.length;
         for(var i:uint = 0; i < len; i++)
         {
            if(num == this.houseGoodsArr[i].num)
            {
               return i;
            }
         }
         return -1;
      }
      
      private function changeSelect() : void
      {
         switch(this.Mode)
         {
            case 6:
               floorViewStatic.removeFloorListener();
               this.removeBook();
               this.RootMC.houseUIMC.y = this.UIPosY;
               break;
            case 0:
               floorViewStatic.removeFloorListener();
               this.removeBook();
               this.RootMC.houseUIMC.y = this.UIPosY;
               break;
            case 1:
               this.removeBook();
               floorViewStatic.changeWorkMode(1);
               this.RootMC.houseUIMC.y = this.UIPosY;
               break;
            case 2:
               this.removeBook();
               floorViewStatic.changeWorkMode(2);
               this.RootMC.houseUIMC.y = this.UIPosY;
               break;
            case 3:
               floorViewStatic.removeFloorListener();
               this.removeBook();
               if(this.RootMC.houseUIMC.y < 500)
               {
                  this.RootMC.houseUIMC.y = this.UIPosY;
               }
               else
               {
                  this.RootMC.houseUIMC.y = 440;
               }
               break;
            case 4:
               floorViewStatic.removeFloorListener();
               this.openBookAction();
               this.RootMC.houseUIMC.y = this.UIPosY;
               break;
            case 5:
               this.dolockHome();
         }
      }
      
      private function dolockHome() : void
      {
         this.houseTool.lock_mc.btn.visible = false;
         if(Boolean(this.lockHome & 2))
         {
            this.lockhomereq.lock(0);
         }
         else
         {
            this.lockhomereq.lock(2);
         }
         GV.onlineSocket.addEventListener("user_lockhome",this.lockHomeResult);
      }
      
      private function lockHomeResult(e:EventTaomee) : void
      {
         this.houseTool.lock_mc.btn.visible = true;
         this.lockHome = e.EventObj.Vip;
         LocalUserInfo.setVip(this.lockHome);
         this.houseTool.lock_mc.gotoAndStop(this.lockHome & 2 + 1);
         GV.onlineSocket.removeEventListener("user_lockhome",this.lockHomeResult);
      }
      
      private function OpenClosedepot(e:MouseEvent) : void
      {
         this.Mode = 3;
         this.resetBtnStatus();
         this.changeSelect();
      }
      
      private function OpenCloseBook(e:Event) : void
      {
         this.Mode = 4;
         this.resetBtnStatus();
         this.changeSelect();
      }
      
      private function changeLock(e:Event) : void
      {
         this.Mode = 5;
         this.resetBtnStatus();
         this.changeSelect();
      }
      
      public function waHandle(e:Event) : void
      {
         this.Mode = 1;
         this.resetBtnStatus();
         this.changeSelect();
      }
      
      public function buHandle(e:Event) : void
      {
         this.Mode = 2;
         this.resetBtnStatus();
         this.changeSelect();
      }
      
      private function saveMap(e:Event) : void
      {
         dispatchEvent(new EventTaomee("dispatchSaveMap"));
      }
      
      private function changeEditMode(e:Event) : void
      {
         this.editMode = !this.editMode;
         this.houseTool.depot_mc.visible = this.editMode;
         this.houseTool.wa_mc.visible = this.editMode;
         this.houseTool.bu_mc.visible = this.editMode;
         this.houseTool.lock_mc.visible = !this.editMode;
         this.RootMC.houseUIMC.y = this.UIPosY;
         this.RootMC.floorMC.stage.removeEventListener(MouseEvent.CLICK,floorViewStatic.addFloor);
         this.cleartip();
         floorViewStatic.removeFloorListener();
         if(this.editMode)
         {
            this.Mode = 0;
            this.houseTool.edit_mc.gotoAndStop(2);
            this.houseTool.key_mc.visible = true;
            this.RootMC.door_mc.btn.visible = false;
            MainManager.getToolLevel().y = 1000;
            GF.clearPeoples();
            MoveTo.CanMove = false;
         }
         else
         {
            MoveTo.CanMove = true;
            this.Mode = 6;
            this.RootMC.door_mc.btn.visible = true;
            MainManager.getToolLevel().y = 0;
            this.houseTool.edit_mc.gotoAndStop(1);
            this.houseTool.key_mc.visible = false;
         }
         dispatchEvent(new EventTaomee("dispatchEditMode",{"Mode":this.editMode}));
      }
      
      public function initBtn() : void
      {
         this.lockHome = LocalUserInfo.getVip();
         if(Boolean(this.lockHome & 2))
         {
            this.houseTool.lock_mc.gotoAndStop(2);
         }
         else
         {
            this.houseTool.lock_mc.gotoAndStop(1);
         }
         this.houseTool.depot_mc.btn.addEventListener(MouseEvent.CLICK,this.OpenClosedepot);
         this.houseTool.depot_mc.btn.addEventListener(MouseEvent.MOUSE_OVER,this.goto2);
         this.houseTool.depot_mc.btn.addEventListener(MouseEvent.MOUSE_OUT,this.goto1);
         this.houseTool.book_mc.btn.addEventListener(MouseEvent.CLICK,this.OpenCloseBook);
         this.houseTool.book_mc.btn.addEventListener(MouseEvent.MOUSE_OVER,this.goto2);
         this.houseTool.book_mc.btn.addEventListener(MouseEvent.MOUSE_OUT,this.goto1);
         this.houseTool.lock_mc.btn.addEventListener(MouseEvent.CLICK,this.changeLock);
         this.houseTool.lock_mc.btn.addEventListener(MouseEvent.MOUSE_OVER,this.showLockTip);
         this.houseTool.lock_mc.btn.addEventListener(MouseEvent.MOUSE_OUT,this.cleanLockTip);
         this.houseTool.edit_mc.btn.addEventListener(MouseEvent.CLICK,this.changeEditMode);
         this.houseTool.edit_mc.btn.addEventListener(MouseEvent.MOUSE_OVER,this.showedittip);
         this.houseTool.edit_mc.btn.addEventListener(MouseEvent.MOUSE_OUT,this.cleanedittip);
         this.houseTool.wa_mc.btn.addEventListener(MouseEvent.CLICK,this.waHandle);
         this.houseTool.wa_mc.btn.addEventListener(MouseEvent.MOUSE_OVER,this.goto2);
         this.houseTool.wa_mc.btn.addEventListener(MouseEvent.MOUSE_OUT,this.goto1);
         this.houseTool.bu_mc.btn.addEventListener(MouseEvent.CLICK,this.buHandle);
         this.houseTool.bu_mc.btn.addEventListener(MouseEvent.MOUSE_OVER,this.goto2);
         this.houseTool.bu_mc.btn.addEventListener(MouseEvent.MOUSE_OUT,this.goto1);
         this.houseTool.key_mc.btn.addEventListener(MouseEvent.MOUSE_OVER,this.goto2);
         this.houseTool.key_mc.btn.addEventListener(MouseEvent.MOUSE_OUT,this.goto1);
         this.RootMC.door_mc.btn.addEventListener(MouseEvent.CLICK,this.leaveHome);
         this.RootMC.door_mc.btn.addEventListener(MouseEvent.MOUSE_OVER,this.goto2);
         this.RootMC.door_mc.btn.addEventListener(MouseEvent.MOUSE_OUT,this.goto1);
         this.RootMC.houseUIMC.close_btn.addEventListener(MouseEvent.CLICK,this.OpenClosedepot);
      }
      
      public function resetBtnStatus() : void
      {
         this.houseTool.wa_mc.gotoAndStop(1);
         this.houseTool.bu_mc.gotoAndStop(1);
         this.houseTool.depot_mc.gotoAndStop(1);
         this.houseTool.book_mc.gotoAndStop(1);
      }
      
      public function leaveHome(e:Event) : void
      {
         GV.Room_DefaultRoomID = 0;
         LocalUserInfo.setMapID(0);
         GF.clearTip();
         this.RootMC.door_mc.btn.removeEventListener(MouseEvent.MOUSE_OVER,this.goto2);
         this.RootMC.door_mc.btn.removeEventListener(MouseEvent.MOUSE_OUT,this.goto1);
         switchMapLogic.switchMapLogicHandler(1);
      }
      
      public function showLockTip(e:Event) : void
      {
         this.showtip(e.target.parent);
      }
      
      public function cleanLockTip(e:Event) : void
      {
         this.cleartip();
      }
      
      public function showedittip(e:Event) : void
      {
         this.showtip(e.target.parent);
      }
      
      public function cleanedittip(e:Event) : void
      {
         this.cleartip();
      }
      
      public function goto2(e:Event) : void
      {
         this.showtip(e.target.parent);
         e.target.parent.gotoAndStop(2);
         if(e.target.parent.name == "door_mc")
         {
            this.RootMC.doorEmptyMC["door"].gotoAndStop(2);
         }
      }
      
      public function goto1(e:Event) : void
      {
         this.cleartip();
         e.target.parent.gotoAndStop(1);
         if(e.target.parent.name == "door_mc")
         {
            this.RootMC.doorEmptyMC.door.gotoAndStop(1);
         }
      }
      
      public function removeGoods() : void
      {
         var i:int = 0;
         for(var k:uint = 0; k < this.MCArr.length; k++)
         {
            for(i = this.MCArr[k].numChildren - 1; i >= 0; i--)
            {
               this.MCArr[k].removeChildAt(i);
            }
         }
      }
      
      public function getHitBitMap(e:Object) : void
      {
         try
         {
            this.bmd2.dispose();
         }
         catch(err:Error)
         {
         }
         this.bmd2 = new BitmapData(960,560,true,0);
         this.bmd2.draw(floorViewStatic.o);
         try
         {
            this.bmdwall.dispose();
         }
         catch(err:Error)
         {
         }
         this.bmdwall = new BitmapData(960,560,true,0);
         this.bmdwall.draw(floorViewStatic.b);
      }
      
      public function hit() : void
      {
         var p:Point = localToGlobal(new Point(this.movingMC.x,this.movingMC.y + this.actionGoods.y + this.actionGoods.mc1.y));
         if(this.bmd1.hitTest(p,85,this.bmdwall,new Point(0,0)))
         {
            this.backOldPos = true;
            this.movingMC.alpha = 0.6;
         }
         else
         {
            if(this.bmd1.hitTest(p,85,this.bmd2,new Point(0,0)))
            {
               this.topLevel = true;
            }
            else
            {
               this.topLevel = false;
            }
            if(Boolean(this.movingMC.hitTestObject(this.RootMC.hitTestMC.bottom_hitmc)) || Boolean(this.movingMC.y < 120) || this.movingMC.x < 16)
            {
               this.backOldPos = true;
               this.movingMC.alpha = 0.6;
            }
            else
            {
               this.backOldPos = false;
               this.movingMC.alpha = 1;
            }
         }
      }
      
      private function openBookAction() : void
      {
         this.bookPanel = ModuleManager.openPanel("HouseShopsPanel");
      }
      
      private function removeBook() : void
      {
         if(Boolean(this.bookPanel))
         {
            this.bookPanel.close();
            this.bookPanel = null;
         }
      }
      
      public function showtip(mc:DisplayObject) : void
      {
         var btnName:String = null;
         var tipX:uint = 0;
         var tipy:uint = 0;
         btnName = mc.name;
         tipX = 930;
         tipy = 74;
         this.cleartip();
         this.myTimeout = setTimeout(function():void
         {
            try
            {
               switch(btnName)
               {
                  case "door_mc":
                     GF.showTip("離開小屋",{
                        "x":448,
                        "y":65
                     });
                     break;
                  case "wa_mc":
                     GF.showTip("挖掘",{
                        "x":tipX,
                        "y":130
                     });
                     break;
                  case "bu_mc":
                     GF.showTip("填埋",{
                        "x":tipX,
                        "y":130 + tipy
                     });
                     break;
                  case "depot_mc":
                     GF.showTip("倉庫",{
                        "x":tipX,
                        "y":130 + tipy + tipy
                     });
                     break;
                  case "lock_mc":
                     if(Boolean(LocalUserInfo.getVip() & 2))
                     {
                        GF.showTip("開門",{
                           "x":tipX,
                           "y":130 + tipy + tipy
                        });
                     }
                     else
                     {
                        GF.showTip("鎖門",{
                           "x":tipX,
                           "y":130 + tipy + tipy
                        });
                     }
                     break;
                  case "book_mc":
                     GF.showTip("摩爾裝潢",{
                        "x":tipX,
                        "y":130 + tipy + tipy + tipy
                     });
                     break;
                  case "edit_mc":
                     if(editMode)
                     {
                        GF.showTip("返回小屋",{
                           "x":tipX,
                           "y":130 + tipy + tipy + tipy + tipy
                        });
                     }
                     else
                     {
                        GF.showTip("編輯小屋",{
                           "x":tipX,
                           "y":130 + tipy + tipy + tipy + tipy
                        });
                     }
                     break;
                  case "key_mc":
                     GF.showTip("控制道具的方向",{
                        "x":tipX - 20,
                        "y":130 + tipy + tipy + tipy + tipy + tipy
                     });
               }
            }
            catch(err:Error)
            {
               trace(err);
            }
         },300);
      }
      
      private function cleartip() : void
      {
         if(this.myTimeout != null)
         {
            clearTimeout(this.myTimeout);
            GF.clearTip();
         }
      }
      
      private function showSaveGoods(arr:Object) : void
      {
         for(var i:uint = 0; i < this.houseGoodsArr.length; i++)
         {
            try
            {
            }
            catch(err:Error)
            {
            }
         }
      }
   }
}

