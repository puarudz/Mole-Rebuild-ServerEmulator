package com.mole.app.module
{
   import com.common.util.DisplayUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.media.SoundMixer;
   import flash.media.SoundTransform;
   
   public class GameUIBase extends Sprite
   {
      
      protected var _module:AppModuleBase;
      
      private var _ui:Sprite;
      
      private var _sound_mc:MovieClip;
      
      private var _close_btn:SimpleButton;
      
      public function GameUIBase(ui:Sprite, module:AppModuleBase)
      {
         super();
         this._ui = ui;
         addChild(this._ui);
         this._module = module;
         this._sound_mc = this._ui["sound_mc"];
         this._close_btn = this._ui["close_btn"];
         if(Boolean(this._sound_mc))
         {
            this._sound_mc.addEventListener(MouseEvent.CLICK,this.onSoundClick);
         }
         if(Boolean(this._close_btn))
         {
            this._close_btn.addEventListener(MouseEvent.CLICK,this.onCloseClick);
         }
      }
      
      private function onSoundClick(e:MouseEvent) : void
      {
         if(this._sound_mc.currentFrame == 1)
         {
            SoundMixer.soundTransform = new SoundTransform(0);
            this._sound_mc.gotoAndStop(2);
         }
         else
         {
            SoundMixer.soundTransform = new SoundTransform(1);
            this._sound_mc.gotoAndStop(1);
         }
      }
      
      protected function onCloseClick(e:MouseEvent) : void
      {
         SoundMixer.soundTransform = new SoundTransform(1);
         this._module.close();
      }
      
      public function destroy() : void
      {
         this._module = null;
         this._ui = null;
         if(Boolean(this._sound_mc))
         {
            this._sound_mc.removeEventListener(MouseEvent.CLICK,this.onSoundClick);
            this._sound_mc = null;
         }
         if(Boolean(this._close_btn))
         {
            this._close_btn.removeEventListener(MouseEvent.CLICK,this.onCloseClick);
            this._close_btn = null;
         }
         DisplayUtil.removeForParent(this);
      }
   }
}

