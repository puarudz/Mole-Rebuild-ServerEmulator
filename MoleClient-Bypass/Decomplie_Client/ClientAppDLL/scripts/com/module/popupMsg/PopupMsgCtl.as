package com.module.popupMsg
{
   import com.common.util.Tick;
   import com.core.info.LocalUserInfo;
   import com.core.manager.IndexManager;
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import com.logic.socket.textNotice.TextNoticeRes;
   import com.module.magicSpirit.MagicSpiritManager;
   import com.mole.app.info.MoleActionInfo;
   import com.mole.app.manager.MoleActionManager;
   import com.mole.app.map.MapManager;
   import com.mole.app.type.ActionType;
   import com.mole.app.utils.PlayMovie;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   
   public class PopupMsgCtl
   {
      
      private static var _popup:PopupMsgCtl;
      
      private var _mc:Sprite;
      
      private var _infoList:Array;
      
      private var _curInfo:Object;
      
      private var _startTime:Number;
      
      private var _isShow:Boolean;
      
      private var info999:String = "";
      
      private var overlg:int = 0;
      
      private var alllg:int = 2;
      
      public function PopupMsgCtl()
      {
         super();
         this._mc = IndexManager.getInstance().getMovieClip("speakMsg");
         this._mc.x = 225;
         this._mc.y = 40;
         this._mc.visible = false;
         this._mc["execute_btn"].addEventListener(MouseEvent.CLICK,this.onExecute);
         LevelManager.dialogLevel.addChild(this._mc);
         this._infoList = new Array();
         this._isShow = false;
      }
      
      public static function PopupMsg(str:String, showDelay:int = 3000, waitToShowDelay:int = 0, cmdType:uint = 0) : void
      {
         if(_popup == null)
         {
            _popup = new PopupMsgCtl();
         }
         var cmdInfo:MoleActionInfo = new MoleActionInfo();
         switch(cmdType)
         {
            case 10:
               cmdInfo.cmd = ActionType.GO_MAP;
               cmdInfo.param = 47;
               break;
            case 15:
               if(LocalUserInfo.getMapID() == 399)
               {
                  if(!MagicSpiritManager.getInstance().isFight)
                  {
                     MapManager.enterMap(396);
                  }
               }
               break;
            default:
               cmdInfo = null;
         }
         _popup.addInfo(str,showDelay,waitToShowDelay,cmdInfo);
      }
      
      public static function ShowMapNameEffect(mapEffectName:String) : void
      {
         var url:String = "resource/map/mapNameEffect/" + mapEffectName + ".swf";
         PlayMovie.play(url);
      }
      
      public static function setup() : void
      {
         GV.onlineSocket.addEventListener(TextNoticeRes.TEXT_INFO_BROADCAST,onTextInfoBroadcast);
      }
      
      private static function onTextInfoBroadcast(e:EventTaomee) : void
      {
         var msg:String = e.EventObj.msyInfo;
         var cmdType:uint = uint(e.EventObj.Type);
         if(e.EventObj.Pic != null)
         {
            if(e.EventObj.Pic == 999)
            {
               PopupMsg999(msg,20000,0,cmdType);
               return;
            }
         }
         PopupMsg(msg,3000,0,cmdType);
      }
      
      private static function PopupMsg999(str:String, showDelay:int = 1000, waitToShowDelay:int = 0, cmdType:int = 999) : void
      {
         if(_popup == null)
         {
            _popup = new PopupMsgCtl();
         }
         _popup.info999 = str;
         _popup.overlg = 0;
         _popup.alllg = 2;
         Tick.instance.addCallback(_popup.onShowPopup999);
      }
      
      private function onShowPopup(delay:Number) : void
      {
         var curTime:Number = NaN;
         if(this._isShow)
         {
            curTime = getTimer() - this._startTime;
            if(curTime > this._curInfo.showDelay)
            {
               this._isShow = false;
            }
            else if(curTime > this._curInfo.waitDelay && this._mc.visible == false)
            {
               this._mc.visible = true;
               this._mc["msgTxt"].text = this._curInfo.msg;
            }
         }
         else
         {
            this._mc.visible = false;
            if(this._infoList.length == 0)
            {
               Tick.instance.removeCallback(this.onShowPopup);
            }
            else
            {
               this._startTime = getTimer();
               this._curInfo = this._infoList.shift();
               if(Boolean(this._curInfo.data))
               {
                  this._mc["execute_btn"].visible = true;
               }
               else
               {
                  this._mc["execute_btn"].visible = false;
               }
               this._isShow = true;
            }
         }
      }
      
      private function onExecute(e:MouseEvent) : void
      {
         this._mc["execute_btn"].mouseEnabled = false;
         if(Boolean(this._curInfo) && Boolean(this._curInfo.data))
         {
            MoleActionManager.doAction(this._curInfo.data);
         }
      }
      
      public function addInfo(msg:String, showDelay:Number, waitDelay:Number, data:MoleActionInfo) : void
      {
         var info:Object = new Object();
         info.msg = msg;
         info.showDelay = showDelay + waitDelay;
         info.waitDelay = waitDelay;
         info.data = data;
         this._infoList.unshift(info);
         Tick.instance.addCallback(this.onShowPopup);
      }
      
      private function onShowPopup999(delay:Number) : void
      {
         var str:String = this.info999;
         if(str == "")
         {
            Tick.instance.removeCallback(this.onShowPopup999);
            return;
         }
         var p:int = int(this.overlg / 10);
         if(p >= str.length)
         {
            if(this.alllg <= 0)
            {
               this._mc.visible = false;
               Tick.instance.removeCallback(this.onShowPopup999);
               this._isShow = false;
               return;
            }
            --this.alllg;
            this.overlg = 0;
            p = 0;
         }
         if(p < str.length)
         {
            if(this.overlg == 0 && this.alllg == 3)
            {
               this._startTime = getTimer();
               this._curInfo = new Object();
               this._curInfo.msg = str;
               this._curInfo.showDelay = str.length * 1000 * this.alllg + 3000;
               this._curInfo.waitDelay = 3000;
               this._curInfo.data = null;
            }
            this._isShow = true;
            this._mc.visible = true;
            this._mc["execute_btn"].visible = false;
            this._mc["msgTxt"].text = str.substr(p,p + 25);
            ++this.overlg;
         }
      }
   }
}

