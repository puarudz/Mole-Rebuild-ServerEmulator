package com.view.mapView.activity.npcTask
{
   public class defendNPCState
   {
      
      private static var instance:defendNPCState;
      
      private static var canotBool:Boolean = false;
      
      private var sayObjId:int;
      
      private var npcTimer:Number;
      
      private var cottageTimer:Number;
      
      public function defendNPCState()
      {
         super();
         if(canotBool)
         {
            throw new Error("defendNPCState不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : defendNPCState
      {
         if(!instance)
         {
            canotBool = false;
            instance = new defendNPCState();
            canotBool = true;
         }
         return instance;
      }
      
      public function getSayId() : int
      {
         trace("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" + this.sayObjId);
         return this.sayObjId;
      }
      
      public function setSayId(temp:int) : void
      {
         this.sayObjId = temp;
         trace("%%%%%%%%%%%%%%%%%%%%%%%%%%%" + this.sayObjId);
      }
      
      public function getnpcTimer() : Number
      {
         return this.npcTimer;
      }
      
      public function setnpcTimer(_timer:Number) : void
      {
         this.npcTimer = _timer;
      }
      
      public function getCottageTimer() : Number
      {
         return this.cottageTimer;
      }
      
      public function setCottageTimer(_timer:Number) : void
      {
         this.cottageTimer = _timer;
      }
   }
}

