package com.module.classModule
{
   import com.core.manager.IndexManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class medalManage
   {
      
      public function medalManage()
      {
         super();
      }
      
      public static function getMedal(classID:uint, size:uint = 50, clickFun:Function = null, overFun:Function = null, outFun:Function = null, initFun:Function = null) : Sprite
      {
         var cm:Sprite = null;
         cm = new Sprite();
         cm.buttonMode = true;
         cm.mouseChildren = false;
         classManage.getInstance().getBadgeInfo(classID,function(obj:Object):void
         {
            var cm1:MovieClip = IndexManager.getInstance().getMovieClip("cm" + obj.Logo_type);
            cm1.width = cm1.height = size;
            cm1.t_mc.txt.text = obj.Logo_word;
            GF.setOffsetColor(cm1.MC,obj.Logo_color);
            if(clickFun != null)
            {
               cm.addEventListener(MouseEvent.CLICK,function(E:MouseEvent):void
               {
                  clickFun(cm,obj);
               });
            }
            if(overFun != null)
            {
               cm.addEventListener(MouseEvent.MOUSE_OVER,function(E:MouseEvent):void
               {
                  overFun(cm,obj);
               });
            }
            if(outFun != null)
            {
               cm.addEventListener(MouseEvent.MOUSE_OUT,function(E:MouseEvent):void
               {
                  outFun(cm,obj);
               });
            }
            cm.addChild(cm1);
            if(initFun != null)
            {
               initFun(cm,obj);
            }
         });
         return cm;
      }
   }
}

