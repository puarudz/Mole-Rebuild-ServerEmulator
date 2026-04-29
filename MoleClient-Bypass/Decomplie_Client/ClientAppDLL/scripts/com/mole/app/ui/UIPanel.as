package com.mole.app.ui
{
   import com.common.util.AlignType;
   import com.common.util.DisplayUtil;
   import com.core.manager.LevelManager;
   import com.mole.app.module.PanelModuleBase;
   import com.mole.app.utils.MouseDrag;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class UIPanel extends PanelModuleBase
   {
      
      protected var _drag_mc:Sprite;
      
      public function UIPanel(mainUI:Sprite, moduleID:uint = 0)
      {
         super(mainUI,moduleID);
         this._drag_mc = _panel["drag_mc"];
         if(Boolean(this._drag_mc))
         {
            this._drag_mc.alpha = 0;
            this._drag_mc.buttonMode = true;
            this.addEvent();
         }
      }
      
      override protected function initView() : void
      {
         DisplayUtil.align(_panel,LevelManager.stageRect,AlignType.MIDDLE_CENTER);
         addChild(_panel);
      }
      
      override public function destroy() : void
      {
         LevelManager.stage.focus = LevelManager.stage;
         if(Boolean(this._drag_mc))
         {
            this._drag_mc.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDragDown);
            this._drag_mc = null;
         }
         super.destroy();
      }
      
      protected function addEvent() : void
      {
         this._drag_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.onDragDown);
      }
      
      protected function onDragDown(e:MouseEvent) : void
      {
         new MouseDrag(this);
      }
   }
}

