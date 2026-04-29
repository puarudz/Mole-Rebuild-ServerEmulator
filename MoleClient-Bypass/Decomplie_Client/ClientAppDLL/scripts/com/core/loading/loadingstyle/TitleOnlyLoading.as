package com.core.loading.loadingstyle
{
   import flash.display.DisplayObjectContainer;
   import flash.text.TextField;
   
   public class TitleOnlyLoading extends BaseLoadingStyle implements ILoadingStyle
   {
      
      private static const KEY:String = "titleOnlyLoading";
      
      protected var titleText:TextField;
      
      public function TitleOnlyLoading(parentMC:DisplayObjectContainer, title:String = "Loading...", showCloseBtn:Boolean = false)
      {
         super(parentMC,showCloseBtn);
         this.titleText = _loadingMC["content_txt"];
         this.titleText.text = title;
      }
      
      override public function changePercent(total:Number, loaded:Number) : void
      {
         super.changePercent(total,loaded);
      }
      
      override public function setTitle(str:String) : void
      {
         this.titleText.text = str;
      }
      
      override protected function getKey() : String
      {
         return KEY;
      }
   }
}

