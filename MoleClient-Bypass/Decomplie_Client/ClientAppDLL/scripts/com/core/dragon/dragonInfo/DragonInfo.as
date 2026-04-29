package com.core.dragon.dragonInfo
{
   public class DragonInfo
   {
      
      public var Name:String;
      
      public var Type:int;
      
      public var UserID:int;
      
      public var DragonID:int;
      
      public var ItemID:int;
      
      public var NickName:String;
      
      public var Growth:int;
      
      public var State:int;
      
      public var Count:int;
      
      public var DragonHeight1:int;
      
      public var DragonHeight2:int;
      
      public var GrowthMax:int;
      
      public var CardAttribute:Array;
      
      public var CardValue1:int;
      
      public var CardValue2:int;
      
      public var Life1:int;
      
      public var Life2:int;
      
      public var Speed1:int;
      
      public var Speed2:int;
      
      public var LeftTime:int;
      
      public function DragonInfo(infoObj:Object)
      {
         var name:String = null;
         super();
         for(name in infoObj)
         {
            try
            {
               this[name] = infoObj[name];
            }
            catch(E:Error)
            {
            }
         }
         this.DragonID = this.ItemID;
      }
   }
}

