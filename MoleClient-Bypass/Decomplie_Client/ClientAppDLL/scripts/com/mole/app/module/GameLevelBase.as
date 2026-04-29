package com.mole.app.module
{
   import com.common.util.DisplayUtil;
   import flash.display.Sprite;
   
   public class GameLevelBase extends Sprite
   {
      
      protected var _module:AppModuleBase;
      
      protected var _gamePanel:Sprite;
      
      public function GameLevelBase(module:AppModuleBase, gamePanel:Sprite)
      {
         super();
         this._module = module;
         this._gamePanel = gamePanel;
         addChild(this._gamePanel);
      }
      
      public function get module() : AppModuleBase
      {
         return this._module;
      }
      
      public function destroy() : void
      {
         this._module = null;
         this._gamePanel = null;
         DisplayUtil.removeForParent(this);
      }
   }
}

