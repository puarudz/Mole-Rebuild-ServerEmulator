package com.mole.net
{
   import com.core.info.LocalUserInfo;
   import flash.events.AsyncErrorEvent;
   import flash.events.Event;
   import flash.events.NetStatusEvent;
   import flash.net.SharedObject;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class MoleSharedObject
   {
      
      private static var _moleSO:SharedObject;
      
      private static var _isFlush:Boolean = true;
      
      private static var _timeID:uint = 0;
      
      public static var IMAGE_FIGHT_LEVEL_INDEX:String = "imageFightLevelIndex";
      
      public static var IMAGE_LEVEL_INDEX:String = "imageLevelIndex";
      
      public function MoleSharedObject()
      {
         super();
      }
      
      public static function flush(minDiskSpace:int = 0) : void
      {
         clearTimeout(_timeID);
         try
         {
            _moleSO.flush(minDiskSpace);
         }
         catch(e:Error)
         {
            trace("本地禁用SO寫入。");
         }
      }
      
      public static function get moleSO() : SharedObject
      {
         if(_moleSO == null)
         {
            _moleSO = getMoleData(LocalUserInfo.getUserID());
         }
         if(_isFlush)
         {
            _isFlush = false;
            _timeID = setTimeout(function():void
            {
               flush();
               _isFlush = true;
            },5000);
         }
         return _moleSO;
      }
      
      public static function setMoleSo(type:String, key:String, quality:String) : void
      {
         key = key;
         var activityObj:Object = new Object();
         moleSO.data[key] = activityObj;
         activityObj.imageLevel = quality;
      }
      
      public static function get moleObj() : Object
      {
         return moleSO.data;
      }
      
      public static function getMoleData(userID:uint) : SharedObject
      {
         var tmpSO:SharedObject = SharedObject.getLocal("mole/" + userID,"/");
         tmpSO.addEventListener(NetStatusEvent.NET_STATUS,onSOFail);
         tmpSO.addEventListener(AsyncErrorEvent.ASYNC_ERROR,onSOFail);
         return tmpSO;
      }
      
      private static function onSOFail(e:Event) : void
      {
         trace(e);
      }
   }
}

