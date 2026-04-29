package com.view.FightWorld
{
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.mole.app.map.MapManager;
   import com.view.LamuWorld.attack.IAttackTarget;
   import com.view.MapManageView.MapButtonView;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.errors.IllegalOperationError;
   import flash.events.Event;
   
   public class FightWorld implements IAttackTarget
   {
      
      private static var _instance:FightWorld;
      
      public static const Siren_BOSS:String = "Sirenboss";
      
      public static const ICE_BOSS:String = "iceboss";
      
      public static const KULA_BOSS:String = "kulaboss";
      
      public static const FIGHT_HURT:String = "fighthurt";
      
      public static const BOSS_HURT:String = "bosshurt";
      
      public static var isBuild:Boolean = false;
      
      public var isShowLive:Boolean;
      
      private var uiapp:UIFightWorld;
      
      private var stage:Sprite;
      
      private var fightLive:FightLive;
      
      public function FightWorld()
      {
         super();
         if(!isBuild)
         {
            isBuild = true;
            _instance = this;
            this.uiapp = new UIFightWorld();
            return;
         }
         throw new IllegalOperationError("com.view.FightWorld::FightWorld not supported to build");
      }
      
      public static function get instance() : FightWorld
      {
         return _instance;
      }
      
      public static function getInstance() : FightWorld
      {
         if(_instance == null)
         {
            return new FightWorld();
         }
         return _instance;
      }
      
      public function get lives() : int
      {
         if(this.fightLive == null)
         {
            return 20;
         }
         return this.fightLive.live;
      }
      
      public function get isComplete() : Boolean
      {
         return this.uiapp.isComplete;
      }
      
      public function get x() : Number
      {
         return GV.MAN_PEOPLE.x;
      }
      
      public function get y() : Number
      {
         return GV.MAN_PEOPLE.y - 20;
      }
      
      public function get width() : Number
      {
         return GV.MAN_PEOPLE.width;
      }
      
      public function get height() : Number
      {
         return GV.MAN_PEOPLE.height;
      }
      
      public function set lives(val:int) : void
      {
         if(this.fightLive == null)
         {
            return;
         }
         this.fightLive.live = val;
      }
      
      public function addLamuEvents() : void
      {
         BC.addEvent(this,GV.onlineSocket,FIGHT_HURT,this.behurtHandler);
         BC.addEvent(this,GV.onlineSocket,BOSS_HURT,this.bossHurtFun);
      }
      
      public function mapinit() : void
      {
         this.showFightLive();
      }
      
      public function loadUI() : void
      {
         this.uiapp.loadUI();
      }
      
      public function addFightEvents() : void
      {
         BC.addEvent(this,GV.onlineSocket,FIGHT_HURT,this.behurtHandler);
         BC.addEvent(this,GV.onlineSocket,BOSS_HURT,this.bossHurtFun);
      }
      
      private function behurtHandler(e:EventTaomee) : void
      {
         this.behurt();
      }
      
      public function behurt(value:Number = 1) : Object
      {
         var kouxue:MovieClip = null;
         var p:PeopleManageView = null;
         if(!this.stageHaveChild("kouxue") && Boolean(value))
         {
            this.lives -= value;
            if(!isBuild)
            {
               return null;
            }
            kouxue = this.uiapp.getSprite("Kouxue") as MovieClip;
            kouxue.name = "kouxue";
            if(value > 0)
            {
               kouxue["index"] = value;
            }
            else
            {
               kouxue["index"] = 9 - value;
            }
            p = GV.MAN_PEOPLE as PeopleManageView;
            kouxue.x = p.x;
            kouxue.y = p.y - 120;
            this.stage.addChild(kouxue);
            if(this.lives <= 0)
            {
               this.dead();
            }
         }
         return kouxue;
      }
      
      public function dead() : void
      {
         this.clean();
         _instance = null;
         isBuild = false;
         MapManager.enterMap(264);
      }
      
      public function bossHurtFun(e:*) : void
      {
         if(e is EventTaomee)
         {
         }
      }
      
      public function init() : void
      {
         if(this.stage == null)
         {
            this.stage = MapButtonView.getTarget();
         }
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeHandler);
      }
      
      private function removeHandler(e:Event) : void
      {
         this.clean();
      }
      
      public function showFightLive() : void
      {
         var spr:Sprite = null;
         var bar:DisplayObject = null;
         if(LocalUserInfo.getMapID() == 136)
         {
            return;
         }
         if(!this.stageHaveChild("fightLiveBar"))
         {
            spr = this.uiapp.getSprite("FightLive");
            spr.name = "fightLiveBar";
            spr.x = 27.6;
            spr.y = 75;
            this.stage.addChild(spr);
            this.fightLive = new FightLive(spr);
            this.lives = GV.fightLive;
         }
         else
         {
            bar = this.stage.getChildByName("fightLiveBar");
            bar.visible = true;
         }
      }
      
      public function hideLamuLive() : void
      {
         var bar:DisplayObject = null;
         if(this.stageHaveChild("fightLiveBar"))
         {
            bar = this.stage.getChildByName("fightLiveBar");
            bar.visible = false;
         }
      }
      
      public function removeLamuLive() : void
      {
         this.removeStagehild("FightLive");
      }
      
      public function getBossLive(type:String) : Sprite
      {
         switch(type)
         {
            case ICE_BOSS:
               return this.uiapp.getSprite("IceBossLive");
            case KULA_BOSS:
               return this.uiapp.getSprite("KulaBossLive");
            case Siren_BOSS:
               return this.uiapp.getSprite("SirenBossLive");
            default:
               return null;
         }
      }
      
      private function initLiveComplete(e:* = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"fightComplete",this.initLiveComplete);
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(GV.MAN_PEOPLE.Petlevel < 2)
         {
            return;
         }
         var itemid:int = p.lamuinfo.PetCloth;
         if(itemid == 1200035)
         {
            GV.fightLive = 20;
         }
         else
         {
            GV.fightLive = 16;
         }
         if(Boolean(this.fightLive))
         {
            this.lives = GV.fightLive;
         }
         else
         {
            this.showFightLive();
         }
      }
      
      public function initLive() : void
      {
         if(!FightWorld.getInstance().isComplete)
         {
            BC.addEvent(this,GV.onlineSocket,"fightComplete",this.initLiveComplete);
            FightWorld.getInstance().loadUI();
         }
         else
         {
            this.initLiveComplete();
         }
      }
      
      public function hideBossLive() : void
      {
      }
      
      public function removed() : void
      {
         this.removeStagehild("fightICO");
         this.removeStagehild("FightLive");
         this.removeStagehild("fightLiveBar");
         this.removeStagehild("kouxue");
      }
      
      public function clean() : void
      {
         this.removed();
         BC.removeEvent(this);
      }
      
      private function stageHaveChild(str:String) : Boolean
      {
         return Boolean(this.stage) && this.stage.getChildByName(str) != null;
      }
      
      private function removeStagehild(str:String) : void
      {
         if(this.stageHaveChild(str))
         {
            this.stage.removeChild(this.stage.getChildByName(str));
         }
      }
   }
}

