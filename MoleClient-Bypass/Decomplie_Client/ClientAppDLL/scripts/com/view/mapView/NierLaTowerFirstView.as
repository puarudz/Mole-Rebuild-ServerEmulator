package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.JobLogic.JobExpandLogic;
   import com.module.loadExtentPanel.LoadGame;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.ActivityTmpDataManager;
   import com.mole.app.manager.BufferManager;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.NewRoleBagManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.map.MapManager;
   import com.mole.app.task.TaskManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class NierLaTowerFirstView extends MapBase
   {
      
      private static var _task548:Boolean;
      
      public static var nowJob_265info:Object = new Object();
      
      private var nowJob_info:Object;
      
      private var _totemStep:uint;
      
      private var _kfcJewelStep:uint;
      
      public function NierLaTowerFirstView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         controlLevel.magicBox_mc.buttonMode = true;
         BC.addEvent(this,controlLevel.aceGame,MouseEvent.CLICK,this.onAceGame);
         BC.addEvent(this,controlLevel.magicBox_mc,MouseEvent.CLICK,this.openMagicIntroducePanel);
         depthLevel.niceBoll.gotoAndPlay(depthLevel.niceBoll.totalFrames);
         this.task265Event();
         GV.onlineSocket.addEventListener("transfigurationOver",this.transfigurationOver);
         SystemEventManager.addEventListener("totem",this.totemHandle);
         SystemEventManager.addEventListener("kulachen",this.kulachenHandle);
         SystemEventManager.addEventListener("howEnterMap",this.howEnterMap);
         SystemEventManager.addEventListener("openJewelGame",this.jewelGameHandle);
         SystemEventManager.addEventListener("mohe",this.moheHandle);
      }
      
      private function moheHandle(e:SystemEvent = null) : void
      {
         NewRoleBagManager.openBag();
      }
      
      private function jewelGameHandle(e:SystemEvent = null) : void
      {
         BufferManager.setBuffer(BufferManager.KFC_JEWEL_BOX_SWAP,2);
         new LoadGame("module/game/FindCrystalGame.swf","正在加載預言球機關",MainManager.getGameLevel());
         GV.onlineSocket.addEventListener("nierlaGameOver",this.gameWinHandler);
      }
      
      private function gameWinHandler(evt:Event) : void
      {
         GV.onlineSocket.removeEventListener("nierlaGameOver",this.gameWinHandler);
         BufferManager.setBuffer(BufferManager.KFC_JEWEL_BOX_SWAP,3);
         Alert.smileAlart("　　聰明的小摩爾，恭喜你闖關成功，打開了去西部遊樂場的機關，現在就去吧！",function():void
         {
            MapManager.enterMap(6);
         });
      }
      
      private function howEnterMap(e:SystemEvent) : void
      {
         BufferManager.addBufferEvent(BufferManager.KFC_JEWEL_BOX_SWAP,this.kfcJewelHandle);
         BufferManager.getBuffer(BufferManager.KFC_JEWEL_BOX_SWAP);
      }
      
      private function kfcJewelHandle(e:EventTaomee) : void
      {
         BufferManager.removeBufferEvent(BufferManager.KFC_JEWEL_BOX_SWAP,this.kfcJewelHandle);
         this._kfcJewelStep = uint(e.EventObj);
         if(this._kfcJewelStep == 1)
         {
            mapSay(8);
         }
         else if(this._kfcJewelStep == 0)
         {
            mapSay(10);
         }
         else if(this._kfcJewelStep == 2)
         {
            this.jewelGameHandle();
         }
         else
         {
            Alert.smileAlart("小摩爾去西部遊戲場看看唄！",function():void
            {
               MapManager.enterMap(6);
            });
         }
      }
      
      private function kulachenHandle(e:SystemEvent) : void
      {
         BufferManager.addBufferEvent(BufferManager.TOTEM_TASK_STEP,this.teoStepHandle);
         BufferManager.getBuffer(BufferManager.TOTEM_TASK_STEP);
      }
      
      private function teoStepHandle(e:EventTaomee) : void
      {
         BufferManager.removeBufferEvent(BufferManager.TOTEM_TASK_STEP,this.teoStepHandle);
         this._totemStep = uint(e.EventObj);
         if(this._totemStep == 2)
         {
            BufferManager.setBuffer(BufferManager.TOTEM_TASK_STEP,3);
         }
      }
      
      private function totemHandle(e:SystemEvent) : void
      {
         BufferManager.addBufferEvent(BufferManager.TOTEM_TASK_STEP,this.totemStepHandle);
         BufferManager.getBuffer(BufferManager.TOTEM_TASK_STEP);
      }
      
      private function totemStepHandle(e:EventTaomee) : void
      {
         BufferManager.removeBufferEvent(BufferManager.TOTEM_TASK_STEP,this.totemStepHandle);
         this._totemStep = uint(e.EventObj);
         if(this._totemStep == 1)
         {
            BufferManager.setBuffer(BufferManager.TOTEM_TASK_STEP,2);
            mapSay(5);
         }
      }
      
      private function transfigurationOver(evt:Event) : void
      {
         MovieClip(depthLevel["npc_10161"]).gotoAndPlay(2);
      }
      
      private function onAceGame(evt:MouseEvent) : void
      {
         new LoadGame("module/game/FindCrystalGame.swf","正在加載預言球機關",MainManager.getGameLevel());
         GV.onlineSocket.addEventListener("nierlaGameOver",this.gameWinWinHandler);
      }
      
      private function gameWinWinHandler(evt:Event) : void
      {
         GV.onlineSocket.removeEventListener("nierlaGameOver",this.gameWinHandler);
         ActivityTmpDataManager.getTransferItem(8);
      }
      
      private function task265Event() : void
      {
         var task265State:uint = TaskManager.getTaskState(265);
         if(task265State == 1)
         {
            BC.addEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.getJob265Info);
            JobExpandLogic.getJobExpand().getOneJob(265);
         }
      }
      
      private function getJob265Info(evt:EventTaomee) : void
      {
         BC.removeEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.getJob265Info);
         nowJob_265info = evt.EventObj.obj;
      }
      
      private function openMagicIntroducePanel(evt:MouseEvent) : void
      {
         ModuleManager.openPanel("MagicBoxIntroductionPanel");
      }
      
      override public function destroy() : void
      {
         BufferManager.removeBufferEvent(BufferManager.KFC_JEWEL_BOX_SWAP,this.kfcJewelHandle);
         GV.onlineSocket.removeEventListener("nierlaGameOver",this.gameWinWinHandler);
         SystemEventManager.removeEventListener("openJewelGame",this.jewelGameHandle);
         SystemEventManager.removeEventListener("howEnterMap",this.howEnterMap);
         SystemEventManager.removeEventListener("kulachen",this.kulachenHandle);
         BufferManager.removeBufferEvent(BufferManager.TOTEM_TASK_STEP,this.teoStepHandle);
         GV.onlineSocket.removeEventListener("nierlaGameOver",this.gameWinHandler);
         SystemEventManager.removeEventListener("totem",this.totemHandle);
         super.destroy();
      }
   }
}

