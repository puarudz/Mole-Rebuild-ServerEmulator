package com.taomee.mole.library.utils
{
   import com.common.data.HashMap;
   import com.mole.app.map.MapManager;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.MouseEvent;
   
   public class GoMapUtil
   {
      
      private var _map:HashMap;
      
      public function GoMapUtil(mc:DisplayObjectContainer)
      {
         var go_btn:DisplayObject = null;
         var nameList:Array = null;
         super();
         this._map = new HashMap();
         for(var i:uint = 0; i < mc.numChildren; i++)
         {
            go_btn = mc.getChildAt(i);
            if(Boolean(go_btn))
            {
               nameList = go_btn.name.split("_");
               if(nameList[0] == "go")
               {
                  this._map.add(go_btn,nameList[1]);
                  go_btn.addEventListener(MouseEvent.CLICK,this.onGoMap);
               }
            }
         }
      }
      
      private function onGoMap(e:MouseEvent) : void
      {
         var tarMapID:uint = this._map.getValue(e.currentTarget);
         MapManager.enterMap(tarMapID);
      }
      
      public function destroy() : void
      {
         var go_btn:DisplayObject = null;
         var btnList:Array = this._map.keys;
         for each(go_btn in btnList)
         {
            go_btn.addEventListener(MouseEvent.CLICK,this.onGoMap);
         }
         this._map.clear();
      }
   }
}

