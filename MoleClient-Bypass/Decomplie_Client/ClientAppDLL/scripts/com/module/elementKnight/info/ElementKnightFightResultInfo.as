package com.module.elementKnight.info
{
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   public class ElementKnightFightResultInfo
   {
      
      private static const SKILL_LIST:Array = [5001,5002,5003,5004,5005,5006,5007,5008,5009,5010,5011,5012,5013,5014];
      
      public static const PVP:uint = 1;
      
      public static const PVE:uint = 0;
      
      public static const ATTACK:uint = 0;
      
      public static const DEFENSE:uint = 1;
      
      private var _fightType:uint;
      
      private var _isPVPReplay:Boolean;
      
      private var _identity:uint;
      
      private var _result:uint;
      
      private var _strength:uint;
      
      private var _myAttack:uint;
      
      private var _myDefense:uint;
      
      private var _enemyAttack:uint;
      
      private var _enemyDefense:uint;
      
      private var _currentWave:uint;
      
      private var _exprience:uint;
      
      private var _selfCardList:Vector.<Vector.<uint>>;
      
      private var _rewardList:Vector.<Vector.<uint>>;
      
      private var _enemyCardList:Vector.<Vector.<uint>>;
      
      private var _selfAttribute:uint;
      
      private var _enemyAttribute:uint;
      
      private var _selfName:String = "";
      
      private var _enemyName:String = "";
      
      private var _enemyId:uint;
      
      private var _addStrength:uint;
      
      private var _dictionary:Dictionary;
      
      public function ElementKnightFightResultInfo()
      {
         super();
         this._dictionary = new Dictionary();
         var len:int = int(SKILL_LIST.length);
         for(var i:int = 0; i < len; i++)
         {
            this._dictionary[SKILL_LIST[i]] = SKILL_LIST[i];
         }
      }
      
      public function pveFightResult(recData:ByteArray) : void
      {
         var cardVec:Vector.<uint> = null;
         var skill:uint = 0;
         var rewardVec:Vector.<uint> = null;
         var enemyVec:Vector.<uint> = null;
         this._fightType = PVE;
         this._result = recData.readUnsignedInt();
         this._strength = recData.readUnsignedInt();
         this._myAttack = recData.readUnsignedInt();
         this._myDefense = recData.readUnsignedInt();
         this._enemyAttack = recData.readUnsignedInt();
         this._enemyDefense = recData.readUnsignedInt();
         this._currentWave = recData.readUnsignedInt();
         this._exprience = recData.readUnsignedInt();
         this._addStrength = recData.readUnsignedInt();
         var _cardCount:uint = recData.readUnsignedInt();
         this._selfCardList = new Vector.<Vector.<uint>>();
         for(var i:int = 0; i < _cardCount; i++)
         {
            cardVec = new Vector.<uint>();
            cardVec.push(recData.readUnsignedInt());
            skill = recData.readUnsignedInt();
            if(this._dictionary[skill] != null)
            {
               skill = 0;
            }
            cardVec.push(skill);
            this._selfCardList.push(cardVec);
         }
         var _rewardCount:uint = 1;
         this._rewardList = new Vector.<Vector.<uint>>();
         for(var j:int = 0; j < _rewardCount; j++)
         {
            rewardVec = new Vector.<uint>();
            rewardVec.push(recData.readUnsignedInt());
            rewardVec.push(recData.readUnsignedInt());
            this._rewardList.push(rewardVec);
         }
         this._enemyCardList = new Vector.<Vector.<uint>>();
         var _enemyCount:uint = recData.readUnsignedInt();
         for(var ix:int = 0; ix < _enemyCount; ix++)
         {
            enemyVec = new Vector.<uint>();
            enemyVec.push(recData.readUnsignedInt());
            skill = recData.readUnsignedInt();
            if(this._dictionary[skill] != null)
            {
               skill = 0;
            }
            enemyVec.push(skill);
            this._enemyCardList.push(enemyVec);
         }
      }
      
      public function pvpFightResult(recData:ByteArray) : void
      {
         var cardVec:Vector.<uint> = null;
         var skill:uint = 0;
         var enemyVec:Vector.<uint> = null;
         this._fightType = PVP;
         this._isPVPReplay = false;
         this._identity = recData.readUnsignedInt();
         this._result = recData.readUnsignedInt();
         this._myAttack = recData.readUnsignedInt();
         this._myDefense = recData.readUnsignedInt();
         this._enemyAttribute = recData.readUnsignedInt();
         this._enemyAttack = recData.readUnsignedInt();
         this._enemyDefense = recData.readUnsignedInt();
         var _cardCount:uint = recData.readUnsignedInt();
         this._selfCardList = new Vector.<Vector.<uint>>();
         for(var i:int = 0; i < _cardCount; i++)
         {
            cardVec = new Vector.<uint>();
            cardVec.push(recData.readUnsignedInt());
            skill = recData.readUnsignedInt();
            if(this._dictionary[skill] != null)
            {
               skill = 0;
            }
            cardVec.push(skill);
            this._selfCardList.push(cardVec);
         }
         this._enemyName = recData.readUTFBytes(16);
         this._enemyCardList = new Vector.<Vector.<uint>>();
         var _enemyCount:uint = recData.readUnsignedInt();
         for(var ix:int = 0; ix < _enemyCount; ix++)
         {
            enemyVec = new Vector.<uint>();
            enemyVec.push(recData.readUnsignedInt());
            skill = recData.readUnsignedInt();
            if(this._dictionary[skill] != null)
            {
               skill = 0;
            }
            enemyVec.push(skill);
            this._enemyCardList.push(enemyVec);
         }
      }
      
      public function pvpFightReplayResult(recData:ByteArray) : void
      {
         var cardVec:Vector.<uint> = null;
         var skill:uint = 0;
         var enemyVec:Vector.<uint> = null;
         this._fightType = PVP;
         this._isPVPReplay = true;
         this._identity = recData.readUnsignedInt();
         this._result = recData.readUnsignedInt();
         this._myAttack = recData.readUnsignedInt();
         this._myDefense = recData.readUnsignedInt();
         var _cardCount:uint = recData.readUnsignedInt();
         this._selfCardList = new Vector.<Vector.<uint>>();
         for(var i:int = 0; i < _cardCount; i++)
         {
            cardVec = new Vector.<uint>();
            cardVec.push(recData.readUnsignedInt());
            skill = recData.readUnsignedInt();
            if(this._dictionary[skill] != null)
            {
               skill = 0;
            }
            cardVec.push(skill);
            this._selfCardList.push(cardVec);
         }
         this._enemyId = recData.readUnsignedInt();
         this._enemyAttribute = recData.readUnsignedInt();
         this._enemyName = recData.readUTFBytes(16);
         this._enemyAttack = recData.readUnsignedInt();
         this._enemyDefense = recData.readUnsignedInt();
         this._enemyCardList = new Vector.<Vector.<uint>>();
         var _enemyCount:uint = recData.readUnsignedInt();
         for(var ix:int = 0; ix < _enemyCount; ix++)
         {
            enemyVec = new Vector.<uint>();
            enemyVec.push(recData.readUnsignedInt());
            skill = recData.readUnsignedInt();
            if(this._dictionary[skill] != null)
            {
               skill = 0;
            }
            enemyVec.push(skill);
            this._enemyCardList.push(enemyVec);
         }
      }
      
      public function setAttribute(selfName:String = "", enemyName:String = "", selfAttribute:uint = 0, enemyAttribute:uint = 0) : void
      {
         if(selfName != "")
         {
            this._selfName = selfName;
         }
         if(enemyName != "")
         {
            this._enemyName = enemyName;
         }
         if(selfAttribute != 0)
         {
            this._selfAttribute = selfAttribute;
         }
         if(enemyAttribute != 0)
         {
            this._enemyAttribute = enemyAttribute;
         }
      }
      
      public function get fightType() : uint
      {
         return this._fightType;
      }
      
      public function get isPVPReplay() : Boolean
      {
         return this._isPVPReplay;
      }
      
      public function get identity() : uint
      {
         return this._identity;
      }
      
      public function get result() : uint
      {
         return this._result;
      }
      
      public function get strength() : uint
      {
         return this._strength;
      }
      
      public function get selfAttack() : uint
      {
         return this._myAttack;
      }
      
      public function get selfDefense() : uint
      {
         return this._myDefense;
      }
      
      public function get enemyAttack() : uint
      {
         return this._enemyAttack;
      }
      
      public function get enemyDefense() : uint
      {
         return this._enemyDefense;
      }
      
      public function get fightWave() : uint
      {
         return this._currentWave;
      }
      
      public function get exprience() : uint
      {
         return this._exprience;
      }
      
      public function get selfCardList() : Vector.<Vector.<uint>>
      {
         return this._selfCardList;
      }
      
      public function get enemyCardList() : Vector.<Vector.<uint>>
      {
         return this._enemyCardList;
      }
      
      public function get rewardList() : Vector.<Vector.<uint>>
      {
         return this._rewardList;
      }
      
      public function get selfAttribute() : uint
      {
         return this._selfAttribute;
      }
      
      public function get enemyAttribute() : uint
      {
         return this._enemyAttribute;
      }
      
      public function get selfName() : String
      {
         return this._selfName;
      }
      
      public function get enemyName() : String
      {
         return this._enemyName;
      }
      
      public function get enemyId() : uint
      {
         return this._enemyId;
      }
      
      public function get addStrength() : uint
      {
         return this._addStrength;
      }
   }
}

