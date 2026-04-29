package com.mole.app.ui
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.tip.tip;
   import com.common.util.DisplayUtil;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import flash.display.Loader;
   import flash.display.Sprite;
   
   public class LoaderItemIcon
   {
      
      public static const NONE_ICON:int = -1;
      
      protected var _iconCon:Sprite;
      
      private var _icon_mc:Sprite;
      
      private var _scale:Number;
      
      private var _showTips:Boolean;
      
      private var _iconID:int = -1;
      
      private var _resID:uint;
      
      public function LoaderItemIcon(iconCon:Sprite, scale:Number = 1, showTips:Boolean = true)
      {
         super();
         this._iconCon = iconCon;
         this._scale = scale;
         this._showTips = showTips;
         this._icon_mc = new Sprite();
         if(Boolean(this._iconCon))
         {
            this._iconCon.addChild(this._icon_mc);
         }
      }
      
      public function setIconID(iconID:int = -1) : void
      {
         var url:String = null;
         DownLoadManager.remove(this._resID);
         DisplayUtil.removeAllChild(this._icon_mc);
         tip.delTipTailDisPlayObject(this._iconCon);
         if(iconID != NONE_ICON)
         {
            if(this._showTips)
            {
               tip.tipTailDisPlayObject(this._iconCon,GoodsInfo.getItemNameByID(iconID));
            }
            url = GoodsInfo.GetFullURLByItemId(iconID);
            this._resID = DownLoadManager.add(url,ResType.DISPLAY_OBJECT);
            DownLoadManager.addEvent(this._resID,this.onLoadIconComplete);
            this._iconID = iconID;
         }
      }
      
      protected function updateIcon(icon_loader:Loader) : void
      {
         DisplayUtil.removeAllChild(this._icon_mc);
         if(Boolean(icon_loader))
         {
            if(this._iconID >= 1720001 && this._iconID <= 1729999)
            {
               icon_loader.scaleX = icon_loader.scaleY = 1;
            }
            else
            {
               icon_loader.scaleX = icon_loader.scaleY = this._scale;
               icon_loader.x += 10;
               icon_loader.y += 5;
            }
            this._icon_mc.addChild(icon_loader);
         }
      }
      
      private function onLoadIconComplete(e:DownLoadEvent) : void
      {
         this.updateIcon(e.loader);
      }
      
      public function clear() : void
      {
         DownLoadManager.remove(this._resID);
         DisplayUtil.removeAllChild(this._icon_mc);
         tip.delTipTailDisPlayObject(this._iconCon);
         this._iconID = -1;
      }
      
      public function destroy() : void
      {
         DisplayUtil.removeAllChild(this._icon_mc);
         DownLoadManager.remove(this._resID);
         DisplayUtil.removeForParent(this._icon_mc);
         this._icon_mc = null;
         this._iconCon = null;
      }
      
      public function get iconCon() : Sprite
      {
         return this._iconCon;
      }
      
      public function get iconId() : uint
      {
         return this._iconID;
      }
   }
}

