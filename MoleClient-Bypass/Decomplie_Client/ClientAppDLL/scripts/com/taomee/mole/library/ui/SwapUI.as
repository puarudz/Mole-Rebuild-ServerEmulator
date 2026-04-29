package com.taomee.mole.library.ui
{
   import com.common.Alert.Alert;
   import com.common.data.PageListData;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.info.LocalUserInfo;
   import com.global.staticData.CommandID;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.module.LocusWork.NumSprite;
   import com.mole.app.info.SwapInfo;
   import com.mole.app.manager.OnlineManager;
   import com.mole.app.utils.FilterUtil;
   import com.mole.app.utils.SwapUtil;
   import com.mole.info.ItemInfo;
   import com.mole.net.events.SocketEvent;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class SwapUI extends EventDispatcher
   {
      
      public static const LOAD_XML_FAIL:String = "LOAD_SWAP_XML_FAIL";
      
      private var _prev_btn:DisplayObject;
      
      private var _next_btn:DisplayObject;
      
      private var _page_txt:TextField;
      
      protected var _num:uint;
      
      private var _num_txt:TextField;
      
      private var _numSpr:NumSprite;
      
      private var _data:PageListData;
      
      private var _nodeList:Array;
      
      private var _needID:uint;
      
      private var _name:String;
      
      private var _ui:Sprite;
      
      private var _count:uint;
      
      private var _all:uint = 10;
      
      private var _ip:uint = 100;
      
      public var needToDisableBtn:Boolean = false;
      
      public function SwapUI(ui:Sprite, name:String, count:uint, scale:Number = 1, ip:uint = 100)
      {
         var node:SwapNode = null;
         super();
         this._ui = ui;
         this._name = name;
         this._count = count;
         this._prev_btn = this._ui.getChildByName("prev_btn");
         this._next_btn = this._ui.getChildByName("next_btn");
         this._page_txt = this._ui.getChildByName("page_txt") as TextField;
         this._num_txt = this._ui.getChildByName("num_txt") as TextField;
         if(Boolean(this._num_txt))
         {
            this._num_txt.text = "0";
         }
         var num_mc:DisplayObject = this._ui.getChildByName("num_mc");
         if(Boolean(num_mc))
         {
            this._numSpr = new NumSprite(num_mc,0,false,true);
         }
         this._ip = ip;
         if(this._ip < this._count && this._ip > 0)
         {
            this._ui["node_" + this._ip].visible = false;
         }
         this._nodeList = new Array();
         for(var i:int = 1; i <= this._all; i++)
         {
            if(this._ui["node_" + i] != null)
            {
               node = new this.swapNodeClass(this._ui["node_" + i],this,scale);
               this._nodeList.push(node);
            }
         }
         var resID:uint = DownLoadManager.add("resource/xml/swap/" + this._name + ".xml",ResType.STRING,true);
         DownLoadManager.addEvent(resID,this.onLoadSwapXmlSucc,null,null,this.onLoadSwapXmlFail);
         OnlineManager.addCmdListener(CommandID.ITEMCOUNT,this.onCheckNeedCount);
      }
      
      protected function get swapNodeClass() : Class
      {
         return SwapNode;
      }
      
      public function updateNum() : void
      {
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),this._needID,2);
      }
      
      private function onCheckNeedCount(e:SocketEvent) : void
      {
         var itemPro:GetItemCountRes = e.bodyInfo;
         var info:ItemInfo = itemPro.itemHash.getValue(this._needID);
         if(Boolean(info))
         {
            this._num = info.count;
            if(Boolean(this._num_txt))
            {
               this._num_txt.text = this._num.toString();
            }
            if(Boolean(this._numSpr))
            {
               this._numSpr.value = this._num;
            }
         }
         this.checkEnableSwap();
      }
      
      protected function checkEnableSwap() : void
      {
         var swapN:SwapNode = null;
         var swapi:SwapInfo = null;
         if(this.needToDisableBtn)
         {
            for each(swapN in this._nodeList)
            {
               swapi = swapN.swapInfo;
               if(Boolean(swapN.swapBtn))
               {
                  swapN.swapBtn.filters = [];
                  swapN.swapBtn.enabled = true;
                  swapN.swapBtn.mouseEnabled = true;
               }
               if(Boolean(swapN.swapBtn) && Boolean(swapi) && swapi.needCount > this._num)
               {
                  FilterUtil.applyGray(swapN.swapBtn);
                  swapN.swapBtn.enabled = false;
                  swapN.swapBtn.mouseEnabled = false;
               }
            }
         }
      }
      
      private function onLoadSwapXmlSucc(e:DownLoadEvent) : void
      {
         var swapInfo:SwapInfo = null;
         var infoXml:XML = null;
         var swapXml:XML = XML(e.data);
         this._needID = uint(swapXml.@NeedID);
         var infoList:Array = new Array();
         for each(infoXml in swapXml.children())
         {
            swapInfo = new SwapInfo(infoXml);
            infoList.push(swapInfo);
         }
         this._data = new PageListData(infoList,this._count);
         if(Boolean(this._prev_btn))
         {
            this._prev_btn.addEventListener(MouseEvent.CLICK,this.onPrev);
         }
         if(Boolean(this._next_btn))
         {
            this._next_btn.addEventListener(MouseEvent.CLICK,this.onNext);
         }
         this.update();
         this.updateNum();
      }
      
      private function onPrev(e:MouseEvent) : void
      {
         if(this._data.prev())
         {
            this.update();
         }
      }
      
      private function onNext(e:MouseEvent) : void
      {
         if(this._data.next())
         {
            this.update();
         }
      }
      
      private function update() : void
      {
         var node:SwapNode = null;
         var info:SwapInfo = null;
         var curList:Array = this._data.getCurrentPageData();
         for(var i:uint = 0; i < this._count; i++)
         {
            if(this._ip != i)
            {
               node = this._nodeList[i];
               info = curList[i];
            }
            node.setInfo(info);
         }
         if(Boolean(this._page_txt))
         {
            this._page_txt.text = this._data.curPage + "/" + this._data.totalPage;
         }
         if(this._data.curPage == 1)
         {
            if(Boolean(this._prev_btn))
            {
               this._prev_btn.visible = false;
            }
         }
         else if(Boolean(this._prev_btn))
         {
            this._prev_btn.visible = true;
         }
         if(this._data.curPage == this._data.totalPage)
         {
            if(Boolean(this._next_btn))
            {
               this._next_btn.visible = false;
            }
         }
         else if(Boolean(this._next_btn))
         {
            this._next_btn.visible = true;
         }
      }
      
      private function onLoadSwapXmlFail(e:DownLoadEvent) : void
      {
         dispatchEvent(new Event(LOAD_XML_FAIL));
      }
      
      public function swap(info:SwapInfo) : void
      {
         if(info.socketID == 1243 || info.socketID == 0)
         {
            SwapUtil.swap(info,this._num);
         }
         else if(info.socketID == 12027)
         {
            this.exchange_12027(info.typeID,1,info.dataType,10,this._needID,info.needCount);
         }
         this.updateNum();
      }
      
      public function exchange_12027(typeID:int = 0, count:int = 1, dataType:int = 0, dataTypeCount:int = 1, needID:int = 0, needCount:int = 1, _flag:int = 0) : void
      {
         if(this._num < needCount * count)
         {
            Alert.smileAlart("兌換物品數量不足！");
            return;
         }
         var _temp_2:* = GV.onlineSocket;
         var _temp_1:* = 9301;
         with({})
         {
            _temp_2.addCmdListener(_temp_1,function back9301(e:*):void
            {
               GV.onlineSocket.removeCmdListener(9301,back9301);
               var date:ByteArray = e.data as ByteArray;
               var tp:uint = date.readUnsignedInt();
               var aa:uint = date.readUnsignedInt();
               var bb:uint = date.readUnsignedInt();
               if(tp == dataType)
               {
                  if(aa >= dataTypeCount)
                  {
                     if(dataTypeCount > 1)
                     {
                        Alert.angryAlart("今天已經獲得很多了，明天再來吧！");
                        return;
                     }
                     Alert.angryAlart("已經領取過了哦！");
                  }
                  else
                  {
                     GV.onlineSocket.addCmdListener(12027,back12027);
                     GF.sendSocket(12027,typeID,count,_flag);
                  }
               }
            });
         }
         
         private function back12027(e:*) : void
         {
            var i:int = 0;
            var obj:Object = null;
            GV.onlineSocket.removeCmdListener(12027,this.back12027);
            var output:ByteArray = e.data as ByteArray;
            var infoObj:Object = {};
            var str:String = "恭喜你獲得";
            infoObj.Count = output.readUnsignedInt();
            if(infoObj.Count >= 1)
            {
               for(i = 0; i < infoObj.Count; i++)
               {
                  obj = new Object();
                  obj.times = output.readUnsignedInt();
                  obj.itemID = output.readUnsignedInt();
                  obj.count = output.readUnsignedInt();
                  str += GoodsInfo.getItemNameByID(obj.itemID) + "x" + obj.count + "、";
               }
            }
            if(infoObj.Count > 0)
            {
               Alert.smileAlart(str.substr(0,str.length - 1) + "。");
            }
         }
         
         public function destroy() : void
         {
            var node:SwapNode = null;
            for each(node in this._nodeList)
            {
               node.destroy();
            }
            this._nodeList = null;
            OnlineManager.removeCmdListener(CommandID.ITEMCOUNT,this.onCheckNeedCount);
            if(Boolean(this._prev_btn))
            {
               this._prev_btn.removeEventListener(MouseEvent.CLICK,this.onPrev);
            }
            if(Boolean(this._next_btn))
            {
               this._next_btn.removeEventListener(MouseEvent.CLICK,this.onNext);
            }
         }
      }
   }
   
   