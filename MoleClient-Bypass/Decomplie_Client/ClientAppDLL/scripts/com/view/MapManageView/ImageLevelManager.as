package com.view.MapManageView
{
   import com.core.manager.LevelManager;
   import com.mole.net.MoleSharedObject;
   import flash.display.Stage;
   import flash.net.SharedObject;
   
   public class ImageLevelManager
   {
      
      public function ImageLevelManager()
      {
         super();
      }
      
      public static function setStage(stage:Stage) : void
      {
      }
      
      public static function showImagePanel() : void
      {
      }
      
      public static function setImageLevel(quality:String) : void
      {
         var stage:Stage = LevelManager.stage;
         if(stage.quality == quality)
         {
            return;
         }
         MoleSharedObject.setMoleSo(MoleSharedObject.IMAGE_LEVEL_INDEX,"image_level_index",quality);
         stage.quality = quality;
      }
      
      public static function getImageQuality() : String
      {
         return getImageSoLevel(MoleSharedObject.IMAGE_LEVEL_INDEX,"image_level_index");
      }
      
      public static function getFightImageQuality() : String
      {
         return getImageSoLevel(MoleSharedObject.IMAGE_FIGHT_LEVEL_INDEX,"image_fight_level_index");
      }
      
      private static function getImageSoLevel(type:String, key:String) : String
      {
         var so:SharedObject = null;
         var activityObj:Object = null;
         if(isActivityAnimationPlayed(type,key))
         {
            so = MoleSharedObject.moleSO;
            activityObj = so.data[key];
            return activityObj.imageLevel;
         }
         return "";
      }
      
      private static function isActivityAnimationPlayed(type:String, key:String) : Boolean
      {
         var so:SharedObject = MoleSharedObject.moleSO;
         key = key;
         if(so.data[key] == null)
         {
            return false;
         }
         return true;
      }
   }
}

