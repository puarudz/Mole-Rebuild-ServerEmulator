package com.view.PeopleView
{
   import com.event.EventTaomee;
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   
   public class HitConditional
   {
      
      private static var myEventDispatcher:EventDispatcher = new EventDispatcher();
      
      public static var dispatchEvent:Function = myEventDispatcher.dispatchEvent;
      
      public static var addEventListener:Function = myEventDispatcher.addEventListener;
      
      public static var removeEventListener:Function = myEventDispatcher.removeEventListener;
      
      public static var ON_TYPE_CHANGE:String = "on_type_change";
      
      public static var USER_PAN:String = "user_Pan";
      
      public static var MAGIC_BAR:String = "magic_bar";
      
      public static var CATCH_PHOTO:String = "catch_Photo";
      
      private static var currentType:String = USER_PAN;
      
      public function HitConditional()
      {
         super();
      }
      
      public static function set HitType(_type:String) : void
      {
         var hasChange:Boolean = false;
         var _oldType:String = currentType;
         if(_type != currentType)
         {
            hasChange = true;
         }
         currentType = _type;
         if(hasChange)
         {
            dispatchEvent(new EventTaomee(ON_TYPE_CHANGE,{
               "newType":currentType,
               "oldType":_oldType
            }));
         }
      }
      
      public static function get HitType() : String
      {
         return currentType;
      }
      
      public static function MOUSE_OVER(_People:MovieClip, E:MouseEvent = null) : void
      {
         var _isSelf:Boolean = _People.id == GV.MyInfo_userID ? true : false;
         var dispatchObj:Object = {
            "Event":E,
            "Type":currentType,
            "isSelf":_isSelf,
            "People":_People
         };
         dispatchEvent(new EventTaomee(MouseEvent.MOUSE_OVER,dispatchObj));
         dispatchObj.People = null;
      }
      
      public static function MOUSE_DOWN(_People:MovieClip, E:MouseEvent = null) : void
      {
         var _isSelf:Boolean = _People.id == GV.MyInfo_userID ? true : false;
         var dispatchObj:Object = {
            "Event":E,
            "Type":currentType,
            "isSelf":_isSelf,
            "People":_People
         };
         dispatchEvent(new EventTaomee(MouseEvent.MOUSE_DOWN,dispatchObj));
         dispatchObj.People = null;
      }
      
      public static function CLICK(_People:MovieClip, E:MouseEvent = null) : void
      {
         var _isSelf:Boolean = _People.id == GV.MyInfo_userID ? true : false;
         var dispatchObj:Object = {
            "Event":E,
            "Type":currentType,
            "isSelf":_isSelf,
            "People":_People
         };
         dispatchEvent(new EventTaomee(MouseEvent.CLICK,dispatchObj));
         dispatchObj.People = null;
      }
      
      public static function MOUSE_OUT(_People:MovieClip, E:MouseEvent = null) : void
      {
         var _isSelf:Boolean = _People.id == GV.MyInfo_userID ? true : false;
         var dispatchObj:Object = {
            "Event":E,
            "Type":currentType,
            "isSelf":_isSelf,
            "People":_People
         };
         dispatchEvent(new EventTaomee(MouseEvent.MOUSE_OUT,dispatchObj));
         dispatchObj.People = null;
      }
   }
}

