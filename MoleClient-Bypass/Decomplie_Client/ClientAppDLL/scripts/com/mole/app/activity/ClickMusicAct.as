package com.mole.app.activity
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.util.MovieClipUtil;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.mapEvent.MapEvent;
   import com.mole.app.map.MapManager;
   import com.view.MapManageView.MapManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ClickMusicAct
   {
      
      private static var _inst:ClickMusicAct;
      
      private const MAPVEC:Vector.<uint> = new <uint>[1,2,3];
      
      public function ClickMusicAct()
      {
         super();
      }
      
      public static function getInst() : ClickMusicAct
      {
         if(!_inst)
         {
            _inst = new ClickMusicAct();
         }
         return _inst;
      }
      
      public function setUp() : void
      {
         var j:uint = 0;
         for(var i:uint = 0; i < this.MAPVEC.length; i++)
         {
            if(this.MAPVEC[i] == MapManager.curMapID)
            {
               GV.onlineSocket.addEventListener(MapEvent.READY_CHANGE_MAP,this.clearAll);
               for(j = 0; MapManageView.inst.mapLevel.controlLevel["music" + j] != null; j++)
               {
                  MapManageView.inst.mapLevel.controlLevel["music" + j].buttonMode = true;
                  BC.addEvent(this,MapManageView.inst.mapLevel.controlLevel["music" + j],MouseEvent.CLICK,this.onClickMusic);
               }
               break;
            }
         }
      }
      
      private function onClickMusic(e:Event) : void
      {
         var musicMc:MovieClip = null;
         musicMc = e.currentTarget as MovieClip;
         musicMc.gotoAndPlay(2);
         musicMc.mouseChildren = false;
         musicMc.mouseEnabled = false;
         MovieClipUtil.playEndAndFunc(musicMc,function():void
         {
            musicMc.mouseChildren = true;
            musicMc.mouseEnabled = true;
            musicMc.gotoAndStop(1);
         });
      }
      
      private function back1242(e:EventTaomee) : void
      {
         var msg:String = null;
         var id:uint = 0;
         BC.removeEvent(this,GV.onlineSocket,"read_" + CommandID.TreasureBowl,this.back1242);
         var infoObj:Object = e.EventObj;
         if(infoObj.type == 219)
         {
            id = uint(infoObj.itemId);
            msg = infoObj.count + "個" + GoodsInfo.getItemNameByID(infoObj.itemId);
            Alert.smileAlart("  恭喜你獲得" + msg + "。");
         }
      }
      
      private function clearAll(e:*) : void
      {
         GV.onlineSocket.removeEventListener(MapEvent.READY_CHANGE_MAP,this.clearAll);
         this.destroy();
      }
      
      private function destroy() : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + CommandID.TreasureBowl,this.back1242);
         BC.removeEvent(this);
      }
   }
}

