package com.module.treasureHouse.view
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.tip.tip;
   import com.global.staticData.XMLInfo;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TreasureItemCtl
   {
      
      private var _ui:MovieClip;
      
      private var _id:int = -1;
      
      private var _count:int;
      
      private var _btn:Sprite;
      
      private var _countTxt:TextField;
      
      public function TreasureItemCtl(ui:MovieClip)
      {
         super();
         this._ui = ui;
         this._countTxt = this._ui.num_txt;
      }
      
      public function get ui() : MovieClip
      {
         return this._ui;
      }
      
      public function Clear() : void
      {
         BC.removeEvent(this);
      }
      
      public function UpdateData(data:Object) : void
      {
         var loader:Loader = null;
         var path:String = null;
         this._ui.gotoAndStop(1);
         BC.removeEvent(this);
         if(data == null)
         {
            GC.clearAll(this._btn);
            this._btn = null;
            this._id = -1;
            this._count = -1;
            this._countTxt.text = "";
            return;
         }
         var id:int = int(data.itemId);
         this._count = data.count;
         if(id != this._id)
         {
            this._id = id;
            GC.clearAll(this._btn);
            this._btn = new Sprite();
            this._btn.graphics.beginFill(0,0);
            this._btn.graphics.drawRect(0,0,this._ui.width,this._ui.height);
            this._btn.graphics.endFill();
            this._ui.addChild(this._btn);
            this._ui.addChild(this._countTxt);
            loader = new Loader();
            path = GoodsInfo.GetFullURLByItemId(this._id);
            loader.load(VL.getURLRequest(path));
            this._btn.addChild(loader);
         }
         this.InitTip(this._btn);
         BC.addEvent(this,this._btn,MouseEvent.CLICK,this.OnMouseClick);
         BC.addEvent(this,this._btn,MouseEvent.MOUSE_OVER,this.OnMouseOver);
         BC.addEvent(this,this._btn,MouseEvent.MOUSE_OUT,this.OnMouseOut);
         this._countTxt.text = this._count.toString();
      }
      
      private function OnMouseOut(e:MouseEvent) : void
      {
         this._ui.gotoAndStop(1);
      }
      
      private function OnMouseOver(e:MouseEvent) : void
      {
         this._ui.gotoAndStop(2);
      }
      
      private function OnMouseClick(e:MouseEvent) : void
      {
         TreasureHouseDragCtl.StarDrag(-1,this._id);
      }
      
      private function InitTip(btn:Sprite) : void
      {
         var name:String = GoodsInfo.getItemNameByID(this._id);
         var tipstr:String = "";
         tipstr = "<b>" + name + "</b><br/>";
         var desc:String = "點擊後放入藏寶閣";
         if(Boolean(XMLInfo.itemTips[this._id]))
         {
            desc = XMLInfo.itemTips[this._id];
         }
         tipstr += "<font color=\'#1764D7\'>" + desc + "<font/><br/>";
         tipstr += "<font color=\'#5C4901\'>數量:" + this._count + "<font/>";
         tip.delTipTailDisPlayObject(btn);
         tip.tipTailDisPlayObject(btn,tipstr);
      }
   }
}

