package com.module.cutMapModule
{
   import com.common.util.DisplayUtil;
   import com.core.MainManager;
   import com.core.loading.Loading;
   import com.core.newloader.MCLoader;
   import com.core.stringPop.Pop;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.global.links.Links;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.socket.cupMap.cupMapReq;
   import com.logic.socket.cupMap.cupMapRes;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.net.FileReference;
   import flash.net.URLRequest;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class SaveCutMap extends EventDispatcher
   {
      
      private static var file:FileReference;
      
      public static var PhotographClass:Class;
      
      public static var cutMapClass:Class;
      
      public static var PicViewClass:Class;
      
      public static var LoaderMC:Loader;
      
      private static var tempClass:*;
      
      public static var myEventDispatcher:EventDispatcher = new EventDispatcher();
      
      public static var G_dispatchEvent:Function = myEventDispatcher.dispatchEvent;
      
      public static var G_addEventListener:Function = myEventDispatcher.addEventListener;
      
      public static var G_removeEventListener:Function = myEventDispatcher.removeEventListener;
      
      public static var cutMapArray:Array = new Array();
      
      public static var isUseCamera:Boolean = false;
      
      public static var busy:Boolean = false;
      
      public static var ADDED_CLASS:String = "Added_Class";
      
      public static var DOWN_IO_ERROR:String = "DOWN_IO_ERROR";
      
      public static var DOWN_COMPLETE:String = "DOWN_COMPLETE";
      
      public static var DOWN_CANCEL:String = "DOWN_CANCEL";
      
      public static var CAMERA_OPEN:String = "Camera_Open";
      
      public static var CAMERA_CLOSE:String = "Camera_Close";
      
      public static var CAMERA_COMPLETE:String = "Camera_Complete";
      
      public static var GET_CAMERA_CLASS:String = "getCameraClass";
      
      public var txt:TextField;
      
      private var Session:ByteArray;
      
      private var ip:String = "";
      
      private var port:uint = 0;
      
      private var CutMapSprit:*;
      
      private var cutMapData:ByteArray;
      
      public function SaveCutMap()
      {
         super();
         this.getCutMapData();
         this.getSaveInfo();
         busy = true;
      }
      
      public static function GetCamera() : void
      {
         var PhotographClass:* = undefined;
         isUseCamera = true;
         if(!SaveCutMap.GetClass())
         {
            PhotographClass = SaveCutMap.getLibClass("Photograph");
            tempClass = new PhotographClass();
            tempClass.addEventListener(Event.OPEN,CameraOpen);
            tempClass.addEventListener(Event.CLOSE,CameraClose);
            GV.MC_AppLever.parent.addChild(tempClass);
            SaveCutMap.G_dispatchEvent(new EventTaomee(GET_CAMERA_CLASS,tempClass));
         }
         else
         {
            SaveCutMap.G_addEventListener(ADDED_CLASS,function(E:*):void
            {
               SaveCutMap.G_removeEventListener(ADDED_CLASS,arguments.callee);
               PhotographClass = getLibClass("Photograph");
               tempClass = new PhotographClass();
               tempClass.addEventListener(Event.OPEN,CameraOpen);
               tempClass.addEventListener(Event.CLOSE,CameraClose);
               tempClass.addEventListener(Event.COMPLETE,CameraComplete);
               GV.MC_AppLever.parent.addChild(tempClass);
               SaveCutMap.G_dispatchEvent(new EventTaomee(GET_CAMERA_CLASS,tempClass));
            });
         }
      }
      
      public static function closeCamera() : void
      {
         if(Boolean(tempClass))
         {
            tempClass.clearClass();
            DisplayUtil.removeForParent(tempClass);
            CameraClose();
         }
      }
      
      private static function CameraComplete(E:Event) : void
      {
         G_dispatchEvent(new Event(CAMERA_COMPLETE));
      }
      
      private static function CameraOpen(E:Event) : void
      {
         var stopMoveMC:PeopleManageView = null;
         MoveTo.CanMove = false;
         var taskMC:Sprite = MainManager.getToolLevel().getChildByName("notice_mc") as Sprite;
         taskMC.visible = false;
         GV.MC_ToolView.visible = false;
         try
         {
            setmouseEnabled(false);
            stopMoveMC = GV.MAN_PEOPLE as PeopleManageView;
            stopMoveMC.DelRotation();
         }
         catch(E:*)
         {
         }
         G_dispatchEvent(new Event(CAMERA_OPEN));
      }
      
      private static function CameraClose(E:Event = null) : void
      {
         var stopMoveMC:PeopleManageView = null;
         MoveTo.CanMove = true;
         var taskMC:Sprite = MainManager.getToolLevel().getChildByName("notice_mc") as Sprite;
         taskMC.visible = true;
         GV.MC_ToolView.visible = true;
         try
         {
            setmouseEnabled(true);
            stopMoveMC = GV.MAN_PEOPLE as PeopleManageView;
            stopMoveMC.addRotation();
         }
         catch(E:*)
         {
         }
         G_dispatchEvent(new Event(CAMERA_CLOSE));
         isUseCamera = false;
      }
      
      public static function GetClass() : MCLoader
      {
         var infoClass:MCLoader = null;
         if(!cutMapClass)
         {
            infoClass = new MCLoader("module/cutMapView/MycutMap.swf",GV.MC_AppLever,Loading.TITLE_AND_PERCENT,"正在初始化截圖程序.");
            infoClass.addEventListener(MCLoadEvent.ON_SUCCESS,loadcutMapViewHandler2);
            infoClass.addEventListener(MCLoadEvent.ERROR,loadcutMapViewError2);
            infoClass.doLoad();
            return infoClass;
         }
         G_dispatchEvent(new Event(ADDED_CLASS));
         return null;
      }
      
      private static function loadcutMapViewHandler2(evt:MCLoadEvent) : void
      {
         evt.target.removeEventListener(MCLoadEvent.ON_SUCCESS,loadcutMapViewHandler2);
         var childMC:Loader = evt.getLoader();
         LoaderMC = childMC;
         PhotographClass = getLibClass("Photograph");
         cutMapClass = getLibClass("CutMap");
         PicViewClass = getLibClass("PicView");
         G_dispatchEvent(new Event(ADDED_CLASS));
      }
      
      private static function loadcutMapViewError2(evt:MCLoadEvent) : void
      {
         isUseCamera = false;
      }
      
      public static function setmouseEnabled(bool:Boolean) : void
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
      
      public static function getN2S(str:String) : String
      {
         str = Pop.replaceStrng(str,"1","A");
         str = Pop.replaceStrng(str,"2","B");
         str = Pop.replaceStrng(str,"3","C");
         str = Pop.replaceStrng(str,"4","D");
         str = Pop.replaceStrng(str,"5","E");
         str = Pop.replaceStrng(str,"6","F");
         str = Pop.replaceStrng(str,"7","G");
         str = Pop.replaceStrng(str,"8","H");
         str = Pop.replaceStrng(str,"9","I");
         return Pop.replaceStrng(str,"0","J");
      }
      
      public static function getS2N(str:String) : String
      {
         str = Pop.replaceStrng(str,"A","1");
         str = Pop.replaceStrng(str,"B","2");
         str = Pop.replaceStrng(str,"C","3");
         str = Pop.replaceStrng(str,"D","4");
         str = Pop.replaceStrng(str,"E","5");
         str = Pop.replaceStrng(str,"F","6");
         str = Pop.replaceStrng(str,"G","7");
         str = Pop.replaceStrng(str,"H","8");
         str = Pop.replaceStrng(str,"I","9");
         return Pop.replaceStrng(str,"J","0");
      }
      
      public static function getLibClass(str:String) : Class
      {
         var returnClass:Class = null;
         if(LoaderMC != null)
         {
            return LoaderMC.contentLoaderInfo.applicationDomain.getDefinition(str) as Class;
         }
         throw new Error("SaveCutMap類中的 LoaderMC庫 未加載.");
      }
      
      public static function FileReference_download(url:String, name:String) : void
      {
         var downloadURL:URLRequest = VL.getURLRequest();
         downloadURL.url = url;
         file = new FileReference();
         var fileName:String = "mole_" + new Date().valueOf() + ".jpg";
         configureListeners();
         file.download(downloadURL,fileName);
      }
      
      private static function configureListeners() : void
      {
         file.addEventListener(Event.CANCEL,cancelHandler);
         file.addEventListener(Event.COMPLETE,completeHandler);
         file.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
         file.addEventListener(ProgressEvent.PROGRESS,progressHandler);
         file.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
      }
      
      private static function removeConfigureListeners() : void
      {
         file.removeEventListener(Event.CANCEL,cancelHandler);
         file.removeEventListener(Event.COMPLETE,completeHandler);
         file.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
         file.removeEventListener(ProgressEvent.PROGRESS,progressHandler);
         file.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
      }
      
      private static function cancelHandler(event:Event) : void
      {
         trace("cancelHandler: " + event);
         removeConfigureListeners();
         G_dispatchEvent(new EventTaomee(DOWN_CANCEL,event));
      }
      
      private static function completeHandler(event:Event) : void
      {
         trace("completeHandler: " + event);
         removeConfigureListeners();
         G_dispatchEvent(new EventTaomee(DOWN_COMPLETE,event));
      }
      
      private static function ioErrorHandler(event:IOErrorEvent) : void
      {
         trace("ioErrorHandler: " + event);
         removeConfigureListeners();
         G_dispatchEvent(new EventTaomee(DOWN_IO_ERROR,event));
      }
      
      private static function progressHandler(event:ProgressEvent) : void
      {
         var file:FileReference = FileReference(event.target);
         trace("progressHandler name=" + file.name + " bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
      }
      
      private static function securityErrorHandler(event:SecurityErrorEvent) : void
      {
         trace("securityErrorHandler: " + event);
         removeConfigureListeners();
         G_dispatchEvent(new EventTaomee(DOWN_IO_ERROR,event));
      }
      
      private function getSaveInfo() : void
      {
         cupMapReq.getSession();
         BC.addEvent(this,GV.onlineSocket,cupMapRes.GET_SESSION,this.getSaveInfoHandler);
      }
      
      private function getCutMapData() : void
      {
         var infoClass:MCLoader = null;
         var stopMoveMC:PeopleManageView = null;
         if(!cutMapClass)
         {
            infoClass = new MCLoader(Links.getUrl("module/cutMapView/MycutMap.swf"),GV.MC_AppLever,Loading.TITLE_AND_PERCENT,"正在初始化截圖程序.");
            BC.addEvent(this,infoClass,MCLoadEvent.ON_SUCCESS,this.loadcutMapViewHandler);
            infoClass.doLoad();
         }
         else
         {
            try
            {
               MoveTo.CanMove = false;
               setmouseEnabled(false);
               stopMoveMC = GV.MAN_PEOPLE as PeopleManageView;
               stopMoveMC.DelRotation();
            }
            catch(E:Error)
            {
            }
            this.CutMapSprit = new cutMapClass();
            BC.addEvent(this,this.CutMapSprit,Event.COMPLETE,function(E:Event):void
            {
               var stopMoveMC:PeopleManageView = null;
               cutMapData = CutMapSprit.cutMapData as ByteArray;
               checkUpLoad();
               CutMapSprit = null;
               MoveTo.CanMove = true;
               setmouseEnabled(true);
               try
               {
                  stopMoveMC = GV.MAN_PEOPLE as PeopleManageView;
                  stopMoveMC.addRotation();
               }
               catch(E:*)
               {
               }
            });
            BC.addEvent(this,this.CutMapSprit,Event.CLOSE,function(E:Event):void
            {
               var stopMoveMC:PeopleManageView = null;
               busy = false;
               CutMapSprit = null;
               MoveTo.CanMove = true;
               setmouseEnabled(true);
               try
               {
                  stopMoveMC = GV.MAN_PEOPLE as PeopleManageView;
                  stopMoveMC.addRotation();
               }
               catch(E:*)
               {
               }
            });
            MainManager.getRootMC().addChild(this.CutMapSprit);
         }
      }
      
      private function getSaveInfoHandler(E:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,cupMapRes.GET_SESSION,this.getSaveInfoHandler);
         this.Session = E.EventObj.Session as ByteArray;
         this.ip = E.EventObj.Ip;
         this.port = E.EventObj.Port;
         this.checkUpLoad();
      }
      
      private function loadcutMapViewHandler(evt:MCLoadEvent) : void
      {
         BC.removeEvent(this,null,MCLoadEvent.ON_SUCCESS,this.loadcutMapViewHandler);
         var childMC:Loader = evt.getLoader();
         LoaderMC = childMC;
         PhotographClass = getLibClass("Photograph");
         cutMapClass = getLibClass("CutMap");
         PicViewClass = getLibClass("PicView");
         this.getCutMapData();
      }
      
      private function checkUpLoad() : void
      {
         var _data:ByteArray = null;
         var cutMapID:int = 0;
         var returnStr:String = null;
         if(Boolean(this.cutMapData) && Boolean(this.Session))
         {
            busy = false;
            _data = new ByteArray();
            _data.writeBytes(this.Session,0);
            _data.writeBytes(this.cutMapData,0);
            cutMapID = 1;
            if(cutMapArray.length > 5)
            {
               cutMapArray.shift();
            }
            if(Boolean(cutMapArray.length))
            {
               cutMapID = cutMapArray[cutMapArray.length - 1].id + 1;
               cutMapArray.push({
                  "data":_data,
                  "id":cutMapID,
                  "ip":this.ip,
                  "port":this.port,
                  "link":""
               });
            }
            else
            {
               cutMapArray.push({
                  "data":_data,
                  "id":cutMapID,
                  "ip":this.ip,
                  "port":this.port,
                  "link":""
               });
            }
            trace("cutMapData,Session",this.cutMapData,this.Session);
            returnStr = "[IMG ([ID=" + SaveCutMap.getN2S(String(cutMapID)) + "])]摩爾截圖[/IMG]";
            dispatchEvent(new EventTaomee(Event.COMPLETE,returnStr));
         }
      }
   }
}

