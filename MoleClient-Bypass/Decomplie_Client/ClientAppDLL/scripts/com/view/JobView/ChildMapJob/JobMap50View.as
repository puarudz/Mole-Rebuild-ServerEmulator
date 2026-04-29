package com.view.JobView.ChildMapJob
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.logic.socket.shopItem.BuyItemReq;
   import com.logic.socket.shopItem.BuyItemRes;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class JobMap50View extends MovieClip
   {
      
      private var target_mc:MovieClip;
      
      private var buykey:BuyItemReq;
      
      public function JobMap50View()
      {
         super();
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEvent);
      }
      
      public function beginInfo(MC:MovieClip) : void
      {
         this.target_mc = MC;
         this.buykey = new BuyItemReq();
         this.setMC();
      }
      
      private function setMC() : void
      {
         this.target_mc.key_btn.visible = false;
         this.target_mc.Job_mc.visible = false;
         this.target_mc.Job_btn.visible = false;
         this.target_mc.showKey_mc.visible = false;
         if(LocalUserInfo.isVIP())
         {
            BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.backBage);
            GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),12401,2);
         }
      }
      
      private function backBage(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.backBage);
         var obj:Object = event.EventObj.obj;
         if(obj.Count == 0)
         {
            BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.backBage2);
            GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),190185,2);
         }
      }
      
      private function backBage2(event:EventTaomee) : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("TEST_JACK_GAME"));
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.backBage2);
         var obj:Object = event.EventObj.obj;
         if(obj.Count == 0)
         {
            this.target_mc.Job_mc.visible = true;
            this.target_mc.Job_btn.visible = true;
            BC.addEvent(this,this.target_mc.Job_btn,MouseEvent.CLICK,this.beginMovie);
         }
      }
      
      private function beginMovie(event:MouseEvent) : void
      {
         BC.removeEvent(this,this.target_mc.Job_btn,MouseEvent.CLICK,this.beginMovie);
         this.target_mc.Job_mc.gotoAndPlay(2);
         GC.setGTimeout(this.showKeyMC,3000);
      }
      
      private function showKeyMC() : void
      {
         this.target_mc.showKey_mc.visible = true;
         BC.addEvent(this,this.target_mc.showKey_mc,MouseEvent.CLICK,this.showKey);
         this.target_mc.Job_mc.gotoAndStop(1);
         this.target_mc.Job_btn.visible = false;
      }
      
      private function showKey(e:MouseEvent) : void
      {
         BC.removeEvent(this,this.target_mc.showKey_mc,MouseEvent.CLICK,this.showKey);
         this.target_mc.showKey_mc.gotoAndPlay(2);
         GC.setGTimeout(this.showKeyUI,1000);
      }
      
      private function showKeyUI() : void
      {
         this.target_mc.key_btn.visible = true;
         BC.addEvent(this,this.target_mc.key_btn,MouseEvent.CLICK,this.getKeyFun);
         this.target_mc.showKey_mc.visible = false;
      }
      
      private function getKeyFun(event:MouseEvent) : void
      {
         BC.removeEvent(this,this.target_mc.key_btn,MouseEvent.CLICK,this.getKeyFun);
         this.target_mc.key_btn.visible = false;
         GV.itemID = 3;
         BC.addEvent(this,GV.onlineSocket,BuyItemRes.BUY_ITEM_SUCCESS,this.getKeyAlt);
         this.buykey.buyItems(190185,1);
      }
      
      private function getKeyAlt(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,BuyItemRes.BUY_ITEM_SUCCESS,this.getKeyAlt);
         var url:String = "resource/allJob/icon/190185.swf";
         var msg:String = "    鑰匙已經放入你的百寶箱中了!";
         var myAlert:* = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
         this.removeEvent();
      }
      
      public function removeEvent(event:EventTaomee = null) : void
      {
         BC.removeEvent(this);
         this.buykey = null;
         this.target_mc = null;
      }
   }
}

