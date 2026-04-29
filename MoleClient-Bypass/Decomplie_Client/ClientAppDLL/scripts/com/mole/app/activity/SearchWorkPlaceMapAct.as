package com.mole.app.activity
{
   import com.common.Alert.Alert;
   import com.event.EventTaomee;
   import com.logic.mapEvent.MapEvent;
   import com.logic.socket.CSItems.exchange;
   import com.mole.app.info.SearchSomethingInfo;
   import com.mole.app.manager.QueryItemCntManager;
   import com.mole.app.manager.TipsManager;
   import com.mole.app.map.MapManager;
   import com.mole.app.task.TaskManager;
   import com.mole.app.utils.PlayMovie;
   import com.mole.app.utils.Tool;
   import com.mole.utils.URLUtil;
   import com.taomee.mole.cache.CacheManager;
   import com.view.MapManageView.MapManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.loader.ContentInfo;
   
   public class SearchWorkPlaceMapAct
   {
      
      private static var _inst:SearchWorkPlaceMapAct;
      
      public static const decorate_map_prizeE_type_arr:Array = [1351777,1351778,1351779,1351780];
      
      public static const DECORATE_MAP_DAYTYPE:uint = 31752;
      
      private static const MAPPRIZETYPE:Array = [3416,3417,3418,3419];
      
      private const MAPVEC:Array = [10,1,3,2];
      
      private const NEWMAPVEC:Array = [385,386,387,388];
      
      private const MALitPVEC:Array = [4,5,5,4];
      
      private const mapItemX:Vector.<uint> = new <uint>[455,315,415,310];
      
      private const mapItemY:Vector.<uint> = new <uint>[445,435,440,415];
      
      private var mapIndex:uint;
      
      private var _iceMc:MovieClip;
      
      private var _animalPrizeState:uint;
      
      private var _query:QueryItemCntManager;
      
      private var correctMc:MovieClip;
      
      public function SearchWorkPlaceMapAct()
      {
         super();
      }
      
      public static function getInst() : SearchWorkPlaceMapAct
      {
         if(!_inst)
         {
            _inst = new SearchWorkPlaceMapAct();
         }
         return _inst;
      }
      
      public function setUp() : void
      {
         for(var i:uint = 0; i < this.MAPVEC.length; i++)
         {
            if(this.MAPVEC[i] == MapManager.curMapID)
            {
               if(!(i == 1 && TaskManager.getTask(643).buffer.step == 4 && TaskManager.getTask(643).state == 1))
               {
                  GV.onlineSocket.addEventListener(MapEvent.READY_CHANGE_MAP,this.clearAll);
                  this.mapIndex = i;
                  this._query = new QueryItemCntManager();
                  this._query.addEventListener(QueryItemCntManager.SOMEGOODS_QUERY,this.someGoodsHandle);
                  this._query.someGoosQuery(decorate_map_prizeE_type_arr);
               }
               break;
            }
         }
      }
      
      private function someGoodsHandle(e:EventTaomee) : void
      {
         var _tarNumArr:Array = e.EventObj as Array;
         if(_tarNumArr[this.mapIndex] >= this.MALitPVEC[this.mapIndex])
         {
            MapManager.enterMap(this.NEWMAPVEC[this.mapIndex]);
         }
         else
         {
            CacheManager.getPhasorContent(URLUtil.getSearchSomethingUrl(14),"item_1",this.searchCorrect);
         }
      }
      
      private function searchCorrect(contentInfo:ContentInfo) : void
      {
         this.correctMc = contentInfo.content;
         var itemInfo:SearchSomethingInfo = contentInfo.data;
         if(Boolean(MapManageView.inst.mapLevel.topLevel))
         {
            this.correctMc.x = this.mapItemX[this.mapIndex];
            this.correctMc.y = this.mapItemY[this.mapIndex];
            MovieClip(MapManageView.inst.mapLevel.topLevel).addChild(this.correctMc);
            TipsManager.addTextTips(this.correctMc,"裝飾莊園");
            this.correctMc.addEventListener(MouseEvent.CLICK,this.onClickPic);
            if(this.correctMc is MovieClip)
            {
               MovieClip(this.correctMc).buttonMode = true;
            }
         }
      }
      
      private function onClickPic(e:Event) : void
      {
         Tool.finishSomething(31752,function(times:uint):void
         {
            var movie:PlayMovie = null;
            if(times < 6)
            {
               movie = PlayMovie.play("resource/lucas/20140425/" + MapManager.curMapID + ".swf",null,null,function():void
               {
                  trace("點到了");
                  movie.destroy();
                  exchange.exchange_goods(MAPPRIZETYPE[mapIndex],1,1);
                  _query.addEventListener(QueryItemCntManager.SOMEGOODS_QUERY,someGoodsHandle);
                  _query.someGoosQuery(decorate_map_prizeE_type_arr);
               });
            }
            else
            {
               Alert.angryAlart("今天次數用完了，明天繼續來裝飾莊園吧");
            }
         });
      }
      
      private function socksHandler(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.socksHandler);
         evt.stopPropagation();
      }
      
      private function clearAll(e:*) : void
      {
         GV.onlineSocket.removeEventListener(MapEvent.READY_CHANGE_MAP,this.destroy);
         this.destroy();
      }
      
      public function destroy() : void
      {
         BC.removeEvent(this);
      }
   }
}

