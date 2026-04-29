package com.module.farm
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.socket.action.ActionReq;
   import com.logic.socket.farm.farmSocket;
   import com.logic.socket.presentGoods.PresentGoodsReq;
   import com.logic.socket.presentGoods.PresentGoodsRes;
   import com.logic.switchMapLogic.switchMapLogic;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   
   public class FishingGame
   {
      
      public var FishingMC:MovieClip;
      
      public var eatingBool:Boolean;
      
      public var eatingID:uint;
      
      public var escapeID:uint;
      
      public var ranFish:uint;
      
      public var FishArr:Array;
      
      public var playBool:Boolean;
      
      public function FishingGame(mc:MovieClip)
      {
         super();
         this.FishingMC = mc;
         this.FishArr = FieldView.getInstance().FishArr;
         this.FishingMC.fisheat.buttonMode = true;
         BC.addEvent(this,this.FishingMC.fisheat,MouseEvent.CLICK,this.fishingClick);
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.sitdown);
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         BC.addEvent(this,GV.onlineSocket,"iskaddish",this.kaddishEndHandler);
      }
      
      private function kaddishEndHandler(evt:EventTaomee) : void
      {
         if(this.playBool)
         {
            this.eatingBool = false;
            this.playBool = false;
            this.FishingMC.fisheat.gotoAndStop(1);
            clearInterval(this.eatingID);
            clearTimeout(this.escapeID);
         }
      }
      
      private function automove() : void
      {
         var tempX:int = int(GV.MAN_PEOPLE.x);
         var tempY:int = GV.MAN_PEOPLE.y - 30;
         MoveTo.AutoFind(tempX,tempY,GV.MAN_PEOPLE);
      }
      
      public function leaveHome() : void
      {
         GV.Room_DefaultRoomID = 0;
         LocalUserInfo.setMapID(0);
         MainManager.getToolLevel().y = 0;
         GV.Room_DefaultRoomID = FieldView.hostID + GV.TwentyBillion;
         switchMapLogic.switchMapLogicHandler(FieldView.hostID + GV.TwentyBillion);
      }
      
      private function sitdown(evt:EventTaomee) : void
      {
         var msg:String = null;
         if(evt.EventObj.type == 333)
         {
            this.leaveHome();
            return;
         }
         var d:Number = 7;
         this.playBool = true;
         PeopleManageView(GV.MAN_PEOPLE).sitDown(d);
         var actionReq:ActionReq = new ActionReq();
         actionReq.actions(3,d);
         this.FishArr = FieldView.getInstance().FishArr;
         if(this.FishArr.length > 0)
         {
            this.gameStart();
         }
         else
         {
            msg = "目前這個魚池中沒有魚哦，去其他小摩爾家看看吧！";
            Alert.showAlert(MainManager.getAppLevel(),"",msg,Alert.IKNOW_ALERT);
         }
      }
      
      private function gameStart() : void
      {
         var rantime:Number = 2000 + int(Math.random() * 8) * 1000;
         if(FieldView.ismyhome)
         {
            clearInterval(this.eatingID);
            clearTimeout(this.escapeID);
            this.eatingBool = false;
            this.FishingMC.fisheat.gotoAndStop(2);
            this.eatingID = setInterval(this.eating,rantime);
         }
         else if(FieldView.getInstance().Locked)
         {
            Alert.showAlert(MainManager.getGameLevel(),"    目前魚塘已經被鎖了，你釣不到任何魚哦！","",6,"D");
         }
         else
         {
            clearInterval(this.eatingID);
            clearTimeout(this.escapeID);
            this.eatingBool = false;
            this.FishingMC.fisheat.gotoAndStop(2);
            this.eatingID = setInterval(this.eating,rantime);
         }
      }
      
      private function fishingClick(e:MouseEvent) : void
      {
         var ran:Number = NaN;
         var msg:String = null;
         var canFishingArr:Array = null;
         var i:uint = 0;
         if(this.eatingBool)
         {
            this.automove();
            clearInterval(this.eatingID);
            clearTimeout(this.escapeID);
            this.eatingBool = false;
            this.FishingMC.fisheat.gotoAndStop(1);
            if(FieldView.getInstance().Locked)
            {
               if(!FieldView.ismyhome)
               {
                  Alert.showAlert(MainManager.getGameLevel(),"    目前魚塘已經被鎖了，你釣不到任何魚哦！","",6,"D");
                  return;
               }
            }
            ran = 1;
            if(FieldView.ismyhome)
            {
               ran = 0.7;
            }
            else
            {
               ran = 0.5;
            }
            if(Math.random() > ran)
            {
               msg = "你真不走運，魚掙脫了魚鉤，再試一次吧！";
               Alert.showAlert(MainManager.getAppLevel(),"",msg,Alert.IKNOW_ALERT);
               return;
            }
            canFishingArr = [];
            for(i = 0; i < this.FishArr.length; i++)
            {
               if(this.FishArr[i].Value >= this.FishArr[i].LevelArray[2])
               {
                  canFishingArr.push(this.FishArr[i]);
               }
            }
            if(canFishingArr.length > 0)
            {
               this.ranFish = uint(Math.random() * canFishingArr.length);
               if(this.FishArr[this.ranFish].id == 1270009)
               {
                  if(Math.random() > 0.1)
                  {
                     BC.addEvent(this,GV.onlineSocket,"read_" + 1363,this.catchFishSuc);
                     BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_" + 1363,this.catchFishFail);
                     farmSocket.catch_animal(this.FishArr[this.ranFish].NO,0);
                  }
                  else
                  {
                     if(!FieldView.ismyhome)
                     {
                        msg = "你真不走運，魚掙脫了魚鉤，再試一次吧！！";
                        Alert.showAlert(MainManager.getAppLevel(),"",msg,Alert.IKNOW_ALERT);
                        return;
                     }
                     BC.addEvent(this,GV.onlineSocket,"read_" + 1363,this.catchFishSuc);
                     BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_" + 1363,this.catchFishFail);
                     farmSocket.catch_animal(this.FishArr[this.ranFish].NO,0);
                     this.FishArr.splice(this.ranFish,1);
                  }
               }
               else
               {
                  BC.addEvent(this,GV.onlineSocket,"read_" + 1363,this.catchFishSuc);
                  BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_" + 1363,this.catchFishFail);
                  farmSocket.catch_animal(this.FishArr[this.ranFish].NO,0);
                  this.FishArr.splice(this.ranFish,1);
               }
            }
            else
            {
               msg = "哎呀！真不走運，這條小魚掙脫了魚鉤，再試一次吧！";
               Alert.showAlert(MainManager.getAppLevel(),"",msg,Alert.IKNOW_ALERT);
            }
         }
      }
      
      public function getGuaiGuaiYu(type:int = 24) : void
      {
         GV.onlineSocket.addEventListener(PresentGoodsRes.PRESENT_GOODS_SUCC,this.getSeedSucc);
         GV.onlineSocket.addEventListener("ERROR_CMD_1116",this.getSeedError);
         PresentGoodsReq.req(type);
      }
      
      private function getSeedError(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(PresentGoodsRes.PRESENT_GOODS_SUCC,this.getSeedSucc);
         GV.onlineSocket.removeEventListener("ERROR_CMD_1116",this.getSeedError);
      }
      
      private function getSeedSucc(e:EventTaomee) : void
      {
         var msg:String = null;
         var url:String = null;
         GV.onlineSocket.removeEventListener(PresentGoodsRes.PRESENT_GOODS_SUCC,this.getSeedSucc);
         GV.onlineSocket.removeEventListener("ERROR_CMD_1116",this.getSeedError);
         if(e.EventObj.Flag == 1)
         {
            this.FishArr.splice(this.ranFish,1);
            url = "resource/farm/icon/" + e.EventObj.ItemID + ".swf";
            msg = "    你釣到一條" + GoodsInfo.getItemNameByID(e.EventObj.ItemID) + "，已經放入你的牧場倉庫中。趕快去看看吧！";
            Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"sure",true,false,"EMP_BUY");
         }
         else if(FieldView.ismyhome)
         {
            if(Math.random() <= 0.4)
            {
               msg = "你真不走運，魚掙脫了魚鉤，再試一次吧！！";
               Alert.showAlert(MainManager.getAppLevel(),"",msg,Alert.IKNOW_ALERT);
               return;
            }
            BC.addEvent(this,GV.onlineSocket,"read_" + 1363,this.catchFishSuc);
            BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_" + 1363,this.catchFishFail);
            farmSocket.catch_animal(this.FishArr[this.ranFish].NO,0);
            this.FishArr.splice(this.ranFish,1);
         }
         else
         {
            msg = "你今天已經釣過一條魚了,休息下明天再釣吧！";
            Alert.showAlert(MainManager.getAppLevel(),"",msg,Alert.IKNOW_ALERT);
         }
      }
      
      public function catchFishFail(E:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1363,this.catchFishSuc);
         BC.removeEvent(this,GV.onlineSocket,"ERROR_CMD_" + 1363,this.catchFishFail);
      }
      
      private function catchFishSuc(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1363,this.catchFishSuc);
         BC.removeEvent(this,GV.onlineSocket,"ERROR_CMD_" + 1363,this.catchFishFail);
         var obj:Object = GoodsInfo.getInfoById(e.EventObj.ItemID);
         var url:String = "resource/allJob/icon/" + e.EventObj.ItemID + ".swf";
         var msg:String = "    你釣到一條" + GoodsInfo.getItemNameByID(e.EventObj.ItemID) + "，已經放入你的摩摩倉庫庫中。趕快去看看吧！";
         Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"sure",true,false,"EMP_BUY");
         GF.sendSocket(CommandID.GOLDEN_BEAN_REWARD,0,6);
      }
      
      private function eating() : void
      {
         if(this.FishArr.length > 0)
         {
            this.eatingBool = true;
            this.FishingMC.fisheat.gotoAndStop(3);
            this.escapeID = setTimeout(this.escape,3000);
         }
      }
      
      private function escape() : void
      {
         this.eatingBool = false;
         this.FishingMC.fisheat.gotoAndStop(2);
      }
      
      private function removeEventHandler(E:Event) : void
      {
         clearInterval(this.eatingID);
         clearTimeout(this.escapeID);
         BC.removeEvent(this);
      }
   }
}

