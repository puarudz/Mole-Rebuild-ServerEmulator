package com.logic.lamuMantraLogic
{
   import com.core.MainManager;
   import com.core.manager.UIManager;
   import com.event.EventTaomee;
   import com.global.staticData.XMLInfo;
   import com.module.activityModule.checkItem;
   import com.module.deal.Deal;
   import com.module.deal.SwapItem;
   import com.module.pet.petLogic;
   import com.view.PeopleView.PeopleManageView;
   import com.view.mapView.activity.creatShareObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Timer;
   
   public class LamuMantra
   {
      
      public static var DurationTimer:Timer;
      
      public static var currentMagic:String;
      
      private static var indexMantra:int;
      
      private static var Duration:uint = 5000;
      
      private static var dispatchObj:EventDispatcher = new EventDispatcher();
      
      public static var BIBOBIBO:String = "bibobibo";
      
      public static var BIBOBIBO_OVER:String = "bibobibo_over";
      
      public function LamuMantra()
      {
         super();
      }
      
      public static function dispatchEvent(event:Event) : Boolean
      {
         return dispatchObj.dispatchEvent(event);
      }
      
      public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         dispatchObj.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         dispatchObj.removeEventListener(type,listener,useCapture);
      }
      
      public static function hasEventListener(type:String) : Boolean
      {
         return dispatchObj.hasEventListener(type);
      }
      
      public static function hasOwnProperty(name:String) : Boolean
      {
         return dispatchObj.hasOwnProperty(name);
      }
      
      public static function willTrigger(type:String) : Boolean
      {
         return dispatchObj.willTrigger(type);
      }
      
      public static function checkHasMantra(msg:String) : Boolean
      {
         var name:String = null;
         var demand:int = 0;
         msg = msg.toLowerCase();
         var s1:int = int(XMLInfo.MantraArray1.indexOf(msg));
         var s2:int = int(XMLInfo.MantraArray2.indexOf(msg));
         var index:int = Math.max(s1,s2);
         if(index >= 0)
         {
            name = XMLInfo.MantraArray1[index];
            demand = int(XMLInfo.DemandLamuArray[index]);
            if(demand == 0 && PeopleManageView(GV.MAN_PEOPLE).Petlevel > 0 || petLogic.PetMagicCan(demand))
            {
               if(Boolean(LamuMantra[name]))
               {
                  LamuMantra[name](name);
               }
               else
               {
                  addMovie("lamu_BianShen_mc");
                  doAction(name);
               }
               return true;
            }
            if(name == "mofaxingxing" && Boolean(PeopleManageView(GV.MAN_PEOPLE).avatarMC.pet_mc.numChildren))
            {
               checkItem.checkItemHandler(190415);
               GV.onlineSocket.addEventListener(checkItem.chekItem_suc,has190415);
               return true;
            }
            if(name == "mofaxianzhiqiu" && Boolean(PeopleManageView(GV.MAN_PEOPLE).avatarMC.pet_mc.numChildren))
            {
               checkItem.checkItemHandler(190416);
               GV.onlineSocket.addEventListener(checkItem.chekItem_suc,has190416);
               return true;
            }
         }
         return false;
      }
      
      private static function has190415(E:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(checkItem.chekItem_suc,has190415);
         if(E.EventObj.count == 1)
         {
            doAction("mofaxingxing");
            Deal.DelItem([new SwapItem(190415,1)]);
         }
      }
      
      private static function has190416(E:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(checkItem.chekItem_suc,has190416);
         if(E.EventObj.count == 1)
         {
            doAction("mofaxianzhiqiu");
            Deal.DelItem([new SwapItem(190416,1)]);
         }
      }
      
      public static function yishouzhetian(name:String) : void
      {
         doAction(name);
      }
      
      public static function nihao(name:String) : void
      {
         doAction(name);
      }
      
      public static function baibiansuixin(name:String) : void
      {
         doAction(name);
      }
      
      public static function xingchenshouhu(name:String) : void
      {
         doAction(name);
      }
      
      public static function shikongganying(name:String) : void
      {
         doAction(name);
      }
      
      private static function startShikongganying(E:Event) : void
      {
         MovieClip(E.currentTarget).removeEventListener("over",startShikongganying);
         doMagic("shikongganying");
      }
      
      private static function addMovie(type:String) : MovieClip
      {
         var mc:MovieClip = null;
         if(!type)
         {
            return null;
         }
         mc = UIManager.getMovieClip(type);
         mc.x = 480;
         mc.y = 280;
         MainManager.getGameLevel().addChild(mc);
         return mc;
      }
      
      private static function doAction(name:String) : void
      {
         doMagic(name);
      }
      
      private static function doMagic(name:String) : void
      {
         if(!GV.MAN_PEOPLE)
         {
            return;
         }
         var index:int = int(XMLInfo.MantraArray1.indexOf(name));
         if(index >= 0)
         {
            MainManager.getStage().frameRate = 24;
            indexMantra = index;
            Duration = XMLInfo.DurationArray[index];
            currentMagic = name;
            PeopleManageView(GV.MAN_PEOPLE).addEffect("magic_ef");
            creatShareObject.getInstance().setLahuWood(name);
            PeopleManageView(GV.MAN_PEOPLE).addWoodPet(name);
            GC.clearGInterval(DurationTimer);
            DurationTimer = GC.setGTimeout(MantraTimeOut,Duration);
            dispatchEvent(new EventTaomee(BIBOBIBO,name));
            if(name == "shikongganying")
            {
               MainManager.getStage().frameRate = 5;
            }
            return;
         }
         throw "魔法不存在！！！";
      }
      
      private static function MantraTimeOut() : void
      {
         MainManager.getStage().frameRate = 24;
         currentMagic = "";
         indexMantra = -1;
         GC.clearGInterval(DurationTimer);
         creatShareObject.getInstance().setLahuWood("");
         PeopleManageView(GV.MAN_PEOPLE).addWoodPet("");
         dispatchEvent(new EventTaomee(BIBOBIBO_OVER,currentMagic));
      }
   }
}

