package com.mole.app.activity
{
   import com.common.util.DisplayUtil;
   import com.event.EventTaomee;
   import com.logic.mapEvent.MapEvent;
   import com.module.activityModule.Presented;
   import com.mole.app.manager.QueryItemCntManager;
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
   
   public class SearchSeedAct
   {
      
      private static var _inst:SearchSeedAct;
      
      private var mapIDVec:Vector.<uint> = new <uint>[9,355,112,80,41,204,10];
      
      private var itemXVec:Vector.<uint> = new <uint>[242,874,114,638,437,234,160];
      
      private var itemYVec:Vector.<uint> = new <uint>[338,218,357,290,316,269,363];
      
      private var prizeIDVec:Vector.<uint> = new <uint>[3081,3082,3083,3084,3085,3086,3087];
      
      private var dayTypeVec:Vector.<uint> = new <uint>[31658,31659,31660,31661,31662,31663,31664];
      
      private var prizeTip:Vector.<String> = new <String>["　　得到密碼碎片2，碎片指向海妖王寶藏區域.","　　得到密碼碎片3，碎片指向摩羅島山洞。","　　得到密碼碎片4，恭喜集齊所有碎片,獲得綠色探險燈，快去破譯密碼吧！"];
      
      private var dayTypeQuery:QueryItemCntManager;
      
      private var _mapIndex:uint;
      
      private var mc:DisplayObject;
      
      public function SearchSeedAct()
      {
         super();
      }
      
      public static function getInst() : SearchSeedAct
      {
         if(!_inst)
         {
            _inst = new SearchSeedAct();
         }
         return _inst;
      }
      
      public function setUp() : void
      {
         for(var i:uint = 0; i < this.mapIDVec.length; i++)
         {
            if(this.mapIDVec[i] == MapManager.curMapID)
            {
               this._mapIndex = i;
               this.addPainting();
               break;
            }
         }
      }
      
      private function addPainting() : void
      {
         var itemIndex:uint = this._mapIndex + 1;
         if(!this.dayTypeQuery)
         {
            this.dayTypeQuery = new QueryItemCntManager();
         }
         if(this._mapIndex == 1 || this._mapIndex == 2 || this._mapIndex == 3 || this._mapIndex == 4)
         {
            CacheManager.getPhasorContent(URLUtil.getSearchSomethingUrl(8),"item_" + itemIndex,this.loadComplete);
         }
         else
         {
            this.dayTypeQuery.addEventListener(QueryItemCntManager.DayTYPE_QUERY,this.dayTypeHandle);
            this.dayTypeQuery.dayTypeQuery(this.dayTypeVec[this._mapIndex]);
         }
      }
      
      private function dayTypeHandle(e:EventTaomee) : void
      {
         var itemIndex:uint = this._mapIndex + 1;
         this.dayTypeQuery.removeEventListener(QueryItemCntManager.DayTYPE_QUERY,this.dayTypeHandle);
         var times:uint = uint(e.EventObj);
         if(times < 3)
         {
            CacheManager.getPhasorContent(URLUtil.getSearchSomethingUrl(8),"item_" + itemIndex,this.loadComplete);
         }
      }
      
      private function loadComplete(contentInfo:ContentInfo) : void
      {
         this.mc = contentInfo.content;
         if(Boolean(MapManageView.inst.mapLevel.controlLevel))
         {
            this.mc.x = this.itemXVec[this._mapIndex];
            this.mc.y = this.itemYVec[this._mapIndex];
            MovieClip(MapManageView.inst.mapLevel.controlLevel).addChild(this.mc);
            TipsManager.addTextTips(this.mc,"尋找的物品");
            this.mc.addEventListener(MouseEvent.CLICK,this.onClickPic);
            if(this.mc is MovieClip)
            {
               MovieClip(this.mc).buttonMode = true;
            }
         }
      }
      
      private function onClickPic(e:Event) : void
      {
         DisplayUtil.removeForParent(this.mc);
         Presented.getInstance().celebrate1225(this.prizeIDVec[this._mapIndex]);
      }
      
      private function getPrize(e:Event) : void
      {
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

