package com.mole.app.info
{
   public class NPCInfo
   {
      
      private var _id:uint;
      
      private var _name:String;
      
      private var _sex:uint;
      
      private var _en_name:String;
      
      private var _movespeed:Number;
      
      private var _px:int;
      
      private var _py:int;
      
      public function NPCInfo()
      {
         super();
      }
      
      public function setBasicInfo(basicInfo:XML) : void
      {
         this._id = uint(basicInfo.@ID);
         this._name = basicInfo.@Name;
         this._sex = uint(basicInfo.@Sex);
         this._en_name = basicInfo.@EnName;
         this._movespeed = uint(basicInfo.@MoveSpeed);
      }
      
      public function setLocationInMap(px:int, py:int) : void
      {
         this._px = px;
         this._py = py;
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function get sex() : uint
      {
         return this._sex;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get en_name() : String
      {
         return this._en_name;
      }
      
      public function get movespeed() : Number
      {
         return this._movespeed;
      }
      
      public function get coordinateX() : int
      {
         return this._px;
      }
      
      public function get coordinateY() : int
      {
         return this._py;
      }
   }
}

