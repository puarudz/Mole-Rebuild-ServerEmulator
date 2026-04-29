package com.common.dialogBox
{
   import assets.DialogBox_mc;
   import com.core.manager.UIManager;
   import flash.display.MovieClip;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   
   public class DialogBox extends DialogBox_mc implements IDialogBox
   {
      
      public static var DialogBoxLen:int = 0;
      
      private static var DialogBoxLib:Array = new Array();
      
      private var BGH:int;
      
      private var showBoxTimer:Timer;
      
      public function DialogBox()
      {
         super();
         this.BGH = BG.height;
         visible = false;
         showMSG_txt.autoSize = TextFieldAutoSize.LEFT;
         showMSG_txt.wordWrap = true;
      }
      
      public static function showDialogBox(msg:String, delay:int = 3000) : DialogBox
      {
         var returnCls:DialogBox = null;
         if(Boolean(DialogBoxLib.length))
         {
            returnCls = DialogBox(DialogBoxLib.shift());
            returnCls.say(msg,delay);
            return returnCls;
         }
         returnCls = new DialogBox();
         returnCls.say(msg,delay);
         return returnCls;
      }
      
      public function setPosXY(__x:int, __y:int) : void
      {
         x = __x;
         y = __y;
      }
      
      public function say(msg:String, delay:int = 3000) : void
      {
         var tempStr:String = null;
         var tempNum:int = 0;
         var i:uint = 0;
         if(Boolean(this.showBoxTimer))
         {
            this.showBoxTimer.stop();
         }
         this.showBoxTimer = new Timer(delay,1);
         BC.addEvent(this,this.showBoxTimer,"timerComplete",this.timerCompleteHandler);
         if(msg.substr(0,1) == "/")
         {
            tempStr = msg.substr(1,2);
            tempNum = -1;
            for(i = 0; i < GV.expressionArray.length; i++)
            {
               if(GV.expressionArray[i] == tempStr)
               {
                  tempNum = int(i);
                  break;
               }
            }
            if(Boolean(tempStr.length) && !isNaN(Number(tempStr)))
            {
               tempNum = int(tempStr);
            }
            if(tempNum > -1)
            {
               if(tempNum != 24)
               {
                  this.showExpression(tempNum + 1);
               }
            }
            else if(tempNum != -1)
            {
               this.showMsg(msg);
            }
         }
         else
         {
            this.showMsg(msg);
         }
      }
      
      private function showMsg(msg:String) : void
      {
         msg = msg.split("                 ").join("");
         this.showBoxTimer.start();
         visible = true;
         showMSG_txt.text = msg;
         BG.width = showMSG_txt.textWidth + 20;
         BG.height = showMSG_txt.textHeight + 20;
         msgjt_mc.gotoAndStop(1);
         if(showMSG_txt.textWidth < 100)
         {
            msgjt_mc.gotoAndStop(2);
            BG.height = showMSG_txt.textHeight + 16;
         }
         BG.x = -int(BG.width / 2);
         showMSG_txt.x = BG.x + 8;
         BG.y = msgjt_mc.y - BG.height;
         showMSG_txt.y = BG.y + 8;
      }
      
      private function showExpression(ExpressionNum:int) : void
      {
         this.showBoxTimer.start();
         showMSG_txt.text = "";
         visible = true;
         BG.width = 85;
         BG.height = 50;
         BG.x = -int(BG.width / 2);
         BG.y = msgjt_mc.y - BG.height;
         msgjt_mc.gotoAndStop(1);
         var myClass:* = UIManager.getClass("expression_mc") as Class;
         var tempMC:MovieClip = new myClass();
         tempMC.name = "ep";
         tempMC.gotoAndStop(ExpressionNum);
         tempMC.x = -16;
         tempMC.y = BG.y + 8;
         tempMC.scaleX = 1.5;
         tempMC.scaleY = 1.5;
         addChild(tempMC);
      }
      
      private function timerCompleteHandler(E:* = null) : void
      {
         try
         {
            BC.removeEvent(this);
            showMSG_txt.text = "";
            visible = false;
            GC.clearAll(getChildByName("ep"));
         }
         catch(E:Error)
         {
            BC.removeEvent(this);
         }
         x = 0;
         y = 0;
         if(DialogBoxLib.length < DialogBoxLen && DialogBoxLib.indexOf(this) == -1)
         {
            DialogBoxLib.push(this);
         }
         GC.clearAll(this);
      }
      
      public function removeDialogBox() : void
      {
         this.timerCompleteHandler();
      }
   }
}

