package com.module.hulupuModule
{
   import com.common.scrollBar.ScrollBar;
   import com.core.manager.UIManager;
   import com.core.stringPop.Pop;
   import com.event.EventTaomee;
   import com.module.friendList.friendView.GView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   
   public class HistoryView extends EventDispatcher
   {
      
      public static var ITEM_MSG:String = "itemMsg";
      
      public static var historyObj:Object = {};
      
      private var commpnArray:Array;
      
      private var targetMC:MovieClip;
      
      private var msgScrollBar:ScrollBar;
      
      private var TotalmsgLen:uint;
      
      private var checkMovieTimer:Timer;
      
      public function HistoryView()
      {
         super();
         this.commpnArray = new Array();
         this.commpnArray.push({
            "MSG":"你屏蔽了咕嚕噗消息.",
            "USERID":1000,
            "USERNAME":""
         });
         this.TotalmsgLen = 0;
      }
      
      public static function getInstanceByGroup(GroupID:uint) : HistoryView
      {
         if(Boolean(historyObj[GroupID]))
         {
            return historyObj[GroupID];
         }
         historyObj[GroupID] = new HistoryView();
         return historyObj[GroupID];
      }
      
      public function setTarget(_targetMC:MovieClip) : void
      {
         this.targetMC = _targetMC;
         this.msgScrollBar = new ScrollBar(null,this.targetMC.chat_box,{
            "length":234,
            "x":211,
            "y":0
         },ScrollBar.DIRECTION_HORIZONTAL,ScrollBar.DIRECTION_VERTICAL,14);
         BC.addEvent(this,this.msgScrollBar,ScrollBar.EVENT_ON_SIZE_CHANGE,this.checkMovieExp);
         this.checkMovieTimer = GC.setGTimeout(this.checkMovieExp,200);
      }
      
      public function addItem(obj:Object) : void
      {
         var tempObj:Object = null;
         var tempMC:MovieClip = null;
         if(this.commpnArray.length >= 50)
         {
            tempObj = this.commpnArray.shift();
            tempMC = this.targetMC.chat_box.getChildByName("seq_" + tempObj.seq) as MovieClip;
            if(Boolean(tempMC))
            {
               BC.removeEvent(this,tempMC.msg_txt,TextEvent.LINK,this.linkHandler);
               GC.stopAllMC(tempMC);
               tempMC.parent.removeChild(tempMC);
            }
         }
         ++this.TotalmsgLen;
         obj.seq = this.TotalmsgLen;
         this.commpnArray.push(obj);
      }
      
      public function getCommpnArray() : Array
      {
         return this.commpnArray;
      }
      
      public function showSMGData() : void
      {
         var item:MovieClip = null;
         var hasExpression:int = 0;
         var myClass:Class = null;
         var tempMC:MovieClip = null;
         var tempStr:String = null;
         var k:uint = 0;
         var htmlStr:String = null;
         var oldY:Number = 0;
         var tempArray:Array = this.commpnArray;
         for(var i:uint = 0; i < tempArray.length; i++)
         {
            item = this.targetMC.chat_box.getChildByName("seq_" + tempArray[i].seq) as MovieClip;
            if(!item)
            {
               item = UIManager.getMovieClip("chat_item");
               item.name = "seq_" + tempArray[i].seq;
               item.msg = tempArray[i].MSG;
               item.msg = this.checkAddMSG(item.msg);
               item.userID = tempArray[i].USERID;
               item.userName = Boolean(GView.friendsInfo[item.userID]) ? GView.friendsInfo[item.userID].Nick : tempArray[i].USERID;
               item.msg_txt.wordWrap = true;
               item.msg_txt.autoSize = TextFieldAutoSize.LEFT;
               item.msg_txt.mouseWheelEnabled = false;
               hasExpression = -1;
               if(item.msg.substr(0,1) == "/")
               {
                  tempStr = item.msg.substr(1,2);
                  for(k = 0; k < GV.expressionArray.length; k++)
                  {
                     if(GV.expressionArray[k] == tempStr)
                     {
                        hasExpression = int(k);
                        break;
                     }
                  }
               }
               if(item.msg == "您發送的信息已經被屏蔽，請文明用語！")
               {
                  item.msg_txt.htmlText = "<font color=\'#0000cc\'>" + item.msg + "</font>";
                  item.bg_mc.height = item.msg_txt.numLines * 16 + 6;
               }
               else if(item.userID == 1000)
               {
                  myClass = UIManager.getClass("securityTip_mc");
                  tempMC = new myClass();
                  tempMC.x = -5;
                  tempMC.y = -4;
                  item.addChild(tempMC);
                  htmlStr = "";
                  item.msg_txt.htmlText = htmlStr;
                  item.bg_mc.height = 25;
               }
               else if(item.userID == 1001)
               {
                  item.msg_txt.htmlText = "<font color=\'#999999\'>" + item.msg + "</font>";
                  item.bg_mc.height = item.msg_txt.numLines * 16 + 6;
               }
               else
               {
                  if(hasExpression > -1)
                  {
                     myClass = UIManager.getClass("expression_mc");
                     tempMC = new myClass();
                     tempMC.name = "ep";
                     tempMC.gotoAndStop(hasExpression + 1);
                     tempMC.x = 5;
                     tempMC.y = 20;
                     item.addChild(tempMC);
                     htmlStr = "<font color=\'#0000cc\'><u><a href=\'event:UserPan|" + item.userID + "\'>" + item.userName + "(" + item.userID + ")</a></u>說:</font><br> ";
                     item.msg_txt.htmlText = htmlStr;
                     item.bg_mc.height = 50;
                  }
                  else
                  {
                     htmlStr = "<font color=\'#0000cc\'><u><a href=\'event:UserPan|" + item.userID + "\'>" + item.userName + "(" + item.userID + ")</a></u>說:</font><br><font color=\'#000000\'>" + item.msg + "</font>";
                     item.msg_txt.htmlText = htmlStr;
                     item.bg_mc.height = item.msg_txt.numLines * 16 + 6;
                  }
                  BC.addEvent(this,item.msg_txt,TextEvent.LINK,this.linkHandler);
               }
               item.bg_mc.width = 210;
               item.bg_mc.alpha = 0;
               item.y = oldY;
               oldY = item.y + item.bg_mc.height - 4;
               this.targetMC.chat_box.addChild(item);
            }
            else
            {
               item.y = oldY;
               oldY = item.y + item.bg_mc.height - 4;
            }
         }
         this.msgScrollBar.sendToBottom();
      }
      
      private function checkMovieExp(E:Event = null) : void
      {
         var tempItemMC:MovieClip = null;
         var tempEpMC:MovieClip = null;
         var num:int = int(this.targetMC.chat_box.numChildren);
         for(var j:int = num - 1; j >= 0; j--)
         {
            tempItemMC = this.targetMC.chat_box.getChildAt(j);
            tempEpMC = tempItemMC.getChildByName("ep") as MovieClip;
            if(tempEpMC != null)
            {
               if(tempEpMC.hitTestObject(this.targetMC.hit_mc))
               {
                  tempEpMC = tempEpMC.getChildAt(0) as MovieClip;
                  if(Boolean(tempEpMC))
                  {
                     tempEpMC.play();
                  }
               }
               else
               {
                  GC.stopAllMC(tempEpMC);
               }
            }
         }
      }
      
      private function checkAddMSG(filterStr:String) : String
      {
         var num:int = 0;
         var currentStr:String = null;
         var tempStr:String = null;
         var tempStr2:String = null;
         var MapTitle:String = null;
         var src:String = null;
         var imgStr:String = null;
         var mapArray:Array = Pop.popArray(filterStr,"[IMG (","[/IMG]");
         if(mapArray != null)
         {
            for(num = 0; num < mapArray.length; num++)
            {
               currentStr = mapArray[num];
               tempStr = Pop.popString(currentStr,"[IMG (",")]");
               tempStr2 = Pop.replaceStrng(currentStr,tempStr,"");
               MapTitle = Pop.replaceStrng(tempStr2,"[/IMG]","");
               src = Pop.popString(tempStr,"[IMG (",")]",0,false);
               imgStr = "<b><u><a href=\'event:" + src + "\' color=\'#00ff00\'>" + MapTitle + "</a></u></b>";
               filterStr = Pop.replaceStrng(filterStr,mapArray[num],imgStr);
            }
         }
         return filterStr;
      }
      
      private function linkHandler(E:TextEvent) : void
      {
         var str:String = E.text;
         dispatchEvent(new EventTaomee(ITEM_MSG,str));
      }
      
      private function doAction(E:MouseEvent) : void
      {
      }
      
      private function showBG(E:MouseEvent) : void
      {
         E.currentTarget.bg_mc.alpha = 1;
      }
      
      private function hideBG(E:MouseEvent) : void
      {
         E.currentTarget.bg_mc.alpha = 0;
      }
      
      public function clearClass(E:* = null) : void
      {
         var tempEpMC:MovieClip = null;
         var tempItemMC:MovieClip = null;
         BC.removeEvent(this);
         GC.clearGTimeout(this.checkMovieTimer);
         var num:int = int(this.targetMC.chat_box.numChildren);
         for(var j:int = num - 1; j >= 0; j--)
         {
            tempItemMC = this.targetMC.chat_box.getChildAt(j);
            tempEpMC = tempItemMC.getChildByName("ep") as MovieClip;
            if(tempEpMC != null)
            {
               GC.stopAllMC(tempEpMC);
            }
            this.targetMC.chat_box.removeChild(tempItemMC);
         }
      }
   }
}

