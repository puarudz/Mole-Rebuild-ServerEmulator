package com.module.RunMushLoad
{
   import com.core.MainManager;
   import com.core.loading.Loading;
   import com.core.newloader.MCLoader;
   import com.event.MCLoadEvent;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class RunMushLoader
   {
      
      public static var setTime:uint;
      
      public static var MC:MovieClip;
      
      public static var isShowPanel:Boolean;
      
      public function RunMushLoader()
      {
         super();
      }
      
      public static function showmogu(mc:MovieClip) : void
      {
         MC = mc;
         mc.stop();
         mc.mouseChildren = false;
         mc.buttonMode = true;
         GV.onlineSocket.addEventListener("removeMapEvent",removeEventHandler);
         mc.addEventListener(MouseEvent.MOUSE_OVER,mcHandler);
         mc.addEventListener(MouseEvent.MOUSE_OUT,mcHandler);
         mc.addEventListener(MouseEvent.CLICK,mcHandler);
      }
      
      private static function mcHandler(e:Event) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         if(e.type == MouseEvent.MOUSE_OVER)
         {
            mc.gotoAndStop(2);
         }
         else if(e.type == MouseEvent.MOUSE_OUT)
         {
            mc.gotoAndStop(1);
         }
         else
         {
            loadMogu();
         }
      }
      
      public static function loadMogu(showPanel:Boolean = true) : void
      {
         var spriteMC:MovieClip = null;
         var spriteLoad:MCLoader = null;
         var spriMC:MovieClip = null;
         var contentMC:Sprite = null;
         var loader:Loader = null;
         isShowPanel = showPanel;
         clearTimeout(setTime);
         if(!MainManager.getToolLevel().getChildByName("spriteMC"))
         {
            spriteMC = new MovieClip();
            spriteMC.name = "spriteMC";
            MainManager.getToolLevel().addChild(spriteMC);
            MainManager.getToolLevel().setChildIndex(spriteMC,0);
            spriteLoad = new MCLoader("module/external/RunMushRoom.swf",spriteMC,Loading.TITLE_AND_PERCENT,"正在打開幫助小精靈");
            spriteLoad.addEventListener(MCLoadEvent.ON_SUCCESS,spriteMCHandler);
            spriteLoad.doLoad();
         }
         else
         {
            spriMC = MainManager.getToolLevel().getChildByName("spriteMC") as MovieClip;
            if(isShowPanel)
            {
               contentMC = (spriMC.getChildAt(0) as Loader).content as Sprite;
               contentMC["init"]("panel");
            }
            else
            {
               loader = spriMC.getChildAt(0) as Loader;
               GV.onlineSocket.dispatchEvent(new Event("close_runmush"));
               setTime = setTimeout(removeMushroom,1100);
            }
         }
      }
      
      private static function removeMushroom() : void
      {
         var spriMC:MovieClip = MainManager.getToolLevel().getChildByName("spriteMC") as MovieClip;
         clearTimeout(setTime);
         if(Boolean(spriMC))
         {
            MainManager.getToolLevel().removeChild(spriMC);
         }
         spriMC = null;
      }
      
      private static function spriteMCHandler(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:Loader = evt.getLoader();
         var contentMC:Sprite = evt.getContent() as Sprite;
         if(isShowPanel)
         {
            contentMC["init"]("panel");
         }
         else
         {
            contentMC["init"]("mogu");
         }
         mainMC.addChild(childMC);
         evt.currentTarget.removeEventListener(MCLoadEvent.ON_SUCCESS,spriteMCHandler);
         evt.currentTarget["clear"]();
      }
      
      private static function removeEventHandler(e:Event) : void
      {
         GV.onlineSocket.removeEventListener("removeMapEvent",removeEventHandler);
         MC.removeEventListener(MouseEvent.MOUSE_OVER,mcHandler);
         MC.removeEventListener(MouseEvent.MOUSE_OUT,mcHandler);
         MC.removeEventListener(MouseEvent.CLICK,mcHandler);
         MC = null;
      }
   }
}

