package com.module.lahmClassRoom
{
   import com.core.MainManager;
   import com.event.EventTaomee;
   import flash.display.Loader;
   import flash.display.MovieClip;
   
   public class lahmCourseSpecial
   {
      
      private static var instance:lahmCourseSpecial;
      
      private static var canotNew:Boolean = true;
      
      private var gameLoader:Loader;
      
      private var gameMc:MovieClip;
      
      public function lahmCourseSpecial()
      {
         super();
         if(canotNew)
         {
            throw new Error("lahmCourseSpecial不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : lahmCourseSpecial
      {
         if(!instance)
         {
            canotNew = false;
            instance = new lahmCourseSpecial();
            canotNew = true;
         }
         return instance;
      }
      
      public function courseSpecial(courseId:int) : void
      {
         this.gameMc = new MovieClip();
         this.gameMc.name = "gameMc";
         GC.clearAllChildren(this.gameMc);
         if(courseId == 13)
         {
            BC.addEvent(this,GV.onlineSocket,"sportOver",this.onSportOver);
            this.gameLoader = new Loader();
            this.gameLoader.load(VL.getURLRequest("module/game/LamuSport.swf"));
            this.gameMc.addChild(this.gameLoader);
            MainManager.getGameLevel().addChild(this.gameMc);
         }
      }
      
      private function onSportOver(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"sportOver",this.onSportOver);
         var scoreNum:int = int(evt.EventObj.score);
         trace(scoreNum);
         MainManager.getGameLevel().removeChild(this.gameMc);
      }
   }
}

