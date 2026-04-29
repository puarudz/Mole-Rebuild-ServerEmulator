package com.view.MapManageView
{
   import com.common.data.HashMap;
   import com.common.util.ColorMatrix;
   import com.common.util.DisplayUtil;
   import com.mole.debug.DebugManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   
   public class MapButtonView extends Sprite
   {
      
      private static var _inst:MapButtonView;
      
      public static var data:HashMap;
      
      private var _enabled:Boolean;
      
      public function MapButtonView()
      {
         super();
         this._enabled = true;
      }
      
      public static function getTarget() : MapButtonView
      {
         if(_inst == null)
         {
            _inst = new MapButtonView();
         }
         return _inst;
      }
      
      public static function regeditEvent(disObj:DisplayObject, backFun:Function, eventType:String = "click") : DisplayObject
      {
         var bm:Bitmap;
         var matrix:ColorMatrix = null;
         var name:String = disObj.name;
         var btn:Sprite = new Sprite();
         btn.name = name;
         btn.x = disObj.x;
         btn.y = disObj.y;
         btn.buttonMode = true;
         bm = DisplayUtil.copyDisplayAsBmp(disObj);
         if(DebugManager.DEBUG)
         {
            matrix = new ColorMatrix();
            matrix.adjustSaturation(-100);
            matrix.adjustContrast(-100);
            bm.filters = [new ColorMatrixFilter(matrix)];
            bm.alpha = 0.8;
         }
         else
         {
            bm.alpha = 0;
         }
         btn.addChild(bm);
         _inst.addChild(btn);
         if(data == null)
         {
            data = new HashMap();
         }
         data.add(name,btn);
         BC.addEvent(_inst,btn,eventType,function(e:MouseEvent):void
         {
            backFun(e);
         });
         return btn;
      }
      
      public static function removeEvent(disObj:DisplayObject, removeObj:Boolean = true) : void
      {
         if(removeObj)
         {
            DisplayUtil.removeForParent(disObj);
         }
         var mc:* = data.getValue(disObj.name);
         if(mc == null)
         {
            BC.removeEvent(_inst,disObj);
         }
         else
         {
            BC.removeEvent(_inst,mc);
            data.remove(disObj.name);
         }
      }
      
      public function set enabled(b:Boolean) : void
      {
         this._enabled = b;
         mouseChildren = mouseEnabled = this._enabled;
         if(b)
         {
            x = 0;
         }
         else
         {
            x = -1000;
         }
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function destroy() : void
      {
         BC.removeEvent(this);
         DisplayUtil.removeAllChild(this);
         if(Boolean(data))
         {
            data.clear();
         }
         data = null;
      }
   }
}

