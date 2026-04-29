package com.module.home
{
   import com.core.MainManager;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.socket.home.HomeCarSocket;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class HomeCarLoad
   {
      
      public static var showCarInfo:Object;
      
      public static var change_show_car:String = "change_show_car";
      
      public static var clean_show_car:String = "clean_show_car";
      
      public var targetMC:MovieClip;
      
      public function HomeCarLoad(mc:MovieClip)
      {
         super();
         this.targetMC = mc;
         showCarInfo = null;
         if(HomeView.ismyhome)
         {
            BC.addEvent(this,this.targetMC.btn,MouseEvent.CLICK,this.click);
         }
         HomeCarSocket.ShowCarInfo(HomeView.hostID);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1704,this.showcarinfo);
         BC.addEvent(this,GV.onlineSocket,change_show_car,this.changeshowcar);
         BC.addEvent(this,GV.onlineSocket,clean_show_car,this.cleanshowcar);
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
      }
      
      private function removeEventHandler(E:Event) : void
      {
         BC.removeEvent(this);
      }
      
      public function cleanshowcar(e:EventTaomee) : void
      {
         var mc:Object = this.targetMC.mc2.getChildAt(0);
         if(Boolean(mc) && Boolean(mc.icon))
         {
            GC.clearAllChildren(mc.icon);
         }
      }
      
      public function changeshowcar(e:EventTaomee) : void
      {
         setTimeout(this.loadIcon,50);
      }
      
      public function showcarinfo(e:EventTaomee) : void
      {
         if(e.EventObj != "noshowcar")
         {
            showCarInfo = e.EventObj;
            setTimeout(this.loadIcon,50);
         }
      }
      
      private function loadIcon() : void
      {
         var tempLoader:Loader = null;
         var mc:Object = this.targetMC.mc2.getChildAt(0);
         if(Boolean(mc) && Boolean(mc.icon) && Boolean(showCarInfo))
         {
            tempLoader = new Loader();
            tempLoader.load(VL.getURLRequest("resource/car/icon/" + showCarInfo.ItemID + ".swf"));
            GC.clearAllChildren(mc.icon);
            mc.icon.addChild(tempLoader);
         }
      }
      
      public function click(e:MouseEvent) : void
      {
         if(!HomeEditView.Editable)
         {
            this.loadUI({
               "swf":"module/external/HomeCar.swf",
               "tip":"正在打開車庫..."
            });
         }
      }
      
      private function loadUI(Obj:Object) : void
      {
         var mcloader:MCLoader = new MCLoader(Obj.swf,MainManager.getTopLevel(),1,Obj.tip);
         mcloader.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadSucc);
         mcloader.addEventListener(MCLoadEvent.ERROR,this.loadErr);
         mcloader.doLoad();
      }
      
      private function loadErr(event:MCLoadEvent) : void
      {
         trace("加載出錯");
      }
      
      private function loadSucc(event:MCLoadEvent) : void
      {
         var a:DisplayObjectContainer = event.getParent();
         var b:Loader = event.getLoader();
         var c:DisplayObject = event.getContent();
         MainManager.getTopLevel().addChild(c);
         trace("loadSucc",c.name);
         var mcloader:MCLoader = event.target as MCLoader;
         mcloader.clear();
      }
   }
}

