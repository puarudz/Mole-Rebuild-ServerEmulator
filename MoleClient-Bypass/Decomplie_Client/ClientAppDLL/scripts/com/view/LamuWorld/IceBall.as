package com.view.LamuWorld
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class IceBall
   {
      
      public var content:Sprite;
      
      private var _canMove:Boolean;
      
      private var parentMC:Sprite;
      
      private var oldParent:Sprite;
      
      private var speed:Point;
      
      private var interval:Point;
      
      private var boss:MovieClip;
      
      public function IceBall(c:Sprite, parentMC:Sprite)
      {
         super();
         this.content = c;
         this.oldParent = c.parent as Sprite;
         this._canMove = false;
         this.parentMC = parentMC;
         this.interval = new Point();
         this.interval.x = this.oldParent.y - this.content.height / 2;
         this.interval.y = this.oldParent.y + 21 - this.content.height / 2;
         this.boss = parentMC.getChildByName("zhangyu") as MovieClip;
      }
      
      public function set canMove(b:Boolean) : void
      {
         this._canMove = b;
         if(b)
         {
            this.speed = new Point();
            this.speed.x = int(Math.random() * 5 + 3) * (Math.random() > 0.5 ? -2 : 2);
            this.speed.y = -int(Math.random() * 5 + 3);
            this.content.x += this.oldParent.x;
            this.content.y += this.oldParent.y;
            this.parentMC.addChild(this.content);
         }
      }
      
      public function get isMove() : Boolean
      {
         return this._canMove;
      }
      
      public function set place(p:Point) : void
      {
         this.content.x = p.x;
         this.content.y = p.y;
      }
      
      public function updata() : void
      {
         var ty:Number = NaN;
         var spr:Sprite = null;
         var head:Sprite = null;
         if(!this._canMove)
         {
            return;
         }
         if(this.content.x < this.content.width / 2 || this.content.x > 960 - this.content.width / 2)
         {
            this.speed.x *= -1;
         }
         var mc:MovieClip = this.oldParent.getChildAt(0) as MovieClip;
         if(this.content.y < this.content.height / 2)
         {
            this.speed.y *= -1;
         }
         else if(this.content.y > 560 - this.content.height / 2)
         {
            this.content.dispatchEvent(new Event("level"));
         }
         else if(this.content.y >= this.interval.x && this.content.y <= this.interval.y)
         {
            ty = this.content.y + this.content.height / 2;
            if(ty <= this.oldParent.y && ty + this.speed.y >= this.oldParent.y && this.content.x + this.speed.x >= this.oldParent.x - this.oldParent.width / 2 && this.content.x + this.speed.x <= this.oldParent.x + this.oldParent.width / 2)
            {
               this.speed.y = -int(Math.random() * 5 + 3);
               this.speed.x = (this.content.x - this.oldParent.x) / 3;
               if(Boolean(mc))
               {
                  mc.gotoAndStop(2);
               }
            }
         }
         else if(this.content.y >= 50 - this.content.height / 2 && this.content.y <= 154 + this.content.height / 2)
         {
            spr = this.boss.getChildAt(0) as Sprite;
            head = spr.getChildByName("head") as Sprite;
            if(Boolean(head) && head.hitTestObject(this.content))
            {
               this.content.dispatchEvent(new Event("tohurt"));
               this.speed.y *= -1;
               if(Boolean(mc))
               {
                  mc.gotoAndStop(3);
               }
               return;
            }
         }
         this.content.x += this.speed.x;
         this.content.y += this.speed.y;
      }
      
      public function removed() : void
      {
         if(Boolean(this.content.parent))
         {
            this.content.parent.removeChild(this.content);
         }
      }
   }
}

