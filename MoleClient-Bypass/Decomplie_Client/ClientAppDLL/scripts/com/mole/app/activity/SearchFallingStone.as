package com.mole.app.activity
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.util.DisplayUtil;
   import com.global.staticData.CommandID;
   import com.logic.mapEvent.MapEvent;
   import com.mole.app.info.SearchSomethingInfo;
   import com.mole.app.manager.TipsManager;
   import com.mole.app.map.MapManager;
   import com.mole.app.utils.PlayMovie;
   import com.mole.utils.URLUtil;
   import com.taomee.mole.cache.CacheManager;
   import com.view.MapManageView.MapManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import org.taomee.loader.ContentInfo;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.Tick;
   
   public class SearchFallingStone
   {
      
      private static var _inst:SearchFallingStone;
      
      private const MAPVEC:Vector.<uint> = new <uint>[372,373,374,375,376,377,378,379,380,8,355,6];
      
      private var curIndex:uint;
      
      private var bitIndex:uint;
      
      private var correctMc:MovieClip;
      
      private var bitArr:Array;
      
      private var loadNum:uint;
      
      public function SearchFallingStone()
      {
         super();
      }
      
      public static function getInst() : SearchFallingStone
      {
         if(!_inst)
         {
            _inst = new SearchFallingStone();
         }
         return _inst;
      }
      
      public function setUp() : void
      {
         for(var i:uint = 0; i < this.MAPVEC.length; i++)
         {
            if(MapManager.curMapID == this.MAPVEC[i])
            {
               GV.onlineSocket.addEventListener(MapEvent.READY_CHANGE_MAP,this.clearAll);
               this.curIndex = i + 1;
               GV.onlineSocket.addCmdListener(CommandID.STAR_RAIN_GET_PRIZE,this.prizeHandle);
               GV.onlineSocket.addCmdListener(CommandID.STAR_RAIN_ENTER_MAP,this.typeHandle);
               GF.sendSocket(CommandID.STAR_RAIN_ENTER_MAP,0,this.curIndex);
               break;
            }
         }
      }
      
      private function prizeHandle(e:SocketEvent) : void
      {
         var i:uint = 0;
         var bitBool:Boolean = false;
         var itemID:uint = 0;
         var itemCnt:uint = 0;
         var data:ByteArray = e.data as ByteArray;
         data.position = 0;
         var state:uint = data.readUnsignedInt();
         var stoneState:uint = data.readUnsignedInt();
         if(state == 2)
         {
            this.bitArr = new Array();
            for(i = 0; i < 5; i++)
            {
               bitBool = Boolean(1 << i & stoneState);
               this.bitArr.push(bitBool);
            }
            Tick.instance.addRender(this.loadItem,450);
         }
         var cnt:uint = data.readUnsignedInt();
         var msg:String = "恭喜你獲得";
         for(i = 0; i < cnt; i++)
         {
            itemID = data.readUnsignedInt();
            itemCnt = data.readUnsignedInt();
            msg += itemCnt + "個" + GoodsInfo.getItemNameByID(itemID) + " ";
         }
         if(cnt != 0)
         {
            Alert.smileAlart(msg);
         }
      }
      
      private function loadItem(delay:Number) : void
      {
         if(this.bitIndex < 5)
         {
            ++this.bitIndex;
            CacheManager.getPhasorContent(URLUtil.getSearchSomethingUrl(13),"item_1",this.searchCorrect);
         }
         else
         {
            Tick.instance.removeRender(this.loadItem);
            this.bitIndex = 0;
         }
      }
      
      private function searchCorrect(contentInfo:ContentInfo) : void
      {
         var curBit:uint = 0;
         var str:String = null;
         curBit = this.bitIndex - 1;
         this.correctMc = contentInfo.content;
         var itemInfo:SearchSomethingInfo = contentInfo.data;
         if(Boolean(MapManageView.inst.mapLevel.topLevel))
         {
            str = "MAPArr" + this.curIndex;
            this.correctMc.x = FallingStoneConfig[str][curBit][0];
            this.correctMc.y = FallingStoneConfig[str][curBit][1];
            this.correctMc.name = "falling" + curBit;
            MovieClip(MapManageView.inst.mapLevel.topLevel).addChild(this.correctMc);
            TipsManager.addTextTips(this.correctMc,"找到失落的星星");
            this.correctMc.addEventListener(MouseEvent.CLICK,this.onClickPic);
            if(this.correctMc is MovieClip)
            {
               MovieClip(this.correctMc).buttonMode = true;
            }
         }
      }
      
      private function onClickPic(e:Event) : void
      {
         var picIndex:uint = uint(String(e.currentTarget.name).slice(7));
         trace("點到了");
         var target:MovieClip = e.currentTarget as MovieClip;
         DisplayUtil.removeForParent(target);
         GF.sendSocket(CommandID.STAR_RAIN_GET_PRIZE,1,this.curIndex,picIndex);
      }
      
      private function typeHandle(e:SocketEvent) : void
      {
         var flag:uint;
         var state:uint;
         var movieFlag:uint;
         var movie:PlayMovie = null;
         var data:ByteArray = e.data as ByteArray;
         data.position = 0;
         flag = data.readUnsignedInt();
         state = data.readUnsignedInt();
         movieFlag = data.readUnsignedInt();
         if(flag == 0)
         {
            if(movieFlag == 0)
            {
               trace("播動畫");
               movie = PlayMovie.play("resource/lucas/20140410/fullCartoon.swf",null,null,function():void
               {
                  movie.destroy();
                  GF.sendSocket(CommandID.STAR_RAIN_ENTER_MAP,1,curIndex);
                  GF.sendSocket(CommandID.STAR_RAIN_GET_PRIZE,0,curIndex,0);
               });
            }
            else if(movieFlag == 1)
            {
               trace("不播動畫");
               GF.sendSocket(CommandID.STAR_RAIN_GET_PRIZE,0,this.curIndex,0);
            }
         }
         else if(flag == 1)
         {
         }
      }
      
      private function clearAll(e:*) : void
      {
         this.bitIndex = 0;
         this.curIndex = 0;
         this.bitIndex = 0;
         this.bitArr = null;
         this.loadNum = 0;
         GV.onlineSocket.removeCmdListener(CommandID.STAR_RAIN_GET_PRIZE,this.prizeHandle);
         GV.onlineSocket.removeEventListener(MapEvent.READY_CHANGE_MAP,this.clearAll);
      }
   }
}

