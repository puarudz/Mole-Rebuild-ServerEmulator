package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.loading.Loading;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.global.staticData.XMLInfo;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.module.activityModule.checkItem;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.npc.dialog.TalkEvent;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.ActivityTmpDataManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.task.Task;
   import com.mole.app.task.TaskManager;
   import com.mole.app.utils.GetItem;
   import com.view.JobView.ChildNPCModule.ChildNpc.CrowNpc;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class FirecompanyView extends MapBase
   {
      
      private static const FIRE_SPIRIT_CRYSTALS:uint = 191076;
      
      private var fireBookMC:MovieClip;
      
      private var botton_mc:MovieClip;
      
      private var NPCLogics:MovieClip;
      
      private var tempMC:*;
      
      public function FirecompanyView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         BC.addEvent(this,_mapLevel.controlLevel["examBtn"],MouseEvent.CLICK,this.examHandler);
         BC.addEvent(this,_mapLevel.controlLevel["newBook"],MouseEvent.CLICK,this.loadBookEvent);
         this.judgeCharm();
         GV.onlineSocket.addEventListener("NPCOldJob",this.onNPCOldJob);
         GV.onlineSocket.addEventListener("OVERNPCOldJob",this.overTaskTip);
         SystemEventManager.addEventListener("fireKnight",this.onFireKnight);
      }
      
      private function onFireKnight(evt:Event) : void
      {
         GV.onlineSocket.addEventListener(GetItemCountRes.GET_ITEMCOUNT,this.getItemCountBk);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),FIRE_SPIRIT_CRYSTALS,2,FIRE_SPIRIT_CRYSTALS + 1);
      }
      
      private function getItemCountBk(evt:EventTaomee) : void
      {
         var itemObj:Object = null;
         GV.onlineSocket.removeEventListener(GetItemCountRes.GET_ITEMCOUNT,this.getItemCountBk);
         var itemArr:Array = evt.EventObj.obj.arr;
         for each(itemObj in itemArr)
         {
            if(FIRE_SPIRIT_CRYSTALS == itemObj.ID)
            {
               if(itemObj.Count >= 1)
               {
                  mapSay(2);
                  ActivityTmpDataManager.getTransferItem(4);
                  return;
               }
            }
         }
         mapSay(3);
      }
      
      private function onNPCOldJob(e:Event) : void
      {
         var _t:MapBase = null;
         var Tasks:Task = null;
         var getItems:GetItem = null;
         var id:uint = 131;
         _t = this;
         Tasks = TaskManager.getTask(id);
         var State:uint = TaskManager.getTaskState(id);
         if(State == 1)
         {
            var _temp_4:* = BC;
            var _temp_3:* = _t;
            var _temp_2:* = getItems;
            var _temp_1:* = GetItem.BACKITEMNUM;
            with({})
            {
               
               _temp_4.addEvent(_temp_3,_temp_2,_temp_1,function getItemNum(e:EventTaomee):void
               {
                  BC.removeEvent(_t,getItems,GetItem.BACKITEMNUM,getItemNum);
                  getItems.destroy();
                  getItems = null;
                  Tasks.taskInfo.goodsNum = e.EventObj.arr;
                  if(e.EventObj.arr.indexOf(0) == -1 && LocalUserInfo.getStrong() >= 20)
                  {
                     Tasks.over();
                     Tasks.checkEnterMap(100000003);
                  }
                  else
                  {
                     Tasks.checkEnterMap(100000002);
                  }
               });
               getItems.itemNum(Tasks.taskInfo.goods);
            }
            else if(State == 0)
            {
               Tasks.checkEnterMap(100000001);
            }
            else if(State == 2)
            {
               Tasks.checkEnterMap(100000004);
            }
         }
         
         public function overTaskTip(evt:Event) : void
         {
            var url:String = GoodsInfo.getItemPathByID(12560) + "12560.swf";
            var msg:String = "    恭喜你獲得消防員套裝！快穿齊它吧！";
            Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
         }
         
         private function onJoinKuroSmc(e:SystemEvent) : void
         {
            this.runCrowTask();
         }
         
         private function judgeCharm() : void
         {
            var task131State:uint = TaskManager.getTaskState(131);
            if(task131State == 2 || task131State == 1)
            {
               if(LocalUserInfo.getStrong() >= 20)
               {
                  this.npcFunc();
               }
            }
            else
            {
               this.npcFunc();
            }
         }
         
         private function runCrowTask() : void
         {
            var info:String = "     嘿，你的任務還未完成，看看你的力量值是否達到20以上，有沒有拿到入職資格證，再來交任務哦！";
            var url:String = "resource/allJob/AlertPic/crow/crow1.swf";
            var myAlert:* = Alert.showAlert(MainManager.getAppLevel(),url,info,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
         }
         
         private function loadBookEvent(evt:MouseEvent) : void
         {
            if(!MainManager.getAppLevel().getChildByName("fireBookMC"))
            {
               this.fireBookMC = new MovieClip();
               this.fireBookMC.name = "fireBookMC";
               MainManager.getAppLevel().addChild(this.fireBookMC);
               this.tempMC = new MCLoader("module/external/BooksUI/fireBookView.swf",this.fireBookMC,Loading.TITLE_AND_PERCENT,"正在打開消防員手冊");
               this.tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadBookHandler);
               this.tempMC.doLoad();
            }
         }
         
         private function loadBookHandler(evt:MCLoadEvent) : void
         {
            var mainMC:DisplayObjectContainer = evt.getParent();
            var childMC:* = evt.getLoader();
            mainMC.addChild(childMC);
            this.tempMC.removeEventListener(MCLoadEvent.ON_SUCCESS,this.loadBookHandler);
            this.tempMC.clear();
         }
         
         private function npcFunc() : void
         {
            var crowNpc:CrowNpc;
            BC.addEvent(this,TalkEvent,"kuro_joinKuroSMC",function(E:*):void
            {
               runCrowTask();
            });
            crowNpc = new CrowNpc();
            crowNpc.setTargetMC(controlLevel["npc_10039"]);
            crowNpc = null;
         }
         
         private function examHandler(event:MouseEvent) : void
         {
            this.task();
         }
         
         private function task() : void
         {
            var myalter:Class = null;
            var task131State:uint = TaskManager.getTaskState(131);
            var _url:String = "";
            var _msg:String = "";
            if(task131State == 0)
            {
               _url = XMLInfo.npcXML["131"].url0;
               _msg = XMLInfo.npcXML["131"].msg0;
               myalter = Alert.showAlert(MainManager.getAppLevel(),_url,_msg,Alert.CHANG_ALERT,"otherJob_konw",true,true,"SMCUI") as Class;
            }
            else if(task131State == 1)
            {
               GV.onlineSocket.addEventListener(checkItem.chekItem_suc,this.itemSucHandler);
               checkItem.checkItemHandler(190191);
            }
            else
            {
               _url = XMLInfo.npcXML["131"].url3;
               _msg = XMLInfo.npcXML["131"].msg3;
               myalter = Alert.showAlert(MainManager.getAppLevel(),_url,_msg,Alert.CHANG_ALERT,"otherJob_konw",true,true,"SMCUI") as Class;
            }
         }
         
         private function itemSucHandler(evt:EventTaomee) : void
         {
            var _url:String = null;
            var _msg:String = null;
            var myalter:* = undefined;
            var loadGame:LoadGame = null;
            GV.onlineSocket.removeEventListener(checkItem.chekItem_suc,this.itemSucHandler);
            if(evt.EventObj.num == 1)
            {
               _url = "resource/allJob/AlertPic/crow/crow2.swf";
               _msg = "    你已經拿到消防員職業資格證，快去庫洛交任務！";
               myalter = Alert.showAlert(MainManager.getAppLevel(),_url,_msg,Alert.CHANG_ALERT,"otherJob_konw",true,true,"SMCUI");
            }
            else
            {
               loadGame = new LoadGame("module/external/FireManControl.swf","正在加載摩爾消防員入職測試",MainManager.getGameLevel());
               loadGame = null;
            }
         }
         
         override public function destroy() : void
         {
            GV.onlineSocket.removeEventListener("NPCOldJob",this.onNPCOldJob);
            GV.onlineSocket.removeEventListener("OVERNPCOldJob",this.overTaskTip);
            SystemEventManager.removeEventListener("fireKnight",this.onFireKnight);
            super.destroy();
         }
      }
   }
   
   