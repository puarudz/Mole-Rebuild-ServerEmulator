package com.mole.app.manager
{
   import com.common.Alert.Alert;
   import com.common.Alert.type.AlertType;
   import com.common.util.DisplayUtil;
   import com.core.manager.IndexManager;
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import com.logic.randomItemDrawLogic.randomItemDrawLogic;
   import com.module.npc.lamu.I_LamuNPC;
   import com.module.pet.petLogic;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   
   public class LamuReviveManager
   {
      
      private static var _pet:I_LamuNPC;
      
      private static var setTimeNum:int;
      
      private static var petTimer:Timer;
      
      private static var _wait_mc:MovieClip;
      
      private static var _maskLevel:Sprite;
      
      public function LamuReviveManager()
      {
         super();
      }
      
      public static function revive() : void
      {
         petTimer = new Timer(1000,60);
         petTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onGetReviveItem);
         petTimer.addEventListener(TimerEvent.TIMER,onUpdateScroll);
         petTimer.start();
         var peopleMC:* = GV.MAN_PEOPLE.avatarMC.tomatoMC;
         if(!peopleMC.getChildByName("kaddish_mc"))
         {
            _wait_mc = IndexManager.getInstance().getMovieClip("RES_LamuRevive_Flag");
            _wait_mc["scroll_mc"].gotoAndStop(1);
            peopleMC.addChild(_wait_mc);
         }
         _maskLevel = LevelManager.drawBG(0,0);
         LevelManager.appLevel.addChild(_maskLevel);
         _maskLevel.addEventListener(MouseEvent.MOUSE_DOWN,onConfirm);
      }
      
      private static function onUpdateScroll(e:TimerEvent) : void
      {
         if(Boolean(_wait_mc))
         {
            _wait_mc["scroll_mc"].gotoAndStop(petTimer.currentCount);
         }
      }
      
      private static function onConfirm(e:Event) : void
      {
         Alert.smileAlart("    正在祈禱拉姆復活中，想要離開麼？",function(e:Event):void
         {
            removeEvent();
         },AlertType.SURE + "," + AlertType.CANCEL);
      }
      
      private static function removeEvent() : void
      {
         _maskLevel.removeEventListener(MouseEvent.MOUSE_DOWN,onConfirm);
         DisplayUtil.removeForParent(_maskLevel);
         petTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,onGetReviveItem);
         petTimer.removeEventListener(TimerEvent.TIMER,onUpdateScroll);
         petTimer.stop();
         DisplayUtil.removeForParent(_wait_mc);
         _wait_mc = null;
      }
      
      private static function onGetReviveItem(evt:TimerEvent) : void
      {
         removeEvent();
         randomItemDrawLogic.sendType = 2;
         var itemArray:Array = [{
            "kind":180006,
            "num":1
         }];
         randomItemDrawLogic.sendServerAction(itemArray);
         GV.onlineSocket.addEventListener("getLiveItem",getItemSuc);
      }
      
      private static function getItemSuc(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("getLiveItem",getItemSuc);
         petLogic.doFeedPet(_pet["lamuInfo"].masterID,_pet["lamuInfo"].PetID,180006);
         _pet["lamuInfo"].isDie = true;
         setTimeout(function():void
         {
            ModuleManager.openPanel("LamuReviveAlert3");
         },3000);
      }
      
      public static function get pet() : I_LamuNPC
      {
         return _pet;
      }
      
      public static function set pet(value:I_LamuNPC) : void
      {
         _pet = value;
      }
   }
}

