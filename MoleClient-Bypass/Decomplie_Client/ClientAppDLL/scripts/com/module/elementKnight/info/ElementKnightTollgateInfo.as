package com.module.elementKnight.info
{
   public class ElementKnightTollgateInfo
   {
      
      private var _id:uint;
      
      private var _name:String;
      
      private var _experience:uint;
      
      private var _strength:uint;
      
      private var _type:uint;
      
      private var _isVip:Boolean;
      
      private var _openTime:Array;
      
      private var _recommandFighting:uint;
      
      private var _introduce:String;
      
      private var _fightLength:uint;
      
      private var _bonus:String;
      
      private var _fightList:Vector.<ElementKnightTollgateFightInfo>;
      
      private var _exploit:uint;
      
      public function ElementKnightTollgateInfo(xml:XML)
      {
         var tollgateFightInfo:ElementKnightTollgateFightInfo = null;
         var fightXML:XML = null;
         super();
         this._id = uint(xml.@ID);
         this._name = String(xml.@Name);
         this._experience = uint(xml.@exp);
         this._strength = uint(xml.@power);
         this._type = uint(xml.@type);
         this._isVip = Boolean(xml.@vip == 1);
         this._recommandFighting = uint(xml.@recommend);
         this._introduce = String(xml.@about);
         this._bonus = String(xml.@Bonus);
         this._exploit = uint(xml.@exploit);
         this._fightList = new Vector.<ElementKnightTollgateFightInfo>();
         for each(fightXML in xml.fights.fight)
         {
            tollgateFightInfo = new ElementKnightTollgateFightInfo(fightXML);
            this._fightList.push(tollgateFightInfo);
            ++this._fightLength;
         }
         this._openTime = [];
         this.setOpenTime(String(xml.@open));
      }
      
      private function setOpenTime(str:String) : void
      {
         var arr:Array = str.split(" ");
         for(var i:int = 0; i < arr.length; i++)
         {
            if(arr[i] != null)
            {
               this._openTime.push(arr[i]);
            }
         }
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get experience() : uint
      {
         return this._experience;
      }
      
      public function get strength() : uint
      {
         return this._strength;
      }
      
      public function get type() : uint
      {
         return this._type;
      }
      
      public function get isVip() : Boolean
      {
         return this._isVip;
      }
      
      public function get openTime() : Array
      {
         return this._openTime;
      }
      
      public function get recommandFighting() : uint
      {
         return this._recommandFighting;
      }
      
      public function get introduce() : String
      {
         return this._introduce;
      }
      
      public function get fightLength() : uint
      {
         return this._fightLength;
      }
      
      public function get fightList() : Vector.<ElementKnightTollgateFightInfo>
      {
         return this._fightList;
      }
      
      public function get bonus() : String
      {
         return this._bonus;
      }
      
      public function get exploit() : uint
      {
         return this._exploit;
      }
      
      public function getFightInfoByID(wave:uint) : ElementKnightTollgateFightInfo
      {
         var fightInfo:ElementKnightTollgateFightInfo = null;
         for(var i:int = 0; i < this._fightLength; i++)
         {
            fightInfo = this.fightList[i];
            if(fightInfo.lifeId == wave)
            {
               return fightInfo;
            }
         }
         return null;
      }
   }
}

