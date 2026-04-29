package com.module.lahmClassRoom
{
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.loading.Loading;
   import com.core.newloader.LoaderList;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.logic.socket.finishSomething.finishedSomethingReq;
   import com.logic.socket.finishSomething.finishedSomethingRes;
   import flash.display.MovieClip;
   
   public class GetClassrootGift
   {
      
      private static var _instance:GetClassrootGift;
      
      private static const PULA_TYPE:int = 37;
      
      private static const CHAOLA_TYPE:int = 36;
      
      private static const LEVEL_20_EXP:int = 12300;
      
      private static const PATH:String = "resource/movie/ClassroomGift";
      
      private var _type:int;
      
      private var _getedGift:int = 0;
      
      public function GetClassrootGift()
      {
         super();
      }
      
      public static function GetInstance() : GetClassrootGift
      {
         if(_instance == null)
         {
            _instance = new GetClassrootGift();
         }
         return _instance;
      }
      
      public function GetGift() : void
      {
         if(lahmClassRoomBeen.getInstance().getLahmClassRoomInfo().classRoomUserId == LocalUserInfo.getUserID())
         {
            if(this._getedGift == 0)
            {
               if(lahmClassRoomBeen.getInstance().getLahmClassRoomInfo().exp < LEVEL_20_EXP)
               {
                  BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.CheckHasGift);
                  if(LocalUserInfo.isVIP())
                  {
                     this._type = CHAOLA_TYPE;
                  }
                  else
                  {
                     this._type = PULA_TYPE;
                  }
                  finishSomethingReq.sendReq(this._type);
               }
            }
         }
      }
      
      private function CheckHasGift(e:EventTaomee) : void
      {
         if(e.EventObj.Type == this._type)
         {
            BC.removeEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.CheckHasGift);
            this._getedGift = 1;
            if(e.EventObj.Done == 0)
            {
               BC.addEvent(this,GV.onlineSocket,finishedSomethingRes.FINISHED_SOMETHING_SUCC,this.GetGiftOver);
               finishedSomethingReq.sendReq(this._type);
            }
         }
      }
      
      private function GetGiftOver(e:EventTaomee) : void
      {
         var path:String = null;
         var loader:MCLoader = null;
         if(e.EventObj.type == this._type)
         {
            BC.removeEvent(this,GV.onlineSocket,finishedSomethingRes.FINISHED_SOMETHING_SUCC,this.GetGiftOver);
            if(e.EventObj.count == 0)
            {
               return;
            }
            if(this._type == PULA_TYPE)
            {
               path = PATH + "PL.swf";
            }
            else
            {
               path = PATH + "CL.swf";
            }
            loader = new MCLoader(path,MainManager.getBaseLevel(),Loading.TITLE_AND_PERCENT,"正在加載...");
            loader.addEventListener(MCLoadEvent.ON_SUCCESS,this.UILoadOverHandler);
            LoaderList.getInstance().addItem(loader,null,LoaderList.HIGH);
         }
      }
      
      private function UILoadOverHandler(e:MCLoadEvent) : void
      {
         e.getLoader().removeEventListener(MCLoadEvent.ON_SUCCESS,this.UILoadOverHandler);
         var mv:MovieClip = e.getLoader().content as MovieClip;
         MCLoader(e.currentTarget).clear();
         MainManager.getAppLevel().addChild(mv);
      }
   }
}

