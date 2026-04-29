package com.module.lahmClassRoom
{
   import flash.display.MovieClip;
   
   public class lahmClassRoomBeen
   {
      
      private static var instance:lahmClassRoomBeen;
      
      private static var canotNew:Boolean = true;
      
      private var inLahmClassRoom:Boolean;
      
      private var myLahmClassRoom:Boolean;
      
      private var lahmClassRoomInfo:Object;
      
      private var lahmClassRoomBG:MovieClip;
      
      private var lahmClassRoomMC:MovieClip;
      
      public function lahmClassRoomBeen()
      {
         super();
         if(canotNew)
         {
            throw new Error("lahmClassRoomBeen不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : lahmClassRoomBeen
      {
         if(!instance)
         {
            canotNew = false;
            instance = new lahmClassRoomBeen();
            canotNew = true;
         }
         return instance;
      }
      
      public function setInLahmClassRoom(value:Boolean) : void
      {
         this.inLahmClassRoom = value;
      }
      
      public function isInLahmClassRoom() : Boolean
      {
         return this.inLahmClassRoom;
      }
      
      public function setMyLahmClassRoom(value:Boolean) : void
      {
         this.myLahmClassRoom = value;
      }
      
      public function isMyLahmClassRoom() : Boolean
      {
         return this.myLahmClassRoom;
      }
      
      public function setLahmClassRoomInfo(value:Object) : void
      {
         this.lahmClassRoomInfo = value;
      }
      
      public function getLahmClassRoomInfo() : Object
      {
         return this.lahmClassRoomInfo;
      }
      
      public function setLahmClassRoomBG(value:MovieClip) : void
      {
         this.lahmClassRoomBG = value;
      }
      
      public function getLahmClassRoomBG() : MovieClip
      {
         return this.lahmClassRoomBG;
      }
      
      public function setLahmClassRoomMC(value:MovieClip) : void
      {
         this.lahmClassRoomMC = value;
      }
      
      public function getLahmClassRoomMC() : MovieClip
      {
         return this.lahmClassRoomMC;
      }
   }
}

