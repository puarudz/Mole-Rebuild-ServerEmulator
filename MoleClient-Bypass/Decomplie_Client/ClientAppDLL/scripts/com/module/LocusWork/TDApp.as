package com.module.LocusWork
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   
   [Event(name="mapComplete",type="com.module.LocusWork.TDApp")]
   public class TDApp extends Sprite
   {
      
      public static const MAP_COMPLETE:String = "mapComplete";
      
      public var taskArr:Array = [5,19,20];
      
      public var isTask:Boolean = false;
      
      public var _game:*;
      
      public var top_play_mc:Sprite;
      
      public var bg_mc:Sprite;
      
      public function TDApp()
      {
         super();
         addEventListener(TDApp.MAP_COMPLETE,this.mapComplete);
         this.top_play_mc = getChildByName("top_play_mc") as Sprite;
         this.bg_mc = getChildByName("bg_mc") as Sprite;
      }
      
      protected function mapComplete(e:Event) : void
      {
      }
      
      public function clean() : void
      {
         this._game = null;
         this.top_play_mc = null;
         this.bg_mc = null;
      }
      
      public function get game() : *
      {
         return this._game;
      }
      
      public function set game(value:*) : void
      {
         this._game = value;
      }
      
      public function addChildToBottom(mc:DisplayObject) : void
      {
         var main:DisplayObjectContainer = null;
         var i:int = 0;
         if(mc is DisplayObjectContainer)
         {
            main = mc as DisplayObjectContainer;
            for(i = main.numChildren - 1; i >= 0; i--)
            {
               this.addChild(main.getChildAt(0));
            }
         }
         else
         {
            this.addChild(mc);
         }
      }
   }
}

