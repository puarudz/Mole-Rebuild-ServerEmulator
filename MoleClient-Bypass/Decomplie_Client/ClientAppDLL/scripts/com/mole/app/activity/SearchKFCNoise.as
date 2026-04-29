package com.mole.app.activity
{
   import com.common.Alert.Alert;
   import com.common.util.DisplayUtil;
   import com.event.EventTaomee;
   import com.logic.mapEvent.MapEvent;
   import com.mole.app.manager.BufferManager;
   import com.mole.app.manager.ModuleManager;
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
   
   public class SearchKFCNoise
   {
      
      private static var _inst:SearchKFCNoise;
      
      private var mapIDVec:Vector.<uint> = new <uint>[147,17,203];
      
      private var taskStep:Vector.<uint> = new <uint>[2,3,4];
      
      private var prizeIDVec:Vector.<uint> = new <uint>[2668,2669,2670];
      
      private var prizeTip:Vector.<String> = new <String>["　　聰明的小摩爾，恭喜你獲得一個密碼，還有兩個哦，快點再找找吧。","　　聰明的小摩爾，恭喜你獲得一個密碼，還有一個哦，快點再找找吧。","　　恭喜集齊所有密碼！"];
      
      private var _totemStep:uint;
      
      private var mc:DisplayObject;
      
      public function SearchKFCNoise()
      {
         super();
      }
      
      public static function getInst() : SearchKFCNoise
      {
         if(!_inst)
         {
            _inst = new SearchKFCNoise();
         }
         return _inst;
      }
      
      public function setUp() : void
      {
         for(var i:uint = 0; i < this.mapIDVec.length; i++)
         {
            if(this.mapIDVec[i] == MapManager.curMapID)
            {
               BufferManager.addBufferEvent(BufferManager.KFC_DISAPPLE_NOISE_STEP,this.teoStepHandle);
               BufferManager.getBuffer(BufferManager.KFC_DISAPPLE_NOISE_STEP);
            }
         }
      }
      
      private function teoStepHandle(e:EventTaomee) : void
      {
         BufferManager.removeBufferEvent(BufferManager.KFC_DISAPPLE_NOISE_STEP,this.teoStepHandle);
         this._totemStep = uint(e.EventObj);
         if(this._totemStep == 1 && MapManager.curMapID == this.mapIDVec[this._totemStep - 1])
         {
            this.addPainting();
         }
         else if(this._totemStep == 2 && MapManager.curMapID == this.mapIDVec[this._totemStep - 1])
         {
            this.addPainting();
         }
         else if(this._totemStep == 3 && MapManager.curMapID == this.mapIDVec[this._totemStep - 1])
         {
            this.addPainting();
         }
      }
      
      private function addPainting() : void
      {
         CacheManager.getPhasorContent(URLUtil.getSearchSomethingUrl(5),"LU_KFC" + this._totemStep,this.loadComplete);
      }
      
      private function loadComplete(contentInfo:ContentInfo) : void
      {
         this.mc = contentInfo.content;
         if(Boolean(MapManageView.inst.mapLevel.controlLevel))
         {
            this.mc.x = 400;
            this.mc.y = 400;
            MovieClip(MapManageView.inst.mapLevel.controlLevel).addChild(this.mc);
            TipsManager.addTextTips(this.mc,"尋找的密碼");
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
         BufferManager.setBuffer(BufferManager.KFC_DISAPPLE_NOISE_STEP,this._totemStep);
         trace("點到了");
         DisplayUtil.removeForParent(this.mc);
         if(this._totemStep < 4)
         {
            Alert.smileAlart(this.prizeTip[this._totemStep - 2]);
         }
         else
         {
            Alert.smileAlart("小摩爾，恭喜你找到了所有的密碼，現在就告訴你一個秘密吧！！",function():void
            {
               ModuleManager.openPanel("KFCKulaClickPanel");
            });
         }
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

