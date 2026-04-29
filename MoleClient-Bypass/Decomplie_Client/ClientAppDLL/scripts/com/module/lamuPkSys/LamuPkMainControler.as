package com.module.lamuPkSys
{
   import com.module.lamuPkSys.animalSkill.IAnimalSkillControler;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   
   public class LamuPkMainControler
   {
      
      public static var _animalSkillControler:IAnimalSkillControler;
      
      public static const IS_DEBUG:Boolean = true;
      
      public function LamuPkMainControler()
      {
         super();
      }
      
      public static function Init() : void
      {
         InitAnimalSkillControler();
      }
      
      private static function InitAnimalSkillControler() : void
      {
         var url:String = null;
         var loader:Loader = null;
         if(_animalSkillControler == null)
         {
            url = "module/lamuPKSys/AnimalSkillControler.swf";
            loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,OnLoadAnimalSkillControlerOk);
            loader.load(VL.getURLRequest(url));
         }
      }
      
      private static function OnLoadAnimalSkillControlerOk(e:Event) : void
      {
         var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
         loaderInfo.removeEventListener(Event.COMPLETE,OnLoadAnimalSkillControlerOk);
         var cls:Class = loaderInfo.applicationDomain.getDefinition("AnimalSkillControler") as Class;
         _animalSkillControler = new cls();
         _animalSkillControler.Init();
      }
   }
}

