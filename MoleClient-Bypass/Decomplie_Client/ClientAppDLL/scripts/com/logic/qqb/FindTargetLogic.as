package com.logic.qqb
{
   import com.logic.FindPathLogic.MoveTo;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   
   public class FindTargetLogic extends EventDispatcher
   {
      
      private static var point:Point;
      
      public static const ARRIVE_TARGET:String = "arriveTarget";
      
      public function FindTargetLogic()
      {
         super();
      }
      
      public function goHere(mc:Sprite, p:Point) : void
      {
         point = p;
         MoveTo.AutoFind(p.x,p.y,GV.MAN_PEOPLE);
         GV.MAN_PEOPLE.avatarClass.addEventListener("onGoOver",this.goOverHandler);
      }
      
      private function goOverHandler(event:Event) : void
      {
         if(Boolean(GV.MAN_PEOPLE.hitTestPoint(point.x,point.y,true)))
         {
            dispatchEvent(new Event(ARRIVE_TARGET));
         }
         this.removeHandler();
      }
      
      public function removeHandler() : void
      {
         if(Boolean(GV.MAN_PEOPLE.avatarClass))
         {
            GV.MAN_PEOPLE.avatarClass.removeEventListener("onGoOver",this.goOverHandler);
         }
      }
   }
}

