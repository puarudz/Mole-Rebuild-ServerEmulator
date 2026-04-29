package com.mole.app.ui.control
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.tip.tip;
   import com.common.util.DisplayUtil;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class ScrollIcon extends Scroller
   {
      
      private var _iconScale:Number;
      
      public function ScrollIcon(panel:MovieClip, itemInfoArr:Array = null, maskRect:Rectangle = null, scrollTime:Number = 0.2, waitTime:Number = 0, stMax:Number = 0.6, showTip:Boolean = true, iconScale:Number = 1)
      {
         this._iconScale = iconScale;
         super(panel,itemInfoArr,maskRect,scrollTime,waitTime,stMax,showTip);
      }
      
      override protected function clickBtn(e:MouseEvent) : void
      {
         if(clickFunc == null)
         {
            beginShow();
         }
         else
         {
            clickFunc.apply(null,null);
         }
      }
      
      override protected function addElement() : void
      {
         var loader:Loader = null;
         var url:String = null;
         var container:Sprite = getContainer();
         DisplayUtil.removeForParent(container);
         container = new Sprite();
         container.name = conName;
         for(var i:int = 0; i < _itemArrLen; i++)
         {
            loader = new Loader();
            url = GoodsInfo.GetFullURLByItemId(_itemInfoArr[i].itemID);
            loader.load(VL.getURLRequest(url));
            _elementArr[i] = loader;
            container.addChild(loader);
            loader.scaleX = this._iconScale;
            loader.scaleY = this._iconScale;
            loader.y = -i * _elementH;
            if(_showTip)
            {
               tip.tipTailDisPlayObject(loader,_itemInfoArr[i].count + "個" + GoodsInfo.getItemNameByID(_itemInfoArr[i].itemID));
            }
         }
         _container.addChild(container);
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
   }
}

