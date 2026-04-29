package com.module.elementKnight.info
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.module.elementKnight.ElementCardManager;
   import com.module.elementKnight.constant.ElementKnightCardXMLInfo;
   import flash.utils.ByteArray;
   
   public class ElementKnightCardInfo
   {
      
      public var id:uint;
      
      public var staticId:uint;
      
      public var cardExp:uint;
      
      private var _lv:uint;
      
      public var cardStatus:uint;
      
      public var leftExp:int;
      
      public function ElementKnightCardInfo(input:ByteArray = null)
      {
         super();
         if(Boolean(input))
         {
            this.id = input.readUnsignedInt();
            this.staticId = input.readUnsignedInt();
            this.cardExp = input.readUnsignedInt();
            this.cardStatus = input.readUnsignedInt();
         }
      }
      
      public function get staticInfo() : ElementKnightCardXMLInfo
      {
         var obj:Object = GoodsInfo.getInfoById(this.staticId);
         var staticInfo:ElementKnightCardXMLInfo = new ElementKnightCardXMLInfo();
         if(Boolean(obj))
         {
            staticInfo.staticId = this.staticId;
            staticInfo.name = obj.name;
            staticInfo.race = obj.race;
            staticInfo.type = obj.type;
            staticInfo.star = obj.star;
            staticInfo.advanceId = obj.advanceId;
            staticInfo.minAtk = obj.minAtk;
            staticInfo.maxAtk = obj.maxAtk;
            staticInfo.minDef = obj.minDef;
            staticInfo.maxDef = obj.maxDef;
            staticInfo.minAtkGrw = obj.minAtkGrw;
            staticInfo.maxAtkGrw = obj.maxAtkGrw;
            staticInfo.minDefGrw = obj.minDefGrw;
            staticInfo.maxDefGrw = obj.maxDefGrw;
         }
         return staticInfo;
      }
      
      public function get lv() : uint
      {
         var expArr:Array = null;
         var ix:int = 0;
         if(this._lv == 0)
         {
            expArr = ElementCardManager.KNIGHT_CARD_LV_EXP[this.staticInfo.star - 1];
            this.leftExp = this.cardExp;
            for(ix = 0; ix < expArr.length; ix++)
            {
               this.leftExp -= expArr[ix];
               if(this.leftExp < 0 || ix == expArr.length - 1)
               {
                  this._lv = ix;
                  break;
               }
            }
         }
         return this._lv;
      }
      
      public function updateLv(exp:uint) : void
      {
         this.cardExp += exp;
         this._lv = 0;
         this.lv;
      }
      
      public function get needExp() : uint
      {
         var expTotal:uint = 0;
         var exp:int = 0;
         var ix:int = 0;
         var expArr:Array = ElementCardManager.KNIGHT_CARD_LV_EXP[this.staticInfo.star - 1];
         if(this._lv == expArr.length - 1)
         {
            return 0;
         }
         for(ix = 0; ix < this._lv; ix++)
         {
            expTotal += expArr[ix];
         }
         return expArr[this._lv] - (this.cardExp - expTotal);
      }
      
      public function get nextLevelExp() : uint
      {
         var expArr:Array = ElementCardManager.KNIGHT_CARD_LV_EXP[this.staticInfo.star - 1];
         if(this._lv == expArr.length - 1)
         {
            return 0;
         }
         return expArr[this._lv];
      }
      
      public function get minAtk() : uint
      {
         return this.staticInfo.minAtk + (this.lv - 1) * this.staticInfo.minAtkGrw;
      }
      
      public function get maxAtk() : uint
      {
         return this.staticInfo.maxAtk + (this.lv - 1) * this.staticInfo.maxAtkGrw;
      }
      
      public function get minDef() : uint
      {
         return this.staticInfo.minDef + (this.lv - 1) * this.staticInfo.minDefGrw;
      }
      
      public function get maxDef() : uint
      {
         return this.staticInfo.maxDef + (this.lv - 1) * this.staticInfo.maxDefGrw;
      }
   }
}

