package com.view.toolView.tool
{
   import com.common.tip.tip;
   import com.core.info.LocalUserInfo;
   import com.core.music.TopicMusicManager;
   import com.logic.mapEvent.MapEvent;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.StatisticsManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.type.ModuleType;
   import com.view.mapView.activity.Task83.SoundManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import org.taomee.manager.TaomeeManager;
   
   public class ToolSystemMenu
   {
      
      public static const OPEN_ALL_SOUND_EVENT:String = "OPEN_ALL_SOUND_EVENT";
      
      public static const CLOSE_ALL_SOUND_EVENT:String = "CLOSE_ALL_SOUND_EVENT";
      
      public static const HIDE_OTHER_MOLE:String = "hideOtherMole";
      
      public static const SHOW_OTHER_MOLE:String = "showOtherMole";
      
      public static var _isHideOtherMole:Boolean = false;
      
      private var _service_btn:SimpleButton;
      
      private var _visible_mc:MovieClip;
      
      private var _sound_mc:MovieClip;
      
      private var _soundCon:Sprite;
      
      private var _scrList:Array;
      
      private var _menuCon:Sprite;
      
      public function ToolSystemMenu(_menuCon:Sprite)
      {
         var scr_btn:DisplayObject = null;
         super();
         this._menuCon = _menuCon;
         _menuCon.visible = false;
         this._service_btn = _menuCon["service_btn"];
         this._visible_mc = _menuCon["visible_mc"];
         this._visible_mc.mouseChildren = false;
         this._visible_mc.buttonMode = true;
         this._sound_mc = _menuCon["sound_mc"];
         this._sound_mc.mouseChildren = false;
         this._sound_mc.buttonMode = true;
         this._soundCon = _menuCon["soundCon"];
         this._soundCon.visible = false;
         this._service_btn.addEventListener(MouseEvent.CLICK,this.onOpenService);
         this._visible_mc.addEventListener(MouseEvent.CLICK,this.onSetVisible);
         this._sound_mc.addEventListener(MouseEvent.CLICK,this.onSetSound);
         this._sound_mc.mouseChildren = false;
         this._sound_mc.addEventListener(MouseEvent.MOUSE_OVER,this.onShowVolumeControl);
         this._scrList = new Array();
         var soundScr:Sprite = this._soundCon["soundScr"];
         for(var i:uint = 1; i <= 7; i++)
         {
            scr_btn = soundScr["_" + i];
            scr_btn.addEventListener(MouseEvent.CLICK,this.onSetSoundScr);
            this._scrList.push(scr_btn);
         }
         tip.tipTailDisPlayObject(this._service_btn,"在線提問");
         GV.onlineSocket.addEventListener(MapEvent.CHANGE_MAP_COMPLETE,this.onReadyChangeMap);
      }
      
      public function show() : void
      {
         this._menuCon.visible = true;
         this._menuCon.addEventListener(Event.ENTER_FRAME,this.enterFrame);
      }
      
      private function enterFrame(evt:Event) : void
      {
         if(!this._menuCon.hitTestPoint(TaomeeManager.stage.mouseX,TaomeeManager.stage.mouseY,true))
         {
            this._menuCon.visible = false;
            this._menuCon.removeEventListener(Event.ENTER_FRAME,this.enterFrame);
         }
      }
      
      public function onReadyChangeMap(e:Event) : void
      {
         if(SoundManager.mute == false)
         {
            this._sound_mc.gotoAndStop(1);
            if(Boolean(GV.MC_mapFrame))
            {
               MovieClip(GV.MC_mapFrame).soundTransform.volume = 0;
            }
         }
         else
         {
            this._sound_mc.gotoAndStop(2);
            if(Boolean(GV.MC_mapFrame))
            {
               MovieClip(GV.MC_mapFrame).soundTransform.volume = 1;
            }
         }
      }
      
      private function onOpenService(e:MouseEvent) : void
      {
         ModuleManager.openPanel(ModuleType.NEW_TERMS_PLAN_PANEL);
      }
      
      public function closeOnlineServiceFunc() : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("closeInnerFrame");
         }
      }
      
      private function onSetVisible(e:MouseEvent) : void
      {
         StatisticsManager.send(494);
         if(this._visible_mc.currentFrame == 1)
         {
            LocalUserInfo.setIsHideOtherMole(true);
            _isHideOtherMole = true;
            this._visible_mc.gotoAndStop(2);
            SystemEventManager.dispatchEvent(new Event(HIDE_OTHER_MOLE));
         }
         else if(this._visible_mc.currentFrame == 2)
         {
            LocalUserInfo.setIsHideOtherMole(false);
            _isHideOtherMole = false;
            this._visible_mc.gotoAndStop(1);
            SystemEventManager.dispatchEvent(new Event(SHOW_OTHER_MOLE));
         }
      }
      
      private function onSetSound(e:MouseEvent) : void
      {
         if(this._sound_mc.currentFrame == 1)
         {
            SystemEventManager.dispatchEvent(new Event(OPEN_ALL_SOUND_EVENT));
            SoundManager.mute = true;
            this._sound_mc.gotoAndStop(2);
            this._soundCon.visible = false;
         }
         else if(this._sound_mc.currentFrame == 2)
         {
            SystemEventManager.dispatchEvent(new Event(CLOSE_ALL_SOUND_EVENT));
            SoundManager.mute = false;
            this._sound_mc.gotoAndStop(1);
            this._soundCon.visible = true;
         }
      }
      
      private function onSetSoundScr(e:MouseEvent) : void
      {
         var tar_btn:DisplayObject = e.currentTarget as DisplayObject;
         var tarFrame:uint = uint(String(tar_btn.name).split("_")[1]);
         var soundScr:MovieClip = this._soundCon["soundScr"];
         soundScr.gotoAndStop(tarFrame);
         TopicMusicManager.instance.changeSoundVolume(tarFrame / 8);
      }
      
      private function onShowVolumeControl(e:MouseEvent) : void
      {
         StatisticsManager.send(495);
         if(this._sound_mc.currentFrame == 1)
         {
            this._soundCon.visible = true;
            this._soundCon.addEventListener(MouseEvent.ROLL_OUT,this.onSoundConRollOut);
         }
      }
      
      private function onSoundConRollOut(evt:MouseEvent) : void
      {
         this._soundCon.removeEventListener(MouseEvent.ROLL_OUT,this.onSoundConRollOut);
         this._soundCon.visible = false;
      }
      
      public function destroy() : void
      {
         var scr_btn:DisplayObject = null;
         this._service_btn.removeEventListener(MouseEvent.CLICK,this.onOpenService);
         this._visible_mc.removeEventListener(MouseEvent.CLICK,this.onOpenService);
         this._sound_mc.removeEventListener(MouseEvent.CLICK,this.onOpenService);
         this._sound_mc.removeEventListener(MouseEvent.MOUSE_OVER,this.onShowVolumeControl);
         for each(scr_btn in this._scrList)
         {
            scr_btn.removeEventListener(MouseEvent.CLICK,this.onSetSoundScr);
         }
         this._scrList = null;
      }
   }
}

