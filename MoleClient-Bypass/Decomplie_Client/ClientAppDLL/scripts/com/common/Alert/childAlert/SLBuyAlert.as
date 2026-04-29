package com.common.Alert.childAlert
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.manager.IndexManager;
   import com.event.EventTaomee;
   import flash.display.Loader;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   
   public class SLBuyAlert extends EventDispatcher
   {
      
      public static var CLICK_EVENT_A:String = "CLICK_event_1";
      
      public static var CLICK_EVENT_B:String = "CLICK_event_2";
      
      public static var SL_ALERT:String = "SL_ALERT_UI";
      
      public static var CLOSE_MIBI_EVENT:String = "CLOSE_MIBI_EVENT";
      
      private var targetMC:*;
      
      private var msg:String;
      
      private var url:String;
      
      private var MC:*;
      
      private var tempLoader:Loader;
      
      private var bool:Boolean = false;
      
      public function SLBuyAlert()
      {
         super();
      }
      
      public function showUI(AddMC:*, Url:String = "", Msg:String = "", _b:Boolean = false) : void
      {
         this.bool = _b;
         this.targetMC = AddMC;
         if(Boolean(this.targetMC.getChildByName(SL_ALERT)))
         {
            return;
         }
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeAll);
         this.msg = Msg;
         this.url = Url;
         if(this.bool)
         {
            this.MC = IndexManager.getInstance().getMovieClip("SL_AlartMC");
         }
         else
         {
            this.MC = IndexManager.getInstance().getMovieClip("SL_Alart");
         }
         this.MC.name = SL_ALERT;
         MainManager.centerObj(this.MC);
         this.setMC();
         this.targetMC.addChild(this.MC);
      }
      
      private function setMC() : void
      {
         this.MC.Info_txt.htmlText = this.msg;
         this.MC.Pass_txt.text = "";
         this.tempLoader = new Loader();
         this.tempLoader.load(VL.getURLRequest(this.url));
         this.tempLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         this.MC.addMC.addChild(this.tempLoader);
         if(!this.bool)
         {
            this.MC.addMC.scaleX = this.MC.addMC.scaleY = 2;
         }
         BC.addEvent(this,this.MC.close_btn,MouseEvent.CLICK,this.removeAll);
         BC.addEvent(this,this.MC.btn_1,MouseEvent.CLICK,this.disEvent);
         BC.addEvent(this,this.MC.btn_2,MouseEvent.CLICK,this.disEventT);
      }
      
      private function onLoadError(e:IOErrorEvent) : void
      {
         this.tempLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         this.url = "resource/cloth/slicon/102045.swf";
         this.tempLoader.load(VL.getURLRequest(this.url));
      }
      
      private function disEvent(event:MouseEvent) : void
      {
         var infos:String = this.MC.Pass_txt.text;
         if(infos == "" && !this.bool)
         {
            GF.showAlert(this.targetMC,"一定要輸入密碼哦！","",Alert.CHANG_ALERT,"iknow",true,false,"D");
         }
         else
         {
            dispatchEvent(new EventTaomee(CLICK_EVENT_A,{"info":infos}));
         }
         this.removeAll();
      }
      
      private function disEventT(event:MouseEvent) : void
      {
         dispatchEvent(new EventTaomee(CLICK_EVENT_B));
         GV.onlineSocket.dispatchEvent(new EventTaomee(CLOSE_MIBI_EVENT));
         this.removeAll();
      }
      
      public function removeAll(event:MouseEvent = null) : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee(CLOSE_MIBI_EVENT));
         this.tempLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         BC.removeEvent(this);
         GC.stopAllMC(this.MC);
         var temp:* = this.targetMC.getChildByName(SL_ALERT);
         this.targetMC.removeChild(temp);
         this.targetMC = null;
         this.msg = "";
         this.url = "";
         this.MC = null;
      }
   }
}

