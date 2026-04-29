package com.module.newAngel
{
   import com.common.util.DisplayUtil;
   import com.core.MainManager;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import flash.display.MovieClip;
   import flash.utils.Timer;
   
   public class NewAngelPopMsg
   {
      
      private static var _instance:NewAngelPopMsg;
      
      private var t:Timer;
      
      private var _msg:String;
      
      private var _delay:Number;
      
      private var mc:MovieClip;
      
      public function NewAngelPopMsg()
      {
         super();
      }
      
      public static function get instance() : NewAngelPopMsg
      {
         if(!_instance)
         {
            _instance = new NewAngelPopMsg();
         }
         return _instance;
      }
      
      public function popMsg(msg:String, delay:int = 5000) : void
      {
         var resID:int = 0;
         this._msg = msg;
         this._delay = delay;
         if(this.mc == null)
         {
            resID = int(DownLoadManager.add("module/external/exeModule/newAngelPopMsg.swf",ResType.DISPLAY_OBJECT));
            DownLoadManager.addEvent(resID,this.onLoadResOver);
         }
         else
         {
            this.showTxt();
         }
      }
      
      private function showTxt() : void
      {
         this.mc["txt"].text = this._msg;
         MainManager.getAppLevel().addChild(this.mc);
         if(this.t != null)
         {
            GC.clearGTimeout(this.t);
         }
         this.t = GC.setGTimeout(function():void
         {
            DisplayUtil.removeForParent(mc);
            mc = null;
            GC.clearGTimeout(t);
         },this._delay);
      }
      
      private function onLoadResOver(e:DownLoadEvent) : void
      {
         this.mc = e.data as MovieClip;
         this.showTxt();
      }
   }
}

