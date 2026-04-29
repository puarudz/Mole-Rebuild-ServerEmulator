package com.logic.FindPathLogic
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.manager.LevelManager;
   import com.core.manager.UIManager;
   import com.core.socketlogic.ClientOnLineSerSocket;
   import com.event.EventTaomee;
   import com.logic.mapEvent.MapEvent;
   import com.logic.socket.leaveGame.LeaveGameReq;
   import com.mole.app.event.PeopleEvent;
   import com.mole.app.manager.ActivityTmpDataManager;
   import com.view.MapManageView.MapManageView;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public dynamic class MoveTo
   {
      
      public static var CanPathPoint:Boolean = true;
      
      private static var _CanMove:Boolean = true;
      
      public static var CanAutoFind:Boolean = true;
      
      public function MoveTo(mapFrame:*)
      {
         super();
      }
      
      public static function set CanMove(b:Boolean) : void
      {
         _CanMove = b;
      }
      
      public static function get CanMove() : Boolean
      {
         return _CanMove;
      }
      
      public static function get CanMove2() : Boolean
      {
         return _CanMove;
      }
      
      public static function set CanMove2(value:Boolean) : void
      {
         _CanMove = value;
      }
      
      public static function getSpecifiedDirectionPoint(startPoint:Point, endPoint:Point, Limit:uint) : Point
      {
         return FindPathLogic.noHitLatelyPoint(startPoint,endPoint,Limit);
      }
      
      public static function getRandomFloorPoint() : Point
      {
         var rect:Rectangle = new Rectangle(10,10,940,490);
         var hx:int = int(rect.x + rect.width * Math.random());
         var hy:int = int(rect.y + rect.height * Math.random());
         if(MoveCondition.hasRoad(hx,hy))
         {
            return new Point(hx,hy);
         }
         return getRandomFloorPoint();
      }
      
      public static function AutoFind(X_or_Array:*, Y_or_Peple:*, Peple:* = null) : Boolean
      {
         var PepleMC:* = undefined;
         var p:PeopleManageView = null;
         var startX:* = undefined;
         var startY:* = undefined;
         var endX:* = undefined;
         var endY:* = undefined;
         var pathArray:Array = null;
         var i:uint = 0;
         while(i < 2)
         {
            if(!CanAutoFind)
            {
               break;
            }
            if(Boolean(LocalUserInfo.getMapID() == 229) && Boolean(Peple) && Peple != GV.MAN_PEOPLE)
            {
               p = Peple as PeopleManageView;
               if(X_or_Array == 448 && Y_or_Peple == 275)
               {
                  p.isIn204Game = true;
                  if(Boolean(GV.MAN_PEOPLE["isIn204Game"]))
                  {
                     p.visible = false;
                  }
               }
               else if(X_or_Array == 486 && Y_or_Peple == 150)
               {
                  p.isIn204Game = false;
                  if(Boolean(GV.MAN_PEOPLE["isIn204Game"]))
                  {
                     p.visible = true;
                  }
               }
               X_or_Array = [{
                  "X":X_or_Array,
                  "Y":Y_or_Peple
               }];
               Y_or_Peple = Peple;
               if(Boolean(GV.MAN_PEOPLE["isIn204Game"]))
               {
                  if(p.isIn204Game)
                  {
                     p.visible = false;
                  }
               }
            }
            if(Boolean(X_or_Array as Array))
            {
               PepleMC = Y_or_Peple;
               PepleMC.startX = PepleMC.x;
               PepleMC.startY = PepleMC.y;
               PepleMC.endX = X_or_Array[X_or_Array.length - 1].X;
               PepleMC.endY = X_or_Array[X_or_Array.length - 1].Y;
               if(PepleMC == GV.MAN_PEOPLE && MoveTo.CanPathPoint)
               {
                  GV.onlineClass.walking(PepleMC.endX,PepleMC.endY,GV.MAN_PEOPLE.id);
               }
               pathArray = [{
                  "X":startX,
                  "Y":startY
               },{
                  "X":endX,
                  "Y":endY
               }];
               PepleMC.gotoHere(pathArray,40);
            }
            else
            {
               PepleMC = Peple;
               startX = PepleMC.x;
               startY = PepleMC.y;
               endX = X_or_Array;
               endY = Y_or_Peple;
               if(Boolean(endX == PepleMC.endX && endY == PepleMC.endY))
               {
                  return true;
               }
               pathArray = new Array();
               if(PepleMC.layer == "FloorLayer")
               {
                  try
                  {
                     pathArray = GV.FindPath.getPath(startX,startY,endX,endY);
                  }
                  catch(E:*)
                  {
                     pathArray = [];
                  }
               }
               else
               {
                  pathArray = [{
                     "X":startX,
                     "Y":startY
                  },{
                     "X":endX,
                     "Y":endY
                  }];
               }
               if(pathArray.length >= 2)
               {
                  PepleMC.startX = startX;
                  PepleMC.startY = startY;
                  PepleMC.endX = endX;
                  PepleMC.endY = endY;
                  if(PepleMC == GV.MAN_PEOPLE && MoveTo.CanPathPoint)
                  {
                     GV.onlineClass.walking(X_or_Array,Y_or_Peple,GV.MAN_PEOPLE.id);
                  }
                  PepleMC.gotoHere(pathArray,40);
                  return true;
               }
            }
            i++;
         }
         return false;
      }
      
      public static function addMouseEventToStage() : void
      {
         GV.onlineClass.addEventListener(ClientOnLineSerSocket.GET_WALK_MESSAGE,getAllPos);
         LevelManager.stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler);
      }
      
      public static function removeMouseEventToStage() : void
      {
         GV.onlineClass.removeEventListener(ClientOnLineSerSocket.GET_WALK_MESSAGE,getAllPos);
         LevelManager.stage.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler);
      }
      
      public static function noLinerMotoPoint(tp:Point) : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee(PeopleEvent.READY_MOVE));
         tp = GV.MC_Depth.globalToLocal(tp);
         AutoFind(tp.x,tp.y,GV.MAN_PEOPLE);
      }
      
      private static function cancelCall() : void
      {
         GV.onlineSocket.dispatchEvent(new Event("callCancel"));
      }
      
      public static function onMouseDownHandler(E:MouseEvent) : void
      {
         var tempFootMark:MovieClip = null;
         var mc:MovieClip = null;
         var tp:Point = new Point(E.stageX,E.stageY);
         if(ActivityTmpDataManager.isCallingGod)
         {
            Alert.showChooseAlart("小摩爾是否確定要結束祈禱?",cancelCall);
            return;
         }
         if(_CanMove && MoveCondition.check(tp))
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee(PeopleEvent.READY_MOVE));
            tp = GV.MC_Depth.globalToLocal(tp);
            AutoFind(tp.x,tp.y,GV.MAN_PEOPLE);
            if(GV.isSitDown)
            {
               LeaveGameReq.leaveGame(0);
               GV.isSitDown = false;
            }
            if(isShowHalo(tp))
            {
               tempFootMark = UIManager.getMovieClip("ToPoint_mc");
               tempFootMark.x = tp.x;
               tempFootMark.y = tp.y;
               mc = GV.MC_mapFrame;
               if(Boolean(mc))
               {
                  mc.addChildAt(tempFootMark,mc.getChildIndex(mc["depth_mc"]) - 1);
               }
            }
            MainManager.getStage().focus = MainManager.getStage();
         }
         else
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee(MapEvent.MOUSE_DOWN));
         }
      }
      
      private static function isShowHalo(tp:Point) : Boolean
      {
         if(Boolean(MapManageView.inst.mapLevel))
         {
            if(Boolean(MapManageView.inst.mapLevel.controlLevel) && MapManageView.inst.mapLevel.controlLevel.hitTestPoint(tp.x,tp.y,true))
            {
               return false;
            }
            if(Boolean(MapManageView.inst.mapLevel.buttonLevel) && MapManageView.inst.mapLevel.buttonLevel.hitTestPoint(tp.x,tp.y,true))
            {
               return false;
            }
         }
         return true;
      }
      
      private static function getAllPos(evt:*) : void
      {
         if(evt.EventObj.UserID != GV.MAN_PEOPLE.id)
         {
            try
            {
               AutoFind(evt.EventObj.EndX,evt.EventObj.EndY,GF.getPeopleByID(evt.EventObj.UserID));
            }
            catch(E:*)
            {
            }
         }
      }
   }
}

