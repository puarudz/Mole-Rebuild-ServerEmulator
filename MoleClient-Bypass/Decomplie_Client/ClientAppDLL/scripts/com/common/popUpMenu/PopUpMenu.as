package com.common.popUpMenu
{
   import com.core.MainManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class PopUpMenu
   {
      
      private static var _showedMenu:MovieClip;
      
      private static const Max_Width:int = 960;
      
      private static const Max_Height:int = 560;
      
      private static var _menuDic:Dictionary = new Dictionary();
      
      public function PopUpMenu()
      {
         super();
      }
      
      public static function ClearClickMenu(mc:*) : void
      {
         if(Boolean(_menuDic[mc]))
         {
            BC.removeEvent(mc);
            _menuDic[mc] = null;
         }
      }
      
      public static function SetClickMenu(mc:*, items:Array, bg:Class = null) : void
      {
         var stage:Stage = null;
         if(Boolean(mc is DisplayObject) && Boolean(items) && items.length > 0)
         {
            if(Boolean(_menuDic[mc]))
            {
               ClearClickMenu(mc);
            }
            _menuDic[mc] = CeateMenu(items,bg);
            BC.addEvent(mc,mc,MouseEvent.CLICK,OnMouseClick);
            stage = MainManager.getAlertLevel().stage;
            BC.addEvent(_menuDic,stage,MouseEvent.CLICK,OnStageClick);
            BC.addEvent(_menuDic,GV.onlineSocket,"removeMapEvent",ClearHandler);
         }
      }
      
      private static function CeateMenu(items:Array, bg:Class) : MovieClip
      {
         var menuMC:MovieClip = null;
         var containerMC:MovieClip = null;
         var bgMC:MovieClip = null;
         var item:PopUpMenuItem = null;
         var startY:Number = 0;
         var offsetY:Number = 3;
         if(Boolean(bg))
         {
            menuMC = new bg();
            containerMC = menuMC.container_mc;
            bgMC = menuMC.bg_mc;
            for each(item in items)
            {
               item.y = startY;
               startY += item.height + offsetY;
               containerMC.addChild(item);
            }
            bgMC.width = containerMC.width + bgMC.width - bgMC.scale9Grid.width;
            bgMC.height = containerMC.height + bgMC.height - bgMC.scale9Grid.height;
         }
         else
         {
            menuMC = new MovieClip();
            bgMC = menuMC.bg_mc = new MovieClip();
            menuMC.addChild(bgMC);
            containerMC = menuMC.container_mc = new MovieClip();
            containerMC.x = 7;
            containerMC.y = 6;
            menuMC.addChild(containerMC);
            for each(item in items)
            {
               item.y = startY;
               startY += item.height + offsetY;
               containerMC.addChild(item);
            }
            bgMC.graphics.lineStyle(2,13018194);
            bgMC.graphics.beginFill(16777174);
            bgMC.graphics.drawRoundRect(0,0,containerMC.width + 14,containerMC.height + 12,10,10);
            bgMC.graphics.endFill();
         }
         return menuMC;
      }
      
      private static function ClearHandler(e:Event) : void
      {
         BC.removeEvent(_menuDic);
      }
      
      private static function OnMouseClick(e:MouseEvent) : void
      {
         e.stopImmediatePropagation();
         var menuMC:MovieClip = _menuDic[e.currentTarget];
         if(Boolean(_showedMenu))
         {
            try
            {
               _showedMenu.visible = false;
               MainManager.getAlertLevel().removeChild(_showedMenu);
            }
            catch(e:Error)
            {
            }
         }
         _showedMenu = menuMC;
         _showedMenu.visible = true;
         _showedMenu.x = e.stageX + 5;
         if(_showedMenu.x + _showedMenu.width > Max_Width)
         {
            _showedMenu.x = Max_Width - _showedMenu.width - 5;
         }
         _showedMenu.y = e.stageY;
         if(_showedMenu.y + _showedMenu.height > Max_Height)
         {
            _showedMenu.y = Max_Height - _showedMenu.height - 5;
         }
         MainManager.getAlertLevel().addChild(_showedMenu);
      }
      
      private static function OnStageClick(e:MouseEvent) : void
      {
         if(Boolean(_showedMenu))
         {
            try
            {
               _showedMenu.visible = false;
               MainManager.getAlertLevel().removeChild(_showedMenu);
               _showedMenu = null;
            }
            catch(e:Error)
            {
            }
         }
      }
   }
}

