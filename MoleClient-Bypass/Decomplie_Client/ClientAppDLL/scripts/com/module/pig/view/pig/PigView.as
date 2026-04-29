package com.module.pig.view.pig
{
   import com.common.util.MovieClipUtil;
   import com.logic.MapManageLogic.MapDepthManageLogic;
   import com.module.pig.PigDragCtl;
   import com.module.pig.PigHouseEntrance;
   import com.module.pig.PigHouseUI;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.setTimeout;
   
   public class PigView extends Sprite
   {
      
      public static const Move_Dir_LeftUp:String = "左上";
      
      public static const Move_Dir_LeftDown:String = "左下";
      
      public static const Move_Dir_RightUp:String = "右上";
      
      public static const Move_Dir_RightDown:String = "右下";
      
      public static const Stay_Dir_LeftUp:String = "待机左上";
      
      public static const Stay_Dir_LeftDown:String = "待机左下";
      
      public static const Stay_Dir_RightUp:String = "待机右上";
      
      public static const Stay_Dir_RightDown:String = "待机右下";
      
      public static const Eat:String = "喂食";
      
      public static const Bathe:String = "洗澡";
      
      public static const Hunger:String = "饥饿";
      
      public static const Tease_1:String = "逗逗1";
      
      public static const Tease_2:String = "逗逗2";
      
      public static const Tease_3:String = "逗逗3";
      
      public static const Dirty:String = "脏动画";
      
      public static const Dying:String = "濒死";
      
      public static const Train_1:String = "训练动作1";
      
      public static const Train_2:String = "训练动作2";
      
      public static const Happy_1:String = "开心1";
      
      public static const Happy_2:String = "开心2";
      
      public static const Happy_3:String = "开心3";
      
      private static var Wait_Tease_Count:int = 0;
      
      private var _currentAction:String = "左下";
      
      private var _direct:String = "左下";
      
      private var _pigPopIcon:MovieClip;
      
      private var _pigUI:MovieClip;
      
      private var _data:PigData;
      
      private var _pig:Pig;
      
      private var _waitTrainType:int = -1;
      
      private var _isWaitingTease:Boolean = false;
      
      private var _isTeased:Boolean = false;
      
      public function PigView(pig:Pig)
      {
         super();
         this._pig = pig;
         this._pigUI = new MovieClip();
         this._pigPopIcon = new MovieClip();
         this.buttonMode = true;
         this.addChild(this._pigPopIcon);
         this._data = this._pig.pigData;
         GV.MC_mapFrame["depth_mc"].addChild(this);
         BC.addEvent(this,MapDepthManageLogic.owner,MapDepthManageLogic.ADD_ARRAY,this.handler);
         this.Init();
      }
      
      public function get isWaitingTease() : Boolean
      {
         return this._isWaitingTease;
      }
      
      public function set isWaitingTease(value:Boolean) : void
      {
         this._isWaitingTease = value;
         if(this._isWaitingTease)
         {
            ++Wait_Tease_Count;
         }
         else
         {
            --Wait_Tease_Count;
         }
      }
      
      public function set waitTrainType(value:int) : void
      {
         this._waitTrainType = value;
      }
      
      public function get waitTrainType() : int
      {
         return this._waitTrainType;
      }
      
      private function handler(e:*) : void
      {
         var f:Function = e.EventObj as Function;
         f([this]);
      }
      
      public function Init() : void
      {
         var uiUrl:String = "resource/pig/swf/" + this._data.showId + ".swf";
         var loader:Loader = new Loader();
         BC.addOnceEvent(this,loader.contentLoaderInfo,Event.COMPLETE,this.LoadOverHandler);
         loader.load(VL.getURLRequest(uiUrl));
      }
      
      private function LoadOverHandler(e:Event) : void
      {
         var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
         GC.clearAll(this._pigUI);
         this._pigUI = loaderInfo.content as MovieClip;
         this._pigUI = this._pigUI.getChildAt(0) as MovieClip;
         this._pigUI.x = this._pigUI.y = 0;
         this.Update();
         this.addChildAt(this._pigUI,0);
         this.PlayAction(this._currentAction);
      }
      
      public function ChangeDir(moveCtl:PigMoveCtl) : void
      {
         var startP:Point = moveCtl.startP;
         var endP:Point = moveCtl.endP;
         if(endP.y > startP.y)
         {
            if(endP.x > startP.x)
            {
               this._direct = Move_Dir_RightDown;
               this.PlayAction(Move_Dir_RightDown);
            }
            else
            {
               this._direct = Move_Dir_LeftDown;
               this.PlayAction(Move_Dir_LeftDown);
            }
         }
         else if(endP.x > startP.x)
         {
            this._direct = Move_Dir_RightUp;
            this.PlayAction(Move_Dir_RightUp);
         }
         else
         {
            this._direct = Move_Dir_LeftUp;
            this.PlayAction(Move_Dir_LeftUp);
         }
      }
      
      public function PlayWaitAction() : void
      {
         this.PlayAction("待机" + this._direct);
      }
      
      public function PlayHunger() : void
      {
         this.PlayAction(Hunger);
      }
      
      public function PlayAction(action:String) : void
      {
         this._currentAction = action;
         MovieClipUtil.gotoAndStop(this._pigUI,action);
      }
      
      public function PlayRandomHappy() : void
      {
         var tpye:int = int(Math.random() * 100) % 3 + 1;
         this.PlayAction("开心" + tpye);
      }
      
      public function PlayRandomTease() : void
      {
         var tpye:int = int(Math.random() * 100) % 3 + 1;
         this.PlayAction("逗逗" + tpye);
      }
      
      public function Update(updatePop:Boolean = true) : void
      {
         if(this._data.growState == PigData.Grow_State_Adult)
         {
            this._pigUI.scaleX = this._pigUI.scaleY = 1.1;
         }
         else if(this._data.growState == PigData.Grow_State_Baby)
         {
            this._pigUI.scaleX = this._pigUI.scaleY = 0.7;
         }
         else
         {
            this._pigUI.scaleX = this._pigUI.scaleY = 0.9;
         }
         if(updatePop)
         {
            this.PopByState();
         }
         this._pigPopIcon.y = -this._pigUI.height + 5;
      }
      
      public function Clear() : void
      {
         BC.removeEvent(this);
         GC.clearAll(this);
         Wait_Tease_Count = 0;
      }
      
      public function PopByState() : void
      {
         if(this._data.isDying)
         {
            return;
         }
         if(this._data.isDied)
         {
            this.Pop_Die();
            return;
         }
         if(this._data.hungry == 100)
         {
            this.Pop_Hungry();
            return;
         }
         if(this._data.isCanTrain_1 && this._waitTrainType == -1 && PigHouseEntrance.instance.isMyPigHouse)
         {
            this._waitTrainType = 1;
            this.Pop_Train_1();
            return;
         }
         if(this._data.isCanTrain_2 && this._waitTrainType == -1 && PigHouseEntrance.instance.isMyPigHouse)
         {
            this._waitTrainType = 2;
            this.Pop_Train_2();
            return;
         }
         if(this._data.isHasBaby)
         {
            if(this._data.isHasTwoBaby)
            {
               this.Pop_TwoBaby();
            }
            else
            {
               this.Pop_Baby();
            }
            return;
         }
         if(this._data.isCanSeed)
         {
            if(this._data.isHasTwoBaby)
            {
               this.Pop_TwoSeed();
            }
            else
            {
               this.Pop_Seed();
            }
            return;
         }
         if(Math.random() > 0.5 && Wait_Tease_Count < 3 && this._data.isCanTease && this._isTeased == false && PigHouseEntrance.instance.isMyPigHouse)
         {
            this.isWaitingTease = true;
            this._isTeased = true;
            this.Pop_Tease();
            return;
         }
         if(Math.random() > 0.5)
         {
            with({})
            {
               
               setTimeout(function h():void
               {
                  ClearPop();
               },5000 * Math.random());
               return;
            }
            this.ClearPop();
         }
         
         public function Pop_Happy() : void
         {
            this.ClearPop();
            this._pigPopIcon.addChild(PigHouseUI.instance.GetMovieClip("pop_happy"));
         }
         
         public function Pop_Hungry() : void
         {
            this.ClearPop();
            this._pigPopIcon.addChild(PigHouseUI.instance.GetMovieClip("pop_hungry"));
         }
         
         public function Pop_Seed() : void
         {
            this.ClearPop();
            this._pigPopIcon.addChild(PigHouseUI.instance.GetMovieClip("pop_seed"));
         }
         
         public function Pop_TwoSeed() : void
         {
            this.ClearPop();
            this._pigPopIcon.addChild(PigHouseUI.instance.GetMovieClip("pop_twoSeed"));
         }
         
         public function Pop_Baby() : void
         {
            this.ClearPop();
            this._pigPopIcon.addChild(PigHouseUI.instance.GetMovieClip("pop_baby"));
         }
         
         public function Pop_TwoBaby() : void
         {
            this.ClearPop();
            this._pigPopIcon.addChild(PigHouseUI.instance.GetMovieClip("pop_twoBaby"));
         }
         
         public function Pop_Tease() : void
         {
            this.ClearPop();
            this._pigPopIcon.addChild(PigHouseUI.instance.GetMovieClip("pop_tease"));
            var _temp_4:* = BC;
            var _temp_3:* = this;
            var _temp_2:* = this._pigPopIcon;
            var _temp_1:* = MouseEvent.CLICK;
            with({})
            {
               _temp_4.addEvent(_temp_3,_temp_2,_temp_1,function h(e:MouseEvent):void
               {
                  if(PigDragCtl.dragType != -1)
                  {
                     return;
                  }
                  e.stopImmediatePropagation();
                  _pig.MovetoTeasePig();
               });
            }
            
            public function Pop_Die() : void
            {
               this.ClearPop();
               this._pigPopIcon.addChild(PigHouseUI.instance.GetMovieClip("pop_dying"));
            }
            
            public function Pop_Train_1() : void
            {
               this.ClearPop();
               this._pigPopIcon.addChild(PigHouseUI.instance.GetMovieClip("pop_train_" + this._data.breed + "_1"));
               var _temp_4:* = BC;
               var _temp_3:* = this;
               var _temp_2:* = this._pigPopIcon;
               var _temp_1:* = MouseEvent.CLICK;
               with({})
               {
                  _temp_4.addEvent(_temp_3,_temp_2,_temp_1,function h(e:MouseEvent):void
                  {
                     if(PigDragCtl.dragType != -1)
                     {
                        return;
                     }
                     e.stopImmediatePropagation();
                     _pig.Train(1 + _pig.pigData.breed * 10);
                  });
               }
               
               public function Pop_Train_2() : void
               {
                  this.ClearPop();
                  this._pigPopIcon.addChild(PigHouseUI.instance.GetMovieClip("pop_train_" + this._data.breed + "_2"));
                  var _temp_4:* = BC;
                  var _temp_3:* = this;
                  var _temp_2:* = this._pigPopIcon;
                  var _temp_1:* = MouseEvent.CLICK;
                  with({})
                  {
                     _temp_4.addEvent(_temp_3,_temp_2,_temp_1,function h(e:MouseEvent):void
                     {
                        if(PigDragCtl.dragType != -1)
                        {
                           return;
                        }
                        e.stopImmediatePropagation();
                        _pig.Train(2 + _pig.pigData.breed * 10);
                     });
                  }
                  
                  private function ClearPop() : void
                  {
                     this._pigPopIcon.buttonMode = false;
                     BC.removeEvent(this,this._pigPopIcon);
                     GC.clearAllChildren(this._pigPopIcon);
                  }
               }
            }
            
            