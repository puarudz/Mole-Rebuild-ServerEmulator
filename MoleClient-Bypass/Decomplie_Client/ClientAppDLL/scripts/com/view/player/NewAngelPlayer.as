package com.view.player
{
   import com.taomee.mole.player.SpritePlayer;
   import org.taomee.utils.Tick;
   
   public class NewAngelPlayer extends SpritePlayer
   {
      
      private var _curAction:uint;
      
      private var _curDir:uint;
      
      public function NewAngelPlayer()
      {
         super();
         Tick.instance.addRender(this.renderHandler);
      }
      
      public function doAction(actionId:uint, dir:uint, loop:uint = 0) : void
      {
         this._curAction = actionId;
         this._curDir = dir;
         var actionIndex:uint = PlayerActionConstant.getNewAngelActionIndex(actionId,dir);
         setIndex(actionIndex);
         if(dir >= 5)
         {
            scaleX = -1;
         }
         else
         {
            scaleX = 1;
         }
      }
      
      public function get curDir() : uint
      {
         return this._curDir;
      }
      
      public function get curAction() : uint
      {
         return this._curAction;
      }
      
      public function renderHandler(... ret) : void
      {
         render();
      }
      
      override public function dispose() : void
      {
         Tick.instance.removeRender(this.renderHandler);
         super.dispose();
      }
   }
}

