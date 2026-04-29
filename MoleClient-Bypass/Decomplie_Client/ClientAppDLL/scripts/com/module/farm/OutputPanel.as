package com.module.farm
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.logic.socket.farm.farmSocket;
   import com.module.present.PresentManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class OutputPanel extends FieldPanel
   {
      
      public static var instance:OutputPanel;
      
      public var OutputArr:Array;
      
      public var OutputArr1:Array;
      
      public var OutputArr2:Array;
      
      public var OutputArr_:Array;
      
      public var OutputArr2_2:Array;
      
      public var OutputArr2_3:Array;
      
      public var OutputArr2_4:Array;
      
      public function OutputPanel()
      {
         super();
         URL = "resource/allJob/icon/";
         classLink = "output_UI";
      }
      
      public static function getInstance() : OutputPanel
      {
         if(instance == null)
         {
            instance = new OutputPanel();
         }
         return instance;
      }
      
      private function getCarrotNum() : void
      {
         this.OutputArr1 = [];
         this.OutputArr2 = [];
         this.OutputArr2_2 = [];
         this.OutputArr2_3 = [];
         this.OutputArr2_4 = [];
         for(var i:uint = 0; i < this.OutputArr.length; i++)
         {
            if(this.OutputArr[i].AgriculturalType == 1)
            {
               this.OutputArr1.push(this.OutputArr[i]);
            }
            else if(this.OutputArr[i].AgriculturalType == 2)
            {
               this.OutputArr2.push(this.OutputArr[i]);
            }
         }
         for(var j:int = 0; j < this.OutputArr_.length; j++)
         {
            if(this.OutputArr_[j].starLevel == 1)
            {
               this.OutputArr2_2.push(this.OutputArr_[j]);
            }
            else if(this.OutputArr_[j].starLevel == 2)
            {
               this.OutputArr2_3.push(this.OutputArr_[j]);
            }
            else if(this.OutputArr_[j].starLevel == 3)
            {
               this.OutputArr2_4.push(this.OutputArr_[j]);
            }
         }
         showPanel(this.OutputArr2);
         this.addClickEvent();
      }
      
      public function addClickEvent() : void
      {
         Panel.farm_btn.gotoAndStop(2);
         Panel.farm2_btn.gotoAndStop(1);
         Panel.farm3_btn.gotoAndStop(1);
         Panel.farm4_btn.gotoAndStop(1);
         Panel.plant_btn.gotoAndStop(1);
         BC.addEvent(this,Panel.farm_btn,MouseEvent.CLICK,this.clickBtn1Fun);
         BC.addEvent(this,Panel.plant_btn,MouseEvent.CLICK,this.clickBtn2Fun);
         BC.addEvent(this,Panel.farm2_btn,MouseEvent.CLICK,this.clickBtn3Fun);
         BC.addEvent(this,Panel.farm3_btn,MouseEvent.CLICK,this.clickBtn4Fun);
         BC.addEvent(this,Panel.farm4_btn,MouseEvent.CLICK,this.clickBtn5Fun);
      }
      
      public function getOutputNum() : void
      {
         BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getOutputNumSucc);
         GetItemCountReq.getItemCount(FieldView.hostID,190001,2,199999);
      }
      
      private function clickBtn1Fun(e:MouseEvent) : void
      {
         clearItems();
         Panel.farm_btn.gotoAndStop(2);
         Panel.plant_btn.gotoAndStop(1);
         Panel.farm2_btn.gotoAndStop(1);
         Panel.farm3_btn.gotoAndStop(1);
         Panel.farm4_btn.gotoAndStop(1);
         showPanel(this.OutputArr2);
      }
      
      private function clickBtn2Fun(e:MouseEvent) : void
      {
         clearItems();
         Panel.farm_btn.gotoAndStop(1);
         Panel.farm2_btn.gotoAndStop(1);
         Panel.farm3_btn.gotoAndStop(1);
         Panel.farm4_btn.gotoAndStop(1);
         Panel.plant_btn.gotoAndStop(2);
         showPanel(this.OutputArr1);
      }
      
      private function clickBtn3Fun(e:MouseEvent) : void
      {
         clearItems();
         Panel.farm_btn.gotoAndStop(1);
         Panel.farm2_btn.gotoAndStop(2);
         Panel.farm3_btn.gotoAndStop(1);
         Panel.farm4_btn.gotoAndStop(1);
         Panel.plant_btn.gotoAndStop(1);
         showPanel(this.OutputArr2_2);
      }
      
      private function clickBtn4Fun(e:MouseEvent) : void
      {
         clearItems();
         Panel.farm_btn.gotoAndStop(1);
         Panel.farm2_btn.gotoAndStop(1);
         Panel.farm3_btn.gotoAndStop(2);
         Panel.farm4_btn.gotoAndStop(1);
         Panel.plant_btn.gotoAndStop(1);
         showPanel(this.OutputArr2_3);
      }
      
      private function clickBtn5Fun(e:MouseEvent) : void
      {
         clearItems();
         Panel.farm_btn.gotoAndStop(1);
         Panel.farm2_btn.gotoAndStop(1);
         Panel.farm3_btn.gotoAndStop(1);
         Panel.farm4_btn.gotoAndStop(2);
         Panel.plant_btn.gotoAndStop(1);
         showPanel(this.OutputArr2_4);
      }
      
      private function getOutputNumSucc(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getOutputNumSucc);
         this.OutputArr = e.EventObj.obj.arr;
         BC.addEvent(this,GV.onlineSocket,"read_1467",this.onGetStarAnimal);
         farmSocket.getStarAnimal(FieldView.hostID);
      }
      
      private function onGetStarAnimal(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_1467",this.onGetStarAnimal);
         this.OutputArr_ = e.EventObj.arr;
         this.getCarrotNum();
      }
      
      override public function userPorp(e:MouseEvent) : void
      {
         var goods:Object = null;
         var i:int = 0;
         if(FieldView.ismyhome)
         {
            goods = e.target.parent;
            trace(goods);
            i = super.CanGiveGood.indexOf(String(goods.ID));
            if(Panel.farm2_btn.currentFrame == 2 || Panel.farm3_btn.currentFrame == 2 || Panel.farm4_btn.currentFrame == 2)
            {
               trace("星級動物按鈕 TODO");
               ClosePanel(e);
               BC.addEvent(this,GV.onlineSocket,"read_" + 1374,this.FollowSuc);
               BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_" + 1374,this.FollowFail);
               farmSocket.farm_follow(goods.obj.animalId);
            }
            else if(i >= 0)
            {
               ClosePanel(e);
               PresentManager.init(super.SendGood[i]);
               PresentManager.maxCount(goods.Count);
            }
            else
            {
               Alert.showAlert(MainManager.getGameLevel(),"    這種農副產品是無法贈送的哦，試試給好友送上其它禮物吧。","",6,"D");
            }
         }
      }
      
      public function FollowFail(E:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1374,this.FollowSuc);
         BC.removeEvent(this,GV.onlineSocket,"ERROR_CMD_" + 1374,this.FollowFail);
      }
      
      public function FollowSuc(E:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1374,this.FollowSuc);
      }
      
      public function catchANM(e:Event) : void
      {
      }
   }
}

