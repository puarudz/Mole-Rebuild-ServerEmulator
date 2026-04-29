package com.module.throwThing
{
   import com.core.manager.UIManager;
   import com.logic.MapManageLogic.MapModelLogic;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.utils.Timer;
   
   public class throwThing
   {
      
      private var throwTimer:Timer;
      
      public function throwThing()
      {
         super();
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.clearThrow);
      }
      
      public function getThingMC() : MovieClip
      {
         var tempMC:* = undefined;
         var tempMC2:* = undefined;
         var tempLoader:MovieClip = null;
         tempMC = new MovieClip();
         tempMC2 = new MovieClip();
         tempMC2.name = "loaderMC";
         GC.clearGTimeout(this.throwTimer);
         this.throwTimer = GC.setGTimeout(function():void
         {
            tempLoader = UIManager.getMovieClip("swf" + tempMC.Throw_selected);
            tempMC.addChild(tempMC2);
            tempMC2.addChild(tempLoader);
            tempMC.useProp = function():void
            {
               var lp:* = undefined;
               var gp:* = undefined;
               var p1:* = undefined;
               var p3:* = undefined;
               var temp:* = undefined;
               var pm:* = GF.getPeopleByID(tempMC.userID) as PeopleManageView;
               if(Boolean(pm))
               {
                  lp = new Point(pm.x,pm.y);
                  gp = pm.parent.localToGlobal(lp);
                  p1 = new Point(gp.x,gp.y);
                  p3 = new Point(tempMC.targetX,tempMC.targetY);
                  temp = new throwThingLogic();
                  temp.throwProp(tempMC,p1,p3);
                  MapModelLogic.mapFrame.addChild(tempMC);
               }
            };
         },100);
         return tempMC;
      }
      
      private function clearThrow(E:* = null) : void
      {
         GC.clearGTimeout(this.throwTimer);
         BC.removeEvent(this,GV.onlineSocket,"removeMapEvent",this.clearThrow);
      }
   }
}

