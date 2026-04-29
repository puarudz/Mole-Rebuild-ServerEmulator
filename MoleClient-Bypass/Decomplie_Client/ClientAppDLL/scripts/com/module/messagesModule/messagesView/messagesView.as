package com.module.messagesModule.messagesView
{
   import com.core.MainManager;
   import com.core.manager.UIManager;
   import com.core.newloader.XMLLoader;
   import com.event.XMLLoadEvent;
   import com.logic.lamuMantraLogic.LamuMantra;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class messagesView extends Sprite
   {
      
      private static var empLg:int = 0;
      
      private static var outx:int = 260;
      
      private static var outy:int = 397;
      
      private static var conHeight:int = 40;
      
      private static var tooly:int = 533;
      
      private static var ypot:int = 15;
      
      private var xml:XML;
      
      private var tempClass:*;
      
      private var tempBtnAClass:*;
      
      private var tempBtnBClass:*;
      
      private var conOutClass:*;
      
      private var messagesMC:MovieClip;
      
      private var lastMC:MovieClip;
      
      private var outMC:MovieClip;
      
      private var addHeight:int = 0;
      
      private var conOutW:Number = 0;
      
      private var send_arr:Array;
      
      private var next_arr:Array;
      
      private var next0_arr:Array;
      
      private var next1_arr:Array;
      
      private var next2_arr:Array;
      
      private var next3_arr:Array;
      
      private var next4_arr:Array;
      
      private var next5_arr:Array;
      
      private var next6_arr:Array;
      
      private var next7_arr:Array;
      
      private var next8_arr:Array;
      
      private var next9_arr:Array;
      
      private var txt0_arr:Array;
      
      private var txt1_arr:Array;
      
      private var txt2_arr:Array;
      
      private var txt3_arr:Array;
      
      private var txt4_arr:Array;
      
      private var txt5_arr:Array;
      
      private var txt6_arr:Array;
      
      private var txt7_arr:Array;
      
      private var txt8_arr:Array;
      
      private var txt9_arr:Array;
      
      public function messagesView()
      {
         super();
         var tempversion:XMLLoader = new XMLLoader("resource/xml/messages.xml?0403");
         tempversion.addEventListener(XMLLoadEvent.ON_SUCCESS,this.XMLOverHandler);
         tempversion.addEventListener(XMLLoadEvent.ERROR,this.XMLFailHandler);
         tempversion.doLoad();
      }
      
      public function XMLOverHandler(evt:XMLLoadEvent) : void
      {
         var nextArr:String = null;
         var b:uint = 0;
         var txtArr:String = null;
         try
         {
            this.xml = evt.getXML();
            this.xml.ignoreWhitespace = true;
         }
         catch(e:*)
         {
         }
         var ssend:String = this.xml.item.@Send;
         var nnext:String = this.xml.item.@Next;
         this.send_arr = ssend.split(",");
         this.next_arr = nnext.split(",");
         for(var i:uint = 0; i < this.next_arr.length; i++)
         {
            nextArr = this.xml["next" + i].@arr;
            this["next" + i + "_arr"] = nextArr.split("/");
            for(b = 0; b < this["next" + i + "_arr"].length; b++)
            {
               txtArr = this.xml["txt" + i].@txts;
               this["txt" + i + "_arr"] = txtArr.split("/");
            }
         }
         if(this.next_arr.length + this.send_arr.length < 11)
         {
            this.baginit();
         }
      }
      
      public function XMLFailHandler(evt:XMLLoadEvent) : void
      {
      }
      
      public function baginit() : void
      {
         this.tempClass = UIManager.getClass("messagesMC_common");
         this.messagesMC = new this.tempClass();
         this.messagesMC.name = "messagesMC";
         MainManager.getAppLevel().addChild(this.messagesMC);
         this.lastMC = new this.tempClass();
         this.lastMC.name = "lastMC";
         this.lastMC.removeChild(this.lastMC["conEmp_mc"]);
         this.lastMC.removeChild(this.lastMC["bg_mask"]);
         this.conOutClass = UIManager.getClass("OutUI_mc");
         this.outMC = new this.conOutClass();
         this.outMC.name = "outMC";
         this.messagesMC.conEmp_mc.addChild(this.outMC);
         this.tempBtnAClass = UIManager.getClass("sendUI_mc");
         this.tempBtnBClass = UIManager.getClass("nextUI_mc");
         this.addHeight = this.messagesMC.bg_mask.height / 2;
         this.conOutW = this.outMC.width;
         this.messagesMC.bg_mc.addEventListener(MouseEvent.CLICK,this.bgPress);
         this.loadBtn();
         this.messagesMC.addEventListener(MouseEvent.ROLL_OVER,this.overHandler);
      }
      
      private function overHandler(evt:MouseEvent) : void
      {
         this.messagesMC.removeEventListener(MouseEvent.ROLL_OVER,this.overHandler);
         this.messagesMC.addEventListener(MouseEvent.ROLL_OUT,this.outFun);
      }
      
      private function loadBtn() : void
      {
         var i:uint = 0;
         var send_mc:MovieClip = null;
         var it:int = 0;
         var next_mc:MovieClip = null;
         this.messagesMC.x = 350;
         if(this.send_arr[0] == "")
         {
            this.messagesMC.bg_mc.height = (this.addHeight + ypot) * this.next_arr.length + 30;
            this.outMC.height = this.messagesMC.bg_mc.height + conHeight;
            this.outMC.width = this.messagesMC.bg_mc.width + 50;
            this.outMC.x += (this.outMC.width - this.messagesMC.bg_mc.width) / 4;
            this.messagesMC.y = tooly - this.messagesMC.bg_mc.height;
            empLg = 1;
         }
         else
         {
            this.messagesMC.bg_mc.height = (this.addHeight + ypot) * (this.send_arr.length - empLg + this.next_arr.length) + 30;
            this.outMC.height = this.messagesMC.bg_mc.height + conHeight;
            this.outMC.width = this.messagesMC.bg_mc.width + 50;
            this.outMC.x += (this.outMC.width - this.messagesMC.bg_mc.width) / 4;
            this.messagesMC.y = tooly - this.messagesMC.bg_mc.height;
            for(i = 0; i < this.send_arr.length - empLg; i++)
            {
               send_mc = new this.tempBtnAClass();
               this.messagesMC.addChild(send_mc);
               send_mc.x = (this.messagesMC.bg_mc.width - send_mc.width) / 2;
               send_mc.y = this.addHeight * i + ypot * (i + 1);
               send_mc.my_txt.mouseEnabled = false;
               send_mc.my_txt.text = this.send_arr[i];
               send_mc.id = i;
               send_mc.txtIn = this.send_arr[i];
               send_mc.btn.addEventListener(MouseEvent.CLICK,this.sendedFun);
            }
         }
         if(this.next_arr[0] == "")
         {
            this.messagesMC.bg_mc.height = (this.addHeight + ypot) * this.send_arr.length + 30;
            this.outMC.height = this.messagesMC.bg_mc.height + conHeight;
            this.outMC.width = this.messagesMC.bg_mc.width + 50;
            empLg = 1;
            this.outMC.x += (this.outMC.width - this.messagesMC.bg_mc.width) / 4;
            this.messagesMC.y = tooly - this.messagesMC.bg_mc.height;
         }
         else
         {
            this.messagesMC.bg_mc.height = (this.addHeight + ypot) * (this.send_arr.length + this.next_arr.length - empLg) + 30;
            this.outMC.height = this.messagesMC.bg_mc.height + conHeight;
            this.outMC.width = this.messagesMC.bg_mc.width + 50;
            this.outMC.x += (this.outMC.width - this.messagesMC.bg_mc.width) / 4;
            this.messagesMC.y = tooly - this.messagesMC.bg_mc.height;
            for(it = this.send_arr.length - empLg; it < this.send_arr.length + this.next_arr.length - empLg; it++)
            {
               next_mc = new this.tempBtnBClass();
               this.messagesMC.addChild(next_mc);
               next_mc.x = (this.messagesMC.bg_mc.width - next_mc.width * 88 / 100) / 2;
               next_mc.y = this.addHeight * it + ypot * (it + 1);
               next_mc.my_txt.mouseEnabled = false;
               next_mc.my_txt.text = this.next_arr[it - this.send_arr.length + empLg];
               next_mc.id = it;
               next_mc.txtIn = this.next_arr[it - this.send_arr.length + empLg];
               next_mc.btn.addEventListener(MouseEvent.CLICK,this.sendedFun);
               next_mc.btn.addEventListener(MouseEvent.MOUSE_OVER,this.overFun);
            }
         }
         this.outMC.height = this.messagesMC.bg_mc.height + conHeight;
         this.outMC.width = this.messagesMC.bg_mc.width + 50;
      }
      
      private function lastUI(a:int, b:String, c:int) : void
      {
         var sen_mc:MovieClip = null;
         var lastIp:int = a - this.send_arr.length + empLg;
         var pp:Array = this["next" + lastIp + "_arr"];
         var pplg:int = 0;
         pplg = int(pp.length);
         this.messagesMC.addChild(this.lastMC);
         var pot:int = (this.addHeight + ypot) * pplg + 30;
         this.lastMC.bg_mc.height = pot;
         if(this.messagesMC.bg_mc.height < this.lastMC.bg_mc.height)
         {
            this.outMC.height = pot + conHeight;
            this.outMC.y += (this.outMC.height - outy) / 4;
         }
         this.outMC.width += this.messagesMC.width + 50;
         this.lastMC.x = this.messagesMC.bg_mc.x + this.messagesMC.bg_mc.width;
         this.lastMC.bg_mc.addEventListener(MouseEvent.CLICK,this.bgPress);
         while(this.lastMC.numChildren > 1)
         {
            this.lastMC.removeChildAt(this.lastMC.numChildren - 1);
         }
         for(var i:uint = 0; i < pplg; i++)
         {
            sen_mc = new this.tempBtnAClass();
            this.lastMC.addChild(sen_mc);
            sen_mc.x = (this.lastMC.bg_mc.width - sen_mc.width) / 2;
            sen_mc.y = this.addHeight * i + ypot * (i + 1);
            sen_mc.my_txt.mouseEnabled = false;
            sen_mc.my_txt.text = pp[i];
            sen_mc.lastIp = lastIp;
            sen_mc.id = i;
            sen_mc.lastTxt = b;
            sen_mc.btn.addEventListener(MouseEvent.CLICK,this.lastFun);
         }
         this.lastMC.y = c;
         if(this.lastMC.height + this.lastMC.y > this.messagesMC.bg_mc.height)
         {
            this.lastMC.y -= this.lastMC.height / 2;
         }
         if(this.lastMC.height + this.lastMC.y > this.messagesMC.bg_mc.height)
         {
            this.lastMC.y = this.messagesMC.bg_mc.height - this.lastMC.height;
         }
      }
      
      private function delFun() : void
      {
         this.messagesMC.removeChild(this.lastMC);
         MainManager.getAppLevel().removeChild(this.messagesMC);
      }
      
      private function overFun(event:MouseEvent = null) : void
      {
         var cc:int = int(event.target.parent.y);
         if(!MainManager.getAppLevel().getChildByName("lastMC"))
         {
            this.outMC.width = this.conOutW;
            this.outMC.x = 0;
            this.lastUI(event.target.parent.id,event.target.parent.txtIn,cc);
         }
         else
         {
            this.outMC.width = this.conOutW;
            this.outMC.x = 0;
            this.messagesMC.removeChild(this.lastMC);
            this.lastMC = new this.tempClass();
            this.lastMC.name = "lastMC";
            this.lastUI(event.target.parent.id,event.target.parent.txtIn,cc);
         }
      }
      
      private function outFun(event:MouseEvent = null) : void
      {
         if(Boolean(MainManager.getAppLevel().getChildByName("lastMC")))
         {
            this.messagesMC.removeChild(this.lastMC);
         }
         if(Boolean(MainManager.getAppLevel().getChildByName("messagesMC")))
         {
            MainManager.getAppLevel().removeChild(this.messagesMC);
         }
      }
      
      private function bgPress(e:MouseEvent) : void
      {
      }
      
      private function sendedFun(event:MouseEvent = null) : void
      {
         var cc:int = 0;
         var txt:String = null;
         var tempObj:Object = null;
         if(event.target.parent.id >= this.send_arr.length - 1)
         {
            cc = int(event.target.parent.y);
            if(!MainManager.getAppLevel().getChildByName("lastMC"))
            {
               this.outMC.width = this.conOutW;
               this.outMC.x = 0;
               this.lastUI(event.target.parent.id,event.target.parent.txtIn,cc);
            }
            else
            {
               this.outMC.width = this.conOutW;
               this.outMC.x = 0;
               MainManager.getAppLevel().removeChild(this.lastMC);
               this.lastMC = new this.tempClass();
               this.lastMC.name = "lastMC";
               this.lastUI(event.target.parent.id,event.target.parent.txtIn,cc);
            }
         }
         else
         {
            txt = event.target.parent.txtIn;
            tempObj = {"EventObj":{"msg":txt}};
            GV.MAN_PEOPLE.showWordBoxMSG(tempObj);
            GV.onlineClass.chating(0,txt);
            LamuMantra.checkHasMantra(txt);
            this.delFun();
         }
      }
      
      private function lastFun(event:MouseEvent = null) : void
      {
         this.lastSend(event.target.parent.lastIp,event.target.parent.id,event.target.parent.lastTxt);
      }
      
      private function lastSend(Ip:int, aa:int, txts:String) : void
      {
         var myA:Array = this["txt" + Ip + "_arr"];
         var strs:String = myA[aa].toString();
         var myB:Array = strs.split(";");
         var lg:int = int(myB.length);
         var bb:int = Math.floor(Math.random() * lg);
         var txt:String = myB[bb];
         var tempObj:Object = {"EventObj":{"msg":txt}};
         GV.MAN_PEOPLE.showWordBoxMSG(tempObj);
         GV.onlineClass.chating(0,txt);
         LamuMantra.checkHasMantra(txt);
         GV.onlineSocket.dispatchEvent(new Event("say_language"));
         this.delFun();
      }
      
      public function tt(... args) : void
      {
         for(var i:uint = 0; i < args.length; i++)
         {
         }
      }
   }
}

