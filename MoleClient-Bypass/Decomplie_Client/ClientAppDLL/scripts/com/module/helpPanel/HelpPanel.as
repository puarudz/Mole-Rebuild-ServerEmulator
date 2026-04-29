package com.module.helpPanel
{
   import com.common.util.AlignType;
   import com.common.util.DisplayUtil;
   import com.core.MainManager;
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   
   public class HelpPanel extends EventDispatcher
   {
      
      private static var instance:HelpPanel;
      
      public static const TIP_COLSE:String = "tip_close";
      
      private var _help_mc:MovieClip;
      
      private var _close_btn:DisplayObject;
      
      public function HelpPanel()
      {
         super();
      }
      
      public static function getInstance() : HelpPanel
      {
         if(instance == null)
         {
            instance = new HelpPanel();
         }
         return instance;
      }
      
      public function panelVisible(str:String, isAlign:Boolean = true) : void
      {
         if(!MainManager.getGameLevel().getChildByName("hlepMC"))
         {
            this._help_mc = GV.Lib_Map.getMovieClip(str) as MovieClip;
            if(Boolean(this._help_mc))
            {
               this._help_mc.name = "hlep" + str;
               if(isAlign)
               {
                  DisplayUtil.align(this._help_mc,LevelManager.stageRect,AlignType.MIDDLE_CENTER);
               }
               MainManager.getGameLevel().addChild(this._help_mc);
               this._close_btn = this._help_mc["close_btn"];
               if(Boolean(this._close_btn))
               {
                  this._close_btn.addEventListener(MouseEvent.CLICK,this.helpCloseHnalder);
               }
               GV.onlineSocket.addEventListener("removeMapEvent",this.removeEventHandler);
            }
         }
      }
      
      private function helpCloseHnalder(event:MouseEvent = null) : void
      {
         this.destroy();
      }
      
      public function destroy() : void
      {
         this.dispatchEvent(new Event(HelpPanel.TIP_COLSE));
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeEventHandler);
         this._close_btn.removeEventListener(MouseEvent.CLICK,this.helpCloseHnalder);
         DisplayUtil.removeForParent(this._help_mc);
      }
      
      private function removeEventHandler(evt:EventTaomee) : void
      {
         this.destroy();
      }
   }
}

