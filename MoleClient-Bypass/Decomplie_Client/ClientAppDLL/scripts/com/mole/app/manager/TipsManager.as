package com.mole.app.manager
{
   import com.common.data.HashMap;
   import com.mole.app.ui.SpriteTips;
   import com.mole.app.ui.TextTips;
   import com.mole.app.ui.TipsBase;
   import flash.display.DisplayObject;
   
   public class TipsManager
   {
      
      private static var _tipsHash:HashMap;
      
      public function TipsManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         _tipsHash = new HashMap();
      }
      
      public static function addTextTips(container:DisplayObject, msg:String, autoDel:Boolean = true, txtWordWrap:Boolean = false, txtDefaultWidth:int = 100) : void
      {
         var tip:TipsBase = new TextTips(container,msg,autoDel,txtWordWrap,txtDefaultWidth);
         _tipsHash.add(container,tip);
      }
      
      public static function addTips(container:DisplayObject, tips:DisplayObject, autoDel:Boolean = true) : void
      {
         var tip:TipsBase = new SpriteTips(container,tips,autoDel);
         _tipsHash.add(container,tip);
      }
      
      public static function remove(container:DisplayObject) : void
      {
         var tip:TipsBase = _tipsHash.remove(container);
         if(Boolean(tip))
         {
            tip.destroy();
         }
      }
   }
}

