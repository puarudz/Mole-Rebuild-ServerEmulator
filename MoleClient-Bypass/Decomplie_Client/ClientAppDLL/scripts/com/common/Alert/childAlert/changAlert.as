package com.common.Alert.childAlert
{
   import com.common.Alert.Alert;
   import com.core.manager.IndexManager;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.text.*;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class changAlert extends simpleAlert
   {
      
      public var tempLoader:Loader;
      
      public var tempMC:MovieClip;
      
      public var myTextBox:TextField;
      
      public var mymsgTextBox:TextField;
      
      public var NPCMsg_arr:Array;
      
      public var myButtonArray:Array;
      
      public var PIC_TYPE:String;
      
      public var WIDTH_HEIGHT:Array;
      
      public var SHOW_BTN:Boolean;
      
      private var IntervalID:uint;
      
      public function changAlert(obj:*, title:String = "提示", content:String = "...", style:uint = 0, bottomArray:String = "A", closeB:Boolean = true, showBtn:Boolean = false, picTip:String = "A", WH:String = "298,228")
      {
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEvent);
         super(obj,title,content,style,bottomArray,closeB);
         this.WIDTH_HEIGHT = WH.split(",");
         this.SHOW_BTN = showBtn;
         this.PIC_TYPE = picTip;
         if(this.PIC_TYPE == "EMP")
         {
            this.tempLoader = new Loader();
         }
         else if(this.PIC_TYPE == "EMP_BUY")
         {
            this.tempLoader = new Loader();
         }
         else if(this.PIC_TYPE == "EMP_UI")
         {
            this.tempLoader = new Loader();
         }
         else if(this.PIC_TYPE == "SMCUI")
         {
            if(WH == "298,228")
            {
               this.WIDTH_HEIGHT = [424,336];
            }
            this.tempLoader = new Loader();
         }
         else if(this.PIC_TYPE == "SMC")
         {
            if(WH == "298,228")
            {
               this.WIDTH_HEIGHT = [424,336];
            }
            this.tempLoader = new Loader();
         }
         else if(this.PIC_TYPE == "sandUI")
         {
            if(WH == "298,228")
            {
               this.WIDTH_HEIGHT = [400,300];
            }
            this.myTextBox = new TextField();
            this.mymsgTextBox = new TextField();
         }
         else if(this.PIC_TYPE == "npcUI")
         {
            if(WH == "298,228")
            {
               this.WIDTH_HEIGHT = [424,336];
            }
            this.tempLoader = new Loader();
            this.NPCMsg_arr = new Array();
         }
         this.myButtonArray = bottomArray.split(",");
         this.showAlert();
      }
      
      override public function showAlert() : void
      {
         var myAlert:* = undefined;
         var myTexts:TextField = null;
         myAlert = IndexManager.getInstance().getMovieClip("Alert_simpleAlert");
         if(this.PIC_TYPE == "")
         {
            myAlert.ico_mc.gotoAndStop(1);
         }
         else
         {
            myAlert.ico_mc.gotoAndStop(this.PIC_TYPE);
         }
         myAlert.drag_mc.width = this.WIDTH_HEIGHT[0];
         myAlert.drag_mc.height = this.WIDTH_HEIGHT[1];
         this.IfshowCloseBtn(myAlert);
         if(this.PIC_TYPE == "EMP")
         {
            myAlert.ico_mc.gotoAndStop("EMP");
            this.IntervalID = setTimeout(this.EMPshowAlert,200,myAlert);
         }
         else if(this.PIC_TYPE == "EMP_BUY")
         {
            myAlert.ico_mc.gotoAndStop("EMP_BUY");
            this.IntervalID = setTimeout(this.EMPBUYshowAlert,200,myAlert);
         }
         else if(this.PIC_TYPE == "EMP_UI")
         {
            myAlert.ico_mc.gotoAndStop("EMP_UI");
            this.IntervalID = setTimeout(this.EMPBUYshowAlert,200,myAlert,2);
         }
         else if(this.PIC_TYPE == "SMCUI")
         {
            myAlert.ico_mc.gotoAndStop("SMCUI");
            this.IntervalID = setTimeout(this.SMCUIshowAlert,200,myAlert);
         }
         else if(this.PIC_TYPE == "SMC")
         {
            this.IntervalID = setTimeout(this.SMCshowAlert,200,myAlert);
         }
         else if(this.PIC_TYPE == "sandUI")
         {
            myAlert.ico_mc.gotoAndStop("sandUI");
            this.IntervalID = setTimeout(this.SANDUIshowAlert,200,myAlert);
         }
         else if(this.PIC_TYPE == "npcUI")
         {
            myAlert.ico_mc.gotoAndStop("npcUI");
            this.IntervalID = setTimeout(this.NPCUIshowAlert,200,myAlert);
         }
         else
         {
            myAlert.title_txt.autoSize = TextFieldAutoSize.CENTER;
            if(TITLE.slice(0,1) == "<")
            {
               myAlert.title_txt.text = "";
               myTexts = new TextField();
               myTexts.autoSize = TextFormatAlign.CENTER;
               myAlert.Add_mc.addChild(myTexts);
               myTexts.selectable = true;
               myTexts.x = 23;
               myTexts.y = 32;
               myTexts.width = 250;
               myTexts.height = 35;
               BC.addEvent(this,myTexts,TextEvent.LINK,this.TextHandler);
               myTexts.htmlText = TITLE;
            }
            else
            {
               myAlert.title_txt.text = TITLE;
            }
            myAlert.title_txt.wordWrap = true;
            myAlert.content_txt.text = CONTENT;
            myAlert.content_txt.y = 67;
            myAlert.content_txt.width = 250;
            dispatchObj.addChild(myAlert);
            this.setButtonHeightSimple(myAlert,165);
            dragAndDepthManage(myAlert);
            setAlertXY(myAlert);
         }
      }
      
      private function TextHandler(e:*) : void
      {
         dispatchEvent(new Event("CLICK_100"));
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
      
      override public function setButtonHeight(obj:*, __y:Number) : void
      {
         var BT:* = undefined;
         var __x:Number = NaN;
         obj.ico_mc.gotoAndStop(this.PIC_TYPE);
         var type:int = int(this.myButtonArray.length);
         var offset:uint = 0;
         if(type == 2)
         {
            BT = IndexManager.getInstance().getMovieClip("Alert_button");
            BT.gotoAndStop(this.myButtonArray[0]);
            offset = (obj.drag_mc.width - BT.mc.width * 2) / 4;
            BT.x = offset;
            BT.y = __y;
            BT.num = 0;
            BT.name = "button1";
            BT.buttonMode = true;
            BC.addEvent(this,BT,MouseEvent.CLICK,dispatchFun,false,0,true);
            obj.addChild(BT);
            BT = IndexManager.getInstance().getMovieClip("Alert_button");
            BT.gotoAndStop(this.myButtonArray[1]);
            BT.x = obj.drag_mc.width - BT.mc.width - offset;
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
      
      public function EMPshowAlert(myAlert:*) : void
      {
         try
         {
            this.tempMC = new MovieClip();
            this.tempLoader.load(VL.getURLRequest(TITLE));
            this.tempMC.scaleX = 1.5;
            this.tempMC.scaleY = 1.5;
            this.tempMC.x = (myAlert.drag_mc.width - 80) / 2;
            this.tempMC.y = 70;
            this.tempMC.addChild(this.tempLoader);
            myAlert.ico_mc.add_mc.addChild(this.tempMC);
            myAlert.content_txt.text = CONTENT;
            myAlert.content_txt.y = 30 - 5;
            myAlert.content_txt.width = 250;
            dispatchObj.addChild(myAlert);
            this.setButtonHeight(myAlert,165);
            dragAndDepthManage(myAlert);
            setAlertXY(myAlert);
         }
         catch(E:*)
         {
            trace(E,this);
         }
      }
      
      public function EMPBUYshowAlert(myAlert:*, type:uint = 1) : void
      {
         var myText:TextField = null;
         var myTexts:TextField = null;
         var strArr:Array = null;
         try
         {
            this.setButtonHeight(myAlert,165);
            this.tempMC = new MovieClip();
            this.tempLoader.load(VL.getURLRequest(TITLE));
            this.tempMC.scaleX = 1.5;
            this.tempMC.scaleY = 1.5;
            this.tempMC.x = (myAlert.drag_mc.width - 80) / 2;
            this.tempMC.y = 30;
            this.tempMC.addChild(this.tempLoader);
            myAlert.ico_mc.add_mc.addChildAt(this.tempMC,0);
            myText = myAlert.ico_mc.emp_txt;
            myText.x = myAlert.content_txt.x;
            myText.y = 120;
            myText.width = 250;
            if(type == 2)
            {
               myText.y = 100;
               myTexts = new TextField();
               myAlert.addChild(myTexts);
               myTexts.selectable = true;
               myTexts.x = myText.x + 20;
               myTexts.y = 140;
               myTexts.width = 250;
               myTexts.height = 30;
               strArr = new Array();
               strArr = CONTENT.split(";");
               myText.text = strArr[0];
               myTexts.text = strArr[1];
            }
            else
            {
               myText.text = CONTENT;
            }
            dispatchObj.addChild(myAlert);
            dragAndDepthManage(myAlert);
            setAlertXY(myAlert);
         }
         catch(E:*)
         {
            trace(E,this);
         }
      }
      
      public function SMCshowAlert(myAlert:*) : void
      {
         myAlert.title_txt.autoSize = TextFieldAutoSize.CENTER;
         myAlert.title_txt.wordWrap = true;
         this.tempMC = new MovieClip();
         this.tempLoader.load(VL.getURLRequest(TITLE));
         myAlert.Add_mc.addChild(this.tempMC);
         this.tempMC.addChild(this.tempLoader);
         myAlert.ico_mc.smc_txt.text = CONTENT;
         myAlert.ico_mc.smc_txt.y = 210;
         myAlert.ico_mc.smc_txt.width = 340;
         dispatchObj.addChild(myAlert);
         this.setButtonHeight(myAlert,268);
         dragAndDepthManage(myAlert);
         setAlertXY(myAlert);
      }
      
      public function SMCUIshowAlert(myAlert:*) : void
      {
         var txt_bln:Boolean = false;
         var myText:TextField = null;
         var Arr:Array = null;
         var lgg:uint = 0;
         var ip:uint = 0;
         try
         {
            this.tempMC = new MovieClip();
            this.tempLoader.load(VL.getURLRequest(TITLE));
            txt_bln = false;
            if(CONTENT.slice(0,1) == "<")
            {
               txt_bln = true;
            }
            myText = myAlert.ico_mc.smc_txt;
            Arr = String(CONTENT).split("rr");
            lgg = Arr.length;
            if(lgg > 1)
            {
               myText.text = "";
               for(ip = 0; ip < lgg; ip++)
               {
                  if(txt_bln)
                  {
                     myText.htmlText = myText.text + "\r" + Arr[ip];
                  }
                  else
                  {
                     myText.text = myText.text + "\r" + Arr[ip];
                  }
               }
            }
            else if(txt_bln)
            {
               myText.htmlText = CONTENT;
            }
            else
            {
               myText.text = CONTENT;
            }
            myText.x = 200;
            myText.y = (320 - myText.numLines * myText.height) / 2;
            myText.width = 180;
            myText.type = TextFieldType.INPUT;
            myText.autoSize = TextFieldAutoSize.LEFT;
            myText.selectable = false;
            myText.multiline = true;
            myText.wordWrap = true;
            this.tempMC.addChild(this.tempLoader);
            myAlert.Add_mc.addChild(this.tempMC);
            dispatchObj.addChild(myAlert);
            this.setButtonHeight(myAlert,268);
            dragAndDepthManage(myAlert);
            setAlertXY(myAlert);
         }
         catch(E:*)
         {
            trace(E,this);
         }
      }
      
      public function SANDUIshowAlert(myAlert:*) : void
      {
         var BT:* = undefined;
         var __x:Number = NaN;
         var offset:uint = 0;
         try
         {
            myAlert.name = "changAlert_sandUIMC";
            if(TITLE == "")
            {
               myAlert.ico_mc.tip_mc.gotoAndStop(1);
            }
            else if(TITLE == "郵箱")
            {
               myAlert.ico_mc.tip_mc.gotoAndStop(2);
            }
            else if(TITLE == "劇院")
            {
               myAlert.ico_mc.tip_mc.gotoAndStop(3);
            }
            this.myTextBox.x = 105;
            this.myTextBox.y = 70;
            this.myTextBox.width = 237;
            this.myTextBox.type = TextFieldType.INPUT;
            this.myTextBox.multiline = false;
            this.myTextBox.text = "";
            BC.addEvent(this,this.myTextBox,Event.CHANGE,this.textInputCapture);
            this.mymsgTextBox.x = 43;
            this.mymsgTextBox.y = 102;
            this.mymsgTextBox.width = 312;
            this.mymsgTextBox.height = 134;
            this.mymsgTextBox.type = TextFieldType.INPUT;
            this.mymsgTextBox.multiline = true;
            this.mymsgTextBox.wordWrap = true;
            this.mymsgTextBox.text = "";
            BC.addEvent(this,this.mymsgTextBox,Event.CHANGE,this.textInputCapture);
            myAlert.addChild(this.myTextBox);
            myAlert.addChild(this.mymsgTextBox);
            dispatchObj.addChild(myAlert);
            offset = 0;
            BT = IndexManager.getInstance().getMovieClip("Alert_button");
            BT.gotoAndStop(this.myButtonArray[0]);
            offset = (myAlert.drag_mc.width - BT.mc.width) / 2;
            BT.x = offset;
            BT.y = 240;
            BT.num = 0;
            BT.name = "button1";
            BT.buttonMode = true;
            BC.addEvent(this,BT,MouseEvent.CLICK,dispatchFun,false,0,true);
            myAlert.addChild(BT);
            TARGET = BT.parent;
            dragAndDepthManage(myAlert);
            setAlertXY(myAlert);
         }
         catch(E:*)
         {
            trace(E,this);
         }
      }
      
      public function textInputCapture(e:*) : void
      {
         if(this.checkLen(this.myTextBox.text) > 40)
         {
            TITLE = this.myTextBox.text;
            this.myTextBox.text = "最多可以輸入40字符哦~";
            this.myTextBox.type = TextFieldType.DYNAMIC;
            this.IntervalID = setTimeout(function():*
            {
               try
               {
                  mastTitFun();
               }
               catch(E:*)
               {
                  trace(E);
               }
            },2000);
         }
         if(this.checkLen(this.mymsgTextBox.text) > 1000)
         {
            CONTENT = this.mymsgTextBox.text;
            this.mymsgTextBox.text = "最多可以輸入1000字符哦~";
            this.mymsgTextBox.type = TextFieldType.DYNAMIC;
            this.IntervalID = setTimeout(function():*
            {
               try
               {
                  mastMsgFun();
               }
               catch(E:*)
               {
                  trace(E);
               }
            },2000);
         }
         Alert.back_tit = this.myTextBox.text;
         Alert.back_msg = this.mymsgTextBox.text;
      }
      
      private function mastTitFun() : void
      {
         this.myTextBox.text = TITLE.slice(0,38);
         this.myTextBox.type = TextFieldType.INPUT;
      }
      
      private function mastMsgFun() : void
      {
         this.mymsgTextBox.text = CONTENT.slice(0,998);
         this.mymsgTextBox.type = TextFieldType.INPUT;
         Alert.back_tit = TextFieldType.INPUT;
         Alert.back_msg = CONTENT.slice(0,998);
      }
      
      public function NPCUIshowAlert(myAlert:*) : void
      {
         var myText:TextField = null;
         var BT:* = undefined;
         var BTs:* = undefined;
         var __x:Number = NaN;
         var offset:uint = 0;
         try
         {
            this.NPCMsg_arr = CONTENT.split(";");
            this.tempMC = new MovieClip();
            this.tempLoader.load(VL.getURLRequest(TITLE));
            myText = myAlert.ico_mc.smc_txt;
            myText.text = this.NPCMsg_arr[0];
            myText.x = 200;
            myText.y = (myAlert.drag_mc.height - myText.numLines * myText.height) / 2;
            myText.width = 180;
            myText.type = TextFieldType.INPUT;
            myText.autoSize = TextFieldAutoSize.LEFT;
            myText.selectable = false;
            myText.multiline = true;
            myText.wordWrap = true;
            this.tempMC.addChild(this.tempLoader);
            myAlert.Add_mc.addChild(this.tempMC);
            dispatchObj.addChild(myAlert);
            offset = 0;
            BT = IndexManager.getInstance().getMovieClip("Alert_button");
            BT.gotoAndStop(this.myButtonArray[0]);
            offset = (myAlert.drag_mc.width - BT.mc.width) / 2;
            BT.x = offset;
            BT.y = 268;
            BT.num = 0;
            myAlert.now_num = 0;
            BT.name = "button1";
            BT.buttonMode = true;
            BC.addEvent(this,BT,MouseEvent.CLICK,this.npcNextMsg,false,0,true);
            myAlert.addChild(BT);
            TARGET = myAlert;
            dragAndDepthManage(myAlert);
            setAlertXY(myAlert);
         }
         catch(E:*)
         {
            trace(E,this);
         }
      }
      
      public function npcNextMsg(e:*) : void
      {
         if(TARGET.now_num < this.NPCMsg_arr.length - 1)
         {
            TARGET.now_num += 1;
            TARGET.ico_mc.smc_txt.text = this.NPCMsg_arr[TARGET.now_num];
         }
         else if(TARGET.now_num == this.NPCMsg_arr.length - 1)
         {
            close(TARGET);
         }
      }
      
      private function checkLen(txt:*) : int
      {
         var testSTR:* = undefined;
         var strNum:int = 0;
         var L:int = int(txt.length);
         for(var i:int = 0; i < L; i++)
         {
            testSTR = txt.slice(i,i + 1);
            if(testSTR.charCodeAt(0) > 130)
            {
               strNum += 2;
            }
            else
            {
               strNum++;
            }
         }
         return strNum;
      }
      
      public function IfshowCloseBtn(myAlert:*) : void
      {
         var mc:* = undefined;
         if(this.SHOW_BTN)
         {
            mc = IndexManager.getInstance().getMovieClip("Job_AddCloseBtn");
            mc.x = myAlert.drag_mc.width - mc.width - 10;
            mc.y = 8;
            mc.buttonMode = true;
            BC.addEvent(this,mc,MouseEvent.CLICK,close,false,0,true);
            myAlert.addChild(mc);
         }
      }
      
      public function removeEvent(evt:Event) : void
      {
         clearTimeout(this.IntervalID);
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeEvent);
      }
   }
}

