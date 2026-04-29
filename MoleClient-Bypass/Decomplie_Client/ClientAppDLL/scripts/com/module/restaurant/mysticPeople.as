package com.module.restaurant
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.oneBigStreetSocket.oneBigStreetSocket;
   import com.module.npc.NPC;
   import com.module.npc.dialog.TalkEvent;
   import com.module.npc.dialog.TalkMessage;
   import com.module.npc.npcInstance.MoleNPC;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.info.NPCDialogInfo;
   import com.mole.app.info.NPCDialogOptionInfo;
   import com.mole.app.manager.BagViewManager;
   import com.mole.app.manager.NPCDialogManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.type.ActionType;
   import com.mole.manager.DialogManager;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class mysticPeople
   {
      
      private static var instance:mysticPeople;
      
      private static var canotNew:Boolean = true;
      
      private var restaurantTool:RestaurantTool;
      
      public var npcMysticPeople:MoleNPC;
      
      private var tempMoney:int;
      
      private var tempCount:int;
      
      private var tempFoodName:String;
      
      public var strTeamName:String;
      
      public function mysticPeople()
      {
         super();
         if(canotNew)
         {
            throw new Error("mysticPeople不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : mysticPeople
      {
         if(!instance)
         {
            canotNew = false;
            instance = new mysticPeople();
            canotNew = true;
         }
         return instance;
      }
      
      public function init() : void
      {
         this.restaurantTool = new RestaurantTool();
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         BC.addEvent(this,TalkEvent,TalkEvent.THROW_DATA,this.changeMsgFun);
         BagViewManager.addEventListener(BagViewManager.USE_EFFECT_PROP + "_16011",this.onMysticPeople);
         this.npcInit();
      }
      
      private function onMysticPeople(evt:EventTaomee) : void
      {
         if(this.npcMysticPeople != null)
         {
            Alert.smileAlart("　　神秘商人已經在你的餐廳中了，在週圍仔細看看吧。");
            this.closeBagView();
         }
         else if(this.restaurantTool.queryMakeOverFoodCount() > 0)
         {
            if(this.restaurantTool.queryMakeOverFoodCount200())
            {
               BC.addEvent(this,GV.onlineSocket,"read_1043",this.onRead1043);
               oneBigStreetSocket.querySellFood();
            }
            else
            {
               Alert.smileAlart("　　你做好的菜數量太少了，神秘商人是不會感興趣的。");
               this.closeBagView();
            }
         }
         else
         {
            Alert.smileAlart("　　菜沒有做好神秘商人是不會過來的哦，趕快多做幾道菜吧。");
            this.closeBagView();
         }
      }
      
      private function onRead1043(evt:EventTaomee) : void
      {
         var npcOptionInfo:NPCDialogOptionInfo = null;
         BC.removeEvent(this,GV.onlineSocket,"read_1043",this.onRead1043);
         this.tempMoney = evt.EventObj.money;
         this.tempCount = evt.EventObj.count;
         this.tempFoodName = GoodsInfo.getItemNameByID(evt.EventObj.itemId);
         this.closeBagView();
         this.strTeamName = this.tempMoney + "摩爾豆的價格收購你" + this.tempCount + "份的" + this.tempFoodName + "怎麼樣？";
         DialogManager.addMatch("team",this.strTeamName);
         this.npcMysticPeople = NPC.getNPCInstance(1038,true);
         var sayList:Array = new Array();
         npcOptionInfo = new NPCDialogOptionInfo("你想買哪道菜呢？",ActionType.TASK_FUNCTION,this.npcSay5,false);
         sayList.push(npcOptionInfo);
         npcOptionInfo = new NPCDialogOptionInfo("你走吧，我不賣了",ActionType.TASK_FUNCTION,this.npcSay2,false);
         sayList.push(npcOptionInfo);
         var npcDialogInfo:NPCDialogInfo = new NPCDialogInfo(10085,"正常","你的餐廳看著很衛生，裝潢的也不錯，我來看看有哪些菜是我感興趣的。",sayList);
         NPCDialogManager.say(npcDialogInfo);
         this.npcMysticPeople.dialogInfo = npcDialogInfo;
      }
      
      private function npcInit() : void
      {
         SystemEventManager.addEventListener("npc_nextFood",this.onNpcNextFood);
         SystemEventManager.addEventListener("npc_hide",this.onNpcHide);
         SystemEventManager.addEventListener("npc_success",this.onNpcSuccess);
      }
      
      private function onNpcNextFood(e:SystemEvent) : void
      {
         this.getSellFood();
      }
      
      private function onNpcHide(e:SystemEvent) : void
      {
         this.clearNpc();
      }
      
      private function onNpcSuccess(e:SystemEvent) : void
      {
         this.SellFoodSuccess();
      }
      
      private function npcSay2() : void
      {
         var npcOptionInfo:NPCDialogOptionInfo = null;
         var sayList:Array = new Array();
         npcOptionInfo = new NPCDialogOptionInfo("我再想想",ActionType.SYSTEM_ACT,"npc_nextFood");
         sayList.push(npcOptionInfo);
         npcOptionInfo = new NPCDialogOptionInfo("我真的不賣了",ActionType.TASK_FUNCTION,this.npcSay6,false);
         sayList.push(npcOptionInfo);
         var npcDialogInfo:NPCDialogInfo = new NPCDialogInfo(10085,"正常","呵呵呵，你再仔細考慮考慮嘛，我開的價格可是很公道的哦。",sayList);
         NPCDialogManager.say(npcDialogInfo);
      }
      
      private function npcSay3() : void
      {
         var npcOptionInfo:NPCDialogOptionInfo = null;
         DialogManager.addMatch("team",this.strTeamName);
         var sayList:Array = new Array();
         npcOptionInfo = new NPCDialogOptionInfo("再見",ActionType.SYSTEM_ACT,"npc_hide");
         sayList.push(npcOptionInfo);
         var npcDialogInfo:NPCDialogInfo = new NPCDialogInfo(10085,"正常","呵呵呵，這是給你的{$team}摩爾豆，菜我就帶走了，下次有機會再見哦",sayList);
         NPCDialogManager.say(npcDialogInfo);
      }
      
      private function npcSay4() : void
      {
         var npcOptionInfo:NPCDialogOptionInfo = null;
         var sayList:Array = new Array();
         npcOptionInfo = new NPCDialogOptionInfo("好的",ActionType.SYSTEM_ACT,"npc_nextFood");
         sayList.push(npcOptionInfo);
         npcOptionInfo = new NPCDialogOptionInfo("你走吧，我不賣了",ActionType.TASK_FUNCTION,this.npcSay2,false);
         sayList.push(npcOptionInfo);
         var npcDialogInfo:NPCDialogInfo = new NPCDialogInfo(10085,"正常","哎呀呀，你這道菜好像數量不夠了呀，我收購你別的菜吧。",sayList);
         NPCDialogManager.say(npcDialogInfo);
      }
      
      private function npcSay5() : void
      {
         var npcOptionInfo:NPCDialogOptionInfo = null;
         DialogManager.addMatch("team",this.strTeamName);
         var sayList:Array = new Array();
         npcOptionInfo = new NPCDialogOptionInfo("好的，成交",ActionType.SYSTEM_ACT,"npc_success");
         sayList.push(npcOptionInfo);
         npcOptionInfo = new NPCDialogOptionInfo("出價太低了",ActionType.SYSTEM_ACT,"npc_nextFood");
         sayList.push(npcOptionInfo);
         npcOptionInfo = new NPCDialogOptionInfo("你走吧，我不賣了",ActionType.TASK_FUNCTION,this.npcSay2,false);
         sayList.push(npcOptionInfo);
         var npcDialogInfo:NPCDialogInfo = new NPCDialogInfo(10085,"正常","我決定以總價{$team}。",sayList);
         NPCDialogManager.say(npcDialogInfo);
      }
      
      private function npcSay6() : void
      {
         var npcOptionInfo:NPCDialogOptionInfo = null;
         var sayList:Array = new Array();
         npcOptionInfo = new NPCDialogOptionInfo("再見",ActionType.SYSTEM_ACT,"npc_hide");
         sayList.push(npcOptionInfo);
         var npcDialogInfo:NPCDialogInfo = new NPCDialogInfo(10085,"正常","呵呵呵，那我們青山不改，綠水長流，後會有期吧。",sayList);
         NPCDialogManager.say(npcDialogInfo);
      }
      
      private function npcSay7() : void
      {
         var npcOptionInfo:NPCDialogOptionInfo = null;
         var sayList:Array = new Array();
         npcOptionInfo = new NPCDialogOptionInfo("再見",ActionType.SYSTEM_ACT,"npc_hide");
         sayList.push(npcOptionInfo);
         var npcDialogInfo:NPCDialogInfo = new NPCDialogInfo(10085,"正常","哎呀呀，你做好的菜怎麼這麼少呀？我還有別的事情要先走了等你菜做好了再找我吧。",sayList);
         NPCDialogManager.say(npcDialogInfo);
      }
      
      private function changeMsgFun(d:TalkEvent) : void
      {
         var msgInfo:Object = d.data;
         var msg:String = TalkMessage(msgInfo).msg;
         DialogManager.addMatch("team",this.strTeamName);
      }
      
      public function getSellFood() : void
      {
         BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_-100193",this.onGetSellFoodFail);
         BC.addEvent(this,GV.onlineSocket,"read_1043",this.onNextFood);
         oneBigStreetSocket.querySellFood();
      }
      
      private function onGetSellFoodFail(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"ERROR_CMD_-100193",this.onGetSellFoodFail);
         this.npcSay7();
      }
      
      private function onNextFood(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_1043",this.onNextFood);
         this.tempMoney = evt.EventObj.money;
         this.tempCount = evt.EventObj.count;
         this.tempFoodName = GoodsInfo.getItemNameByID(evt.EventObj.itemId);
         this.strTeamName = this.tempMoney + "摩爾豆的價格收購你" + this.tempCount + "份的" + this.tempFoodName + "怎麼樣？";
         DialogManager.addMatch("team",this.strTeamName);
         this.npcSay5();
      }
      
      public function clearNpc() : void
      {
         var buttonLevel:MovieClip = RestaurantBeen.getInstance().getRestaurantMC().buttonLevel;
         BC.addEvent(this,this.npcMysticPeople,PeopleManageView.ON_GO_OVER,this.onGoOver);
         this.npcMysticPeople.autoMove = false;
         this.npcMysticPeople.MoveTo(buttonLevel.exitPonit.x,buttonLevel.exitPonit.y);
      }
      
      private function onGoOver(evt:Event) : void
      {
         BC.removeEvent(this,this.npcMysticPeople,PeopleManageView.ON_GO_OVER,this.onGoOver);
         this.npcMysticPeople.clearClass();
         this.npcMysticPeople = null;
      }
      
      public function SellFoodSuccess() : void
      {
         BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_-100192",this.onSellFoodFail);
         BC.addEvent(this,GV.onlineSocket,"read_1044",this.onSellFood);
         oneBigStreetSocket.getSellFood();
      }
      
      private function onSellFood(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_1044",this.onSellFood);
         LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + evt.EventObj.money);
         var houseObj:Object = RestaurantBeen.getInstance().getRestaurantInfo().houseInfo;
         houseObj.houseMoney += evt.EventObj.money;
         this.strTeamName = evt.EventObj.money;
         DialogManager.addMatch("team",this.strTeamName);
         this.npcSay3();
         this.restaurantTool.upDateFoodCountByFoodIndex(evt.EventObj.foodIndexId,evt.EventObj.count);
      }
      
      private function onSellFoodFail(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"ERROR_CMD_-100192",this.onSellFoodFail);
         this.npcSay4();
      }
      
      private function closeBagView() : void
      {
         BagViewManager.closeBag();
      }
      
      private function removeEventHandler(evt:EventTaomee) : void
      {
         SystemEventManager.removeEventListener("npc_nextFood",this.onNpcNextFood);
         SystemEventManager.removeEventListener("npc_hide",this.onNpcHide);
         SystemEventManager.removeEventListener("npc_success",this.onNpcSuccess);
         BagViewManager.removeEventListener(BagViewManager.USE_EFFECT_PROP + "_16011",this.onMysticPeople);
         BC.removeEvent(this);
         this.npcMysticPeople = null;
      }
   }
}

