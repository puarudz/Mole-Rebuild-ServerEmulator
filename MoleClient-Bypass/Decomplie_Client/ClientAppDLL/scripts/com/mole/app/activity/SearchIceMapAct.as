package com.mole.app.activity
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.util.DisplayUtil;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.mapEvent.MapEvent;
   import com.logic.socket.superlamuParty.superlamuPartySocket;
   import com.mole.app.info.SearchSomethingInfo;
   import com.mole.app.manager.NPCDialogManager;
   import com.mole.app.manager.QueryItemTool;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.manager.TipsManager;
   import com.mole.app.map.MapManager;
   import com.mole.debug.DebugManager;
   import com.mole.utils.URLUtil;
   import com.taomee.mole.cache.CacheManager;
   import com.view.MapManageView.MapManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import org.taomee.loader.ContentInfo;
   import org.taomee.net.SocketEvent;
   
   public class SearchIceMapAct
   {
      
      private static var _inst:SearchIceMapAct;
      
      private const MAPVEC:Vector.<uint> = new <uint>[1,3,2,10,9];
      
      private var typeVec:Vector.<uint> = new <uint>[221,223,224,225,226];
      
      private const mapItemX:Vector.<uint> = new <uint>[275,286,725,628,163];
      
      private const mapItemY:Vector.<uint> = new <uint>[221,119,190,177,259];
      
      private var mapIndex:uint;
      
      private var _iceMc:MovieClip;
      
      private var _animalPrizeState:uint;
      
      private var correctMc:MovieClip;
      
      public function SearchIceMapAct()
      {
         super();
      }
      
      public static function getInst() : SearchIceMapAct
      {
         if(!_inst)
         {
            _inst = new SearchIceMapAct();
         }
         return _inst;
      }
      
      public function setUp() : void
      {
         for(var i:uint = 0; i < this.MAPVEC.length; i++)
         {
            if(this.MAPVEC[i] == MapManager.curMapID)
            {
               GV.onlineSocket.addEventListener(MapEvent.READY_CHANGE_MAP,this.clearAll);
               this.mapIndex = i;
               GV.onlineSocket.addCmdListener(CommandID.HIDE_AND_SEEK_PRIZE,this.catchPrizeHandle);
               GF.sendSocket(CommandID.HIDE_AND_SEEK_PRIZE);
               break;
            }
         }
      }
      
      private function catchPrizeHandle(e:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.HIDE_AND_SEEK_PRIZE,this.catchPrizeHandle);
         var data:ByteArray = e.data as ByteArray;
         data.position = 0;
         var mapID:uint = data.readUnsignedInt();
         if(mapID == MapManager.curMapID)
         {
            QueryItemTool.dayTypeQuery(30167,this.checkTwenty);
         }
      }
      
      private function checkTwenty(dalay:uint) : void
      {
         if(dalay > 20)
         {
            trace("超過了領取次數20");
         }
         else
         {
            GV.onlineSocket.addCmdListener(CommandID.GODDESS_OVER_TASK,this.onQueryInfo);
            GF.sendSocket(CommandID.GODDESS_OVER_TASK,278);
         }
      }
      
      private function onQueryInfo(e:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.GODDESS_OVER_TASK,this.onQueryInfo);
         var recData:ByteArray = e.data as ByteArray;
         recData.position = 0;
         var preMapID:uint = recData.readUnsignedInt();
         var preTime:Number = recData.readUnsignedInt();
         var _curDate:Date = ServerUpTime.getInstance().chinaDate;
         var _curSecs:Number = Number(_curDate.time);
         var gapSecs:uint = _curSecs / 1000 - preTime;
         if(preMapID == MapManager.curMapID && gapSecs < 300)
         {
            DebugManager.traceMsg("上次找的也是這個地圖");
         }
         else
         {
            CacheManager.getPhasorContent(URLUtil.getSearchSomethingUrl(15),"item_" + this.mapIndex,this.searchCorrect);
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
            TipsManager.addTextTips(this.correctMc,"愛躲貓貓的小C");
            this.correctMc.addEventListener(MouseEvent.CLICK,this.onClickPic);
            if(this.correctMc is MovieClip)
            {
               MovieClip(this.correctMc).buttonMode = true;
            }
         }
      }
      
      private function onClickPic(e:Event) : void
      {
         trace("點到了");
         DisplayUtil.removeForParent(this.correctMc);
         SystemEventManager.addEventListener("xiaocfind",this.xiaocFindHandle);
         NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(3333));
      }
      
      private function xiaocFindHandle(e:*) : void
      {
         SystemEventManager.removeEventListener("xiaocfind",this.xiaocFindHandle);
         BC.addEvent(this,GV.onlineSocket,"read_" + CommandID.TreasureBowl,this.getRandomGiftTwo);
         superlamuPartySocket.treasurebowl(this.typeVec[this.mapIndex]);
      }
      
      private function getRandomGiftTwo(e:EventTaomee) : void
      {
         var msg:String = null;
         BC.removeEvent(this,GV.onlineSocket,"read_" + CommandID.TreasureBowl,this.getRandomGiftTwo);
         var infoObj:Object = e.EventObj;
         if(infoObj.type == this.typeVec[this.mapIndex])
         {
            if(infoObj.itemId == 0)
            {
               LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + infoObj.count);
            }
            msg = GoodsInfo.getItemNameByID(infoObj.itemId) + "x" + infoObj.count;
            Alert.smileAlart("恭喜你獲得" + msg + "。");
         }
      }
      
      private function clearAll(e:*) : void
      {
         GV.onlineSocket.removeEventListener(MapEvent.READY_CHANGE_MAP,this.destroy);
         this.destroy();
      }
      
      public function destroy() : void
      {
         SystemEventManager.removeEventListener("xiaocfind",this.xiaocFindHandle);
         GV.onlineSocket.removeCmdListener(CommandID.GODDESS_OVER_TASK,this.onQueryInfo);
         BC.removeEvent(this,GV.onlineSocket,"read_" + CommandID.TreasureBowl,this.getRandomGiftTwo);
         GV.onlineSocket.removeCmdListener(CommandID.CATCH_ANIMAL_PRIZE,this.catchPrizeHandle);
         BC.removeEvent(this);
      }
   }
}

