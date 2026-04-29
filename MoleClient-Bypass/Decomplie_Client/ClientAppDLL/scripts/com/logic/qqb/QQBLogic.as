package com.logic.qqb
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.socketlogic.ClientOnLineSerSocket;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.MapManageLogic.MapModelLogic;
   import com.logic.socket.action.ActionReq;
   import com.logic.socket.enterGame.EnterGameReq;
   import com.logic.socket.leaveGame.LeaveGameRes;
   import com.logic.socket.qqb.QQBRequest;
   import com.logic.socket.qqb.QQBResult;
   import com.module.pet.petLogic;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class QQBLogic
   {
      
      private static const MAX_ROTATION:Number = 10;
      
      private static const MIN_ROTATION:Number = -10;
      
      private var perRotation:Number = 0;
      
      private var qqbMC:MovieClip;
      
      private var barMC:MovieClip;
      
      private var boardMC:MovieClip;
      
      private var sitMC:MovieClip;
      
      private var manArray:Array;
      
      private var W:Number;
      
      private var typeMC:MovieClip;
      
      private var enterRequest:EnterGameReq;
      
      private var isSit:Boolean = false;
      
      private var isClick:Boolean = false;
      
      private var isBarClick:Boolean = false;
      
      private var isCanLeave:Boolean = false;
      
      private var moveLogicDict:Dictionary;
      
      private var findTargetLogic:FindTargetLogic;
      
      private var hitSprite:Sprite;
      
      private var qqbSubject:QQBSubject;
      
      private var lahmLogic:LahmAnimationLogic;
      
      private var timer:Timer;
      
      private var leaveTimer:Timer;
      
      public function QQBLogic(mc:MovieClip)
      {
         super();
         this.qqbSubject = new QQBSubject();
         this.moveLogicDict = new Dictionary(true);
         this.enterRequest = new EnterGameReq();
         this.manArray = [];
         this.qqbMC = mc;
         this.typeMC = mc.parent.parent["type_mc"];
         this.boardMC = this.qqbMC["boardMC"];
         this.barMC = this.boardMC["barMC"];
         this.barMC.buttonMode = true;
         this.sitMC = this.boardMC["sitMC"];
         this.sitMC.buttonMode = true;
         this.W = this.barMC.width / 2;
         this.findTargetLogic = new FindTargetLogic();
         this.findTargetLogic.addEventListener(FindTargetLogic.ARRIVE_TARGET,this.arriveHandler);
         mc = this.qqbMC["lahm_mc"];
         this.lahmLogic = new LahmAnimationLogic(mc);
         this.leaveTimer = new Timer(1500,1);
         this.leaveTimer.addEventListener(TimerEvent.TIMER,this.leaveTimerHandler);
         this.timer = new Timer(50);
         this.initHandlder();
      }
      
      public function requestQQBStatus() : void
      {
         QQBRequest.qqbStatus();
      }
      
      private function parseArray() : Number
      {
         var i:PeopleManageView = null;
         var num:Number = 0;
         for each(i in this.manArray)
         {
            num += this.getWeight(i);
         }
         this.perRotation = num / 10;
         if(this.perRotation < 0.5 && this.perRotation > 0)
         {
            this.perRotation = 0.5;
         }
         else if(this.perRotation > -0.5 && this.perRotation < 0)
         {
            this.perRotation = -0.5;
         }
         return this.perRotation;
      }
      
      public function destroy() : void
      {
         var i:QQBManMoveLogic = null;
         for each(i in this.moveLogicDict)
         {
            if(Boolean(i))
            {
               i.clear();
            }
         }
         this.lahmLogic.clear();
         this.qqbSubject.clear();
         GV.onlineSocket.removeEventListener(QQBResult.QQB_STATUS,this.qqbStatusHandler);
         GV.onlineSocket.removeEventListener(QQBResult.SOME_ONE_JOIN,this.someOneJoinHandler);
         GV.onlineSocket.removeEventListener(LeaveGameRes.LEAVE_GAME,this.someOneLeaveHandler);
         GV.onlineSocket.removeEventListener(QQBResult.SOME_ONE_MOVE,this.someOneMoveHandler);
         this.barMC.removeEventListener(MouseEvent.CLICK,this.clickBarHandler);
         this.boardMC.removeEventListener(Event.ENTER_FRAME,this.computeHandler);
         this.sitMC.removeEventListener(MouseEvent.CLICK,this.sitHandler);
         GV.onlineSocket.removeEventListener(ClientOnLineSerSocket.ERROR_GAME,this.errorHandler);
         this.qqbMC = null;
         this.barMC = null;
         this.boardMC = null;
         this.sitMC = null;
         this.typeMC = null;
         if(Boolean(this.hitSprite))
         {
            this.hitSprite.parent.removeChild(this.hitSprite);
            this.hitSprite.removeEventListener(MouseEvent.CLICK,this.stageClickHandler);
            this.hitSprite = null;
         }
         this.findTargetLogic.removeHandler();
         this.manArray = [];
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.countPerRotation);
         this.leaveTimer.stop();
         this.leaveTimer.removeEventListener(TimerEvent.TIMER,this.leaveTimerHandler);
      }
      
      private function initHandlder() : void
      {
         this.timer.addEventListener(TimerEvent.TIMER,this.countPerRotation);
         this.timer.start();
         GV.onlineSocket.addEventListener(QQBResult.QQB_STATUS,this.qqbStatusHandler);
         GV.onlineSocket.addEventListener(QQBResult.SOME_ONE_JOIN,this.someOneJoinHandler);
         GV.onlineSocket.addEventListener(LeaveGameRes.LEAVE_GAME,this.someOneLeaveHandler);
         GV.onlineSocket.addEventListener(QQBResult.SOME_ONE_MOVE,this.someOneMoveHandler);
         this.barMC.addEventListener(MouseEvent.CLICK,this.clickBarHandler);
         this.boardMC.addEventListener(Event.ENTER_FRAME,this.computeHandler);
         this.sitMC.addEventListener(MouseEvent.CLICK,this.sitHandler);
         GV.onlineSocket.addEventListener(ClientOnLineSerSocket.ERROR_GAME,this.errorHandler);
      }
      
      private function qqbStatusHandler(event:EventTaomee) : void
      {
         var i:Object = null;
         var mc:PeopleManageView = null;
         var array:Array = event.EventObj as Array;
         for each(i in array)
         {
            mc = GF.getPeopleByID(i.userID) as PeopleManageView;
            mc.hitBtn.visible = false;
            mc.avatarMC.nickName_txt.y = 1200;
            mc.avatarMC.nickName_txt.visible = false;
            mc.x = i.posX;
            mc.y = 0;
            this.boardMC.addChild(mc);
            this.qqbSubject.addObserver(mc);
            if(mc.x < 0)
            {
               mc.avatarMC.Visualize_mc.scaleX = -1;
            }
            this.manArray.push(mc);
            mc.sitDown(2);
            if(this.parseArray() > 0)
            {
               this.boardMC.rotation = MAX_ROTATION;
            }
            else if(this.parseArray() == 0)
            {
               this.boardMC.rotation = 0;
            }
            else
            {
               this.boardMC.rotation = MIN_ROTATION;
            }
         }
         if(this.manArray.length == 0)
         {
            this.lahmLogic.stop();
         }
      }
      
      private function sitHandler(event:MouseEvent) : void
      {
         this.findTargetLogic.goHere(event.currentTarget as Sprite,new Point(int(event.stageX),int(event.stageY)));
      }
      
      private function stageClickHandler(event:MouseEvent) : void
      {
         if(this.isSit && !this.isClick && !this.isBarClick && this.isCanLeave)
         {
            this.isClick = true;
            GF.leaveGame2();
         }
         this.isBarClick = false;
      }
      
      private function arriveHandler(event:Event) : void
      {
         this.sitClickHandler();
      }
      
      private function someOneJoinHandler(event:EventTaomee) : void
      {
         var actionReq:ActionReq = null;
         var obj:Object = event.EventObj;
         var peopel:PeopleManageView = GF.getPeopleByID(int(obj.userID)) as PeopleManageView;
         var p:Point = this.boardMC.globalToLocal(new Point(peopel.x,peopel.y));
         peopel.hitBtn.visible = false;
         peopel.avatarMC.nickName_txt.y = 1200;
         peopel.avatarMC.nickName_txt.visible = false;
         this.boardMC.addChild(peopel);
         if(p.x > 0)
         {
            peopel.avatarMC.Visualize_mc.scaleX = 1;
         }
         else if(peopel.x < 0)
         {
            peopel.avatarMC.Visualize_mc.scaleX = -1;
         }
         this.manArray.push(peopel);
         peopel.x = int(p.x);
         peopel.y = 0;
         peopel.sitDown(2);
         if(obj.userID == LocalUserInfo.getUserID())
         {
            actionReq = new ActionReq();
            actionReq.actions(3,2);
            this.sitMC.mouseEnabled = false;
            this.sitMC.buttonMode = false;
            this.isSit = true;
            QQBRequest.qqbMove(peopel.x,0,2);
            this.addHitSprite();
         }
         this.qqbSubject.addObserver(peopel);
      }
      
      private function addHitSprite() : void
      {
         var mc:DisplayObjectContainer = null;
         if(!this.hitSprite)
         {
            this.hitSprite = new Sprite();
            this.hitSprite.graphics.beginFill(0,0);
            this.hitSprite.graphics.drawRect(0,0,MainManager.getStageWidth(),MainManager.getStageHeight());
            this.hitSprite.graphics.endFill();
            mc = this.qqbMC.parent;
            mc.addChildAt(this.hitSprite,mc.getChildIndex(this.qqbMC));
            this.hitSprite.addEventListener(MouseEvent.CLICK,this.stageClickHandler);
         }
         this.setCanLeave();
      }
      
      private function removeHitSprite() : void
      {
         if(Boolean(this.hitSprite))
         {
            this.hitSprite.parent.removeChild(this.hitSprite);
            this.hitSprite.removeEventListener(MouseEvent.CLICK,this.stageClickHandler);
            this.hitSprite = null;
         }
         this.isCanLeave = false;
      }
      
      private function setCanLeave() : void
      {
         this.leaveTimer.stop();
         this.leaveTimer.start();
      }
      
      private function leaveTimerHandler(event:TimerEvent) : void
      {
         this.isCanLeave = true;
      }
      
      private function someOneLeaveHandler(event:EventTaomee) : void
      {
         var point:Point = null;
         var obj:Object = event.EventObj;
         var moveLogic:QQBManMoveLogic = this.moveLogicDict["act" + obj.UserID.toString()];
         if(Boolean(moveLogic))
         {
            moveLogic.clear();
            this.moveLogicDict["act" + obj.UserID.toString()] = null;
         }
         var mc:PeopleManageView = GF.getPeopleByID(obj.UserID) as PeopleManageView;
         mc.hitBtn.visible = true;
         mc.avatarMC.nickName_txt.y = 12;
         mc.avatarMC.nickName_txt.visible = true;
         var index:int = this.manArray.indexOf(mc);
         this.manArray.splice(index,1);
         point = this.boardMC.localToGlobal(new Point(mc.x,mc.y + 10));
         mc.x = point.x;
         mc.y = point.y;
         mc.changeLayer(MapModelLogic.FLOOR_LAYER);
         mc.stopAction();
         mc.avatarMC.Visualize_mc.scaleX = 1;
         if(obj.UserID == LocalUserInfo.getUserID())
         {
            this.sitMC.mouseEnabled = true;
            this.sitMC.buttonMode = true;
            this.isClick = false;
            this.isSit = false;
            this.removeHitSprite();
         }
         this.qqbSubject.delObserver(mc);
         if(this.manArray.length == 0)
         {
            this.lahmLogic.stop();
         }
      }
      
      private function someOneMoveHandler(event:EventTaomee) : void
      {
         var moveLogic:QQBManMoveLogic = null;
         var obj:Object = event.EventObj;
         if(this.moveLogicDict["act" + obj.userID.toString()] == null)
         {
            moveLogic = new QQBManMoveLogic(this);
            this.moveLogicDict["act" + obj.userID.toString()] = moveLogic;
         }
         else
         {
            moveLogic = this.moveLogicDict["act" + obj.userID.toString()];
         }
         var p:Point = this.boardMC.globalToLocal(new Point(obj.PosX,0));
         moveLogic.move(obj.userID,obj.PosX);
      }
      
      private function computeHandler(event:Event) : void
      {
         if(this.perRotation == 0)
         {
            this.balanceAction();
         }
         else if(this.boardMC.rotation + this.perRotation >= MAX_ROTATION)
         {
            this.boardMC.rotation = MAX_ROTATION;
         }
         else if(this.boardMC.rotation + this.perRotation <= MIN_ROTATION)
         {
            this.boardMC.rotation = MIN_ROTATION;
         }
         else
         {
            this.boardMC.rotation += this.perRotation;
         }
         this.qqbSubject.changeRtotaion(this.boardMC.rotation);
      }
      
      private function balanceAction() : void
      {
         var temp:Number = NaN;
         if(this.boardMC.rotation < 0)
         {
            temp = 0.4;
         }
         else
         {
            temp = -0.4;
         }
         if(temp == 0.4 && this.boardMC.rotation + temp >= 0 || temp == -0.4 && this.boardMC.rotation + temp <= 0)
         {
            this.boardMC.rotation = 0;
         }
         else
         {
            this.boardMC.rotation += temp;
         }
      }
      
      private function sitClickHandler() : void
      {
         MoveTo.CanMove = false;
         this.enterRequest.enterGame(1);
      }
      
      private function clickBarHandler(event:MouseEvent) : void
      {
         if(this.isSit)
         {
            this.isBarClick = true;
            QQBRequest.qqbMove(int(event.localX));
         }
      }
      
      private function countPerRotation(event:TimerEvent) : void
      {
         if(this.parseArray() < 0)
         {
            this.lahmLogic.left();
         }
         else if(this.parseArray() > 0)
         {
            this.lahmLogic.right();
         }
         else if(this.parseArray() == 0 && this.manArray.length > 0)
         {
            this.lahmLogic.tired();
         }
      }
      
      public function getWeight(i:PeopleManageView) : Number
      {
         if(petLogic.havePetFollow(i.id))
         {
            return 15 * (i.x / this.W);
         }
         return 10 * (i.x / this.W);
      }
      
      private function errorHandler(event:Event) : void
      {
         Alert.showAlert(MainManager.getAppLevel(),"蹺蹺板上人滿囉\n請稍等一會兒再來玩吧！","",6,"E");
      }
   }
}

