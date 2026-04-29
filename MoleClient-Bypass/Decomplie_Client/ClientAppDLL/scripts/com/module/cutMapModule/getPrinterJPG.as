package com.module.cutMapModule
{
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.socket.cupMap.cupMapReq;
   import com.logic.socket.cupMap.cupMapRes;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   
   public class getPrinterJPG extends EventDispatcher
   {
      
      public static var ON_SAVE_CANCEL:String = "ON_SAVE_CANCEL";
      
      public static var ON_SAVE_SUCCESS:String = "onSaveSuccess";
      
      public static var ON_SAVE_FAIL:String = "onSaveFail";
      
      public static var ON_CUTMAP_SUCCESS:String = "onSuccess";
      
      public static var ON_CUTMAP_CANCEL:String = "onCancel";
      
      private var cupMapClass:*;
      
      private var cutMapData:ByteArray;
      
      private var tipMC:MovieClip;
      
      private var loadingMC:MovieClip;
      
      private var Session:ByteArray;
      
      private var photoULR:String;
      
      private var ip:String;
      
      private var port:int;
      
      private var myClass:Class;
      
      private var cupMapOk:Boolean = false;
      
      public function getPrinterJPG()
      {
         super();
      }
      
      public function init() : void
      {
         SaveCutMap.G_addEventListener(SaveCutMap.ADDED_CLASS,this.showCutMapBox);
         SaveCutMap.GetClass();
      }
      
      public function getJPG(rec:*) : ByteArray
      {
         return this.myClass["getPhoto"](rec);
      }
      
      public function B2J(bitMapData:BitmapData) : ByteArray
      {
         return this.myClass["B2J"](bitMapData,50);
      }
      
      public function showCutMapBox(E:Event) : void
      {
         SaveCutMap.G_removeEventListener(SaveCutMap.ADDED_CLASS,this.showCutMapBox);
         this.myClass = SaveCutMap.getLibClass("printCut");
      }
      
      private function setmouseEnabled(bool:Boolean) : void
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
      
      public function saveLocal(jpg:*) : void
      {
         this.cupMapOk = true;
         this.getSaveInfo();
         this.cutMapData = jpg as ByteArray;
         dispatchEvent(new Event(ON_CUTMAP_SUCCESS));
      }
      
      private function onSuccess(E:Event) : void
      {
         this.cupMapOk = true;
         this.getSaveInfo();
         this.cutMapData = this.cupMapClass.cutMapData as ByteArray;
         dispatchEvent(new Event(ON_CUTMAP_SUCCESS));
      }
      
      private function onCancel(E:Event) : void
      {
         dispatchEvent(new Event(ON_CUTMAP_CANCEL));
         if(!this.cupMapOk)
         {
            this.clearClass();
         }
      }
      
      private function cancelFun(E:Event) : void
      {
         dispatchEvent(new Event(ON_SAVE_CANCEL));
         this.clearClass();
      }
      
      private function saveFun(E:Event) : void
      {
         this.tipMC.x = -1000;
         this.tipMC.y = -1000;
         SaveCutMap.FileReference_download(this.photoULR,"摩爾塗鴉_" + new Date().valueOf() + ".jpg");
         SaveCutMap.G_addEventListener(SaveCutMap.DOWN_IO_ERROR,this.onDownError);
         SaveCutMap.G_addEventListener(SaveCutMap.DOWN_CANCEL,this.onDownCancel);
         SaveCutMap.G_addEventListener(SaveCutMap.DOWN_COMPLETE,this.onDownComplete);
      }
      
      private function onDownError(E:EventTaomee) : void
      {
         SaveCutMap.G_removeEventListener(SaveCutMap.DOWN_IO_ERROR,this.onDownError);
         SaveCutMap.G_removeEventListener(SaveCutMap.DOWN_CANCEL,this.onDownCancel);
         SaveCutMap.G_removeEventListener(SaveCutMap.DOWN_COMPLETE,this.onDownComplete);
         dispatchEvent(new Event(ON_SAVE_FAIL));
         GC.setGTimeout(this.clearClass,1000);
      }
      
      private function onDownCancel(E:EventTaomee = null) : void
      {
         SaveCutMap.G_removeEventListener(SaveCutMap.DOWN_IO_ERROR,this.onDownError);
         SaveCutMap.G_removeEventListener(SaveCutMap.DOWN_CANCEL,this.onDownCancel);
         SaveCutMap.G_removeEventListener(SaveCutMap.DOWN_COMPLETE,this.onDownComplete);
         dispatchEvent(new Event(ON_SAVE_FAIL));
         this.clearClass();
      }
      
      private function onDownComplete(E:EventTaomee = null) : void
      {
         SaveCutMap.G_removeEventListener(SaveCutMap.DOWN_IO_ERROR,this.onDownError);
         SaveCutMap.G_removeEventListener(SaveCutMap.DOWN_CANCEL,this.onDownCancel);
         SaveCutMap.G_removeEventListener(SaveCutMap.DOWN_COMPLETE,this.onDownComplete);
         dispatchEvent(new Event(ON_SAVE_SUCCESS));
         this.clearClass();
      }
      
      private function getSaveInfo() : void
      {
         BC.addEvent(this,GV.onlineSocket,cupMapRes.GET_SESSION,this.getSaveInfoHandler);
         cupMapReq.getSession();
      }
      
      private function getSaveInfoHandler(E:EventTaomee) : void
      {
         this.Session = E.EventObj.Session as ByteArray;
         this.ip = E.EventObj.Ip;
         this.port = E.EventObj.Port;
         this.checkUpLoad();
      }
      
      private function checkUpLoad() : void
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
      
      private function getLinskURL(E:EventTaomee) : void
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
      
      private function upLoadError(E:EventTaomee) : void
      {
         this.clearClass();
      }
      
      private function clearClass() : void
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
            this.cutMapData = null;
         }
      }
   }
}

