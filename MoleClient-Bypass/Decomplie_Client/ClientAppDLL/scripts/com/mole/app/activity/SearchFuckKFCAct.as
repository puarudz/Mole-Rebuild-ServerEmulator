package com.mole.app.activity
{
   import com.common.Alert.Alert;
   import com.common.util.DisplayUtil;
   import com.event.EventTaomee;
   import com.logic.mapEvent.MapEvent;
   import com.mole.app.manager.BufferManager;
   import com.mole.app.manager.TipsManager;
   import com.mole.app.map.MapManager;
   import com.mole.app.task.TaskManager;
   import com.mole.utils.URLUtil;
   import com.taomee.mole.cache.CacheManager;
   import com.view.MapManageView.MapManageView;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.loader.ContentInfo;
   
   public class SearchFuckKFCAct
   {
      
      private static var _inst:SearchFuckKFCAct;
      
      private var mapIDVec:Vector.<uint> = new <uint>[84,57,328,6,237,203];
      
      private var taskStep:Vector.<uint> = new <uint>[1,2,3,4,5,6];
      
      private var targetXVec:Vector.<uint> = new <uint>[222,377,538,775,519,641];
      
      private var targetYVec:Vector.<uint> = new <uint>[447,377,446,475,532,458];
      
      private var itemName:Vector.<String> = new <String>["LU_KFCKey","LU_KFCTu","LU_KFCBox","LU_KFCKey","LU_KFCTu","LU_KFCBox"];
      
      private var tipsVec:Vector.<String> = new <String>["神秘鑰匙","神秘藏寶圖","神秘寶盒","神秘鑰匙","神秘藏寶圖","神秘寶盒"];
      
      private var prizeTip:Vector.<String> = new <String>["　　恭喜你撿到了偵探物品1個，還剩5個，去其他地方再找找吧","　　恭喜你撿到了偵探物品1個，還剩4個，去其他地方再找找吧","　　恭喜你撿到了偵探物品1個，還剩3個，去其他地方再找找吧","　　恭喜你撿到了偵探物品1個，還剩2個，去其他地方再找找吧","　　恭喜你撿到了偵探物品1個，還剩1個，去其他地方再找找吧","　　恭喜你收集齊了偵探物品，快去找奇可兌換吧！"];
      
      private var _totemStep:uint;
      
      private var mc:DisplayObject;
      
      public function SearchFuckKFCAct()
      {
         super();
      }
      
      public static function getInst() : SearchFuckKFCAct
      {
         if(!_inst)
         {
            _inst = new SearchFuckKFCAct();
         }
         return _inst;
      }
      
      public function setUp() : void
      {
         for(var i:uint = 0; i < this.mapIDVec.length; i++)
         {
            if(this.mapIDVec[i] == MapManager.curMapID)
            {
               BufferManager.addBufferEvent(BufferManager.KFC_SPY_SMALL_CLERK_STEP,this.teoStepHandle);
               BufferManager.getBuffer(BufferManager.KFC_SPY_SMALL_CLERK_STEP);
            }
         }
      }
      
      private function teoStepHandle(e:EventTaomee) : void
      {
         BufferManager.removeBufferEvent(BufferManager.KFC_SPY_SMALL_CLERK_STEP,this.teoStepHandle);
         this._totemStep = uint(e.EventObj);
         if(this._totemStep < 6)
         {
            if(MapManager.curMapID == this.mapIDVec[this._totemStep])
            {
               this.addPainting();
            }
         }
      }
      
      private function addPainting() : void
      {
         CacheManager.getPhasorContent(URLUtil.getSearchSomethingUrl(4),this.itemName[this._totemStep],this.loadComplete);
      }
      
      private function loadComplete(contentInfo:ContentInfo) : void
      {
         this.mc = contentInfo.content;
         if(Boolean(MapManageView.inst.mapLevel.controlLevel))
         {
            this.mc.x = this.targetXVec[this._totemStep];
            this.mc.y = this.targetYVec[this._totemStep];
            MovieClip(MapManageView.inst.mapLevel.controlLevel).addChild(this.mc);
            TipsManager.addTextTips(this.mc,this.tipsVec[this._totemStep]);
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
         BufferManager.setBuffer(BufferManager.KFC_SPY_SMALL_CLERK_STEP,this._totemStep);
         trace("點到了");
         DisplayUtil.removeForParent(this.mc);
         this.getPrize();
      }
      
      private function getPrize() : void
      {
         Alert.smileAlart(this.prizeTip[this._totemStep - 1]);
         if(TaskManager.getTask(595).state == 0)
         {
            TaskManager.applyTask(595);
            TaskManager.getTask(595).state == 1;
         }
         TaskManager.getTask(595).setBit(this._totemStep);
      }
      
      private function clearAll(e:EventTaomee) : void
      {
         this.destroy();
      }
      
      public function destroy() : void
      {
         BufferManager.removeBufferEvent(BufferManager.KFC_SPY_SMALL_CLERK_STEP,this.teoStepHandle);
         BC.removeEvent(this);
         GV.onlineSocket.removeEventListener(MapEvent.READY_CHANGE_MAP,this.destroy);
      }
   }
}

