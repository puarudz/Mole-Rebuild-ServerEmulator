package com.module.pig.view.pig
{
   import com.common.util.MovieClipUtil;
   import com.core.MainManager;
   import com.logic.FindPathLogic.MoveCondition;
   import com.logic.MapManageLogic.MapDepthManageLogic;
   import com.module.pig.PigEvent;
   import com.module.pig.PigHouseUI;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class MachinistSquarePigView extends Sprite
   {
      
      private static var Wait_Tease_Count:int = 0;
      
      private var _currentAction:String = PigView.Move_Dir_LeftDown;
      
      private var _direct:String = PigView.Move_Dir_LeftDown;
      
      private var _pigPopIcon:MovieClip;
      
      private var _pigUI:MovieClip;
      
      private var _pig:MachinistSquarePig;
      
      private var _data:PigData;
      
      private var _energyMC:MovieClip;
      
      private var _offerX:int;
      
      private var _offerY:int;
      
      private var _oldPoint:Point;
      
      public function MachinistSquarePigView(pig:MachinistSquarePig)
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
         BC.addEvent(this,PigEvent.instance,PigEvent.Get_MachinistSquare_Data_OK,this.ShowEnergy);
         this.Init();
      }
      
      public function Init() : void
      {
         var uiUrl:String = "resource/pig/swf/" + this._data.showId + ".swf";
         var loader:Loader = new Loader();
         BC.addOnceEvent(this,loader.contentLoaderInfo,Event.COMPLETE,this.LoadOverHandler);
         loader.load(VL.getURLRequest(uiUrl));
      }
      
      private function LoadOverHandler(event:Event) : void
      {
         var loaderInfo:LoaderInfo = event.currentTarget as LoaderInfo;
         this._pigUI = loaderInfo.content as MovieClip;
         this._pigUI = this._pigUI.getChildAt(0) as MovieClip;
         this._pigUI.x = this._pigUI.y = 0;
         this.ShowEnergy();
         this.Update();
         this.addChildAt(this._pigUI,0);
         this.PlayAction(this._currentAction);
      }
      
      public function ShowEnergy(event:Event = null) : void
      {
         var len:Number = NaN;
         if(this._energyMC == null)
         {
            this._energyMC = PigHouseUI.instance.GetMovieClip("energy_tag");
         }
         this._energyMC.y = -(this._pigUI.height + 10);
         try
         {
            this._energyMC.exp_txt.text = String(this._data.energy) + "/" + String(this._data.maxEnergy);
            len = this._data.energy / this._data.maxEnergy;
            this._energyMC.mc.width = 95 * len;
            this._pigPopIcon.addChild(this._energyMC);
         }
         catch(e:Error)
         {
         }
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
      }
      
      public function PlayAction(action:String) : void
      {
         this._currentAction = action;
         MovieClipUtil.gotoAndStop(this._pigUI,action);
      }
      
      public function ChangeDir(moveCtl:PigMoveCtl) : void
      {
         var startP:Point = moveCtl.startP;
         var endP:Point = moveCtl.endP;
         if(endP.y > startP.y)
         {
            if(endP.x > startP.x)
            {
               this._direct = PigView.Move_Dir_RightDown;
               this.PlayAction(PigView.Move_Dir_RightDown);
            }
            else
            {
               this._direct = PigView.Move_Dir_LeftDown;
               this.PlayAction(PigView.Move_Dir_LeftDown);
            }
         }
         else if(endP.x > startP.x)
         {
            this._direct = PigView.Move_Dir_RightUp;
            this.PlayAction(PigView.Move_Dir_RightUp);
         }
         else
         {
            this._direct = PigView.Move_Dir_LeftUp;
            this.PlayAction(PigView.Move_Dir_LeftUp);
         }
      }
      
      public function PlayWaitAction() : void
      {
         this.PlayAction("待機" + this._direct);
      }
      
      public function PlayHunger() : void
      {
         this.PlayAction(PigView.Hunger);
      }
      
      public function PlayRandomHappy() : void
      {
         var tpye:int = int(Math.random() * 100) % 3 + 1;
         this.PlayAction("開心" + tpye);
      }
      
      public function SetPigToTopLevel() : void
      {
         GV.MC_mapFrame["top_mc"].addChild(this);
      }
      
      public function SetPigToDepthLevel() : void
      {
         GV.MC_mapFrame["depth_mc"].addChild(this);
      }
      
      public function SetOfforPoint() : void
      {
         this._oldPoint = new Point(this.x,this.y);
         this._offerX = MainManager.getStage().mouseX - this.x;
         this._offerY = MainManager.getStage().mouseY - this.y;
      }
      
      public function MovePigByMouse(point:Point) : void
      {
         this.x = point.x - this._offerX;
         this.y = point.y - this._offerY;
      }
      
      public function StopMovePigByMouse(point:Point) : void
      {
         if(MoveCondition.hasRoad(point.x,point.y))
         {
            this.x = point.x - this._offerX;
            this.y = point.y - this._offerY;
         }
         else
         {
            this.x = this._oldPoint.x;
            this.y = this._oldPoint.y;
         }
         this._oldPoint = null;
         this._offerX = 0;
         this._offerY = 0;
      }
      
      private function handler(e:*) : void
      {
         var f:Function = e.EventObj as Function;
         f([this]);
      }
      
      public function Clear() : void
      {
         BC.removeEvent(this);
         GC.clearAll(this);
         Wait_Tease_Count = 0;
      }
      
      public function get pigUI() : MovieClip
      {
         return this._pigUI;
      }
   }
}

