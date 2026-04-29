package com.mole.app.manager
{
   import com.common.util.DisplayUtil;
   import com.core.MainManager;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.event.EventTaomee;
   import com.logic.mapEvent.MapEvent;
   import com.logic.socket.CSItems.exchange;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.mole.app.utils.Tool;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   
   public class FootPrintManager
   {
      
      private static var _inst:FootPrintManager;
      
      public var year:int;
      
      public var month:int;
      
      public var footObj:Object;
      
      public var gotFeetArr:Array;
      
      private var len:int = 5;
      
      private var _queryIndex:int = 0;
      
      public function FootPrintManager()
      {
         super();
      }
      
      public static function get inst() : FootPrintManager
      {
         if(_inst == null)
         {
            _inst = new FootPrintManager();
         }
         return _inst;
      }
      
      public function init() : void
      {
         this.year = ServerUpTime.getInstance().date.fullYear;
         this.month = 12;
         this.footObj = {};
         this.gotFeetArr = [0,0,0,0,0];
         Tool.loadAndHandleXML("resource/xml/footPrint/footPrint" + 2013 + ".xml",this.footObj,this.onLoadFootXmlOver);
      }
      
      private function onLoadFootXmlOver() : void
      {
         this.queryFeetGot();
      }
      
      private function queryFeetGot() : void
      {
         if(this._queryIndex < this.len)
         {
            GV.onlineSocket.addEventListener(finishSomethingRes.FINISH_SOMETHING_SUCC,this.queryOver);
            finishSomethingRes.sendReq(this.footObj.feet[this.month - 1].foot[this._queryIndex].dayType);
         }
      }
      
      private function queryOver(e:EventTaomee) : void
      {
         if(e.EventObj.Type == this.footObj.feet[this.month - 1].foot[this._queryIndex].dayType)
         {
            GV.onlineSocket.removeEventListener(finishSomethingRes.FINISH_SOMETHING_SUCC,this.queryOver);
            if(e.EventObj.Done > 0)
            {
               this.gotFeetArr[this._queryIndex] = 1;
            }
            if(this._queryIndex < this.len - 1)
            {
               ++this._queryIndex;
               this.queryFeetGot();
            }
            else
            {
               GV.onlineSocket.addEventListener(MapEvent.CHANGE_MAP_COMPLETE,this.onChangeMap);
            }
         }
      }
      
      private function removeMapFunc(e:*) : void
      {
         BC.removeEvent(_inst);
         GV.onlineSocket.removeEventListener(MapEvent.READY_CHANGE_MAP,this.removeMapFunc);
      }
      
      private function onChangeMap(e:*) : void
      {
         var i:int = 0;
         var resID:int = 0;
         GV.onlineSocket.addEventListener(MapEvent.READY_CHANGE_MAP,this.removeMapFunc);
         for(i = 0; i < this.len; i++)
         {
            if(LocalUserInfo.getMapID() == this.footObj.feet[this.month - 1].foot[i].mapID)
            {
               if(this.gotFeetArr[i] == 0)
               {
                  resID = int(DownLoadManager.add("resource/task/footPrint/foot.swf",ResType.DISPLAY_OBJECT));
                  DownLoadManager.addEvent(resID,this.onLoadFootRes);
                  break;
               }
            }
         }
      }
      
      private function onLoadFootRes(e:DownLoadEvent) : void
      {
         var i:int = 0;
         var foot:SimpleButton = null;
         for(i = 0; i < this.len; i++)
         {
            if(LocalUserInfo.getMapID() == this.footObj.feet[this.month - 1].foot[i].mapID)
            {
               break;
            }
         }
         if(i < this.len)
         {
            foot = (e.data as MovieClip).getChildAt(0) as SimpleButton;
            MainManager.getAppLevel().addChild(foot);
            foot.x = this.footObj.feet[this.month - 1].foot[i].x;
            foot.y = this.footObj.feet[this.month - 1].foot[i].y;
            BC.addEvent(_inst,foot,MouseEvent.CLICK,this.clickFoot);
         }
      }
      
      private function clickFoot(e:MouseEvent) : void
      {
         var i:int = 0;
         BC.removeEvent(_inst,e.currentTarget,MouseEvent.CLICK,this.clickFoot);
         DisplayUtil.removeForParent(e.currentTarget as DisplayObject);
         for(i = 0; i < this.len; i++)
         {
            if(LocalUserInfo.getMapID() == this.footObj.feet[this.month - 1].foot[i].mapID)
            {
               break;
            }
         }
         if(i < this.len)
         {
            BC.addEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.exeOver);
            exchange.exchange_goods(this.footObj.feet[this.month - 1].foot[i].type);
         }
      }
      
      private function exeOver(e:EventTaomee) : void
      {
         var arr:Array = null;
         var type:int = int(e.EventObj.type);
         for(var i:int = 0; i < 5; i++)
         {
            if(type == this.footObj.feet[this.month - 1].foot[i].type)
            {
               this.gotFeetArr[i] = 1;
               BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.exeOver);
               arr = e.EventObj.arr;
               Tool.alert(arr[0].itemID);
               break;
            }
         }
      }
   }
}

