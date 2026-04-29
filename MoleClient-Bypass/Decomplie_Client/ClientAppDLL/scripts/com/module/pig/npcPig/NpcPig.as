package com.module.pig.npcPig
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.tip.tip;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.MapManageLogic.MapDepthManageLogic;
   import com.module.pig.view.pig.PigActionCtl;
   import com.module.pig.view.pig.PigMoveCtl;
   import com.module.pig.view.pig.PigView;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class NpcPig
   {
      
      private var _ui:MovieClip;
      
      private var _pigActionCtl:PigActionCtl;
      
      private var _pigMoveCtl:PigMoveCtl;
      
      private var _direct:String = PigView.Move_Dir_LeftDown;
      
      private var _itemId:int = 0;
      
      public function NpcPig(pigItemId:int)
      {
         super();
         this._itemId = pigItemId;
         var uiUrl:String = "resource/pig/swf/" + this._itemId + ".swf";
         var loader:Loader = new Loader();
         BC.addOnceEvent(this,loader.contentLoaderInfo,Event.COMPLETE,this.LoadOverHandler);
         loader.load(VL.getURLRequest(uiUrl));
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.Clear);
      }
      
      private function Clear(e:Event) : void
      {
         BC.removeEvent(this);
         this._pigMoveCtl.stopToHere();
         this._pigActionCtl.RemoveAllAction();
         GC.clearAll(this._ui);
      }
      
      private function LoadOverHandler(e:Event) : void
      {
         var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
         this._ui = loaderInfo.content as MovieClip;
         this._ui = this._ui.getChildAt(0) as MovieClip;
         this._ui.scaleY = this._ui.scaleX = 0.9;
         GV.MC_mapFrame["depth_mc"].addChild(this._ui);
         BC.addEvent(this,MapDepthManageLogic.owner,MapDepthManageLogic.ADD_ARRAY,this.handler);
         tip.tipTailDisPlayObject(this._ui,GoodsInfo.getItemNameByID(this._itemId));
         this._pigMoveCtl = new PigMoveCtl(this._ui);
         this._pigMoveCtl.changeDirFuns.add(this.ChangeDir,true);
         this._pigMoveCtl.stopMoveFuns.add(this.MoveOver,true);
         this._pigActionCtl = new PigActionCtl();
         this._pigActionCtl.endFun = this.TryRandomMove;
         var randomPoint:Point = MoveTo.getRandomFloorPoint();
         this._ui.x = randomPoint.x;
         this._ui.y = randomPoint.y;
         this.TryRandomMove();
      }
      
      private function TryRandomMove() : void
      {
         if(Math.random() > 0.8)
         {
            this._pigActionCtl.AddAction(this.RandomMove);
         }
         else if(Math.random() > 0.95)
         {
            this._pigActionCtl.AddAction(this.PlayRandomHappy,2500);
         }
         else
         {
            this._pigActionCtl.AddAction(this.PlayWaitAction,4000);
         }
         this._pigActionCtl.Play();
      }
      
      private function RandomMove() : void
      {
         var endPoint:Point = MoveTo.getRandomFloorPoint();
         this._pigMoveCtl.MoveTo(this._ui.x,this._ui.y,endPoint.x,endPoint.y);
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
      
      public function PlayAction(action:String) : void
      {
         this._ui.gotoAndStop(action);
      }
      
      private function MoveOver(moveCtl:PigMoveCtl) : void
      {
         this.PlayWaitAction();
         this._pigActionCtl.Play();
      }
      
      public function PlayWaitAction() : void
      {
         this.PlayAction("待机" + this._direct);
      }
      
      public function PlayRandomHappy() : void
      {
         var tpye:int = int(Math.random() * 100) % 3 + 1;
         this.PlayAction("开心" + tpye);
      }
      
      private function handler(e:*) : void
      {
         var f:Function = e.EventObj as Function;
         f([this._ui]);
      }
   }
}

