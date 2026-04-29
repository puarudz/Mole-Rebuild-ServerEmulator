package com.view.PeopleView
{
   import com.module.newAngel.info.AngelInfo;
   import com.mole.utils.URLUtil;
   import com.view.player.NewAngelPlayer;
   import flash.display.Sprite;
   
   public class NewAngelModel extends Sprite
   {
      
      private var angelPlayer:NewAngelPlayer;
      
      private var _angelInfo:AngelInfo;
      
      public function NewAngelModel(angelInfo:AngelInfo)
      {
         super();
         this._angelInfo = angelInfo;
         this.angelPlayer = new NewAngelPlayer();
         addChild(this.angelPlayer);
         this.angelPlayer.resourceURL = URLUtil.getNewAngelSwf(this._angelInfo.angelStaticId);
      }
      
      public function doAction(actionId:uint, dir:uint, loop:uint = 0) : void
      {
         this.angelPlayer.doAction(actionId,dir,loop);
      }
      
      public function get curDir() : uint
      {
         return this.angelPlayer.curDir;
      }
      
      public function get curAction() : uint
      {
         return this.angelPlayer.curAction;
      }
      
      public function get angelInfo() : AngelInfo
      {
         return this._angelInfo;
      }
      
      public function dispose() : void
      {
         this.angelPlayer.dispose();
         this._angelInfo = null;
      }
   }
}

