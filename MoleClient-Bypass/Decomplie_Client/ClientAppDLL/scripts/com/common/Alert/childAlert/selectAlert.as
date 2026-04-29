package com.common.Alert.childAlert
{
   import com.common.util.MovieClipUtil;
   import com.core.manager.IndexManager;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   
   public class selectAlert extends simpleAlert
   {
      
      public function selectAlert(obj:*, title:String = "提示", content:String = "...", style:uint = 0, bottomArray:String = "A", closeB:Boolean = true)
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
         MovieClipUtil.gotoAndStop(obj.ico_mc,ButtonArray[0]);
         var offset:uint = 60;
         BT = IndexManager.getInstance().getMovieClip("Alert_button");
         BT.gotoAndStop("sure");
         BT.x = offset;
         BT.y = __y;
         BT.num = 0;
         BT.name = "button1";
         BT.buttonMode = true;
         BC.addEvent(this,BT,MouseEvent.CLICK,dispatchFun,false,0,true);
         obj.addChild(BT);
         BT = IndexManager.getInstance().getMovieClip("Alert_button");
         BT.gotoAndStop("cancel");
         BT.x = obj.drag_mc.width - 80 - offset;
         BT.y = __y;
         BT.num = 1;
         BT.name = "button2";
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

