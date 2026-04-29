package com.view.mapView.activity.Task83
{
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.global.staticData.XMLInfo;
   import flash.display.MovieClip;
   
   public class UpdateAppearNew
   {
      
      private static var instance:UpdateAppearNew;
      
      public static var newBookNum:int;
      
      public static var upholsterNum:int;
      
      public static var sutrabookNum:int;
      
      public function UpdateAppearNew()
      {
         super();
      }
      
      public static function getInstance() : UpdateAppearNew
      {
         if(!instance)
         {
            instance = new UpdateAppearNew();
         }
         return instance;
      }
      
      public function init() : void
      {
         var obj:Object = XMLInfo.WeeklyUpdateXML["appearNew"];
         newBookNum = int(obj["newBook"]);
         upholsterNum = int(obj["upholster"]);
         sutrabookNum = int(obj["sutrabook"]);
         switch(LocalUserInfo.getMapID())
         {
            case 3:
               this.newMap3Fun();
         }
      }
      
      public function newMap3Fun() : void
      {
         var botton_mc:MovieClip = null;
         if(!botton_mc)
         {
            botton_mc = GV.MC_mapFrame["buttonLevel"];
         }
         if(newBookNum != 0)
         {
            botton_mc.newBookBtn.newBook_mc.visible = Boolean(MainManager.getGlobalObject().data.newBookNum != newBookNum);
         }
         if(upholsterNum != 0)
         {
            botton_mc.upholsterBook.newBook_mc.visible = Boolean(MainManager.getGlobalObject().data.upholsterNum != upholsterNum);
         }
      }
   }
}

