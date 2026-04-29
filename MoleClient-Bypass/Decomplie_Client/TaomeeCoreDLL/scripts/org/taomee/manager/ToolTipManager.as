package org.taomee.manager
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Dictionary;
   
   public class ToolTipManager
   {
      
      private static var _container:Sprite;
      
      private static var _txt:TextField;
      
      private static var _bg:DisplayObject;
      
      private static var _map:Dictionary;
      
      public function ToolTipManager()
      {
         super();
      }
      
      public static function setup(bg:DisplayObject) : void
      {
         _bg = bg;
         _map = new Dictionary();
         _container = new Sprite();
         _container.mouseChildren = false;
         _container.mouseEnabled = false;
         _container.addChild(_bg);
         _txt = new TextField();
         _txt.multiline = true;
         _txt.autoSize = TextFieldAutoSize.LEFT;
         _txt.x = 2;
         _txt.y = 2;
         _container.addChild(_txt);
      }
      
      public static function add(obj:InteractiveObject, text_p:String, width_p:int = 120, wordWrap_p:Boolean = true) : void
      {
         obj.addEventListener(MouseEvent.ROLL_OVER,onOver);
         obj.addEventListener(MouseEvent.ROLL_OUT,onOut);
         _map[obj] = {
            "text":text_p,
            "wordWrap":wordWrap_p,
            "width":width_p
         };
      }
      
      public static function remove(obj:InteractiveObject) : void
      {
         if(obj in _map)
         {
            obj.removeEventListener(MouseEvent.ROLL_OVER,onOver);
            obj.removeEventListener(MouseEvent.ROLL_OUT,onOut);
            delete _map[obj];
         }
         onFinish();
      }
      
      private static function onOver(e:MouseEvent) : void
      {
         var obj:InteractiveObject = e.currentTarget as InteractiveObject;
         var info:Object = _map[obj];
         if(Boolean(info.wordWrap))
         {
            _txt.wordWrap = true;
            _txt.width = 120;
         }
         else
         {
            _txt.wordWrap = false;
         }
         _txt.width = info.width;
         _txt.htmlText = info.text;
         _bg.width = _txt.textWidth + 9;
         _bg.height = _txt.textHeight + 9;
         _txt.width = _txt.textWidth + 4;
         _txt.height = _txt.textHeight + 4;
         PopUpManager.showForMouse(_container,PopUpManager.TOP_RIGHT,5,-5);
         TaomeeManager.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
      }
      
      private static function onOut(e:MouseEvent) : void
      {
         onFinish();
      }
      
      private static function onMove(e:MouseEvent) : void
      {
         PopUpManager.showForMouse(_container,PopUpManager.TOP_RIGHT,5,-5);
      }
      
      private static function onFinish() : void
      {
         if(Boolean(_container.parent))
         {
            _container.parent.removeChild(_container);
         }
         TaomeeManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
      }
   }
}

