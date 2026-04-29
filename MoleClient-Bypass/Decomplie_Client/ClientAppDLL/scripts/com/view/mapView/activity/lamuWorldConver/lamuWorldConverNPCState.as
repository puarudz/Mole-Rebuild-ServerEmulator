package com.view.mapView.activity.lamuWorldConver
{
   public class lamuWorldConverNPCState
   {
      
      private static var instance:lamuWorldConverNPCState;
      
      private static var canotNew:Boolean = true;
      
      private var clickObjId:int;
      
      public function lamuWorldConverNPCState()
      {
         super();
         if(canotNew)
         {
            throw new Error("lamuWorldConverNPCState不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : lamuWorldConverNPCState
      {
         if(!instance)
         {
            canotNew = false;
            instance = new lamuWorldConverNPCState();
            canotNew = true;
         }
         return instance;
      }
      
      public function getClickObjId() : int
      {
         return this.clickObjId;
      }
      
      public function setClickObjId(temp:int) : void
      {
         this.clickObjId = temp;
      }
   }
}

