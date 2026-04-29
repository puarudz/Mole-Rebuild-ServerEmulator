package com.view.MapManageView
{
   import com.core.manager.IndexManager;
   import com.logic.mapEvent.MapEvent;
   import com.mole.debug.DebugManager;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.utils.Timer;
   import org.taomee.utils.DisplayUtil;
   
   public class TailButtonView extends Sprite
   {
      
      private var _enabled:Boolean = true;
      
      private var _offsetX:int = 0;
      
      private var _offsetY:int = 0;
      
      private var _hide:Boolean = false;
      
      private var _tailTarget:DisplayObject;
      
      private var _tailTimer:Timer;
      
      private var _btn:DisplayObject;
      
      public function TailButtonView(name:* = "mole_hitBtn", _offsetX:int = 0, _offsetY:int = 0)
      {
         super();
         GV.onlineSocket.addEventListener(MapEvent.READY_CHANGE_MAP,this.onReadyChangeMap);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.removeFromStage);
         if(name is String)
         {
            this._btn = IndexManager.getInstance().getMovieClip(name);
         }
         else if(name is DisplayObject)
         {
            this._btn = name;
         }
         if(DebugManager.DEBUG == false)
         {
            this._btn.alpha = 0;
         }
         else
         {
            this._btn.alpha = 0.5;
         }
         this._btn.x = _offsetX;
         this._btn.y = _offsetY;
         addChild(this._btn);
      }
      
      public function simpleTailTarget(mc:DisplayObject) : void
      {
         this._tailTarget = mc;
         GC.clearGInterval(this._tailTimer);
         this._tailTimer = GC.setGInterval(this.tailXY,300);
         var gp:Point = mc.parent.localToGlobal(new Point(0,0));
         this._offsetX = gp.x;
         this._offsetY = gp.y;
      }
      
      public function fineTailTarget(mc:DisplayObject) : void
      {
         this.destroy();
         this._tailTarget = mc;
         BC.addEvent(this,mc,PeopleManageView.ON_GO_START,this.hideTarget);
         BC.addEvent(this,mc,PeopleManageView.ON_GO_OVER,this.showTarget);
         BC.addEvent(this,mc,PeopleManageView.ON_GO_BREAK,this.showTarget);
         var gp:Point = mc.parent.localToGlobal(new Point(0,0));
         this._offsetX = gp.x;
         this._offsetY = gp.y;
      }
      
      public function fineTail2Target(mc:DisplayObjectContainer) : void
      {
         this.destroy();
         this._tailTarget = mc as DisplayObjectContainer;
         BC.addEvent(this,mc,PeopleManageView.ON_GO_ENTERFRAME,this.showTarget);
         BC.addEvent(this,mc,PeopleManageView.ON_GO_BREAK,this.showTarget);
         BC.addEvent(this,mc,PeopleManageView.ON_GO_OVER,this.showTarget);
         var gp:Point = mc.parent.localToGlobal(new Point(0,0));
         this._offsetX = gp.x;
         this._offsetY = gp.y;
      }
      
      public function fineTail3Target(mc:DisplayObjectContainer) : void
      {
         this.destroy();
         this._tailTarget = mc as DisplayObjectContainer;
         BC.addEvent(this,mc,Event.ENTER_FRAME,this.showTarget);
         var gp:Point = mc.parent.localToGlobal(new Point(0,0));
         this._offsetX = gp.x;
         this._offsetY = gp.y;
      }
      
      private function tailXY() : void
      {
         if(!this._tailTarget.parent)
         {
            BC.removeEvent(this,null,Event.ENTER_FRAME,this.showTarget);
            return;
         }
         if(this._hide)
         {
            x = -10000;
            return;
         }
         var gp:Point = this._tailTarget.parent.localToGlobal(new Point(0,0));
         this._offsetX = gp.x;
         this._offsetY = gp.y;
         x = this._tailTarget.x + this._offsetX;
         y = this._tailTarget.y + this._offsetY;
      }
      
      private function hideTarget(E:*) : void
      {
         x = -10000;
      }
      
      public function showTarget(E:* = null) : void
      {
         this.tailXY();
      }
      
      public function set enabled(b:Boolean) : void
      {
         this._enabled = b;
         if(b)
         {
            addChild(this._btn);
         }
         else if(Boolean(this._btn.parent))
         {
            removeChild(this._btn);
         }
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set offsetPoint(posx:Point) : void
      {
         var dp:DisplayObjectContainer = getChildAt(0) as DisplayObjectContainer;
         dp.x = posx.x;
         dp.y = posx.y;
      }
      
      public function get offsetPoint() : Point
      {
         var dp:DisplayObjectContainer = getChildAt(0) as DisplayObjectContainer;
         return new Point(dp.x,dp.y);
      }
      
      public function set hide(b:Boolean) : void
      {
         this._hide = b;
         x = b ? -10000 : -10000;
         if(!this._hide)
         {
            this.tailXY();
         }
      }
      
      public function get hide() : Boolean
      {
         return this._hide;
      }
      
      public function get tailTarget() : DisplayObject
      {
         return this._tailTarget;
      }
      
      private function onReadyChangeMap(e:Event) : void
      {
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.removeFromStage);
         GV.onlineSocket.removeEventListener(MapEvent.READY_CHANGE_MAP,this.onReadyChangeMap);
         DisplayUtil.removeFromParent(this);
      }
      
      private function removeFromStage(evt:Event) : void
      {
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.removeFromStage);
         GV.onlineSocket.removeEventListener(MapEvent.READY_CHANGE_MAP,this.onReadyChangeMap);
      }
      
      public function destroy() : void
      {
         GC.clearGInterval(this._tailTimer);
         BC.removeEvent(this);
      }
   }
}

