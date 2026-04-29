package com.common.Alert.childAlert
{
   import com.core.manager.IndexManager;
   import flash.events.MouseEvent;
   
   public class wrongAlert extends simpleAlert
   {
      
      public function wrongAlert(obj:*, title:String = "提示", content:String = "...", style:uint = 0, bottomArray:String = "確定", closeB:Boolean = true)
      {
         super(obj,title,content,style,bottomArray,closeB);
         this.showAlert();
         this.setButtonEffect();
      }
      
      override public function showAlert() : void
      {
         var myAlert:* = undefined;
         myAlert = IndexManager.getInstance().getMovieClip("Alert_simpleAlert");
         myAlert.ico_mc.gotoAndStop(1);
         myAlert.title_txt.text = TITLE;
         myAlert.content_txt.text = CONTENT;
         dispatchObj.addChild(myAlert);
         this.setButtonHeight(myAlert,165);
         dragAndDepthManage(myAlert);
         setAlertXY(myAlert);
      }
      
      override public function setButtonHeight(obj:*, __y:Number) : void
      {
         var BT:* = undefined;
         var __x:Number = NaN;
         var offset:uint = 32;
         BT = IndexManager.getInstance().getMovieClip("Alert_button");
         BT.gotoAndStop("no");
         BT.x = obj.width / 2 - 40;
         BT.y = __y;
         BT.num = 0;
         BT.name = "button1";
         BT.buttonMode = true;
         BC.addEvent(this,BT,MouseEvent.CLICK,dispatchFun,false,0,true);
         obj.addChild(BT);
         TARGET = BT.parent;
      }
      
      public function setButtonEffect() : void
      {
         var bt:* = undefined;
         var i:uint = 0;
         try
         {
            bt = OWNER.TARGET.close_btn;
         }
         catch(E:*)
         {
         }
         while(Boolean(bt))
         {
            BC.addEvent(this,bt,MouseEvent.MOUSE_OVER,this.MOUSE_OVER_FUN);
            BC.addEvent(this,bt,MouseEvent.MOUSE_OUT,this.MOUSE_OUT_FUN);
            BC.addEvent(this,bt,MouseEvent.MOUSE_DOWN,this.MOUSE_DOWN_FUN);
            BC.addEvent(this,bt,MouseEvent.MOUSE_UP,this.MOUSE_UP_FUN);
            i++;
            bt = OWNER.TARGET.getChildByName("button" + i);
         }
      }
      
      public function MOUSE_OVER_FUN(e:MouseEvent) : void
      {
         e.currentTarget.alpha = 0.8;
      }
      
      public function MOUSE_OUT_FUN(e:MouseEvent) : void
      {
         e.currentTarget.alpha = 1;
      }
      
      public function MOUSE_DOWN_FUN(e:MouseEvent) : void
      {
      }
      
      public function MOUSE_UP_FUN(e:MouseEvent) : void
      {
      }
   }
}

