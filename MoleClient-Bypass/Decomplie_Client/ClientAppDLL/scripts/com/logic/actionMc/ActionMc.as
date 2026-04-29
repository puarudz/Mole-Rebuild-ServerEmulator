package com.logic.actionMc
{
   import com.common.util.DisplayUtil;
   import com.core.MainManager;
   import com.core.manager.UIManager;
   import com.logic.mapEvent.MapEvent;
   import com.logic.socket.action.ActionReq;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class ActionMc
   {
      
      private static var _inst:ActionMc;
      
      private var bigMc:MovieClip;
      
      private var actionReq:ActionReq;
      
      public function ActionMc()
      {
         super();
         this.actionReq = new ActionReq();
         this.bigMc = UIManager.getMovieClip("action_mc");
         this.bigMc.x = 520;
         this.bigMc.y = 221;
         BC.addEvent(this,this.bigMc.dance_mc,MouseEvent.ROLL_OVER,this.onDisOver);
         BC.addEvent(this,this.bigMc.dance_mc,MouseEvent.ROLL_OUT,this.onDisOut);
         BC.addEvent(this,this.bigMc.dance_mc,MouseEvent.CLICK,this.onDance);
         BC.addEvent(this,this.bigMc.wave_mc,MouseEvent.ROLL_OVER,this.onDisOver);
         BC.addEvent(this,this.bigMc.wave_mc,MouseEvent.ROLL_OUT,this.onDisOut);
         BC.addEvent(this,this.bigMc.wave_mc,MouseEvent.CLICK,this.onWave);
         BC.addEvent(this,this.bigMc.an1,MouseEvent.CLICK,this.sitDownBtn1Over);
         BC.addEvent(this,this.bigMc.an2,MouseEvent.CLICK,this.sitDownBtn2Over);
         BC.addEvent(this,this.bigMc.an3,MouseEvent.CLICK,this.sitDownBtn3Over);
         BC.addEvent(this,this.bigMc.an4,MouseEvent.CLICK,this.sitDownBtn4Over);
         BC.addEvent(this,this.bigMc.an5,MouseEvent.CLICK,this.sitDownBtn5Over);
         BC.addEvent(this,this.bigMc.an6,MouseEvent.CLICK,this.sitDownBtn6Over);
         BC.addEvent(this,this.bigMc.an7,MouseEvent.CLICK,this.sitDownBtn7Over);
         BC.addEvent(this,this.bigMc.an8,MouseEvent.CLICK,this.sitDownBtn8Over);
      }
      
      public static function get inst() : ActionMc
      {
         if(_inst == null)
         {
            _inst = new ActionMc();
         }
         return _inst;
      }
      
      public function show() : void
      {
         MainManager.getAppLevel().addChild(this.bigMc);
         this.bigMc.addEventListener(MouseEvent.ROLL_OUT,this.onRemove);
         GV.onlineSocket.addEventListener(MapEvent.READY_CHANGE_MAP,this.onRemove);
      }
      
      public function hide() : void
      {
         DisplayUtil.removeForParent(this.bigMc,false);
         this.bigMc.removeEventListener(MouseEvent.ROLL_OUT,this.onRemove);
         GV.onlineSocket.removeEventListener(MapEvent.READY_CHANGE_MAP,this.onRemove);
      }
      
      protected function onDisOver(e:MouseEvent) : void
      {
         var tar_mc:MovieClip = e.currentTarget as MovieClip;
         tar_mc.gotoAndStop(2);
      }
      
      protected function onDisOut(e:MouseEvent) : void
      {
         var tar_mc:MovieClip = e.currentTarget as MovieClip;
         tar_mc.gotoAndStop(1);
      }
      
      private function onDance(e:MouseEvent) : void
      {
         this.hide();
         if(Boolean(GV.MAN_PEOPLE.dance()))
         {
            this.actionReq.actions(1,0);
         }
      }
      
      private function onWave(e:MouseEvent) : void
      {
         this.hide();
         if(Boolean(GV.MAN_PEOPLE.wave()))
         {
            this.actionReq.actions(2,0);
         }
      }
      
      private function onRemove(event:MouseEvent) : void
      {
         this.hide();
      }
      
      private function sitDownBtn1Over(event:MouseEvent) : void
      {
         this.sitDownEvent(3,event.target.parent);
      }
      
      private function sitDownEvent(_d:int, _event:DisplayObject) : void
      {
         MainManager.getAppLevel().removeChild(_event);
         if(Boolean(GV.MAN_PEOPLE.sitDown(_d)))
         {
            this.actionReq.actions(3,_d);
         }
      }
      
      private function sitDownBtn2Over(event:MouseEvent) : void
      {
         this.sitDownEvent(4,event.target.parent);
      }
      
      private function sitDownBtn3Over(event:MouseEvent) : void
      {
         this.sitDownEvent(5,event.target.parent);
      }
      
      private function sitDownBtn4Over(event:MouseEvent) : void
      {
         this.sitDownEvent(2,event.target.parent);
      }
      
      private function sitDownBtn5Over(event:MouseEvent) : void
      {
         this.sitDownEvent(1,event.target.parent);
      }
      
      private function sitDownBtn6Over(event:MouseEvent) : void
      {
         this.sitDownEvent(0,event.target.parent);
      }
      
      private function sitDownBtn7Over(event:MouseEvent) : void
      {
         this.sitDownEvent(7,event.target.parent);
      }
      
      private function sitDownBtn8Over(event:MouseEvent) : void
      {
         this.sitDownEvent(6,event.target.parent);
      }
   }
}

