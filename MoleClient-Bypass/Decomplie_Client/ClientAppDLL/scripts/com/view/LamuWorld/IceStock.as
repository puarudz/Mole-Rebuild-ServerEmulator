package com.view.LamuWorld
{
   import com.global.staticData.MapsConfig;
   import com.mole.app.map.MapManager;
   import com.view.FightWorld.FightWorld;
   import com.view.LamuWorld.attack.IAttackTarget;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class IceStock implements IAttackTarget
   {
      
      private var world:*;
      
      private var content:Sprite;
      
      public function IceStock(content:Sprite)
      {
         super();
         if(Boolean(MapsConfig.MapsInfo[MapManager.curMapID].isLamuWorld))
         {
            this.world = LamuWorld.getInstance();
         }
         else
         {
            this.world = FightWorld.getInstance();
         }
         this.content = content;
      }
      
      public function set lives(val:int) : void
      {
         this.world.lives = val;
      }
      
      public function get lives() : int
      {
         return this.world.lives;
      }
      
      public function get x() : Number
      {
         return this.content.x;
      }
      
      public function get y() : Number
      {
         return this.content.y;
      }
      
      public function get width() : Number
      {
         return this.content.width;
      }
      
      public function get height() : Number
      {
         return this.content.height;
      }
      
      public function behurt(hurt:Number = 1) : Object
      {
         var mc:MovieClip = this.world.behurt(hurt) as MovieClip;
         if(Boolean(mc))
         {
            mc.x = this.content.x;
            mc.y = this.content.y;
         }
         return null;
      }
      
      public function dead() : void
      {
         this.world.dead();
      }
   }
}

