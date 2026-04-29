package com.module.ninePicGame
{
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class tuya extends MovieClip
   {
      
      public static var ctrl_mc:MovieClip;
      
      public static var tuyaNum:uint;
      
      public static var tuing:Boolean;
      
      private static var tuyaArr:Array = [3,4,1,2];
      
      private static var tuyaIndex:uint = 0;
      
      public function tuya()
      {
         super();
      }
      
      public static function init(mc:MovieClip) : void
      {
         tuing = false;
         tuyaIndex = 0;
         changearr();
         ctrl_mc = mc;
         if(!GF.BT(GV.MyInfo_PetObj.Skill,3))
         {
            return;
         }
         ctrl_mc.doodle.buttonMode = true;
         ctrl_mc.doodle.addEventListener(MouseEvent.CLICK,petTuya);
      }
      
      public static function petTuya(e:MouseEvent) : void
      {
         if(GF.BT(GV.MyInfo_PetObj.Skill,3))
         {
            trace("學會");
            if(!tuing)
            {
               petAction();
            }
         }
         else
         {
            trace("還沒學會");
         }
      }
      
      public static function petAction() : void
      {
         tuing = true;
         var tempLoader:Loader = new Loader();
         tempLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,completeHandler);
         tempLoader.load(VL.getURLRequest("resource/pet/swf/pet" + GV.MyInfo_PetObj.Level + "/tuya" + tuyaArr[tuyaIndex] + ".swf"));
      }
      
      public static function completeHandler(e:Event) : void
      {
         ctrl_mc.doodle.visible = false;
         ++tuyaIndex;
         if(tuyaIndex == 4)
         {
            tuyaIndex = 0;
         }
         e.target.removeEventListener(Event.COMPLETE,completeHandler);
         var food:* = e.target.content.root.getChildAt(0);
         ctrl_mc.tuya.addChild(food);
         food.addEventListener("gotoEnd",showPet);
         hidePet();
         GF.setPetColor(food.petBody,GV.MyInfo_PetObj.Color);
      }
      
      public static function hidePet() : void
      {
         GV.MAN_PEOPLE.avatarMC.pet_mc.visible = false;
      }
      
      public static function showPet(e:Event) : void
      {
         GV.MAN_PEOPLE.avatarMC.pet_mc.visible = true;
         ctrl_mc.doodle.visible = true;
         tuing = false;
      }
      
      public static function changearr() : void
      {
         for(var i:uint = 0; i < 4; i++)
         {
            tuyaArr.push(tuyaArr.splice(int(Math.random() * 4),1)[0]);
         }
      }
   }
}

