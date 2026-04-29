package com.view.mapView.activity.mapActivity.elaineParty
{
   import com.event.EventTaomee;
   import com.logic.loadUserInfoList.LoaderUserInfoList;
   import com.logic.loadUserInfoList.UserInfoLoader;
   import com.logic.socket.elaineParty.ElainePartySocket;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class DonateRankView extends BasePartyView
   {
      
      private var _cancelBtn:SimpleButton;
      
      private var _userList:Array;
      
      private var _userListInfoLoader:LoaderUserInfoList;
      
      public function DonateRankView(ui:MovieClip)
      {
         super(ui);
         this._closeBtn = _ui["close_btn"];
         this._cancelBtn = _ui["cancel_btn"];
      }
      
      override protected function Init() : void
      {
         var txt:TextField = null;
         super.Init();
         this._ui.x = 202;
         this._ui.y = 68;
         for(var i:int = 1; i <= 10; i++)
         {
            txt = _ui["num_" + i];
            txt.text = "";
         }
         BC.addEvent(this,this._cancelBtn,MouseEvent.CLICK,CloseBtnHandler);
         BC.addEvent(this,GV.onlineSocket,"read_" + ElainePartySocket.CharityDonateRankingCommand,this.GetRankOk);
         ElainePartySocket.CheckCharityDonateRanking(ElainePartySocket.Rank_Type_Donate);
      }
      
      private function GetRankOk(e:EventTaomee) : void
      {
         var obj:Object = e.EventObj;
         this._userList = obj.userArr;
         this._userListInfoLoader = new LoaderUserInfoList();
         BC.addEvent(this,this._userListInfoLoader,LoaderUserInfoList.LOAD_USER_LIST_OVER,this.OnAllUserInfoLoaded);
         this._userListInfoLoader.LoadUserList(this._userList);
      }
      
      private function OnAllUserInfoLoaded(e:Event) : void
      {
         var txt:TextField = null;
         var userInfo:UserInfoLoader = null;
         for(var i:int = 1; i <= 10; i++)
         {
            txt = _ui["num_" + i];
            txt.text = "";
            if(Boolean(this._userListInfoLoader.userInfoList[i - 1]))
            {
               userInfo = this._userListInfoLoader.userInfoList[i - 1];
               txt.text = userInfo.name + "  " + String(userInfo.id).slice(0,4) + "***";
            }
         }
      }
   }
}

