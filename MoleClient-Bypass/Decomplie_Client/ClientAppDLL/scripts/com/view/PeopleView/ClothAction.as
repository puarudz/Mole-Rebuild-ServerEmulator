package com.view.PeopleView
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.field.animalInfo.AnimalInfo;
   import com.core.info.LocalUserInfo;
   import com.core.manager.AssetsManage;
   import com.core.manager.IndexManager;
   import com.core.manager.UIManager;
   import com.core.newloader.LoaderList;
   import com.event.EventTaomee;
   import com.global.links.Links;
   import com.global.staticData.MapsConfig;
   import com.logic.MapManageLogic.MapModelLogic;
   import com.module.farm.FieldView;
   import com.module.farm.IAnimal_Follow;
   import com.module.throwThing.throwThingLogic;
   import com.view.PeopleView.ChildPeople.BoyAvatar;
   import fl.motion.BezierSegment;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class ClothAction
   {
      
      private static var fieldItemID:uint;
      
      private static var pool_1270004:Array = [];
      
      private static var screenLib:Dictionary = new Dictionary();
      
      private static var Transport_Lib:AssetsManage = new AssetsManage(true);
      
      screenLib["F12203"] = 1;
      screenLib["F14212"] = 1;
      screenLib["F12300"] = 1;
      screenLib["F12326"] = 1;
      screenLib["F12401"] = 1;
      screenLib["F12619"] = 1;
      screenLib["F12648"] = 1;
      screenLib["F12750"] = 1;
      screenLib["F13046"] = 1;
      screenLib["F13051"] = 1;
      screenLib["F13163"] = 1;
      screenLib["F13246"] = 1;
      screenLib["F15050"] = 1;
      screenLib["F15394"] = 1;
      screenLib["F15402"] = 1;
      screenLib["F15405"] = 1;
      screenLib["F15408"] = 1;
      screenLib["F15411"] = 1;
      screenLib["F15414"] = 1;
      screenLib["F15419"] = 1;
      screenLib["F15422"] = 1;
      
      public function ClothAction()
      {
         super();
      }
      
      public static function getClearMapListener() : void
      {
         var flag:Boolean = false;
         BC.addEvent(ClothAction,GV.onlineSocket,"removeMapEvent",clearEvents);
         var mapID:int = LocalUserInfo.getMapID();
         if(!MapsConfig.MapsInfo[mapID])
         {
            flag = false;
         }
         else
         {
            flag = Boolean(MapsConfig.MapsInfo[mapID].isLamuWorld);
         }
         if(flag || mapID == 150 || mapID == 166)
         {
            ClothAction.screen_TreadCloths(0,0,0,0,0,0,0);
            ClothAction.screen_Cloths_1(0,0,0,0,0);
         }
         else
         {
            ClothAction.screen_TreadCloths(1,1,1,1,1,1,1);
            ClothAction.screen_Cloths_1(1,1,1,1,1);
         }
      }
      
      public static function clearEvents(E:Event = null) : void
      {
         BC.removeEvent(ClothAction);
      }
      
      public static function screen_TreadCloths(DO:int = 1, fire_DO:int = 1, kintoun:int = 1, purpleKintoun:int = 1, figureSkate:int = 1, sled:int = 1, footprint:int = 1, firefly_DO:int = 1) : void
      {
         screenLib["F12401"] = DO;
         screenLib["F12750"] = fire_DO;
         screenLib["F12648"] = kintoun;
         screenLib["F15394"] = kintoun;
         screenLib["F13246"] = purpleKintoun;
         screenLib["F12203"] = figureSkate;
         screenLib["F14212"] = figureSkate;
         screenLib["F12300"] = sled;
         screenLib["F13163"] = footprint;
         screenLib["F15050"] = firefly_DO;
      }
      
      public static function screen_Cloths_1(visibleCloth:int = 1, ciceroneDesk:int = 1, pentacle:int = 1, catFollow:int = 1, timesChain:int = 1, ghostCatOne:int = 1, ghostCatTwo:int = 1, ghostCatThree:int = 1, ghostCatFoue:int = 1, ghostCatFive:int = 1, ghostCatSix:int = 1, ghostCatSeven:int = 1) : void
      {
         screenLib["F12273"] = visibleCloth;
         screenLib["F12326"] = ciceroneDesk;
         screenLib["F12619"] = pentacle;
         screenLib["F13046"] = catFollow;
         screenLib["F13051"] = timesChain;
         screenLib["F15402"] = ghostCatOne;
         screenLib["F15405"] = ghostCatTwo;
         screenLib["F15408"] = ghostCatThree;
         screenLib["F15411"] = ghostCatFoue;
         screenLib["F15414"] = ghostCatFive;
         screenLib["F15419"] = ghostCatSix;
         screenLib["F15422"] = ghostCatSeven;
      }
      
      public static function checkCloth(PeoPleMC:MovieClip) : void
      {
         executeAll(PeoPleMC);
      }
      
      private static function executeAll(PeoPleMC:MovieClip) : void
      {
         var ClothID:int = 0;
         var ClothObj:Object = null;
         var len:uint = 0;
         var i:int = 0;
         var name:String = null;
         if(PeoPleMC.clothsArray != null)
         {
            ClothObj = {};
            len = uint(PeoPleMC.clothsArray.length);
            for(i = 0; i < len; i++)
            {
               ClothID = int(PeoPleMC.clothsArray[i].ItemID);
               ClothObj["F" + ClothID] = true;
               if(Boolean(screenLib["F" + ClothID]) && Boolean(ClothAction["F" + ClothID]))
               {
                  ClothAction["F" + ClothID](PeoPleMC as PeopleManageView);
               }
            }
            for(name in PeoPleMC.specificObj)
            {
               if(Boolean(PeoPleMC.specificObj[name]))
               {
                  if(!ClothObj[name])
                  {
                     ClothAction["Out" + name](PeoPleMC);
                     PeoPleMC.specificObj[name] = null;
                  }
               }
            }
            flyCarOrDragon(PeoPleMC as PeopleManageView);
            return;
         }
         throw new Error("沒有衣服數組" + PeoPleMC.id);
      }
      
      public static function F13051(PeoPleMC:PeopleManageView) : void
      {
         if(!PeoPleMC.specificObj["F13051"])
         {
            PeoPleMC.specificObj["F13051"] = true;
            if(PeoPleMC.id == GV.MyInfo_userID)
            {
               BC.addEvent(ClothAction,PeoPleMC,PeopleManageView.ON_ACTION_WAVE,timeDoors);
            }
         }
      }
      
      private static function timeDoors(E:Event) : void
      {
         var PeoPleMC:PeopleManageView = E.currentTarget as PeopleManageView;
         if(!MainManager.getGameLevel().getChildByName("transportBord_mc"))
         {
            BC.addEvent(ClothAction,Transport_Lib,AssetsManage.ON_COMPLETE,ontTimeDoorsLoaded);
            Transport_Lib.IncludeLib("Transport_Lib","module/transport/Transport.swf","正在打開時光門...",true,LoaderList.getPRI_Obj(LoaderList.HIGH,true));
         }
      }
      
      private static function ontTimeDoorsLoaded(E:Event) : void
      {
         BC.removeEvent(ClothAction,Transport_Lib,AssetsManage.ON_COMPLETE,ontTimeDoorsLoaded);
         DisplayObjectContainer(Transport_Lib.getLoader().content)["init"]();
      }
      
      public static function OutF13051(PeoPleMC:PeopleManageView) : void
      {
         BC.removeEvent(ClothAction,PeoPleMC,PeopleManageView.ON_ACTION_WAVE,timeDoors);
         PeoPleMC.specificObj["F13051"] = null;
         try
         {
            MainManager.getGameLevel().removeChild(MainManager.getGameLevel().getChildByName("transportBord_mc"));
         }
         catch(e:Error)
         {
         }
      }
      
      public static function F12203(PeoPleMC:PeopleManageView) : void
      {
         var tempClass:BoyAvatar = PeoPleMC.avatarClass as BoyAvatar;
         if(Boolean(tempClass))
         {
            PeoPleMC.specificObj["F12203"] = true;
            tempClass.speed = tempClass.defaultSpeed * 1.4;
         }
      }
      
      public static function OutF12203(PeoPleMC:PeopleManageView) : void
      {
         var tempClass:BoyAvatar = PeoPleMC.avatarClass as BoyAvatar;
         if(Boolean(tempClass))
         {
            tempClass.speed = tempClass.defaultSpeed;
         }
      }
      
      public static function F14212(PeoPleMC:PeopleManageView) : void
      {
         var tempClass:BoyAvatar = PeoPleMC.avatarClass as BoyAvatar;
         if(Boolean(tempClass))
         {
            PeoPleMC.specificObj["F14212"] = true;
            tempClass.speed = tempClass.defaultSpeed * 1.4;
         }
      }
      
      public static function OutF14212(PeoPleMC:PeopleManageView) : void
      {
         var tempClass:BoyAvatar = PeoPleMC.avatarClass as BoyAvatar;
         if(Boolean(tempClass))
         {
            tempClass.speed = tempClass.defaultSpeed;
         }
      }
      
      public static function F13163(PeoPleMC:PeopleManageView) : void
      {
         if(PeoPleMC.hasDragon)
         {
            return;
         }
         getOnFoot(PeoPleMC);
      }
      
      public static function OutF13163(PeoPleMC:PeopleManageView) : void
      {
         if(PeoPleMC.hasDragon)
         {
            return;
         }
         getOffFoot(PeoPleMC);
      }
      
      private static function getOnFoot(PeoPleMC:PeopleManageView) : void
      {
         if(PeoPleMC.hasDragon)
         {
            return;
         }
         if(Boolean(PeoPleMC.car))
         {
            getOffFoot(PeoPleMC);
            return;
         }
         var tempClass:BoyAvatar = PeoPleMC.avatarClass as BoyAvatar;
         if(Boolean(tempClass))
         {
            PeoPleMC.specificObj["F13163"] = true;
            BC.addEvent(ClothAction,PeoPleMC,PeopleManageView.ON_SET_DEPTH,addFootMark);
            BC.addEvent(ClothAction,PeoPleMC,PeopleManageView.ON_GO_START,addFootMark);
         }
      }
      
      private static function addFootMark(e:Event) : void
      {
         var peopleMC:PeopleManageView = PeopleManageView(e.target);
         var tempFootMark:MovieClip = UIManager.getMovieClip("Footmark");
         var tempMarkDirction:uint = 0;
         tempMarkDirction = peopleMC.avatarClass.DirectionNum;
         tempFootMark.gotoAndStop(tempMarkDirction + 1);
         tempFootMark.x = peopleMC.x;
         tempFootMark.y = peopleMC.y;
         var mc:MovieClip = GV.MC_mapFrame;
         if(Boolean(mc))
         {
            mc.addChildAt(tempFootMark,mc.getChildIndex(mc["depth_mc"]) - 1);
         }
      }
      
      private static function getOffFoot(PeoPleMC:PeopleManageView) : void
      {
         var tempClass:BoyAvatar = PeoPleMC.avatarClass as BoyAvatar;
         if(Boolean(tempClass))
         {
            BC.removeEvent(ClothAction,PeoPleMC,PeopleManageView.ON_SET_DEPTH,addFootMark);
            BC.removeEvent(ClothAction,PeoPleMC,PeopleManageView.ON_GO_START,addFootMark);
         }
      }
      
      public static function F12648(PeoPleMC:PeopleManageView) : void
      {
         var tempClass:BoyAvatar = null;
         var shadow:MovieClip = null;
         if(PeoPleMC.hasDragon)
         {
            return;
         }
         if(Boolean(PeoPleMC.car))
         {
            OutF12648(PeoPleMC);
            return;
         }
         tempClass = PeoPleMC.avatarClass as BoyAvatar;
         if(Boolean(tempClass))
         {
            PeoPleMC.specificObj["F12648"] = true;
            PeoPleMC.avatarMC.y = -40;
            shadow = PeoPleMC.avatarMC.shadow_mc as MovieClip;
            shadow.y = 40;
            tempClass.speed = tempClass.defaultSpeed * 1.4;
            BC.addEvent(ClothAction,PeoPleMC,PeopleManageView.ON_GO_START,startdump);
         }
         else
         {
            PeoPleMC.avatarMC.y = 0;
         }
      }
      
      public static function OutF12648(PeoPleMC:PeopleManageView) : void
      {
         var shadow:MovieClip = null;
         if(PeoPleMC.hasDragon)
         {
            return;
         }
         var tempClass:BoyAvatar = PeoPleMC.avatarClass as BoyAvatar;
         if(Boolean(tempClass))
         {
            PeoPleMC.avatarMC.y = 0;
            tempClass.speed = tempClass.defaultSpeed;
            shadow = PeoPleMC.avatarMC.shadow_mc as MovieClip;
            shadow.y = 0;
            BC.removeEvent(ClothAction,PeoPleMC,PeopleManageView.ON_GO_START,startdump);
         }
      }
      
      public static function F13246(PeoPleMC:PeopleManageView) : void
      {
         var shadow:MovieClip = null;
         if(PeoPleMC.hasDragon)
         {
            return;
         }
         if(Boolean(PeoPleMC.car))
         {
            OutF13246(PeoPleMC);
            return;
         }
         var tempClass:BoyAvatar = PeoPleMC.avatarClass as BoyAvatar;
         if(Boolean(tempClass))
         {
            PeoPleMC.specificObj["F13246"] = true;
            PeoPleMC.avatarMC.y = -40;
            shadow = PeoPleMC.avatarMC.shadow_mc as MovieClip;
            shadow.y = 40;
            tempClass.speed = tempClass.defaultSpeed * 1.4;
            BC.addEvent(ClothAction,PeoPleMC,PeopleManageView.ON_GO_START,startdump);
         }
         else
         {
            PeoPleMC.avatarMC.y = 0;
         }
      }
      
      public static function OutF13246(PeoPleMC:PeopleManageView) : void
      {
         var shadow:MovieClip = null;
         if(PeoPleMC.hasDragon)
         {
            return;
         }
         var tempClass:BoyAvatar = PeoPleMC.avatarClass as BoyAvatar;
         if(Boolean(tempClass))
         {
            PeoPleMC.avatarMC.y = 0;
            tempClass.speed = tempClass.defaultSpeed;
            shadow = PeoPleMC.avatarMC.shadow_mc as MovieClip;
            shadow.y = 0;
            BC.removeEvent(ClothAction,PeoPleMC,PeopleManageView.ON_GO_START,startdump);
         }
      }
      
      public static function F15394(PeoPleMC:PeopleManageView) : void
      {
         var shadow:MovieClip = null;
         if(PeoPleMC.hasDragon)
         {
            return;
         }
         if(Boolean(PeoPleMC.car))
         {
            OutF15394(PeoPleMC);
            return;
         }
         var tempClass:BoyAvatar = PeoPleMC.avatarClass as BoyAvatar;
         if(Boolean(tempClass))
         {
            PeoPleMC.specificObj["F15394"] = true;
            PeoPleMC.avatarMC.y = -40;
            shadow = PeoPleMC.avatarMC.shadow_mc as MovieClip;
            shadow.y = 40;
            tempClass.speed = tempClass.defaultSpeed * 1.4;
            BC.addEvent(ClothAction,PeoPleMC,PeopleManageView.ON_GO_START,startdump);
         }
         else
         {
            PeoPleMC.avatarMC.y = 0;
         }
      }
      
      public static function OutF15394(PeoPleMC:PeopleManageView) : void
      {
         var shadow:MovieClip = null;
         if(PeoPleMC.hasDragon)
         {
            return;
         }
         var tempClass:BoyAvatar = PeoPleMC.avatarClass as BoyAvatar;
         if(Boolean(tempClass))
         {
            PeoPleMC.avatarMC.y = 0;
            tempClass.speed = tempClass.defaultSpeed;
            shadow = PeoPleMC.avatarMC.shadow_mc as MovieClip;
            shadow.y = 0;
            BC.removeEvent(ClothAction,PeoPleMC,PeopleManageView.ON_GO_START,startdump);
         }
      }
      
      public static function F12619(PeoPleMC:PeopleManageView) : void
      {
         var tempClass:BoyAvatar = PeoPleMC.avatarClass as BoyAvatar;
         if(Boolean(tempClass))
         {
            PeoPleMC.specificObj["F12619"] = true;
            PeoPleMC.avatarMC.nickName_txt.htmlText = "<font color=\'#FF0000\'>" + PeoPleMC["nickName"] + "</font>";
            PeoPleMC.avatarMC.nickName_txt.filters = [new GlowFilter(16777215,1,2,2,1000)];
         }
      }
      
      public static function OutF12619(PeoPleMC:PeopleManageView) : void
      {
         var tempClass:BoyAvatar = PeoPleMC.avatarClass as BoyAvatar;
         if(Boolean(tempClass))
         {
            PeoPleMC.avatarMC.nickName_txt.text = PeoPleMC["nickName"];
            PeoPleMC.avatarMC.nickName_txt.filters = [];
         }
      }
      
      public static function F12300(PeoPleMC:PeopleManageView) : void
      {
         var tempClass:BoyAvatar = PeoPleMC.avatarClass as BoyAvatar;
         if(Boolean(tempClass))
         {
            PeoPleMC.specificObj["F12300"] = true;
            tempClass.speed = tempClass.defaultSpeed * 1.5;
         }
      }
      
      public static function OutF12300(PeoPleMC:PeopleManageView) : void
      {
         var tempClass:BoyAvatar = PeoPleMC.avatarClass as BoyAvatar;
         if(Boolean(tempClass))
         {
            tempClass.speed = tempClass.defaultSpeed;
         }
      }
      
      public static function F12273(PeoPleMC:PeopleManageView) : void
      {
         if(!PeoPleMC.isActionMovie)
         {
            PeoPleMC.specificObj["F12273"] = true;
            PeoPleMC.isVisible = true;
            if(PeoPleMC.id == LocalUserInfo.getUserID())
            {
               PeoPleMC.avatarMC.Visualize_mc.visible = false;
            }
            else
            {
               PeoPleMC.avatarMC.Visualize_mc.visible = false;
               PeoPleMC.avatarMC.shadow_mc.visible = false;
               PeoPleMC.avatarMC.nickName_txt.visible = false;
            }
         }
         else
         {
            OutF12273(PeoPleMC);
         }
      }
      
      public static function OutF12273(PeoPleMC:PeopleManageView) : void
      {
         PeoPleMC.isVisible = false;
         PeoPleMC.avatarMC.Visualize_mc.visible = true;
         PeoPleMC.avatarMC.shadow_mc.visible = true;
         PeoPleMC.avatarMC.nickName_txt.visible = true;
      }
      
      public static function F12326(PeoPleMC:PeopleManageView) : void
      {
         if(!PeoPleMC.isActionMovie)
         {
            PeoPleMC.specificObj["F12326"] = true;
         }
         else
         {
            OutF12326(PeoPleMC);
         }
      }
      
      public static function OutF12326(PeoPleMC:PeopleManageView) : void
      {
         PeoPleMC.specificObj["F12326"] = null;
      }
      
      public static function F12750(PeoPleMC:PeopleManageView) : void
      {
         if(PeoPleMC.hasDragon)
         {
            return;
         }
         if(Boolean(PeoPleMC.car))
         {
            return;
         }
         if(!PeoPleMC.isActionMovie)
         {
            PeoPleMC.specificObj["F12750"] = true;
            BC.addEvent(ClothAction,PeoPleMC,PeopleManageView.ON_GO_START,startMove);
         }
         else
         {
            OutF12750(PeoPleMC);
         }
      }
      
      public static function F15050(PeoPleMC:PeopleManageView) : void
      {
         if(PeoPleMC.hasDragon)
         {
            return;
         }
         if(Boolean(PeoPleMC.car))
         {
            return;
         }
         if(!PeoPleMC.isActionMovie)
         {
            PeoPleMC.specificObj["F15050"] = true;
            BC.addEvent(ClothAction,PeoPleMC,PeopleManageView.ON_GO_START,startMove);
         }
         else
         {
            OutF15050(PeoPleMC);
         }
      }
      
      public static function startMove(E:Event) : void
      {
         var m:int;
         var da:Array;
         var PeoPleMC:PeopleManageView = null;
         var tempClass:BoyAvatar = null;
         PeoPleMC = E.target as PeopleManageView;
         if(PeoPleMC.hasDragon)
         {
            return;
         }
         m = int(GV.MapInfo_mapID);
         da = [98,99,100];
         if(da.indexOf(m) > -1)
         {
            if(Boolean(PeoPleMC.specificObj["F12648"]) || Boolean(PeoPleMC.specificObj["F13246"]) || Boolean(PeoPleMC.specificObj["F15394"]))
            {
               PeoPleMC.stopAction(tempClass.currentDirection);
            }
            return;
         }
         if(Boolean(PeoPleMC.car))
         {
            return;
         }
         tempClass = PeoPleMC.avatarClass as BoyAvatar;
         if(!tempClass || PeoPleMC.isFlying)
         {
            return;
         }
         if(!PeoPleMC.specificObj["F12750"] && !PeoPleMC.specificObj["F15050"])
         {
            BC.removeEvent(ClothAction,PeoPleMC,PeopleManageView.ON_GO_START,startMove);
            return;
         }
         PeoPleMC.isFlying = true;
         tempClass.myTween_X.stop();
         tempClass.myTween_Y.stop();
         PeoPleMC.stopAction(tempClass.currentDirection);
         if(Boolean(PeoPleMC.specificObj["F12750"]))
         {
            PeoPleMC.avatarMC.tomatoMC.hlz_mc.gotoAndPlay(3);
         }
         else if(Boolean(PeoPleMC.specificObj["F15050"]))
         {
            PeoPleMC.avatarMC.tomatoMC.yhc_mc.gotoAndPlay(3);
         }
         GC.setGTimeout(function():void
         {
            PeoPleMC.x = PeoPleMC.endX;
            PeoPleMC.y = PeoPleMC.endY;
            PeoPleMC.isFlying = false;
            GC.setGTimeout(tempClass.goOver,500);
         },500);
      }
      
      public static function OutF12750(PeoPleMC:PeopleManageView) : void
      {
         if(PeoPleMC.hasDragon)
         {
            return;
         }
         PeoPleMC.specificObj["F12750"] = null;
      }
      
      public static function OutF15050(PeoPleMC:PeopleManageView) : void
      {
         if(PeoPleMC.hasDragon)
         {
            return;
         }
         PeoPleMC.specificObj["F15050"] = null;
      }
      
      public static function F13046(PeoPleMC:PeopleManageView) : void
      {
         getLib(PeoPleMC);
      }
      
      public static function OutF13046(PeoPleMC:PeopleManageView) : void
      {
         var animalObj:IAnimal_Follow = PeoPleMC.specificObj["F13046"] as IAnimal_Follow;
         if(Boolean(animalObj))
         {
            animalObj.clearClass();
         }
         PeoPleMC.specificObj["F13046"] = null;
      }
      
      public static function F15402(PeoPleMC:PeopleManageView) : void
      {
         getNewLib(PeoPleMC,15402);
      }
      
      public static function OutF15402(PeoPleMC:PeopleManageView) : void
      {
         var animalObj:IAnimal_Follow = PeoPleMC.specificObj["F15402"] as IAnimal_Follow;
         if(Boolean(animalObj))
         {
            animalObj.clearClass();
         }
         PeoPleMC.specificObj["F15402"] = null;
      }
      
      public static function F15405(PeoPleMC:PeopleManageView) : void
      {
         getNewLib(PeoPleMC,15405);
      }
      
      public static function OutF15405(PeoPleMC:PeopleManageView) : void
      {
         var animalObj:IAnimal_Follow = PeoPleMC.specificObj["F15405"] as IAnimal_Follow;
         if(Boolean(animalObj))
         {
            animalObj.clearClass();
         }
         PeoPleMC.specificObj["F15405"] = null;
      }
      
      public static function F15408(PeoPleMC:PeopleManageView) : void
      {
         getNewLib(PeoPleMC,15408);
      }
      
      public static function OutF15408(PeoPleMC:PeopleManageView) : void
      {
         var animalObj:IAnimal_Follow = PeoPleMC.specificObj["F15408"] as IAnimal_Follow;
         if(Boolean(animalObj))
         {
            animalObj.clearClass();
         }
         PeoPleMC.specificObj["F15408"] = null;
      }
      
      public static function F15411(PeoPleMC:PeopleManageView) : void
      {
         getNewLib(PeoPleMC,15411);
      }
      
      public static function OutF15411(PeoPleMC:PeopleManageView) : void
      {
         var animalObj:IAnimal_Follow = PeoPleMC.specificObj["F15411"] as IAnimal_Follow;
         if(Boolean(animalObj))
         {
            animalObj.clearClass();
         }
         PeoPleMC.specificObj["F15411"] = null;
      }
      
      public static function F15414(PeoPleMC:PeopleManageView) : void
      {
         getNewLib(PeoPleMC,15414);
      }
      
      public static function OutF15414(PeoPleMC:PeopleManageView) : void
      {
         var animalObj:IAnimal_Follow = PeoPleMC.specificObj["F15414"] as IAnimal_Follow;
         if(Boolean(animalObj))
         {
            animalObj.clearClass();
         }
         PeoPleMC.specificObj["F15414"] = null;
      }
      
      public static function F15419(PeoPleMC:PeopleManageView) : void
      {
         getNewLib(PeoPleMC,15419);
      }
      
      public static function OutF15419(PeoPleMC:PeopleManageView) : void
      {
         var animalObj:IAnimal_Follow = PeoPleMC.specificObj["F15419"] as IAnimal_Follow;
         if(Boolean(animalObj))
         {
            animalObj.clearClass();
         }
         PeoPleMC.specificObj["F15419"] = null;
      }
      
      public static function F15422(PeoPleMC:PeopleManageView) : void
      {
         getNewLib(PeoPleMC,15422);
      }
      
      public static function OutF15422(PeoPleMC:PeopleManageView) : void
      {
         var animalObj:IAnimal_Follow = PeoPleMC.specificObj["F15422"] as IAnimal_Follow;
         if(Boolean(animalObj))
         {
            animalObj.clearClass();
         }
         PeoPleMC.specificObj["F15422"] = null;
      }
      
      private static function getLib(PeoPleMC:PeopleManageView) : void
      {
         var loadLibcomplete:Function = null;
         fieldItemID = 13046;
         pool_1270004.push(PeoPleMC);
         loadLibcomplete = function(E:Event):void
         {
            var p:PeopleManageView = null;
            var id:int = 0;
            var r:int = 0;
            BC.removeEvent(ClothAction,FieldView.Field_Lib,AssetsManage.ON_COMPLETE,loadLibcomplete);
            while(Boolean(pool_1270004.length))
            {
               p = pool_1270004.shift();
               id = 1270013;
               r = Math.random() * 5;
               if(r == 0)
               {
                  id = 1270013;
               }
               else if(r == 1)
               {
                  id = 1270014;
               }
               else if(r == 2)
               {
                  id = 1270049;
               }
               else if(r == 3)
               {
                  id = 1270050;
               }
               else if(r == 4)
               {
                  id = 1270051;
               }
               flowPeople(p,id);
            }
         };
         BC.addEvent(ClothAction,FieldView.Field_Lib,AssetsManage.ON_COMPLETE,loadLibcomplete);
         FieldView.Field_Lib.IncludeLib("Field_Lib",Links.getUrl("module/field/FieldManage.swf"),"正在召喚毛毛怪...",false);
      }
      
      private static function getNewLib(PeoPleMC:PeopleManageView, animalID:uint) : void
      {
         var loadLibcomplete:Function = null;
         fieldItemID = animalID;
         loadLibcomplete = function(E:Event):void
         {
            var id:int = 0;
            BC.removeEvent(ClothAction,FieldView.Field_Lib,AssetsManage.ON_COMPLETE,loadLibcomplete);
            var p:PeopleManageView = PeoPleMC;
            switch(animalID)
            {
               case 15402:
                  id = 1270151;
                  break;
               case 15405:
                  id = 1270150;
                  break;
               case 15408:
                  id = 1270149;
                  break;
               case 15411:
                  id = 1270148;
                  break;
               case 15414:
                  id = 1270147;
                  break;
               case 15419:
                  id = 1270146;
                  break;
               case 15422:
                  id = 1270145;
            }
            flowPeople(p,id);
         };
         BC.addEvent(ClothAction,FieldView.Field_Lib,AssetsManage.ON_COMPLETE,loadLibcomplete);
         FieldView.Field_Lib.IncludeLib("Field_Lib",Links.getUrl("module/field/FieldManage.swf"),"正在召喚毛毛怪...",false);
      }
      
      private static function flowPeople(PeoPleMC:PeopleManageView, animalID:uint) : void
      {
         trace("PeoPleMC.specificObj[F13046]" + PeoPleMC.specificObj["F13046"]);
         trace("PeoPleMC.specificObj[F15402]" + PeoPleMC.specificObj["F15402"]);
         trace("PeoPleMC.specificObj[F15405]" + PeoPleMC.specificObj["F15405"]);
         trace("PeoPleMC.specificObj[F15408]" + PeoPleMC.specificObj["F15408"]);
         trace("PeoPleMC.specificObj[F15411]" + PeoPleMC.specificObj["F15411"]);
         trace("PeoPleMC.specificObj[F15414]" + PeoPleMC.specificObj["F15414"]);
         trace("PeoPleMC.specificObj[F15419]" + PeoPleMC.specificObj["F15419"]);
         trace("PeoPleMC.specificObj[F15422]" + PeoPleMC.specificObj["F15422"]);
         trace("//////////////////////////////////////////////////////////////");
         if(Boolean(!PeoPleMC.stage) || Boolean(PeoPleMC.specificObj["F13046"]) || Boolean(PeoPleMC.specificObj["F15402"]) || Boolean(PeoPleMC.specificObj["F15405"]) || Boolean(PeoPleMC.specificObj["F15408"]) || Boolean(PeoPleMC.specificObj["F15411"]) || Boolean(PeoPleMC.specificObj["F15414"]) || Boolean(PeoPleMC.specificObj["F15419"]) || Boolean(PeoPleMC.specificObj["F15422"] as IAnimal_Follow))
         {
            return;
         }
         var fieldAnimalClass:Class = FieldView.Field_Lib.getClass("LandAnimal_Follow");
         var id:uint = animalID;
         var anm:Object = new Object();
         anm.NO = 7777;
         anm.ID = id;
         anm.Flag = 0;
         anm.Value = 600;
         anm.Type = 1;
         var tobj:Object = GoodsInfo.getInfoById(animalID);
         anm.typeObject = tobj.typeObject;
         anm.id = anm.ID;
         anm.name = tobj.name;
         anm.price = tobj.price;
         anm.Class = tobj.Class;
         anm.LevelArray = tobj.LevelArray;
         anm.quantifier = tobj.quantifier;
         anm.Fruit = tobj.Fruit;
         anm.growth = tobj.growth;
         anm.water = tobj.water;
         anm.speed = tobj.speed;
         anm.floatSpeed = tobj.floatSpeed;
         anm.floatMoveTime = tobj.floatMoveTime;
         anm.baseMoveTime = tobj.baseMoveTime;
         anm.acedia = tobj.acedia;
         var fieldAnimal:IAnimal_Follow = new fieldAnimalClass() as IAnimal_Follow;
         fieldAnimal.showAnimal(new AnimalInfo(anm));
         fieldAnimal.followMole(PeoPleMC);
         var str:String = String("F" + fieldItemID);
         trace("賦予的物品的字符串是lucaslu" + str);
         if(!PeoPleMC.specificObj[str])
         {
            PeoPleMC.specificObj[str] = fieldAnimal;
         }
      }
      
      public static function F12401(PeoPleMC:PeopleManageView) : void
      {
         var tempClass:BoyAvatar = null;
         if(PeoPleMC.hasDragon)
         {
            return;
         }
         if(Boolean(PeoPleMC.car))
         {
            return;
         }
         if(!PeoPleMC.isActionMovie)
         {
            PeoPleMC.specificObj["F12401"] = true;
            tempClass = PeoPleMC.avatarClass as BoyAvatar;
            if(Boolean(tempClass))
            {
               if(Boolean(PeoPleMC.specificObj["F12203"]) || Boolean(PeoPleMC.specificObj["F14212"]))
               {
                  tempClass.speed = tempClass.defaultSpeed * 1.4;
               }
               else
               {
                  tempClass.speed = tempClass.defaultSpeed * 1.2;
               }
            }
            BC.addEvent(ClothAction,PeoPleMC,PeopleManageView.ON_GO_START,startdump);
         }
         else
         {
            OutF12401(PeoPleMC);
         }
      }
      
      public static function flyCarOrDragon(PeoPleMC:PeopleManageView) : void
      {
         if(PeoPleMC.hasDragon && PeoPleMC == GV.MAN_PEOPLE)
         {
            ClothAction.screen_TreadCloths(0,0,0,0,0,0,0);
            ClothAction.screen_Cloths_1(1,0,1,1,1);
         }
         if(PeoPleMC.hasDragon)
         {
            return;
         }
         if(Boolean(PeoPleMC.car) && PeoPleMC.car.carInfo.ItemID == 1300009)
         {
            PeoPleMC.specificObj["F12401"] = null;
            if(!PeoPleMC.isActionMovie)
            {
               BC.addEvent(ClothAction,PeoPleMC,PeopleManageView.ON_GO_START,startdump);
            }
         }
      }
      
      public static function startdump(E:Event) : void
      {
         var obj1:Object = null;
         var obj2:Object = null;
         var p1:Point = null;
         var p3:Point = null;
         var temp:throwThingLogic = null;
         var yunMC:MovieClip = null;
         var PeoPleMC:PeopleManageView = E.target as PeopleManageView;
         if(PeoPleMC.hasDragon)
         {
            return;
         }
         if(Boolean(PeoPleMC.car) && PeoPleMC.car.carInfo.ItemID != 1300009)
         {
            return;
         }
         var tempClass:BoyAvatar = PeoPleMC.avatarClass as BoyAvatar;
         if((Boolean(!tempClass) || Boolean(PeoPleMC.specificObj["F12750"])) && (Boolean(!tempClass) || Boolean(PeoPleMC.specificObj["F15050"])))
         {
            return;
         }
         var m:int = int(GV.MapInfo_mapID);
         var da:Array = [98,99,100];
         if(da.indexOf(m) > -1)
         {
            if(Boolean(PeoPleMC.specificObj["F12648"]) || Boolean(PeoPleMC.specificObj["F13246"]) || Boolean(PeoPleMC.specificObj["F15394"]))
            {
               PeoPleMC.stopAction(tempClass.currentDirection);
            }
            return;
         }
         if(!PeoPleMC.specificObj["F12401"] && !PeoPleMC.specificObj["F12648"] && !PeoPleMC.specificObj["F15394"] && !PeoPleMC.specificObj["F13246"] && (Boolean(!PeoPleMC.car) || Boolean(PeoPleMC.car && PeoPleMC.car.carInfo.ItemID != 1300009)))
         {
            BC.removeEvent(ClothAction,PeoPleMC,PeopleManageView.ON_GO_START,startdump);
            return;
         }
         if(PeoPleMC.isFlying)
         {
            tempClass.stopToHere();
            return;
         }
         if(Boolean(PeoPleMC.specificObj["F12648"]) || Boolean(PeoPleMC.specificObj["F13246"]) || Boolean(PeoPleMC.specificObj["F15394"]))
         {
            PeoPleMC.stopAction(tempClass.currentDirection);
         }
         var len:int = Point.distance(new Point(PeoPleMC.startX,PeoPleMC.startY),new Point(PeoPleMC.endX,PeoPleMC.endY));
         if(Boolean(PeoPleMC.isFlying_double))
         {
            len = 1000;
         }
         if(Boolean(!PeoPleMC.isActionMovie) && Boolean(tempClass) && (Boolean(len > 320) || Boolean(tempClass.path && tempClass.path.length > 2)))
         {
            delete PeoPleMC.isFlying_double;
            obj1 = {
               "X":PeoPleMC.startX,
               "Y":PeoPleMC.startY
            };
            obj2 = {
               "X":PeoPleMC.endX,
               "Y":PeoPleMC.endY
            };
            tempClass.changeDirectionByObject(obj1,obj2);
            tempClass.stopToHere();
            p1 = new Point(PeoPleMC.x,PeoPleMC.y);
            p3 = new Point(PeoPleMC.endX,PeoPleMC.endY);
            if(Boolean(PeoPleMC.flyTimer))
            {
               BC.removeEvent(ClothAction,PeoPleMC.flyTimer);
               BC.removeEvent(ClothAction,PeoPleMC.flyTimer.MyID);
               PeoPleMC.flyTimer.MyID.stop();
            }
            temp = new throwThingLogic();
            PeoPleMC.flyTimer = temp;
            temp.D_time = 5;
            temp.topSize = 2;
            BC.addEvent(ClothAction,temp,throwThingLogic.Throw_OVER,dumpOver);
            BC.addEvent(ClothAction,temp,throwThingLogic.Throw_TIMER,moveShadow);
            temp.throwProp(PeoPleMC,p1,p3);
            PeoPleMC.isFlying = true;
            PeoPleMC.flyBezier = new BezierSegment(p1,p1,p3,p3);
            PeoPleMC.changeLayer(MapModelLogic.AIR_LAYER);
            if(Boolean(PeoPleMC.specificObj["F12401"]) && !PeoPleMC.avatarMC.getChildByName("yun_mc"))
            {
               yunMC = IndexManager.getInstance().getMovieClip("yun_mc");
               yunMC.scaleX = yunMC.scaleY = PeoPleMC.avatarMC.Visualize_mc.scaleX;
               yunMC.name = "yun_mc";
               PeoPleMC.avatarMC.addChild(yunMC);
            }
         }
      }
      
      public static function moveShadow(E:EventTaomee) : void
      {
         var shadow:MovieClip = null;
         var bezier:BezierSegment = null;
         var offsetY:int = 0;
         var yunMC:MovieClip = null;
         var PeoPleMC:PeopleManageView = E.EventObj.targetMC as PeopleManageView;
         var time:Number = Number(E.EventObj.time);
         var degrees:Number = Number(E.EventObj.degrees);
         if(Boolean(PeoPleMC.avatarMC) && Boolean(PeoPleMC.avatarMC.shadow_mc))
         {
            shadow = PeoPleMC.avatarMC.shadow_mc as MovieClip;
            bezier = PeoPleMC.flyBezier;
            offsetY = (PeoPleMC.y - bezier.a.y) * -1;
            if(Boolean(PeoPleMC.specificObj["F12648"]) || Boolean(PeoPleMC.specificObj["F13246"]) || Boolean(PeoPleMC.specificObj["F15394"]))
            {
               shadow.y = offsetY + 40;
            }
            else
            {
               shadow.y = offsetY;
            }
            if(Math.abs(bezier.a.x - bezier.d.x) < 6)
            {
               shadow.y += bezier.getValue(time).y - bezier.a.y;
            }
            else
            {
               shadow.y += bezier.getYForX(PeoPleMC.x) - bezier.a.y;
            }
         }
         else
         {
            if(Boolean(PeoPleMC.avatarMC))
            {
               yunMC = PeoPleMC.avatarMC.getChildByName("yun_mc") as MovieClip;
               if(Boolean(yunMC))
               {
                  yunMC.stop();
                  PeoPleMC.avatarMC.removeChild(yunMC);
               }
            }
            if(Boolean(PeoPleMC.flyTimer))
            {
               PeoPleMC.flyTimer.MyID.stop();
            }
            PeoPleMC.flyTimer = null;
            PeoPleMC.flyBezier = null;
            PeoPleMC.isFlying = false;
         }
      }
      
      public static function dumpOver(E:EventTaomee) : void
      {
         var shadow:MovieClip = null;
         var yunMC:MovieClip = null;
         BC.removeEvent(ClothAction,E.target,throwThingLogic.Throw_TIMER,moveShadow);
         BC.removeEvent(ClothAction,E.target,throwThingLogic.Throw_OVER,dumpOver);
         var PeoPleMC:PeopleManageView = E.EventObj as PeopleManageView;
         var tempClass:* = PeoPleMC.avatarClass;
         PeoPleMC.x = E.target.targetPoint.x;
         PeoPleMC.y = E.target.targetPoint.y;
         if(Boolean(tempClass))
         {
            tempClass.dispatchEvent(new Event(PeopleManageView.ON_GO_OVER));
            PeoPleMC.dispatchEvent(new Event(PeopleManageView.ON_GO_OVER));
            tempClass.setDepth();
         }
         if(Boolean(PeoPleMC.avatarMC) && Boolean(PeoPleMC.avatarMC.shadow_mc))
         {
            shadow = PeoPleMC.avatarMC.shadow_mc as MovieClip;
            if(Boolean(shadow))
            {
               if(PeoPleMC == GV.MAN_PEOPLE)
               {
                  shadow.gotoAndStop(5);
               }
               shadow.x = 0;
               shadow.y = 0;
               if(Boolean(PeoPleMC.specificObj["F12648"]) || Boolean(PeoPleMC.specificObj["F13246"]) || Boolean(PeoPleMC.specificObj["F15394"]))
               {
                  shadow.y = 40;
               }
            }
            PeoPleMC.avatarMC.x = 0;
            PeoPleMC.avatarMC.y = 0;
            if(Boolean(PeoPleMC.specificObj["F12648"]) || Boolean(PeoPleMC.specificObj["F13246"]) || Boolean(PeoPleMC.specificObj["F15394"]))
            {
               PeoPleMC.avatarMC.y = -40;
            }
         }
         if(Boolean(PeoPleMC.avatarMC))
         {
            PeoPleMC.avatarMC.y = 0;
            if(Boolean(PeoPleMC.specificObj["F12648"]) || Boolean(PeoPleMC.specificObj["F13246"]) || Boolean(PeoPleMC.specificObj["F15394"]))
            {
               PeoPleMC.avatarMC.y = -40;
            }
            yunMC = PeoPleMC.avatarMC.getChildByName("yun_mc") as MovieClip;
            if(Boolean(yunMC))
            {
               yunMC.stop();
               PeoPleMC.avatarMC.removeChild(yunMC);
            }
         }
         if(Boolean(PeoPleMC.flyTimer))
         {
            PeoPleMC.flyTimer.MyID.stop();
         }
         PeoPleMC.flyTimer = null;
         PeoPleMC.flyBezier = null;
         PeoPleMC.isFlying = false;
         PeoPleMC.changeLayer(MapModelLogic.FLOOR_LAYER);
         if(PeoPleMC.x != PeoPleMC.endX || PeoPleMC.y != PeoPleMC.endY)
         {
            BC.addEvent(ClothAction,PeoPleMC,PeopleManageView.ON_GO_START,startdump);
            PeoPleMC.isFlying_double = true;
            PeoPleMC.dispatchEvent(new Event(PeopleManageView.ON_GO_START));
            if(Boolean(PeoPleMC["avatarClass"]))
            {
               PeoPleMC.stopAction();
            }
         }
      }
      
      public static function OutF12401(PeoPleMC:PeopleManageView) : void
      {
         if(PeoPleMC.hasDragon)
         {
            return;
         }
         if(PeoPleMC.layer == MapModelLogic.AIR_LAYER)
         {
            PeoPleMC.changeLayer(MapModelLogic.FLOOR_LAYER);
         }
         PeoPleMC.specificObj["F12401"] = null;
         PeoPleMC.avatarMC.y = 0;
         if(Boolean(PeoPleMC.specificObj["F12648"]) || Boolean(PeoPleMC.specificObj["F13246"]) || Boolean(PeoPleMC.specificObj["F15394"]))
         {
            PeoPleMC.avatarMC.y = -40;
         }
         PeoPleMC.isFlying = false;
         var tempClass:BoyAvatar = PeoPleMC.avatarClass as BoyAvatar;
         if(Boolean(tempClass))
         {
            tempClass.speed = tempClass.defaultSpeed;
         }
         flyCarOrDragon(PeoPleMC);
      }
      
      public static function stopFlyCarOrDragon(PeoPleMC:PeopleManageView) : void
      {
         if(PeoPleMC.hasDragon)
         {
            if(PeoPleMC == GV.MAN_PEOPLE)
            {
               getClearMapListener();
            }
         }
         if(PeoPleMC.layer == MapModelLogic.AIR_LAYER)
         {
            PeoPleMC.changeLayer(MapModelLogic.FLOOR_LAYER);
         }
         PeoPleMC.avatarMC.y = 0;
         PeoPleMC.isFlying = false;
         var tempClass:BoyAvatar = PeoPleMC.avatarClass as BoyAvatar;
         if(Boolean(tempClass))
         {
            tempClass.speed = tempClass.defaultSpeed;
         }
         checkCloth(PeoPleMC);
      }
   }
}

