package com.common.Alert.childAlert
{
   import com.common.Alert.Alert;
   import com.common.util.DisplayUtil;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.manager.IndexManager;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class simpleAlert extends EventDispatcher
   {
      
      public var TITLE:String;
      
      public var CONTENT:String;
      
      public var STYLE:uint;
      
      public var OWNER:*;
      
      public var TARGET:*;
      
      public var SIZE:Array;
      
      public var ICO_URL:String;
      
      public var Value:Array;
      
      public var dispatchObj:*;
      
      public var ButtonArray:Array;
      
      public var ButtonURLArray:Array;
      
      public var closeBool:Boolean;
      
      public function simpleAlert(obj:*, title:String = "提示", content:String = "...", style:uint = 0, bottomArray:String = "確定", closeB:Boolean = true, size:String = "298,228")
      {
         var i:int = 0;
         this.ButtonArray = [];
         this.ButtonURLArray = [];
         super();
         this.dispatchObj = obj;
         this.Value = new Array(this.dispatchObj,title,content,style,bottomArray,closeB);
         this.TITLE = title;
         this.CONTENT = content;
         this.STYLE = style;
         this.SIZE = size.split(",");
         if(this.SIZE.length > 2)
         {
            this.ICO_URL = this.SIZE[2];
         }
         this.ButtonArray = bottomArray.split(",");
         if(this.ButtonArray[0] == "load")
         {
            this.ButtonArray.shift();
            this.ButtonURLArray = this.ButtonArray.slice(0);
            for(i = 0; i < this.ButtonArray.length; i++)
            {
               this.ButtonArray[i] = "load";
            }
         }
         this.closeBool = closeB;
         this.OWNER = this;
      }
      
      public function getTitle() : String
      {
         return this.TITLE;
      }
      
      public function getTitleTextField() : TextField
      {
         return this.TARGET.title_txt as TextField;
      }
      
      public function getTargetMC() : MovieClip
      {
         return this.TARGET as MovieClip;
      }
      
      public function getBg() : MovieClip
      {
         return this.TARGET.drag_mc as MovieClip;
      }
      
      public function get width() : Number
      {
         return this.getBg().width;
      }
      
      public function get height() : Number
      {
         return this.getBg().height;
      }
      
      public function getContent() : String
      {
         return this.CONTENT;
      }
      
      public function getContentTextField() : TextField
      {
         return this.TARGET.content_txt as TextField;
      }
      
      public function getStyle() : uint
      {
         return this.STYLE;
      }
      
      public function close(event:*) : void
      {
         DisplayUtil.removeForParent(this.TARGET);
      }
      
      protected function clearInstance(event:*) : void
      {
         GC.stopAllMC(this.TARGET);
         Alert.closeAlert(this.TARGET,"1");
         dispatchEvent(new Event("CLOSED"));
         BC.removeEvent(this);
      }
      
      public function showAlert() : void
      {
         var myAlert:* = undefined;
         var resID:uint = 0;
         myAlert = IndexManager.getInstance().getMovieClip("Alert_simpleAlert");
         myAlert.drag_mc.width = this.SIZE[0];
         myAlert.drag_mc.height = this.SIZE[1];
         myAlert.title_txt.width = this.SIZE[0] - 48;
         myAlert.content_txt.width = this.SIZE[0] - 48;
         myAlert.title_txt.x = 24;
         myAlert.content_txt.x = 24;
         myAlert.title_txt.text = this.TITLE;
         myAlert.content_txt.text = this.CONTENT;
         myAlert.x = (GV.stageWidth - myAlert.drag_mc.width) / 2;
         myAlert.y = (GV.stageHeight - myAlert.drag_mc.height) / 2;
         myAlert.ico_mc.gotoAndStop(1);
         if(Boolean(this.ICO_URL))
         {
            resID = DownLoadManager.add(this.ICO_URL,ResType.DISPLAY_OBJECT);
            DownLoadManager.addEvent(resID,this.onLoaderIcon);
         }
         myAlert.close_btn.buttonMode = true;
         this.setButtonHeight(myAlert,myAlert.drag_mc.height - 52);
         this.dragAndDepthManage(myAlert);
         this.dispatchObj.addChild(myAlert);
         this.TARGET = myAlert;
      }
      
      private function onLoaderIcon(e:DownLoadEvent) : void
      {
         this.TARGET.ico_mc.addChild(e.data as DisplayObject);
      }
      
      protected function dragAndDepthManage(myAlert:*) : void
      {
         BC.addEvent(this,myAlert.close_btn,MouseEvent.CLICK,this.close);
         BC.addEvent(this,myAlert.drag_mc,MouseEvent.MOUSE_DOWN,this.dragAlert);
         BC.addEvent(this,myAlert.drag_mc,MouseEvent.MOUSE_UP,this.stopdragAlert);
         BC.addEvent(this,myAlert.drag_mc,MouseEvent.MOUSE_MOVE,this.movedragAlert);
         BC.addEvent(this,myAlert,MouseEvent.MOUSE_DOWN,this.sendDepthToTop);
         BC.addEvent(this,myAlert,Event.REMOVED_FROM_STAGE,this.clearInstance);
         Alert.hasAlert = true;
         Alert.AlertArray.push(myAlert);
      }
      
      public function setButtonHeight(obj:*, __y:Number) : void
      {
         var BT:* = undefined;
         var __x:Number = NaN;
         var tl:Loader = null;
         for(var i:uint = 0; i < this.ButtonArray.length; i++)
         {
            BT = IndexManager.getInstance().getMovieClip("Alert_button");
            __x = (obj.drag_mc.width - (BT.width + 6) * this.ButtonArray.length) / 2;
            BT.x = i * BT.width + __x + i * 6;
            BT.y = __y;
            BT.num = i;
            BT.name = "button" + (i + 1);
            BT.gotoAndStop(this.ButtonArray[i]);
            if(this.ButtonArray[i] == "load")
            {
               tl = new Loader();
               tl.load(VL.getURLRequest(this.ButtonURLArray[i]));
               BT.addChild(tl);
            }
            else if(this.ButtonArray[i] == "common")
            {
               BT.btn_mc.str_txt.text = this.ButtonArray[i];
               BT.mouseChildren = false;
            }
            obj.addChild(BT);
            BT.buttonMode = true;
            BC.addEvent(this,BT,MouseEvent.CLICK,this.dispatchFun);
         }
         this.TARGET = BT.parent;
      }
      
      protected function dispatchFun(event:MouseEvent) : void
      {
         try
         {
            if(this.closeBool)
            {
               this.close(this.TARGET);
            }
         }
         catch(Err:Error)
         {
         }
         dispatchEvent(new Event("CLICK" + (event.currentTarget.num + 1)));
      }
      
      protected function dragAlert(event:MouseEvent) : void
      {
         event.currentTarget.parent.startDrag();
      }
      
      protected function movedragAlert(event:MouseEvent) : void
      {
         event.updateAfterEvent();
      }
      
      protected function stopdragAlert(event:MouseEvent) : void
      {
         event.currentTarget.parent.parent.stopDrag();
      }
      
      public function sendDepthToTop(event:MouseEvent) : void
      {
         var topPosition:uint = event.currentTarget.parent.numChildren - 1;
         event.currentTarget.parent.setChildIndex(event.currentTarget,topPosition);
      }
      
      protected function setAlertXY(myAlert:*) : void
      {
         var bool:Boolean = false;
         var oldAlert:* = undefined;
         var oldAlertClass:* = undefined;
         var i:uint = 0;
         myAlert.OWNER = this.OWNER;
         if(Alert.AlertArray.length > 1)
         {
            bool = true;
            if(Alert.AlertArray.length >= 2)
            {
               oldAlert = Alert.AlertArray[Alert.AlertArray.length - 2];
               oldAlertClass = oldAlert.OWNER;
               if(oldAlertClass.Value.length == this.Value.length)
               {
                  for(i = 0; i < this.Value.length; i++)
                  {
                     if(oldAlertClass.Value[i] != this.Value[i])
                     {
                        bool = false;
                        break;
                     }
                  }
               }
            }
            if(!bool)
            {
               if(GV.stageWidth - oldAlert.x < myAlert.width)
               {
                  myAlert.x = 0;
               }
               else
               {
                  myAlert.x = oldAlert.x + 20;
               }
               if(GV.stageHeight - oldAlert.y < myAlert.height)
               {
                  myAlert.y = Math.random() * 50;
               }
               else
               {
                  myAlert.y = oldAlert.y + 20;
               }
            }
            else
            {
               Alert.closeAlert(myAlert);
            }
         }
         else
         {
            myAlert.x = (GV.stageWidth - myAlert.width) / 2;
            myAlert.y = (GV.stageHeight - myAlert.height) / 2;
         }
      }
   }
}

