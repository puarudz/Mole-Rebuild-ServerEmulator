package com.core.loading.loadingstyle
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.text.TextField;
   
   public class TitlePercentLoading extends TitleOnlyLoading implements ILoadingStyle
   {
      
      private static const KEY:String = "RES_TitleLoading";
      
      protected var percentText:TextField;
      
      protected var percentBar:DisplayObject;
      
      private var barWidth:Number;
      
      private var showCloseBtn:Boolean = true;
      
      public function TitlePercentLoading(parentMC:DisplayObjectContainer, title:String = "Loading...", showCloseBtn:Boolean = false)
      {
         super(parentMC,title,this.showCloseBtn);
         this.percentText = _loadingMC["perNum"];
         this.percentText.text = "0%";
         this.percentBar = _loadingMC["loadingbar"];
         this.barWidth = 166;
      }
      
      override public function changePercent(total:Number, loaded:Number) : void
      {
         super.changePercent(total,loaded);
         this.percentText.text = _percent + "%";
         this.percentBar.width = this.barWidth * (_percent / 100);
      }
      
      override public function setTitle(str:String) : void
      {
         super.setTitle(str);
      }
      
      override protected function getKey() : String
      {
         return KEY;
      }
   }
}

