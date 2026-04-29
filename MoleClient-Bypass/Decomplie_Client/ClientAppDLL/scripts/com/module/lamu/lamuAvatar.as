package com.module.lamu
{
   import com.module.npc.lamu.LamuInfo;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.net.URLRequest;
   
   public class lamuAvatar extends Sprite
   {
      
      private var l:Loader;
      
      private var _lamuinfo:LamuInfo;
      
      public function lamuAvatar()
      {
         super();
      }
      
      public function loadAvatar(lamuinfo:LamuInfo) : void
      {
         this._lamuinfo = lamuinfo;
         this.l = new Loader();
         BC.addEvent(this,this.l.contentLoaderInfo,Event.COMPLETE,this.addChildAvatar);
         this.l.load(VL.getURLRequest("resource/pet/avatar/pet.swf"));
         addChild(this.l);
      }
      
      private function addChildAvatar(E:Event) : void
      {
         BC.removeEvent(this,this.l.contentLoaderInfo,Event.COMPLETE,this.addChildAvatar);
         this.showAvatar(this.l.content as MovieClip);
      }
      
      private function showAvatar(mc:MovieClip) : void
      {
         var l:Loader = null;
         if(Boolean(this._lamuinfo.skill_learnType))
         {
            trace("lv" + this._lamuinfo.Petlevel + "_" + this._lamuinfo.skill_learnType);
            mc.hasCloth_pet_mc.gotoAndStop("lv" + this._lamuinfo.Petlevel + "_" + this._lamuinfo.skill_learnType);
            mc.pet_mc.gotoAndStop("lv" + this._lamuinfo.Petlevel + "_" + this._lamuinfo.skill_learnType);
            mc.pet_ye.gotoAndStop("lv" + this._lamuinfo.Petlevel + "_" + this._lamuinfo.skill_learnType);
         }
         else
         {
            mc.hasCloth_pet_mc.gotoAndStop("" + this._lamuinfo.Petlevel);
            mc.pet_mc.gotoAndStop("lv" + this._lamuinfo.Petlevel);
            mc.pet_ye.gotoAndStop("lv" + this._lamuinfo.Petlevel);
         }
         if(this._lamuinfo.PetCloth > 0 && this._lamuinfo.skill_learnType == 0)
         {
            if(this._lamuinfo.ClothObj.Layer >= 45 && this._lamuinfo.ClothObj.Layer != 75)
            {
               mc.pet_mc.visible = false;
               mc.pet_ye.visible = false;
            }
            else
            {
               mc.pet_mc.visible = true;
               mc.pet_ye.visible = true;
            }
            mc.cloth_mc.visible = true;
            mc.hasCloth_pet_mc.visible = true;
            l = new Loader();
            l.load(new URLRequest("resource/petcloth/swf/cloth/" + this._lamuinfo.PetCloth + ".swf"));
            mc.cloth_mc.addChild(l);
         }
         else
         {
            mc.cloth_mc.visible = false;
            mc.hasCloth_pet_mc.visible = false;
            mc.pet_mc.visible = true;
            mc.pet_ye.visible = true;
         }
         GF.setPetColor(mc.hasCloth_pet_mc,this._lamuinfo.PetColor);
         GF.setPetColor(mc.pet_mc,this._lamuinfo.PetColor);
      }
   }
}

