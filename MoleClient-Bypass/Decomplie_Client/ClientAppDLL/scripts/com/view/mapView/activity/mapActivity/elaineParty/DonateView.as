package com.view.mapView.activity.mapActivity.elaineParty
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.elaineParty.ElainePartySocket;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class DonateView extends BasePartyView
   {
      
      private var _okBtn:SimpleButton;
      
      private var _btn1:SimpleButton;
      
      private var _btn2:SimpleButton;
      
      private var _btn3:SimpleButton;
      
      private var _btn4:SimpleButton;
      
      private var _btn5:SimpleButton;
      
      private var _btn6:SimpleButton;
      
      private var _btn7:SimpleButton;
      
      private var _btn8:SimpleButton;
      
      private var _btn9:SimpleButton;
      
      private var _btn0:SimpleButton;
      
      private var _btn00:SimpleButton;
      
      private var _btnMax:SimpleButton;
      
      private var _btnClear:SimpleButton;
      
      private var _nowMoneyTxt:TextField;
      
      private var _payMoneyTxt:TextField;
      
      private var _rankView:DonateRankView;
      
      private var _rankBtn:SimpleButton;
      
      public function DonateView(ui:MovieClip)
      {
         super(ui);
         this._closeBtn = _ui["close_btn"];
         this._okBtn = _ui["ok_btn"];
         this._btn1 = _ui["btn_1"];
         this._btn2 = _ui["btn_2"];
         this._btn3 = _ui["btn_3"];
         this._btn4 = _ui["btn_4"];
         this._btn5 = _ui["btn_5"];
         this._btn6 = _ui["btn_6"];
         this._btn7 = _ui["btn_7"];
         this._btn8 = _ui["btn_8"];
         this._btn9 = _ui["btn_9"];
         this._btn0 = _ui["btn_0"];
         this._btn00 = _ui["btn_00"];
         this._btnMax = _ui["btn_max"];
         this._btnClear = _ui["clear_btn"];
         this._nowMoneyTxt = _ui["nowMoney_txt"];
         this._payMoneyTxt = _ui["payMoney_txt"];
         this._payMoneyTxt.restrict = "0-9";
         this._payMoneyTxt.text = "";
         this._rankView = new DonateRankView(_ui["rank_mc"]);
         this._rankBtn = _ui["showRank_btn"];
      }
      
      override protected function Init() : void
      {
         super.Init();
         this._nowMoneyTxt.text = "目前你有現金：" + LocalUserInfo.getYXQ() + " 摩爾豆";
         BC.addEvent(this,this._okBtn,MouseEvent.CLICK,this.DonateMoney);
         BC.addEvent(this,this._rankBtn,MouseEvent.CLICK,this.ShowRankView);
         BC.addEvent(this,this._btn1,MouseEvent.CLICK,this.InputMoney);
         BC.addEvent(this,this._btn2,MouseEvent.CLICK,this.InputMoney);
         BC.addEvent(this,this._btn3,MouseEvent.CLICK,this.InputMoney);
         BC.addEvent(this,this._btn4,MouseEvent.CLICK,this.InputMoney);
         BC.addEvent(this,this._btn5,MouseEvent.CLICK,this.InputMoney);
         BC.addEvent(this,this._btn6,MouseEvent.CLICK,this.InputMoney);
         BC.addEvent(this,this._btn7,MouseEvent.CLICK,this.InputMoney);
         BC.addEvent(this,this._btn8,MouseEvent.CLICK,this.InputMoney);
         BC.addEvent(this,this._btn9,MouseEvent.CLICK,this.InputMoney);
         BC.addEvent(this,this._btn0,MouseEvent.CLICK,this.InputMoney);
         BC.addEvent(this,this._btn00,MouseEvent.CLICK,this.InputMoney);
         BC.addEvent(this,this._btnMax,MouseEvent.CLICK,this.InputMoney);
         BC.addEvent(this,this._btnClear,MouseEvent.CLICK,this.InputMoney);
      }
      
      private function ShowRankView(e:MouseEvent) : void
      {
         MainManager.getAppLevel().addChild(this._rankView.GetUI());
      }
      
      private function DonateMoney(e:MouseEvent) : void
      {
         var msg:String = null;
         var alert:* = undefined;
         var elaineMCUrl:String = "resource/allJob/AlertPic/elaine.swf";
         if(int(this._payMoneyTxt.text) == 0)
         {
            msg = "親愛的小摩爾，請至少捐一個摩爾豆哦！";
            Alert.showAlert(MainManager.getAppLevel(),elaineMCUrl,msg,Alert.CHANG_ALERT,"iknow",true,false,"SMCUI");
         }
         else
         {
            msg = "親愛的小摩爾，你確定要捐贈" + this._payMoneyTxt.text + "摩爾豆嗎？熱心公益是一種美德哦！";
            alert = Alert.showAlert(MainManager.getAppLevel(),elaineMCUrl,msg,Alert.CHANG_ALERT,"sure,notgo",true,false,"SMCUI");
            BC.addEvent(this,alert,"CLICK" + 1,this.DonateMoneyHandler);
         }
      }
      
      private function DonateMoneyHandler(e:Event) : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + ElainePartySocket.CharityOfferCommand,this.DonateMoneyOkHandler);
         ElainePartySocket.CharityOffer(0,int(this._payMoneyTxt.text));
         LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() - int(this._payMoneyTxt.text));
         this._payMoneyTxt.text = "";
      }
      
      private function DonateMoneyOkHandler(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + ElainePartySocket.CharityOfferCommand,this.DonateMoneyOkHandler);
         var elaineMCUrl:String = "resource/allJob/AlertPic/elaine.swf";
         var msg:String = "    非常感謝你為莊園慈善基金貢獻愛心哦！我們一定會把你的愛心傳遞給需要幫助的摩爾和拉姆！";
         Alert.showAlert(MainManager.getAppLevel(),elaineMCUrl,msg,Alert.CHANG_ALERT,"iknow",true,false,"SMCUI");
         this._nowMoneyTxt.text = "目前你有現金：" + LocalUserInfo.getYXQ() + " 摩爾豆";
      }
      
      private function InputMoney(e:MouseEvent) : void
      {
         var btn:SimpleButton = e.currentTarget as SimpleButton;
         switch(btn)
         {
            case this._btn1:
               this.AddMoney("1");
               break;
            case this._btn2:
               this.AddMoney("2");
               break;
            case this._btn3:
               this.AddMoney("3");
               break;
            case this._btn4:
               this.AddMoney("4");
               break;
            case this._btn5:
               this.AddMoney("5");
               break;
            case this._btn6:
               this.AddMoney("6");
               break;
            case this._btn7:
               this.AddMoney("7");
               break;
            case this._btn8:
               this.AddMoney("8");
               break;
            case this._btn9:
               this.AddMoney("9");
               break;
            case this._btn0:
               if(int(this._payMoneyTxt.text) > 0)
               {
                  this.AddMoney("0");
               }
               break;
            case this._btn00:
               if(int(this._payMoneyTxt.text) > 0)
               {
                  this.AddMoney("00");
               }
               break;
            case this._btnMax:
               this._payMoneyTxt.text = int(LocalUserInfo.getYXQ()).toString();
               break;
            case this._btnClear:
               this._payMoneyTxt.text = "";
         }
      }
      
      private function AddMoney(value:String) : void
      {
         if(int(this._payMoneyTxt.text + value) < LocalUserInfo.getYXQ())
         {
            this._payMoneyTxt.appendText(value);
         }
         else
         {
            this._payMoneyTxt.text = int(LocalUserInfo.getYXQ()).toString();
         }
      }
   }
}

