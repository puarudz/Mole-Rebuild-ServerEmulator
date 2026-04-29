package com.module.duck
{
   import com.module.activityModule.Presented;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   
   public class BlackLahm
   {
      
      public static var clothMC:*;
      
      public static const Black_Lahm_Hit_Mole:String = "Black_Lahm_Hit_Mole";
      
      public var Lahm:MovieClip;
      
      public var Distance:Number = 100;
      
      public var followBool:Boolean;
      
      public var spd:uint;
      
      public var TimeID:uint;
      
      public var FreezeBool:Boolean;
      
      public var FaintBool:Boolean;
      
      public var appleclass:*;
      
      public var clothUI:*;
      
      public var XY:Array = [];
      
      private var up_timer:Timer;
      
      public function BlackLahm(mc:MovieClip)
      {
         super();
         this.spd = 3;
         this.Lahm = mc;
         this.up_timer = GC.setGTimeout(this.beginPetFun,2000);
         BC.addEvent(this,this.Lahm,"Black_Lahm_Freezed",this.freeze);
         BC.addEvent(this,this.Lahm,"Black_Lahm_Unfreeze",this.unfreeze);
         BC.addEvent(this,this.Lahm,"Black_Lahm_follow",this.follow);
         BC.addEvent(this,this.Lahm,"Black_Lahm_faint",this.faint);
         BC.addEvent(this,this.Lahm,"Black_Lahm_unfaint",this.unfaint);
         BC.addEvent(this,this.Lahm,MouseEvent.CLICK,this.catchLahm);
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         BC.addEvent(this,GV.onlineSocket,"end_catch_show_mole",this.showMole);
      }
      
      public static function getAngle(p1:Point, p2:Point) : Number
      {
         var xx:Number = p2.x - p1.x;
         var yy:Number = p2.y - p1.y;
         var hyp:Number = Point.distance(p1,p2);
         var cos:Number = xx / hyp;
         var rad:Number = Math.acos(cos);
         var deg:Number = 180 / (Math.PI / rad);
         if(yy < 0)
         {
            deg = 360 - deg;
         }
         else if(yy == 0 && xx < 0)
         {
            deg = 180;
         }
         return deg;
      }
      
      public static function getRadian(p1:Point, p2:Point) : Number
      {
         var xx:Number = p2.x - p1.x;
         var yy:Number = p2.y - p1.y;
         var hyp:Number = Point.distance(p1,p2);
         var cos:Number = xx / hyp;
         return Math.acos(cos);
      }
      
      public function getMC() : MovieClip
      {
         return this.Lahm;
      }
      
      public function beginPetFun() : void
      {
         GC.clearGTimeout(this.up_timer);
         this.up_timer = null;
         this.Lahm.gotoAndStop(23 + uint(Math.random() * 6));
      }
      
      public function beginMoveMC(xx:uint, yy:uint) : void
      {
         this.XY = [xx,yy];
         BC.addEvent(this,this.Lahm,Event.ENTER_FRAME,this.followMole);
      }
      
      public function showMole(e:*) : void
      {
         GV.MAN_PEOPLE.visible = true;
      }
      
      public function catchLahm(e:MouseEvent) : void
      {
         if(this.clothRight())
         {
            if(!clothMC)
            {
               this.clothUI = GV.Lib_Map.getClass("cloth_ui");
               clothMC = new this.clothUI();
               this.Lahm.parent.addChild(clothMC);
            }
            clothMC.x = GV.MAN_PEOPLE.x;
            clothMC.y = GV.MAN_PEOPLE.y;
            if(GV.MAN_PEOPLE.x > this.Lahm.x)
            {
               clothMC.gotoAndStop(int(Math.random() * 2) + 1);
            }
            else
            {
               clothMC.gotoAndStop(int(Math.random() * 2) + 3);
            }
            GV.MAN_PEOPLE.visible = false;
            if(Math.random() > 0.9)
            {
               if(Point.distance(new Point(GV.MAN_PEOPLE.x,GV.MAN_PEOPLE.y),new Point(this.Lahm.x,this.Lahm.y)) < 100)
               {
                  BC.removeEvent(this,this.Lahm,MouseEvent.CLICK,this.catchLahm);
                  Presented.getInstance().FreeReceive(10);
                  this.Lahm.gotoAndStop(20);
               }
               else
               {
                  trace("離太遠");
                  this.Lahm.gotoAndStop(21);
               }
            }
            else
            {
               this.Lahm.gotoAndStop(21);
               trace("運氣不好");
            }
         }
         else
         {
            trace("沒穿好衣服");
         }
      }
      
      public function clothRight() : Boolean
      {
         if(Boolean(GV.JobLogics.chartbagClothFun([[12739,12740,12741]])))
         {
            return true;
         }
         return false;
      }
      
      public function faint(e:*) : void
      {
         this.FaintBool = true;
      }
      
      public function unfaint(e:*) : void
      {
         this.FaintBool = false;
      }
      
      public function follow(e:*) : void
      {
         this.followBool = true;
      }
      
      public function unfreeze(e:*) : void
      {
         this.FreezeBool = false;
         this.FaintBool = false;
      }
      
      public function freeze(e:*) : void
      {
         this.FreezeBool = true;
      }
      
      public function removeEventHandler(e:*) : void
      {
         GV.MAN_PEOPLE.visible = true;
         clothMC = null;
         BC.removeEvent(this);
         if(Boolean(this.up_timer))
         {
            GC.clearGTimeout(this.up_timer);
            this.up_timer = null;
         }
      }
      
      public function followMole(e:Event) : void
      {
         var ang:Number = NaN;
         var r:Number = NaN;
         var movey:Number = NaN;
         var movex:Number = NaN;
         var petAng:Number = NaN;
         if(this.FaintBool)
         {
            return;
         }
         if(this.FreezeBool)
         {
            return;
         }
         var mp:Point = new Point(this.XY[0],this.XY[1]);
         var lp:Point = new Point(this.Lahm.x,this.Lahm.y);
         var dis:Number = Point.distance(mp,lp);
         if(this.Lahm.currentFrame != 2 && !this.followBool)
         {
            this.Lahm.gotoAndStop(2);
            return;
         }
         if(this.followBool)
         {
            ang = getAngle(lp,mp);
            r = Math.PI * ang / 180;
            movey = Math.sin(r) * this.spd;
            movex = Math.cos(r) * this.spd;
            petAng = int(ang / 45) + 5;
            if(this.Lahm.currentFrame != petAng && ang != 0)
            {
               this.Lahm.gotoAndStop(petAng);
            }
            if(ang > 180)
            {
               movey = -Math.abs(movey);
            }
            this.Lahm.x += movex;
            this.Lahm.y += movey;
            if(dis < 5)
            {
               BC.removeEvent(this,this.Lahm,Event.ENTER_FRAME,this.followMole);
               this.followBool = false;
               GV.onlineSocket.dispatchEvent(new Event(Black_Lahm_Hit_Mole));
            }
         }
      }
      
      private function randomEvent() : void
      {
         var num:int = Math.floor(Math.random() * 10);
         if(num < 5)
         {
            Presented.getInstance().FreeReceive();
         }
      }
   }
}

