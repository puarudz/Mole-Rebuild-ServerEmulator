package com.view.LamuWorld
{
   import com.view.LamuWorld.attack.IAttackTarget;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.utils.Timer;
   
   public class ABoss implements IAttackTarget
   {
      
      protected var _boss:MovieClip;
      
      public var bossTimer:Timer;
      
      protected var currentTime:int;
      
      protected var attackTime:int = 30;
      
      protected var _target:IAttackTarget;
      
      private var points:Array;
      
      public var bossLive:BossLive;
      
      public var scene:*;
      
      public var isbehurt:Boolean = false;
      
      public function ABoss(boss:*)
      {
         super();
         this.currentTime = 0;
         this.boss = boss as MovieClip;
         BC.addEvent(this,boss,Event.REMOVED_FROM_STAGE,this.removed);
         this.points = [new Point(0,-36),new Point(15,-14),new Point(7,0),new Point(-7,0),new Point(-15,12)];
      }
      
      public function set lives(val:int) : void
      {
         this.bossLive.live = val;
      }
      
      public function get lives() : int
      {
         return this.bossLive.live;
      }
      
      public function get x() : Number
      {
         return 0;
      }
      
      public function get y() : Number
      {
         return 0;
      }
      
      public function get width() : Number
      {
         return 0;
      }
      
      public function get height() : Number
      {
         return 0;
      }
      
      public function get boss() : MovieClip
      {
         return this._boss;
      }
      
      public function set boss(mc:MovieClip) : void
      {
         this._boss = mc;
      }
      
      public function set target(at:IAttackTarget) : void
      {
         this._target = at;
      }
      
      public function get target() : IAttackTarget
      {
         return this._target;
      }
      
      public function attack() : void
      {
      }
      
      public function initBossLive(mc:Sprite) : void
      {
         this.bossLive = new BossLive(mc);
         this.bossLive.live = 5;
      }
      
      public function hideBossLive(mc:Sprite) : void
      {
         this.bossLive.visible = false;
      }
      
      public function dead() : void
      {
         this.removed();
         if(this._boss.currentLabel != "昏倒")
         {
            this._boss.gotoAndPlay("昏倒");
         }
      }
      
      public function isLive() : Boolean
      {
         return this.bossLive.live != 0;
      }
      
      protected function removed(e:Event = null) : void
      {
         BC.removeEvent(this);
         GC.clearGInterval(this.bossTimer);
         this.scene = null;
      }
      
      protected function onEnterFrame(e:Event) : void
      {
      }
      
      public function behurt(value:Number = 1) : Object
      {
         this.bossLive.subLive();
         this._boss.gotoAndPlay("被攻击");
         this.currentTime = 2;
         this.isbehurt = true;
         return null;
      }
      
      public function setNormal() : void
      {
      }
      
      public function init() : void
      {
         this.bossTimer = GC.setGInterval(this.bossAI,1000);
      }
      
      protected function bossAI() : void
      {
         ++this.currentTime;
      }
      
      protected function hitTest(spr:Sprite, _shapeFlag:Boolean = true) : Boolean
      {
         var point:Point = null;
         var flag:Boolean = false;
         if(spr == null)
         {
            return false;
         }
         for(var i:int = 0; i < this.points.length; i++)
         {
            point = new Point(this._target.x,this._target.y);
            flag = spr.hitTestPoint(point.x,point.y,_shapeFlag);
            if(flag)
            {
               return true;
            }
         }
         return false;
      }
   }
}

