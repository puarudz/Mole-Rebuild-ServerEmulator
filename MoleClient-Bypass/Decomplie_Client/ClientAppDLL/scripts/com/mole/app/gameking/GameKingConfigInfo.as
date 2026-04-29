package com.mole.app.gameking
{
   import com.mole.config.info.Config;
   
   public class GameKingConfigInfo
   {
      
      private var _id:uint;
      
      private var _name:String;
      
      private var _honourList:Array;
      
      private var _scoreList:Array;
      
      private var _mapid:uint;
      
      private var _gamePath:String;
      
      private var _gameType:int;
      
      private var _chairID:int;
      
      private var _score:uint;
      
      public function GameKingConfigInfo(infoXml:XML)
      {
         super();
         this._id = infoXml.@ID;
         this._name = infoXml.@Name;
         this._honourList = String(infoXml.@HonourList).split(Config.SEPARATOR);
         this._scoreList = String(infoXml.@Score).split(Config.SEPARATOR);
         this._mapid = infoXml.@MapID;
         this._gamePath = infoXml.@GamePath;
         this._gameType = infoXml.@GameType;
         this._chairID = infoXml.@ChairID;
      }
      
      public function get score() : uint
      {
         return this._score;
      }
      
      public function get title() : String
      {
         var tmpScore:Number = NaN;
         for(var i:uint = 0; i < this._scoreList.length; i++)
         {
            tmpScore = Number(this._scoreList[i]);
            if(tmpScore > this._score)
            {
               return this._honourList[i - 1];
            }
         }
         return this._honourList[this._honourList.length - 1];
      }
      
      public function get isMax() : Boolean
      {
         var tmpScore:Number = NaN;
         for(var i:uint = 0; i < this._scoreList.length; i++)
         {
            tmpScore = Number(this._scoreList[i]);
            if(tmpScore >= this._score)
            {
               if(i == this._scoreList.length)
               {
                  return true;
               }
               return false;
            }
         }
         return true;
      }
      
      public function set score(value:uint) : void
      {
         this._score = value;
      }
      
      public function get scoreList() : Array
      {
         return this._scoreList;
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get honourList() : Array
      {
         return this._honourList;
      }
      
      public function get mapid() : uint
      {
         return this._mapid;
      }
      
      public function get gameType() : int
      {
         return this._gameType;
      }
      
      public function get gamePath() : String
      {
         return this._gamePath;
      }
      
      public function get chairID() : int
      {
         return this._chairID;
      }
   }
}

