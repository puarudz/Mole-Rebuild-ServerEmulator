package com.module.digTreasure.view
{
   import com.common.soundControl.soundControl;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.socket.digTreasure.DigTreasureSocket;
   import com.module.digTreasure.DigTreasureEvent;
   import com.module.digTreasure.DigTreasureViewCtl;
   import com.module.digTreasure.IDigTreasureItemCtl;
   import com.module.digTreasure.data.DigTreasureConfig;
   import com.module.digTreasure.data.DigTreasureData;
   import com.view.PeopleView.ChildPeople.DigTreasureAvatar;
   import com.view.PeopleView.PeopleManageView;
   import com.view.mapView.activity.Task83.SoundManager;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.ui.Mouse;
   import flash.utils.setTimeout;
   
   public class DigTreasureItem implements IDigTreasureItemCtl
   {
      
      public static var moleMoveListner:IDigTreasureItemCtl;
      
      private static var LockClick:Boolean = false;
      
      private static const CircleRadius:int = 80;
      
      private static const Radian:int = 360;
      
      private static const TypeUrl:Array = ["","Mine","Boss","Event","Trigger"];
      
      protected var _config:XML;
      
      protected var _dataCtl:DigTreasureData;
      
      protected var _digCount:int;
      
      protected var _itemData:Object;
      
      protected var _itemUI:MovieClip;
      
      protected var _mole:PeopleManageView;
      
      protected var _name:String;
      
      protected var _tipMC:MovieClip;
      
      protected var _ui:Sprite;
      
      protected var _tipType:String;
      
      protected var _mouseType:int;
      
      private var _actionName:String;
      
      private var _addedExp:int;
      
      private var _canWalkX:Number;
      
      private var _canWalkY:Number;
      
      private var _effectName:String;
      
      private var _id:int;
      
      private var _index:int;
      
      private var _itemUIUrl:String;
      
      private var _randomPosTableId:int = -1;
      
      private var _soundName:String = "";
      
      private var _soundWaitTime:int = 0;
      
      private var _awardDelay:int = 0;
      
      private var _type:int;
      
      private var _usedHP:int;
      
      private var _x:Number;
      
      private var _y:Number;
      
      private var _viewCtl:DigTreasureViewCtl;
      
      private var _uiInMapId:String;
      
      private var _startDigFun:Function;
      
      public function DigTreasureItem()
      {
         super();
         this._ui = new Sprite();
         this.InitMouseEvent();
         this._mole = GV.MAN_PEOPLE as PeopleManageView;
         this._startDigFun = this.StartDig;
      }
      
      public function get itemUI() : MovieClip
      {
         return this._itemUI;
      }
      
      public function Clear() : void
      {
         BC.removeEvent(this);
         GC.clearAll(this._tipMC);
         this._ui = null;
         LockClick = false;
         this._itemData = null;
      }
      
      public function Init(View:DigTreasureViewCtl, dataCtl:DigTreasureData) : void
      {
         this._viewCtl = View;
         this._dataCtl = dataCtl;
      }
      
      public function SetConfig(config:XML, index:int) : void
      {
         var soundConfig:Array = null;
         this._index = index;
         this._id = config.@ID;
         this._type = config.@Type;
         if(config.hasOwnProperty("@uiInMapId"))
         {
            this._uiInMapId = config.@uiInMapId;
         }
         if(config.hasOwnProperty("@RandTable"))
         {
            this._x = -1000;
            this._y = -1000;
            this._canWalkX = 0;
            this._canWalkY = 0;
            this._randomPosTableId = config.@RandTable;
         }
         else
         {
            this._x = Number(config.@x);
            this._y = Number(config.@y);
            this._canWalkX = Number(config.@canWalkX);
            this._canWalkY = Number(config.@canWalkY);
         }
         this._config = DigTreasureConfig.instance.GetItemConfig(this._type,this._id);
         this._name = this._config.@name;
         this._addedExp = int(this._config.@Exp);
         this._usedHP = int(this._config.@Hp);
         this._tipType = this._config.@tipType;
         this._tipMC = DigTreasureConfig.instance.GetMovieClip(this._tipType);
         this._mouseType = int(this._config.@mouseType);
         if(this._config.hasOwnProperty("@sound"))
         {
            soundConfig = String(this._config.@sound).split(":");
            if(Boolean(soundConfig[0]))
            {
               this._soundName = soundConfig[0];
            }
            if(Boolean(soundConfig[1]))
            {
               this._soundWaitTime = int(soundConfig[1]);
            }
         }
         this._awardDelay = int(this._config.@awardDelay);
         this._actionName = this._config.@action;
         this._effectName = this._config.@effect;
         this._itemUIUrl = "resource/digTreasure/" + TypeUrl[this._type] + "/" + this._config.@ui + ".swf";
      }
      
      public function UpdateData(data:Object) : void
      {
         var pos:XML = null;
         var mapMC:MovieClip = null;
         var moveMC:MovieClip = null;
         var uiLoader:Loader = null;
         this._itemData = data;
         if(this._randomPosTableId >= 0 && this._itemData.hasOwnProperty("posId"))
         {
            pos = DigTreasureConfig.instance.GetPosConfig(this._randomPosTableId,this._itemData.posId);
            this._x = pos.@x;
            this._y = pos.@y;
            this._canWalkX = pos.@canWalkX;
            this._canWalkY = pos.@canWalkY;
         }
         this._digCount = this._itemData.digCount;
         if(Boolean(this._uiInMapId) && this._uiInMapId != "")
         {
            mapMC = GV.MC_mapFrame["control_mc"];
            this._itemUI = mapMC[this._uiInMapId];
            moveMC = mapMC["move_" + this._uiInMapId];
            this._canWalkX = moveMC.x;
            this._canWalkY = moveMC.y;
            moveMC.visible = false;
            this._ui.addChild(this._itemUI);
            this._x = this._itemUI.x;
            this._y = this._itemUI.y;
            this._itemUI.x = 0;
            this._itemUI.y = 0;
            this._ui.x = this._x;
            this._ui.y = this._y;
            this.ItemUILoaderOver();
         }
         else
         {
            try
            {
               uiLoader = new Loader();
               BC.addOnceEvent(this,uiLoader.contentLoaderInfo,Event.COMPLETE,this.LoadUIOver);
               uiLoader.load(VL.getURLRequest(this._itemUIUrl));
            }
            catch(e:Error)
            {
               throw new Error("加載錯誤" + _itemUIUrl);
            }
         }
      }
      
      public function UpdateState() : void
      {
      }
      
      public function get addedExp() : int
      {
         return this._addedExp;
      }
      
      public function get canWalkX() : Number
      {
         return this._canWalkX;
      }
      
      public function get canWalkY() : Number
      {
         return this._canWalkY;
      }
      
      public function get digCount() : int
      {
         return this._digCount;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get() : int
      {
         return 0;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function get ui() : Sprite
      {
         return this._ui;
      }
      
      public function get usedHP() : int
      {
         return this._usedHP;
      }
      
      public function get x() : Number
      {
         return this._x;
      }
      
      public function get y() : Number
      {
         return this._y;
      }
      
      public function get state() : int
      {
         return 0;
      }
      
      public function ClearMouseEvent() : void
      {
         this.OnMouseOut();
         BC.removeEvent(this,this._ui,MouseEvent.MOUSE_OVER,this.OnMouseOver);
         BC.removeEvent(this,this._ui,MouseEvent.MOUSE_OUT,this.OnMouseOut);
         BC.removeEvent(this,this._ui,MouseEvent.CLICK,this.OnMouseClick);
      }
      
      protected function InitMouseEvent() : void
      {
         BC.addEvent(this,this._ui,MouseEvent.MOUSE_OVER,this.OnMouseOver);
         BC.addEvent(this,this._ui,MouseEvent.MOUSE_OUT,this.OnMouseOut);
         BC.addEvent(this,this._ui,MouseEvent.CLICK,this.OnMouseClick);
      }
      
      protected function OnMouseClick(e:MouseEvent) : void
      {
         this.OnMouseOut(e);
         if(this._usedHP > 0 && this._dataCtl.hp < this._usedHP)
         {
            this._dataCtl.dispatchEvent(new Event(DigTreasureEvent.HPNotEnough));
         }
         else
         {
            if(LockClick)
            {
               return;
            }
            if(this.IsMoleHitItem())
            {
               this._startDigFun(this);
            }
            else
            {
               this.StopDig();
               moleMoveListner = this;
               BC.addOnceEvent(moleMoveListner,this._mole.avatarClass,PeopleManageView.ON_GO_OVER,this.StartDigItem);
               BC.addOnceEvent(moleMoveListner,this._mole.avatarClass,PeopleManageView.ON_GO_NOPATH,this.StopDig);
               this._mole.moveTo(this._canWalkX,this._canWalkY);
            }
         }
      }
      
      public function IsMoleHitItem() : Boolean
      {
         var bool:Boolean = Boolean(this._mole.avatarMC.Visualize_mc.hitTestPoint(this._canWalkX,this._canWalkY,true));
         if(!bool)
         {
            bool = this._mole.hasDragon && this._mole.dragon.dragonBody.hitTestPoint(this._canWalkX,this._canWalkY,true);
         }
         return bool;
      }
      
      private function StartDigItem(e:Event) : void
      {
         this._startDigFun(this);
      }
      
      private function StopDig(e:Event = null) : void
      {
         BC.removeEvent(moleMoveListner,this._mole.avatarClass);
      }
      
      protected function OnMouseOut(e:MouseEvent = null) : void
      {
         this._itemUI.filters = [];
         Mouse.show();
         this._tipMC.stopDrag();
         this._tipMC.visible = false;
         try
         {
            MainManager.getAppLevel().stage.removeChild(this._tipMC);
         }
         catch(e:Error)
         {
            trace(e);
         }
      }
      
      protected function OnMouseOver(e:MouseEvent) : void
      {
         Mouse.hide();
         this._tipMC.mouseEnabled = false;
         this._tipMC.mouseChildren = false;
         this._tipMC.startDrag();
         this._tipMC.visible = true;
         this._tipMC.x = e.stageX;
         this._tipMC.y = e.stageY;
         MainManager.getAppLevel().stage.addChild(this._tipMC);
         var bevel:GlowFilter = new GlowFilter();
         bevel.color = 16310155;
         bevel.alpha = 1;
         bevel.blurX = 10;
         bevel.blurY = 10;
         bevel.strength = 3;
         bevel.quality = BitmapFilterQuality.LOW;
         bevel.inner = false;
         bevel.knockout = false;
         this._itemUI.filters = [bevel];
      }
      
      protected function ShowAddedExpEffect() : void
      {
         var addExpMC:MovieClip = null;
         var mainPeople:PeopleManageView = null;
         try
         {
            if(this._addedExp > 0)
            {
               addExpMC = DigTreasureConfig.instance.GetMovieClip("addExp_mc");
               addExpMC.tipsTxt.value_txt.text = this._addedExp;
               mainPeople = PeopleManageView(GV.MAN_PEOPLE);
               MainManager.getAppLevel().addChild(addExpMC);
               addExpMC.x = mainPeople.x;
               addExpMC.y = mainPeople.y;
            }
         }
         catch(e:Error)
         {
            trace(e);
         }
      }
      
      protected function ShowAwards(awards:Array) : void
      {
         with({})
         {
            setTimeout(function fun():void
            {
               var award:Object = null;
               var offsetX:Number = NaN;
               var awardMC:DigAwardViewCtl = null;
               var toRight:Boolean = Math.random() > 0.5;
               for each(award in awards)
               {
                  offsetX = 10 + Math.random() * 60;
                  if(toRight)
                  {
                     offsetX = -offsetX;
                  }
                  toRight = !toRight;
                  awardMC = new DigAwardViewCtl(award.id,award.count,new Point(_ui.x,_ui.y),offsetX);
                  MainManager.getAppLevel().addChild(awardMC);
               }
            },this._awardDelay);
         }
         
         protected function ShowEffect() : void
         {
            var effectMC:MovieClip = null;
            try
            {
               effectMC = DigTreasureConfig.instance.GetMovieClip(this._effectName + "_effect");
               MainManager.getAppLevel().addChild(effectMC);
               effectMC.x = this._ui.x;
               with({})
               {
                  
                  setTimeout(function h():void
                  {
                     effectMC.visible = false;
                     GC.clearAll(effectMC);
                  },3000);
               }
               catch(e:Error)
               {
                  trace(e);
               }
            }
            
            protected function PlaySound() : void
            {
               var soundCls:Class = null;
               var soundCtl:soundControl = null;
               try
               {
                  soundCls = DigTreasureConfig.instance.GetClass(this._soundName + "_sound");
                  soundCtl = new soundControl();
                  soundCtl.getSound(soundCls,0,1);
               }
               catch(e:Error)
               {
                  trace(e);
               }
            }
            
            public function set StartDigFun(fun:Function) : void
            {
               this._startDigFun = fun;
            }
            
            public function StartDig(tragger:IDigTreasureItemCtl = null) : void
            {
            }
            
            private function GetRandomPoint(pos:Point) : Point
            {
               var randomAngle:Number = Radian * Math.random();
               var randomDis:Number = CircleRadius * Math.random();
               var randomX:Number = randomDis * Math.cos(randomAngle * Math.PI / 180);
               var randomY:Number = randomDis * Math.sin(randomAngle * Math.PI / 180);
               return new Point(pos.x + randomX,pos.y + randomY);
            }
            
            private function LoadUIOver(e:Event) : void
            {
               var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
               this._itemUI = loaderInfo.content as MovieClip;
               this._itemUI.totalFrames;
               this._itemUI = this._itemUI.getChildAt(0) as MovieClip;
               this._ui.addChild(this._itemUI);
               this._ui.x = this._x;
               this._ui.y = this._y;
               this.ItemUILoaderOver();
            }
            
            protected function ItemUILoaderOver() : void
            {
            }
            
            protected function PlayMoleAction() : void
            {
               var direction:String = null;
               var itemX:Number = NaN;
               var itemY:Number = NaN;
               try
               {
                  MoveTo.CanMove = false;
                  LockClick = true;
                  if(this._actionName == "")
                  {
                     return;
                  }
                  direction = "leftdown";
                  itemX = this._x + this._itemUI.width / 2;
                  itemY = this._y + this._itemUI.height / 2;
                  if(this._mole.x > itemX)
                  {
                     if(this._mole.y > itemY)
                     {
                        direction = "leftup";
                     }
                     else
                     {
                        direction = "leftdown";
                     }
                  }
                  else if(this._mole.y > itemY)
                  {
                     direction = "rightup";
                  }
                  else
                  {
                     direction = "rightdown";
                  }
                  DigTreasureAvatar(this._mole.avatarClass).DelRotation();
                  DigTreasureAvatar(this._mole.avatarClass).stopAction();
                  DigTreasureAvatar(this._mole.avatarClass).showAction(direction + "_" + this._actionName);
               }
               catch(e:Error)
               {
                  trace(e);
               }
            }
            
            protected function ShowUseHpEffect() : void
            {
               var effecMC:MovieClip = null;
               var mainPeople:PeopleManageView = null;
               try
               {
                  if(this.usedHP > 0)
                  {
                     effecMC = DigTreasureConfig.instance.GetMovieClip("num_effect");
                     effecMC.tipsTxt.value_txt.text = "探險精力- " + this.usedHP;
                     mainPeople = PeopleManageView(GV.MAN_PEOPLE);
                     MainManager.getAppLevel().addChild(effecMC);
                     effecMC.x = mainPeople.x;
                     effecMC.y = mainPeople.y;
                  }
               }
               catch(e:Error)
               {
                  trace(e);
               }
            }
            
            protected function PlayDigSound() : void
            {
               var soundUrl:String = null;
               try
               {
                  if(this._soundName != "")
                  {
                     with({})
                     {
                        
                        setTimeout(function h():void
                        {
                           SoundManager.play(soundUrl);
                        },this._soundWaitTime);
                     }
                  }
                  catch(e:Error)
                  {
                     trace(e);
                  }
               }
               
               protected function StopMoleAction() : void
               {
                  try
                  {
                     MoveTo.CanMove = true;
                     LockClick = false;
                     DigTreasureAvatar(this._mole.avatarClass).stopAction("down");
                     DigTreasureAvatar(this._mole.avatarClass).addRotation();
                  }
                  catch(e:Error)
                  {
                     trace(e);
                  }
               }
               
               public function SendDigCmd() : void
               {
                  BC.addEvent(this,GV.onlineSocket,"read_" + DigTreasureSocket.DigAreaCmd,this.DigCmdHandler);
                  DigTreasureSocket.DigArea(this.index);
               }
               
               protected function DigCmdHandler(e:EventTaomee) : void
               {
               }
            }
         }
         
         