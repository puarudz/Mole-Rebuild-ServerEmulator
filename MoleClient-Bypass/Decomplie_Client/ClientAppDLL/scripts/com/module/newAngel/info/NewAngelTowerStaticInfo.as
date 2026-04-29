package com.module.newAngel.info
{
   import flash.geom.Point;
   
   public class NewAngelTowerStaticInfo
   {
      
      public var id:uint;
      
      public var name:String;
      
      public var atkFrame:uint;
      
      public var type:uint;
      
      public var atkType:uint;
      
      public var bulletPos:Point;
      
      public var bulletSpeed:Number;
      
      public var bulletMoveType:uint;
      
      public var isFollow:Boolean;
      
      public var isRota:Boolean;
      
      public function NewAngelTowerStaticInfo(xml:XML)
      {
         super();
         this.id = uint(xml.@id);
         this.name = String(xml.@name);
         this.atkFrame = uint(xml.@atkFrame);
         this.type = uint(xml.@type);
         this.atkType = uint(xml.@atkType);
         this.bulletPos = new Point(int(xml.@bulletX),int(xml.@bulletY));
         this.bulletSpeed = Number(xml.@bulletSpeed);
         this.bulletMoveType = uint(xml.@bulletMoveType);
         this.isFollow = uint(xml.@isFollow) == 1;
         this.isRota = uint(xml.@isRota) == 1;
      }
   }
}

