package com.mole.app.manager
{
   import com.module.lamuPkSys.eggRainSkillInMap.eggRainSkillInMapContorl;
   import com.mole.app.activity.GodOfFireAct;
   import com.mole.app.activity.KFCStaticsManager;
   import com.mole.app.activity.SearchFuckKFCAct;
   import com.mole.app.activity.SearchKFCNoise;
   
   public class MapActivityManager
   {
      
      public function MapActivityManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         eggRainSkillInMapContorl.getInstance().checkMapAddEgg();
         KFCStaticsManager.getInstance().setUp();
         SearchFuckKFCAct.getInst().setUp();
         SearchKFCNoise.getInst().setUp();
         GodOfFireAct.getInst().getIn();
      }
   }
}

