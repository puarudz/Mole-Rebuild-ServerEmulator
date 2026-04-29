package com.view.PeopleView.ChildPeople
{
   import com.common.util.DisplayUtil;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.objectPool.ObjectPool;
   import com.event.EventTaomee;
   import com.logic.MapManageLogic.MapDepthManageLogic;
   import com.logic.MapManageLogic.MapModelLogic;
   import com.view.PeopleView.PeopleManageView;
   import com.view.player.MultiEquipPlayer;
   import com.view.player.PlayerActionConstant;
   import com.view.player.TransfigurationMultiEquipPlayer;
   import fl.transitions.Tween;
   import fl.transitions.TweenEvent;
   import fl.transitions.easing.Elastic;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.BevelFilter;
   import flash.filters.BlurFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import flash.utils.Timer;
   
   public class simplePeople extends EventDispatcher
   {
      
      public static var DIR_UP:String = "up";
      
      public static var DIR_DOWN:String = "down";
      
      public static var DIR_LEFT:String = "left";
      
      public static var DIR_LEFT_UP:String = "leftup";
      
      public static var DIR_LEFT_DOWN:String = "leftdown";
      
      public static var DIR_RIGHT:String = "right";
      
      public static var DIR_RIGHT_UP:String = "rightup";
      
      public static var DIR_RIGHT_DOWN:String = "rightdown";
      
      public static const DIR_LIST:Vector.<String> = new <String>[DIR_DOWN,DIR_LEFT_DOWN,DIR_LEFT,DIR_LEFT_UP,DIR_UP,DIR_RIGHT_UP,DIR_RIGHT,DIR_RIGHT_DOWN];
      
      public static const LABEL_ACTION_ARR:Array = [DIR_DOWN,DIR_LEFT_DOWN,DIR_LEFT,DIR_LEFT_UP,DIR_UP,DIR_RIGHT_UP,DIR_RIGHT,DIR_RIGHT_DOWN];
      
      public var Effect:Object;
      
      public var EffectType:uint = 0;
      
      public var myTween:Tween;
      
      public var myTween2:Tween;
      
      public var clothClass:ChangeCloths;
      
      public var delayTimeout:Timer;
      
      public var getJPGTimer:Timer;
      
      public var isdoAction:Boolean;
      
      public var isRuning:Boolean;
      
      public var _currentDirection:String = "down";
      
      public var oldDirection:uint;
      
      public var DirectionNum:uint;
      
      public var currentNum:uint = 0;
      
      public var delay:uint = 40;
      
      public var defaultSpeed:uint = 100;
      
      private var _speed:uint = this.defaultSpeed;
      
      public var path:Array;
      
      public var avatarMC:MovieClip;
      
      private var _InstanceMC:PeopleManageView;
      
      public var bodyBG_mc:MovieClip;
      
      public var body_mc:MovieClip;
      
      public var kyteMC:MovieClip;
      
      public var shadowMC:MovieClip;
      
      public var isActionMovie:Boolean;
      
      public var offset:uint = 10;
      
      private var prevN:uint = 0;
      
      private var prevX:int = 0;
      
      private var prevY:int = 0;
      
      public var myTween_X:Tween;
      
      public var myTween_Y:Tween;
      
      public var multiEquipPlayer:MultiEquipPlayer;
      
      private var throwMc:MovieClip;
      
      public function simplePeople()
      {
         super();
      }
      
      public function initSimplePeople(instanceMC:MovieClip, mc:MovieClip) : void
      {
         this.currentDirection = "down";
         this.oldDirection = 0;
         this.DirectionNum = 0;
         this.InstanceMC = instanceMC as PeopleManageView;
         this.defaultSpeed = 100;
         this.speed = this.defaultSpeed;
         this.isActionMovie = false;
         this.isRuning = false;
         this.currentDirection = this.getDirectionString(int(Math.random() * 8));
         this.offset = 10;
         this.avatarMC = mc;
         this.Effect = new Object();
         this.isActionMovie = false;
         this.InstanceMC.isActionMovie = false;
         instanceMC = null;
         this.initAvatar();
         if(this.InstanceMC.id == GV.MyInfo_userID)
         {
            BC.addEvent(this,GV.onlineSocket,"mouseMoveRemove",this.removeMouseMove);
         }
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.reMoveInstanceMC);
         this.InstanceMC.isMoving = false;
         this.clothClass = ObjectPool.getObject(ChangeCloths);
         BC.addEvent(this,this,PeopleManageView.ON_CHANGE_CLOTHS,this.initHandler);
         this.clothClass.init(this.InstanceMC);
         this.shadowMC = this.clothClass.shadowMC;
         this.myTween_X = new Tween(this.InstanceMC,"x",null,this.InstanceMC.x,this.InstanceMC.x,1,true);
         this.myTween_X.stop();
         this.myTween_Y = new Tween(this.InstanceMC,"y",null,this.InstanceMC.y,this.InstanceMC.y,1,true);
         BC.addEvent(this,this.myTween_Y,TweenEvent.MOTION_FINISH,this.onMotionFinishedY);
         BC.addEvent(this,this.myTween_Y,TweenEvent.MOTION_CHANGE,this.onMotionChangeY);
         this.myTween_Y.stop();
      }
      
      public function initAvatar() : void
      {
         var isGM:Boolean = false;
         var isVip:Object = this._InstanceMC.Vip >> 0 & 1;
         if(Boolean(isVip))
         {
            this.avatarMC.nickName_txt.htmlText = "<font color=\'#FF0000\'>" + this.InstanceMC["nickName"] + "</font>";
         }
         else
         {
            isGM = GF.returnGM(this.InstanceMC.id);
            if(isGM)
            {
               this.avatarMC.nickName_txt.htmlText = "<font color=\'#0000FF\'>" + this.InstanceMC["nickName"] + "</font>";
            }
            else
            {
               this.avatarMC.nickName_txt.text = this.InstanceMC["nickName"];
            }
         }
         this.avatarMC.nickName_txt.x = -this.avatarMC.nickName_txt.width / 2;
         this.avatarMC.status_txt.visible = false;
         GC.clearAllChildren(this.avatarMC.Visualize_mc);
         this.isActionMovie = false;
         this.body_mc = new MovieClip();
         var myColor:Object = this.InstanceMC.colorObj;
         this.body_mc.name = "body_mc";
         this.kyteMC = new MovieClip();
         this.kyteMC.name = "kyteMC";
         if(Boolean(this.multiEquipPlayer))
         {
            this.multiEquipPlayer.dispose();
            if(Boolean(this.avatarMC.Visualize_mc.contains(this.multiEquipPlayer)))
            {
               this.avatarMC.Visualize_mc.removeChild(this.multiEquipPlayer);
            }
            this.multiEquipPlayer = null;
         }
         if(this.InstanceMC.roleType == 0)
         {
            this.multiEquipPlayer = new MultiEquipPlayer(this.InstanceMC.colorObj);
         }
         else
         {
            this.multiEquipPlayer = new TransfigurationMultiEquipPlayer(this.InstanceMC.colorObj);
            TransfigurationMultiEquipPlayer(this.multiEquipPlayer).changeNude(this.InstanceMC.roleType);
         }
         this.avatarMC.Visualize_mc.addChild(this.multiEquipPlayer);
         this.multiEquipPlayer.addEventListener(MultiEquipPlayer.CHANGE_CLOTH_OVER,this.onClothsChange);
         this.multiEquipPlayer.addEventListener(MultiEquipPlayer.THROW_ITEM_INIT,this.throwThingInit);
         this.multiEquipPlayer.addEventListener(MultiEquipPlayer.THROW_ITEM_START,this.throwThingStart);
         this.bodyBG_mc = new MovieClip();
         this.bodyBG_mc.x = -480;
         this.bodyBG_mc.y = -300;
         this.bodyBG_mc.name = "bodyBG_mc";
         this.avatarMC.addChild(this.bodyBG_mc);
         this.avatarMC.setChildIndex(this.bodyBG_mc,0);
         this.avatarMC.Visualize_mc.addChild(this.body_mc);
         this.avatarMC.Visualize_mc.addChild(this.kyteMC);
         if(this.InstanceMC.address == "17003")
         {
            this.scaleBody(1.5);
         }
         else if(this.InstanceMC.address == "120000")
         {
            this.InstanceMC.scaleXY(2);
         }
         else
         {
            this.avatarMC.shadow_mc.scaleX = this.avatarMC.shadow_mc.scaleY = 1;
         }
         BC.addEvent(this,this.body_mc,Event.REMOVED_FROM_STAGE,this.clearProp);
         this.setDepth();
      }
      
      public function changeCloth(clothArr:Array) : void
      {
         var cloth:Object = null;
         var ld:Loader = null;
         for each(cloth in clothArr)
         {
            if(this.bodyBG_mc.numChildren > 0)
            {
               DisplayUtil.removeAllChild(this.bodyBG_mc);
            }
            if(cloth.layer == 88)
            {
               ld = new Loader();
               ld.load(new URLRequest(VL.getURL("resource/cloth/swf/" + cloth.id + ".swf")));
               this.bodyBG_mc.addChild(ld);
            }
         }
         this.multiEquipPlayer.updateEquip(clothArr);
      }
      
      public function changeRoleType(roleType:uint) : void
      {
         if(roleType == 0)
         {
            if(Boolean(this.multiEquipPlayer))
            {
               this.multiEquipPlayer.dispose();
               if(Boolean(this.avatarMC.Visualize_mc.contains(this.multiEquipPlayer)))
               {
                  this.avatarMC.Visualize_mc.removeChild(this.multiEquipPlayer);
               }
               this.multiEquipPlayer = null;
            }
            this.multiEquipPlayer = new MultiEquipPlayer(this.InstanceMC.colorObj);
            this.multiEquipPlayer.updateEquip([]);
            this.avatarMC.Visualize_mc.addChild(this.multiEquipPlayer);
         }
         else
         {
            if(Boolean(this.multiEquipPlayer))
            {
               this.multiEquipPlayer.dispose();
               if(Boolean(this.avatarMC.Visualize_mc.contains(this.multiEquipPlayer)))
               {
                  this.avatarMC.Visualize_mc.removeChild(this.multiEquipPlayer);
               }
               this.multiEquipPlayer = null;
            }
            this.multiEquipPlayer = new TransfigurationMultiEquipPlayer(this.InstanceMC.colorObj);
            this.multiEquipPlayer.updateEquip([]);
            TransfigurationMultiEquipPlayer(this.multiEquipPlayer).changeNude(this.InstanceMC.roleType);
            this.avatarMC.Visualize_mc.addChild(this.multiEquipPlayer);
         }
      }
      
      public function changeColor(colorObj:Object) : void
      {
         this.multiEquipPlayer.changeColor(colorObj);
      }
      
      public function get currentDirection() : String
      {
         return this._currentDirection;
      }
      
      public function set currentDirection(dir:String) : void
      {
         this._currentDirection = dir;
      }
      
      public function get speed() : int
      {
         return this._speed;
      }
      
      public function set speed(num:int) : void
      {
         if(this.InstanceMC.hasDragon && LocalUserInfo.getMapID() != 166)
         {
            if(this.InstanceMC.dragon_Info.Growth >= this.InstanceMC.dragon_Info.GrowthMax)
            {
               this._speed = this.InstanceMC.dragon_Info.Speed2;
            }
            else
            {
               this._speed = this.InstanceMC.dragon_Info.Speed1;
            }
         }
         else
         {
            this._speed = num;
         }
      }
      
      public function clearProp(E:Event) : void
      {
         E.currentTarget.removeEventListener(E.type,this.clearProp);
      }
      
      public function getActionMC() : DisplayObject
      {
         return this.body_mc.getChildAt(0);
      }
      
      public function gotoHere(pathArray:Array, delayNum:uint) : void
      {
         if(pathArray == null)
         {
            this.DirectionNum = this.getDirection(this.InstanceMC.startXY,this.InstanceMC.targetXY);
            this.changeDirection(this.DirectionNum);
            this.stopToHere();
            this.InstanceMC.isMoving = false;
            dispatchEvent(new Event(PeopleManageView.ON_GO_NOPATH));
            if(Boolean(this.InstanceMC))
            {
               this.InstanceMC.dispatchEvent(new Event(PeopleManageView.ON_GO_NOPATH));
            }
         }
         else if(pathArray.length > 0)
         {
            if(this.InstanceMC.isMoving)
            {
               dispatchEvent(new Event(PeopleManageView.ON_GO_BREAK));
               if(Boolean(this.InstanceMC))
               {
                  this.InstanceMC.dispatchEvent(new Event(PeopleManageView.ON_GO_BREAK));
               }
            }
            if(PeopleManageView.Run == delayNum)
            {
               this.isRuning = true;
            }
            else
            {
               this.isRuning = false;
            }
            this.path = pathArray;
            this.currentNum = 0;
            this.InstanceMC.isMoving = true;
            this.nextFun();
            this.isdoAction = false;
            this.ResetAndDisposeBmp();
            this.DelRotation();
            dispatchEvent(new Event(PeopleManageView.ON_GO_START));
            if(Boolean(this.InstanceMC))
            {
               this.InstanceMC.dispatchEvent(new Event(PeopleManageView.ON_GO_START));
            }
         }
      }
      
      public function stopToHere() : void
      {
         if(this.myTween_X.isPlaying || this.myTween_Y.isPlaying)
         {
            dispatchEvent(new Event(PeopleManageView.ON_GO_BREAK));
            if(Boolean(this.InstanceMC))
            {
               this.InstanceMC.dispatchEvent(new Event(PeopleManageView.ON_GO_BREAK));
            }
            this.InstanceMC.isMoving = false;
            this.myTween_X.stop();
            this.myTween_Y.stop();
            this.stopAction();
         }
      }
      
      public function initHandler(E:Event) : void
      {
         var num:uint = 0;
         BC.removeEvent(this,this,PeopleManageView.ON_CHANGE_CLOTHS,this.initHandler);
         this.ResetAndDisposeBmp();
         if(Boolean(this.InstanceMC) && Boolean(this.InstanceMC.Action != null) && !this.isActionMovie)
         {
            if(this.InstanceMC.Action2 == 1)
            {
               this.openBook();
               this.stopAction();
            }
            else if(this.InstanceMC.Action == 3)
            {
               num = this.InstanceMC.Direction;
               this.showAction("sit_" + this.getDirectionString(num));
            }
            else if(this.InstanceMC.Action == 1)
            {
               this.InstanceMC.dance();
            }
            else
            {
               this.stopAction();
            }
         }
         else
         {
            this.stopAction();
         }
         dispatchEvent(new EventTaomee(PeopleManageView.ON_LOADED,{"target":this.InstanceMC}));
         if(Boolean(this.InstanceMC))
         {
            this.InstanceMC.dispatchEvent(new EventTaomee(PeopleManageView.ON_LOADED,{"target":this.InstanceMC}));
         }
      }
      
      public function onClothsChange(evt:Event = null) : void
      {
         this.currentDirection = "down";
         this.DirectionNum = 0;
         this.multiEquipPlayer.visible = true;
         this.multiEquipPlayer.doAction(PlayerActionConstant.ACTION_STAND,0);
         dispatchEvent(new Event(PeopleManageView.ON_CHANGE_CLOTHS));
         if(Boolean(this.InstanceMC))
         {
            this.InstanceMC.dispatchEvent(new Event(PeopleManageView.ON_CHANGE_CLOTHS));
         }
      }
      
      public function showJGPTimer(delay:Number) : void
      {
      }
      
      private function showJGP(E:TimerEvent) : void
      {
         this.ReplaceToBmp();
      }
      
      public function changeDirection(Dir:uint) : void
      {
         if(this.InstanceMC.hasDragon)
         {
            if(Boolean(this.multiEquipPlayer && this.multiEquipPlayer.curAction != PlayerActionConstant.ACTION_SIT) || Boolean(this.currentDirection != LABEL_ACTION_ARR[Dir]) || this.InstanceMC.hasDragonType4 == true)
            {
               this.showActionWithId(PlayerActionConstant.ACTION_SIT,Dir);
            }
         }
         else
         {
            this.showActionWithId(PlayerActionConstant.ACTION_RUN,Dir);
         }
         this.currentDirection = LABEL_ACTION_ARR[Dir];
         dispatchEvent(new EventTaomee(PeopleManageView.ON_CHANGE_DIRECTION,{"dir":this.currentDirection}));
         if(Boolean(this.InstanceMC))
         {
            this.InstanceMC.dispatchEvent(new EventTaomee(PeopleManageView.ON_CHANGE_DIRECTION,{"dir":this.currentDirection}));
         }
      }
      
      public function changeDirectionByObject(a:Object, b:Object) : void
      {
         this.changeDirection(this.getDirection(a,b));
      }
      
      public function changSpeed() : void
      {
         if(!this.path)
         {
            return;
         }
         var path2:Array = this.path.slice(this.currentNum);
         this.InstanceMC.startX = int(this.InstanceMC.x);
         this.InstanceMC.startY = int(this.InstanceMC.y);
         path2.unshift({
            "X":this.InstanceMC.startX,
            "Y":this.InstanceMC.startY
         });
         this.gotoHere(path2,40);
      }
      
      public function getDirectionString(dir:uint) : String
      {
         return DIR_LIST[dir];
      }
      
      public function showAction(dir:String = "", changeDir:Boolean = true) : void
      {
         var tempDirection:String = null;
         dispatchEvent(new Event(PeopleManageView.ON_ACTION_SHOW_BEFORE));
         if(Boolean(this.InstanceMC))
         {
            this.InstanceMC.dispatchEvent(new Event(PeopleManageView.ON_ACTION_SHOW_BEFORE));
         }
         if(dir != "")
         {
            if(changeDir)
            {
               this.currentDirection = dir;
            }
            tempDirection = dir;
         }
         else
         {
            tempDirection = this.currentDirection;
         }
         this.doActionWithStr(tempDirection);
         dispatchEvent(new Event(PeopleManageView.ON_ACTION_SHOW_AFTER));
         if(Boolean(this.InstanceMC))
         {
            this.InstanceMC.dispatchEvent(new Event(PeopleManageView.ON_ACTION_SHOW_AFTER));
         }
      }
      
      public function showActionWithId(actionId:uint, dir:uint, loop:uint = 0, loopOverAction:int = 1) : void
      {
         dispatchEvent(new Event(PeopleManageView.ON_ACTION_SHOW_BEFORE));
         if(Boolean(this.InstanceMC))
         {
            this.InstanceMC.dispatchEvent(new Event(PeopleManageView.ON_ACTION_SHOW_BEFORE));
         }
         if(Boolean(this.multiEquipPlayer))
         {
            this.multiEquipPlayer.doAction(actionId,dir,loop,loopOverAction);
         }
         else
         {
            this.body_mc.gotoAndStop(LABEL_ACTION_ARR[dir]);
         }
         dispatchEvent(new Event(PeopleManageView.ON_ACTION_SHOW_AFTER));
         if(Boolean(this.InstanceMC))
         {
            this.InstanceMC.dispatchEvent(new Event(PeopleManageView.ON_ACTION_SHOW_AFTER));
         }
      }
      
      public function playMovieClip(E:Event) : void
      {
      }
      
      public function stopAction(dir:String = "", changeDir:Boolean = true) : void
      {
         var tempDirection:String = null;
         dispatchEvent(new Event(PeopleManageView.ON_ACTION_STOP_BEFORE));
         if(Boolean(this.InstanceMC))
         {
            this.InstanceMC.dispatchEvent(new Event(PeopleManageView.ON_ACTION_STOP_BEFORE));
         }
         if(dir != "")
         {
            if(changeDir)
            {
               this.currentDirection = dir;
            }
            tempDirection = dir;
         }
         else
         {
            tempDirection = this.currentDirection;
         }
         this.InstanceMC.isMoving = false;
         dispatchEvent(new Event(PeopleManageView.ON_ACTION_STOP_AFTER));
         if(Boolean(this.InstanceMC))
         {
            this.InstanceMC.dispatchEvent(new Event(PeopleManageView.ON_ACTION_STOP_AFTER));
         }
      }
      
      public function stopMovieClip(E:Event) : void
      {
      }
      
      public function sitDown(num:int = 0) : void
      {
         this.isdoAction = true;
         this.currentDirection = "sit_" + this.getDirectionString(num);
         this.showActionWithId(PlayerActionConstant.ACTION_SIT,num,1,-1);
         dispatchEvent(new Event(PeopleManageView.ON_SITDOWN));
         if(Boolean(this.InstanceMC))
         {
            this.InstanceMC.dispatchEvent(new Event(PeopleManageView.ON_SITDOWN));
         }
      }
      
      private function throwThingInit(evt:Event) : void
      {
         this.throwMc = GV.throwThingClass.getThingMC() as MovieClip;
         this.throwMc.Throw_selected = this.InstanceMC.Throw_selected;
         this.throwMc.userID = this.InstanceMC.id;
      }
      
      private function throwThingStart(evt:Event) : void
      {
         var temp2Prop:MovieClip = null;
         this.throwMc.targetX = this.InstanceMC.throwXY.X;
         this.throwMc.targetY = this.InstanceMC.throwXY.Y;
         if(Boolean(this.throwMc) && this.throwMc.numChildren > 0)
         {
            temp2Prop = MovieClip(this.throwMc.getChildAt(0)).getChildAt(0) as MovieClip;
            temp2Prop.x = 0;
            temp2Prop.y = 0;
            temp2Prop.gotoAndStop(2);
            this.throwMc.x = this.InstanceMC.x;
            this.throwMc.y = this.InstanceMC.y - 30;
            this.throwMc.scaleX = this.throwMc.scaleY = 0.3;
            GV.MC_Depth.addChild(this.throwMc);
            this.throwMc.useProp();
            this.throwMc = null;
         }
      }
      
      public function specialAct(Actstr:String, Act:String, jobID:int) : void
      {
      }
      
      public function wave() : void
      {
         this.ResetAndDisposeBmp();
         this.isdoAction = true;
         this.currentDirection = "wave_down";
         this.showActionWithId(PlayerActionConstant.ACTION_WAVE,0);
         dispatchEvent(new Event(PeopleManageView.ON_ACTION_WAVE));
         if(Boolean(this.InstanceMC))
         {
            this.InstanceMC.dispatchEvent(new Event(PeopleManageView.ON_ACTION_WAVE));
         }
      }
      
      public function openBook() : void
      {
         this.ResetAndDisposeBmp();
         this.currentDirection = DIR_DOWN;
         this.showActionWithId(PlayerActionConstant.ACTION_STAND,this.DirectionNum);
         this.isdoAction = true;
         this.avatarMC.status_mc.gotoAndStop(5);
         this.ReplaceToBmp();
      }
      
      public function closeBook() : void
      {
         this.ResetAndDisposeBmp();
         this.showActionWithId(PlayerActionConstant.ACTION_STAND,this.DirectionNum);
         this.isdoAction = false;
         this.avatarMC.status_mc.gotoAndStop(1);
      }
      
      public function dance() : void
      {
         this.ResetAndDisposeBmp();
         this.isdoAction = true;
         this.currentDirection = "dance_down";
         this.showActionWithId(PlayerActionConstant.ACTION_DANCE,0);
         dispatchEvent(new Event(PeopleManageView.ON_ACTION_DANCE));
         if(Boolean(this.InstanceMC))
         {
            this.InstanceMC.dispatchEvent(new Event(PeopleManageView.ON_ACTION_DANCE));
         }
      }
      
      public function scaleBody(num:Number = 1) : void
      {
         if(GV.MapInfo_mapID == 10)
         {
            return;
         }
         this.ResetAndDisposeBmp();
         try
         {
            this.myTween.stop();
         }
         catch(error:Error)
         {
         }
         try
         {
            this.myTween2.stop();
         }
         catch(error:Error)
         {
         }
         if(this.InstanceMC.isNewPeople)
         {
            this.avatarMC.Visualize_mc.scaleX = this.avatarMC.Visualize_mc.scaleY = num;
            this.avatarMC.shadow_mc.scaleX = this.avatarMC.shadow_mc.scaleY = num;
            this.speed = this.defaultSpeed * num;
            this.avatarMC.Visualize_mc.filters = [];
         }
         else
         {
            this.myTween2 = new Tween(this.avatarMC.Visualize_mc,"scaleX",Elastic.easeOut,this.avatarMC.Visualize_mc.scaleX,num,1,true);
            new Tween(this.avatarMC.Visualize_mc,"scaleY",Elastic.easeOut,this.avatarMC.Visualize_mc.scaleY,num,1,true);
            GC.setGTimeout(function():*
            {
               try
               {
                  trace(avatarMC);
                  avatarMC.Visualize_mc.scaleX = avatarMC.Visualize_mc.scaleY = num;
                  avatarMC.shadow_mc.scaleX = avatarMC.shadow_mc.scaleY = num;
                  speed = defaultSpeed * num;
               }
               catch(E:*)
               {
               }
            },500);
            if(num > 1)
            {
               this.showMe(2);
            }
            else
            {
               this.showMe(1);
            }
         }
         dispatchEvent(new Event(PeopleManageView.ON_SPECIFIC_SCALEBODY));
         if(Boolean(this.InstanceMC))
         {
            this.InstanceMC.dispatchEvent(new Event(PeopleManageView.ON_SPECIFIC_SCALEBODY));
         }
      }
      
      public function throwThing(obj2:*) : void
      {
         this.ResetAndDisposeBmp();
         this.InstanceMC.throwXY = obj2;
         var lp:Point = new Point(this.InstanceMC.x,this.InstanceMC.y);
         var gp:Point = this.InstanceMC.parent.localToGlobal(lp);
         var num:uint = this.getDirection({
            "X":gp.x,
            "Y":gp.y
         },obj2);
         if(num > -1)
         {
            switch(num)
            {
               case 0:
                  this.currentDirection = "throw_leftdown";
                  break;
               case 1:
                  this.currentDirection = "throw_leftdown";
                  break;
               case 2:
                  this.currentDirection = "throw_leftup";
                  break;
               case 3:
                  this.currentDirection = "throw_leftup";
                  break;
               case 4:
                  this.currentDirection = "throw_rightup";
                  break;
               case 5:
                  this.currentDirection = "throw_rightup";
                  break;
               case 6:
                  this.currentDirection = "throw_rightdown";
                  break;
               case 7:
                  this.currentDirection = "throw_rightdown";
                  break;
               default:
                  this.currentDirection = "throw_leftdown";
            }
            this.showAction();
            this.isdoAction = true;
         }
         else
         {
            if(!this.isdoAction)
            {
               this.showAction("throw_" + this.currentDirection);
            }
            this.isdoAction = true;
         }
         dispatchEvent(new Event(PeopleManageView.ON_ACTION_THROW));
         if(Boolean(this.InstanceMC))
         {
            this.InstanceMC.dispatchEvent(new Event(PeopleManageView.ON_ACTION_THROW));
         }
      }
      
      public function ReplaceToBmp(bool:Boolean = false) : void
      {
         dispatchEvent(new Event(PeopleManageView.ON_SET_CACHE));
         if(Boolean(this.InstanceMC))
         {
            this.InstanceMC.dispatchEvent(new Event(PeopleManageView.ON_SET_CACHE));
         }
      }
      
      public function ResetAndDisposeBmp() : void
      {
         dispatchEvent(new Event(PeopleManageView.ON_DISPOSE_CACHE));
         if(Boolean(this.InstanceMC))
         {
            this.InstanceMC.dispatchEvent(new Event(PeopleManageView.ON_DISPOSE_CACHE));
         }
      }
      
      public function setPlace() : void
      {
         var offset:uint = 6;
         if(this.avatarMC.Visualize_mc.scaleX > 0)
         {
            this.avatarMC.Visualize_mc.x = -(this.avatarMC.Visualize_mc.width / 2) + offset;
            this.avatarMC.Visualize_mc.y = -100;
            this.avatarMC.nickName_txt.y = -100;
         }
         else
         {
            this.avatarMC.Visualize_mc.x = this.avatarMC.Visualize_mc.width / 2 + offset;
            this.avatarMC.Visualize_mc.y = -100;
            this.avatarMC.nickName_txt.y = -100;
         }
      }
      
      public function setDepth() : void
      {
         if(!this.InstanceMC)
         {
            return;
         }
         MapDepthManageLogic.setPeopleDepth(this.InstanceMC);
         dispatchEvent(new Event(PeopleManageView.ON_SET_DEPTH));
         if(Boolean(this.InstanceMC))
         {
            this.InstanceMC.dispatchEvent(new Event(PeopleManageView.ON_SET_DEPTH));
         }
      }
      
      public function getDirection(obj1:*, obj2:*) : uint
      {
         var myAngle:Number = Math.atan2(obj1.Y - obj2.Y,obj1.X - obj2.X) / Math.PI * 180 + 180;
         var angle:Number = myAngle + 22.5 + 270;
         return int(angle % 360 / 45);
      }
      
      public function showMe(type:uint = 0) : void
      {
         this.EffectType = type;
         this.Effect.num = 0;
         switch(this.EffectType)
         {
            case 0:
               this.myTween = new Tween(this.Effect,"num",Elastic.easeInOut,80,0,0.5,true);
               break;
            case 1:
               this.myTween = new Tween(this.Effect,"num",Elastic.easeOut,200,0,1,true);
               break;
            case 2:
               this.myTween = new Tween(this.Effect,"num",Elastic.easeOut,80,0,0.5,true);
         }
         BC.addEvent(this,this.myTween,TweenEvent.MOTION_START,this.onMotionChange);
         BC.addEvent(this,this.myTween,TweenEvent.MOTION_FINISH,this.onMotionFinish);
      }
      
      private function onMotionChange(E:*) : *
      {
         switch(this.EffectType)
         {
            case 0:
               this.avatarMC.Visualize_mc.filters = [new GlowFilter(this.Effect.num,this.Effect.num,1)];
               break;
            case 1:
               this.avatarMC.Visualize_mc.filters = [new BlurFilter(this.Effect.num,this.Effect.num,1)];
               break;
            case 2:
               this.avatarMC.Visualize_mc.filters = [new BevelFilter(this.Effect.num,this.Effect.num)];
         }
      }
      
      private function onMotionFinish(E:*) : void
      {
         BC.removeEvent(this,this.myTween);
         this.avatarMC.Visualize_mc.filters = [];
      }
      
      private function nextFun() : void
      {
         var obj1:Object = null;
         var obj2:Object = null;
         if(Boolean(this.path) && this.currentNum + 1 < this.path.length)
         {
            if(this.currentNum == 0)
            {
               if(this.currentNum + 1 == this.path.length - 1)
               {
                  obj1 = {
                     "X":this.InstanceMC.startX,
                     "Y":this.InstanceMC.startY
                  };
                  obj2 = {
                     "X":this.InstanceMC.endX,
                     "Y":this.InstanceMC.endY
                  };
               }
               else
               {
                  obj1 = {
                     "X":this.InstanceMC.startX,
                     "Y":this.InstanceMC.startY
                  };
                  obj2 = {
                     "X":this.path[this.currentNum + 1].X * MapModelLogic.GridSize,
                     "Y":this.path[this.currentNum + 1].Y * MapModelLogic.GridSize
                  };
               }
            }
            else if(this.currentNum == this.path.length - 2)
            {
               obj1 = {
                  "X":this.path[this.currentNum].X * MapModelLogic.GridSize,
                  "Y":this.path[this.currentNum].Y * MapModelLogic.GridSize
               };
               obj2 = {
                  "X":this.InstanceMC.endX,
                  "Y":this.InstanceMC.endY
               };
            }
            else
            {
               obj1 = {
                  "X":this.path[this.currentNum].X * MapModelLogic.GridSize,
                  "Y":this.path[this.currentNum].Y * MapModelLogic.GridSize
               };
               obj2 = {
                  "X":this.path[this.currentNum + 1].X * MapModelLogic.GridSize,
                  "Y":this.path[this.currentNum + 1].Y * MapModelLogic.GridSize
               };
            }
            this.doMove(obj1,obj2);
            ++this.currentNum;
         }
         else
         {
            this.goOver();
         }
      }
      
      public function goOver() : void
      {
         if(!this.myTween_X)
         {
            return;
         }
         this.myTween_X.stop();
         this.myTween_Y.stop();
         this.path = null;
         this.goOver2();
         this.setDepth();
      }
      
      private function goOver2(E:TimerEvent = null) : void
      {
         try
         {
            if(!this.InstanceMC.hasDragon || this.InstanceMC.hasDragonType4 == true)
            {
               this.addRotation();
               this.showActionWithId(PlayerActionConstant.ACTION_STAND,this.DirectionNum);
            }
            this.InstanceMC.isMoving = false;
         }
         catch(E:*)
         {
         }
         dispatchEvent(new Event(PeopleManageView.ON_GO_OVER));
         if(Boolean(this.InstanceMC))
         {
            this.InstanceMC.dispatchEvent(new Event(PeopleManageView.ON_GO_OVER));
         }
      }
      
      private function doMove(a:*, b:*) : *
      {
         this.DirectionNum = this.getDirection(a,b);
         this.changeDirection(this.DirectionNum);
         var tt:Number = int(this.getMoveTimer(a,b) * 10) / 10;
         tt = tt <= 0 ? 0.05 : tt;
         if(this.myTween_X == null)
         {
            return this.myTween_X.stop();
         }
         this.myTween_Y.stop();
         this.myTween_X.begin = a.X;
         this.myTween_X.finish = b.X;
         this.myTween_X.duration = tt;
         this.myTween_X.rewind();
         this.myTween_X.start();
         this.myTween_Y.begin = a.Y;
         this.myTween_Y.finish = b.Y;
         this.myTween_Y.duration = tt;
         this.myTween_Y.rewind();
         this.myTween_Y.start();
      }
      
      private function onMotionChangeY(E:TweenEvent) : void
      {
         var tempNum:int = int(E.currentTarget.time * 10) % 3;
         if(tempNum == 2 && tempNum != this.prevN)
         {
            if(this.prevX == this.InstanceMC.x && this.prevY == this.InstanceMC.y)
            {
               this.goOver();
            }
            else
            {
               this.setDepth();
               this.prevX = this.InstanceMC.x;
               this.prevY = this.InstanceMC.y;
            }
         }
         this.prevN = tempNum;
         dispatchEvent(new Event(PeopleManageView.ON_GO_ENTERFRAME));
         if(Boolean(this.InstanceMC))
         {
            this.InstanceMC.dispatchEvent(new Event(PeopleManageView.ON_GO_ENTERFRAME));
         }
      }
      
      private function onMotionFinishedY(E:TweenEvent) : void
      {
         this.myTween_X.stop();
         this.myTween_Y.stop();
         this.nextFun();
      }
      
      private function getMoveTimer(a:*, b:*) : Number
      {
         var AA:Point = new Point(a.X,a.Y);
         var BB:Point = new Point(b.X,b.Y);
         if(this.InstanceMC.hasCar)
         {
            return Point.distance(AA,BB) / this.InstanceMC.car.speed;
         }
         return Point.distance(AA,BB) / this.speed;
      }
      
      private function changeManDirction(E:MouseEvent) : void
      {
         if(!this.isdoAction && !this.InstanceMC.isMoving)
         {
            this.DirectionNum = this.getDirection({
               "X":this.InstanceMC.x,
               "Y":this.InstanceMC.y
            },{
               "X":E.stageX,
               "Y":E.stageY
            });
            if(this.oldDirection != this.DirectionNum)
            {
               this.currentDirection = LABEL_ACTION_ARR[this.DirectionNum];
               this.showActionWithId(PlayerActionConstant.ACTION_STAND,this.DirectionNum);
               this.oldDirection = this.DirectionNum;
            }
         }
         E = null;
         if(this.InstanceMC.parent == null)
         {
            this.reMoveInstanceMC();
         }
      }
      
      private function body_mouseover(E:MouseEvent) : void
      {
         if(this.myTween_X == null)
         {
            this.DelRotation();
            this.stopAction(this.getDirectionString(0));
         }
      }
      
      private function body_mouseout(E:MouseEvent) : void
      {
         if(this.myTween_X == null)
         {
            this.addRotation();
            this.stopAction(this.getDirectionString(0));
         }
      }
      
      protected function doActionWithStr(actionStr:String) : void
      {
         var index:int = 0;
         index = actionStr.indexOf("sit_");
         this.multiEquipPlayer.visible = true;
         if(index != -1)
         {
            this.showActionWithId(PlayerActionConstant.ACTION_SIT,this.getDirFromStr(actionStr),1);
            return;
         }
         index = actionStr.indexOf("wave_");
         if(index != -1)
         {
            this.showActionWithId(PlayerActionConstant.ACTION_WAVE,this.getDirFromStr(actionStr),1,PlayerActionConstant.ACTION_STAND);
            return;
         }
         index = actionStr.indexOf("dance_");
         if(index != -1)
         {
            this.showActionWithId(PlayerActionConstant.ACTION_DANCE,this.getDirFromStr(actionStr),1,PlayerActionConstant.ACTION_STAND);
            return;
         }
         index = actionStr.indexOf("throw_");
         if(index != -1)
         {
            this.showActionWithId(PlayerActionConstant.ACTION_THROW,this.getDirFromStr(actionStr),1,PlayerActionConstant.ACTION_STAND);
            return;
         }
         index = actionStr.indexOf("special");
         if(index != -1)
         {
            this.multiEquipPlayer.visible = false;
            return;
         }
         this.showActionWithId(PlayerActionConstant.ACTION_RUN,this.getDirFromStr(actionStr));
      }
      
      protected function getDirFromStr(actionStr:String) : uint
      {
         var index:int = 0;
         index = actionStr.indexOf("down");
         if(index != -1)
         {
            return 0;
         }
         index = actionStr.indexOf("leftdown");
         if(index != -1)
         {
            return 1;
         }
         index = actionStr.indexOf("left");
         if(index != -1)
         {
            return 2;
         }
         index = actionStr.indexOf("leftup");
         if(index != -1)
         {
            return 3;
         }
         index = actionStr.indexOf("up");
         if(index != -1)
         {
            return 4;
         }
         index = actionStr.indexOf("rightup");
         if(index != -1)
         {
            return 5;
         }
         index = actionStr.indexOf("right");
         if(index != -1)
         {
            return 6;
         }
         index = actionStr.indexOf("rightdown");
         if(index != -1)
         {
            return 7;
         }
         return 0;
      }
      
      public function addRotation() : void
      {
         if(this.InstanceMC.id == GV.MyInfo_userID && !this.InstanceMC.hasDragon && !this.InstanceMC.hasCar)
         {
            BC.addEvent(this,MainManager.getStage(),MouseEvent.MOUSE_MOVE,this.changeManDirction);
         }
      }
      
      public function DelRotation() : void
      {
         BC.removeEvent(this,MainManager.getStage(),MouseEvent.MOUSE_MOVE,this.changeManDirction);
      }
      
      public function reMoveInstanceMC(E:Event = null) : void
      {
         if(E == null || E.currentTarget == this.InstanceMC)
         {
            this.currentDirection = "down";
            if(Boolean(this.multiEquipPlayer))
            {
               this.multiEquipPlayer.removeEventListener(MultiEquipPlayer.CHANGE_CLOTH_OVER,this.onClothsChange);
               this.multiEquipPlayer.removeEventListener(MultiEquipPlayer.THROW_ITEM_INIT,this.throwThingInit);
               this.multiEquipPlayer.removeEventListener(MultiEquipPlayer.THROW_ITEM_START,this.throwThingStart);
            }
            BC.removeEvent(this);
            if(Boolean(this.myTween_X))
            {
               this.myTween_X.stop();
            }
            if(Boolean(this.myTween_Y))
            {
               this.myTween_Y.stop();
            }
            this.ResetAndDisposeBmp();
            this.clothClass.clearClass();
            ObjectPool.disposeObject(this.clothClass,ChangeCloths,100);
            this.clothClass = null;
            this.myTween_X = null;
            this.myTween_Y = null;
            this.InstanceMC = null;
            this.avatarMC = null;
            this.body_mc = null;
         }
      }
      
      private function removeMouseMove(evt:EventTaomee) : void
      {
         this.DelRotation();
      }
      
      public function get InstanceMC() : PeopleManageView
      {
         return this._InstanceMC;
      }
      
      public function set InstanceMC(value:PeopleManageView) : void
      {
         this._InstanceMC = value;
      }
   }
}

