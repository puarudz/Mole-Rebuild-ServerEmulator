package com.view.player
{
   import com.core.dragon.dragonInfo.DragonInfo;
   import com.mole.utils.URLUtil;
   import com.taomee.mole.player.SpritePlayer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import org.taomee.ds.HashMap;
   import org.taomee.log.Logger;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.Tick;
   
   public class DragonPlayer extends EventDispatcher
   {
      
      public static const EMPTY_FRAME:String = "empty_frame";
      
      private static var scaleMap:HashMap = new HashMap();
      
      scaleMap.add(1350004,0.8);
      
      private var _playerContainer:MovieClip;
      
      private var _dragonAPlayer:SpritePlayer;
      
      private var _dragonBPlayer:SpritePlayer;
      
      private var _dragonInfo:DragonInfo;
      
      private var _loaderComplete:Boolean;
      
      private var dragonPlayer:Array;
      
      private var _evtFrame:int = -1;
      
      public function DragonPlayer(playerContainer:MovieClip)
      {
         super();
         this._playerContainer = playerContainer;
         this._dragonAPlayer = new SpritePlayer();
         this._dragonBPlayer = new SpritePlayer();
         Tick.instance.addRender(this.renderHandler);
         this.dragonPlayer = [];
      }
      
      public function set dragonInfo(info:DragonInfo) : void
      {
         this._dragonInfo = info;
         if(scaleMap.containsKey(this._dragonInfo.ItemID))
         {
            this._dragonAPlayer.scaleX = this._dragonAPlayer.scaleY = scaleMap.getValue(this._dragonInfo.ItemID);
            this._dragonBPlayer.scaleX = this._dragonBPlayer.scaleY = scaleMap.getValue(this._dragonInfo.ItemID);
         }
         if(this._dragonInfo.Growth < this._dragonInfo.GrowthMax)
         {
            this._dragonAPlayer.resourceURL = URLUtil.getDragonSwf(this._dragonInfo.ItemID + "_small_a");
            this._dragonBPlayer.resourceURL = URLUtil.getDragonSwf(this._dragonInfo.ItemID + "_small_b");
         }
         else
         {
            this._dragonAPlayer.resourceURL = URLUtil.getDragonSwf(this._dragonInfo.ItemID + "_big_a");
            this._dragonBPlayer.resourceURL = URLUtil.getDragonSwf(this._dragonInfo.ItemID + "_big_b");
         }
         this._playerContainer.addChildAt(this._dragonAPlayer,0);
         this._playerContainer.addChild(this._dragonBPlayer);
      }
      
      public function doAction(action:uint, dir:uint = 0) : void
      {
         var actionIndex:uint = PlayerActionConstant.getActionIndex(action,dir);
         this._dragonAPlayer.setIndex(actionIndex);
         this._dragonBPlayer.setIndex(actionIndex);
      }
      
      private function renderHandler(... ret) : void
      {
         try
         {
            if(!this._dragonAPlayer.isGeting && !this._dragonBPlayer.isGeting)
            {
               if(!this._loaderComplete)
               {
                  this._dragonAPlayer.setIndex(PlayerActionConstant.STAND_DOWN);
                  this._dragonBPlayer.setIndex(PlayerActionConstant.STAND_DOWN);
                  dispatchEvent(new Event(Event.COMPLETE));
               }
               this._loaderComplete = true;
               this._dragonAPlayer.render();
               this._dragonBPlayer.render();
               if(this._evtFrame != -1 && this._dragonBPlayer.player.currentFrame == this._evtFrame)
               {
                  dispatchEvent(new Event(EMPTY_FRAME));
               }
            }
         }
         catch(e:Error)
         {
            Logger.error(this,e.message);
         }
      }
      
      public function get dragonAPlayer() : SpritePlayer
      {
         return this._dragonAPlayer;
      }
      
      public function get dragonBPlayer() : SpritePlayer
      {
         return this._dragonBPlayer;
      }
      
      public function set evtFrame(val:int) : void
      {
         this._evtFrame = val;
      }
      
      public function destroy() : void
      {
         Tick.instance.removeRender(this.renderHandler);
         DisplayUtil.removeFromParent(this._dragonAPlayer);
         DisplayUtil.removeFromParent(this._dragonBPlayer);
         this._dragonAPlayer.dispose();
         this._dragonBPlayer.dispose();
         this._dragonAPlayer = null;
         this._dragonBPlayer = null;
         this._playerContainer = null;
      }
   }
}

