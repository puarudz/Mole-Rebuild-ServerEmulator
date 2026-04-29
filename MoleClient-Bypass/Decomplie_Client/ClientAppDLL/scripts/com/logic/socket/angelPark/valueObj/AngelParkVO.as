package com.logic.socket.angelPark.valueObj
{
   import com.global.staticData.XMLInfo;
   
   public class AngelParkVO
   {
      
      public static const MAX_LVL:int = 20;
      
      private var _angelList:Array;
      
      private var _aura:Number;
      
      private var _canSeedAgelCount:Number;
      
      private var _dressUpList:Array;
      
      private var _exp:Number;
      
      private var _high:int;
      
      private var _level:int;
      
      private var _showAngelId:int;
      
      private var _userId:Number;
      
      private var _isVip:Boolean = false;
      
      public function AngelParkVO()
      {
         super();
      }
      
      public function get showAngelId() : int
      {
         return this._showAngelId;
      }
      
      public function set showAngelId(value:int) : void
      {
         this._showAngelId = value;
      }
      
      public function get isVip() : Boolean
      {
         return this._isVip;
      }
      
      public function set isVip(value:Boolean) : void
      {
         this._isVip = value;
      }
      
      public function get angelList() : Array
      {
         return this._angelList;
      }
      
      public function set angelList(value:Array) : void
      {
         this._angelList = value;
      }
      
      public function get aura() : Number
      {
         return this._aura;
      }
      
      public function get lvlMaxAura() : Number
      {
         return this.GetMaxAuraByLvl(this.level);
      }
      
      public function GetMaxAuraByLvl(lvl:int) : Number
      {
         return 1920 + (lvl - 1) * 20 * 24;
      }
      
      public function set aura(value:Number) : void
      {
         this._aura = value;
      }
      
      public function get canSeedAgelCount() : Number
      {
         if(this.isVip)
         {
            return this._canSeedAgelCount - 3;
         }
         return this._canSeedAgelCount;
      }
      
      public function set canSeedAgelCount(value:Number) : void
      {
         this._canSeedAgelCount = value;
      }
      
      public function get dressUpList() : Array
      {
         return this._dressUpList;
      }
      
      public function set dressUpList(value:Array) : void
      {
         this._dressUpList = value;
      }
      
      public function get exp() : Number
      {
         return this._exp;
      }
      
      public function set exp(value:Number) : void
      {
         this._exp = value;
      }
      
      public function get high() : int
      {
         return this._high;
      }
      
      public function set high(value:int) : void
      {
         this._high = value;
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      public function set level(value:int) : void
      {
         this._level = value;
      }
      
      public function get userId() : Number
      {
         return this._userId;
      }
      
      public function set userId(value:Number) : void
      {
         this._userId = value;
      }
      
      public function get nextLvlNeedExp() : int
      {
         return this.nextLvlExp - this.exp;
      }
      
      public function get nextLvlExp() : int
      {
         var exp:int = 0;
         for(var i:int = 1; i <= this.level; i++)
         {
            exp += 15 * i + 50;
         }
         return exp;
      }
      
      public function get topLvlExp() : int
      {
         return 3800;
      }
      
      public function get isTopLvl() : Boolean
      {
         return this.level >= MAX_LVL;
      }
      
      public function get UnLockAngelCountInfo() : Object
      {
         var list:Array = XMLInfo.angelCountList;
         for(var i:int = this.level; i < list.length; i++)
         {
            if(list[i] > this.canSeedAgelCount)
            {
               return {
                  "level":i,
                  "count":list[i]
               };
            }
         }
         return {
            "level":this.level,
            "count":this.canSeedAgelCount
         };
      }
   }
}

