package com.common.Alert.childAlert
{
   import com.common.Alert.ICustomAlert;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.global.links.Links;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   
   public class customAlert extends simpleAlert implements ICustomAlert
   {
      
      public static var myLoader:MCLoader;
      
      public static var onLoad:String = "onLoad";
      
      public static var onAdded:String = "added";
      
      private static var libSrc_Dic:Dictionary = new Dictionary(true);
      
      private static var libCountArr:Array = new Array();
      
      private static var MaxLen:uint = 0;
      
      private var loader:Loader;
      
      public function customAlert(obj:*, title:String = "", content:String = "", style:uint = 0, bottomArray:String = "確定", closeB:Boolean = true)
      {
         super(obj,title,content,2);
         if(!style)
         {
            this.showAlert();
         }
      }
      
      public function load() : void
      {
         this.showAlert();
      }
      
      override public function showAlert() : void
      {
         var myAlert:* = undefined;
         var myclass:* = undefined;
         var GV_Class:* = dispatchObj.stage.loaderInfo.applicationDomain.getDefinition("GV");
         if(CONTENT == "")
         {
            if(GV_Class != null)
            {
               myclass = null;
               if(myclass != null)
               {
                  myAlert = new myclass();
                  trace("在共享庫中找到類:",myAlert);
               }
               else
               {
                  myclass = dispatchObj.root.loaderInfo.applicationDomain.getDefinition(TITLE.split(",")[0]);
                  myAlert = new myclass();
                  trace("在Index主程序中找到類:",myAlert);
               }
            }
            else
            {
               myclass = dispatchObj.root.loaderInfo.applicationDomain.getDefinition(TITLE.split(",")[0]);
               myAlert = new myclass();
               trace("在Index主程序中找到類:",myAlert);
            }
            this.InitMC(myAlert);
         }
         else
         {
            this.loadMc();
         }
      }
      
      public function loadMc() : void
      {
         var index:int = 0;
         var delStr:String = null;
         if(Boolean(libSrc_Dic[CONTENT]))
         {
            this.getPart(libSrc_Dic[CONTENT]);
            index = libCountArr.indexOf(CONTENT);
            if(Boolean(index))
            {
               delStr = libCountArr.splice(index,1)[0];
               libCountArr.unshift(delStr);
            }
         }
         else
         {
            myLoader = new MCLoader(Links.getUrl(CONTENT),dispatchObj,1,TITLE.split(",")[1]);
            BC.addEvent(this,myLoader,MCLoadEvent.ON_SUCCESS,this.onLoadedMC);
            myLoader.doLoad();
         }
      }
      
      private function onLoadedMC(event:MCLoadEvent) : void
      {
         var str:String = null;
         var temp_mc:* = event.getLoader();
         this.loader = temp_mc;
         BC.removeEvent(this,myLoader,MCLoadEvent.ON_SUCCESS,this.onLoadedMC);
         libSrc_Dic[CONTENT] = temp_mc;
         libCountArr.unshift(CONTENT);
         if(libCountArr.length > MaxLen)
         {
            str = libCountArr.pop();
            libSrc_Dic[str] = null;
         }
         this.getPart(temp_mc);
      }
      
      private function getPart(temp_mc:Loader) : void
      {
         var myclass:* = temp_mc.contentLoaderInfo.applicationDomain.getDefinition(TITLE.split(",")[0]);
         var myAlert:* = new myclass();
         this.InitMC(myAlert);
         dispatchEvent(new EventTaomee(onLoad,{"target":myAlert}));
         setTimeout(this.onAddedMC,50);
      }
      
      public function InitMC(myAlert:*) : void
      {
         TARGET = myAlert;
         dispatchObj.addChild(myAlert);
         dragAndDepthManage(myAlert);
         this.setAlertXY(myAlert);
      }
      
      public function onAddedMC() : void
      {
         dispatchEvent(new EventTaomee(onAdded,{"target":TARGET}));
      }
      
      override protected function setAlertXY(myAlert:*) : void
      {
         myAlert.OWNER = OWNER;
         myAlert.x = (GV.stageWidth - myAlert.width) / 2;
         myAlert.y = (GV.stageHeight - myAlert.height) / 2;
      }
      
      public function getLoader() : Loader
      {
         return this.loader;
      }
      
      public function getTarget() : DisplayObjectContainer
      {
         return TARGET;
      }
   }
}

