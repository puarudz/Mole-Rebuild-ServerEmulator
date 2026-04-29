package com.module.newHouse
{
   import com.common.Alert.Alert;
   import com.common.Tween.TweenLite;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.info.MapInfo;
   import com.core.newloader.LoaderList;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.MapManageLogic.MapDepthManageLogic;
   import com.logic.MapManageLogic.MapModelLogic;
   import com.logic.socket.SpecialGoodsSocket.lilypond.LilyPondReq;
   import com.logic.socket.SpecialGoodsSocket.lilypond.LilyPondRes;
   import com.logic.socket.enterMapOrRoom.EnterMapOrRoomReq;
   import com.logic.socket.lockHome.lockHomeReq;
   import com.logic.socket.moleAction.moleActionReq;
   import com.logic.switchMapLogic.switchMapLogic;
   import com.module.home.HomeHot;
   import com.module.newHouse.ModelShowCloths.ModelShowCloths;
   import com.module.pet.petLogic;
   import com.module.pet.petView;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.module.AppModuleControl;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class newEditHouseView extends MovieClip
   {
      
      public static var owner:newEditHouseView;
      
      public static var floorSign:int = 1;
      
      public var changed:Boolean = false;
      
      public var doorLabel:String;
      
      public var doorBtn:MovieClip;
      
      public var loadNum:Number = 0;
      
      public var houseObj:Object;
      
      public var houseGoodsArr:Array;
      
      public var YY:Number = 560;
      
      public var RootMC:MovieClip;
      
      public var UIPosY:Number = 8000;
      
      public var twofloorhouse:Array = [160419,160611,160641,160724,160772,160807,161187,161226,161245,161336,161383,161414,161462,161475,161489];
      
      public var somefloorhouse:Array = [160425,161017,160497,161462,160538,160700,160738,160739,160756,160783,160821,160837,160846,160856,160868,160888,160912,160946,160973,160997,161071,161077,161421,161465];
      
      public var loadComplete:Boolean = false;
      
      private var myTimeout:*;
      
      private var lockhomereq:lockHomeReq;
      
      private var houseTool:MovieClip;
      
      public var backDepot:Boolean = false;
      
      public var backOldPos:Boolean = false;
      
      public var oldx:Number;
      
      public var oldy:Number;
      
      public var oldIndex:int;
      
      public var index:int;
      
      public var parentMC:MovieClip;
      
      public var Mode:int = 0;
      
      public var bookMode:int;
      
      private var editMode:Boolean = false;
      
      private var isHasEditorUI:Boolean = true;
      
      public var lockHome:uint;
      
      public var actionGoods:Object;
      
      public var movingMC:MovieClip;
      
      public var bookView:MovieClip;
      
      public var loadBookEvent:MCLoader;
      
      public var arry:Array = [];
      
      public var BG:Object;
      
      private var prev_BG:int;
      
      private var houseLevel:int = 0;
      
      public var goodsNum:int;
      
      public var maptype:int;
      
      private var bookPanel:AppModuleControl;
      
      public function newEditHouseView(houseobj:Object, rootmc:MovieClip)
      {
         super();
         this.init(houseobj,rootmc);
      }
      
      public function init(houseobj:Object, rootmc:MovieClip) : void
      {
         LocalUserInfo.setMapType(EnterMapOrRoomReq.newMapType);
         this.maptype = LocalUserInfo.getMapType();
         this.lockhomereq = new lockHomeReq();
         owner = this;
         this.RootMC = rootmc;
         this.houseObj = houseobj;
         GV.Room_Name = this.houseObj.Name;
         this.houseTool = this.RootMC.houseTool;
         this.houseGoodsArr = this.houseObj.itemArr;
         this.loadGoodsInHouse();
         this.initBtn();
         this.initOldXY();
         GV.onlineClass.addEventListener("ud",this.molegoto1);
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeHandler);
         this.houseTool.key_mc.visible = false;
         HomeHot.init(newHouseView.houseID);
         this.resetMCXY();
         this.BG = Boolean(this.BG) ? this.BG : GoodsInfo.getInfoById(160030);
         this.prev_BG = this.BG.ID;
      }
      
      public function removeHandler(e:Event) : void
      {
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeHandler);
         GV.onlineSocket.removeEventListener("fireAction_select",this.moveDownUp);
         GV.onlineClass.removeEventListener("ud",this.molegoto1);
         this.houseTool.molehome_btn.removeEventListener(MouseEvent.CLICK,this.openMoleHome);
         if(newHouseView.isMyHouse)
         {
            HitTest.floorBMD = null;
            HitTest.leftBMD = null;
            HitTest.midBMD = null;
            HitTest.rightBMD = null;
            HitTest.sideBMD = null;
            HitTest.moveGoodsBMD = null;
            this.RootMC.removeEventListener("changeRotation",this.updateRotation);
            this.RootMC.removeEventListener("changeDirection",this.updateDirection);
            this.RootMC.removeEventListener("changeVisible",this.updateVisible);
            this.houseTool.depot_mc.btn.removeEventListener(MouseEvent.CLICK,this.OpenClosedepot);
            this.houseTool.depot_mc.btn.removeEventListener(MouseEvent.MOUSE_OVER,this.goto2);
            this.houseTool.depot_mc.btn.removeEventListener(MouseEvent.MOUSE_OUT,this.goto1);
            this.houseTool.houseShopBtn.removeEventListener(MouseEvent.CLICK,this.OpenNewHouseShop);
            this.houseTool.lock_mc.btn.removeEventListener(MouseEvent.CLICK,this.changeLock);
            this.houseTool.lock_mc.btn.removeEventListener(MouseEvent.MOUSE_OVER,this.showLockTip);
            this.houseTool.lock_mc.btn.removeEventListener(MouseEvent.MOUSE_OUT,this.cleanLockTip);
            this.houseTool.edit_mc.btn.removeEventListener(MouseEvent.CLICK,this.changeEditMode);
            this.houseTool.edit_mc.btn.removeEventListener(MouseEvent.MOUSE_OVER,this.showedittip);
            this.houseTool.edit_mc.btn.removeEventListener(MouseEvent.MOUSE_OUT,this.cleanedittip);
            this.houseTool.key_mc.btn.removeEventListener(MouseEvent.MOUSE_OVER,this.goto2);
            this.houseTool.key_mc.btn.removeEventListener(MouseEvent.MOUSE_OUT,this.goto1);
            this.RootMC.houseUIMC.close_btn.removeEventListener(MouseEvent.CLICK,this.OpenClosedepot);
         }
      }
      
      public function loadGoodsInHouse() : void
      {
         var len:uint = this.houseGoodsArr.length;
         this.goodsNum = len;
         for(var i:uint = 0; i < len; i++)
         {
            this.houseGoodsArr[i].num = i;
            if(this.houseGoodsArr[i].Layer == 6)
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
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("allGoodsLoaded",this.houseObj));
      }
      
      public function loadHouseBG(goods:Object) : void
      {
         if(this.BG == null)
         {
            this.prev_BG = goods.ID;
         }
         this.BG = goods;
         if(this.somefloorhouse.indexOf(goods.ID) != -1)
         {
            if(this.maptype == 0)
            {
               this.doorLabel = goods.ID + "_1";
            }
            else if(this.maptype == 11)
            {
               this.doorLabel = goods.ID + "_2";
            }
            else if(this.maptype == 12)
            {
               this.doorLabel = goods.ID + "_3";
            }
         }
         else
         {
            this.doorLabel = goods.ID;
         }
         var mcloader:MCLoader = new MCLoader("resource/goods/swf/" + this.doorLabel + ".swf",this.RootMC,1,"正在加載小屋背景...");
         BC.addEvent(this,mcloader,MCLoadEvent.ON_SUCCESS,this.loadBGSucc);
         LoaderList.getInstance().addItem(mcloader,null,LoaderList.HIGH);
         if(this.prev_BG != goods.ID)
         {
            GV.MC_mapFrame.y = 0;
         }
      }
      
      private function loadBGSucc(event:MCLoadEvent) : void
      {
         GC.clearAllChildren(this.RootMC.TestMC);
         GC.clearAllChildren(this.RootMC.bgMC);
         GC.clearAllChildren(this.RootMC.type_mc);
         GC.clearAllChildren(this.RootMC.door_mc);
         var a:DisplayObjectContainer = event.getParent();
         var b:Loader = event.getLoader();
         var c:DisplayObject = event.getContent();
         this.RootMC.type_mc.addChild(c["type_mc"]);
         this.RootMC.door_mc.addChild(c["door"]);
         this.RootMC.TestMC.addChild(c["hitTestMC"]);
         this.RootMC.bgMC.addChild(c["bg"]);
         var mcloader:MCLoader = event.target as MCLoader;
         mcloader.clear();
         this.gotoBG(this.BG);
      }
      
      public function gotoBG(goods:*) : void
      {
         GV.onlineSocket.addEventListener("fireAction_select",this.moveDownUp);
         this.isAllGoodsLoaded();
         this.initDoorBtn();
         if(newHouseView.isMyHouse)
         {
            HitTest.getBMD(this.RootMC);
         }
         this.SetMapArray();
      }
      
      private function SetMapArray() : void
      {
         setTimeout(function():void
         {
            try
            {
               if(twofloorhouse.indexOf(int(BG.ID)) >= 0)
               {
                  MapModelLogic.owner.makeMapArray(true,1120);
               }
               else
               {
                  MapModelLogic.owner.makeMapArray(true);
               }
            }
            catch(err:Error)
            {
            }
         },50);
      }
      
      public function setOldXY() : void
      {
         for(var i:uint = 0; i < this.RootMC.MoveMCArr.length; i++)
         {
            this.RootMC.MoveMCArr[i].x = this.RootMC.MoveMCArr[i].oldx;
            this.RootMC.MoveMCArr[i].y = this.RootMC.MoveMCArr[i].oldy;
         }
      }
      
      public function initOldXY() : void
      {
         for(var i:uint = 0; i < this.RootMC.MoveMCArr.length; i++)
         {
            this.RootMC.MoveMCArr[i].oldx = this.RootMC.MoveMCArr[i].x;
            this.RootMC.MoveMCArr[i].oldy = this.RootMC.MoveMCArr[i].y;
         }
      }
      
      public function resetMCXY(_houseLevel:String = "") : void
      {
         this.houseLevel = Boolean(_houseLevel.length) ? int(_houseLevel) : int(GV.MC_mapFrame.y / 560);
         var _posY:int = this.houseLevel;
         this.setOldXY();
         for(var i:uint = 0; i < this.RootMC.MoveMCArr.length; i++)
         {
            this.RootMC.MoveMCArr[i].y -= this.houseLevel * this.YY;
         }
         GV.MC_ToolView.y = 340;
      }
      
      public function showEditorUI(b:Boolean) : void
      {
         this.isHasEditorUI = b;
         if(this.prev_BG == this.BG.ID)
         {
            if(b)
            {
               this.RootMC.houseUIMC.y = 440 - this.houseLevel * this.YY;
            }
            else
            {
               this.RootMC.houseUIMC.y = 440 - this.houseLevel * this.YY + 10000;
            }
         }
         else if(b)
         {
            this.RootMC.houseUIMC.y = 440;
         }
         else
         {
            this.RootMC.houseUIMC.y = 440 + 10000;
         }
      }
      
      public function setPeoplePos() : void
      {
         if(this.twofloorhouse.indexOf(this.BG.ID) == -1)
         {
            this.resetMCXY();
            GC.setGTimeout(function():void
            {
               if(MapInfo.currentMapInfo().name == "house")
               {
                  GV.MAN_PEOPLE.x = 440;
                  GV.MAN_PEOPLE.y = 440;
               }
            },500);
         }
         else if(this.prev_BG == this.BG.ID)
         {
            GC.setGTimeout(function():void
            {
               var mole:MovieClip = null;
               var gotomc:DisplayObject = null;
               if(MapInfo.currentMapInfo().name == "house" && -int(GV.MAN_PEOPLE.y / YY) != houseLevel)
               {
                  try
                  {
                     mole = GV.MAN_PEOPLE;
                     gotomc = RootMC.door_mc.getChildAt(0);
                     mole.x = gotomc["floor_" + (houseLevel + 10)].x;
                     mole.y = gotomc["floor_" + (houseLevel + 10)].y;
                  }
                  catch(err:Error)
                  {
                  }
               }
            },500);
         }
         else
         {
            GC.setGTimeout(function():void
            {
               if(MapInfo.currentMapInfo().name == "house")
               {
                  GV.MAN_PEOPLE.x = 440;
                  GV.MAN_PEOPLE.y = 440;
               }
            },500);
            this.prev_BG = this.BG.ID;
            this.resetMCXY();
         }
      }
      
      public function MCPoint() : Point
      {
         return new Point(-GV.MC_mapFrame.x,-GV.MC_mapFrame.y);
      }
      
      public function initDoorBtn() : void
      {
         var n:uint = uint(this.RootMC.door_mc.numChildren);
         this.doorBtn = this.RootMC.door_mc.getChildAt(0);
         var doors:Object = this.doorBtn.getChildAt(0);
         if(doors.name == "doors")
         {
            doors.outmc.btn.addEventListener(MouseEvent.CLICK,this.leaveHomeTip);
            doors.outmc.btn.addEventListener(MouseEvent.MOUSE_OVER,this.goto2);
            doors.outmc.btn.addEventListener(MouseEvent.MOUSE_OUT,this.goto1);
            if(Boolean(doors.btn1))
            {
               doors.btn1.btn.addEventListener(MouseEvent.CLICK,this.changeRoom);
            }
            if(Boolean(doors.btn2))
            {
               doors.btn2.btn.addEventListener(MouseEvent.CLICK,this.changeRoom);
            }
            if(Boolean(doors.btn3))
            {
               doors.btn3.btn.addEventListener(MouseEvent.CLICK,this.changeRoom);
            }
            if(Boolean(doors.btn4))
            {
               doors.btn4.btn.addEventListener(MouseEvent.CLICK,this.changeRoom);
            }
            if(Boolean(doors.btn5))
            {
               doors.btn5.btn.addEventListener(MouseEvent.CLICK,this.changeRoom);
            }
            if(Boolean(doors.btn6))
            {
               doors.btn6.btn.addEventListener(MouseEvent.CLICK,this.changeRoom);
            }
            return;
         }
         this.doorBtn.btn.addEventListener(MouseEvent.CLICK,this.leaveHomeTip);
         this.doorBtn.btn.addEventListener(MouseEvent.MOUSE_OVER,this.goto2);
         this.doorBtn.btn.addEventListener(MouseEvent.MOUSE_OUT,this.goto1);
         if(Boolean(this.doorBtn.btn1))
         {
            this.doorBtn.btn1.addEventListener(MouseEvent.CLICK,this.leaveHomeTip);
            this.doorBtn.btn1.addEventListener(MouseEvent.MOUSE_OVER,this.goto2);
            this.doorBtn.btn1.addEventListener(MouseEvent.MOUSE_OUT,this.goto1);
         }
      }
      
      public function changeRoom(e:MouseEvent) : void
      {
         var maptype:uint = 0;
         if(!this.editMode)
         {
            maptype = uint(e.currentTarget.parent.name.slice(3,4));
            GV.Room_DefaultRoomID = 0;
            if(maptype == 1)
            {
               maptype = 0;
            }
            else if(maptype == 2)
            {
               maptype = 11;
            }
            else if(maptype == 3)
            {
               maptype = 12;
            }
            GF.clearTip();
            this.cleartip();
            GV.Room_DefaultRoomID = newHouseView.houseID;
            switchMapLogic.switchMapLogicHandler(newHouseView.houseID,false,maptype);
         }
      }
      
      public function changeBG(temp:Object) : void
      {
         GV.MC_mapFrame.y = 0;
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
            "Rotation":0,
            "num":this.houseGoodsArr.length
         };
         this.houseGoodsArr = new Array();
         this.houseGoodsArr.push(tempObj);
         this.loadHouseBG(tempObj);
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
         tempmc.Rotation = temp.Rotation;
         tempmc.Reserved = temp.Reserved;
         var tempLoader:Loader = new Loader();
         if(temp.Layer == 1)
         {
            this.RootMC.depth_mc.addChild(tempmc);
         }
         else if(temp.Layer == 2)
         {
            this.RootMC.floorMC.addChild(tempmc);
         }
         else if(temp.Layer == 4)
         {
            this.RootMC.wallMC.addChild(tempmc);
         }
         tempmc.addChild(tempLoader);
         tempLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.completeHandler);
         tempLoader.load(VL.getURLRequest("resource/goods/swf/" + temp.ID + ".swf"));
      }
      
      public function isAllGoodsLoaded() : void
      {
         if(!this.loadComplete)
         {
            ++this.loadNum;
            if(this.loadNum == this.houseGoodsArr.length)
            {
               this.loadNum = 0;
               this.loadComplete = true;
               GoodsLogic.getInstance().init();
            }
         }
      }
      
      public function completeHandler(e:Event) : void
      {
         var goodsMC:*;
         var movingmc:* = undefined;
         var treeInfoReq:LilyPondReq = null;
         var m_id_lily:uint = 0;
         this.isAllGoodsLoaded();
         goodsMC = e.target.content;
         movingmc = goodsMC.parent.parent;
         if(movingmc.ID == 161102)
         {
            var _temp_2:* = GV.onlineSocket;
            var _temp_1:* = LilyPondRes.GET_LILYPOND_SUCC;
            with({})
            {
               
               _temp_2.addEventListener(_temp_1,function ap(e:EventTaomee):void
               {
                  GV.onlineSocket.removeEventListener(LilyPondRes.GET_LILYPOND_SUCC,ap);
                  var TreeInfo:Object = e.EventObj;
                  if(TreeInfo.water < 100)
                  {
                     movingmc.Direction = 1;
                  }
                  else if(TreeInfo.water >= 100 && TreeInfo.water < 200)
                  {
                     movingmc.Direction = 3;
                  }
                  else if(TreeInfo.water >= 200 && TreeInfo.water <= 300)
                  {
                     movingmc.Direction = 5;
                  }
               });
               m_id_lily = uint(newHouseView.getInstance().houseObj.UserID);
               treeInfoReq.sendReq(m_id_lily);
            }
            movingmc.x = movingmc.PosX;
            movingmc.y = movingmc.PosY;
            if(Boolean(movingmc.Rotation))
            {
               movingmc.rotation = movingmc.Rotation;
            }
            goodsMC.mc1.gotoAndStop(movingmc.Direction);
            goodsMC.mc2.gotoAndStop(movingmc.Direction);
            goodsMC.ID = movingmc.ID;
            if(newHouseView.getInstance().CandyNum == 0)
            {
               movingmc.rotation = Math.random() * 360;
            }
            ModelShowCloths.getInstance().init(goodsMC);
            goodsMC.addEventListener("Special_Goods",this.ClickSpecialGoods);
            goodsMC.btn.addEventListener(MouseEvent.CLICK,this.changeStatus);
            goodsMC.btn.addEventListener(MouseEvent.MOUSE_OVER,this.CanMove);
            goodsMC.btn.addEventListener(MouseEvent.MOUSE_OUT,this.CantMove);
            if(movingmc.Visible == 0)
            {
               movingmc.Visible = 1;
            }
            setTimeout(this.gotoVisible,100,goodsMC.mc2,movingmc);
            goodsMC.moving = false;
            if(this.houseObj.UserID == LocalUserInfo.getUserID())
            {
               goodsMC.btn.addEventListener(MouseEvent.CLICK,this.startdrag);
            }
            MapDepthManageLogic.compositorMapDepth();
         }
         
         public function ClickSpecialGoods(e:Event) : void
         {
            if(!this.editMode)
            {
               GV.onlineSocket.dispatchEvent(new EventTaomee("Show_Special_Goods",{"goodsObj":e}));
            }
         }
         
         public function CanMove(e:MouseEvent) : void
         {
            if(!this.editMode && e.target.parent.mc2.getChildAt(0) is MovieClip)
            {
               MoveTo.CanMove = false;
            }
         }
         
         public function CantMove(e:Event) : void
         {
            if(!this.editMode)
            {
               MoveTo.CanMove = true;
            }
         }
         
         public function changeStatus(e:Event) : void
         {
            var mc:* = undefined;
            var petmc:DisplayObject = null;
            var i:int = 0;
            var mole:* = undefined;
            if(!this.editMode)
            {
               mc = e.target.parent.mc2.getChildAt(0);
               if(mc is MovieClip)
               {
                  mc.userTool = true;
                  GC.stopAllMC(e.target.parent.mc2);
                  if(Boolean(e.target.parent.mc2.needPet) && newHouseView.isMyHouse)
                  {
                     if(GV.MyInfo_PetObj.Level > 1)
                     {
                        if(mc.currentFrame == 2)
                        {
                           petmc = this.RootMC.petlevel_mc.getChildByName("pet" + mc.playpetid);
                           i = petView.playPetID.indexOf(mc.playpetid);
                           petView.playPetID.slice(i,i + 1);
                           petmc.visible = true;
                           mc.playpetid = GV.MyInfo_PetObj.SpriteID;
                           petView.playPetID.push(GV.MyInfo_PetObj.SpriteID);
                           GF.setPetColor(mc.pet.petBody,GV.MyInfo_PetObj.Color);
                           petLogic.doPetFollow(GV.MyInfo_PetObj.SpriteID,0);
                        }
                        else
                        {
                           mc.gotoAndStop(2);
                           mc.playpetid = GV.MyInfo_PetObj.SpriteID;
                           petView.playPetID.push(GV.MyInfo_PetObj.SpriteID);
                           GF.setPetColor(mc.pet.petBody,GV.MyInfo_PetObj.Color);
                           petLogic.doPetFollow(GV.MyInfo_PetObj.SpriteID,0);
                        }
                     }
                     else if(mc.currentFrame == 2)
                     {
                        mc.gotoAndStop(1);
                        petmc = this.RootMC.petlevel_mc.getChildByName("pet" + mc.playpetid);
                        if(Boolean(petmc))
                        {
                           i = petView.playPetID.indexOf(mc.playpetid);
                           petView["playPetID"].slice(i,i + 1);
                           petmc.visible = true;
                        }
                     }
                     else
                     {
                        Alert.showAlert(MainManager.getAppLevel(),"","帶著你的拉姆來這裡吧！",Alert.IKNOW_ALERT);
                     }
                  }
                  else if(Boolean(e.target.parent.mc2.needPet))
                  {
                     mole = GF.getPeopleByID(LocalUserInfo.getUserID());
                     if(mc.currentFrame == 1 && Boolean(mole.avatarClass.avatarMC.pet_mc.visible))
                     {
                        if(GV.MyInfo_PetObj.Level > 1)
                        {
                           mole.avatarClass.avatarMC.pet_mc.visible = false;
                           mc.gotoAndStop(2);
                           GF.setPetColor(mc.pet.petBody,GV.MyInfo_PetObj.Color);
                        }
                     }
                     else if(mc.currentFrame == 2)
                     {
                        if(GV.MyInfo_PetObj.Level > 1)
                        {
                           mole = GF.getPeopleByID(LocalUserInfo.getUserID());
                           mole.avatarClass.avatarMC.pet_mc.visible = true;
                           mc.gotoAndStop(1);
                        }
                     }
                  }
                  else if(mc.currentFrame == mc.totalFrames)
                  {
                     mc.gotoAndStop(1);
                  }
                  else
                  {
                     mc.nextFrame();
                  }
               }
            }
         }
         
         public function gotoVisible() : void
         {
            var id:int = 0;
            var mc:MovieClip = null;
            var go:Object = null;
            if(arguments[0].numChildren > 0)
            {
               if(arguments[0].getChildAt(0) is MovieClip)
               {
                  if(arguments[0].getChildAt(0).totalFrames != 1)
                  {
                     id = int(arguments[1].ID);
                     arguments[0].getChildAt(0).gotoAndStop(arguments[1].Visible);
                     mc = arguments[0].getChildAt(0);
                     go = arguments[1].Visible;
                     mc.gotoAndStop(go);
                     if(Boolean(arguments[0].needPet))
                     {
                        arguments[0].getChildAt(0).gotoAndStop(1);
                     }
                     this.specialGoodsGoto(id,arguments[0].getChildAt(0));
                  }
               }
            }
         }
         
         public function specialGoodsGoto(id:int, mc:MovieClip) : void
         {
            if(id == 160148)
            {
               if(newHouseView.hostOnline == 0)
               {
                  mc.gotoAndStop(3);
               }
               else
               {
                  mc.gotoAndStop(1);
               }
               mc.name_txt.text = newHouseView.houseName + "的小屋";
            }
         }
         
         public function startdrag(e:Event) : void
         {
            var topPosition:uint = 0;
            this.changed = true;
            if(this.Mode == 1 || this.Mode == 2)
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
                  this.RootMC.addEventListener("changeRotation",this.updateRotation);
                  this.RootMC.addEventListener("changeDirection",this.updateDirection);
                  this.RootMC.addEventListener("changeVisible",this.updateVisible);
                  HitTest.hitTesting(this.actionGoods,this.movingMC);
               }
               else
               {
                  this.movingMC.stopDrag();
                  this.actionGoods.mc2.y += 10;
                  this.index = this.movingMC.num;
                  this.houseGoodsArr[this.index].PosX = this.movingMC.x;
                  this.houseGoodsArr[this.index].PosY = this.movingMC.y;
                  this.doAction();
                  HitTest.stopHitTesting();
               }
            }
         }
         
         private function updateRotation(e:EventTaomee) : void
         {
            this.houseGoodsArr[this.index].Rotation = e.EventObj;
         }
         
         private function updateDirection(e:EventTaomee) : void
         {
            this.houseGoodsArr[this.index].Direction = e.EventObj;
         }
         
         private function updateVisible(e:EventTaomee) : void
         {
            this.houseGoodsArr[this.index].Visible = e.EventObj;
         }
         
         private function doAction() : void
         {
            if(this.movingMC.Layer == 1)
            {
               this.RootMC.depth_mc.addChild(this.movingMC);
            }
            else if(this.movingMC.Layer == 2)
            {
               this.RootMC.floorMC.addChild(this.movingMC);
            }
            else if(this.movingMC.Layer == 4)
            {
               this.RootMC.wallMC.addChild(this.movingMC);
            }
            if(HitTest.backOldPos)
            {
               this.movingMC.x = this.oldx;
               this.movingMC.y = this.oldy;
               this.houseGoodsArr[this.index].x = this.oldx;
               this.houseGoodsArr[this.index].y = this.oldy;
               this.movingMC.alpha = 1;
               this.parentMC.setChildIndex(this.movingMC,this.oldIndex);
            }
            else
            {
               this.levelCtrl();
            }
            if(HitTest.backDepot)
            {
               this.RootMC.depot_mc.x = 10000;
               this.RootMC.depot_mc.y = 10000;
               this.moveGoodsToDepot();
            }
         }
         
         private function levelCtrl() : void
         {
            this.arry = new Array();
            if(this.movingMC.Layer == 4)
            {
               this.getarry(this.RootMC.wallMC);
            }
            else if(this.movingMC.Layer == 2)
            {
               this.getarry(this.RootMC.floorMC);
            }
            else if(this.movingMC.Layer == 1)
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
         
         private function moveAllGoodsToDepot() : void
         {
            var len:uint = this.houseGoodsArr.length;
            for(var i:uint = 0; i < len; i++)
            {
               if(this.houseGoodsArr[i] != "")
               {
                  dispatchEvent(new EventTaomee("dispatchGoodsToDepot",{"obj":this.houseGoodsArr[i]}));
               }
            }
            this.removeAllGoods();
         }
         
         private function removeAllGoods() : void
         {
            GC.stopAllMC(this.RootMC.depth_mc);
            GC.stopAllMC(this.RootMC.wallMC);
            GC.stopAllMC(this.RootMC.floorMC);
            this.stopSound(this.RootMC.depth_mc);
            this.stopSound(this.RootMC.wallMC);
            GC.clearChildren(this.RootMC.depth_mc);
            GC.clearChildren(this.RootMC.wallMC);
            GC.clearChildren(this.RootMC.floorMC);
         }
         
         private function stopSound(soundmc:DisplayObjectContainer) : void
         {
            var i:uint;
            var mc:Object = null;
            var ld:Object = null;
            for(i = 0; i < soundmc.numChildren; i++)
            {
               mc = soundmc.getChildAt(i);
               if(mc is MovieClip)
               {
                  ld = mc.getChildAt(0);
                  if(ld is Loader)
                  {
                     try
                     {
                        if(Boolean(ld.content.mc2))
                        {
                           GC.stopAllMC(ld.content.mc2);
                        }
                     }
                     catch(E:Error)
                     {
                        continue;
                     }
                  }
               }
            }
         }
         
         private function removeGoods(mc:DisplayObjectContainer) : void
         {
            var ld:Object = null;
            if(mc["Layer"] == 1)
            {
               ld = mc.getChildAt(0);
               if(ld is Loader)
               {
                  if(Boolean(ld.content.mc2))
                  {
                     GC.stopAllMC(ld.content.mc2);
                  }
               }
               this.RootMC.depth_mc.removeChild(mc);
            }
            else if(this.movingMC.Layer == 2)
            {
               this.RootMC.floorMC.removeChild(mc);
            }
            else if(this.movingMC.Layer == 4)
            {
               ld = mc.getChildAt(0);
               if(ld is Loader)
               {
                  if(Boolean(ld.content.mc2))
                  {
                     GC.stopAllMC(ld.content.mc2);
                  }
               }
               this.RootMC.wallMC.removeChild(mc);
            }
         }
         
         private function moveGoodsToDepot() : void
         {
            this.removeGoods(this.movingMC);
            dispatchEvent(new EventTaomee("dispatchGoodsToDepot",{"obj":this.houseGoodsArr[this.index]}));
            this.houseGoodsArr[this.index] = "";
            --this.goodsNum;
         }
         
         public function loadNewGoods(temp:Object) : void
         {
            var tempObj:Object = null;
            ++this.goodsNum;
            this.changed = true;
            var goodsStatus:uint = SpecialGoodsBasic.getSpecialGoodsStatus(temp.ID);
            if(GV.MC_mapFrame.y == 0)
            {
               tempObj = {
                  "ID":temp.ID,
                  "PosX":500,
                  "PosY":300,
                  "Direction":1,
                  "Visible":goodsStatus,
                  "Layer":temp.Layer,
                  "num":this.houseGoodsArr.length
               };
            }
            else
            {
               tempObj = {
                  "ID":temp.ID,
                  "PosX":500,
                  "PosY":860,
                  "Direction":1,
                  "Visible":goodsStatus,
                  "Layer":temp.Layer,
                  "num":this.houseGoodsArr.length
               };
            }
            this.houseGoodsArr.push(tempObj);
            this.loadGoods(tempObj);
         }
         
         public function initBtn() : void
         {
            if(newHouseView.isMyHouse)
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
               this.houseTool.houseShopBtn.addEventListener(MouseEvent.CLICK,this.OpenNewHouseShop);
               this.houseTool.lock_mc.btn.addEventListener(MouseEvent.CLICK,this.changeLock);
               this.houseTool.lock_mc.btn.addEventListener(MouseEvent.MOUSE_OVER,this.showLockTip);
               this.houseTool.lock_mc.btn.addEventListener(MouseEvent.MOUSE_OUT,this.cleanLockTip);
               this.houseTool.edit_mc.btn.addEventListener(MouseEvent.CLICK,this.changeEditMode);
               this.houseTool.edit_mc.btn.addEventListener(MouseEvent.MOUSE_OVER,this.showedittip);
               this.houseTool.edit_mc.btn.addEventListener(MouseEvent.MOUSE_OUT,this.cleanedittip);
               this.houseTool.key_mc.btn.addEventListener(MouseEvent.MOUSE_OVER,this.goto2);
               this.houseTool.key_mc.btn.addEventListener(MouseEvent.MOUSE_OUT,this.goto1);
               this.houseTool.molehome_btn.addEventListener(MouseEvent.CLICK,this.openMoleHome);
               this.RootMC.houseUIMC.close_btn.addEventListener(MouseEvent.CLICK,this.OpenClosedepot);
            }
         }
         
         public function moveDownUp(e:EventTaomee) : void
         {
            GV.onlineSocket.removeEventListener("fireAction_select",this.moveDownUp);
            trace(e.EventObj.name);
            var _level:int = int(String(e.EventObj.name).split("_")[1]) - 10;
            if(e.EventObj.type == 1)
            {
               this.Goup(_level + 1);
            }
            else
            {
               this.Godown(_level - 1);
            }
         }
         
         private function molegoto1(e:EventTaomee = null) : void
         {
            var gotomc:DisplayObject = null;
            var lv:int = 0;
            var mole:Object = null;
            var id:uint = uint(e.EventObj.ID);
            var lb:Boolean = isNaN(e.EventObj.lv);
            gotomc = this.RootMC.door_mc.getChildAt(0);
            if(id == LocalUserInfo.getUserID() || lb || !gotomc["floor_" + int(e.EventObj.lv)])
            {
               return;
            }
            lv = int(e.EventObj.lv);
            mole = GF.getPeopleByID(id);
            setTimeout(function():void
            {
               mole.x = gotomc["floor_" + lv].x;
               mole.y = gotomc["floor_" + lv].y;
            },500);
         }
         
         private function Goup(_level:int) : void
         {
            if(this.twofloorhouse.indexOf(int(this.BG.ID)) >= 0)
            {
               TweenLite.to(GV.MC_mapFrame,1,{
                  "y":_level * this.YY,
                  "onComplete":this.GoupOver,
                  "onCompleteParams":[_level + 10]
               });
               MoveTo.CanMove = false;
               GV.onlineClass.chating(0,"/wx");
            }
         }
         
         private function GoupOver(_level:int) : void
         {
            var mole:Object = GV.MAN_PEOPLE;
            var gotomc:DisplayObject = this.RootMC.door_mc.getChildAt(0);
            mole.x = gotomc["floor_" + _level].x;
            mole.y = gotomc["floor_" + _level].y;
            new moleActionReq().sendAction(1,mole.x,mole.y);
            MoveTo.CanMove = true;
            GV.onlineSocket.addEventListener("fireAction_select",this.moveDownUp);
            floorSign = 1;
            this.resetMCXY(String(_level - 10));
            this.SetMapArray();
         }
         
         private function Godown(_level:int) : void
         {
            if(this.twofloorhouse.indexOf(int(this.BG.ID)) >= 0)
            {
               TweenLite.to(GV.MC_mapFrame,1,{
                  "y":_level * this.YY,
                  "onComplete":this.GodownOver,
                  "onCompleteParams":[_level + 10]
               });
               MoveTo.CanMove = false;
               GV.onlineClass.chating(0,"/wx");
               this.resetMCXY(String(_level));
            }
         }
         
         private function GodownOver(_level:int) : void
         {
            var mole:Object = GV.MAN_PEOPLE;
            var gotomc:DisplayObject = this.RootMC.door_mc.getChildAt(0);
            mole.x = gotomc["floor_" + _level].x;
            mole.y = gotomc["floor_" + _level].y;
            new moleActionReq().sendAction(1,mole.x,mole.y);
            MoveTo.CanMove = true;
            GV.onlineSocket.addEventListener("fireAction_select",this.moveDownUp);
            floorSign = 2;
            this.SetMapArray();
         }
         
         private function openMoleHome(e:MouseEvent) : void
         {
            HomeHot.showPanel();
         }
         
         public function leaveHomeTip(e:MouseEvent) : void
         {
            if(this.editMode)
            {
               Alert.showAlert(MainManager.getAppLevel(),"","你正在編輯小屋中，還不能離開哦",Alert.IKNOW_ALERT);
            }
            else
            {
               this.leaveHome();
            }
         }
         
         public function leaveHome() : void
         {
            GF.clearTip();
            try
            {
               this.doorBtn.btn.removeEventListener(MouseEvent.CLICK,this.leaveHomeTip);
               this.doorBtn.btn.removeEventListener(MouseEvent.MOUSE_OVER,this.goto2);
               this.doorBtn.btn.removeEventListener(MouseEvent.MOUSE_OUT,this.goto1);
               if(Boolean(this.doorBtn.btn1))
               {
                  this.doorBtn.btn1.removeEventListener(MouseEvent.CLICK,this.leaveHomeTip);
                  this.doorBtn.btn1.removeEventListener(MouseEvent.MOUSE_OVER,this.goto2);
                  this.doorBtn.btn1.removeEventListener(MouseEvent.MOUSE_OUT,this.goto1);
               }
            }
            catch(err:Error)
            {
            }
            this.cleartip();
            LocalUserInfo.setMapID(0);
            GV.Room_DefaultRoomID = newHouseView.houseID + GV.TwentyBillion;
            GF.switchMap(newHouseView.houseID + GV.TwentyBillion);
         }
         
         private function changeEditMode(e:MouseEvent) : void
         {
            if(!newHouseView.hasAlert)
            {
               if(this.goodsNum <= 100)
               {
                  this.editMode = !this.editMode;
                  this.houseTool.depot_mc.visible = this.editMode;
                  this.houseTool.lock_mc.visible = !this.editMode;
                  this.cleartip();
                  if(this.editMode)
                  {
                     this.Mode = 1;
                     this.houseTool.edit_mc.gotoAndStop(2);
                     this.houseTool.key_mc.visible = true;
                     GV.MC_ToolView.y = 10000;
                     GF.clearPeoples();
                     MoveTo.CanMove = false;
                  }
                  else
                  {
                     MoveTo.CanMove = true;
                     this.setPeoplePos();
                     trace("x: " + GV.MAN_PEOPLE.x + " y: " + GV.MAN_PEOPLE.y + "  isMove: " + MoveTo.CanMove + ":" + MoveTo.CanMove2);
                     this.Mode = 0;
                     GV.MC_ToolView.y = 340;
                     this.houseTool.edit_mc.gotoAndStop(1);
                     this.houseTool.key_mc.visible = false;
                  }
                  dispatchEvent(new EventTaomee("dispatchEditMode",{"Mode":this.editMode}));
               }
               else
               {
                  Alert.showAlert(MainManager.getAppLevel(),"","你的小屋東西太多了，已經超過最大上限無法擺放了！",Alert.IKNOW_ALERT);
               }
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
            return arr;
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
         }
         
         public function goto1(e:Event) : void
         {
            this.cleartip();
            e.target.parent.gotoAndStop(1);
         }
         
         private function OpenNewHouseShop(e:MouseEvent = null) : void
         {
            if(!newHouseView.hasAlert)
            {
               this.bookPanel = ModuleManager.openPanel("HouseShopsPanel",null,"正在加載家園商店",null);
            }
         }
         
         private function changeSelect() : void
         {
            switch(this.Mode)
            {
               case 0:
               case 1:
                  break;
               case 2:
                  if(this.isHasEditorUI)
                  {
                     this.showEditorUI(false);
                  }
                  else
                  {
                     this.showEditorUI(true);
                  }
                  this.removeBook();
                  break;
               case 3:
                  this.OpenNewHouseShop();
                  break;
               case 4:
                  this.dolockHome();
            }
         }
         
         private function dolockHome() : void
         {
            this.houseTool.lock_mc.btn.visible = false;
            if(Boolean(LocalUserInfo.getVip() & 2))
            {
               this.lockhomereq.lock(0);
            }
            else
            {
               this.lockhomereq.lock(1);
            }
            GV.onlineSocket.addEventListener("user_lockhome",this.lockHomeResult);
         }
         
         private function lockHomeResult(e:EventTaomee) : void
         {
            this.houseTool.lock_mc.btn.visible = true;
            this.lockHome = e.EventObj.Vip;
            LocalUserInfo.setVip(this.lockHome);
            if(Boolean(this.lockHome & 2))
            {
               this.houseTool.lock_mc.gotoAndStop(2);
            }
            else
            {
               this.houseTool.lock_mc.gotoAndStop(1);
            }
            GV.onlineSocket.removeEventListener("user_lockhome",this.lockHomeResult);
         }
         
         private function removeBook() : void
         {
            if(Boolean(this.bookPanel))
            {
               this.bookPanel.close();
            }
            this.bookPanel = null;
         }
         
         private function OpenClosedepot(e:MouseEvent) : void
         {
            if(!newHouseView.hasAlert)
            {
               this.Mode = 2;
               this.resetBtnStatus();
               this.changeSelect();
            }
         }
         
         private function OpenCloseBook(e:Event) : void
         {
            if(!newHouseView.hasAlert)
            {
               this.bookMode = this.Mode;
               this.Mode = 3;
               this.resetBtnStatus();
               this.changeSelect();
            }
         }
         
         private function changeLock(e:Event) : void
         {
            this.Mode = 4;
            this.resetBtnStatus();
            this.changeSelect();
         }
         
         public function resetBtnStatus() : void
         {
            this.houseTool.depot_mc.gotoAndStop(1);
         }
         
         public function showtip(mc:DisplayObject) : void
         {
            var btnName:String = null;
            var tipX:Number = NaN;
            var tipy:Number = NaN;
            btnName = mc.name;
            tipX = 920;
            tipy = 315;
            this.cleartip();
            this.myTimeout = setTimeout(function():void
            {
               switch(btnName)
               {
                  case "depot_mc":
                     GF.showTip("倉庫",{
                        "x":tipX,
                        "y":tipy
                     });
                     break;
                  case "lock_mc":
                     if(Boolean(LocalUserInfo.getVip() & 2))
                     {
                        GF.showTip("開門",{
                           "x":tipX,
                           "y":tipy
                        });
                     }
                     else
                     {
                        GF.showTip("鎖門",{
                           "x":tipX,
                           "y":tipy
                        });
                     }
                     break;
                  case "edit_mc":
                     if(editMode)
                     {
                        GF.showTip("保存小屋",{
                           "x":tipX,
                           "y":425
                        });
                     }
                     else
                     {
                        GF.showTip("倉庫",{
                           "x":tipX,
                           "y":425
                        });
                     }
                     break;
                  case "key_mc":
                     GF.showTip("控制道具的方向",{
                        "x":tipX - 20,
                        "y":488
                     });
                     break;
                  default:
                     GF.showTip("離開" + houseObj.Name + "的小屋",{
                        "x":mc.x,
                        "y":mc.y
                     });
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
      }
   }
   
   