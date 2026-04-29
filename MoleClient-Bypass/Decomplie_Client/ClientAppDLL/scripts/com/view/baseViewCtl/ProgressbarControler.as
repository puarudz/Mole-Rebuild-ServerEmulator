package com.view.baseViewCtl
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ProgressbarControler
   {
      
      private var _ui:MovieClip;
      
      private var _maxNum:int = 0;
      
      private var _menuTxt:TextField;
      
      public function ProgressbarControler(ui:MovieClip)
      {
         super();
         this._ui = ui;
         this._ui.gotoAndStop(1);
         this._menuTxt = this._ui.num_txt;
         if(Boolean(this._menuTxt))
         {
            this._menuTxt.selectable = false;
            this._menuTxt.mouseEnabled = false;
         }
      }
      
      public function SetData(value:Number, maxNum:Number, fixed:int = 0) : void
      {
         this._maxNum = maxNum;
         var str:String = Number(value).toFixed(fixed);
         if(value == 0)
         {
            str = "0";
         }
         if(Boolean(this._menuTxt))
         {
            this._menuTxt.text = str + "/" + maxNum;
         }
         this._ui.gotoAndStop(int(value / this._maxNum * this._ui.totalFrames));
      }
      
      public function get ui() : MovieClip
      {
         return this._ui;
      }
   }
}

