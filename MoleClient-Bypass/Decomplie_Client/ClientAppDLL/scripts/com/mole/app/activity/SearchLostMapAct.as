package com.mole.app.activity
{
   import com.common.Alert.Alert;
   import com.common.util.DisplayUtil;
   import com.event.EventTaomee;
   import com.logic.mapEvent.MapEvent;
   import com.logic.socket.CSItems.exchange;
   import com.mole.app.info.SearchSomethingInfo;
   import com.mole.app.manager.BufferManager;
   import com.mole.app.manager.TipsManager;
   import com.mole.app.map.MapManager;
   import com.mole.app.utils.PlayMovie;
   import com.mole.utils.URLUtil;
   import com.taomee.mole.cache.CacheManager;
   import com.view.MapManageView.MapManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.loader.ContentInfo;
   
   public class SearchLostMapAct
   {
      
      private static var _inst:SearchLostMapAct;
      
      private const EXCHANGETYPE:Vector.<uint> = new <uint>[3098,3099,3100,3101,3102,3103,3104];
      
      private const MAPVEC:Vector.<uint> = new <uint>[18,240,15,78,53,330,70];
      
      private const mapItemX:Vector.<uint> = new <uint>[781,133,719,282,270,585,677];
      
      private const mapItemY:Vector.<uint> = new <uint>[274,325,222,266,265,254,208];
      
      private var _itemIndex:uint;
      
      private var curIndex:uint;
      
      private var correctMc:MovieClip;
      
      private var mc:MovieClip;
      
      private var movie:PlayMovie;
      
      public function SearchLostMapAct()
      {
         super();
      }
      
      public static function getInst() : SearchLostMapAct
      {
         if(!_inst)
         {
            _inst = new SearchLostMapAct();
         }
         return _inst;
      }
      
      public function setUp() : void
      {
         this._itemIndex = CheckItemNum.inst.curItemIndex;
         if(this._itemIndex == 0)
         {
            return;
         }
         this.curIndex = this._itemIndex - 1;
         if(MapManager.curMapID == this.MAPVEC[this.curIndex])
         {
            CacheManager.getPhasorContent(URLUtil.getSearchSomethingUrl(9),"item_1",this.searchCorrect);
         }
         else
         {
            CacheManager.getPhasorContent(URLUtil.getSearchSomethingUrl(9),"item_0",this.loadComplete);
         }
      }
      
      private function searchCorrect(contentInfo:ContentInfo) : void
      {
         this.correctMc = contentInfo.content;
         var itemInfo:SearchSomethingInfo = contentInfo.data;
         if(Boolean(MapManageView.inst.mapLevel.controlLevel))
         {
            this.correctMc.x = this.mapItemX[this.curIndex];
            this.correctMc.y = this.mapItemY[this.curIndex];
            MovieClip(MapManageView.inst.mapLevel.controlLevel).addChild(this.correctMc);
            TipsManager.addTextTips(this.correctMc,"找到失落的物品");
            this.correctMc.addEventListener(MouseEvent.CLICK,this.onClickPic);
            if(this.correctMc is MovieClip)
            {
               MovieClip(this.correctMc).buttonMode = true;
            }
         }
      }
      
      private function loadComplete(contentInfo:ContentInfo) : void
      {
         this.mc = contentInfo.content;
         var itemInfo:SearchSomethingInfo = contentInfo.data;
         if(Boolean(MapManageView.inst.mapLevel.controlLevel))
         {
            this.mc.x = 856;
            this.mc.y = 250;
            MovieClip(MapManageView.inst.mapLevel.controlLevel).addChild(this.mc);
            TipsManager.addTextTips(this.mc,"召喚小精靈");
            this.mc.addEventListener(MouseEvent.CLICK,this.shostHelp);
            if(this.mc is MovieClip)
            {
               MovieClip(this.mc).buttonMode = true;
            }
         }
      }
      
      private function onClickPic(e:Event) : void
      {
         DisplayUtil.removeForParent(this.correctMc);
         var swapType:uint = this._itemIndex - 1;
         BC.addEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.searchSuc);
         exchange.exchange_goods(this.EXCHANGETYPE[swapType]);
         trace("點到了");
      }
      
      private function searchSuc(e:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.searchSuc);
         BufferManager.setBuffer(BufferManager.CHECK_ITEM_INDEX,0);
         CheckItemNum.inst.getItemArr();
         Alert.smileAlart("  謝謝小摩爾幫聖誕老人找到遺落的禮物哦~");
      }
      
      private function shostHelp(e:Event) : void
      {
         var str:String = "resource/lucas/20131218/smallGhost/" + this._itemIndex + ".swf";
         if(Boolean(this.movie))
         {
            if(this.movie.actived)
            {
               return;
            }
         }
         this.movie = PlayMovie.play(str,null,null,function():void
         {
            movie.destroy();
         },null,null,false);
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

