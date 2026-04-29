package com.common.Alert.childAlert
{
   import com.core.manager.IndexManager;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.text.TextFieldAutoSize;
   
   public class commonAlert extends simpleAlert
   {
      
      public function commonAlert(obj:*, title:String = "提示", content:String = "...", style:uint = 0, bottomArray:String = "確定", closeB:Boolean = true)
      {
         super(obj,title,content,style,bottomArray,closeB);
         this.showAlert();
         this.setButtonEffect();
      }
      
      override public function showAlert() : void
      {
         var myAlert:* = undefined;
         myAlert = IndexManager.getInstance().getMovieClip("Alert_simpleAlert");
         myAlert.title_txt.text = TITLE;
         myAlert.content_txt.text = CONTENT;
         myAlert.ico_mc.gotoAndStop(1);
         dispatchObj.addChild(myAlert);
         this.setButtonHeight(myAlert,165);
         dragAndDepthManage(myAlert);
         setAlertXY(myAlert);
      }
      
      override public function setButtonHeight(obj:*, __y:Number) : void
      {
         var BT:* = undefined;
         var __x:Number = NaN;
         for(var i:uint = 0; i < ButtonArray.length; i++)
         {
            BT = IndexManager.getInstance().getMovieClip("Alert_button");
            BT.gotoAndStop("common");
            BT.width = ButtonArray[i].length * 14 + 40;
            __x = (obj.width - (BT.width + 6) * ButtonArray.length) / 2;
            BT.x = i * BT.width + __x + i * 6;
            BT.y = __y;
            BT.num = i;
            BT.name = "button" + (i + 1);
            BT.btn_mc.str_txt.autoSize = TextFieldAutoSize.LEFT;
            BT.btn_mc.str_txt.wordWrap = true;
            BT.btn_mc.str_txt.text = ButtonArray[i];
            obj.addChild(BT);
            BT.buttonMode = true;
            BC.addEvent(this,BT,MouseEvent.CLICK,dispatchFun,false,0,true);
         }
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
            BC.addEvent(this,bt,MouseEvent.MOUSE_OVER,this.MOUSE_OVER_FUN,false,0,true);
            BC.addEvent(this,bt,MouseEvent.MOUSE_OUT,this.MOUSE_OUT_FUN,false,0,true);
            BC.addEvent(this,bt,MouseEvent.MOUSE_DOWN,this.MOUSE_DOWN_FUN,false,0,true);
            BC.addEvent(this,bt,MouseEvent.MOUSE_UP,this.MOUSE_UP_FUN,false,0,true);
            i++;
            bt = OWNER.TARGET.getChildByName("button" + i);
         }
      }
      
      public function MOUSE_OVER_FUN(e:MouseEvent) : void
      {
         e.currentTarget.alpha = 0.8;
         e.currentTarget.filters = [new GlowFilter(16701765,1,8,8)];
      }
      
      public function MOUSE_OUT_FUN(e:MouseEvent) : void
      {
         e.currentTarget.alpha = 1;
         e.currentTarget.filters = [];
      }
      
      public function MOUSE_DOWN_FUN(e:MouseEvent) : void
      {
         e.currentTarget.filters = [new GlowFilter(15897348,1,8,8)];
      }
      
      public function MOUSE_UP_FUN(e:MouseEvent) : void
      {
         e.currentTarget.filters = [];
      }
   }
}

