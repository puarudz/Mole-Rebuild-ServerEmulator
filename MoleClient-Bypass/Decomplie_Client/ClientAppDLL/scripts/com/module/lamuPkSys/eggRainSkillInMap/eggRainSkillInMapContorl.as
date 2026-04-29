package com.module.lamuPkSys.eggRainSkillInMap
{
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.lamuPkSys.AnimalSkillSocket;
   import com.module.lamuPkSys.animalSkill.EggRainConfigParser;
   import com.view.MapManageView.MapButtonView;
   import flash.display.Loader;
   import flash.display.MovieClip;
   
   public class eggRainSkillInMapContorl
   {
      
      private static var instance:eggRainSkillInMapContorl;
      
      private static var canotNew:Boolean = true;
      
      private var buttonLevelMc:MapButtonView;
      
      private var eggArr:Array;
      
      private const eggPath:String = "resource/lamuPKSys/eggInMap/";
      
      private var eggLoader:Loader;
      
      private var eggBoxMc:MovieClip;
      
      public function eggRainSkillInMapContorl()
      {
         super();
         if(canotNew)
         {
            throw new Error("eggRainSkillInMapContorl不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : eggRainSkillInMapContorl
      {
         if(!instance)
         {
            canotNew = false;
            instance = new eggRainSkillInMapContorl();
            canotNew = true;
         }
         return instance;
      }
      
      public function checkMapAddEgg() : void
      {
         var mapId:int = int(LocalUserInfo.getMapID());
         if(EggRainConfigParser.HasEggCfgInMap(mapId))
         {
            BC.addEvent(this,GV.onlineSocket,"read_1408",this.onGetMapEgg);
            AnimalSkillSocket.GetMapEgg(mapId);
         }
      }
      
      private function onGetMapEgg(evt:EventTaomee) : void
      {
         var inMapEggC:inMapEgg = null;
         BC.removeEvent(this,GV.onlineSocket,"read_1408",this.onGetMapEgg);
         this.buttonLevelMc = MapButtonView.getTarget();
         var theEggBoxMc:MovieClip = this.buttonLevelMc.getChildByName("eggBoxmc") as MovieClip;
         if(theEggBoxMc == null)
         {
            this.eggBoxMc = new MovieClip();
            this.eggBoxMc.name = "eggBoxmc";
            this.buttonLevelMc.addChild(this.eggBoxMc);
         }
         else
         {
            this.eggBoxMc = theEggBoxMc;
         }
         this.eggArr = evt.EventObj.eggArr;
         for(var i:int = 0; i < this.eggArr.length; i++)
         {
            inMapEggC = new inMapEgg(this.eggArr[i]);
            inMapEggC.loadEggInMap(this.eggBoxMc);
         }
      }
   }
}

