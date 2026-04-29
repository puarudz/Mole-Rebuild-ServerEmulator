package com.view.toolView.tool
{
   import com.common.util.DisplayUtil;
   import com.mole.app.manager.StatisticsManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ToolMenuBase
   {
      
      private var _btn:SimpleButton;
      
      private var _menuParent:DisplayObjectContainer;
      
      protected var _menuCon:Sprite;
      
      public function ToolMenuBase(btn:SimpleButton, menuCon:Sprite)
      {
         super();
         this._btn = btn;
         this._menuCon = menuCon;
         this._menuParent = this._menuCon.parent;
         this._btn.addEventListener(MouseEvent.CLICK,this.onShowMenu);
         this.hide();
      }
      
      private function onShowMenu(e:MouseEvent) : void
      {
         if(Boolean(this._menuCon.parent))
         {
            this.hide();
         }
         else
         {
            StatisticsManager.send(489);
            this._menuParent.addChild(this._menuCon);
            this._menuCon.addEventListener(MouseEvent.ROLL_OUT,this.onHideMenu);
         }
         this.showMenu();
      }
      
      protected function showMenu() : void
      {
      }
      
      private function onHideMenu(e:MouseEvent) : void
      {
         this.hide();
      }
      
      public function hide() : void
      {
         DisplayUtil.removeForParent(this._menuCon);
         this._menuCon.removeEventListener(MouseEvent.ROLL_OUT,this.onHideMenu);
      }
      
      public function destroy() : void
      {
         this._btn.removeEventListener(MouseEvent.CLICK,this.onShowMenu);
      }
   }
}

