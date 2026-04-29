package com.common.Alert.childAlert
{
   import com.core.manager.IndexManager;
   import com.core.newloader.BaseMCLoader;
   import com.event.MCLoadEvent;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.utils.getQualifiedClassName;
   
   public class gameAlert extends simpleAlert
   {
      
      public var myButtonArray:Array;
      
      public function gameAlert(obj:*, title:String = "提示", content:String = "...", style:uint = 0, bottomArray:String = "確定", closeB:Boolean = true, size:String = "298,228")
      {
         super(obj,title,content,style,bottomArray,closeB);
         this.showAlert();
         this.myButtonArray = bottomArray.split(",");
         this.setButtonEffect();
      }
      
      public function load() : void
      {
         this.showAlert();
      }
      
      override public function showAlert() : void
      {
         var myAlert:* = undefined;
         myAlert = IndexManager.getInstance().getMovieClip("Alert_simpleAlert");
         myAlert.ico_mc.gotoAndStop(1);
         dispatchObj.addChild(myAlert);
         setButtonHeight(myAlert,165);
         dragAndDepthManage(myAlert);
         setAlertXY(myAlert);
         var loader:BaseMCLoader = new BaseMCLoader(CONTENT,myAlert);
         loader.addEventListener(MCLoadEvent.ON_SUCCESS,this.icoComplete);
         loader.doLoad();
      }
      
      private function icoComplete(e:MCLoadEvent) : void
      {
         var loader:BaseMCLoader = e.currentTarget as BaseMCLoader;
         loader.removeEventListener(MCLoadEvent.ON_SUCCESS,this.icoComplete);
         var mc:Sprite = Sprite(e.getParent());
         var content:Sprite = loader.loader.content as Sprite;
         content.x = 20;
         content.y = 20;
         mc.addChild(content);
         for(var i:int = mc.numChildren - 1; i >= 0; i--)
         {
            if(getQualifiedClassName(mc.getChildAt(i)) == "Alert_button")
            {
               mc.setChildIndex(mc.getChildAt(i),mc.numChildren - 1);
            }
         }
         loader.clear();
      }
      
      public function setButtonHeightSimple(obj:*, __y:Number) : void
      {
         var BT:* = undefined;
         var __x:Number = NaN;
         var type:int = int(this.myButtonArray.length);
         var offset:uint = 57;
         if(type == 2)
         {
            BT = IndexManager.getInstance().getMovieClip("Alert_button");
            BT.gotoAndStop(this.myButtonArray[0]);
            BT.x = offset;
            BT.y = __y;
            BT.num = 0;
            BT.name = "button1";
            BT.buttonMode = true;
            BC.addEvent(this,BT,MouseEvent.CLICK,dispatchFun,false,0,true);
            obj.addChild(BT);
            BT = IndexManager.getInstance().getMovieClip("Alert_button");
            BT.gotoAndStop(this.myButtonArray[1]);
            BT.x = obj.drag_mc.width - 80 - offset;
            BT.y = __y;
            BT.num = 1;
            BT.name = "button2";
            BT.buttonMode = true;
            BC.addEvent(this,BT,MouseEvent.CLICK,dispatchFun,false,0,true);
            obj.addChild(BT);
         }
         else if(type == 1)
         {
            BT = IndexManager.getInstance().getMovieClip("Alert_button");
            BT.gotoAndStop(this.myButtonArray[0]);
            offset = (obj.drag_mc.width - BT.mc.width) / 2;
            BT.x = offset;
            BT.y = __y;
            BT.num = 0;
            BT.name = "button1";
            BT.buttonMode = true;
            BC.addEvent(this,BT,MouseEvent.CLICK,dispatchFun,false,0,true);
            obj.addChild(BT);
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

