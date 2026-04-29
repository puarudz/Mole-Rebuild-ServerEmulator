package com.module.digTreasure.data
{
   import com.event.EventTaomee;
   import com.logic.socket.digTreasure.DigTreasureSocket;
   import com.module.digTreasure.DigTreasureEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class DigTreasureData extends EventDispatcher
   {
      
      public static const MAX_LEVEL:int = 20;
      
      public static const MAX_EXP:int = 20844;
      
      private var _level:int;
      
      private var _maxHP:int;
      
      private var _hp:int;
      
      private var _exp:int;
      
      private var _maxExp:int;
      
      public function DigTreasureData()
      {
         super();
         BC.addEvent(this,GV.onlineSocket,"read_" + DigTreasureSocket.GetDigMapInfoCmd,this.GetMapDigTreasureInfoHandler);
         BC.addEvent(this,GV.onlineSocket,"read_" + DigTreasureSocket.DigAreaCmd,this.DigCmdHandler);
      }
      
      public static function GetMaxExpByLevel(lvl:int) : int
      {
         var exp:int = 48;
         for(var i:int = 2; i <= lvl; i++)
         {
            exp = exp + (i * i * 8 + 10) + 48;
         }
         if(lvl < MAX_LEVEL)
         {
            return exp;
         }
         return MAX_EXP;
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      public function get maxHP() : int
      {
         return this.GetMaxHPByLevel(this.level);
      }
      
      public function GetMaxHPByLevel(value:int) : int
      {
         return 36 + (value - 1) * 6;
      }
      
      public function get hp() : int
      {
         return this._hp;
      }
      
      public function set hp(value:int) : void
      {
         this._hp = value;
      }
      
      public function get exp() : int
      {
         if(this.level < MAX_LEVEL)
         {
            return this._exp;
         }
         return MAX_EXP;
      }
      
      public function get maxExp() : int
      {
         return GetMaxExpByLevel(this.level);
      }
      
      private function GetMapDigTreasureInfoHandler(e:EventTaomee) : void
      {
         this._level = e.EventObj.level;
         this._maxHP = this._hp = e.EventObj.hp;
         this._maxExp = this._exp = e.EventObj.exp;
         this.dispatchEvent(new Event(DigTreasureEvent.DigTreasureDataUpdate));
      }
      
      private function DigCmdHandler(e:EventTaomee) : void
      {
         this._maxHP = this._hp = e.EventObj.hp;
         this._maxExp = this._exp = e.EventObj.exp;
         if(Boolean(e.EventObj.isLevelUp))
         {
            ++this._level;
            this._hp = this.maxHP;
            this._maxExp = this.maxExp;
            this.dispatchEvent(new Event(DigTreasureEvent.DigTreasureLevelUp));
         }
         this.dispatchEvent(new Event(DigTreasureEvent.DigTreasureDataUpdate));
      }
      
      public function Clear() : void
      {
         BC.removeEvent(this);
      }
   }
}

