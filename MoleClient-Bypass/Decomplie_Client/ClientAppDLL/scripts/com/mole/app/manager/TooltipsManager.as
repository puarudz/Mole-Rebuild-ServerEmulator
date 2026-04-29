package com.mole.app.manager
{
   import com.core.manager.LevelManager;
   import com.taomee.mole.library.ui.BaseTips;
   import flash.display.InteractiveObject;
   import flash.events.MouseEvent;
   import flash.utils.clearTimeout;
   import org.taomee.ds.HashMap;
   import org.taomee.manager.TaomeeManager;
   import org.taomee.utils.DisplayUtil;
   
   public class TooltipsManager
   {
      
      private static var _intervalCode:uint;
      
      private static var tipsMc:BaseTips;
      
      private static var tips:HashMap = new HashMap();
      
      public function TooltipsManager()
      {
         super();
      }
      
      public static function addTip(tipInitiator:InteractiveObject, baseTip:BaseTips) : void
      {
         if(tips.containsKey(tipInitiator))
         {
            return;
         }
         tips.add(tipInitiator,baseTip);
         tipInitiator.addEventListener(MouseEvent.ROLL_OVER,rollOverHandler);
         tipInitiator.addEventListener(MouseEvent.ROLL_OUT,rollOutHandler);
      }
      
      public static function removeTip(tipInitiator:InteractiveObject) : void
      {
         var baseTips:BaseTips = null;
         tipInitiator.removeEventListener(MouseEvent.ROLL_OVER,rollOverHandler);
         tipInitiator.removeEventListener(MouseEvent.ROLL_OUT,rollOutHandler);
         if(tips.containsKey(tipInitiator))
         {
            baseTips = tips.getValue(tipInitiator);
            baseTips.detory();
            tips.remove(tipInitiator);
         }
      }
      
      private static function rollOverHandler(evt:MouseEvent) : void
      {
         var tipInitiator:InteractiveObject = evt.currentTarget as InteractiveObject;
         showTips(tipInitiator);
      }
      
      private static function showTips(tipInitiator:InteractiveObject) : void
      {
         tipsMc = tips.getValue(tipInitiator) as BaseTips;
         tipsMc.show();
         LevelManager.tipLevel.addChild(tipsMc);
         LevelManager.stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
         mouseMoveHandler();
      }
      
      private static function hideTips() : void
      {
         if(_intervalCode != 0)
         {
            clearTimeout(_intervalCode);
            _intervalCode = 0;
         }
         LevelManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
         if(Boolean(tipsMc))
         {
            tipsMc.hide();
            DisplayUtil.removeFromParent(tipsMc);
            tipsMc = null;
         }
      }
      
      private static function rollOutHandler(evt:MouseEvent) : void
      {
         hideTips();
      }
      
      private static function mouseMoveHandler(evt:MouseEvent = null) : void
      {
         if(LevelManager.stage.mouseX + tipsMc.width + 20 >= TaomeeManager.stageWidth)
         {
            tipsMc.x = TaomeeManager.stageWidth - tipsMc.width - 10;
         }
         else
         {
            tipsMc.x = TaomeeManager.stage.mouseX + 10;
         }
         if(TaomeeManager.stage.mouseY + tipsMc.height + 20 >= TaomeeManager.stageHeight)
         {
            tipsMc.y = TaomeeManager.stageHeight - tipsMc.height - 10;
         }
         else
         {
            tipsMc.y = TaomeeManager.stage.mouseY + 20;
         }
      }
   }
}

