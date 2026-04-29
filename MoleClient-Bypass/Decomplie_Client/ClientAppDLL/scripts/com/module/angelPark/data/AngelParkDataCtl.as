package com.module.angelPark.data
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.info.LocalUserInfo;
   import com.core.socketlogic.ClientOnLineSerSocket;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MoveCondition;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.PeopleCountLogic.PeopleCountLogic;
   import com.logic.socket.angelPark.AngelParkSocket;
   import com.logic.socket.angelPark.valueObj.AngelParkVO;
   import com.logic.socket.angelPark.valueObj.AngelParkWarehouseVO;
   import com.logic.socket.angelPark.valueObj.GrowingAngelVO;
   import com.module.angelPark.viewControl.AngelPopupView;
   import com.view.PeopleView.PeopleManageView;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.net.URLLoader;
   import flash.utils.Timer;
   
   public class AngelParkDataCtl extends EventDispatcher
   {
      
      public static const LET_ANGEL_GO_EVENT:String = "LET_ANGEL_GO_EVENT";
      
      public static const UPDATE_ANGELINFO_EVENT:String = "UPDATE_ANGELINFO_EVENT";
      
      public static const UPDATE_ANGEL_EFFECT_EVENT:String = "UPDATE_ANGEL_EFFECT_EVENT";
      
      public static const UPDATE_PARK_EVENT:String = "UPDATE_PARK_EVENT";
      
      public static const UPDATE_WAREHOUSE_EVENT:String = "UPDATE_WAREHOUSE_EVENT";
      
      public static const UPDATE_WAREHOUSE_ITEM_EVENT:String = "UPDATE_WAREHOUSE_ITEM_EVENT";
      
      public static const ANGEL_MADE_CHANGE_EVENT:String = "ANGEL_MADE_CHANGE_EVENT";
      
      public static const UPDATE_PARK_AURA_EVENT:String = "UPDATE_PARK_AURA_EVENT";
      
      public static const ANGEL_RANDOM_MOVE_EFFECT_EVENT:String = "ANGEL_RANDOM_MOVE_EFFECT_EVENT";
      
      public static const USE_ITEM_EFFECT_EVENT:String = "USE_ITEM_EFFECT_EVENT";
      
      public static const CHANGE_BG_EVENT:String = "CHANGE_BG_EVENT";
      
      private static const XML_PATH:String = "resource/xml/angelPark/angelRandomTalk.xml";
      
      private var _angelParkVO:AngelParkVO;
      
      private var _updateTimer:Timer;
      
      private var _wareHouseVO:AngelParkWarehouseVO;
      
      private var _angelRandomTalk:XML;
      
      private var _edit:Boolean = false;
      
      public function AngelParkDataCtl(data:AngelParkVO)
      {
         super();
         this._angelParkVO = data;
         BC.addEvent(this,GV.onlineSocket,"read_" + AngelParkSocket.LevelUpCmd,this.LevelUpHandler);
         var urlloader:URLLoader = new URLLoader();
         urlloader.addEventListener(Event.COMPLETE,this.XmlCompleteHandler);
         urlloader.addEventListener(IOErrorEvent.IO_ERROR,this.XmlErrorHandler);
         urlloader.load(VL.getURLRequest(XML_PATH));
      }
      
      public function get edit() : Boolean
      {
         return this._edit;
      }
      
      private function LevelUpHandler(e:EventTaomee) : void
      {
         var level:int = int(e.EventObj);
         AngelPopupView.instance.ShowLevelUpPanel(level);
         this.UpdateParkInfo();
      }
      
      private function OnUpdateTimer(e:TimerEvent) : void
      {
         if(this._updateTimer.currentCount % 30 == 0)
         {
            this.UpdateRandomMoveEffect();
         }
         if(this._updateTimer.currentCount % 80 == 0)
         {
            this.UpdateRandomTalkEffect();
         }
         if(this._updateTimer.currentCount % (600 * 10) == 0)
         {
            this.UpdateParkInfo();
         }
      }
      
      private function UpdateRandomTalkEffect() : void
      {
         var randomAngelIndex:int = 0;
         var randomAngel:GrowingAngelVO = null;
         if(this._angelParkVO.angelList.length > 0)
         {
            randomAngelIndex = Math.random() * 100 % this._angelParkVO.angelList.length;
            randomAngel = this._angelParkVO.angelList[randomAngelIndex];
            this.dispatchEvent(new EventTaomee(UPDATE_ANGEL_EFFECT_EVENT,randomAngel.index));
         }
      }
      
      private function UpdateRandomMoveEffect() : void
      {
         var randomAngelIndex:int = 0;
         var randomAngel:GrowingAngelVO = null;
         if(this._angelParkVO.angelList.length > 0)
         {
            randomAngelIndex = Math.random() * 100 % this._angelParkVO.angelList.length;
            randomAngel = this._angelParkVO.angelList[randomAngelIndex];
            this.dispatchEvent(new EventTaomee(ANGEL_RANDOM_MOVE_EFFECT_EVENT,randomAngel.index));
            if(this._angelParkVO.angelList.length > 3)
            {
               this.dispatchEvent(new EventTaomee(ANGEL_RANDOM_MOVE_EFFECT_EVENT,randomAngel.index));
               randomAngelIndex = Math.random() * 100 % this._angelParkVO.angelList.length;
               randomAngel = this._angelParkVO.angelList[randomAngelIndex];
               this.dispatchEvent(new EventTaomee(ANGEL_RANDOM_MOVE_EFFECT_EVENT,randomAngel.index));
            }
         }
      }
      
      private function XmlErrorHandler(e:IOErrorEvent) : void
      {
         trace("天使語言加載失敗");
         URLLoader(e.currentTarget).removeEventListener(Event.COMPLETE,this.XmlCompleteHandler);
         URLLoader(e.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,this.XmlErrorHandler);
      }
      
      private function XmlCompleteHandler(e:Event) : void
      {
         URLLoader(e.currentTarget).removeEventListener(Event.COMPLETE,this.XmlCompleteHandler);
         URLLoader(e.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,this.XmlErrorHandler);
         this._angelRandomTalk = new XML(e.target.data);
      }
      
      public function get AngelCount() : int
      {
         return this._angelParkVO.angelList.length;
      }
      
      public function GetAngelRandomTalk(id:int, lvl:int, state:int) : Array
      {
         var angelXml:XML = null;
         var lvlXml:XML = null;
         var stateXml:XML = null;
         var talkList:XMLList = null;
         var index:int = 0;
         var talkXml:XML = null;
         var item:XML = null;
         var talkMsgList:Array = new Array();
         if(Boolean(this._angelRandomTalk))
         {
            angelXml = this._angelRandomTalk.angel.(@id == id)[0];
            if(Boolean(angelXml))
            {
               lvlXml = angelXml.level.(@id == lvl)[0];
               if(Boolean(lvlXml))
               {
                  stateXml = lvlXml.state.(@id == state)[0];
                  if(Boolean(stateXml))
                  {
                     talkList = stateXml.children();
                     index = Math.random() * 100 % talkList.length();
                     talkXml = talkList[index];
                     if(Boolean(talkXml))
                     {
                        if(talkXml.children().length() > 0)
                        {
                           for each(item in talkXml.children())
                           {
                              talkMsgList.push(item.@content);
                           }
                        }
                        else
                        {
                           talkMsgList.push(talkXml.@content);
                        }
                     }
                     return talkMsgList;
                  }
               }
            }
         }
         return talkMsgList;
      }
      
      public function get BG_id() : int
      {
         var id:int = 0;
         var type:int = 0;
         for each(id in this._angelParkVO.dressUpList)
         {
            type = int(GoodsInfo.getInfoById(id).Type);
            if(type == 1)
            {
               return id;
            }
         }
         return -1;
      }
      
      public function Clear() : void
      {
         this.StopUpdateTimer();
         BC.removeEvent(this);
      }
      
      public function GetGrowingAngelInfoByIndex(index:int) : GrowingAngelVO
      {
         var angel:GrowingAngelVO = null;
         for each(angel in this._angelParkVO.angelList)
         {
            if(angel.index == index)
            {
               return angel;
            }
         }
         return null;
      }
      
      public function GetGrowingAngelInfoByPosId(posId:int) : GrowingAngelVO
      {
         var angel:GrowingAngelVO = null;
         for each(angel in this._angelParkVO.angelList)
         {
            if(angel.posId == posId)
            {
               return angel;
            }
         }
         return null;
      }
      
      public function GetWareHouseInfo() : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + AngelParkSocket.GetParkWarehouseCmd,this.GetWareHouseInfoHandler);
         AngelParkSocket.GetWarehouseInfo();
      }
      
      public function HidePeople() : void
      {
         this._edit = true;
         GF.clearPeoples();
         MoveTo.CanMove = false;
      }
      
      public function LetGoBeforeMadeChange(index:int) : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + AngelParkSocket.LetGoBeforeMadeChangeCmd,this.LetGoBeforeMadeChangeHandler);
         AngelParkSocket.LetGoBeforeMadeChange(index);
      }
      
      public function MadeChange(index:int) : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + AngelParkSocket.MadeChangeCmd,this.MadeChangeHandler);
         AngelParkSocket.MadeChange(index);
      }
      
      private function MadeChangeHandler(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + AngelParkSocket.MadeChangeCmd,this.MadeChangeHandler);
         var index:int = int(e.EventObj.index);
         this.RemoveGrowingAngelInfoByIndex(index);
         this.dispatchEvent(new EventTaomee(ANGEL_MADE_CHANGE_EVENT,e.EventObj));
         this.UpdateParkInfo();
      }
      
      public function RemoveGrowingAngelInfoByIndex(index:int) : void
      {
         var angel:GrowingAngelVO = this.GetGrowingAngelInfoByIndex(index);
         var listIndex:int = this._angelParkVO.angelList.indexOf(angel);
         this._angelParkVO.angelList.splice(listIndex,1);
      }
      
      public function ShowPeople() : void
      {
         this._edit = false;
         GV.onlineClass.addEventListener(ClientOnLineSerSocket.GET_BASIC_MESSAGE,this.getAllUserInfo);
         GF.clearPeoples();
         GV.onlineClass.getUserListReq();
         MoveTo.CanMove = true;
      }
      
      public function StartUpdateTimer() : void
      {
         this.StopUpdateTimer();
         this._updateTimer = new Timer(100,10000);
         BC.addEvent(this,this._updateTimer,TimerEvent.TIMER,this.OnUpdateTimer);
         BC.addEvent(this,this._updateTimer,TimerEvent.TIMER_COMPLETE,this.OnUpdateTimerComplete);
         this._updateTimer.start();
      }
      
      public function StopUpdateTimer() : void
      {
         if(Boolean(this._updateTimer))
         {
            this._updateTimer.stop();
            BC.removeEvent(this,this._updateTimer);
         }
      }
      
      public function UpdateParkInfo() : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + AngelParkSocket.GetParkInfoCmd,this.UpdateParkInfoHandler);
         AngelParkSocket.GetParkInfo(this._angelParkVO.userId,this._angelParkVO.high);
      }
      
      public function UseSeed(posId:int, seedId:int) : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + AngelParkSocket.UseSeedCmd,this.UseSeedHandler);
         AngelParkSocket.UseSeed(posId,seedId);
      }
      
      public function UseItem(posId:int, itemId:int) : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + AngelParkSocket.UseItemCmd,this.UseItemHandler);
         AngelParkSocket.UseItem(posId,itemId);
      }
      
      public function AddAura(id:int, count:int) : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + AngelParkSocket.AddAuraCmd,this.AddAuraHandler);
         AngelParkSocket.AddAura(id,count);
      }
      
      private function AddAuraHandler(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + AngelParkSocket.AddAuraCmd,this.AddAuraHandler);
         var maxAura:Number = Number(e.EventObj);
         this._angelParkVO.aura = maxAura;
         this.dispatchEvent(new Event(UPDATE_PARK_AURA_EVENT));
      }
      
      public function get angelParkVO() : AngelParkVO
      {
         return this._angelParkVO;
      }
      
      public function get canSeedAngelCount() : int
      {
         return this._angelParkVO.canSeedAgelCount;
      }
      
      public function get isMyPark() : Boolean
      {
         return this._angelParkVO.userId == LocalUserInfo.getUserID();
      }
      
      public function get wareHouseVO() : AngelParkWarehouseVO
      {
         return this._wareHouseVO;
      }
      
      private function GetWareHouseInfoHandler(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + AngelParkSocket.GetParkWarehouseCmd,this.GetWareHouseInfoHandler);
         this._wareHouseVO = e.EventObj as AngelParkWarehouseVO;
         this.dispatchEvent(new Event(UPDATE_WAREHOUSE_EVENT));
      }
      
      private function LetGoBeforeMadeChangeHandler(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + AngelParkSocket.LetGoBeforeMadeChangeCmd,this.LetGoBeforeMadeChangeHandler);
         var index:int = int(e.EventObj);
         this.RemoveGrowingAngelInfoByIndex(index);
         this.dispatchEvent(new EventTaomee(LET_ANGEL_GO_EVENT,index));
      }
      
      private function OnUpdateTimerComplete(e:TimerEvent) : void
      {
         this.StartUpdateTimer();
      }
      
      private function UpdateParkInfoHandler(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + AngelParkSocket.GetParkInfoCmd,this.UpdateParkInfoHandler);
         this._angelParkVO = e.EventObj as AngelParkVO;
         this.dispatchEvent(new Event(UPDATE_PARK_EVENT));
         this.dispatchEvent(new Event(UPDATE_ANGELINFO_EVENT));
      }
      
      private function UseSeedHandler(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + AngelParkSocket.UseSeedCmd,this.UseSeedHandler);
         var ga:GrowingAngelVO = e.EventObj as GrowingAngelVO;
         this._angelParkVO.angelList.push(ga);
         this.dispatchEvent(new Event(UPDATE_ANGELINFO_EVENT));
         this.dispatchEvent(new EventTaomee(UPDATE_WAREHOUSE_ITEM_EVENT,ga.id));
      }
      
      private function UseItemHandler(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + AngelParkSocket.UseItemCmd,this.UseItemHandler);
         var itemId:int = int(e.EventObj.itemId);
         var angelInfo:GrowingAngelVO = e.EventObj.angel;
         var angel:GrowingAngelVO = this.GetGrowingAngelInfoByIndex(angelInfo.index);
         var listIndex:int = this._angelParkVO.angelList.indexOf(angel);
         this._angelParkVO.angelList[listIndex] = angelInfo;
         this.dispatchEvent(new EventTaomee(USE_ITEM_EFFECT_EVENT,{
            "index":angelInfo.index,
            "itemId":itemId
         }));
         this.dispatchEvent(new EventTaomee(UPDATE_WAREHOUSE_ITEM_EVENT,itemId));
      }
      
      private function getAllUserInfo(evt:EventTaomee) : void
      {
         GV.onlineClass.removeEventListener(ClientOnLineSerSocket.GET_BASIC_MESSAGE,this.getAllUserInfo);
         var userArray:Array = evt.EventObj.arr;
         var userObj:Object = {
            "data":userArray,
            "type":1
         };
         GV.PeopleCount.changeOnlinePeople(userObj);
         this.ReSetMolePoint();
      }
      
      public function ReSetMolePoint() : void
      {
         var tempitem:Object = null;
         var p:Point = null;
         var item:PeopleManageView = null;
         for each(tempitem in PeopleCountLogic.peopleList)
         {
            p = MoveTo.getRandomFloorPoint();
            item = tempitem.Instance as PeopleManageView;
            if(!MoveCondition.hasRoad(item.x,item.y))
            {
               item.x = p.x;
               item.y = p.y;
               item.moveTo(p.x,p.y);
            }
         }
      }
      
      public function ChangeParkBG(bgId:uint) : void
      {
         var thisObj:AngelParkDataCtl = null;
         var _temp_4:* = BC;
         var _temp_3:* = thisObj;
         var _temp_2:* = GV.onlineSocket;
         var _temp_1:* = "read_" + AngelParkSocket.UseBackgroundCmd;
         with({})
         {
            _temp_4.addEvent(_temp_3,_temp_2,_temp_1,function handler(e:Event):void
            {
               var id:int = 0;
               var type:int = 0;
               BC.removeEvent(thisObj,GV.onlineSocket,"read_" + AngelParkSocket.UseBackgroundCmd);
               var length:int = int(_angelParkVO.dressUpList.length);
               for(var i:int = 0; i < length; i++)
               {
                  id = int(_angelParkVO.dressUpList[i]);
                  type = int(GoodsInfo.getInfoById(id).Type);
                  if(type == 1)
                  {
                     _angelParkVO.dressUpList[i] = bgId;
                     break;
                  }
               }
               dispatchEvent(new Event(CHANGE_BG_EVENT));
            });
            AngelParkSocket.UseBackground(bgId);
         }
      }
   }
   
   