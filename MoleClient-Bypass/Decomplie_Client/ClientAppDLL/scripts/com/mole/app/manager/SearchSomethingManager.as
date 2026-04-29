package com.mole.app.manager
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.FindPathLogic.MoveTo;
   import com.module.activityModule.Presented;
   import com.mole.app.activity.FireGodCup4;
   import com.mole.app.info.SearchSomethingInfo;
   import com.mole.app.map.MapManager;
   import com.mole.utils.URLUtil;
   import com.taomee.mole.cache.CacheManager;
   import com.view.MapManageView.MapManageView;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import org.taomee.ds.HashMap;
   import org.taomee.loader.ContentInfo;
   import org.taomee.net.SocketEvent;
   
   public class SearchSomethingManager extends EventDispatcher
   {
      
      private static var _instance:SearchSomethingManager;
      
      private var configCls:Class;
      
      private var activityMap:HashMap;
      
      private var loaderList:Array;
      
      private var itemsMcVec:Vector.<DisplayObject>;
      
      public function SearchSomethingManager()
      {
         var activityVec:Vector.<SearchSomethingInfo> = null;
         var tmpXml:XML = null;
         var itemXml:XML = null;
         this.configCls = SearchSomethingManager_configCls;
         super();
         this.activityMap = new HashMap();
         var configXml:XML = XML(new this.configCls());
         this.itemsMcVec = new Vector.<DisplayObject>();
         for each(tmpXml in configXml.descendants("activity"))
         {
            activityVec = new Vector.<SearchSomethingInfo>();
            for each(itemXml in tmpXml.descendants("item"))
            {
               activityVec.push(new SearchSomethingInfo(itemXml,uint(tmpXml.@id)));
            }
            this.activityMap.add(uint(tmpXml.@id),{
               "id":uint(tmpXml.@id),
               "time":uint(tmpXml.@time),
               "items":activityVec
            });
         }
         MapManageView.inst.addEventListener(Event.INIT,this.initMapHandler);
         GV.onlineSocket.addEventListener("removeMapEvent",this.destroy);
      }
      
      public static function get instance() : SearchSomethingManager
      {
         if(!_instance)
         {
            _instance = new SearchSomethingManager();
         }
         return _instance;
      }
      
      public function initMapHandler(evt:Event) : void
      {
         var activityId:uint = 0;
         var items:Vector.<SearchSomethingInfo> = null;
         var itemInfo:SearchSomethingInfo = null;
         var activityArr:Array = this.getCurMapActivitys(MapManager.curMapID);
         this.loaderList = new Array();
         for each(activityId in activityArr)
         {
            items = this.activityMap.getValue(activityId).items;
            for each(itemInfo in items)
            {
               if(itemInfo.mapId == MapManager.curMapID)
               {
                  this.loaderList.push(URLUtil.getSearchSomethingUrl(activityId));
                  CacheManager.getPhasorContent(URLUtil.getSearchSomethingUrl(activityId),"item_" + itemInfo.id,this.loadComplete,null,itemInfo);
               }
            }
         }
      }
      
      private function loadComplete(contentInfo:ContentInfo) : void
      {
         var mc:DisplayObject = contentInfo.content;
         var itemInfo:SearchSomethingInfo = contentInfo.data;
         if(Boolean(MapManageView.inst.mapLevel[itemInfo.level]))
         {
            this.itemsMcVec.push(mc);
            mc.name = "search_" + itemInfo.activityId + "_" + itemInfo.id;
            mc.x = itemInfo.pos.x;
            mc.y = itemInfo.pos.y;
            MovieClip(MapManageView.inst.mapLevel[itemInfo.level]).addChild(mc);
            TipsManager.addTextTips(mc,itemInfo.tips);
            mc.addEventListener(MouseEvent.CLICK,this.clickHandler);
            if(mc is MovieClip)
            {
               MovieClip(mc).buttonMode = true;
            }
         }
      }
      
      private function clickHandler(evt:MouseEvent) : void
      {
         var getIds:Array = null;
         var bckFunc:Function = null;
         var searchFunc:Function = null;
         var enterFrameCheck:Function = null;
         var mapArr:Array = null;
         var enterFrameCheck6:Function = null;
         var itemName:String = evt.currentTarget.name;
         dispatchEvent(new EventTaomee(itemName));
         switch(itemName)
         {
            case "search_1_1":
            case "search_1_2":
            case "search_1_3":
            case "search_1_4":
            case "search_1_5":
            case "search_1_6":
            case "search_1_7":
            case "search_1_8":
            case "search_1_9":
               getIds = [1351502,1351503,1351505,1351504,1351465,1351466,1351467,1351468,1351469];
               bckFunc = function(evt:SocketEvent):void
               {
                  GV.onlineSocket.removeCmdListener(CommandID.GUESS_WHAT_IS_LOVE_SEARCH,bckFunc);
                  var recData:ByteArray = evt.data as ByteArray;
                  switch(recData.readUnsignedInt())
                  {
                     case 0:
                        Alert.smileAlart("恭喜您獲得了" + GoodsInfo.getItemNameByID(recData.readUnsignedInt()) + " X1");
                        break;
                     case 1:
                        Alert.smileAlart("每次採集之後需要等待5分鐘後才能再次採集哦!");
                        break;
                     case 2:
                        Alert.smileAlart("每天這種收集品最多收集60個!");
                  }
               };
               GV.onlineSocket.addCmdListener(CommandID.GUESS_WHAT_IS_LOVE_SEARCH,bckFunc);
               GF.sendSocket(CommandID.GUESS_WHAT_IS_LOVE_SEARCH,getIds[int(itemName.substr(9,1)) - 1]);
               break;
            case "search_2_1":
            case "search_2_2":
            case "search_2_3":
            case "search_2_4":
            case "search_2_5":
               if(MovieClip(evt.currentTarget).currentFrame != 1)
               {
                  return;
               }
               searchFunc = function(evt:SocketEvent):void
               {
                  var recData:ByteArray = null;
                  var count:uint = 0;
                  var msg:String = null;
                  var ix:int = 0;
                  GV.onlineSocket.removeCmdListener(CommandID.SEARCH_DIARY_FRAGMENT,searchFunc);
                  recData = evt.data as ByteArray;
                  PeopleManageView(GV.MAN_PEOPLE).visible = true;
                  LevelManager.mapLevel.mouseChildren = true;
                  MoveTo.CanMove = true;
                  switch(recData.readUnsignedInt())
                  {
                     case 1:
                        count = recData.readUnsignedInt();
                        msg = "小摩爾很有偵探頭腦哦~發現";
                        for(ix = 0; ix < count; ix++)
                        {
                           msg += GoodsInfo.getItemNameByID(recData.readUnsignedInt()) + "*" + recData.readUnsignedInt() + " ";
                        }
                        Alert.smileAlart(msg);
                        break;
                     case 0:
                        Alert.smileAlart("每次採集之後需要等待15秒後才能再次採集哦!");
                        break;
                     case 2:
                        Alert.smileAlart("每天最多探索30次哦!請明天再來吧!");
                  }
               };
               MovieClip(evt.currentTarget).gotoAndPlay(2);
               enterFrameCheck = function(evt:Event):void
               {
                  if(MovieClip(evt.currentTarget).currentFrame == MovieClip(evt.currentTarget).totalFrames)
                  {
                     MovieClip(evt.currentTarget).removeEventListener(Event.ENTER_FRAME,enterFrameCheck);
                     GV.onlineSocket.addCmdListener(CommandID.SEARCH_DIARY_FRAGMENT,searchFunc);
                     GF.sendSocket(CommandID.SEARCH_DIARY_FRAGMENT);
                  }
               };
               MovieClip(evt.currentTarget).addEventListener(Event.ENTER_FRAME,enterFrameCheck);
               PeopleManageView(GV.MAN_PEOPLE).visible = false;
               LevelManager.mapLevel.mouseChildren = false;
               MoveTo.CanMove = false;
               break;
            case "search_6_1":
            case "search_6_2":
            case "search_6_3":
            case "search_6_4":
            case "search_6_5":
            case "search_6_6":
            case "search_6_7":
            case "search_6_8":
            case "search_6_9":
            case "search_6_10":
            case "search_6_11":
            case "search_6_12":
            case "search_6_13":
            case "search_6_14":
            case "search_6_15":
            case "search_6_16":
               if(MovieClip(evt.currentTarget).currentFrame != 1)
               {
                  return;
               }
               mapArr = [0,330,2,142,80];
               if(mapArr[FireGodCup4.inst.team] != MapManager.curMapID)
               {
                  if(FireGodCup4.inst.team == 0)
                  {
                     Alert.angryAlart("只有參見火神盃的玩家才能參與建設活動哦。");
                  }
                  else
                  {
                     Alert.angryAlart("這不是你所在隊伍的主場景哦，回到隊長所在場景參見活動吧！");
                  }
                  return;
               }
               MovieClip(evt.currentTarget).gotoAndPlay(2);
               enterFrameCheck6 = function(evt:Event):void
               {
                  if(MovieClip(evt.currentTarget).currentFrame == MovieClip(evt.currentTarget).totalFrames)
                  {
                     MovieClip(evt.currentTarget).removeEventListener(Event.ENTER_FRAME,enterFrameCheck6);
                     Presented.getInstance().celebrate1225(2725);
                     PeopleManageView(GV.MAN_PEOPLE).visible = true;
                     LevelManager.mapLevel.mouseChildren = true;
                     MoveTo.CanMove = true;
                  }
               };
               MovieClip(evt.currentTarget).addEventListener(Event.ENTER_FRAME,enterFrameCheck6);
               PeopleManageView(GV.MAN_PEOPLE).visible = false;
               LevelManager.mapLevel.mouseChildren = false;
               MoveTo.CanMove = false;
         }
      }
      
      private function getCurMapActivitys(mapId:uint) : Array
      {
         var obj:Object = null;
         var info:SearchSomethingInfo = null;
         var rtnArr:Array = new Array();
         var activityArr:Array = this.activityMap.getValues();
         for(var ix:int = 0; ix < activityArr.length; ix++)
         {
            obj = activityArr[ix];
            if(obj.time == 0 || SystemTimeController.instance.checkSysTimeAchieve(obj.time))
            {
               for each(info in obj.items)
               {
                  if(info.mapId == mapId)
                  {
                     rtnArr.push(obj.id);
                     break;
                  }
               }
            }
         }
         return rtnArr;
      }
      
      private function destroy(evt:Event) : void
      {
         var url:String = null;
         var mc:DisplayObject = null;
         if(Boolean(this.loaderList))
         {
            for each(url in this.loaderList)
            {
               CacheManager.cancelPhasor(url,this.loadComplete);
            }
         }
         if(Boolean(this.itemsMcVec))
         {
            for each(mc in this.itemsMcVec)
            {
               TipsManager.remove(mc);
               mc.removeEventListener(MouseEvent.CLICK,this.clickHandler);
            }
            this.itemsMcVec.length = 0;
         }
         this.loaderList = null;
      }
   }
}

