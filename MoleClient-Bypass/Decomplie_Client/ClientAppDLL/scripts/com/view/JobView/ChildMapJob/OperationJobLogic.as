package com.view.JobView.ChildMapJob
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.randomItemDrawLogic.randomItemDrawLogic;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.logic.socket.OperationJob.*;
   import com.logic.socket.giveMeMoney.giveMeMoneyReq;
   import com.logic.socket.sendWater.SendWaterRes;
   import com.logic.socket.waterTub.WaterTubOverTimeRes;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class OperationJobLogic extends Sprite
   {
      
      public static var OneOpeLogic:OperationJobLogic;
      
      private static var TYPE:uint = 327;
      
      public var myAlt:*;
      
      private var now_Info:Object;
      
      public var target_mc:MovieClip;
      
      public var con_mc:MovieClip;
      
      public function OperationJobLogic()
      {
         super();
         this.now_Info = {
            "job_flag":0,
            "count":0
         };
      }
      
      public static function getOneOperation() : OperationJobLogic
      {
         if(OneOpeLogic == null)
         {
            OneOpeLogic = new OperationJobLogic();
         }
         return OneOpeLogic;
      }
      
      public function getNow_Info() : Object
      {
         return this.now_Info;
      }
      
      public function beginFun(MC:MovieClip, BtnMC:MovieClip) : void
      {
         this.con_mc = BtnMC;
         this.target_mc = MC;
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeEventHandler);
         this.getOpeInfo();
      }
      
      public function showMC() : void
      {
         BC.removeEvent(this);
         this.con_mc.mc.gotoAndStop(1);
         this.target_mc.goods_mc.visible = false;
         this.target_mc.btn.visible = true;
         switch(this.now_Info.job_flag)
         {
            case 0:
               this.con_mc.mc.gotoAndStop(1);
               BC.addEvent(this,this.target_mc.btn,MouseEvent.CLICK,this.beginOneJob);
               break;
            case 1:
               this.con_mc.mc.gotoAndStop(1);
               BC.addEvent(this,this.target_mc.btn,MouseEvent.CLICK,this.chartOneJob);
               break;
            case 2:
               this.con_mc.mc.gotoAndStop("add");
               BC.addEvent(this,this.target_mc.btn,MouseEvent.CLICK,this.beginTwoJob);
               break;
            case 3:
               this.con_mc.mc.gotoAndStop("add");
               BC.addEvent(this,this.target_mc.btn,MouseEvent.CLICK,this.chartTwoJob);
               break;
            case 4:
               this.target_mc.btn.visible = false;
               this.con_mc.mc.gotoAndStop(this.con_mc.mc.totalFrames - 1);
               this.showGoodsMC();
         }
      }
      
      private function beginOneJob(event:MouseEvent) : void
      {
         this.showAlertF(0);
      }
      
      private function beginOne(event:Event) : void
      {
         BC.removeEvent(this,this.myAlt,Alert.CLICK_ + "1",this.beginOne);
         this.setOpeInfo(1,0);
      }
      
      private function chartOneJob(event:MouseEvent) : void
      {
         this.showAlertF(1);
      }
      
      public function pouredPucketEvent(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,SendWaterRes.SENDWATER,this.pouredPucketEvent);
         var overTimeObj:Object = new Object();
         overTimeObj.UserID = evt.EventObj.Userid;
         overTimeObj.ItemID = 0;
         GV.onlineSocket.dispatchEvent(new EventTaomee(WaterTubOverTimeRes.OVER_TIME,overTimeObj));
      }
      
      private function beginTwoJob(event:*) : void
      {
         this.showAlertF(2);
      }
      
      private function nobeginTwoJob(event:*) : void
      {
         this.showMC();
      }
      
      private function beginTwo(event:Event) : void
      {
         BC.removeEvent(this,this.myAlt,Alert.CLICK_ + "1",this.beginTwo);
         this.setOpeInfo(3,0);
      }
      
      private function chartTwoJob(event:MouseEvent) : void
      {
         var now_info:uint = 190025;
         BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.chartGoodFun);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),now_info,2);
      }
      
      private function chartGoodFun(event:EventTaomee) : void
      {
         var buy_arr:Array = null;
         var del_arr:Array = null;
         var buyItem:giveMeMoneyReq = null;
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.chartGoodFun);
         var obj:Object = event.EventObj.obj;
         if(obj.Count > 0)
         {
            buy_arr = [{
               "kind":1230005,
               "num":5
            }];
            del_arr = [{
               "kind":190025,
               "num":1
            }];
            buyItem = new giveMeMoneyReq(del_arr,buy_arr);
            this.con_mc.mc.gotoAndPlay("add");
            GC.setGTimeout(this.setOpeInfo,1000,4,0);
         }
         else
         {
            this.showAlertF(3);
         }
      }
      
      private function getLastGoods(event:Event) : void
      {
         BC.removeEvent(this,this.myAlt,Alert.CLICK_ + "1",this.getLastGoods);
         this.showAlertF(4);
      }
      
      public function showGoodsMC() : void
      {
         var temp_:* = undefined;
         if(this.now_Info.count > 3)
         {
            this.target_mc.goods_mc.visible = false;
            this.con_mc.mc.gotoAndStop(this.con_mc.mc.totalFrames);
            return;
         }
         this.target_mc.goods_mc.visible = true;
         for(var ia:uint = 1; ia < 5; ia++)
         {
            temp_ = this.target_mc.goods_mc["btn_" + ia];
            BC.addEvent(this,temp_,MouseEvent.CLICK,this.getOneGood);
         }
      }
      
      private function getOneGood(event:MouseEvent) : void
      {
         var BTN:* = event.currentTarget;
         BTN.visible = false;
         BC.addEvent(this,GV.onlineSocket,"giveMoneyEvent",this.onBuySuccess);
         var buy_arr:Array = [{
            "kind":190023,
            "num":1
         }];
         randomItemDrawLogic.moneyAction(buy_arr,0);
      }
      
      private function onBuySuccess(event:*) : void
      {
         ++this.now_Info.count;
         BC.removeEvent(this,GV.onlineSocket,"giveMoneyEvent",this.onBuySuccess);
         this.setOpeInfo(4,this.now_Info.count);
      }
      
      private function showAlertF(flag:uint = 0) : void
      {
         var url:String = "";
         var info:String = "";
         switch(flag)
         {
            case 0:
               url = "resource/allJob/AlertPic/banyan.swf";
               info = "    今年的冬天太乾旱了，好不容易盼來的春雨也只是星星點點，你可以幫我去神秘湖取一些湖水來嗎？我真是太渴了！";
               this.myAlt = Alert.showAlert(MainManager.getAppLevel(),url,info,Alert.CHANG_ALERT,"go,notgo",true,false,"SMCUI");
               BC.addEvent(this,this.myAlt,Alert.CLICK_ + "1",this.beginOne);
               break;
            case 1:
               url = "resource/allJob/AlertPic/banyan.swf";
               info = "    水....你帶來神秘湖的湖水了嗎？我好渴啊，看看我的葉子，他們都快枯萎了！親愛的小摩爾，請你幫幫我吧！";
               this.myAlt = Alert.showAlert(MainManager.getAppLevel(),url,info,Alert.CHANG_ALERT,"iknow",true,false,"SMCUI");
               break;
            case 11:
               url = "resource/allJob/AlertPic/banyan1.swf";
               info = "    甜甜的湖水，真好喝啊！太感謝你了！rr    你願意再幫我一個忙嗎？";
               this.myAlt = Alert.showAlert(MainManager.getAppLevel(),url,info,Alert.CHANG_ALERT,"npcgo,notgo",true,false,"SMCUI");
               BC.addEvent(this,this.myAlt,Alert.CLICK_ + "1",this.beginTwoJob);
               BC.addEvent(this,this.myAlt,Alert.CLICK_ + "2",this.nobeginTwoJob);
               break;
            case 2:
               url = "resource/allJob/AlertPic/banyan.swf";
               info = "    由於乾旱過度，土壤營養不斷流失，原本這個季節我已經可以開花結果了，可是瞧我現在這個樣子，嗚~~rr    聽說有一種叫做七色花的東西，對我來說可是神丹妙藥，你可以幫我找來嗎？1朵就行！";
               this.myAlt = Alert.showAlert(MainManager.getAppLevel(),url,info,Alert.CHANG_ALERT,"go,notgo",true,false,"SMCUI");
               BC.addEvent(this,this.myAlt,Alert.CLICK_ + "1",this.beginTwo);
               BC.addEvent(this,this.myAlt,Alert.CLICK_ + "2",this.nobeginTwoJob);
               break;
            case 3:
               url = "resource/allJob/AlertPic/banyan.swf";
               info = "    你找到七色花了嗎？聽說它生長在很高很高靠近雲彩的地方。你可以幫我找來一朵嗎？有了它我就可以恢復能量了！";
               this.myAlt = Alert.showAlert(MainManager.getAppLevel(),url,info,Alert.CHANG_ALERT,"iknow",true,false,"SMCUI");
               break;
            case 33:
               url = "resource/allJob/AlertPic/banyan2.swf";
               info = "    哇！你真是一個聰明可愛的小摩爾！現在我終於恢復能量了，很快就會長成參天大樹。為了感謝你，我要送你5顆草莓種子，還有我身上的果實，盡情摘取吧！";
               this.myAlt = Alert.showAlert(MainManager.getAppLevel(),url,info,Alert.CHANG_ALERT,"iknow",true,false,"SMCUI");
               BC.addEvent(this,this.myAlt,Alert.CLICK_ + "1",this.getLastGoods);
               break;
            case 4:
               url = "resource/home/seed/icon/1230005.swf";
               info = "    恭喜你獲得5個草莓種子，已經放入你的家園倉庫裡！";
               this.myAlt = Alert.showAlert(MainManager.getAppLevel(),url,info,Alert.CHANG_ALERT,"iknow",true,false,"EMP_BUY");
               this.showMC();
               break;
            case 5:
               url = "resource/allJob/icon/190023.swf";
               info = "    恭喜你獲得1個食用漿果，已經放入你的背包中！";
               this.myAlt = Alert.showAlert(MainManager.getAppLevel(),url,info,Alert.CHANG_ALERT,"iknow",true,false,"EMP_BUY");
               this.showMC();
         }
      }
      
      public function getOpeInfo() : void
      {
         BC.addEvent(this,GV.onlineSocket,GetMutualRes.GET_MUTUAL_BACK,this.backInfoFun);
         GetMutualReq.GetInfo();
      }
      
      public function backInfoFun(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,GetMutualRes.GET_MUTUAL_BACK,this.backInfoFun);
         var Obj:Object = event.EventObj.obj;
         if(Obj.type == 0)
         {
            this.setOpeInfo();
         }
         else
         {
            this.now_Info.job_flag = Obj.job;
            this.now_Info.count = Obj.count;
         }
         this.showMC();
      }
      
      public function setOpeInfo(obj:uint = 0, count:uint = 0) : void
      {
         this.now_Info.job_flag = obj;
         this.now_Info.count = count;
         BC.addEvent(this,GV.onlineSocket,SetMutualRes.SET_MUTUAL_BACK,this.backSetFun);
         SetMutualReq.SetInfo(TYPE,obj,count);
      }
      
      public function backSetFun(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,SetMutualRes.SET_MUTUAL_BACK,this.backSetFun);
         if(this.now_Info.job_flag == 2)
         {
            this.showAlertF(11);
         }
         else if(this.now_Info.job_flag == 4 && this.now_Info.count > 0)
         {
            this.showAlertF(5);
         }
         else if(this.now_Info.job_flag == 4 && this.now_Info.count == 0)
         {
            this.showAlertF(33);
         }
         else
         {
            this.showMC();
         }
      }
      
      public function removeInfo() : void
      {
         this.now_Info = {
            "job_flag":0,
            "count":0
         };
         BC.addEvent(this,GV.onlineSocket,SetMutualRes.SET_MUTUAL_BACK,this.backSetFun);
         SetMutualReq.removeInfo();
      }
      
      private function removeEventHandler(eve:EventTaomee) : void
      {
         BC.removeEvent(this);
         this.now_Info = {
            "job_flag":0,
            "count":0
         };
         OneOpeLogic = null;
         this.target_mc = null;
         this.con_mc = null;
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeEventHandler);
      }
   }
}

