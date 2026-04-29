package com.mole.app.ui
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.tip.tip;
   import com.event.EventTaomee;
   import com.view.player.ClothConstant;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   
   public class TransfigurationShowPanel extends Sprite
   {
      
      public static const PUT_OUT:String = "PUT_OUT";
      
      private var icoVec:Vector.<RolePrevIco>;
      
      private var modeIco:RolePrevIco;
      
      private var modeIndex:uint = 1;
      
      private var _canSelect:Boolean = false;
      
      public function TransfigurationShowPanel(canSelect:Boolean = false)
      {
         super();
         this.icoVec = new Vector.<RolePrevIco>();
         var ico:RolePrevIco = new RolePrevIco(ClothConstant.WING);
         addChild(ico);
         this.modeIco = new RolePrevIco(0);
         addChild(this.modeIco);
         ico = new RolePrevIco(ClothConstant.HEAD);
         this.icoVec.push(ico);
         addChild(ico);
         ico = new RolePrevIco(ClothConstant.FACE);
         this.icoVec.push(ico);
         addChild(ico);
         ico = new RolePrevIco(ClothConstant.BODY);
         this.icoVec.push(ico);
         addChild(ico);
         ico = new RolePrevIco(ClothConstant.DECORATION);
         this.icoVec.push(ico);
         addChild(ico);
         this._canSelect = canSelect;
      }
      
      private function addEvents() : void
      {
         var ico:RolePrevIco = null;
         for each(ico in this.icoVec)
         {
            if(ico.itemID > 1000)
            {
               ico.buttonMode = true;
               tip.tipTailDisPlayObject(ico,GoodsInfo.getItemNameByID(ico.itemID));
               ico.addEventListener(MouseEvent.CLICK,this.clickIco);
               ico.addEventListener(MouseEvent.MOUSE_OVER,this.onOverIco);
               ico.addEventListener(MouseEvent.MOUSE_OUT,this.onOutIco);
            }
         }
      }
      
      private function onOverIco(e:MouseEvent) : void
      {
         var ico:RolePrevIco = e.currentTarget as RolePrevIco;
         ico.filters = [new GlowFilter(16777215,2,5,5,50)];
      }
      
      private function onOutIco(e:MouseEvent) : void
      {
         var ico:RolePrevIco = e.currentTarget as RolePrevIco;
         ico.filters = [];
      }
      
      private function clickIco(evt:MouseEvent) : void
      {
         var clickIco:RolePrevIco = evt.currentTarget as RolePrevIco;
         dispatchEvent(new EventTaomee(PUT_OUT,{
            "itemId":clickIco.itemID,
            "type":clickIco.type
         }));
         clickIco.clear();
      }
      
      public function modeType(prefesstion:uint) : void
      {
         var ico:RolePrevIco = null;
         this.modeIco.itemID = prefesstion;
         this.modeIndex = prefesstion;
         for each(ico in this.icoVec)
         {
            if(ico.type == ClothConstant.FACE && ico.itemID == -1)
            {
               ico.itemID = 100 + this.modeIndex;
            }
         }
      }
      
      public function updateCloth(arr:Array) : void
      {
         var flag:Boolean = false;
         var ico:RolePrevIco = null;
         var cloth:Object = null;
         for each(ico in this.icoVec)
         {
            flag = false;
            for each(cloth in arr)
            {
               if(cloth.layer == ico.type && cloth.ItemID != 0)
               {
                  flag = true;
                  ico.itemID = cloth.ItemID;
                  break;
               }
            }
            if(!flag)
            {
               ico.clear();
            }
         }
         for each(ico in this.icoVec)
         {
            if(ico.type == ClothConstant.FACE && ico.itemID == -1)
            {
               ico.itemID = 100 + this.modeIndex;
            }
         }
         if(this._canSelect)
         {
            this.addEvents();
         }
      }
      
      public function destroy() : void
      {
         var ico:RolePrevIco = null;
         for each(ico in this.icoVec)
         {
            ico.removeEventListener(MouseEvent.CLICK,this.clickIco);
            ico.removeEventListener(MouseEvent.MOUSE_OVER,this.onOverIco);
            ico.removeEventListener(MouseEvent.MOUSE_OUT,this.onOutIco);
            ico.clear();
            removeChild(ico);
         }
         this.icoVec = null;
      }
   }
}

