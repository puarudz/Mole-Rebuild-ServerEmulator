package com.module.AngelsAndDemons.data
{
   public class AngelsAndDemonsData
   {
      
      private static var _instance:AngelsAndDemonsData;
      
      private var _barrierId:int = 1;
      
      private var _barrier_lvl:int = 1;
      
      private var _angel_arr:*;
      
      private var _props_arr:Array;
      
      private var _fight_lvl:int = 1;
      
      private var _bestResult_arr:Array;
      
      private var _exp:int = 0;
      
      private var _e_map:int = 0;
      
      private var _n_map:int = 0;
      
      private var _h_map:int = 0;
      
      private var _choose_Angels:Array;
      
      private var _over_obj:Object;
      
      private var _fightExp:int = 0;
      
      private var _award_arr:Array;
      
      private var _system:Array;
      
      public function AngelsAndDemonsData()
      {
         super();
      }
      
      public static function get instance() : AngelsAndDemonsData
      {
         if(!_instance)
         {
            _instance = new AngelsAndDemonsData();
         }
         return _instance;
      }
      
      public function get system() : Array
      {
         return this._system;
      }
      
      public function set system(value:Array) : void
      {
         this._system = value;
      }
      
      public function get fightExp() : int
      {
         return this._fightExp;
      }
      
      public function set fightExp(value:int) : void
      {
         this._fightExp = value;
      }
      
      public function get award_arr() : Array
      {
         return this._award_arr;
      }
      
      public function set award_arr(value:Array) : void
      {
         this._award_arr = value;
      }
      
      public function get over_obj() : Object
      {
         return this._over_obj;
      }
      
      public function set over_obj(value:Object) : void
      {
         this._over_obj = value;
      }
      
      public function get choose_Angels() : Array
      {
         return this._choose_Angels;
      }
      
      public function set choose_Angels(value:Array) : void
      {
         this._choose_Angels = value;
      }
      
      public function get e_map() : int
      {
         return this._e_map;
      }
      
      public function set e_map(value:int) : void
      {
         this._e_map = value;
      }
      
      public function get n_map() : int
      {
         return this._n_map;
      }
      
      public function set n_map(value:int) : void
      {
         this._n_map = value;
      }
      
      public function get h_map() : int
      {
         return this._h_map;
      }
      
      public function set h_map(value:int) : void
      {
         this._h_map = value;
      }
      
      public function get exp() : int
      {
         return this._exp;
      }
      
      public function set exp(value:int) : void
      {
         this._exp = value;
      }
      
      public function get barrierId() : int
      {
         return this._barrierId;
      }
      
      public function set barrierId(value:int) : void
      {
         this._barrierId = value;
      }
      
      public function get barrier_lvl() : int
      {
         return this._barrier_lvl;
      }
      
      public function set barrier_lvl(value:int) : void
      {
         this._barrier_lvl = value;
      }
      
      public function get angel_arr() : *
      {
         return this._angel_arr;
      }
      
      public function set angel_arr(value:*) : void
      {
         this._angel_arr = value;
      }
      
      public function get props_arr() : Array
      {
         return this._props_arr;
      }
      
      public function set props_arr(value:Array) : void
      {
         this._props_arr = value;
      }
      
      public function get fight_lvl() : int
      {
         return this._fight_lvl;
      }
      
      public function set fight_lvl(value:int) : void
      {
         this._fight_lvl = value;
      }
      
      public function get bestResult_arr() : Array
      {
         return this._bestResult_arr;
      }
      
      public function set bestResult_arr(value:Array) : void
      {
         this._bestResult_arr = value;
      }
   }
}

