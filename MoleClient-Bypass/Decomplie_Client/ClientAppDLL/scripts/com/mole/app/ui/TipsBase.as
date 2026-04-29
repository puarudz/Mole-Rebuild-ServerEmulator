package com.mole.app.ui
{
   import com.common.util.DisplayUtil;
   import com.common.util.Tick;
   import com.core.MainManager;
   import com.core.manager.LevelManager;
   import com.mole.app.manager.TipsManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class TipsBase
   {
      
      private static const EASING:Number = 0.6;
      
      private static const GAP:Number = 10;
      
      protected var _container:DisplayObject;
      
      protected var _tipCon:Sprite;
      
      private var _oldMouseChildren:Boolean = false;
      
      public function TipsBase(container:DisplayObject, autoDel:Boolean)
      {
         super();
         this._container = container;
         if(this._container.hasOwnProperty("mouseChildren"))
         {
            this._oldMouseChildren = this._container["mouseChildren"];
            this._container["mouseChildren"] = false;
         }
         this._tipCon = new Sprite();
         this._tipCon.mouseChildren = false;
         this._tipCon.mouseEnabled = false;
         this._container.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._container.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
         if(autoDel)
         {
            this._container.addEventListener(Event.REMOVED_FROM_STAGE,this.onAutoRemove);
         }
      }
      
      private function onOver(e:MouseEvent) : void
      {
         this._tipCon.x = LevelManager.stage.mouseX;
         this._tipCon.y = LevelManager.stage.mouseY;
         MainManager.tipLevel.addChild(this._tipCon);
         Tick.instance.addCallback(this.onTipMove);
      }
      
      private function onOut(e:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this._tipCon);
         Tick.instance.removeCallback(this.onTipMove);
      }
      
      private function onAutoRemove(e:Event) : void
      {
         TipsManager.remove(this._container);
      }
      
      private function onTipMove(delay:Number) : void
      {
         var targetX:Number = LevelManager.stage.mouseX + GAP;
         var targetY:Number = LevelManager.stage.mouseY + GAP;
         if(targetX + this._tipCon.width > LevelManager.WIDTH)
         {
            targetX -= GAP * 2 + this._tipCon.width;
         }
         if(targetY + this._tipCon.height > LevelManager.HEIGHT)
         {
            targetY -= GAP * 2 + this._tipCon.height;
         }
         this._tipCon.x += (targetX - this._tipCon.x) * EASING;
         this._tipCon.y += (targetY - this._tipCon.y) * EASING;
      }
      
      public function destroy() : void
      {
         this._container.removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._container.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this._container.removeEventListener(Event.REMOVED_FROM_STAGE,this.onAutoRemove);
         Tick.instance.removeCallback(this.onTipMove);
         DisplayUtil.removeForParent(this._tipCon);
         if(this._container.hasOwnProperty("mouseChildren"))
         {
            this._container["mouseChildren"] = this._oldMouseChildren;
         }
      }
   }
}

