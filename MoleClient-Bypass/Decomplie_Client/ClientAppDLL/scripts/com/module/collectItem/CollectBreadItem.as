package com.module.collectItem
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.JobLogic.JobExpandLogic;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.logic.socket.shopItem.BuyItemReq;
   import com.logic.socket.shopItem.BuyItemRes;
   import com.mole.app.task.TaskManager;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   
   public class CollectBreadItem
   {
      
      private static var instance:CollectBreadItem;
      
      private var goodButton:SimpleButton;
      
      private var tipStr:String;
      
      private var jobId:uint;
      
      private var manyGood:uint;
      
      private var startID:uint;
      
      private var endID:uint;
      
      private var itemID:uint;
      
      private var jobid:uint;
      
      private var tipWord:String;
      
      private var _itemCount:uint = 1;
      
      private var takeStr:String;
      
      private var jobSort:uint;
      
      public function CollectBreadItem()
      {
         super();
      }
      
      public static function getInstance() : CollectBreadItem
      {
         if(instance == null)
         {
            instance = new CollectBreadItem();
         }
         return instance;
      }
      
      public function set goodLen(len:uint) : void
      {
         this.manyGood = len;
      }
      
      public function set startItemID(itemID:uint) : void
      {
         this.startID = itemID;
      }
      
      public function set endItemID(itemID:uint) : void
      {
         this.endID = itemID;
      }
      
      public function set jobStr(str:String) : void
      {
         this.tipWord = str;
      }
      
      public function set itemCount(count:uint) : void
      {
         this._itemCount = count;
      }
      
      public function set jobID(job:uint) : void
      {
         this.jobid = job;
      }
      
      public function set item(id:uint) : void
      {
         this.itemID = id;
      }
      
      public function set getItemStr(str:String) : void
      {
         this.takeStr = str;
      }
      
      public function set jobSortNum(num:uint) : void
      {
         this.jobSort = num;
      }
      
      public function initButtonEvent(button:SimpleButton) : void
      {
         this.goodButton = button;
         if(TaskManager.getTaskState(this.jobId) == 1)
         {
            button.mouseEnabled = true;
            button.visible = true;
            GV.onlineSocket.addEventListener("removeMapEvent",this.removeEventHandler);
            this.goodButton.addEventListener(MouseEvent.CLICK,this.buttonHandler);
         }
      }
      
      private function buttonHandler(event:MouseEvent) : void
      {
         this.goodButton.visible = false;
         var simpleButton:SimpleButton = event.currentTarget as SimpleButton;
         var id:uint = uint(simpleButton.name.substr(3));
         if(id != 1230008)
         {
            this.buyChargeItem(id);
         }
         else
         {
            this.judgeSeed(id);
         }
      }
      
      private function judgeSeed(id:uint) : void
      {
         this.itemID = id;
         BC.addEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.showInfoMC);
         JobExpandLogic.getJobExpand().getOneJob(this.jobid);
      }
      
      public function showInfoMC(events:EventTaomee = null) : void
      {
         var count:uint = 0;
         if(this.jobSort == 0)
         {
            BC.removeEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.showInfoMC);
         }
         count = uint(events.EventObj.obj.Count);
         if(count == 1)
         {
            Alert.showAlert(MainManager.getAppLevel(),this.takeStr,"",Alert.CHANG_ALERT,"iknow",true,false,"D");
         }
         else
         {
            this.buyChargeItem(this.itemID);
         }
      }
      
      public function buyChargeItem(item:uint) : void
      {
         this.itemID = item;
         GV.onlineSocket.addEventListener(BuyItemRes.BUY_ITEM_SUCCESS,this.buyItemSucc);
         GV.onlineSocket.addEventListener("sameEvent",this.sameEventHandler);
         var buyItemReq:BuyItemReq = new BuyItemReq();
         buyItemReq.buyItems(this.itemID,this._itemCount);
         buyItemReq = null;
      }
      
      private function buyItemSucc(evt:EventTaomee) : void
      {
         var _url:String = null;
         var EventObj:Object = null;
         if(this.itemID == 1230008)
         {
            EventObj = JobExpandLogic.getJobExpand().getAllJobInfo()[this.jobid];
            EventObj.Count = 1;
            JobExpandLogic.getJobExpand().setOneJob(this.jobid,EventObj);
            _url = "resource/home/seed/icon/" + String(this.itemID) + ".swf";
         }
         else
         {
            _url = "resource/allJob/icon/" + String(this.itemID) + ".swf";
         }
         GV.onlineSocket.removeEventListener(BuyItemRes.BUY_ITEM_SUCCESS,this.buyItemSucc);
         var myalter:* = Alert.showAlert(MainManager.getAppLevel(),_url,this.tipWord,Alert.CHANG_ALERT,"ok",true,false,"EMP_BUY");
         if(this.jobid != 62)
         {
            this.checkAllItem();
         }
      }
      
      public function checkAllItem() : void
      {
         GV.onlineSocket.addEventListener(GetItemCountRes.GET_ITEMCOUNT,this.getItemCountLogic);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),this.startID,2,this.endID);
      }
      
      private function getItemCountLogic(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(GetItemCountRes.GET_ITEMCOUNT,this.getItemCountLogic);
         if(evt.EventObj.obj.arr.length == this.manyGood)
         {
            GV.JobViews.showJob(this.jobid);
         }
      }
      
      private function removeEventHandler(event:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("sameEvent",this.sameEventHandler);
         GV.onlineSocket.removeEventListener(BuyItemRes.BUY_ITEM_SUCCESS,this.buyItemSucc);
         GV.onlineSocket.removeEventListener(GetItemCountRes.GET_ITEMCOUNT,this.getItemCountLogic);
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeEventHandler);
      }
      
      private function sameEventHandler(event:EventTaomee) : void
      {
         this.removeEventHandler(null);
      }
   }
}

