package com.mole.app.module
{
   import com.common.util.DisplayUtil;
   import flash.display.Sprite;
   
   public class GamePage extends Sprite
   {
      
      protected var _gamePage:Sprite;
      
      protected var _initData:Object;
      
      public function GamePage(page:Sprite)
      {
         super();
         this._gamePage = page;
         addChild(this._gamePage);
      }
      
      public function init(data:Object) : void
      {
         this._initData = data;
      }
      
      public function destroy() : void
      {
         this._initData = null;
         this._gamePage = null;
         DisplayUtil.removeForParent(this);
      }
   }
}

