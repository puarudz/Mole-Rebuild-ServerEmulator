package com.view.LamuWorld.attack
{
   import com.core.MainManager;
   import com.logic.FindPathLogic.MoveTo;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class TreeAttack extends HitAttack
   {
      
      public function TreeAttack()
      {
         super();
      }
      
      private function getGenXu() : MovieClip
      {
         var tempClass:Class = GV.Lib_Map.getClass("GenXu") as Class;
         var tempMC:MovieClip = new tempClass();
         tempMC.name = "genxu";
         tempMC.x = _target.x;
         tempMC.y = _target.y;
         return tempMC;
      }
      
      private function getMask() : Sprite
      {
         var spr:Sprite = new Sprite();
         spr.name = "MoleMask";
         spr.graphics.beginFill(0,0);
         spr.graphics.drawRect(0,0,960,560);
         spr.graphics.endFill();
         return spr;
      }
      
      override public function start() : void
      {
         super.start();
         bossMC.gotoAndPlay("根须纠缠术");
         bossMC.direction = int(Math.random() * 3) + 1;
      }
      
      override protected function onEnterFrame(e:*) : void
      {
         var treearea:Sprite = null;
         var genxu:MovieClip = null;
         var content:MovieClip = bossMC.getChildAt(0) as MovieClip;
         if(bossMC.currentLabel == "根须纠缠术")
         {
            treearea = content.getChildByName("treearea") as Sprite;
            if(Boolean(content["isHit"]))
            {
               if(Boolean(treearea))
               {
                  if(Boolean(MainManager.getAppLevel().getChildByName("genxu")))
                  {
                     return;
                  }
                  if(hitTest(treearea))
                  {
                     genxu = this.getGenXu();
                     MainManager.getAppLevel().addChild(genxu);
                     this.hurt();
                     if(Boolean(GV.MAN_PEOPLE.avatarClass))
                     {
                        GV.MAN_PEOPLE.avatarClass.stopToHere();
                     }
                     MoveTo.CanMove = false;
                  }
               }
            }
         }
         else
         {
            this.end();
         }
      }
      
      override public function hurt() : void
      {
         target.behurt(2);
      }
      
      override public function end() : void
      {
         var genxu:MovieClip = MainManager.getAppLevel().getChildByName("genxu") as MovieClip;
         if(Boolean(genxu))
         {
            genxu.gotoAndPlay("结束根须缠绕");
            MoveTo.CanMove = true;
         }
         super.end();
      }
   }
}

