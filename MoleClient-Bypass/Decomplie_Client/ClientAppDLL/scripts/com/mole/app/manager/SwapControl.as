package com.mole.app.manager
{
   import com.common.Alert.Alert;
   import com.common.data.HashMap;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.socket.CSItems.exchange;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.mole.app.info.SwapInfo;
   import com.mole.app.utils.SwapUtil;
   import com.mole.debug.DebugManager;
   import com.mole.info.ItemInfo;
   import com.mole.net.events.SocketEvent;
   import flash.events.EventDispatcher;
   
   public class SwapControl extends EventDispatcher
   {
      
      public static const INIT_COMPLETE:String = "SwapManager_INIT_COMPLETE";
      
      public static const UPDATE:String = "SwapManager_Update";
      
      public static const SWAP_PATH:String = "resource/xml/swap/";
      
      private var _map:HashMap;
      
      private var _needMap:HashMap;
      
      private var _lackMsg:String;
      
      private var _getNeedCount:uint;
      
      public function SwapControl(swapName:String, lackMsg:String)
      {
         super();
         this._lackMsg = lackMsg;
         this._map = new HashMap();
         this._needMap = new HashMap();
         var taskResID:uint = DownLoadManager.add(SWAP_PATH + swapName + ".xml",ResType.STRING,true);
         DownLoadManager.addEvent(taskResID,this.onExchangeConfigComplete);
         OnlineManager.addCmdListener(CommandID.ITEMCOUNT,this.onGetItemCount);
         GV.onlineSocket.addEventListener(exchange.EXCHANGE_ITEM,this.onSwapComplete);
      }
      
      private function onGetItemCount(e:SocketEvent) : void
      {
         var tmpItemInfo:ItemInfo = null;
         var itemInfo:ItemInfo = null;
         var itemCountPro:GetItemCountRes = e.bodyInfo;
         var itemCountMap:HashMap = itemCountPro.itemHash;
         for each(itemInfo in itemCountMap.values)
         {
            tmpItemInfo = this._needMap.getValue(itemInfo.ID);
            if(Boolean(tmpItemInfo))
            {
               tmpItemInfo.count = itemInfo.count;
            }
         }
         if(++this._getNeedCount == this._needMap.length)
         {
            OnlineManager.removeCmdListener(CommandID.ITEMCOUNT,this.onGetItemCount);
            dispatchEvent(new EventTaomee(INIT_COMPLETE));
            dispatchEvent(new EventTaomee(UPDATE));
         }
      }
      
      private function onSwapComplete(e:EventTaomee) : void
      {
         var needItemInfo:ItemInfo = null;
         var typeID:uint = uint(e.EventObj.type);
         var swapInfo:SwapInfo = this._map.getValue(typeID);
         if(Boolean(swapInfo))
         {
            needItemInfo = this._needMap.getValue(swapInfo.needID);
            if(Boolean(needItemInfo))
            {
               needItemInfo.count -= swapInfo.needCount;
            }
         }
         dispatchEvent(new EventTaomee(UPDATE));
      }
      
      private function onExchangeConfigComplete(e:DownLoadEvent) : void
      {
         var exchangeInfo:SwapInfo = null;
         var itemXML:XML = null;
         var itemInfo:ItemInfo = null;
         var needIDArr:Array = null;
         var needID:uint = 0;
         var needIDMap:HashMap = new HashMap();
         var exchangeXML:XML = XML(e.data);
         for each(itemXML in exchangeXML.children())
         {
            exchangeInfo = new SwapInfo(itemXML);
            this._map.add(exchangeInfo.typeID,exchangeInfo);
            needIDMap.add(exchangeInfo.needID,true);
         }
         this._getNeedCount = 0;
         needIDArr = needIDMap.keys;
         for each(needID in needIDArr)
         {
            itemInfo = new ItemInfo();
            itemInfo.ID = needID;
            itemInfo.count = 0;
            this._needMap.add(itemInfo.ID,itemInfo);
            GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),needID,2);
         }
      }
      
      public function swap(typeID:uint) : void
      {
         var itemInfo:ItemInfo = null;
         var swapInfo:SwapInfo = this._map.getValue(typeID);
         if(Boolean(swapInfo))
         {
            itemInfo = this._needMap.getValue(swapInfo.needID);
            if(Boolean(itemInfo))
            {
               SwapUtil.swap(swapInfo,itemInfo.count,this._lackMsg);
            }
            else
            {
               SwapUtil.swap(swapInfo,0,this._lackMsg);
            }
         }
         else if(DebugManager.DEBUG)
         {
            Alert.smileAlart("　　在配置文件中沒有找到TypeID=" + swapInfo.typeID);
         }
      }
      
      public function getNeedCount(needID:uint) : uint
      {
         var itemInfo:ItemInfo = this._needMap.getValue(needID);
         if(Boolean(itemInfo))
         {
            return itemInfo.count;
         }
         return 0;
      }
      
      public function get swapList() : Array
      {
         var tmpList:Array = this._map.values;
         tmpList.sortOn("seq",Array.NUMERIC);
         return tmpList;
      }
      
      public function destroy() : void
      {
         GV.onlineSocket.removeEventListener(exchange.EXCHANGE_ITEM,this.onSwapComplete);
         OnlineManager.removeCmdListener(CommandID.ITEMCOUNT,this.onGetItemCount);
      }
   }
}

