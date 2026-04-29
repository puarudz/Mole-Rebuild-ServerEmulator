package com.view.mapView.activity.Task83
{
   import com.core.MainManager;
   import com.core.newloader.MCLoader;
   import com.event.MCLoadEvent;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   
   public class AngelRookieLead
   {
      
      private static var _instance:AngelRookieLead;
      
      private var gift_MC:MovieClip;
      
      private var childMC:*;
      
      public function AngelRookieLead()
      {
         super();
      }
      
      public static function get instance() : AngelRookieLead
      {
         if(!_instance)
         {
            _instance = new AngelRookieLead();
         }
         return _instance;
      }
      
      public function npcSay() : void
      {
      }
      
      public function checkAngelLeadCourseOne() : void
      {
         var url:String = "resource/task/AngelLeaderCourseOne.swf";
         this.onLoadPanel(url);
      }
      
      public function checkAngelLeadCourseTwo() : void
      {
         var url:String = "resource/task/AngelLeaderCourseTwo.swf";
         this.onLoadPanel(url);
      }
      
      public function checkAngelLeadCourseThree() : void
      {
         var url:String = "resource/task/AngelLeaderCourseThree.swf";
         this.onLoadPanel(url);
      }
      
      private function onLoadPanel(url:String) : void
      {
         this.gift_MC = new MovieClip();
         this.gift_MC.name = "gift_MC";
         MainManager.getAppLevel().addChild(this.gift_MC);
         var tempMC:MCLoader = new MCLoader(url,this.gift_MC,1,"正在打開面板......");
         tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadCallBoardHandler);
         tempMC.doLoad();
      }
      
      private function loadCallBoardHandler(e:*) : void
      {
         var mainMC:DisplayObjectContainer = e.getParent();
         this.childMC = e.getLoader();
         mainMC.addChild(this.childMC);
      }
      
      public function clearHandler() : void
      {
         BC.removeEvent(this);
         GC.clearAll(this.gift_MC);
         this.gift_MC = null;
      }
   }
}

