package com.mole.app.module
{
   import com.common.util.DisplayUtil;
   import com.core.manager.LevelManager;
   import flash.display.Sprite;
   
   public class GameModuleBase extends AppModuleBase
   {
      
      private var _gameUI:GameUIBase;
      
      private var _gameLevelCon:Sprite;
      
      private var _gameLevel:GameLevelBase;
      
      public function GameModuleBase(gameUI:GameUIBase = null, moduleID:uint = 0)
      {
         super(moduleID);
         this._gameLevelCon = new Sprite();
         addChild(this._gameLevelCon);
         this._gameLevelCon.addChild(LevelManager.drawBG());
         if(Boolean(gameUI))
         {
            this._gameUI = gameUI;
            addChild(this._gameUI);
         }
      }
      
      public function get gameLevel() : GameLevelBase
      {
         return this._gameLevel;
      }
      
      public function set gameLevel(value:GameLevelBase) : void
      {
         this.removeGameLevel();
         this._gameLevel = value;
         this._gameLevelCon.addChild(this._gameLevel);
      }
      
      protected function removeGameLevel() : void
      {
         if(Boolean(this._gameLevel))
         {
            this._gameLevel.destroy();
            this._gameLevel = null;
            DisplayUtil.removeForParent(this._gameLevel);
         }
      }
      
      override public function destroy() : void
      {
         if(Boolean(this._gameUI))
         {
            this._gameUI.destroy();
            this._gameUI = null;
         }
         this.removeGameLevel();
         super.destroy();
      }
   }
}

