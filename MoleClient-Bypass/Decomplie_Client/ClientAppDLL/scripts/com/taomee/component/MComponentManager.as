package com.taomee.component
{
   import flash.display.DisplayObjectContainer;
   
   public class MComponentManager
   {
      
      private static var __root:DisplayObjectContainer;
      
      public static var FONT_SIZE:int;
      
      public function MComponentManager()
      {
         super();
      }
      
      public static function intRoot(mc:DisplayObjectContainer, fontSize:int = 12, isLockStage:Boolean = true) : void
      {
         __root = mc;
         FONT_SIZE = fontSize;
      }
      
      public static function getCompRoot() : DisplayObjectContainer
      {
         return __root;
      }
      
      public static function centerComponent(i:Component) : void
      {
         i.x = (__root.stage.stageWidth - i.width) / 2;
         i.y = (__root.stage.stageHeight - i.height) / 2;
      }
   }
}

