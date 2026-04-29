package com.module.magicSpirit.data
{
   import flash.utils.ByteArray;
   
   public class MagicSpiritUserInfo
   {
      
      private var _userid:uint;
      
      private var _level:uint;
      
      private var _exp:uint;
      
      private var _maxExp:uint;
      
      private var _hp:uint;
      
      private var _lastHpTime:uint;
      
      private var _governValues:uint;
      
      private var _bagSzie:uint;
      
      private var _nowTeam:uint;
      
      private var _teamArr:Array;
      
      public function MagicSpiritUserInfo(recData:ByteArray)
      {
         var arr:Array = null;
         super();
         this._userid = recData.readUnsignedInt();
         this._level = recData.readUnsignedByte();
         this._exp = recData.readUnsignedInt();
         this._maxExp = recData.readUnsignedInt();
         this._hp = recData.readUnsignedShort();
         this._lastHpTime = recData.readUnsignedInt();
         this._governValues = recData.readUnsignedShort();
         this._bagSzie = recData.readUnsignedShort();
         this._nowTeam = recData.readUnsignedByte();
         this._teamArr = new Array();
         for(var i:uint = 0; i < 5; i++)
         {
            arr = new Array();
            arr[0] = recData.readUnsignedInt();
            arr[1] = recData.readUnsignedInt();
            arr[2] = recData.readUnsignedInt();
            arr[3] = recData.readUnsignedInt();
            arr[4] = recData.readUnsignedInt();
            this._teamArr.push(arr);
         }
      }
      
      public function get level() : uint
      {
         return this._level;
      }
      
      public function get userid() : uint
      {
         return this._userid;
      }
      
      public function get nowTeamInfo() : Array
      {
         if(this._nowTeam > 0)
         {
            return this._teamArr[this._nowTeam - 1];
         }
         return null;
      }
      
      public function get hp() : uint
      {
         return this._hp;
      }
      
      public function get exp() : uint
      {
         return this._exp;
      }
      
      public function get maxExp() : uint
      {
         return this._maxExp;
      }
      
      public function get nowTeam() : uint
      {
         return this._nowTeam;
      }
      
      public function get bagSzie() : uint
      {
         return this._bagSzie;
      }
      
      public function get controlVal() : uint
      {
         return this._governValues;
      }
      
      public function getTeamByIndex(index:uint) : Array
      {
         if(this._nowTeam > 0)
         {
            return this._teamArr[index - 1];
         }
         return null;
      }
   }
}

