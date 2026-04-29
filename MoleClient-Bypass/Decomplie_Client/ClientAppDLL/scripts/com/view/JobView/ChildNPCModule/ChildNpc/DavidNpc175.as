package com.view.JobView.ChildNPCModule.ChildNpc
{
   import com.common.Alert.Alert;
   import com.common.tip.NpcDialogBox;
   import com.core.MainManager;
   import com.logic.socket.giveMeMoney.giveMeMoneyReq;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Timer;
   
   public class DavidNpc175 extends Sprite
   {
      
      private var tip_timer:Timer;
      
      private var giveMeMoneyReqs:giveMeMoneyReq;
      
      private var npc_obj:Object;
      
      public var targetMC:MovieClip;
      
      public var boxMC:NpcDialogBox;
      
      private var num_time:Timer;
      
      public function DavidNpc175()
      {
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEvent);
         super();
      }
      
      public function clickFun(event:MouseEvent = null) : void
      {
         this.closeTipFun();
         var url:String = this.npc_obj.url;
         var msg:String = this.npc_obj.msg;
         var myAlert:* = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
      }
      
      public function setTargetMC(MC:MovieClip) : void
      {
         this.targetMC = MC;
         this.tip_timer = GC.setGTimeout(this.showTipUI,5000);
         this.npc_obj = {
            "url":"resource/allJob/AlertPic/davidNPC/82_1.swf",
            "msg":"    我在忙著設計汽車圖紙。"
         };
         BC.addEvent(this,this.targetMC.btn,MouseEvent.CLICK,this.clickFun);
      }
      
      private function showTipUI() : void
      {
         GC.clearGTimeout(this.tip_timer);
         this.tip_timer = null;
         this.setTipMC("橡膠的輪胎應該更結實……");
      }
      
      public function setTipMC(msg:String) : void
      {
         this.boxMC = new NpcDialogBox(this.targetMC,0,0,1);
         this.boxMC.show(msg);
         this.num_time = GC.setGTimeout(this.closeTipFun,10000);
      }
      
      public function closeTipFun() : void
      {
         if(this.boxMC != null)
         {
            GC.clearGTimeout(this.num_time);
            this.boxMC.destroy();
         }
         if(Boolean(this.tip_timer))
         {
            GC.clearGTimeout(this.tip_timer);
            this.tip_timer = null;
         }
         this.boxMC = null;
      }
      
      public function removeEvent(eve:*) : void
      {
         this.closeTipFun();
         BC.removeEvent(this);
      }
   }
}

