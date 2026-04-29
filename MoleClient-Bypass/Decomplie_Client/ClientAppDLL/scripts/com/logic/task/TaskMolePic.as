package com.logic.task
{
   import com.core.MainManager;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.info.LocalUserInfo;
   
   public class TaskMolePic
   {
      
      private static var _instance:TaskMolePic;
      
      public static var isMyHouse:Boolean;
      
      public static var UserID:int;
      
      public function TaskMolePic()
      {
         super();
      }
      
      public static function get inst() : TaskMolePic
      {
         if(_instance == null)
         {
            _instance = new TaskMolePic();
         }
         return _instance;
      }
      
      public function openMolePic(userID:int) : void
      {
         UserID = userID;
         if(userID == LocalUserInfo.getUserID())
         {
            isMyHouse = true;
         }
         else
         {
            isMyHouse = false;
         }
         var resID:int = int(DownLoadManager.add("module/external/MolePic2.swf",ResType.DISPLAY_OBJECT));
         DownLoadManager.addEvent(resID,this.loadPicOver);
      }
      
      private function loadPicOver(e:DownLoadEvent) : void
      {
         MainManager.getAppLevel().addChild(e.data);
      }
      
      public function openMolePainter() : void
      {
         var resID:int = int(DownLoadManager.add("module/external/MolePainter2.swf",ResType.DISPLAY_OBJECT));
         DownLoadManager.addEvent(resID,this.loadPaiOver);
      }
      
      private function loadPaiOver(e:DownLoadEvent) : void
      {
         MainManager.getAppLevel().addChild(e.data);
      }
   }
}

