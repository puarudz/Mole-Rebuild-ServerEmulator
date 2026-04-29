package com.view.mapView.activity.mapActivity.elaineParty
{
   import com.common.Alert.Alert;
   import com.logic.socket.PageSandMsg.sandMsgReq;
   import com.logic.socket.PageSandMsg.sandMsgRes;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class CharityMessageView extends BasePartyView
   {
      
      private var _contentTxt:TextField;
      
      private var _cancelBtn:SimpleButton;
      
      private var _okBtn:SimpleButton;
      
      public function CharityMessageView(ui:MovieClip)
      {
         super(ui);
         this._closeBtn = _ui["close_btn"];
         this._contentTxt = _ui["content_txt"];
         this._cancelBtn = _ui["no_btn"];
         this._okBtn = _ui["yes_btn"];
         this._contentTxt.maxChars = 500;
      }
      
      override protected function Init() : void
      {
         super.Init();
         this._contentTxt.text = "";
         BC.addEvent(this,this._cancelBtn,MouseEvent.CLICK,CloseBtnHandler);
         BC.addEvent(this,this._okBtn,MouseEvent.CLICK,this.SendMessage);
      }
      
      private function SendMessage(e:MouseEvent) : void
      {
         var keyWord:String = null;
         var msgType:int = 0;
         var socketReq:sandMsgReq = null;
         if(this._contentTxt.text != "")
         {
            keyWord = "name:慈善基金";
            msgType = 1004;
            socketReq = new sandMsgReq();
            BC.addEvent(this,GV.onlineSocket,sandMsgRes.PAGESANDBACK_SUCCESS,this.SendMsgOkHandler);
            socketReq.sandFun(msgType,keyWord,this._contentTxt.text);
         }
         else
         {
            Alert.smileAlart("         一定要填寫內容哦！");
         }
      }
      
      private function SendMsgOkHandler(e:* = null) : void
      {
         CloseBtnHandler();
         BC.removeEvent(this,GV.onlineSocket,sandMsgRes.PAGESANDBACK_SUCCESS,this.SendMsgOkHandler);
         Alert.smileAlart("      太好了！投稿成功。感謝你的參與！");
      }
   }
}

