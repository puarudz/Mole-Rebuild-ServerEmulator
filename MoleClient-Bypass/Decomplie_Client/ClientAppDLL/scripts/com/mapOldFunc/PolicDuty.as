package com.mapOldFunc
{
   import com.event.EventTaomee;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class PolicDuty
   {
      
      public var mapid:uint;
      
      public var click_btnName:String;
      
      public var click_btn:DisplayObject;
      
      public var owner:PolicDuty;
      
      public function PolicDuty()
      {
         super();
      }
      
      public function init() : void
      {
         this.owner = this;
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeEventToStaget);
         if(this.click_btn is MovieClip)
         {
            MovieClip(this.click_btn).buttonMode = true;
         }
         this.click_btn.addEventListener(MouseEvent.CLICK,this.goHere);
      }
      
      public function goHere(E:*) : void
      {
         if(!GV.MoveTo_Class.CanMove)
         {
            return;
         }
         var bool:Boolean = this.testHitTest();
         if(bool)
         {
            this.gotoChangeMap();
         }
         else
         {
            GV.MoveTo_Class["AutoFind"](this.click_btn.x,this.click_btn.y,GV["MAN_PEOPLE"]);
            try
            {
               GV.MAN_PEOPLE.avatarClass.addEventListener("onGoOver",this.changeMap);
            }
            catch(E:*)
            {
            }
         }
      }
      
      public function changeMap(E:* = null) : void
      {
         var mypoint:Point = new Point(GV.MAN_PEOPLE.x,GV.MAN_PEOPLE.y);
         mypoint = GV.MAN_PEOPLE.parent.localToGlobal(mypoint);
         if(this.click_btn.hitTestPoint(mypoint.x,mypoint.y,false))
         {
            this.gotoChangeMap();
         }
      }
      
      public function testHitTest() : Boolean
      {
         var mypoint:Point = new Point(GV.MAN_PEOPLE.x,GV.MAN_PEOPLE.y);
         mypoint = GV.MAN_PEOPLE.parent.localToGlobal(mypoint);
         if(this.click_btn.hitTestPoint(mypoint.x,mypoint.y,true))
         {
            return true;
         }
         return false;
      }
      
      public function gotoChangeMap() : void
      {
         try
         {
            GV.MAN_PEOPLE.avatarClass.removeEventListener("onGoOver",this.changeMap);
         }
         catch(E:*)
         {
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("POLICE_DUTY_EVENT",{"mc":this.click_btn}));
      }
      
      private function removeEventToStaget(evt:Event) : void
      {
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeEventToStaget);
         if(Boolean(this.click_btn))
         {
            this.click_btn.removeEventListener(MouseEvent.CLICK,this.goHere);
         }
         try
         {
            GV.MAN_PEOPLE.avatarClass.removeEventListener("onGoOver",this.changeMap);
         }
         catch(E:*)
         {
         }
      }
   }
}

