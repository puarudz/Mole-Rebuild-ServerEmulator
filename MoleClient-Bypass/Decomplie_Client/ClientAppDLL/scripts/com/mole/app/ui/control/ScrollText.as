package com.mole.app.ui.control
{
   import com.common.util.DisplayUtil;
   import com.mole.app.map.MapManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class ScrollText extends Scroller
   {
      
      private var _tformat:TextFormat = new TextFormat(null,null,0);
      
      private var _filters:Array = [];
      
      public function ScrollText(panel:MovieClip, itemInfoArr:Array = null, maskRect:Rectangle = null, scrollTime:Number = 1, waitTime:Number = 5, stMax:Number = 1, showTip:Boolean = false)
      {
         super(panel,itemInfoArr,maskRect,scrollTime,waitTime,stMax,showTip);
      }
      
      override protected function clickBtn(e:MouseEvent) : void
      {
         if(clickFunc == null)
         {
            if(_itemInfoArr[_elementIndex].targetMap != undefined)
            {
               MapManager.enterMap(_itemInfoArr[_elementIndex].targetMap);
            }
         }
         else
         {
            clickFunc.apply(null,null);
         }
      }
      
      override protected function addElement() : void
      {
         var txt:TextField = null;
         var container:Sprite = getContainer();
         DisplayUtil.removeForParent(container);
         container = new Sprite();
         container.name = conName;
         for(var i:int = 0; i < _itemArrLen; i++)
         {
            txt = new TextField();
            txt.autoSize = TextFieldAutoSize.CENTER;
            txt.text = _itemInfoArr[i].text;
            txt.selectable = false;
            _elementArr[i] = txt;
            txt.setTextFormat(this._tformat);
            txt.filters = this._filters;
            container.addChild(txt);
            txt.y = -i * _elementH;
            txt.x = -txt.width / 2;
         }
         _container.addChild(container);
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
      
      public function setTextFormat(textFormat:TextFormat) : void
      {
         var i:int = 0;
         var txt:TextField = null;
         this._tformat = textFormat;
         var len:int = int(_elementArr.length);
         if(len > 0)
         {
            for(i = 0; i < len; i++)
            {
               txt = _elementArr[i];
               if(txt != null)
               {
                  txt.setTextFormat(textFormat);
               }
            }
         }
      }
      
      public function setTextFilers(filters:Array) : void
      {
         var i:int = 0;
         var txt:TextField = null;
         this._filters = filters;
         var len:int = int(_elementArr.length);
         if(len > 0)
         {
            for(i = 0; i < len; i++)
            {
               txt = _elementArr[i];
               if(txt != null)
               {
                  txt.filters = filters;
               }
            }
         }
      }
   }
}

