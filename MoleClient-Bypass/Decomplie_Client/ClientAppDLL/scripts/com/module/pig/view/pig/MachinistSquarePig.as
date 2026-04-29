package com.module.pig.view.pig
{
   import com.common.Alert.Alert;
   import com.common.data.HashMap;
   import com.core.MainManager;
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.socket.pig.PigSocket;
   import com.module.pig.MachinistSquareEntrance;
   import com.module.pig.MachinistSquareFurnaceCtl;
   import com.module.pig.MachinistSquareJiChuangCtl;
   import com.module.pig.PigDragCtl;
   import com.module.pig.PigEvent;
   import com.module.pig.data.MachinistSquareData;
   import com.module.popupMsg.PopupMsgCtl;
   import com.mole.app.manager.ModuleManager;
   import com.view.PeopleView.PeopleManageView;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   
   public class MachinistSquarePig
   {
      
      private static var LockClick:Boolean = false;
      
      private var _pigActionCtl:PigActionCtl;
      
      private var _pigData:PigData;
      
      private var _pigMoveCtl:PigMoveCtl;
      
      private var _pigView:MachinistSquarePigView;
      
      private var _moveBl:Boolean = false;
      
      private var _transformTimer:Timer;
      
      private var _getFullDataFuns:Array;
      
      private var _useItemLock:Boolean = false;
      
      public function MachinistSquarePig(data:HashMap)
      {
         super();
         this._pigData = new PigData();
         this._pigData.UpdateData(data);
         this._pigView = new MachinistSquarePigView(this);
         this._pigMoveCtl = new PigMoveCtl(this._pigView);
         this._pigActionCtl = new PigActionCtl();
         this._pigActionCtl.endFun = this.TryRandomMove;
         this._pigMoveCtl.changeDirFuns.add(this._pigView.ChangeDir,true);
         this._pigMoveCtl.stopMoveFuns.add(this.MoveOver,true);
         this.TryRandomMove();
         BC.addEvent(this,this._pigView,MouseEvent.MOUSE_DOWN,this.MouseDownHandler);
         BC.addEvent(this,this._pigView,MouseEvent.CLICK,this.ClickHandler);
         BC.addEvent(this,this._pigView,MouseEvent.MOUSE_OVER,this.OverHandler);
         BC.addEvent(this,this._pigView,MouseEvent.MOUSE_OUT,this.OutHandler);
         BC.addEvent(this,GV.onlineSocket,"read_" + PigSocket.GetPigInfoCmd,this.UpdateDataHandler);
      }
      
      private function OverHandler(event:MouseEvent) : void
      {
         if(PigDragCtl.dragType == PigDragCtl.Type_Item)
         {
            this.StopMove();
            this.DragItemOver();
         }
      }
      
      private function OutHandler(event:MouseEvent) : void
      {
         if(PigDragCtl.dragType == PigDragCtl.Type_Item)
         {
            PigDragCtl.ShowBanIcon();
            this.TryRandomMove();
            return;
         }
      }
      
      private function MouseDownHandler(event:MouseEvent) : void
      {
         if(PigDragCtl.dragType != -1)
         {
            if(PigDragCtl.dragType == PigDragCtl.Type_Item)
            {
               event.stopImmediatePropagation();
               return;
            }
         }
         this.StopMove();
         this._pigView.SetPigToTopLevel();
         this._pigView.SetOfforPoint();
         BC.removeEvent(this,this._pigView,MouseEvent.MOUSE_DOWN,this.MouseDownHandler);
         BC.addEvent(this,MainManager.getStage(),MouseEvent.MOUSE_MOVE,this.MouseMoveHandler);
         BC.addEvent(this,MainManager.getStage(),MouseEvent.MOUSE_UP,this.MouseUpHandler);
         LockClick = true;
         event.stopImmediatePropagation();
      }
      
      private function MouseMoveHandler(event:MouseEvent) : void
      {
         if(event.buttonDown)
         {
            LevelManager.mapLevel.mouseChildren = false;
            this._moveBl = true;
         }
         var p:Point = new Point(MainManager.getStage().mouseX,MainManager.getStage().mouseY);
         this._pigView.MovePigByMouse(p);
      }
      
      private function MouseUpHandler(event:MouseEvent) : void
      {
         var p:Point = null;
         var result:Boolean = false;
         BC.removeEvent(this,MainManager.getStage(),MouseEvent.MOUSE_MOVE,this.MouseMoveHandler);
         BC.removeEvent(this,MainManager.getStage(),MouseEvent.MOUSE_UP,this.MouseUpHandler);
         this._pigView.SetPigToDepthLevel();
         LevelManager.mapLevel.mouseChildren = true;
         if(this._moveBl)
         {
            if(MachinistSquareFurnaceCtl.instance.ready_smelt || MachinistSquareJiChuangCtl.instance.ready_smelt)
            {
               if(this.pigData.energy >= 10)
               {
                  result = MachinistSquareFurnaceCtl.instance.HitPigAndRonglu(this);
                  if(result)
                  {
                     this._pigData.ready_work = true;
                     PigEvent.instance.dispatchEvent(new EventTaomee(PigEvent.Delete_Pig,{"pig":this}));
                     return;
                  }
                  result = MachinistSquareJiChuangCtl.instance.HitPigAndJiChuang(this);
                  if(result)
                  {
                     this._pigData.ready_work = true;
                     PigEvent.instance.dispatchEvent(new EventTaomee(PigEvent.Delete_Pig,{"pig":this}));
                     return;
                  }
               }
               else
               {
                  PopupMsgCtl.PopupMsg("這隻超級豬能量不足，不能勝任工作！");
               }
            }
            p = new Point(MainManager.getStage().mouseX,MainManager.getStage().mouseY);
            this._pigView.StopMovePigByMouse(p);
         }
         BC.addEvent(this,this._pigView,MouseEvent.MOUSE_DOWN,this.MouseDownHandler);
         event.stopImmediatePropagation();
         LockClick = false;
         this.TryRandomMove();
      }
      
      public function SetPigToWork() : void
      {
         if(this.pigData.energy > 0)
         {
            if(MachinistSquareFurnaceCtl.instance.ready_smelt)
            {
               MachinistSquareFurnaceCtl.instance.PigToWork(this);
               return;
            }
            if(MachinistSquareJiChuangCtl.instance.ready_smelt)
            {
               MachinistSquareJiChuangCtl.instance.PigToWork(this);
               return;
            }
            PopupMsgCtl.PopupMsg("暫時沒有工作可分配哦！");
         }
         else
         {
            PopupMsgCtl.PopupMsg("這隻超級豬能量不足，不能勝任工作！");
         }
      }
      
      private function ClickHandler(event:MouseEvent) : void
      {
         if(PigDragCtl.dragType == PigDragCtl.Type_Item)
         {
            event.stopImmediatePropagation();
            this.UseItem();
            return;
         }
         PigEvent.instance.dispatchEvent(new EventTaomee(PigEvent.Click_MachinePig,{"target":this}));
      }
      
      private function UpdateDataHandler(e:EventTaomee) : void
      {
         /*
          * Decompilation error
          * Code may be obfuscated
          * Tip: You can try enabling "Deobfuscate code" option in Settings
          * Error type: IndexOutOfBoundsException (Index -1 out of bounds for length 0)
          */
         throw new flash.errors.IllegalOperationError("Not decompiled due to error");
      }
      
      public function UpdateData(data:HashMap = null) : void
      {
         if(data != null)
         {
            this._pigData.UpdateData(data);
            this._pigView.Update(false);
         }
         else
         {
            PigSocket.GetPigInfo(MachinistSquareEntrance.instance.userId,this._pigData.id);
         }
      }
      
      public function TryRandomMove() : void
      {
         if(this._pigActionCtl == null)
         {
            return;
         }
         if(this._pigActionCtl.actionCount != 0)
         {
            return;
         }
         if(this._pigData.isDying)
         {
            this._pigView.PlayAction(PigView.Dying);
            return;
         }
         if(this._pigData.isDied)
         {
            this._pigView.PlayAction(PigView.Dying);
            return;
         }
         if(Math.random() > 0.8)
         {
            this._pigActionCtl.AddAction(this.RandomMove);
         }
         else if(this._pigData.hungry == 100)
         {
            this._pigActionCtl.AddAction(this._pigView.PlayHunger,3000);
         }
         else if(Math.random() > 0.95)
         {
            this._pigActionCtl.AddAction(this._pigView.PlayRandomHappy,2500);
         }
         else
         {
            this._pigActionCtl.AddAction(this._pigView.PlayWaitAction,4000);
         }
         this._pigActionCtl.Play();
      }
      
      private function RandomMove() : void
      {
         var endPoint:Point = MoveTo.getRandomFloorPoint();
         this._pigMoveCtl.MoveTo(this._pigView.x,this._pigView.y,endPoint.x,endPoint.y);
      }
      
      private function MoveOver(moveCtl:PigMoveCtl) : void
      {
         this._pigView.PlayWaitAction();
         this._pigActionCtl.Play();
      }
      
      public function PlayHappy(moveWhenEnd:Boolean = true) : void
      {
         /*
          * Decompilation error
          * Code may be obfuscated
          * Tip: You can try enabling "Deobfuscate code" option in Settings
          * Error type: IndexOutOfBoundsException (Index -1 out of bounds for length 0)
          */
         throw new flash.errors.IllegalOperationError("Not decompiled due to error");
      }
      
      public function GetFullData(fun:Function, refresh:Boolean = true) : void
      {
         var callBack:Function = null;
         if(this._getFullDataFuns == null)
         {
            this._getFullDataFuns = new Array();
         }
         this._getFullDataFuns.push(fun);
         if(this._pigData.name != null && refresh == false)
         {
            while(this._getFullDataFuns.length != 0)
            {
               callBack = this._getFullDataFuns.pop();
               if(callBack != null)
               {
                  callBack();
               }
            }
         }
         else
         {
            this.UpdateData();
         }
      }
      
      public function get pigData() : PigData
      {
         return this._pigData;
      }
      
      public function get pigView() : MachinistSquarePigView
      {
         return this._pigView;
      }
      
      private function get mole() : PeopleManageView
      {
         return GV.MAN_PEOPLE as PeopleManageView;
      }
      
      public function SetPigToPigHouse() : void
      {
         BC.addOnceEvent(this,GV.onlineSocket,"read_" + PigSocket.SendToTempHouseCmd,this.onResSentPigToPigHouse);
         PigSocket.SendToTempHouse(3,[this._pigData.id]);
      }
      
      private function onResSentPigToPigHouse(event:EventTaomee) : void
      {
         if(Boolean(event.EventObj.isOk))
         {
            MachinistSquareData.instance.GetMachinistSquareData();
         }
         else
         {
            PopupMsgCtl.PopupMsg("    肥肥館已經放不下更多的豬豬了！");
         }
      }
      
      private function DragItemOver() : void
      {
         var dragId:int = PigDragCtl.dragId;
         if(this._pigData.isFullEnergy())
         {
            return;
         }
         if(MachinistSquareEntrance.instance.isMyHouse)
         {
            if(dragId == 1614000)
            {
               PigDragCtl.HideBanIcon();
               return;
            }
            if(dragId == 1614001)
            {
               PigDragCtl.HideBanIcon();
               return;
            }
            if(dragId == 1614017)
            {
               PigDragCtl.HideBanIcon();
               return;
            }
         }
      }
      
      private function UseItem() : void
      {
         var uid:uint = 0;
         var dragId:int = PigDragCtl.dragId;
         if(this._pigData.isFullEnergy())
         {
            return;
         }
         if(dragId != 1614000 && dragId != 1614001 && dragId != 1614017)
         {
            return;
         }
         if(dragId != -1 && PigDragCtl.dragType == PigDragCtl.Type_Item && PigDragCtl.isBaned == false && this._useItemLock == false)
         {
            this._useItemLock = true;
            uid = uint(MachinistSquareEntrance.instance.userId);
            BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_-100295",this.onUseError);
            BC.addEvent(this,GV.onlineSocket,"read_" + PigSocket.UserMachineGoodsCmd,this.UseItemHandler);
            with({})
            {
               
               setTimeout(function handler():void
               {
                  _useItemLock = false;
               },1000);
            }
         }
         
         private function onUseError(event:*) : void
         {
            BC.removeEvent(this,GV.onlineSocket,"ERROR_CMD_-100295",this.onUseError);
            BC.removeEvent(this,GV.onlineSocket,"read_" + PigSocket.UserMachineGoodsCmd,this.UseItemHandler);
            this._useItemLock = false;
         }
         
         private function UseItemHandler(e:EventTaomee) : void
         {
            BC.removeEvent(this,GV.onlineSocket,"ERROR_CMD_-100295",this.onUseError);
            BC.removeEvent(this,GV.onlineSocket,"read_" + PigSocket.UserMachineGoodsCmd,this.UseItemHandler);
            this._useItemLock = false;
            var dragId:int = PigDragCtl.dragId;
            if(dragId == 1614017)
            {
               Alert.smileAlart("    這隻超級豬的灌注次數已經清零！");
            }
            PigEvent.instance.DeleteBagItem(dragId);
            MachinistSquareData.instance.GetMachinistSquareData();
         }
         
         public function ShowInfo() : void
         {
            ModuleManager.openModule("MachinePigInfo",this,"module/pig/");
         }
         
         public function StopMove() : void
         {
            this._pigMoveCtl.ResetSpeed();
            this._pigActionCtl.RemoveAllAction();
            this._pigMoveCtl.stopToHere();
         }
         
         public function Clear() : void
         {
            this.StopMove();
            this._pigActionCtl.Clear();
            this._pigView.Clear();
            this._pigView = null;
            this._pigData = null;
            this._pigMoveCtl = null;
            this._pigActionCtl = null;
            LockClick = false;
            BC.removeEvent(this);
         }
      }
   }
   
   