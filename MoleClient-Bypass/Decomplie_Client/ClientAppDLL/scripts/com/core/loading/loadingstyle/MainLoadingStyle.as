package com.core.loading.loadingstyle
{
   import com.core.MainManager;
   import flash.display.DisplayObjectContainer;
   
   public class MainLoadingStyle extends TitlePercentLoading implements ILoadingStyle
   {
      
      private static const KEY:String = "mainLoad";
      
      public function MainLoadingStyle(parentMC:DisplayObjectContainer, title:String = "Loading...", showCloseBtn:Boolean = false)
      {
         super(parentMC,title,showCloseBtn);
         _loadingMC["start"]();
      }
      
      override protected function initPosition() : void
      {
         MainManager.getStage().addChild(_loadingMC);
      }
      
      override protected function getKey() : String
      {
         return KEY;
      }
      
      override public function close() : void
      {
         _loadingMC["destroy"]();
         super.close();
      }
   }
}

