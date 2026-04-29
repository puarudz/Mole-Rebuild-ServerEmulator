package com.mole.app.activity
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.util.DisplayUtil;
   import com.common.util.MovieClipUtil;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.mapEvent.MapEvent;
   import com.logic.socket.CSItems.exchange;
   import com.logic.socket.superlamuParty.superlamuPartySocket;
   import com.module.throwThing.throwHitTest;
   import com.mole.app.info.SearchSomethingInfo;
   import com.mole.app.manager.BufferManager;
   import com.mole.app.map.MapManager;
   import com.mole.app.utils.PlayMovie;
   import com.mole.utils.URLUtil;
   import com.taomee.mole.cache.CacheManager;
   import com.view.MapManageView.MapManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import org.taomee.loader.ContentInfo;
   
   public class SearchBangerMapAct
   {
      
      private static var _inst:SearchBangerMapAct;
      
      private const EXCHANGETYPE:uint = 190;
      
      private const DAYTYPE:uint = 30142;
      
      private const MAPVEC:Vector.<uint> = new <uint>[1,10,9,77,6];
      
      private const mapItemX:Vector.<uint> = new <uint>[345,172,331,520,313];
      
      private const mapItemY:Vector.<uint> = new <uint>[277,234,280,207,218];
      
      private var _itemIndex:uint;
      
      private var curIndex:uint;
      
      private const THROWID:uint = 150026;
      
      private var correctMc:MovieClip;
      
      private var movie:PlayMovie;
      
      public function SearchBangerMapAct()
      {
         super();
      }
      
      public static function getInst() : SearchBangerMapAct
      {
         if(!_inst)
         {
            _inst = new SearchBangerMapAct();
         }
         return _inst;
      }
      
      public function setUp() : void
      {
         for(var i:uint = 0; i < this.MAPVEC.length; i++)
         {
            if(MapManager.curMapID == this.MAPVEC[i])
            {
               this.curIndex = i;
               CacheManager.getPhasorContent(URLUtil.getSearchSomethingUrl(11),"item_1",this.searchCorrect);
               break;
            }
         }
      }
      
      private function searchCorrect(contentInfo:ContentInfo) : void
      {
         var obj:Object = null;
         this.correctMc = contentInfo.content;
         var itemInfo:SearchSomethingInfo = contentInfo.data;
         if(Boolean(MapManageView.inst.mapLevel.topLevel))
         {
            this.correctMc.x = this.mapItemX[this.curIndex];
            this.correctMc.y = this.mapItemY[this.curIndex];
            MovieClip(MapManageView.inst.mapLevel.topLevel).addChild(this.correctMc);
            if(this.correctMc is MovieClip)
            {
               MovieClip(this.correctMc).buttonMode = true;
            }
            BC.addEvent(this,GV.onlineSocket,throwHitTest.HITTEST_SUC_FLOWER,this.hitOver,false,0,true);
            obj = {
               "btn":this.correctMc,
               "mc":new MovieClip(),
               "id":"swf150026",
               "fre":1,
               "hide":true
            };
            throwHitTest.HitTestMC(obj);
         }
      }
      
      private function hitOver(e:EventTaomee) : void
      {
         if(e.EventObj.mc.userID == LocalUserInfo.getUserID() && e.EventObj.mc.ThrowID == this.THROWID)
         {
            this.correctMc.gotoAndPlay(2);
            MovieClipUtil.playEndAndFunc(this.correctMc,function():void
            {
               DisplayUtil.removeForParent(correctMc);
               BC.addEvent(this,GV.onlineSocket,"read_" + CommandID.TreasureBowl,GetRandomGift);
               superlamuPartySocket.treasurebowl(EXCHANGETYPE);
            });
            trace("點到了");
         }
      }
      
      private function GetRandomGift(e:EventTaomee) : void
      {
         if(e.EventObj.type == this.EXCHANGETYPE)
         {
            BC.removeEvent(this,GV.onlineSocket,"read_" + CommandID.TreasureBowl,this.GetRandomGift);
            Alert.smileAlart("    恭喜你獲得" + GoodsInfo.getItemNameByID(e.EventObj.itemId));
         }
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

