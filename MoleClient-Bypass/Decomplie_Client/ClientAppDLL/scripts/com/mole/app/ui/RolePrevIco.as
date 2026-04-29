package com.mole.app.ui
{
   import com.mole.utils.URLUtil;
   import com.taomee.mole.cache.CacheManager;
   import flash.display.Sprite;
   import org.taomee.loader.ContentInfo;
   
   public class RolePrevIco extends Sprite
   {
      
      private var _type:uint;
      
      private var _itemId:int;
      
      public function RolePrevIco(type:uint)
      {
         super();
         this._itemId = -1;
         this._type = type;
      }
      
      public function get type() : uint
      {
         return this._type;
      }
      
      public function clear() : void
      {
         while(numChildren >= 1)
         {
            removeChildAt(0);
         }
         this._itemId = -1;
      }
      
      public function get itemID() : int
      {
         return this._itemId;
      }
      
      public function set itemID(val:int) : void
      {
         if(this._itemId != val)
         {
            this._itemId = val;
            CacheManager.getPhasorContent(URLUtil.getClothShowSwf(this._itemId),"item",this.getSwfBack);
         }
      }
      
      private function getSwfBack(contentInfo:ContentInfo) : void
      {
         addChild(contentInfo.content);
      }
   }
}

