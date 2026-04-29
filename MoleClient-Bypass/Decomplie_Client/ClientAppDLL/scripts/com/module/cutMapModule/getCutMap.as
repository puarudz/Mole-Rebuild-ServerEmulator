package com.module.cutMapModule
{
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.socket.cupMap.cupMapReq;
   import com.logic.socket.cupMap.cupMapRes;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   
   public class getCutMap extends EventDispatcher
   {
      
      public static var ON_SAVE_SUCCESS:String = "onSaveSuccess";
      
      public static var ON_SAVE_FAIL:String = "onSaveFail";
      
      public static var ON_CUTMAP_SUCCESS:String = "onSuccess";
      
      public static var ON_CUTMAP_CANCEL:String = "onCancel";
      
      protected var cupMapClass:*;
      
      protected var cutMapData:ByteArray;
      
      protected var tipMC:MovieClip;
      
      protected var loadingMC:MovieClip;
      
      protected var Session:ByteArray;
      
      protected var photoULR:String;
      
      protected var ip:String;
      
      protected var port:int;
      
      protected var cupMapOk:Boolean = false;
      
      public function getCutMap()
      {
         super();
      }
      
      public function init() : void
      {
         SaveCutMap.G_addEventListener(SaveCutMap.ADDED_CLASS,this.showCutMapBox);
         SaveCutMap.GetClass();
      }
      
      protected function showCutMapBox(E:Event) : void
      {
         SaveCutMap.G_removeEventListener(SaveCutMap.ADDED_CLASS,this.showCutMapBox);
         var myClass:* = SaveCutMap.getLibClass("CutMap");
         this.cupMapClass = new myClass();
         BC.addEvent(this,this.cupMapClass,Event.COMPLETE,this.onSuccess);
         BC.addEvent(this,this.cupMapClass,Event.CLOSE,this.onCancel);
         MainManager.getRootMC().addChild(this.cupMapClass);
         this.setmouseEnabled(false);
         MoveTo.CanMove = false;
      }
      
      protected function setmouseEnabled(bool:Boolean) : void
      {
         GV.MC_ToolView.mouseChildren = bool;
         GV.MC_ToolView.mouseEnabled = bool;
         GV.MC_TopLever.mouseChildren = bool;
         GV.MC_TopLever.mouseEnabled = bool;
         GV.MC_AppLever.mouseChildren = bool;
         GV.MC_AppLever.mouseEnabled = bool;
         GV.MC_mapFrame.mouseChildren = bool;
         GV.MC_mapFrame.mouseEnabled = bool;
      }
      
      protected function onSuccess(E:Event) : void
      {
         this.cupMapOk = true;
         this.getSaveInfo();
         this.cutMapData = this.cupMapClass.cutMapData as ByteArray;
         var tempClass:* = SaveCutMap.getLibClass("Loading_mc");
         this.loadingMC = new tempClass() as MovieClip;
         this.loadingMC.x = 960 / 2;
         this.loadingMC.y = 560 / 2;
         this.loadingMC.gotoAndPlay(2);
         MainManager.getRootMC().addChild(this.loadingMC);
         dispatchEvent(new Event(ON_CUTMAP_SUCCESS));
      }
      
      protected function onCancel(E:Event) : void
      {
         dispatchEvent(new Event(ON_CUTMAP_CANCEL));
         if(!this.cupMapOk)
         {
            this.clearClass();
         }
      }
      
      protected function cancelFun(E:Event) : void
      {
         this.clearClass();
      }
      
      protected function saveFun(E:Event) : void
      {
         this.tipMC.x = -1000;
         this.tipMC.y = -1000;
         SaveCutMap.FileReference_download(this.photoULR,"摩爾拍照_" + new Date().valueOf() + ".jpg");
         SaveCutMap.G_addEventListener(SaveCutMap.DOWN_IO_ERROR,this.onDownError);
         SaveCutMap.G_addEventListener(SaveCutMap.DOWN_CANCEL,this.onDownCancel);
         SaveCutMap.G_addEventListener(SaveCutMap.DOWN_COMPLETE,this.onDownComplete);
      }
      
      protected function onDownError(E:EventTaomee) : void
      {
         this.loadingMC.gotoAndStop("onFail");
         SaveCutMap.G_removeEventListener(SaveCutMap.DOWN_IO_ERROR,this.onDownError);
         SaveCutMap.G_removeEventListener(SaveCutMap.DOWN_CANCEL,this.onDownCancel);
         SaveCutMap.G_removeEventListener(SaveCutMap.DOWN_COMPLETE,this.onDownComplete);
         dispatchEvent(new Event(ON_SAVE_FAIL));
         GC.setGTimeout(this.clearClass,1000);
      }
      
      protected function onDownCancel(E:EventTaomee = null) : void
      {
         SaveCutMap.G_removeEventListener(SaveCutMap.DOWN_IO_ERROR,this.onDownError);
         SaveCutMap.G_removeEventListener(SaveCutMap.DOWN_CANCEL,this.onDownCancel);
         SaveCutMap.G_removeEventListener(SaveCutMap.DOWN_COMPLETE,this.onDownComplete);
         dispatchEvent(new Event(ON_SAVE_FAIL));
         this.clearClass();
      }
      
      protected function onDownComplete(E:EventTaomee = null) : void
      {
         SaveCutMap.G_removeEventListener(SaveCutMap.DOWN_IO_ERROR,this.onDownError);
         SaveCutMap.G_removeEventListener(SaveCutMap.DOWN_CANCEL,this.onDownCancel);
         SaveCutMap.G_removeEventListener(SaveCutMap.DOWN_COMPLETE,this.onDownComplete);
         dispatchEvent(new Event(ON_SAVE_SUCCESS));
         this.clearClass();
      }
      
      protected function getSaveInfo() : void
      {
         BC.addEvent(this,GV.onlineSocket,cupMapRes.GET_SESSION,this.getSaveInfoHandler);
         cupMapReq.getSession();
      }
      
      protected function getSaveInfoHandler(E:EventTaomee) : void
      {
         this.Session = E.EventObj.Session as ByteArray;
         this.ip = E.EventObj.Ip;
         this.port = E.EventObj.Port;
         this.checkUpLoad();
      }
      
      protected function checkUpLoad() : void
      {
         var _data:ByteArray = null;
         var uploadphoto:upLoadCutMap = null;
         if(Boolean(this.cutMapData) && Boolean(this.Session))
         {
            _data = new ByteArray();
            _data.writeBytes(this.Session,0);
            _data.writeBytes(this.cutMapData,0);
            uploadphoto = new upLoadCutMap(_data,this.ip,this.port);
            BC.addEvent(this,uploadphoto,upLoadCutMap.onSuc,this.getLinskURL);
            BC.addEvent(this,uploadphoto,upLoadCutMap.onFail,this.upLoadError);
         }
      }
      
      protected function getLinskURL(E:EventTaomee) : void
      {
         var link:String = E.EventObj as String;
         this.photoULR = link;
         var tempClass:* = SaveCutMap.getLibClass("saveTip_mc");
         this.tipMC = new tempClass() as MovieClip;
         this.tipMC.x = 960 / 2;
         this.tipMC.y = 560 / 2;
         BC.addEvent(this,this.tipMC.cancel_btn,MouseEvent.CLICK,this.cancelFun);
         BC.addEvent(this,this.tipMC.sure_btn,MouseEvent.CLICK,this.saveFun);
         MainManager.getRootMC().addChild(this.tipMC);
      }
      
      protected function upLoadError(E:EventTaomee) : void
      {
         this.clearClass();
      }
      
      protected function clearClass() : void
      {
         BC.removeEvent(this);
         this.setmouseEnabled(true);
         MoveTo.CanMove = true;
         if(Boolean(this.cutMapData))
         {
            if(Boolean(this.tipMC) && Boolean(this.tipMC.parent))
            {
               this.tipMC.parent.removeChild(this.tipMC);
            }
            this.tipMC = null;
            if(Boolean(this.cupMapClass) && Boolean(this.cupMapClass.parent))
            {
               this.cupMapClass.parent.removeChild(this.cupMapClass);
            }
            this.cupMapClass = null;
            if(Boolean(this.loadingMC) && Boolean(this.loadingMC.parent))
            {
               this.loadingMC.gotoAndStop(1);
               this.loadingMC.parent.removeChild(this.loadingMC);
               this.loadingMC = null;
            }
            this.cutMapData = null;
         }
      }
   }
}

