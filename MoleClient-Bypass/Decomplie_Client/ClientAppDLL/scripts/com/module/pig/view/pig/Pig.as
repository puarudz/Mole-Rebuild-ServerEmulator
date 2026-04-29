package com.module.pig.view.pig
{
   import com.common.data.HashMap;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.util.MovieClipUtil;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MoveCondition;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.socket.pig.PigSocket;
   import com.module.pig.PigDragCtl;
   import com.module.pig.PigEffectCtl;
   import com.module.pig.PigEvent;
   import com.module.pig.PigExtenalCtl;
   import com.module.pig.PigHouseEntrance;
   import com.module.pig.PigHouseUI;
   import com.module.pig.PigTipCtl;
   import com.module.pig.data.PigHouseData;
   import com.module.pig.util.DiedPigCtlPanel;
   import com.module.popupMsg.PopupMsgCtl;
   import com.view.PeopleView.ChildPeople.DigTreasureAvatar;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   
   public class Pig
   {
      
      private static const HitOffsetX:int = 56;
      
      private static const HitOffsetY:int = 10;
      
      private static var LockClick:Boolean = false;
      
      private var _pigActionCtl:PigActionCtl;
      
      private var _pigData:PigData;
      
      private var _pigMoveCtl:PigMoveCtl;
      
      private var _pigView:PigView;
      
      private var _getFullDataFuns:Array;
      
      private var _transformTimer:Timer;
      
      private var _showTip:Boolean = true;
      
      private var _useItemLock:Boolean = false;
      
      public function Pig(data:HashMap)
      {
         super();
         this._pigData = new PigData();
         this._pigData.UpdateData(data);
         this._pigView = new PigView(this);
         this._pigMoveCtl = new PigMoveCtl(this._pigView);
         this._pigActionCtl = new PigActionCtl();
         this._pigActionCtl.endFun = this.TryRandomMove;
         this._pigMoveCtl.changeDirFuns.add(this._pigView.ChangeDir,true);
         this._pigMoveCtl.stopMoveFuns.add(this.MoveOver,true);
         this.TryRandomMove();
         BC.addEvent(this,PigEvent.instance,PigEvent.Go_Eat_Food,this.GoEatFood);
         BC.addEvent(this,PigEvent.instance,PigEvent.Go_Bathe,this.GoBathe);
         BC.addEvent(this,this._pigView,MouseEvent.MOUSE_DOWN,this.MouseDownHandler);
         BC.addEvent(this,this._pigView,MouseEvent.CLICK,this.ClickHandler);
         BC.addEvent(this,this._pigView,MouseEvent.MOUSE_OVER,this.MouseOverHandler);
         BC.addEvent(this,this._pigView,MouseEvent.MOUSE_OUT,this.MouseOutHandler);
         BC.addEvent(this,GV.onlineSocket,"read_" + PigSocket.GetPigInfoCmd,this.UpdateDataHandler);
         BC.addEvent(this,PigEvent.instance,PigEvent.Breed_Pig_Over,this.BreedPigHandler);
      }
      
      public function get pigData() : PigData
      {
         return this._pigData;
      }
      
      public function get pigView() : PigView
      {
         return this._pigView;
      }
      
      private function get mole() : PeopleManageView
      {
         return GV.MAN_PEOPLE as PeopleManageView;
      }
      
      private function MouseDownHandler(e:MouseEvent) : void
      {
         e.stopImmediatePropagation();
      }
      
      private function BreedPigHandler(e:EventTaomee) : void
      {
         if(e.EventObj.pigID == this.pigData.id)
         {
            this.GetFullData(this._pigView.PopByState);
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
      
      public function Reset() : void
      {
         this.StopMoleAction();
         this._pigMoveCtl.ResetSpeed();
         this._pigView.PlayWaitAction();
         this._pigView.Update();
         LockClick = false;
         this.TryRandomMove();
      }
      
      public function StopMove() : void
      {
         this._pigMoveCtl.ResetSpeed();
         this._pigActionCtl.RemoveAllAction();
         this._pigMoveCtl.stopToHere();
      }
      
      public function StopTo(x:Number, y:Number, quickMove:Boolean = true) : void
      {
         if(this._pigData.isDied || this._pigData.isDying)
         {
            return;
         }
         this._pigActionCtl.RemoveAllAction();
         var _temp_2:* = this._pigActionCtl;
         with({})
         {
            _temp_2.AddAction(function h():void
            {
               pigView.PlayAction(PigView.Stay_Dir_RightDown);
            },0);
            this._pigActionCtl.AddAction(this.StopMove);
            if(quickMove)
            {
               this._pigMoveCtl.speed = 150;
            }
            this._pigMoveCtl.MoveTo(this._pigView.x,this._pigView.y,x,y);
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
         
         public function UpdateData(data:HashMap = null) : void
         {
            if(data != null)
            {
               this._pigData.UpdateData(data);
               this._pigView.Update(false);
            }
            else
            {
               PigSocket.GetPigInfo(PigHouseEntrance.instance.userId,this._pigData.id);
            }
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
         
         public function Train(type:int) : void
         {
            var trainType:int = type % 10;
            var pigBreed:int = int(type / 10);
            if(pigBreed != this.pigData.breed)
            {
               return;
            }
            this.mole.stopToHere();
            if(trainType == 1 && trainType == this._pigView.waitTrainType)
            {
               this.StopMove();
               this._pigView.PlayAction(PigView.Train_1);
            }
            else
            {
               if(!(trainType == 2 && trainType == this._pigView.waitTrainType))
               {
                  return;
               }
               this.StopMove();
               this._pigView.PlayAction(PigView.Train_2);
            }
            this._pigView.waitTrainType = -1;
            BC.addEvent(this,GV.onlineSocket,"read_" + PigSocket.TrainCmd,this.TrainOKHandler);
            PigSocket.Train(this._pigData.id,trainType);
            this._pigActionCtl.AddAction(this.UpdateData,3300);
            this._pigActionCtl.AddAction(this.Reset);
            this._pigActionCtl.Play();
         }
         
         private function GoBathe(e:EventTaomee) : void
         {
            if(this._pigData.isDied)
            {
               return;
            }
            this.StopMove();
            this._pigActionCtl.AddAction(this.GoBatheOver,4000);
            this._pigActionCtl.AddAction(this.RandomMove);
            this._pigActionCtl.AddAction(this.BatheAndFoodOver,2500);
            this._pigActionCtl.AddAction(this.Reset);
            LockClick = true;
            var obj:Object = e.EventObj;
            this._pigMoveCtl.speed = 120;
            var endX:Number = obj.x + Math.random() * 20;
            var endY:Number = obj.y + Math.random() * 20;
            this._pigMoveCtl.MoveTo(this._pigView.x,this._pigView.y,endX,endY);
            this._pigView.Pop_Happy();
         }
         
         private function BatheAndFoodOver() : void
         {
            this._pigView.PlayRandomHappy();
         }
         
         private function GoBatheOver() : void
         {
            this._pigView.PlayAction(PigView.Bathe);
            this._pigMoveCtl.ResetSpeed();
         }
         
         private function GoEatFood(e:EventTaomee) : void
         {
            if(this._pigData.isDied)
            {
               return;
            }
            if(this._pigData.hungry == 0)
            {
               return;
            }
            this.StopMove();
            this._pigActionCtl.AddAction(this.GoEatFoodOver,4000);
            this._pigActionCtl.AddAction(this.RandomMove);
            this._pigActionCtl.AddAction(this.BatheAndFoodOver,2500);
            this._pigActionCtl.AddAction(this.Reset);
            LockClick = true;
            var obj:Object = e.EventObj.mc;
            this._pigMoveCtl.speed = 120;
            var offsetX:Number = Math.random() * obj.width;
            var offsetY:Number = obj.height - obj.height * (obj.width - offsetX) / obj.width;
            this._pigMoveCtl.MoveTo(this._pigView.x,this._pigView.y,obj.x + offsetX,obj.y + offsetY);
            this._pigView.Pop_Happy();
         }
         
         private function GoEatFoodOver() : void
         {
            this._pigView.PlayAction(PigView.Eat);
            this._pigMoveCtl.ResetSpeed();
         }
         
         private function IsMoleHitItem() : Boolean
         {
            if(MoveCondition.hasRoad(this._pigView.x - HitOffsetX,this._pigView.y + HitOffsetY))
            {
               return this.mole.avatarMC.Visualize_mc.hitTestPoint(this._pigView.x - HitOffsetX,this._pigView.y + HitOffsetY,true);
            }
            return this.mole.avatarMC.Visualize_mc.hitTestPoint(this._pigView.x,this._pigView.y,true);
         }
         
         public function MovetoTeasePig(e:* = null) : void
         {
            if(LockClick)
            {
               return;
            }
            this.StopMove();
            this._pigView.PlayAction(PigView.Stay_Dir_LeftDown);
            if(this.IsMoleHitItem())
            {
               this.TeasePig();
            }
            else
            {
               BC.addOnceEvent(this,this.mole.avatarClass,PeopleManageView.ON_GO_OVER,this.TeasePig);
               if(MoveCondition.hasRoad(this._pigView.x - HitOffsetX,this._pigView.y + HitOffsetY))
               {
                  this.mole.moveTo(this._pigView.x - HitOffsetX,this._pigView.y + HitOffsetY);
               }
               else
               {
                  this.mole.moveTo(this._pigView.x,this._pigView.y);
               }
            }
         }
         
         private function TeasePig(e:* = null) : void
         {
            if(!this.IsMoleHitItem())
            {
               this.StopMoleAction();
               this._pigMoveCtl.ResetSpeed();
               this._pigView.PlayWaitAction();
               this.TryRandomMove();
               return;
            }
            this.PlayMoleAction("tease");
            this._pigView.PlayRandomTease();
            this._pigView.isWaitingTease = false;
            BC.addEvent(this,GV.onlineSocket,"read_" + PigSocket.TeaseCmd,this.TeaseOKHandler);
            PigSocket.Tease(this._pigData.id);
            this._pigActionCtl.AddAction(this.UpdateData,2600);
            this._pigActionCtl.AddAction(this.Reset);
            this._pigActionCtl.Play();
         }
         
         private function TeaseOKHandler(e:EventTaomee) : void
         {
            /*
             * Decompilation error
             * Code may be obfuscated
             * Tip: You can try enabling "Deobfuscate code" option in Settings
             * Error type: IndexOutOfBoundsException (Index -1 out of bounds for length 0)
             */
            throw new flash.errors.IllegalOperationError("Not decompiled due to error");
         }
         
         private function TrainOKHandler(e:EventTaomee) : void
         {
            /*
             * Decompilation error
             * Code may be obfuscated
             * Tip: You can try enabling "Deobfuscate code" option in Settings
             * Error type: IndexOutOfBoundsException (Index -1 out of bounds for length 0)
             */
            throw new flash.errors.IllegalOperationError("Not decompiled due to error");
         }
         
         private function ShowOptionEffect(data:Object) : void
         {
            if(Boolean(data.weight) && data.weight > 0)
            {
               if(this._pigData.breed == PigData.Breed_Fat_Pig)
               {
                  new PigEffectCtl(PigEffectCtl.Type_effect_weight,data.weight,this._pigView.x,this._pigView.y);
               }
               else if(this._pigData.breed == PigData.Breed_Beauty_Pig)
               {
                  new PigEffectCtl(PigEffectCtl.Type_effect_glamour,data.weight,this._pigView.x,this._pigView.y);
               }
               else
               {
                  new PigEffectCtl(PigEffectCtl.Type_effect_strength,data.weight,this._pigView.x,this._pigView.y);
               }
            }
            if(Boolean(data.exp) && data.exp > 0)
            {
               PigHouseData.instance.exp += data.exp;
               new PigEffectCtl(PigEffectCtl.Type_effect_exp,data.exp,this._pigView.x,this._pigView.y + 20);
            }
         }
         
         private function ClickHandler(e:MouseEvent) : void
         {
            var mc:MovieClip = null;
            if(PigDragCtl.dragType != -1)
            {
               if(PigDragCtl.dragType == PigDragCtl.Type_Tease)
               {
                  if(this._pigView.isWaitingTease)
                  {
                     this.MovetoTeasePig();
                     PigDragCtl.StopDrag();
                  }
                  else
                  {
                     this.mole.stopToHere();
                  }
               }
               if(PigDragCtl.dragType == PigDragCtl.Type_Item)
               {
                  e.stopImmediatePropagation();
                  this.UseItem();
                  return;
               }
               if(PigDragCtl.dragType != PigDragCtl.Type_Train)
               {
                  PigDragCtl.StopDrag();
               }
               return;
            }
            e.stopImmediatePropagation();
            if(PigHouseEntrance.instance.isEditing)
            {
               return;
            }
            if(this._pigData.isDied)
            {
               if(PigHouseEntrance.instance.isMyPigHouse)
               {
                  new DiedPigCtlPanel(this);
               }
               else
               {
                  this._pigView.visible = false;
                  mc = PigHouseUI.instance.GetMovieClip("die_movie");
                  mc.x = this._pigView.x;
                  mc.y = this._pigView.y;
                  MainManager.getAppLevel().addChild(mc);
                  MovieClipUtil.playEndAndRemove(mc);
               }
               return;
            }
            PigExtenalCtl.OpenPigInfoPanel(this);
         }
         
         private function MouseOverHandler(e:MouseEvent) : void
         {
            /*
             * Decompilation error
             * Code may be obfuscated
             * Tip: You can try enabling "Deobfuscate code" option in Settings
             * Error type: IndexOutOfBoundsException (Index -1 out of bounds for length 0)
             */
            throw new flash.errors.IllegalOperationError("Not decompiled due to error");
         }
         
         private function MouseOutHandler(e:MouseEvent) : void
         {
            this._showTip = false;
            PigTipCtl.ClearTip();
            if(PigDragCtl.dragType != PigDragCtl.Type_Train)
            {
               PigDragCtl.ShowBanIcon();
               return;
            }
         }
         
         private function MoveOver(moveCtl:PigMoveCtl) : void
         {
            this._pigView.PlayWaitAction();
            this._pigActionCtl.Play();
         }
         
         private function PlayMoleAction(action:String) : void
         {
            try
            {
               LockClick = true;
               MoveTo.CanMove = false;
               DigTreasureAvatar(this.mole.avatarClass).DelRotation();
               DigTreasureAvatar(this.mole.avatarClass).stopAction();
               DigTreasureAvatar(this.mole.avatarClass).showAction(action);
            }
            catch(e:Error)
            {
            }
         }
         
         private function StopMoleAction() : void
         {
            try
            {
               DigTreasureAvatar(this.mole.avatarClass).stopAction("right");
               DigTreasureAvatar(this.mole.avatarClass).addRotation();
               MoveTo.CanMove = true;
               LockClick = false;
            }
            catch(e:Error)
            {
            }
         }
         
         private function DragItemOver() : void
         {
            var dragId:int = PigDragCtl.dragId;
            if(this._pigData.isDied && dragId != 1613108)
            {
               return;
            }
            if(dragId == 1613109)
            {
               if(this._pigData.growState != PigData.Grow_State_Adult)
               {
                  PigDragCtl.HideBanIcon();
               }
               return;
            }
            if(dragId == 1613110)
            {
               if(this._pigData.isCanSeed == true && this._pigData.isHasBaby == false && this._pigData.isHasVariationBaby == false)
               {
                  PigDragCtl.HideBanIcon();
               }
               return;
            }
            if(dragId == 1613111)
            {
               if(this._pigData.isHasBaby)
               {
                  PigDragCtl.HideBanIcon();
               }
               return;
            }
            if(dragId == 1613112)
            {
               if(this._pigData.isHasBaby)
               {
                  PigDragCtl.HideBanIcon();
               }
               return;
            }
            if(dragId == 1613113)
            {
               if(this._pigData.isCanSeed == true && this._pigData.isHasBaby == false && this._pigData.isHasTwoBaby == false)
               {
                  PigDragCtl.HideBanIcon();
               }
               return;
            }
            if(GoodsInfo.getType(dragId) == 37)
            {
               if(this._pigData.breed == PigData.Breed_Beauty_Pig && this._pigData.dress_1 == 0)
               {
                  PigDragCtl.HideBanIcon();
               }
               return;
            }
            PigDragCtl.HideBanIcon();
         }
         
         private function UseItem() : void
         {
            var dragId:int = PigDragCtl.dragId;
            if(this._pigData.isDied && dragId != 1613108)
            {
               return;
            }
            if(dragId != -1 && PigDragCtl.dragType == PigDragCtl.Type_Item && PigDragCtl.isBaned == false && this._useItemLock == false)
            {
               this._useItemLock = true;
               BC.addEvent(this,GV.onlineSocket,"read_" + PigSocket.UseItemCmd,this.UseItemHandler);
               with({})
               {
                  
                  setTimeout(function handler():void
                  {
                     _useItemLock = false;
                  },1000);
               }
            }
            
            private function UseItemHandler(e:EventTaomee) : void
            {
               var result:int = int(e.EventObj.result);
               var itemId:int = int(e.EventObj.itemId);
               var pigId:int = int(e.EventObj.pigId);
               if(pigId != this._pigData.id)
               {
                  return;
               }
               this._useItemLock = false;
               BC.removeEvent(this,GV.onlineSocket,"read_" + PigSocket.UseItemCmd,this.UseItemHandler);
               switch(itemId)
               {
                  case 1613103:
                     if(result != 0)
                     {
                        this.GetFullData(this._pigView.PopByState);
                        new PigEffectCtl(PigEffectCtl.Type_effect_weight,35,this._pigView.x,this._pigView.y);
                     }
                     break;
                  case 1613108:
                     if(result != 0)
                     {
                        this.GetFullData(this._pigView.PopByState);
                        new PigEffectCtl(PigEffectCtl.Type_effect_age,10,this._pigView.x,this._pigView.y);
                     }
                     break;
                  case 1613109:
                     if(result != 0)
                     {
                        this.GetFullData(this._pigView.PopByState);
                        new PigEffectCtl(PigEffectCtl.Type_effect_growup,0,this._pigView.x,this._pigView.y);
                     }
                     break;
                  case 1613110:
                     if(result != 0)
                     {
                        this.GetFullData(this._pigView.PopByState);
                        new PigEffectCtl(PigEffectCtl.Type_effect_variation,100,this._pigView.x,this._pigView.y);
                     }
                     break;
                  case 1613111:
                     if(result != 0)
                     {
                        PigHouseData.instance.GetPigHouseData();
                        this.GetFullData(this._pigView.PopByState);
                        new PigEffectCtl(PigEffectCtl.Type_effect_deleteTime,12,this._pigView.x,this._pigView.y);
                     }
                     else
                     {
                        PopupMsgCtl.PopupMsg(GoodsInfo.getItemNameByID(itemId) + "一天只能使用一次哦！");
                     }
                     break;
                  case 1613112:
                     if(result != 0)
                     {
                        PigHouseData.instance.GetPigHouseData();
                        this.GetFullData(this._pigView.PopByState);
                        new PigEffectCtl(PigEffectCtl.Type_effect_addPig,0,this._pigView.x,this._pigView.y);
                     }
                     break;
                  case 1613113:
                     if(result != 0)
                     {
                        this.GetFullData(this._pigView.PopByState);
                        new PigEffectCtl(PigEffectCtl.Type_effect_twoBaby,0,this._pigView.x,this._pigView.y);
                     }
               }
               if(GoodsInfo.getType(itemId) == 37)
               {
                  this.GetFullData(this._pigView.Init);
               }
               if(result != 0)
               {
                  PigEvent.instance.DeleteBagItem(itemId);
               }
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
            
            public function PlayDance() : void
            {
               if(this._pigData.isDying || this._pigData.isDied)
               {
                  return;
               }
               MoveTo.CanMove = true;
               LockClick = false;
               this._pigMoveCtl.stopToHere();
               var _temp_2:* = this._pigActionCtl;
               with({})
               {
                  _temp_2.AddAction(function h():void
                  {
                     _pigView.PlayAction(PigView.Happy_3);
                  },2500);
                  this._pigActionCtl.Play();
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
         
         