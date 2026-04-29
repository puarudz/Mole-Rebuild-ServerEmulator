package com.view.noticeView
{
   import com.core.MainManager;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.global.links.Links;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.socket.postCard.*;
   import com.module.friendList.friendView.FView;
   import com.module.present.PresentManager;
   import com.view.toolView.toolView;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class postcardLogic extends MovieClip
   {
      
      public static var ID_Arr:Array;
      
      public static var ALLCARDSID:String = "allCards_ID_arr";
      
      public static var NEWCARDSNUM:String = "newCards_num";
      
      public static var NOWCARDINFO:String = "nowCards_info";
      
      public static var DELCARDSUCCESS:String = "delCard_success";
      
      public static var DELALLCARDSUCCESS:String = "delAllCard_success";
      
      public static var SANDCARDBACK:String = "sandCard_backInfo";
      
      public static var FRIENDSLIST:String = "Card_backfriend_List";
      
      public static var ONLYUNREADNUM:String = "only_unread_num";
      
      public static var ISmove:uint = 0;
      
      public static var open_Flag:uint = 0;
      
      private var AllCard_type:uint = 0;
      
      public function postcardLogic()
      {
         super();
      }
      
      public static function setOpen_Flag(flag:uint) : void
      {
         open_Flag = flag;
      }
      
      public static function setIDArr(a:*) : void
      {
         ID_Arr = [];
         if(Boolean(a as Array))
         {
            ID_Arr = a;
         }
         else
         {
            ID_Arr.push(a);
         }
      }
      
      public static function getOpen_Flag() : uint
      {
         return open_Flag;
      }
      
      public static function getIDArr() : Array
      {
         return ID_Arr;
      }
      
      public function sandOneCardFun(CardID:uint, Msg:String, FriendArr:Array) : void
      {
         GV.onlineSocket.addEventListener(sandOneCardRes.SANDONECARD_INFO,this.sandBackFun);
         sandOneCardReq.Info(CardID,Msg,FriendArr);
      }
      
      private function sandBackFun(event:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(sandOneCardRes.SANDONECARD_INFO,this.sandBackFun);
         var obj:Object = event.EventObj.info;
         GV.onlineSocket.dispatchEvent(new EventTaomee(SANDCARDBACK,obj));
      }
      
      public function delOneCardFun(CardID:uint) : void
      {
         GV.onlineSocket.addEventListener(delOneCardRes.DELONECARD_INFO,this.delBackFun);
         delOneCardReq.Info(CardID);
      }
      
      private function delBackFun(event:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(delOneCardRes.DELONECARD_INFO,this.delBackFun);
         GV.onlineSocket.dispatchEvent(new EventTaomee(DELCARDSUCCESS));
      }
      
      public function delAllCardFun() : void
      {
         GV.onlineSocket.addEventListener(delAllCardRes.DELONECARD_INFO,this.delAllBackFun);
         delAllCardReq.Info();
      }
      
      private function delAllBackFun(event:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(delAllCardRes.DELONECARD_INFO,this.delAllBackFun);
         GV.onlineSocket.dispatchEvent(new EventTaomee(DELALLCARDSUCCESS));
      }
      
      public function getOneCardFun(CardID:uint) : void
      {
         GV.onlineSocket.addEventListener(getOneCardRes.GETBACKONECARD_INFO,this.backOneCardFun);
         getOneCardReq.Info(CardID);
      }
      
      private function backOneCardFun(event:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(getOneCardRes.GETBACKONECARD_INFO,this.backOneCardFun);
         var obj:Object = {"info":event.EventObj.arr};
         GV.onlineSocket.dispatchEvent(new EventTaomee(NOWCARDINFO,obj));
      }
      
      public function getOnlyNum() : void
      {
         GV.onlineSocket.addEventListener(getOnlyNumRes.ONLY_NUM,this.backOnlyNum);
         getOnlyNumReq.Info();
      }
      
      private function backOnlyNum(event:EventTaomee) : void
      {
         var obj:Object = new Object();
         obj.num = event.EventObj.Num;
         GV.onlineSocket.dispatchEvent(new EventTaomee(ONLYUNREADNUM,obj));
      }
      
      public function getAllCardFun(type:uint = 0) : void
      {
         this.AllCard_type = type;
         GV.onlineSocket.addEventListener(getAllCardRes.GETBACKALLCARD_INFO,this.backAllCardFun);
         getAllCardReq.Info();
      }
      
      private function backAllCardFun(event:EventTaomee) : void
      {
         var obj:Object = null;
         var info:Object = null;
         GV.onlineSocket.removeEventListener(getAllCardRes.GETBACKALLCARD_INFO,this.backAllCardFun);
         if(this.AllCard_type == 0)
         {
            if(event.EventObj.obj.TotalCnt > 0)
            {
               obj = {"num":event.EventObj.obj.UnreadCnt};
            }
            else
            {
               obj = {"num":0};
            }
            info = {"obj":event.EventObj.obj};
            GV.onlineSocket.dispatchEvent(new EventTaomee(ALLCARDSID,info));
            GV.onlineSocket.dispatchEvent(new EventTaomee(NEWCARDSNUM,obj));
         }
         else
         {
            info = {"obj":event.EventObj.obj};
            GV.onlineSocket.dispatchEvent(new EventTaomee(ALLCARDSID,info));
         }
      }
      
      public function getFriendInfo() : void
      {
         if(Boolean(MainManager.getAppLevel().getChildByName("friendMC")))
         {
            this.FriendInfo();
         }
         else
         {
            GV.onlineClass.addEventListener("post_card_fview",this.FriendInfo);
            PresentManager.showFriendPanelBool = false;
            toolView.getInstance().showFriend();
         }
      }
      
      private function FriendInfo(event:Event = null) : void
      {
         var add_obj:Object = null;
         PresentManager.showFriendPanelBool = true;
         var obj:Object = {};
         obj.arr = new Array();
         var Arr:Array = FView.arrMC;
         for(var i:uint = 0; i < Arr.length; i++)
         {
            if(Arr[i].id == 1)
            {
               break;
            }
            add_obj = {};
            add_obj.UserID = Arr[i].id;
            add_obj.Color = Arr[i].Color;
            add_obj.Nick = Arr[i].userName.text;
            add_obj.Vip = Arr[i].vip;
            if(Boolean(Arr[i].online))
            {
               add_obj.Status = 1;
            }
            else
            {
               add_obj.Status = 3;
            }
            obj.arr.push(add_obj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(FRIENDSLIST,obj));
      }
      
      public function removeEventFriend() : void
      {
         GV.onlineClass.removeEventListener("post_card_fview",this.FriendInfo);
      }
      
      public function addCardUI() : void
      {
         ISmove = 0;
         var cardUI_mc:MovieClip = new MovieClip();
         cardUI_mc.name = "cardUI_mc";
         MainManager.getAppLevel().addChild(cardUI_mc);
         var url:String = "module/external/PostCardModule.swf";
         var tempMC:MCLoader = new MCLoader(Links.getUrl(url,false,Links.moduleversion),cardUI_mc,1,"正在打開明信片");
         tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadBookOverHandler);
         tempMC.doLoad();
         GV.onlineSocket.addEventListener("remove_CardMC_event",this.removeCardMCFun);
      }
      
      private function loadBookOverHandler(evt:MCLoadEvent) : void
      {
         var mcloader:MCLoader = evt.target as MCLoader;
         mcloader.removeEventListener(MCLoadEvent.ON_SUCCESS,this.loadBookOverHandler);
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:* = evt.getLoader();
         mainMC.addChild(childMC);
         mainMC.x = 0;
         mainMC.y = 0;
         if(!MoveTo.CanMove)
         {
            ISmove = 100;
         }
         else
         {
            MoveTo.CanMove = false;
         }
         mcloader.clear();
      }
      
      private function removeCardMCFun(event:EventTaomee) : void
      {
         var pi:* = undefined;
         var temp:* = MainManager.getAppLevel().getChildByName("cardUI_mc");
         if(Boolean(temp))
         {
            GV.onlineSocket.removeEventListener("remove_CardMC_event",this.removeCardMCFun);
            GC.stopAllMC(temp);
            GC.clearAllChildren(temp);
            MainManager.getAppLevel().removeChild(temp);
            temp = null;
            if(ISmove == 0)
            {
               MoveTo.CanMove = true;
            }
            pi = GV.JobLogics.findJobTaskStatus(24);
            if(pi == 1)
            {
               GV.onlineSocket.dispatchEvent(new EventTaomee("close_mailView"));
            }
         }
      }
   }
}

