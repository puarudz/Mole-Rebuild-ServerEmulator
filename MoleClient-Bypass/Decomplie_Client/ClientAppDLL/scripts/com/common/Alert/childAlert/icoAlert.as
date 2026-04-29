package com.common.Alert.childAlert
{
   import com.core.manager.IndexManager;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.text.*;
   
   public class icoAlert extends simpleAlert
   {
      
      public var tempLoader:Loader;
      
      public var tempMC:MovieClip;
      
      public var myButtonArray:String;
      
      public function icoAlert(obj:*, title:String = "提示", content:String = "...", style:uint = 0, bottomArray:String = "A", closeB:Boolean = true)
      {
         super(obj,title,content,style,bottomArray,closeB);
         this.tempLoader = new Loader();
         this.myButtonArray = bottomArray;
         this.showAlert();
         if(this.myButtonArray != "EMP")
         {
            this.setButtonEffect();
         }
      }
      
      override public function showAlert() : void
      {
         var myAlert:* = undefined;
         var mc:* = undefined;
         myAlert = IndexManager.getInstance().getMovieClip("Alert_simpleAlert");
         if(this.myButtonArray == "EMP")
         {
            myAlert.ico_mc.gotoAndStop("EMP");
            myAlert.title_txt.autoSize = TextFieldAutoSize.CENTER;
            myAlert.title_txt.wordWrap = true;
            myAlert.drag_mc.width = 424;
            myAlert.drag_mc.height = 336;
            mc = IndexManager.getInstance().getMovieClip("Job_AddCloseBtn");
            mc.x = myAlert.drag_mc.width - mc.width - 10;
            mc.y = 8;
            mc.buttonMode = true;
            BC.addEvent(this,mc,MouseEvent.CLICK,close,false,0,true);
            myAlert.addChild(mc);
            this.tempMC = new MovieClip();
            this.tempLoader.load(VL.getURLRequest(TITLE));
            myAlert.Add_mc.addChild(this.tempMC);
            this.tempMC.addChild(this.tempLoader);
            this.tempMC.scaleX = 1.8;
            this.tempMC.scaleY = 1.8;
            this.tempMC.x = 160;
            this.tempMC.y = 32;
            myAlert.content_txt.text = CONTENT;
            myAlert.content_txt.y = 137;
            myAlert.content_txt.width = 347;
            dispatchObj.addChild(myAlert);
            this.setButtonHeight(myAlert,230);
            dragAndDepthManage(myAlert);
            setAlertXY(myAlert);
         }
         else
         {
            myAlert.title_txt.autoSize = TextFieldAutoSize.CENTER;
            myAlert.title_txt.wordWrap = true;
            myAlert.title_txt.text = TITLE;
            myAlert.content_txt.text = CONTENT;
            myAlert.content_txt.y = 67;
            myAlert.content_txt.width = 250;
            myAlert.ico_mc.gotoAndStop(1);
            dispatchObj.addChild(myAlert);
            this.setButtonHeight(myAlert,165);
            dragAndDepthManage(myAlert);
            setAlertXY(myAlert);
         }
      }
      
      override public function setButtonHeight(obj:*, __y:Number) : void
      {
         var BT:* = undefined;
         var __x:Number = NaN;
         if(this.myButtonArray != "EMP")
         {
            obj.ico_mc.gotoAndStop(ButtonArray);
         }
         var offset:uint = 57;
         if(this.myButtonArray == "EMP")
         {
            offset = 80;
            BT = IndexManager.getInstance().getMovieClip("SMC_BUTTON");
            BT.gotoAndStop("getReady");
         }
         else
         {
            offset = 57;
            BT = IndexManager.getInstance().getMovieClip("Alert_button");
            BT.gotoAndStop("sure");
         }
         BT.x = offset;
         BT.y = __y;
         BT.num = 0;
         BT.name = "button1";
         BT.buttonMode = true;
         BC.addEvent(this,BT,MouseEvent.CLICK,dispatchFun,false,0,true);
         obj.addChild(BT);
         if(this.myButtonArray == "EMP")
         {
            offset = 70;
            BT = IndexManager.getInstance().getMovieClip("SMC_BUTTON");
            BT.gotoAndStop("nextCome");
         }
         else
         {
            offset = 57;
            BT = IndexManager.getInstance().getMovieClip("Alert_button");
            BT.gotoAndStop("cancel");
         }
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

