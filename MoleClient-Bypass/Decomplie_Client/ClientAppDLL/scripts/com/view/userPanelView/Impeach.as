package com.view.userPanelView
{
   import com.common.Alert.childAlert.SmcAlert;
   import com.core.MainManager;
   import com.core.manager.UIManager;
   import com.logic.socket.addBlackList.*;
   import com.logic.socket.impeach.*;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class Impeach
   {
      
      private var impeach_Alter:*;
      
      private var impeachContent:String;
      
      private var useID:int;
      
      private var say_mc:*;
      
      private var impeach_mc:MovieClip;
      
      private var impeachReq:ImpeachReq;
      
      private var nikeName:String;
      
      public function Impeach(userId:int, nike:String)
      {
         super();
         this.useID = userId;
         this.nikeName = nike;
         this.impeachReq = new ImpeachReq();
         this.initImpeach();
      }
      
      private function initImpeach() : void
      {
         this.impeachContent = "　　當你發現其他小摩爾違反了《摩爾莊園公民法令》時可以使用此系統，摩爾莊園公民管理處將根據系統記錄進行核實並給予相應處理,你確定繼續舉報嗎？";
         this.impeach_Alter = new SmcAlert(MainManager.getAppLevel(),"",this.impeachContent,0,"impeach，nextCome",false);
         this.impeach_Alter.addEventListener("CLICK" + 1,this.impeachHandler);
      }
      
      private function impeachHandler(event:*) : void
      {
         var impeachTitle:String = null;
         this.impeach_Alter.removeEventListener("CLICK" + 1,this.impeachHandler);
         if(!MainManager.getAppLevel().getChildByName("say_mc"))
         {
            impeachTitle = this.nikeName + "違反了《摩爾莊園公民法令》中：";
            this.impeach_mc = UIManager.getMovieClip("SAY_MC");
            this.impeach_mc.name = "say_mc";
            MainManager.getAppLevel().addChild(this.impeach_mc);
            this.impeach_mc.x = (MainManager.getStageWidth() - this.impeach_mc.width) / 2;
            this.impeach_mc.y = (MainManager.getStageHeight() - this.impeach_mc.height) / 2;
            this.impeach_mc.title_txt.text = impeachTitle;
            this.impeach_mc.policy1.addEventListener(MouseEvent.CLICK,this.policy1ClickHandler);
            this.impeach_mc.policy2.addEventListener(MouseEvent.CLICK,this.policy2ClickHandler);
            this.impeach_mc.policy3.addEventListener(MouseEvent.CLICK,this.policy3ClickHandler);
            this.impeach_mc.policy4.addEventListener(MouseEvent.CLICK,this.policy4ClickHandler);
            this.impeach_mc.close_btn.addEventListener(MouseEvent.CLICK,this.closeBtnHandler);
         }
      }
      
      private function policy1ClickHandler(event:MouseEvent) : void
      {
         this.impeachCommpent();
         this.removeEvent();
         MainManager.getAppLevel().removeChild(this.impeach_mc);
         this.impeachReq.impeach(this.useID,1);
         this.impeachReq = null;
      }
      
      private function policy2ClickHandler(event:MouseEvent) : void
      {
         this.impeachCommpent();
         this.removeEvent();
         MainManager.getAppLevel().removeChild(this.impeach_mc);
         this.impeachReq.impeach(this.useID,2);
         this.impeachReq = null;
      }
      
      private function policy3ClickHandler(event:MouseEvent) : void
      {
         this.impeachCommpent();
         this.removeEvent();
         MainManager.getAppLevel().removeChild(this.impeach_mc);
         this.impeachReq.impeach(this.useID,3);
         this.impeachReq = null;
      }
      
      private function policy4ClickHandler(event:MouseEvent) : void
      {
         this.impeachCommpent();
         this.removeEvent();
         MainManager.getAppLevel().removeChild(this.impeach_mc);
         this.impeachReq.impeach(this.useID,4);
         this.impeachReq = null;
      }
      
      private function closeBtnHandler(event:MouseEvent) : void
      {
         this.removeEvent();
         MainManager.getAppLevel().removeChild(this.impeach_mc);
         this.impeachReq = null;
      }
      
      private function impeachCommpent() : void
      {
         this.impeachContent = "　　你的舉報信息已經發送給摩爾莊園公民管理處，經過核實後會作相應處理。";
         this.impeach_Alter = new SmcAlert(MainManager.getAppLevel(),"",this.impeachContent,0,"know",false);
         this.impeach_Alter = null;
      }
      
      private function removeEvent() : void
      {
         this.impeach_mc.policy1.removeEventListener(MouseEvent.CLICK,this.policy1ClickHandler);
         this.impeach_mc.policy2.removeEventListener(MouseEvent.CLICK,this.policy2ClickHandler);
         this.impeach_mc.policy3.removeEventListener(MouseEvent.CLICK,this.policy3ClickHandler);
         this.impeach_mc.policy4.removeEventListener(MouseEvent.CLICK,this.policy4ClickHandler);
         this.impeach_mc.close_btn.removeEventListener(MouseEvent.CLICK,this.closeBtnHandler);
      }
   }
}

