package com.module.magicSpirit.event
{
   import flash.events.Event;
   
   public class MagicSpiritEvent extends Event
   {
      
      public static const MAGIC_SPIRIT_USER_INFO:String = "magic_spirit_user_info";
      
      public static const MAGIC_SPIRIT_GRT_OTHER_INFO:String = "magic_spirit_other_info";
      
      public static const MAGIC_SPIRIT_BAG_INFO:String = "magic_spirit_bag_info";
      
      public static const MAGIC_SPIRIT_GET_FRIEND_TEAM_INFO:String = "magic_spirit_get_friend_team_info";
      
      public static const MAGIC_SPIRIT_REFRESH_BAG:String = "magic_spirit_refresh";
      
      private var _data:*;
      
      public function MagicSpiritEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         this._data = data;
         super(type,bubbles,cancelable);
      }
      
      override public function clone() : Event
      {
         return new MagicSpiritEvent(type,this._data,bubbles,cancelable);
      }
      
      public function get data() : *
      {
         return this._data;
      }
   }
}

