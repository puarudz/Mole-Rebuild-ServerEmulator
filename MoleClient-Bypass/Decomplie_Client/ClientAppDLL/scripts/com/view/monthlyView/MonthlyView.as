package com.view.monthlyView
{
   import com.core.MainManager;
   import com.core.manager.LevelManager;
   import com.core.newloader.MCLoader;
   import com.event.MCLoadEvent;
   import com.logic.FindPathLogic.MoveTo;
   import com.mole.app.manager.ModuleManager;
   import com.view.mapView.newspaperMapView;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class MonthlyView
   {
      
      public var loader:Loader;
      
      public var main:MovieClip;
      
      public var paper:*;
      
      public var childMC:Loader;
      
      public var isMove:Boolean = false;
      
      public function MonthlyView(container:Loader)
      {
         super();
         this.loader = container;
         this.main = MovieClip(container.content.root);
         this.initEvent();
         if(!MoveTo.CanMove)
         {
            this.isMove = true;
         }
         else
         {
            MoveTo.CanMove = false;
         }
      }
      
      public function initEvent() : void
      {
         for(var i:int = 1; i <= 40; i++)
         {
            if(this.main[["news"] + i] == null)
            {
               break;
            }
            this.main[["news"] + i].mc.buttonMode = true;
            this.main[["news"] + i].mc.addEventListener(MouseEvent.CLICK,this.rootHandler);
            this.main[["news"] + i].mc.addEventListener(MouseEvent.MOUSE_OVER,this.rootMouseOver);
            this.main[["news"] + i].mc.addEventListener(MouseEvent.MOUSE_OUT,this.rootMouseOut);
         }
      }
      
      public function removeBtnHandler() : void
      {
         for(var i:int = 1; i < 40; i++)
         {
            if(this.main[["news"] + i] == null)
            {
               break;
            }
            this.main[["news"] + i].mc.removeEventListener(MouseEvent.CLICK,this.rootHandler);
            this.main[["news"] + i].mc.removeEventListener(MouseEvent.MOUSE_OVER,this.rootMouseOver);
            this.main[["news"] + i].mc.removeEventListener(MouseEvent.MOUSE_OUT,this.rootMouseOut);
         }
         GC.clearAllChildren(this.main);
         this.main = null;
         if(!this.isMove)
         {
            MoveTo.CanMove = true;
         }
      }
      
      public function rootHandler(event:MouseEvent) : void
      {
         var nameStr:String = event.currentTarget.parent.name;
         var tempStr:int = int(nameStr.substr(4));
         var str:String = "resource/monthly/" + newspaperMapView.paperNum + "/" + tempStr + ".swf";
         var loadInfo:String = "正在打開時報......";
         if(newspaperMapView.paperNum > 6 || newspaperMapView.paperNum == 6 && uint(tempStr) >= 21)
         {
            ModuleManager.openModule1("newsPaper",str,null,LevelManager.topLevel,loadInfo);
         }
         else
         {
            this.loadMC(str,loadInfo);
         }
      }
      
      public function loadMC(str:String, loadInfo:String) : void
      {
         var tempMC:MCLoader = null;
         if(!MainManager.getTopLevel().getChildByName("paper"))
         {
            this.paper = new MovieClip();
            this.paper.name = "paper";
            MainManager.getTopLevel().addChild(this.paper);
            tempMC = new MCLoader(str,this.paper,1,loadInfo);
            tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadOverHandler);
            BC.addEvent(this,tempMC,MCLoader.ON_USER_CLOSE_LOADER,this.closeLoadFun);
            tempMC.doLoad();
         }
      }
      
      private function closeLoadFun(evt:Event) : void
      {
         var tempMC:MCLoader = evt.target as MCLoader;
         BC.removeEvent(this,tempMC,MCLoader.ON_USER_CLOSE_LOADER,this.closeLoadFun);
         var tempObj:* = MainManager.getTopLevel().getChildByName("paper");
         if(Boolean(tempObj))
         {
            MainManager.getTopLevel().removeChild(tempObj);
            this.paper = null;
         }
      }
      
      public function loadOverHandler(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         this.childMC = evt.getLoader();
         mainMC.addChild(this.childMC);
         GV.onlineSocket.addEventListener("monthlyCloseEvent",this.removeMC);
         var mcloader:MCLoader = evt.target as MCLoader;
         mcloader.removeEventListener(MCLoadEvent.ON_SUCCESS,this.loadOverHandler);
         mcloader.clear();
      }
      
      public function rootMouseOver(event:MouseEvent) : void
      {
         event.currentTarget.parent.gotoAndPlay(2);
      }
      
      public function rootMouseOut(event:MouseEvent) : void
      {
         event.currentTarget.parent.gotoAndPlay(6);
      }
      
      public function removeMC(event:Event) : void
      {
         GV.onlineSocket.removeEventListener("monthlyCloseEvent",this.removeMC);
         GC.stopAllMC(this.childMC.content);
         GC.clearChildren(this.childMC.content);
         MainManager.getTopLevel().removeChild(this.paper);
         this.paper = null;
      }
   }
}

