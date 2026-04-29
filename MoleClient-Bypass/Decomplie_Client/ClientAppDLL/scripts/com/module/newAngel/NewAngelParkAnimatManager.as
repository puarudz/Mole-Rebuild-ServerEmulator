package com.module.newAngel
{
   import com.logic.MapManageLogic.MapDepthManageLogic;
   import com.module.newAngel.info.AngelInfo;
   import com.mole.app.manager.ModuleManager;
   import com.view.MapManageView.MapManageView;
   import com.view.PeopleView.NewAngelModel;
   import com.view.player.PlayerActionConstant;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.utils.Tick;
   
   public class NewAngelParkAnimatManager
   {
      
      private static const LEFT_TOP_POINT:Point = new Point(176,192);
      
      private static const RIGHT_BOTTOM_POINT:Point = new Point(723,432);
      
      private static const MOVE_SPEED:uint = 1;
      
      private static const STAND_TIME:Number = 3000;
      
      private static const RUN_TIME:Number = 8000;
      
      private var _inParkAngel:Vector.<NewAngelModel>;
      
      private var _angelKeepTime:Object;
      
      public function NewAngelParkAnimatManager()
      {
         super();
         this._angelKeepTime = new Object();
      }
      
      public function initNewAngel(inParkAngel:Vector.<NewAngelModel>) : void
      {
         var angelPlayer:NewAngelModel = null;
         this._inParkAngel = inParkAngel;
         for each(angelPlayer in this._inParkAngel)
         {
            this.initAngel(angelPlayer);
         }
         Tick.instance.addRender(this.renderHandler);
      }
      
      private function initAngel(angelPlayer:NewAngelModel) : void
      {
         var fun:Function = function(evt:*):void
         {
            var f:Function = evt.EventObj as Function;
            f([angelPlayer]);
         };
         BC.addEvent(this,MapDepthManageLogic.owner,MapDepthManageLogic.ADD_ARRAY,fun);
         angelPlayer.x = LEFT_TOP_POINT.x + Math.random() * (RIGHT_BOTTOM_POINT.x - LEFT_TOP_POINT.x);
         angelPlayer.y = LEFT_TOP_POINT.y + Math.random() * (RIGHT_BOTTOM_POINT.y - LEFT_TOP_POINT.y);
         this.getNextAction(angelPlayer,Math.random() < 0.5);
         angelPlayer.buttonMode = true;
         angelPlayer.addEventListener(MouseEvent.CLICK,this.selectAngel);
      }
      
      public function addAngel(angelPlayer:NewAngelModel) : void
      {
         this.initAngel(angelPlayer);
      }
      
      public function removeAngel(angelId:uint) : void
      {
         for(var ix:int = 0; ix < this._inParkAngel.length; ix++)
         {
            if(this._inParkAngel[ix].angelInfo.id == angelId)
            {
               MapManageView.inst.mapLevel.depthLevel.removeChild(this._inParkAngel[ix]);
               this._inParkAngel.splice(ix,1);
               delete this._angelKeepTime[angelId];
               return;
            }
         }
      }
      
      private function renderHandler(... ret) : void
      {
         var angelPlayer:NewAngelModel = null;
         for each(angelPlayer in this._inParkAngel)
         {
            this.checkScope(angelPlayer);
         }
      }
      
      private function checkScope(angelPlayer:NewAngelModel) : void
      {
         var curPoint:Point = null;
         if(this._angelKeepTime.hasOwnProperty(angelPlayer.angelInfo.id))
         {
            this._angelKeepTime[angelPlayer.angelInfo.id] -= 33;
            if(this._angelKeepTime[angelPlayer.angelInfo.id] >= 0)
            {
               if(angelPlayer.curAction == PlayerActionConstant.ACTION_RUN)
               {
                  curPoint = new Point(angelPlayer.x,angelPlayer.y);
                  curPoint = curPoint.add(this.getNextPointWithDir(angelPlayer.curDir));
                  if(curPoint.x > LEFT_TOP_POINT.x && curPoint.x < RIGHT_BOTTOM_POINT.x && curPoint.y > LEFT_TOP_POINT.y && curPoint.y < RIGHT_BOTTOM_POINT.y)
                  {
                     angelPlayer.x = curPoint.x;
                     angelPlayer.y = curPoint.y;
                  }
                  else
                  {
                     this.getNextAction(angelPlayer,true);
                  }
               }
            }
            else
            {
               this.getNextAction(angelPlayer,false,true);
            }
         }
         else
         {
            this.getNextAction(angelPlayer);
         }
      }
      
      private function getNextAction(angelPlayer:NewAngelModel, stand:Boolean = false, changeDir:Boolean = false) : void
      {
         if(stand)
         {
            angelPlayer.doAction(PlayerActionConstant.ACTION_STAND,Math.floor(Math.random() * 8));
            this._angelKeepTime[angelPlayer.angelInfo.id] = STAND_TIME + Math.random() * STAND_TIME;
            return;
         }
         if(changeDir)
         {
            angelPlayer.doAction(PlayerActionConstant.ACTION_RUN,(angelPlayer.curDir - Math.floor(Math.random() * 3) + 8) % 8);
            this._angelKeepTime[angelPlayer.angelInfo.id] = RUN_TIME + Math.random() * RUN_TIME;
            return;
         }
         if(angelPlayer.curAction == PlayerActionConstant.ACTION_STAND)
         {
            angelPlayer.doAction(PlayerActionConstant.ACTION_RUN,Math.floor(Math.random() * 8));
            this._angelKeepTime[angelPlayer.angelInfo.id] = RUN_TIME + Math.random() * RUN_TIME;
         }
         else
         {
            angelPlayer.doAction(PlayerActionConstant.ACTION_STAND,angelPlayer.curDir);
            this._angelKeepTime[angelPlayer.angelInfo.id] = STAND_TIME + Math.random() * STAND_TIME;
         }
      }
      
      private function getNextPointWithDir(dir:uint) : Point
      {
         var point:Point = null;
         switch(dir)
         {
            case 0:
               point = new Point(0,MOVE_SPEED);
               break;
            case 1:
               point = new Point(-MOVE_SPEED,MOVE_SPEED);
               break;
            case 2:
               point = new Point(-MOVE_SPEED,0);
               break;
            case 3:
               point = new Point(-MOVE_SPEED,-MOVE_SPEED);
               break;
            case 4:
               point = new Point(0,-MOVE_SPEED);
               break;
            case 5:
               point = new Point(MOVE_SPEED,-MOVE_SPEED);
               break;
            case 6:
               point = new Point(MOVE_SPEED,0);
               break;
            case 7:
               point = new Point(MOVE_SPEED,MOVE_SPEED);
         }
         return point;
      }
      
      private function selectAngel(evt:MouseEvent) : void
      {
         var curSelAngel:AngelInfo = NewAngelModel(evt.currentTarget).angelInfo;
         ModuleManager.openPanel("NewAngelGetBackPanel",{
            "angelInfo":curSelAngel,
            "startTime":NewAngelManager.instance.inParkAngelStartTimeMap.getValue(curSelAngel.id)
         });
      }
      
      public function destroy() : void
      {
         Tick.instance.removeRender(this.renderHandler);
         BC.removeEvent(this);
         this._angelKeepTime = null;
         this._inParkAngel = null;
      }
   }
}

