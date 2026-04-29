package com.module.loadExtentPanel
{
   import flash.display.Sprite;
   
   public class LoadGame extends LoadPanel
   {
      
      public function LoadGame(url:String, loadTip:String, parentCon:Sprite, type:uint = 1002)
      {
         super(url,loadTip,parentCon,type);
      }
   }
}

