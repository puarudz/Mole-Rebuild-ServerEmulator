package com.module.loadExtentPanel
{
   import com.common.Alert.Alert;
   import com.event.EventTaomee;
   import com.logic.socket.PageSandMsg.sandMsgReq;
   import com.logic.socket.PageSandMsg.sandMsgRes;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class PasswordSign extends LoadPanel
   {
      
      private var myAle:*;
      
      private var AlertMC:MovieClip;
      
      public function PasswordSign(str:String, name:String, container:Sprite)
      {
         super(str,name,container);
         this.AlertMC = new MovieClip();
         _parentCon.addChild(this.AlertMC);
      }
      
      override protected function otherBtnEvent() : void
      {
         BC.addEvent(this,_curLoader.content.root["sendBtn"],MouseEvent.CLICK,this.sendHandler);
      }
      
      private function sendHandler(event:MouseEvent) : void
      {
         this.dispatchEvent(new Event(SEND_MSG));
         if(!this.AlertMC.getChildByName("changAlert_sandUIMC"))
         {
            this.myAle = Alert.showAlert(this.AlertMC,"","",Alert.CHANG_ALERT,"sandmsg",true,true,"sandUI","400,300");
            BC.addEvent(this,this.myAle,Alert.CLICK_ + "1",this.next);
         }
      }
      
      private function next(event:Event) : void
      {
         var info:String = null;
         BC.removeEvent(this,this.myAle,Alert.CLICK_ + "1",this.next);
         var pp:sandMsgReq = new sandMsgReq();
         var msg:String = Alert.back_msg;
         var tit:String = Alert.back_tit;
         if(msg != "" && tit != "")
         {
            pp.sandFun(_sandType,tit,msg);
            BC.addEvent(this,GV.onlineSocket,sandMsgRes.PAGESANDBACK_SUCCESS,this.showsandTit);
         }
         else
         {
            info = "一定要填寫標題和內容才可以哦~";
            this.showLastTipUI(info);
         }
      }
      
      private function showsandTit(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,sandMsgRes.PAGESANDBACK_SUCCESS,this.showsandTit);
         var info:String = "太好了！投稿成功\r摩爾雜志社感謝你的參與";
         this.showLastTipUI(info);
      }
      
      private function showLastTipUI(info:String) : void
      {
         var myAle:Class = Alert.showAlert(this.AlertMC,info,"",Alert.CHANG_ALERT,"sure",true,false,"F") as Class;
      }
      
      override public function destroy() : void
      {
         if(this.myAle != null)
         {
            _parentCon.removeChild(this.AlertMC);
            BC.removeEvent(this,this.myAle,Alert.CLICK_ + "1",this.next);
         }
         super.destroy();
      }
   }
}

