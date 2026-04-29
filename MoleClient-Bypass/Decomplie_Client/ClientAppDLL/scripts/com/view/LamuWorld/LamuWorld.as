package com.view.LamuWorld
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
   
   public class LamuWorld implements IAttackTarget
   {
      
      private static var _instance:LamuWorld;
      
      public static const FIRE_BOSS:String = "fireboss";
      
      public static const ICE_BOSS:String = "iceboss";
      
      public static const TREE_BOSS:String = "treeboss";
      
      public static const LAMU_HURT:String = "lamuhurt";
      
      public static const BOSS_HURT:String = "bosshurt";
      
      public static var isBuild:Boolean = false;
      
      public var isShowLive:Boolean;
      
      private var uiapp:UILamuWorld;
      
      private var stage:Sprite;
      
      private var lamuLive:LamuLive;
      
      public function LamuWorld()
      {
         super();
         if(!isBuild)
         {
            isBuild = true;
            _instance = this;
            this.uiapp = new UILamuWorld();
            return;
         }
         throw new IllegalOperationError("com.view.LamuWorld::LamuWorld not supported to build");
      }
      
      public static function get instance() : LamuWorld
      {
         return _instance;
      }
      
      public static function getInstance() : LamuWorld
      {
         if(_instance == null)
         {
            return new LamuWorld();
         }
         return _instance;
      }
      
      public function get lives() : int
      {
         if(this.lamuLive == null)
         {
            return 20;
         }
         return this.lamuLive.live;
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
         if(this.lamuLive == null)
         {
            return;
         }
         this.lamuLive.live = val;
      }
      
      public function mapinit() : void
      {
         if(GV.MAN_PEOPLE.Petlevel > 1)
         {
            this.showLamuLive();
         }
         else
         {
            this.dead();
         }
      }
      
      public function loadUI() : void
      {
         this.uiapp.loadUI();
      }
      
      public function addLamuEvents() : void
      {
         BC.addEvent(this,GV.onlineSocket,LAMU_HURT,this.behurtHandler);
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
         MapManager.enterMap(123);
         this.clean();
         _instance = null;
         isBuild = false;
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
      }
      
      public function showLamuLive() : void
      {
         var spr:Sprite = null;
         var bar:DisplayObject = null;
         if(LocalUserInfo.getMapID() == 136)
         {
            return;
         }
         if(!this.stageHaveChild("lamuLiveBar"))
         {
            spr = this.uiapp.getSprite("LamuLive");
            spr.name = "lamuLiveBar";
            spr.x = 27.6;
            spr.y = 75;
            this.stage.addChild(spr);
            this.lamuLive = new LamuLive(spr);
            this.lives = GV.lamuLive;
         }
         else
         {
            bar = this.stage.getChildByName("lamuLiveBar");
            bar.visible = true;
         }
      }
      
      public function hideLamuLive() : void
      {
         var bar:DisplayObject = null;
         if(this.stageHaveChild("lamuLiveBar"))
         {
            bar = this.stage.getChildByName("lamuLiveBar");
            bar.visible = false;
         }
      }
      
      public function removeLamuLive() : void
      {
         this.removeStagehild("LamuLive");
      }
      
      public function getBossLive(type:String) : Sprite
      {
         switch(type)
         {
            case FIRE_BOSS:
               return this.uiapp.getSprite("FireBossLive");
            case TREE_BOSS:
               return this.uiapp.getSprite("TreeBossLive");
            case ICE_BOSS:
               return this.uiapp.getSprite("IceBossLive");
            default:
               return null;
         }
      }
      
      private function initLiveComplete(e:* = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"lamuComplete",this.initLiveComplete);
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(GV.MAN_PEOPLE.Petlevel < 2)
         {
            return;
         }
         var itemid:int = p.lamuinfo.PetCloth;
         if(itemid == 1200035)
         {
            GV.lamuLive = 20;
         }
         else
         {
            GV.lamuLive = 16;
         }
         if(Boolean(this.lamuLive))
         {
            this.lives = GV.lamuLive;
         }
         else
         {
            this.showLamuLive();
         }
      }
      
      public function initLive() : void
      {
         if(!LamuWorld.getInstance().isComplete)
         {
            BC.addEvent(this,GV.onlineSocket,"lamuComplete",this.initLiveComplete);
            LamuWorld.getInstance().loadUI();
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
         this.removeStagehild("lamuICO");
         this.removeStagehild("LamuLive");
         this.removeStagehild("lamuLiveBar");
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

