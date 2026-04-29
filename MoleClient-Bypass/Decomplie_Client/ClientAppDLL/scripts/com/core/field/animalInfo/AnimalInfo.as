package com.core.field.animalInfo
{
   public dynamic class AnimalInfo
   {
      
      public var NO:int;
      
      public var ID:int;
      
      public var Flag:int;
      
      public var Value:int;
      
      public var Eat_time:int;
      
      public var Drink_time:int;
      
      public var Output_count:int;
      
      public var Output_time:int;
      
      public var Update_time:int;
      
      public var Mature_time:int;
      
      public var Type:int;
      
      public var FriendTime:int;
      
      public var FriendNum:int;
      
      public var Outgo:int;
      
      public var typeObject:Object;
      
      public var id:int;
      
      public var name:String;
      
      public var price:int;
      
      public var Class:String;
      
      public var LevelArray:Array;
      
      public var quantifier:String;
      
      public var Fruit:int;
      
      public var growth:int;
      
      public var water:int;
      
      public var speed:Number;
      
      public var floatSpeed:Number;
      
      public var floatMoveTime:Number;
      
      public var baseMoveTime:int;
      
      public var acedia:int;
      
      public var FruitNum:int;
      
      public var canFollow:int;
      
      public var Diff_mature_time:int;
      
      public var PollinationNum:int;
      
      public var Food:int;
      
      public var starLvl:int;
      
      public function AnimalInfo(infoObj:Object)
      {
         var name:String = null;
         super();
         for(name in infoObj)
         {
            try
            {
               this[name] = infoObj[name];
            }
            catch(err:Error)
            {
               trace("AnimalInfo缺少關鍵字:",name);
            }
         }
      }
   }
}

