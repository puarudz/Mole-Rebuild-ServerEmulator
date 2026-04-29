package com.logic.FindPathLogic
{
   import com.core.MainManager;
   import com.core.manager.LevelManager;
   import com.logic.MapManageLogic.MapModelLogic;
   import com.view.MapManageView.MapButtonView;
   import flash.geom.Point;
   
   public class MoveCondition
   {
      
      public static var ignore_app:Boolean = false;
      
      public function MoveCondition()
      {
         super();
      }
      
      public static function check(tp:Point) : Boolean
      {
         try
         {
            if(!hasRoad(tp.x,tp.y))
            {
               return false;
            }
            if(Boolean(GV.MAN_PEOPLE.isLookBook))
            {
               return false;
            }
            if(Boolean(GV.MAN_PEOPLE.isFlying))
            {
               return false;
            }
            if(MainManager.getGameLevel().hitTestPoint(tp.x,tp.y,true))
            {
               return false;
            }
            if(Boolean(GV.MC_mapFrame["control_mc"].hitTestPoint(tp.x,tp.y,true)))
            {
               return false;
            }
            if(MapButtonView.getTarget().hitTestPoint(tp.x,tp.y,true))
            {
               return false;
            }
            if(!ignore_app && MainManager.getAppLevel().hitTestPoint(tp.x,tp.y,true))
            {
               return false;
            }
            if(MainManager.getToolLevel().hitTestPoint(tp.x,tp.y,true))
            {
               return false;
            }
            if(MainManager.getTopLevel().hitTestPoint(tp.x,tp.y,true))
            {
               return false;
            }
            if(!checkPoint(tp))
            {
               return false;
            }
            if(LevelManager.dialogLevel.hitTestPoint(tp.x,tp.y,true))
            {
               return false;
            }
            if(LevelManager.mapMovieLevel.hitTestPoint(tp.x,tp.y,true))
            {
               return false;
            }
            if(LevelManager.alertLevel.hitTestPoint(tp.x,tp.y,true))
            {
               return false;
            }
            if(LevelManager.loadingLevel.hitTestPoint(tp.x,tp.y,true))
            {
               return false;
            }
            return true;
         }
         catch(E:*)
         {
            trace(E);
         }
         return false;
      }
      
      public static function checkPoint(point:Point) : Boolean
      {
         var po:Point = null;
         if(Boolean(GV.MAN_PEOPLE))
         {
            po = new Point(GV.MAN_PEOPLE.x,GV.MAN_PEOPLE.y);
            if(Point.distance(point,po) < 10)
            {
               return false;
            }
            return true;
         }
         return false;
      }
      
      public static function hasRoad(x:Number, y:Number) : Boolean
      {
         var posX:int = int(x / MapModelLogic.GridSize);
         var posY:int = int(y / MapModelLogic.GridSize);
         if(Boolean(MapModelLogic.MapArray[posX]) && MapModelLogic.MapArray[posX][posY] > 0)
         {
            return true;
         }
         return false;
      }
   }
}

