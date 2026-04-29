package com.view.mapView.activity
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.socket.superlamuParty.superlamuPartySocket;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.ActivityTmpDataManager;
   import com.mole.app.manager.NPCDialogManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapManager;
   import com.view.MapManageView.MapManageView;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class BackToYouthMapManager
   {
      
      private static var _instence:BackToYouthMapManager;
      
      private var _getMagicWater:Boolean = ActivityTmpDataManager.getMagicWater;
      
      private var _npcMC:MovieClip;
      
      public function BackToYouthMapManager()
      {
         super();
      }
      
      public static function get instence() : BackToYouthMapManager
      {
         if(_instence == null)
         {
            _instence = new BackToYouthMapManager();
         }
         return _instence;
      }
      
      private function backToYouthReward(e:SystemEvent) : void
      {
         this._npcMC.visible = false;
         ActivityTmpDataManager.getMagicWater = false;
         trace("************************恢復青春獲得獎勵");
         BC.addEvent(this,GV.onlineSocket,"read_" + CommandID.TreasureBowl,this.infoBack1242);
         superlamuPartySocket.treasurebowl(238);
      }
      
      private function infoBack1242(e:EventTaomee) : void
      {
         var msg:String = null;
         BC.removeEvent(this,GV.onlineSocket,"read_" + CommandID.TreasureBowl,this.infoBack1242);
         var infoObj:Object = e.EventObj;
         if(infoObj.type == 238)
         {
            msg = GoodsInfo.getItemNameByID(infoObj.itemId) + "x" + infoObj.count;
            Alert.smileAlart("恭喜你獲得" + msg + "。");
         }
      }
      
      private function backToYouthOver(e:SystemEvent) : void
      {
         var index:uint = Math.ceil(Math.random() * 5);
         NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(501 + index));
      }
      
      private function takeTheMedicine(e:SystemEvent) : void
      {
         trace("************************恢復青春播放動畫");
         this._npcMC.gotoAndPlay(1);
         setTimeout(function():void
         {
            _npcMC.gotoAndStop(_npcMC.totalFrames - 2);
            NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(501));
         },2100);
      }
      
      protected function onClickNPC(event:MouseEvent) : void
      {
         NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(500));
      }
      
      public function initView(mc:MovieClip) : void
      {
         this._npcMC = mc;
         this._npcMC.gotoAndStop(1);
         this._getMagicWater = ActivityTmpDataManager.getMagicWater;
         if(this._getMagicWater && ActivityTmpDataManager.randomMapID == MapManager.curMapID)
         {
            this._npcMC.buttonMode = true;
            SystemEventManager.addEventListener("takeTheMedicine",this.takeTheMedicine);
            SystemEventManager.addEventListener("backToYouthOver",this.backToYouthOver);
            SystemEventManager.addEventListener("backToYouthReward",this.backToYouthReward);
            this._npcMC.addEventListener(MouseEvent.CLICK,this.onClickNPC);
         }
         else
         {
            this._npcMC.visible = false;
         }
      }
   }
}

