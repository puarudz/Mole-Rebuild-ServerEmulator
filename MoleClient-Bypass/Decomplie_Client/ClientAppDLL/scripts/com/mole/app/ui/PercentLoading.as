package com.mole.app.ui
{
   import com.core.manager.LevelManager;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.text.TextField;
   
   public class PercentLoading extends LoadingBase
   {
      
      protected var _percent_mc:DisplayObject;
      
      protected var _percert_txt:TextField;
      
      public function PercentLoading(loading_mc:DisplayObjectContainer, title:String = "Loading...")
      {
         super(loading_mc,title);
         this._percert_txt = _loading_mc["perNum"];
         this._percent_mc = _loading_mc["loadingbar"];
         this.changePercent(100,0);
         addChildAt(LevelManager.drawBG(),0);
      }
      
      override public function changePercent(total:Number, loaded:Number) : void
      {
         super.changePercent(total,loaded);
         this._percert_txt.text = Math.round(_percent * 100).toString() + "%";
         this._percent_mc.scaleX = _percent;
      }
   }
}

