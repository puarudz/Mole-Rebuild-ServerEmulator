package com.mole.app.activity
{
   import com.common.Alert.Alert;
   import com.common.util.DisplayUtil;
   import com.event.EventTaomee;
   import com.logic.mapEvent.MapEvent;
   import com.logic.socket.CSItems.exchange;
   import com.mole.app.manager.BufferManager;
   import com.mole.app.manager.TipsManager;
   import com.mole.app.map.MapManager;
   import com.mole.utils.URLUtil;
   import com.taomee.mole.cache.CacheManager;
   import com.view.MapManageView.MapManageView;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.loader.ContentInfo;
   
   public class SearchTotemAct
   {
      
      private static var _inst:SearchTotemAct;
      
      private var mapIDVec:Vector.<uint> = new <uint>[240,264,183];
      
      private var taskStep:Vector.<uint> = new <uint>[3,4,5];
      
      private var prizeIDVec:Vector.<uint> = new <uint>[2668,2669,2670];
      
      private var prizeTip:Vector.<String> = new <String>["　　得到密碼碎片2，碎片指向海妖王寶藏區域.","　　得到密碼碎片3，碎片指向摩羅島山洞。","　　得到密碼碎片4，恭喜集齊所有碎片,獲得綠色探險燈，快去破譯密碼吧！"];
      
      private var _totemStep:uint;
      
      private var mc:DisplayObject;
      
      public function SearchTotemAct()
      {
         super();
      }
      
      public static function getInst() : SearchTotemAct
      {
         if(!_inst)
         {
            _inst = new SearchTotemAct();
         }
         return _inst;
      }
      
      public function setUp() : void
      {
         for(var i:uint = 0; i < this.mapIDVec.length; i++)
         {
            if(this.mapIDVec[i] == MapManager.curMapID)
            {
               BufferManager.addBufferEvent(BufferManager.TOTEM_TASK_STEP,this.teoStepHandle);
               BufferManager.getBuffer(BufferManager.TOTEM_TASK_STEP);
            }
         }
      }
      
      private function teoStepHandle(e:EventTaomee) : void
      {
         BufferManager.removeBufferEvent(BufferManager.TOTEM_TASK_STEP,this.teoStepHandle);
         this._totemStep = uint(e.EventObj);
         if(this._totemStep == 3 && MapManager.curMapID == this.mapIDVec[this._totemStep - 3])
         {
            this.addPainting();
         }
         else if(this._totemStep == 4 && MapManager.curMapID == this.mapIDVec[this._totemStep - 3])
         {
            this.addPainting();
         }
         else if(this._totemStep == 5 && MapManager.curMapID == this.mapIDVec[this._totemStep - 3])
         {
            this.addPainting();
         }
      }
      
      private function addPainting() : void
      {
         CacheManager.getPhasorContent(URLUtil.getSearchSomethingUrl(3),"LUtotem",this.loadComplete);
      }
      
      private function loadComplete(contentInfo:ContentInfo) : void
      {
         this.mc = contentInfo.content;
         if(Boolean(MapManageView.inst.mapLevel.controlLevel))
         {
            this.mc.x = 400;
            this.mc.y = 400;
            MovieClip(MapManageView.inst.mapLevel.controlLevel).addChild(this.mc);
            TipsManager.addTextTips(this.mc,"尋找的碎片");
            this.mc.addEventListener(MouseEvent.CLICK,this.onClickPic);
            if(this.mc is MovieClip)
            {
               MovieClip(this.mc).buttonMode = true;
            }
         }
      }
      
      private function onClickPic(e:Event) : void
      {
         var _erSetp:uint = this._totemStep++;
         BufferManager.setBuffer(BufferManager.TOTEM_TASK_STEP,this._totemStep);
         trace("點到了");
         DisplayUtil.removeForParent(this.mc);
         BC.addEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.getPrize);
         exchange.exchange_goods(this.prizeIDVec[this._totemStep - 4]);
      }
      
      private function getPrize(e:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.getPrize);
         Alert.smileAlart(this.prizeTip[this._totemStep - 4]);
      }
      
      private function clearAll(e:EventTaomee) : void
      {
         this.destroy();
      }
      
      public function destroy() : void
      {
         BC.removeEvent(this);
         GV.onlineSocket.removeEventListener(MapEvent.READY_CHANGE_MAP,this.destroy);
      }
   }
}

