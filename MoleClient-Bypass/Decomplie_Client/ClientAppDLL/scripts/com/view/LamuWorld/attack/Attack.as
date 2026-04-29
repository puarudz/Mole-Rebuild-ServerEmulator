package com.view.LamuWorld.attack
{
   import com.view.LamuWorld.ABoss;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class Attack implements IAttack
   {
      
      protected var _boss:ABoss;
      
      protected var bossMC:MovieClip;
      
      protected var _target:IAttackTarget;
      
      public function Attack()
      {
         super();
      }
      
      public function start() : void
      {
         this.bossMC.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.bossMC.addEventListener(Event.REMOVED_FROM_STAGE,this.removed);
      }
      
      protected function removed(e:Event = null) : void
      {
         this.bossMC.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.bossMC.removeEventListener(Event.REMOVED_FROM_STAGE,this.removed);
         this.bossMC = null;
         this._boss = null;
         this._target = null;
      }
      
      public function end() : void
      {
         this.removed();
      }
      
      protected function onEnterFrame(e:*) : void
      {
      }
      
      public function hurt() : void
      {
         this.target.behurt();
      }
      
      public function checkhurt() : void
      {
      }
      
      public function set boss(b:ABoss) : void
      {
         this._boss = b;
         this.bossMC = this._boss.boss;
      }
      
      public function set target(t:IAttackTarget) : void
      {
         this._target = t;
      }
      
      public function get target() : IAttackTarget
      {
         return this._target;
      }
   }
}

