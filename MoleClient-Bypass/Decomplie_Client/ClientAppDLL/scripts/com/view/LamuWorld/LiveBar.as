package com.view.LamuWorld
{
   import com.common.Tween.TweenLite;
   import com.common.util.DisplayUtil;
   import fl.transitions.easing.Strong;
   import flash.display.Sprite;
   
   public class LiveBar
   {
      
      public var maxLive:int = 5;
      
      protected var ui:Sprite;
      
      protected var _live:int;
      
      public function LiveBar(ui:Sprite)
      {
         super();
         this.ui = ui;
      }
      
      public function set live(val:int) : void
      {
         if(val < 0)
         {
            val = 0;
         }
         if(val > this.maxLive)
         {
            val = this.maxLive;
         }
         this._live = val;
      }
      
      public function get live() : int
      {
         return this._live;
      }
      
      public function set visible(flag:Boolean) : void
      {
         this.ui.visible = flag;
      }
      
      public function hideLive() : void
      {
         TweenLite.to(this.ui,1,{
            "x":this.ui.x + 300,
            "ease":Strong.easeOut
         });
      }
      
      public function destroy() : void
      {
         DisplayUtil.removeForParent(this.ui);
      }
   }
}

