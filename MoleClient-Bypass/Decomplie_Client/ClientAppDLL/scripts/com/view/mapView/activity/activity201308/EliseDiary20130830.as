package com.view.mapView.activity.activity201308
{
   import com.common.data.HashMap;
   import com.common.tip.tip;
   import com.common.util.DisplayUtil;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.CSItems.exchange;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.mole.app.manager.ModuleManager;
   import com.mole.net.events.SocketEvent;
   import com.view.MapManageView.MapManageView;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.net.URLRequest;
   
   public class EliseDiary20130830
   {
      
      private static var instance:EliseDiary20130830;
      
      private var _mapArr:Array = [252,112,330,8,345,5,182];
      
      private var _sheetArr:Array = [new Point(467,212),new Point(895,200),new Point(115,460),new Point(590,195),new Point(0,0),new Point(760,420),new Point(730,160)];
      
      private var _itemVct:Vector.<uint>;
      
      private var _bookVct:Vector.<Boolean>;
      
      private var _static:int;
      
      private var _wasteSheet:Sprite;
      
      private var _sheetURL:String = "resource/map/activity/wasteSheet.swf";
      
      private var _overCount:uint = 0;
      
      private var _today:int = 0;
      
      private var _todayBln:Boolean = false;
      
      public function EliseDiary20130830()
      {
         super();
      }
      
      public static function getInstance() : EliseDiary20130830
      {
         if(!instance)
         {
            instance = new EliseDiary20130830();
         }
         return instance;
      }
      
      public function serverInfo() : void
      {
         BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.back10101);
         finishSomethingReq.sendReq(31589);
      }
      
      private function back10101(e:EventTaomee) : void
      {
         var _id:uint = 0;
         if(e.EventObj.Type == 31589)
         {
            BC.removeEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.back10101);
            if(e.EventObj.Done > 0)
            {
               this._todayBln = true;
            }
            _id = LocalUserInfo.getMapID();
            if(_id == this._mapArr[4])
            {
               ModuleManager.openPanel("EliseDiaryBookPanel");
               return;
            }
            if(e.EventObj.Done == 0)
            {
               BC.addEvent(this,GV.onlineSocket,"EliseDiary20130830_getInfo",this.back511);
               this.socketGetPageHash();
            }
         }
      }
      
      private function back511(e:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"EliseDiary20130830_getInfo",this.back511);
         this.initMap();
      }
      
      private function initMap() : void
      {
         if(this._bookVct[4] == false)
         {
            return;
         }
         var _id:uint = LocalUserInfo.getMapID();
         var _ip:int = this._mapArr.indexOf(_id);
         if(_ip != -1)
         {
            this._static = _ip;
            if(this._static == 4)
            {
               ModuleManager.openPanel("EliseDiaryBookPanel");
               return;
            }
            if(this._bookVct[this._static] == false && this._static == 0)
            {
               this.showSheetUI();
            }
            else if(this._bookVct[this._static] == false && this._bookVct[this._static - 1] == true && this._static == this._today)
            {
               this.showSheetUI();
            }
            return;
         }
      }
      
      private function showSheetUI() : void
      {
         this._wasteSheet = new Sprite();
         var _load:Loader = new Loader();
         _load.load(new URLRequest(this._sheetURL));
         this._wasteSheet.addChild(_load);
         this._wasteSheet.x = this._sheetArr[this._static].x;
         this._wasteSheet.y = this._sheetArr[this._static].y;
         this._wasteSheet.mouseEnabled = true;
         MapManageView.inst.mapLevel.topLevel.addChild(this._wasteSheet);
         this._wasteSheet.addEventListener(MouseEvent.CLICK,this.openPuzzleGame);
         tip.tipTailDisPlayObject(this._wasteSheet,"日記殘頁");
      }
      
      private function openPuzzleGame(e:MouseEvent) : void
      {
         BC.removeEvent(this,GV.onlineSocket);
         BC.addEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.getItems);
         ModuleManager.openPanel("EliseDiaryPuzzleGame",{"page":this._static + 1});
      }
      
      private function getItems(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.getItems);
         if(e.EventObj.type == 2774 + this._static)
         {
            this.destroy();
         }
      }
      
      public function socketGetPageHash() : void
      {
         BC.addEvent(this,GV.onlineSocket,SocketEvent.DATA + "511",this.getMoneyNum);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),1351603,2,1351610);
      }
      
      private function getMoneyNum(e:SocketEvent) : void
      {
         BC.removeEvent(this,GV.onlineSocket,SocketEvent.DATA + "511",this.getMoneyNum);
         var _GetItemCountRes:GetItemCountRes = e.bodyInfo as GetItemCountRes;
         var _hash:HashMap = _GetItemCountRes.itemHash;
         var id:uint = 1351603;
         this._itemVct = new Vector.<uint>();
         this._bookVct = new Vector.<Boolean>();
         this._overCount = 0;
         for(var i:uint = 0; i < 7; i++)
         {
            this._itemVct.push(id);
            this._bookVct.push(false);
            if(_hash.containsKey(id))
            {
               this._bookVct[i] = true;
               ++this._overCount;
            }
            else
            {
               this._bookVct[i] = false;
            }
            id++;
         }
         this._today = this._bookVct.indexOf(false);
         GV.onlineSocket.dispatchEvent(new Event("EliseDiary20130830_getInfo"));
      }
      
      public function chartMapID(ip:uint) : Boolean
      {
         var _id:uint = LocalUserInfo.getMapID();
         var _ip:int = this._mapArr.indexOf(_id);
         if(_ip == ip)
         {
            return true;
         }
         return false;
      }
      
      public function getPageMapID(ip:uint) : uint
      {
         return this._mapArr[ip];
      }
      
      public function get bookVct() : Vector.<Boolean>
      {
         return this._bookVct;
      }
      
      public function get overCount() : uint
      {
         return this._overCount;
      }
      
      public function get today() : int
      {
         return this._today;
      }
      
      public function get todayBln() : Boolean
      {
         return this._todayBln;
      }
      
      public function destroy() : void
      {
         BC.removeEvent(this);
         if(Boolean(this._wasteSheet))
         {
            tip.delTipTailDisPlayObject(this._wasteSheet);
            this._wasteSheet.removeEventListener(MouseEvent.CLICK,this.openPuzzleGame);
            DisplayUtil.removeAllChild(this._wasteSheet);
            this._wasteSheet = null;
         }
      }
   }
}

