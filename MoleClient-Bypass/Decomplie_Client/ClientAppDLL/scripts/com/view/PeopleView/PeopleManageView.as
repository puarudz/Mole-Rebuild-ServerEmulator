package com.view.PeopleView
{
   import com.common.Alert.childAlert.customAlert;
   import com.common.LibLogic.LibLogic;
   import com.common.Tween.TweenLite;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.dialogBox.DialogBox;
   import com.common.util.DisplayUtil;
   import com.common.util.Tick;
   import com.core.MainManager;
   import com.core.car.carInfo.CarInfo;
   import com.core.dragon.dragonInfo.DragonInfo;
   import com.core.field.animalInfo.AnimalInfo;
   import com.core.info.LocalUserInfo;
   import com.core.manager.AssetsManage;
   import com.core.manager.IndexManager;
   import com.core.manager.UIManager;
   import com.core.objectPool.ObjectPool;
   import com.event.EventTaomee;
   import com.global.links.Links;
   import com.interfaces.ICarAction;
   import com.interfaces.IDragonAction;
   import com.interfaces.IMoleAction;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.MapManageLogic.MapModelLogic;
   import com.logic.StageActionLogic.StageActionLogic;
   import com.logic.lamuMantraLogic.LamuMantra;
   import com.logic.mapEvent.MapEvent;
   import com.logic.socket.action.ActionReq;
   import com.logic.socket.useUserDItem.UseUserItemRigReq;
   import com.module.activityModule.Presented;
   import com.module.car.Car;
   import com.module.cutMapModule.SaveCutMap;
   import com.module.dragon.Dragon;
   import com.module.farm.FieldView;
   import com.module.farm.IAnimal_Follow;
   import com.module.lamuPkSys.animalSkill.AnimalSkillEvent;
   import com.module.npc.lamu.I_LamuNPC;
   import com.module.npc.lamu.LamuInfo;
   import com.module.npc.npcInstance.LamuNPC;
   import com.module.npc.npcInstance.lamu.skillBar.LamuSkillBar;
   import com.module.npcFollowMole.AngelFollowMole;
   import com.module.npcFollowMole.NewAngelFollowMole;
   import com.module.npcFollowMole.PigFollowMole;
   import com.module.pet.petPanel;
   import com.module.specialTool.specialView;
   import com.mole.app.event.PeopleEvent;
   import com.mole.app.manager.KFCManager;
   import com.mole.app.task.TaskManager;
   import com.view.MapManageView.MapButtonView;
   import com.view.MapManageView.TailButtonView;
   import com.view.PeopleView.ChildPeople.BoyAvatar;
   import com.view.PeopleView.ChildPeople.TransfigurationAvatar;
   import com.view.PeopleView.ChildPeople.footballAvatar;
   import com.view.PeopleView.ChildPeople.pumpkinAvatar;
   import com.view.PeopleView.ChildPeople.simplePeople;
   import com.view.mapView.activity.creatShareObject;
   import com.view.player.ClothConstant;
   import com.view.player.MultiEquipPlayer;
   import com.view.userPanelView.userPanelView;
   import fl.motion.easing.Bounce;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import patch.view.PeopleView.PatchPeopleManageView;
   
   public final dynamic class PeopleManageView extends MovieClip implements IMoleAction
   {
      
      public static var Status:Object;
      
      public static var ON_FLY_COMPLETE:String = "onFlyComPlete";
      
      public static var ON_FLY_TOUCHDOWN:String = "onFlyTouchdown";
      
      public static var ON_GO_NOPATH:String = "onNoPath";
      
      public static var ON_GO_START:String = "onGoStart";
      
      public static var ON_GO_OVER:String = "onGoOver";
      
      public static var ON_GO_ENTERFRAME:String = "onGoEnterFrame";
      
      public static var ON_SET_DEPTH:String = "onSetDepthEnterFrame";
      
      public static var ON_CHANGE_DIRECTION:String = "onchangeDirection";
      
      public static var ON_CHANGE_CLOTHS:String = "onChangeCloths";
      
      public static var ON_DISPOSE_CACHE:String = "onDisposeCache";
      
      public static var ON_SET_CACHE:String = "onsetCache";
      
      public static var ON_ACTION_DANCE:String = "dance";
      
      public static var ON_ACTION_WAVE:String = "wave";
      
      public static var ON_ACTION_THROW:String = "throw";
      
      public static var ON_ACTION_SKID:String = "Skid";
      
      public static var ON_ACTION_SKID_OVER:String = "SkidOver";
      
      public static var ON_ACTION_SITDOWN:String = "onSitDown";
      
      public static var ON_ACTION_SHOW_BEFORE:String = "onActionShowBefore";
      
      public static var ON_ACTION_SHOW_AFTER:String = "onActionShowAfter";
      
      public static var ON_ACTION_STOP_BEFORE:String = "onActionStopBefore";
      
      public static var ON_ACTION_STOP_AFTER:String = "onActionStopAfter";
      
      public static var ON_SPECIFIC_SCALEBODY:String = "scaleBody";
      
      public static var ON_AVATAR_REFURBISH:String = "on_Avatar_Refurbish";
      
      public static var ON_SITDOWN:String = "onSitDown";
      
      public static var ON_GO_BREAK:String = "onGoBreak";
      
      public static var NO_PATH:String = "onNoPath";
      
      public static var SIT_DOWN:String = "onSitDown";
      
      public static var ON_LOADED:String = "onLoadAvatarInit";
      
      public static var ON_BACK_PET:String = "BackPet";
      
      public static var ON_CLEAR_PEOPLE:String = "onClearPeople";
      
      public static var Run:uint = 25;
      
      public static var Walk:uint = 38;
      
      public var _isMoving:Boolean;
      
      public var Throw_selected:*;
      
      public var avatarMC:MovieClip;
      
      public var avatarClass:simplePeople;
      
      public var motionClass:*;
      
      public var oldXY:Object;
      
      public var startXY:Object;
      
      public var targetXY:Object;
      
      public var throwXY:Object;
      
      public var specificObj:Object;
      
      public var colorObj:Object;
      
      public var metier:String = "公民";
      
      public var delay:uint = 5000;
      
      public var showBoxTimer:Timer;
      
      public var checkNewPeopleTimer:Timer;
      
      public var isNewPeople:Boolean;
      
      public var id:*;
      
      public var layer:String;
      
      public var Direction:uint;
      
      public var Action:*;
      
      public var Action2:*;
      
      public var Activity:ByteArray;
      
      public var isFlying:Boolean = false;
      
      public var isFootballBay:Boolean = false;
      
      public var isActionMovie:Boolean = false;
      
      public var isVisible:Boolean = false;
      
      public var isRefurbishAvatar:Boolean = false;
      
      public var address:String;
      
      public var headTopBtn:TailButtonView;
      
      private var _hitBtn:TailButtonView;
      
      private var _petHitBtn:TailButtonView;
      
      public var Family:*;
      
      public var hasLamu:Boolean = false;
      
      public var PetID:*;
      
      public var PetColor:*;
      
      public var Petlevel:*;
      
      public var PetSkill:*;
      
      public var PetCloth:uint = 0;
      
      public var canFly:int;
      
      public var PetHonor:*;
      
      public var PetSick:*;
      
      public var PetSickID:Timer;
      
      public var changeBody:*;
      
      public var petmc:*;
      
      public var magicMC:MovieClip;
      
      public var petClothMC:MovieClip;
      
      public var lamuinfo:LamuInfo;
      
      public var lamu:I_LamuNPC;
      
      public var _lamuMode:Boolean = false;
      
      public var isLamuFollow:Boolean = true;
      
      public var PetObj:*;
      
      public var roleType:uint;
      
      public var clothsArray:Array;
      
      private var _hasDragon:Boolean = false;
      
      private var _hasCar:Boolean = false;
      
      private var _hasAnimal:Boolean = false;
      
      public var dragon:IDragonAction;
      
      public var car:ICarAction;
      
      public var animal:IAnimal_Follow;
      
      private var _hasAngel:Boolean = false;
      
      private var _angelFollow:AngelFollowMole;
      
      private var _newAngelFollow:NewAngelFollowMole;
      
      private var _hasPig:Boolean = false;
      
      private var _pigFollow:PigFollowMole;
      
      public var isIn204Game:Boolean = false;
      
      public var clothsManage:*;
      
      public var getCandyPan:customAlert;
      
      private var _effectMC:DisplayObjectContainer;
      
      public var hasDragonType4:Boolean = false;
      
      public function PeopleManageView()
      {
         super();
         this.updateProperty();
      }
      
      public static function chartUnusualCloth(clothArr:Array = null) : int
      {
         var myNum:int = 0;
         var clothArray:Array = clothArr != null ? clothArr : LocalUserInfo.getClothItem();
         clothArray = clothArray.slice(0);
         clothArray.sortOn("layer",16);
         while(Boolean(clothArray[0]) && clothArray[0].layer < 5)
         {
            clothArray.shift();
         }
         var tempArray:Array = new Array();
         for(var i:int = 0; i < clothArray.length; i++)
         {
            tempArray.push(clothArray[i].id);
         }
         tempArray.sort();
         if(tempArray.indexOf(12991) >= 0)
         {
            tempArray.splice(tempArray.indexOf(12991),1);
         }
         var str:String = String(tempArray);
         if(Boolean(clothArray.length) && GoodsInfo.ClothObject[str] != null)
         {
            myNum = int(GoodsInfo.ClothObject[str]);
         }
         return myNum;
      }
      
      public static function checkWork(clothArr:Array = null) : String
      {
         var myNum:int = 0;
         var clothArray:Array = clothArr != null ? clothArr : LocalUserInfo.getClothItem();
         clothArray = clothArray.slice(0);
         clothArray.sortOn("layer",16);
         while(Boolean(clothArray[0]) && clothArray[0].layer < 5)
         {
            clothArray.shift();
         }
         var tempArray:Array = new Array();
         for(var i:int = 0; i < clothArray.length; i++)
         {
            tempArray.push(clothArray[i].id);
         }
         tempArray.sort();
         var str:String = String(tempArray);
         if(Boolean(clothArray.length) && GoodsInfo.ClothObject[str] != null)
         {
            myNum = int(GoodsInfo.ClothObject[str]);
         }
         return GoodsInfo.ClothObject[myNum];
      }
      
      public function get angelFollow() : AngelFollowMole
      {
         return this._angelFollow;
      }
      
      public function get newAngelFollow() : NewAngelFollowMole
      {
         return this._newAngelFollow;
      }
      
      public function get pigFollow() : PigFollowMole
      {
         return this._pigFollow;
      }
      
      public function get hasAngel() : Boolean
      {
         return this._hasAngel;
      }
      
      public function set hasAngel(value:Boolean) : void
      {
         this._hasAngel = value;
      }
      
      public function get hasPig() : Boolean
      {
         return this._hasPig;
      }
      
      public function set hasPig(value:Boolean) : void
      {
         this._hasPig = value;
      }
      
      private function onUpdate(delay:Number) : void
      {
         this._effectMC.x = this.x;
         this._effectMC.y = this.y;
      }
      
      public function updateProperty() : void
      {
         if(Boolean(this.avatarMC))
         {
            GC.clearAll(this.avatarMC);
         }
         alpha = 1;
         this.visible = true;
         scaleX = scaleY = 1;
         this.avatarMC = IndexManager.getInstance().getMovieClip("PeopleModel_mc");
         this._effectMC = new Sprite();
         MainManager.getBaseLevel().addChild(this._effectMC);
         this.ResurrectInANewGuise(this.avatarMC,"Visualize_mc","com.view.PeopleView.VisualizeView");
         this.ResurrectInANewGuise(this.avatarMC,"pet_mc","com.view.PeopleView.petView");
         var tempClass:Class = UIManager.getClass("motionMC");
         this.motionClass = new tempClass();
         this.motionClass.mc = this.avatarMC;
         this.avatarMC.nickName_txt.visible = true;
         this.avatarMC.y = 0;
         this.avatarMC.mouseEnabled = false;
         addChild(this.avatarMC);
         this.targetXY = new Object();
         this.startXY = new Object();
         this.specificObj = new Object();
         Status = new Object();
         this.Action = 0;
         this.Action2 = 0;
         this.PetObj = null;
         this.Activity = null;
         this.Family = null;
         this.PetID = null;
         this.PetColor = null;
         this.Petlevel = null;
         this.PetSkill = null;
         this.car = null;
         this.animal = null;
         this.changeBody = 0;
         this.address = "0";
         this.lamuinfo = null;
         this.isFlying = false;
         this.isFootballBay = false;
         this.isActionMovie = false;
         this.isVisible = false;
         this.isNewPeople = true;
         this.isMoving = false;
         this._hasCar = false;
         this._hasDragon = false;
         this._hasAnimal = false;
         this._lamuMode = false;
         this.hasLamu = false;
         this.avatarMC.wordBox.showMSG_txt.autoSize = TextFieldAutoSize.LEFT;
         this.avatarMC.wordBox.showMSG_txt.wordWrap = true;
         this.avatarMC.wordBox.visible = false;
         this.mouseEnabled = false;
         this.metier = checkWork(this.clothsArray);
         LocalUserInfo.lamuinfo = this.lamuinfo = null;
         BC.addEvent(this,GV.onlineSocket,MapEvent.READY_CHANGE_MAP,this.clearEvents);
         this.showBoxTimer = new Timer(this.delay,1);
         BC.addEvent(this,this.showBoxTimer,"timerComplete",this.timerCompleteHandler);
         Tick.instance.addCallback(this.onUpdate);
      }
      
      public function getVisualize(instanceMC:PeopleManageView, gender:uint, type:uint = 1) : void
      {
         var tv1_mc:* = undefined;
         var tv2_mc:* = undefined;
         this.avatarMC.y = 0;
         this.avatarMC.shadow_mc.y = 0;
         this.isRefurbishAvatar = false;
         if(this.avatarClass != null)
         {
            GC.clearChildren(this.avatarMC.Visualize_mc);
            this.avatarClass.reMoveInstanceMC();
            this.isRefurbishAvatar = true;
         }
         this.isActionMovie = false;
         if(this.Action == 17003)
         {
            type = 17003;
         }
         if(type == 0 || PatchPeopleManageView.isBoyAvatarType(type))
         {
            type = 1;
         }
         if(LamuMantra.currentMagic == "xingchenshouhu")
         {
            type = 1;
         }
         this.avatarMC.shadow_mc.alpha = 1;
         switch(type)
         {
            case 1:
               this.address = "0";
               this.avatarClass = ObjectPool.getObject(BoyAvatar);
               break;
            case 2:
               this.address = "0";
               this.avatarClass = ObjectPool.getObject(BoyAvatar);
               break;
            case 17001:
               this.address = "17001";
               this.avatarClass = ObjectPool.getObject(TransfigurationAvatar);
               break;
            case 17002:
               this.address = "17002";
               this.avatarClass = ObjectPool.getObject(TransfigurationAvatar);
               break;
            case 17003:
               this.address = "17003";
               this.avatarClass = ObjectPool.getObject(BoyAvatar);
               break;
            case 17004:
               this.address = "17004";
               this.avatarClass = ObjectPool.getObject(TransfigurationAvatar);
               break;
            case 17005:
               this.address = "17005";
               this.avatarClass = ObjectPool.getObject(TransfigurationAvatar);
               break;
            case 17006:
               this.address = "17006";
               this.avatarClass = ObjectPool.getObject(TransfigurationAvatar);
               break;
            case 17007:
               this.address = "17007";
               this.avatarClass = ObjectPool.getObject(TransfigurationAvatar);
               break;
            case 17008:
               this.address = "17008";
               this.avatarClass = ObjectPool.getObject(TransfigurationAvatar);
               break;
            case 18001:
               this.address = "18001";
               this.avatarClass = ObjectPool.getObject(TransfigurationAvatar);
               break;
            case 19000:
               this.address = "19000";
               this.avatarClass = ObjectPool.getObject(TransfigurationAvatar);
               break;
            case 19000:
               this.address = "19001";
               this.avatarClass = ObjectPool.getObject(TransfigurationAvatar);
               break;
            case 19000:
               this.address = "19002";
               this.avatarClass = ObjectPool.getObject(TransfigurationAvatar);
               break;
            case 120000:
               this.address = "120000";
               this.avatarClass = ObjectPool.getObject(BoyAvatar);
               break;
            case 17010:
               this.address = "17010";
               this.avatarClass = ObjectPool.getObject(TransfigurationAvatar);
               break;
            case 50001:
               this.address = "redPlayer";
               this.avatarClass = ObjectPool.getObject(footballAvatar);
               break;
            case 50002:
               this.address = "bluePlayer";
               this.avatarClass = ObjectPool.getObject(footballAvatar);
               break;
            case 10004:
            case 10005:
            case 10006:
            case 10007:
            case 10008:
            case 10009:
            case 10010:
            case 10011:
               this.address = type.toString();
               this.avatarClass = ObjectPool.getObject(pumpkinAvatar);
               break;
            case 10012:
               this.address = "10012";
               break;
            case 10013:
            case 10014:
            case 10015:
            case 10016:
            case 10017:
            case 10018:
               this.address = type.toString();
               this.avatarClass = ObjectPool.getObject(TransfigurationAvatar);
               break;
            case 17011:
            case 17013:
            case 17014:
            case 17015:
            case 17016:
            case 17017:
            case 17018:
            case 17019:
            case 17020:
            case 17021:
            case 17028:
            case 17029:
            case 17030:
            case 17031:
            case 17032:
            case 17033:
            case 150017:
            case 17037:
            case 17038:
            case 17051:
               this.address = type.toString();
               this.avatarClass = ObjectPool.getObject(TransfigurationAvatar);
               break;
            case 10019:
               this.address = "10019";
               this.avatarClass = ObjectPool.getObject(TransfigurationAvatar);
               break;
            case 17023:
            case 17024:
            case 17025:
            case 17026:
            case 10000:
            case 10001:
            case 10002:
            case 17027:
               this.address = type.toString();
               this.avatarClass = ObjectPool.getObject(TransfigurationAvatar);
               break;
            default:
               this.address = String(type);
               tv1_mc = MainManager.getAppLevel().getChildByName("bigMc");
               if(Boolean(tv1_mc))
               {
                  tv1_mc.x = 1500;
               }
               tv2_mc = MainManager.getToolLevel().getChildByName("special_mc");
               if(Boolean(tv2_mc))
               {
                  tv2_mc.x = 1500;
               }
               tv1_mc = null;
               tv2_mc = null;
               this.avatarClass = ObjectPool.getObject(TransfigurationAvatar);
         }
         this.getColor();
         this.avatarClass["init"](this,this.avatarMC);
         this.changeColor();
         this.clothsManage = this.avatarClass.clothClass;
         this.init();
      }
      
      public function init() : void
      {
         var tempTimer:Timer = null;
         var toolBar_MC:* = undefined;
         var task300State:uint = 0;
         this.headTopBtn = new TailButtonView();
         this._hitBtn = new TailButtonView();
         this._hitBtn.fineTailTarget(this);
         this.headTopBtn.fineTail2Target(this);
         MapButtonView.getTarget().addChild(this.headTopBtn);
         if(Boolean(this._hitBtn))
         {
            this._hitBtn.offsetPoint = new Point(0,this.avatarMC.y);
         }
         this.addPet();
         try
         {
            this.addTarget();
            if(!this._hitBtn.hide)
            {
               this._hitBtn.x = x;
               this._hitBtn.y = y;
            }
            BC.addEvent(this,this._hitBtn,MouseEvent.MOUSE_OVER,this.onHitMouseOver);
            BC.addEvent(this,this._hitBtn,MouseEvent.MOUSE_DOWN,this.onHitMouseDown);
            BC.addEvent(this,this._hitBtn,MouseEvent.CLICK,this.onHitClick);
            BC.addEvent(this,this._hitBtn,MouseEvent.MOUSE_OUT,this.clearActionTipICO);
            if(!this._hasCar)
            {
               ClothAction.checkCloth(this);
            }
            if(GV.MyInfo_userID != this.id)
            {
               this._hitBtn.buttonMode = true;
               if(Boolean(this._petHitBtn))
               {
                  this._petHitBtn.buttonMode = true;
               }
            }
            else
            {
               tempTimer = new Timer(2000,1);
               BC.addEvent(this,tempTimer,TimerEvent.TIMER_COMPLETE,function(E:TimerEvent):void
               {
                  try
                  {
                     if(GV.hasNewLever)
                     {
                        GF.talkAll();
                        GF.showLeverUp(GV.MAN_PEOPLE);
                        GV.hasNewLever = false;
                     }
                     if(Boolean(GV.hasNewMadel))
                     {
                        GF.talkAll(true,GV.hasNewMadel);
                        GF.showLeverUp(GV.MAN_PEOPLE,GV.hasNewMadel);
                        GV.hasNewMadel = 0;
                     }
                  }
                  catch(err:TypeError)
                  {
                     trace(err);
                  }
                  tempTimer.stop();
                  BC.removeEvent(this,tempTimer,TimerEvent.TIMER_COMPLETE,arguments.callee);
                  tempTimer = null;
               });
               tempTimer.start();
               this._hitBtn.buttonMode = true;
               if(Boolean(this._petHitBtn))
               {
                  this._petHitBtn.buttonMode = true;
               }
               toolBar_MC = MainManager.getToolLevel().getChildByName("tool_mc");
               if(toolBar_MC != null)
               {
                  task300State = TaskManager.getTaskState(300);
                  if(task300State != 1)
                  {
                     if(GV.MAN_PEOPLE.address != "0")
                     {
                        toolBar_MC.special_btn.visible = false;
                        toolBar_MC.action_btn.visible = false;
                        specialView.owner.clearMS();
                     }
                     else
                     {
                        toolBar_MC.special_btn.visible = true;
                        toolBar_MC.action_btn.visible = true;
                        toolBar_MC.house_btn.visible = true;
                        toolBar_MC.friend_btn.visible = true;
                        toolBar_MC.bag_btn.visible = true;
                     }
                  }
               }
               toolBar_MC = null;
            }
         }
         catch(E:TypeError)
         {
         }
         this.refurbishPet();
         if(this.isRefurbishAvatar)
         {
            dispatchEvent(new Event(ON_AVATAR_REFURBISH));
         }
      }
      
      public function addTarget(E:Event = null) : void
      {
         if(Boolean(this._hitBtn) && this._hitBtn.parent != MapButtonView.getTarget())
         {
            MapButtonView.getTarget().addChild(this._hitBtn);
         }
         if(Boolean(this._petHitBtn) && this._petHitBtn.parent != MapButtonView.getTarget())
         {
            MapButtonView.getTarget().addChild(this._petHitBtn);
         }
      }
      
      public function delTarget(E:Event = null) : void
      {
         if(Boolean(this._hitBtn) && this._hitBtn.parent == MapButtonView.getTarget())
         {
            MapButtonView.getTarget().removeChild(this._hitBtn);
         }
         if(Boolean(this._petHitBtn) && this._petHitBtn.parent == MapButtonView.getTarget())
         {
            MapButtonView.getTarget().removeChild(this._petHitBtn);
         }
         if(Boolean(this.headTopBtn))
         {
            DisplayUtil.removeForParent(this.headTopBtn);
         }
      }
      
      override public function set visible(b:Boolean) : void
      {
         if(LocalUserInfo.getIsHideOtherMole() && LocalUserInfo.getUserID() != this.id)
         {
            super.visible = false;
         }
         else
         {
            super.visible = b;
         }
         if(Boolean(this._effectMC))
         {
            this._effectMC.visible = b;
         }
         if(visible)
         {
            this.addTarget();
         }
         else
         {
            this.delTarget();
         }
      }
      
      public function ResurrectInANewGuise(pm:MovieClip, name1:String, name2:String) : void
      {
         var index:int = pm.getChildIndex(pm[name1]);
         pm.removeChild(pm[name1]);
         var cls:Class = getDefinitionByName(name2) as Class;
         var tmc:DisplayObjectContainer = new cls();
         tmc.x = pm[name1].x;
         tmc.y = pm[name1].y;
         pm[name1] = tmc;
         pm.addChildAt(pm[name1],index);
      }
      
      public function checkNewPeople() : void
      {
         this.checkNewPeopleTimer = new Timer(200,1);
         BC.addEvent(this,this.checkNewPeopleTimer,TimerEvent.TIMER_COMPLETE,this.initPeopleStatus);
         this.checkNewPeopleTimer.start();
      }
      
      private function initPeopleStatus(E:TimerEvent) : void
      {
         this.isNewPeople = false;
         BC.removeEvent(this,this.checkNewPeopleTimer,TimerEvent.TIMER_COMPLETE,this.initPeopleStatus);
         if(Boolean(this.checkNewPeopleTimer))
         {
            this.checkNewPeopleTimer.stop();
         }
         this.checkNewPeopleTimer = null;
         this.avatarClass.showJGPTimer(2500);
      }
      
      public function gotoHere(pathArray:Array, delayNum:uint) : void
      {
         if(Boolean(this.avatarClass))
         {
            this.avatarClass.gotoHere(pathArray,delayNum);
         }
      }
      
      public function moveTo(_x:int, _y:int) : Boolean
      {
         return MoveTo.AutoFind(_x,_y,this);
      }
      
      public function set lamuMode(bool:Boolean) : void
      {
         if(this._lamuMode != bool)
         {
            if(bool)
            {
               if(Boolean(this.lamu) && this.lamu["scaleX"] == 1.3)
               {
                  return;
               }
               this.avatarMC.pet_mc.x = 0;
               this.avatarMC.pet_mc.y = 0;
               this.avatarMC.Visualize_mc.visible = false;
               this.avatarMC.shadow_mc.visible = false;
               this.avatarMC.car_mc.visible = true;
               if(Boolean(this._hitBtn))
               {
                  this._hitBtn.destroy();
                  this._hitBtn = null;
               }
               this._petHitBtn.offsetPoint = new Point(0,0);
               this._petHitBtn.x = x;
               this.lamu.boneManaage.lamuName = this.nickName + "的拉姆-" + this.lamuinfo.PetName;
               this.avatarMC.nickName_txt.visible = false;
               this.lamu["scaleX"] = 1.3;
               this.lamu["scaleY"] = 1.3;
            }
            else
            {
               if(!this.lamu)
               {
                  return;
               }
               this.lamu.boneManaage.lamuName = "";
               this.avatarMC.pet_mc.x = 35;
               this.avatarMC.pet_mc.y = 10;
               this.avatarMC.Visualize_mc.visible = true;
               this.avatarMC.shadow_mc.visible = true;
               this.avatarMC.car_mc.visible = false;
               this._hitBtn = new TailButtonView();
               this._hitBtn.fineTailTarget(this);
               if(Boolean(this._hitBtn))
               {
                  this._hitBtn.offsetPoint = new Point(0,this.avatarMC.y);
               }
               this._petHitBtn.offsetPoint = new Point(0,35);
               this.lamu.boneManaage.lamuName = "";
               this.avatarMC.nickName_txt.visible = true;
               this.lamu["scaleX"] = 1;
               this.lamu["scaleY"] = 1;
            }
         }
         this._lamuMode = bool;
      }
      
      public function get lamuMode() : Boolean
      {
         return this._lamuMode;
      }
      
      public function set hasDragon(bool:Boolean) : void
      {
         this._hasDragon = bool;
      }
      
      public function get hasDragon() : Boolean
      {
         return this._hasDragon;
      }
      
      public function set hasCar(bool:Boolean) : void
      {
         this._hasCar = bool;
      }
      
      public function get hasCar() : Boolean
      {
         return this._hasCar;
      }
      
      public function set hasAnimal(bool:Boolean) : void
      {
         this._hasAnimal = bool;
      }
      
      public function get hasAnimal() : Boolean
      {
         return this._hasAnimal;
      }
      
      public function set isMoving(bool:Boolean) : void
      {
         this._isMoving = bool;
      }
      
      public function get isMoving() : Boolean
      {
         return this._isMoving;
      }
      
      public function onHitMouseOver(E:MouseEvent) : void
      {
         if(E.currentTarget == this._hitBtn)
         {
            HitConditional.MOUSE_OVER(this,E);
         }
         else
         {
            PetHitConditional.MOUSE_OVER(this,E);
         }
      }
      
      public function onHitMouseDown(E:MouseEvent) : void
      {
         if(E.currentTarget == this._hitBtn)
         {
            HitConditional.MOUSE_DOWN(this,E);
         }
         else
         {
            PetHitConditional.MOUSE_DOWN(this,E);
         }
      }
      
      public function onHitClick(E:MouseEvent) : void
      {
         var obj:Object = null;
         var isUserPan:Boolean = false;
         var isCap:Boolean = false;
         for each(obj in this.clothsArray)
         {
            if(obj.id == 14400)
            {
               isCap = true;
            }
         }
         if(isCap == false || KFCManager.isGetCapGift || LocalUserInfo.getUserID() == this.id)
         {
            if(E.currentTarget == this._hitBtn)
            {
               HitConditional.CLICK(this,E);
               isUserPan = HitConditional.HitType == HitConditional.USER_PAN;
               if(isUserPan)
               {
                  userPanelView.showUserPanel(this.id);
               }
            }
            else
            {
               PetHitConditional.CLICK(this,E);
               if(this.PetID != 0 && this.PetID != undefined)
               {
                  if(GV.MyInfo_PetObj.SpriteID == this.PetID && this.id == LocalUserInfo.getUserID())
                  {
                     petPanel.init(this.id,this.PetID,1,null);
                  }
                  else
                  {
                     petPanel.init(this.id,this.PetID,3,null);
                  }
                  return;
               }
            }
            HitConditional.HitType = HitConditional.USER_PAN;
         }
         else
         {
            Presented.getInstance().celebrate1225(1647);
            KFCManager.updateCapGift();
         }
      }
      
      public function clearActionTipICO(E:MouseEvent) : void
      {
         if(E.currentTarget == this._hitBtn)
         {
            HitConditional.MOUSE_OUT(this,E);
         }
         else
         {
            PetHitConditional.MOUSE_OUT(this,E);
         }
      }
      
      public function say(msg:String) : void
      {
         var obj:Object = {"msg":msg};
         this.showWordBoxMSG({"EventObj":obj});
      }
      
      public function showWordBoxMSG(E:*) : void
      {
         var tempStr:String = null;
         var tempNum:int = 0;
         var i:uint = 0;
         var tArray:Array = null;
         var tag:String = null;
         var tempObj:Object = E.EventObj;
         var poss:String = tempObj.msg;
         if(poss.substr(0,1) == "/")
         {
            tempStr = poss.substr(1,2);
            tempNum = -1;
            for(i = 0; i < GV.expressionArray.length; i++)
            {
               if(GV.expressionArray[i] == tempStr)
               {
                  tempNum = int(i);
                  break;
               }
            }
            if(Boolean(tempStr.length) && !isNaN(Number(tempStr)))
            {
               tempNum = int(tempStr);
            }
            if(tempNum > -1)
            {
               if(tempNum == 24)
               {
                  tArray = poss.split(":");
                  tArray.shift();
                  tag = tArray.shift();
                  StageActionLogic.msgAction(this,this.id,poss,tag,tArray.join(""));
               }
               else
               {
                  this.startHandler(poss,tempNum + 1);
               }
            }
            else
            {
               this.startHandler(poss);
            }
         }
         else
         {
            this.startHandler(poss);
         }
      }
      
      public function startHandler(msg:String, hasExpression:uint = 0) : void
      {
         var tempMC:MovieClip = null;
         var myClass:* = undefined;
         if(this.showBoxTimer.running)
         {
            this.showBoxTimer.stop();
            tempMC = this.avatarMC.wordBox.getChildByName("ep");
            if(tempMC != null)
            {
               GC.clearAll(tempMC);
            }
         }
         msg = msg.split("                 ").join("");
         this.showBoxTimer.start();
         this.avatarMC.wordBox.showMSG_txt.setTextFormat(new TextFormat(null,14));
         if(hasExpression == 0)
         {
            msg = msg.substr(0,20);
            this.avatarMC.wordBox.visible = true;
            this.avatarMC.wordBox.showMSG_txt.text = msg;
            this.avatarMC.wordBox.BG.width = this.avatarMC.wordBox.showMSG_txt.textWidth + 20;
            this.avatarMC.wordBox.BG.height = this.avatarMC.wordBox.showMSG_txt.textHeight + 20;
            this.avatarMC.wordBox.msgjt_mc.gotoAndStop(1);
            if(this.avatarMC.wordBox.showMSG_txt.textWidth < 50)
            {
               this.avatarMC.wordBox.msgjt_mc.gotoAndStop(2);
               this.avatarMC.wordBox.BG.height = this.avatarMC.wordBox.showMSG_txt.textHeight + 16;
            }
         }
         else
         {
            this.avatarMC.wordBox.msgjt_mc.gotoAndStop(1);
            myClass = UIManager.getClass("expression_mc");
            tempMC = new myClass();
            tempMC.name = "ep";
            tempMC.gotoAndStop(hasExpression);
            tempMC.x = 25;
            tempMC.y = 5;
            tempMC.scaleX = 1.5;
            tempMC.scaleY = 1.5;
            this.avatarMC.wordBox.addChild(tempMC);
            this.avatarMC.wordBox.showMSG_txt.text = "";
            this.avatarMC.wordBox.visible = true;
            this.avatarMC.wordBox.BG.width = 85;
            this.avatarMC.wordBox.BG.height = 50;
         }
         this.avatarMC.wordBox.msgjt_mc.x = this.avatarMC.wordBox.BG.width / 2 + this.avatarMC.wordBox.BG.width / 10;
         this.avatarMC.wordBox.msgjt_mc.y = this.avatarMC.wordBox.BG.height;
         this.avatarMC.wordBox.x = -this.avatarMC.wordBox.BG.width / 2;
         this.avatarMC.wordBox.y = -this.avatarMC.wordBox.height - 50;
      }
      
      public function timerCompleteHandler(E:*) : void
      {
         this.avatarMC.wordBox.showMSG_txt.text = "";
         this.avatarMC.wordBox.visible = false;
         var tempMC:MovieClip = this.avatarMC.wordBox.getChildByName("ep");
         if(tempMC != null)
         {
            GC.clearAll(tempMC);
         }
      }
      
      public function getClothMsg() : Array
      {
         var clothMsgArray:Array = new Array();
         for(var j:int = 0; j < this.clothsArray.length; j++)
         {
            clothMsgArray.push(this.clothsArray[j].id);
         }
         return this.clothsArray;
      }
      
      public function changeLayer(LayerObj:*) : void
      {
         MapModelLogic.changeLayer(this,LayerObj);
      }
      
      public function getColor() : void
      {
         try
         {
            this.Family = this.Family == 0 ? 1 : this.Family;
            this.colorObj = GF.getRGBColor(this.Family);
            if(this.id == GV.MyInfo_userID)
            {
               GV.myInfo_Color = this.colorObj;
            }
         }
         catch(E:*)
         {
         }
      }
      
      public function changeColor() : void
      {
         if(!this.avatarClass.isActionMovie)
         {
            this.avatarClass.changeColor(this.colorObj);
         }
      }
      
      public function addRotation() : void
      {
         this.avatarClass.addRotation();
      }
      
      public function DelRotation() : void
      {
         this.avatarClass.DelRotation();
      }
      
      public function fly(flyType:String) : Boolean
      {
         this.isFlying = true;
         BC.addEvent(this,this,ON_FLY_COMPLETE,function(E:*):void
         {
            BC.removeEvent(E.target,E.target,ON_FLY_COMPLETE);
            changeLayer(MapModelLogic.AIR_LAYER);
         });
         this.motionClass.gotoAndStop(flyType);
         return true;
      }
      
      public function touchdown() : Boolean
      {
         BC.addEvent(this,this,ON_FLY_TOUCHDOWN,function(E:*):void
         {
            isFlying = false;
            changeLayer(MapModelLogic.FLOOR_LAYER);
            BC.removeEvent(E.target,E.target,ON_FLY_TOUCHDOWN);
         });
         this.motionClass.gotoAndStop(this.motionClass.type + "D");
         return true;
      }
      
      public function sitDown(dirNum:int = -1) : Boolean
      {
         if(this.avatarClass.isActionMovie)
         {
            return false;
         }
         if(dirNum < 0)
         {
            dirNum = int(this.avatarClass.DirectionNum);
         }
         this.avatarClass.sitDown(dirNum);
         return true;
      }
      
      public function wave() : Boolean
      {
         if(this.avatarClass.isActionMovie)
         {
            return false;
         }
         var tempNum:int = chartUnusualCloth(this.clothsArray);
         var str:String = GoodsInfo.ClothObject["Action_" + tempNum];
         if(str != null && str.indexOf("W") > -1)
         {
            if(this.id == GV.MyInfo_userID && GoodsInfo.ClothObject[tempNum] == "記者" && !SaveCutMap.isUseCamera)
            {
               SaveCutMap.GetCamera();
            }
            this.avatarClass.wave();
            if(GoodsInfo.ClothObject["ActName_" + tempNum] != "")
            {
               this.avatarClass.specialAct("wave_" + GoodsInfo.ClothObject[tempNum] + "_down",ON_ACTION_WAVE,tempNum);
            }
         }
         else
         {
            this.avatarClass.wave();
         }
         return true;
      }
      
      public function dance() : Boolean
      {
         var msg:String = null;
         if(this.avatarClass.isActionMovie)
         {
            return false;
         }
         var tempNum:int = chartUnusualCloth(this.clothsArray);
         var str:String = GoodsInfo.ClothObject["Action_" + tempNum];
         if(str != null && str.indexOf("D") > -1)
         {
            if(this.id == GV.MyInfo_userID && GoodsInfo.ClothObject[tempNum] == "導遊")
            {
               msg = GV.xd_msg[int(Math.random() * GV.xd_msg.length)];
               GV.onlineClass.chating(0,msg);
            }
            this.avatarClass.specialAct("dance_" + GoodsInfo.ClothObject[tempNum] + "_down",ON_ACTION_DANCE,tempNum);
         }
         else
         {
            this.avatarClass.dance();
         }
         return true;
      }
      
      public function openBook(e:* = null) : void
      {
         if(Boolean(e))
         {
            ActionReq.actions2(1);
         }
         if(Boolean(this.avatarClass))
         {
            this.avatarClass.openBook();
         }
      }
      
      public function closeBook(e:* = null) : void
      {
         if(Boolean(e))
         {
            ActionReq.actions2(0);
         }
         if(Boolean(this.avatarClass))
         {
            this.avatarClass.closeBook();
         }
      }
      
      public function scaleBody(num:Number = 1.5) : void
      {
         this.avatarClass.scaleBody(num);
      }
      
      public function scaleXY(size:Number) : void
      {
         TweenLite.to(this.avatarMC.Visualize_mc,1,{
            "scaleX":size,
            "scaleY":size,
            "ease":Bounce.easeInOut
         });
         TweenLite.to(this.avatarMC.shadow_mc,1,{
            "scaleX":size,
            "scaleY":size,
            "ease":Bounce.easeInOut
         });
      }
      
      public function stopAction(dir:String = "") : void
      {
         this.avatarClass.stopAction(dir);
      }
      
      public function throwThing(obj:Object) : void
      {
         this.avatarClass.throwThing(obj);
      }
      
      public function stopToHere() : void
      {
         this.avatarClass.stopToHere();
      }
      
      public function ChangeCloths() : void
      {
         if(Boolean(this.avatarClass) && !this.avatarClass.isActionMovie)
         {
            this.clothsManage.refurbishCloths();
            dispatchEvent(new PeopleEvent(PeopleEvent.PEOPLE_CHANGE_CLOTH));
         }
      }
      
      public function Cloth_PutOn_And_Save(ItemID_or_ItemObj:*) : void
      {
         var obj:Object = ItemID_or_ItemObj is Number ? GoodsInfo.getInfoById(ItemID_or_ItemObj) : ItemID_or_ItemObj;
         this.clothsManage.putOn(obj);
         if(this.id == LocalUserInfo.getUserID())
         {
            new UseUserItemRigReq().useUserItemRig(this.clothsArray.slice(0));
         }
      }
      
      public function Cloth_PutOff_And_Save(ItemID_or_ItemObj:*) : void
      {
         var obj:Object = ItemID_or_ItemObj is Number ? GoodsInfo.getInfoById(ItemID_or_ItemObj) : ItemID_or_ItemObj;
         this.clothsManage.getOff(obj);
         if(this.id == LocalUserInfo.getUserID())
         {
            new UseUserItemRigReq().useUserItemRig(this.clothsArray.slice(0));
         }
      }
      
      public function addEffect(ef:*, isUp:Boolean = true, lib:Loader = null) : void
      {
         var effect_mc:DisplayObject = null;
         this.removeEffect();
         if(ef is String)
         {
            if(Boolean(lib))
            {
               effect_mc = LibLogic.getLibClassInstacen(lib,ef);
            }
            else
            {
               effect_mc = IndexManager.getInstance().getMovieClip(ef);
            }
         }
         else if(ef is Class)
         {
            effect_mc = new ef();
         }
         else if(Boolean(ef as DisplayObject))
         {
            effect_mc = ef;
         }
         if(isUp)
         {
            this._effectMC.addChild(effect_mc);
         }
         else
         {
            this._effectMC.addChildAt(effect_mc,0);
         }
      }
      
      public function removeEffect() : void
      {
         DisplayUtil.removeAllChild(this._effectMC);
      }
      
      public function setEffectEnabled(value:Boolean) : void
      {
         this._effectMC.mouseChildren = this._effectMC.mouseEnabled = value;
      }
      
      public function ChangeEffect(ef:*, isUp:Boolean = true, lib:Loader = null) : void
      {
         this.addEffect(ef,isUp,lib);
      }
      
      public function addAnimalOrUpDate(info:AnimalInfo) : void
      {
         var thisObj:PeopleManageView = null;
         var loadLibcomplete:Function = null;
         this.AngelUnFollow();
         thisObj = this;
         if(this.hasAnimal)
         {
            BC.removeEvent(thisObj,FieldView.Field_Lib,AssetsManage.ON_COMPLETE,loadLibcomplete);
         }
         this.hasAnimal = true;
         loadLibcomplete = function(E:Event):void
         {
            BC.removeEvent(thisObj,FieldView.Field_Lib,AssetsManage.ON_COMPLETE,loadLibcomplete);
            flowPeople(info);
         };
         BC.addEvent(thisObj,FieldView.Field_Lib,AssetsManage.ON_COMPLETE,loadLibcomplete);
         FieldView.Field_Lib.IncludeLib("Field_Lib",Links.getUrl("module/field/FieldManage.swf"),"正在召喚牧場動物...",false);
      }
      
      private function flowPeople(info:AnimalInfo) : void
      {
         if(Boolean(this.animal) && this.animal.getAnimalData().ID == info.ID)
         {
            this.animal.upAnimalData(info);
         }
         else
         {
            if(Boolean(this.animal))
            {
               this.animal.clearClass();
            }
            this.animal = ObjectPool.getObject(FieldView.Field_Lib.getClass("LandAnimal_Follow"));
            this.animal.showAnimal(info);
            this.animal.followMole(this);
         }
         if(this.id == LocalUserInfo.getUserID())
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee(AnimalSkillEvent.CHANGE_CARRY_ANIMAIL_EVENT,this.animal));
         }
      }
      
      public function delAnimal() : void
      {
         if(Boolean(this.animal))
         {
            this.hasAnimal = false;
            this.animal.clearClass();
            this.animal = null;
         }
      }
      
      public function AngelFollow(id:int) : void
      {
         this.delAnimal();
         this.AngelUnFollow();
         this.PigUnFollow();
         this._angelFollow = new AngelFollowMole(id,this);
         this._hasAngel = true;
      }
      
      public function NewAngelFollow(angelID:int, angleIndex:int = 0) : void
      {
         this.delAnimal();
         this.AngelUnFollow();
         this.PigUnFollow();
         this._newAngelFollow = new NewAngelFollowMole(angelID,angleIndex,this);
         this._hasAngel = true;
      }
      
      public function AngelUnFollow() : void
      {
         if(Boolean(this._angelFollow))
         {
            this._hasAngel = false;
            this._angelFollow.Clear();
            this._angelFollow = null;
         }
         if(Boolean(this._newAngelFollow))
         {
            this._hasAngel = false;
            this._newAngelFollow.Clear();
            this._newAngelFollow = null;
         }
      }
      
      public function PigFollow(data:Object) : void
      {
         this.delAnimal();
         this.AngelUnFollow();
         this.PigUnFollow();
         this._pigFollow = new PigFollowMole(data,this);
         this.hasPig = true;
      }
      
      public function PigUnFollow() : void
      {
         if(Boolean(this._pigFollow))
         {
            this.hasPig = false;
            this._pigFollow.Clear();
            this._pigFollow = null;
         }
      }
      
      public function addCar(info:CarInfo) : void
      {
         this.hasCar = true;
         if(Boolean(this.car) && Boolean(this.car_Info.ItemID == info.ItemID) && this.car_Info.CarID == info.CarID)
         {
            this.car_Info = info;
         }
         else
         {
            this.car = ObjectPool.getObject(Car);
            this.car_Info = info;
            this.car.driveCar(this,this.avatarMC.car_mc);
            this.avatarMC.car_mc.visible = true;
         }
         ClothAction.flyCarOrDragon(this);
         ClothAction.checkCloth(this);
      }
      
      public function delCar() : void
      {
         if(this.avatarMC == null)
         {
            return;
         }
         this.hasCar = false;
         this.avatarMC.Visualize_mc.visible = true;
         if(Boolean(this.car))
         {
            ObjectPool.disposeObject(this.car,Car,100);
            this.car["destroy"]();
         }
         this.car = null;
         ClothAction.stopFlyCarOrDragon(this);
         ClothAction.checkCloth(this);
      }
      
      public function addDragon(info:DragonInfo) : void
      {
         if(Boolean(this.dragon))
         {
            this.delDragon();
         }
         this._hasDragon = true;
         this.dragon = ObjectPool.getObject(Dragon);
         this.dragon_Info = info;
         this.dragon.driveDragon(this,this.avatarMC);
         this.avatarMC.pet_mc.x = -15;
         this.avatarMC.pet_mc.y = -10;
         ClothAction.flyCarOrDragon(this);
         ClothAction.checkCloth(this);
         if(Boolean(this._hitBtn))
         {
            this._hitBtn.offsetPoint = new Point(0,this.avatarMC.y);
         }
      }
      
      public function delDragon() : void
      {
         if(this.avatarMC == null)
         {
            return;
         }
         this.avatarMC.nickName_txt.y = 12;
         if(Boolean(this.avatarClass.multiEquipPlayer))
         {
            MultiEquipPlayer(this.avatarClass.multiEquipPlayer).updatePlayerPos(ClothConstant.NICK_DECORATION,new Point(0,0),false);
         }
         this.avatarMC.shadow_mc.y = 0;
         this._hasDragon = false;
         if(Boolean(this.dragon))
         {
            ObjectPool.disposeObject(this.dragon,Dragon,100);
            this.dragon["destroy"]();
         }
         this.dragon = null;
         this.avatarMC.pet_mc.x = 35;
         this.avatarMC.pet_mc.y = 10;
         this.ChangeCloths();
         ClothAction.stopFlyCarOrDragon(this);
         ClothAction.checkCloth(this);
         if(Boolean(this._hitBtn))
         {
            this._hitBtn.offsetPoint = new Point(0,this.avatarMC.y);
         }
      }
      
      public function get dragon_Info() : DragonInfo
      {
         if(Boolean(this.dragon))
         {
            return this.dragon.dragonInfo;
         }
         return null;
      }
      
      public function set dragon_Info(info:DragonInfo) : void
      {
         this.dragon.dragonInfo = info;
      }
      
      public function get car_Info() : CarInfo
      {
         if(Boolean(this.car))
         {
            return this.car.carInfo;
         }
         return null;
      }
      
      public function set car_Info(info:CarInfo) : void
      {
         this.car.carInfo = info;
      }
      
      public function get Animal_Info() : AnimalInfo
      {
         if(Boolean(this.animal))
         {
            return this.animal.getAnimalData();
         }
         return null;
      }
      
      public function set Animal_Info(info:AnimalInfo) : void
      {
         this.animal.upAnimalData(info);
      }
      
      public function lamu_follow_on() : void
      {
         if(Boolean(this.lamu))
         {
            GC.clearChildren(this.avatarMC.pet_mc);
            this.isLamuFollow = true;
            this.lamu.closeAutoMove_And_Stop();
            this.lamu.boneManaage.lamuName = "";
            if(!this._petHitBtn.hide)
            {
               this._petHitBtn.x = x + this.avatarMC.pet_mc.x;
               this._petHitBtn.y = y;
            }
            this.avatarMC.pet_mc.addChild(this.lamu as DisplayObjectContainer);
            this.lamu.x = 0;
            this.lamu.y = 0;
         }
      }
      
      public function lamu_follow_off() : void
      {
         if(Boolean(this.lamu))
         {
            this.avatarMC.pet_mc.addChild(new Sprite());
            this.isLamuFollow = false;
            this.lamu.x = x + this.avatarMC.pet_mc.x;
            this.lamu.y = y + this.avatarMC.pet_mc.y;
            this.lamu.boneManaage.lamuName = this.nickName + "的拉姆-" + this.lamuinfo.PetName;
            this._petHitBtn.x = -1000;
            this._petHitBtn.y = y;
            GV.MC_Depth.addChild(this.lamu as DisplayObjectContainer);
         }
      }
      
      private function loadPet() : void
      {
         if(!this.lamu)
         {
            this.lamu = ObjectPool.getObject(LamuNPC) as I_LamuNPC;
            this.lamu.setMasterID(this.id,this.lamuinfo);
            this.lamu.loadNPC(999);
            this.lamu.autoMove = false;
            this.petmc = this.lamu;
            this.avatarMC.pet_mc.x = 35;
            this.avatarMC.pet_mc.y = 10;
            this.avatarMC.pet_mc.addChild(this.lamu as DisplayObjectContainer);
            this._petHitBtn = new TailButtonView();
            MapButtonView.getTarget().addChild(this._petHitBtn);
            if(!this._petHitBtn.hide)
            {
               this._petHitBtn.x = x + this.avatarMC.pet_mc.x;
               this._petHitBtn.y = y;
            }
            this._petHitBtn.buttonMode = true;
            this._petHitBtn.scaleX = this._petHitBtn.scaleY = 0.8;
            this._petHitBtn.fineTailTarget(this.lamu as DisplayObjectContainer);
            BC.addEvent(this,this._petHitBtn,MouseEvent.MOUSE_OVER,this.onHitMouseOver);
            BC.addEvent(this,this._petHitBtn,MouseEvent.MOUSE_DOWN,this.onHitMouseDown);
            BC.addEvent(this,this._petHitBtn,MouseEvent.CLICK,this.onHitClick);
            BC.addEvent(this,this._petHitBtn,MouseEvent.MOUSE_OUT,this.clearActionTipICO);
            this.refurbishPet();
            if(this.id == LocalUserInfo.getUserID())
            {
               LamuSkillBar.getInstance();
               if(Boolean(creatShareObject.getInstance().getLahuWood()))
               {
                  this.addWoodPet(creatShareObject.getInstance().getLahuWood());
               }
            }
         }
         else
         {
            this.lamu["refurbish"]();
         }
         if(this.id == GV.MyInfo_userID)
         {
            if(Boolean(this.magicMC) && !creatShareObject.getInstance().getLahuWood())
            {
               GC.clearAll(this.magicMC);
               this.magicMC = null;
               this.lamu["visible"] = true;
            }
            else if(creatShareObject.getInstance().getLahuWood() == "shikongganying")
            {
               this.lamu["visible"] = true;
            }
            else
            {
               this.lamu["visible"] = false;
            }
         }
      }
      
      public function refurbishPet() : void
      {
         if(this.avatarMC.pet_mc.numChildren != 0)
         {
            if(this.PetID > 0)
            {
               BC.removeEvent(this,null,ON_ACTION_DANCE,this.Petdance);
               BC.removeEvent(this,null,ON_CHANGE_DIRECTION,this.changeDirection);
               BC.removeEvent(this,null,ON_GO_OVER,this.onGoBreak);
               BC.addEvent(this,this.avatarClass,ON_ACTION_DANCE,this.Petdance);
               BC.addEvent(this,this.avatarClass,ON_CHANGE_DIRECTION,this.changeDirection);
               BC.addEvent(this,this.avatarClass,ON_GO_OVER,this.onGoBreak);
               BC.removeEvent(this,this.avatarClass,null,this.dispatchEventToLamu);
               BC.addEvent(this,this.avatarClass,PeopleManageView.ON_GO_START,this.dispatchEventToLamu);
               BC.addEvent(this,this.avatarClass,PeopleManageView.ON_GO_OVER,this.dispatchEventToLamu);
               BC.addEvent(this,this.avatarClass,PeopleManageView.ON_GO_BREAK,this.dispatchEventToLamu);
            }
         }
         if(Boolean(this._petHitBtn))
         {
            if(this.PetID > 0)
            {
               this._petHitBtn.visible = true;
            }
            else
            {
               this._petHitBtn.visible = false;
            }
         }
      }
      
      private function dispatchEventToLamu(E:Event) : void
      {
         if(this.isLamuFollow && Boolean(this.lamu))
         {
            this.lamu["dispatchEvent"](E);
         }
      }
      
      public function delPet() : void
      {
         this.backPet();
      }
      
      public function addPet() : void
      {
         if(this.avatarMC.pet_mc.numChildren == 0)
         {
            if(this.PetID > 0)
            {
               this.hasLamu = true;
               if(this.id == GV.MyInfo_userID)
               {
                  if(!this.lamuinfo)
                  {
                     this.lamuinfo = LocalUserInfo.lamuinfo;
                  }
                  if(!this.lamuinfo)
                  {
                     if(Boolean(this.PetObj))
                     {
                        this.lamuinfo = new LamuInfo(this.PetObj);
                        LocalUserInfo.lamuinfo = this.lamuinfo;
                        this.lamuinfo.upData2(this.PetObj);
                     }
                  }
                  else
                  {
                     LocalUserInfo.lamuinfo = this.lamuinfo;
                     if(Boolean(this.PetObj))
                     {
                        this.lamuinfo.upData2(this.PetObj);
                     }
                  }
               }
               else if(!this.lamuinfo)
               {
                  if(Boolean(this.PetObj))
                  {
                     this.lamuinfo = new LamuInfo(this.PetObj);
                     this.lamuinfo.upData2(this.PetObj);
                  }
               }
               else if(Boolean(this.PetObj))
               {
                  this.lamuinfo.upData2(this.PetObj);
               }
               BC.addEvent(this,this.avatarClass,ON_ACTION_DANCE,this.Petdance);
               BC.addEvent(this,this.avatarClass,ON_CHANGE_DIRECTION,this.changeDirection);
               BC.addEvent(this,this.avatarClass,ON_GO_OVER,this.onGoBreak);
               this.loadPet();
               if(this._lamuMode)
               {
                  this.lamuMode = true;
               }
               this.lamu_follow_on();
               if(Boolean(this._petHitBtn))
               {
                  if(this.PetID > 0)
                  {
                     this._petHitBtn.visible = true;
                  }
                  else
                  {
                     this._petHitBtn.visible = false;
                  }
               }
            }
            if(this._lamuMode)
            {
               this.lamuMode = true;
            }
            this.lamu_follow_on();
            if(Boolean(this._petHitBtn))
            {
               if(this.PetID > 0)
               {
                  this._petHitBtn.visible = true;
               }
               else
               {
                  this._petHitBtn.visible = false;
               }
            }
         }
         else if(Boolean(this._petHitBtn))
         {
            if(this.PetID > 0)
            {
               this._petHitBtn.visible = true;
            }
            else
            {
               this._petHitBtn.visible = false;
            }
         }
      }
      
      public function sickPicVisible() : void
      {
      }
      
      public function addHaveClothPet() : void
      {
         this.loadPet();
      }
      
      public function loadClothPetComplete(e:Event) : void
      {
         if(Boolean(this.magicMC))
         {
            GC.clearAll(this.magicMC);
         }
         var tl:Loader = e.target.loader as Loader;
         this.magicMC = tl.content as MovieClip;
         this.avatarMC.pet_mc["addChild"](this.magicMC);
         this.setPetColor(this.magicMC.pet,this.PetColor);
         if(!creatShareObject.getInstance().getLahuWood())
         {
            this.lamu["visible"] = true;
         }
         else if(creatShareObject.getInstance().getLahuWood() == "shikongganying")
         {
            this.lamu["visible"] = true;
         }
         else
         {
            this.lamu["visible"] = false;
         }
      }
      
      public function addWoodPet(magicname:String) : void
      {
         var tempLoader:Loader = null;
         var url:String = null;
         if(Boolean(magicname))
         {
            tempLoader = new Loader();
            url = "resource/petcloth/body/pet" + this.Petlevel + "/" + magicname + ".swf";
            if(this.Petlevel >= 5 && this.Petlevel < 100)
            {
               url = "resource/petcloth/body/pet4/" + magicname + ".swf";
            }
            tempLoader.load(VL.getURLRequest(url));
            BC.addEvent(this,tempLoader.contentLoaderInfo,Event.COMPLETE,this.loadClothPetComplete);
         }
         else
         {
            this.loadPet();
         }
      }
      
      public function addNoClothPet() : void
      {
         this.loadPet();
      }
      
      public function PetRemoveCloth(itemid:uint, changeUserObj:Object) : void
      {
         var mole:* = undefined;
         if(this.id == GV.MyInfo_userID)
         {
            if(petPanel.PetID == this.PetID)
            {
               trace("我身上的拉姆脫衣服");
               if(Boolean(LocalUserInfo.lamuinfo))
               {
                  LocalUserInfo.lamuinfo.PetCloth = 0;
               }
               this.lamuinfo.PetCloth = this.Pet_cloth = this.PetCloth = 0;
               this.addNoClothPet();
            }
         }
         else if(Boolean(changeUserObj))
         {
            trace("別人身上的拉姆脫衣服");
            mole = GF.getPeopleByID(changeUserObj.UserID);
            if(mole.PetID == changeUserObj.PetID)
            {
               this.lamuinfo.PetCloth = this.Pet_cloth = this.PetCloth = 0;
               this.addNoClothPet();
            }
         }
      }
      
      public function changeBat() : void
      {
         this.changeBody = 1;
         this.petmc.gotoAndStop(this.avatarClass.DirectionNum + 41);
      }
      
      public function changeSuperPet() : void
      {
         this.changeBody = 0;
         this.petmc.gotoAndStop(this.avatarClass.DirectionNum + 11);
      }
      
      public function backPet(superLamu:Boolean = false) : void
      {
         this.hasLamu = false;
         if(!this.lamu)
         {
            return;
         }
         if(Boolean(this._petHitBtn) && Boolean(this._petHitBtn.parent))
         {
            MapButtonView.getTarget().removeChild(this._petHitBtn);
         }
         creatShareObject.getInstance().setLahuWood("");
         this.lamu.clearClass();
         this.lamu = null;
         GC.clearAll(this.magicMC);
         this.magicMC = null;
         GC.clearGInterval(this.PetSickID);
         this._petHitBtn.destroy();
         this.PetSick = 0;
         GC.stopAllMC(this.avatarMC.pet_mc);
         GC.clearAllChildren(this.avatarMC.pet_mc);
         LocalUserInfo.lamuinfo = null;
         this.lamuinfo = null;
         this.petmc = null;
         this.PetID = null;
         this.PetColor = null;
         this.Petlevel = null;
         this.PetSkill = null;
         this.PetCloth = 0;
         this.changeBody = 0;
         if(!superLamu)
         {
            if(LocalUserInfo.getUserID() == this.id)
            {
               GV.MyInfo_PetObj = new Object();
            }
         }
         dispatchEvent(new Event(ON_BACK_PET));
      }
      
      public function setPetColor(mc:DisplayObject, colorNum:uint) : void
      {
         var _array:Array = null;
         try
         {
            _array = GV["petColor_" + colorNum];
            mc.transform.colorTransform = new ColorTransform(_array[0],_array[1],_array[2],_array[3],_array[4],_array[5],_array[6],_array[7]);
         }
         catch(E:TypeError)
         {
         }
      }
      
      public function Petdance(evt:Event) : void
      {
         if(Boolean(this.lamu) && Boolean(!this.lamuinfo.isUserSKill) && (Boolean(this.lamuinfo.hasSkillAvatar() || !this.lamuinfo.PetCloth) || Boolean(GoodsInfo.getInfoById(this.lamuinfo.PetCloth).Layer < 65)))
         {
            this.lamu.boneManaage.currentDirection = "dance";
            this.lamu.boneManaage.isMoveing = true;
            this.lamu.boneManaage.isDoAction = this.avatarClass.isActionMovie;
         }
      }
      
      public function changeDirection(evt:EventTaomee) : void
      {
         if(this.hasLamu && Boolean(this.lamu))
         {
            this.lamu.boneManaage.isMoveing = this._isMoving;
            this.lamu.boneManaage.isDoAction = this.avatarClass.isActionMovie;
            this.lamu.boneManaage.currentDirection = this.avatarClass.currentDirection;
         }
         if(Boolean(this.magicMC))
         {
            this.magicMC.gotoAndStop(this.avatarClass.DirectionNum + 1);
         }
      }
      
      public function onGoBreak(evt:*) : void
      {
         if(this.isLamuFollow && Boolean(this.lamu))
         {
            this.lamu.boneManaage.isMoveing = false;
            this.lamu.boneManaage.currentDirection = this.avatarClass.currentDirection;
            this.lamu.boneManaage.isDoAction = false;
         }
      }
      
      public function clearEvents(E:Event = null) : void
      {
         this.delTarget();
         GC.clearGInterval(this.PetSickID);
         if(Boolean(this.lamu))
         {
            this.lamuMode = false;
            this.lamu_follow_on();
            this.lamu.clearClass();
            GC.stopAllMC(this.lamu);
            this.lamu = null;
         }
         dispatchEvent(new Event(ON_CLEAR_PEOPLE));
         ObjectPool.disposeObject(this,PeopleManageView,100);
         ObjectPool.disposeObject(this.avatarClass,null,100);
         ObjectPool.disposeObject(this.car,Car,100);
         ObjectPool.disposeObject(this.lamu,LamuNPC,100);
         GC.clearAll(this.magicMC);
         this.magicMC = null;
         BC.removeEvent(this);
         if(Boolean(this.showBoxTimer) && this.showBoxTimer.running)
         {
            this.showBoxTimer.stop();
         }
         this.showBoxTimer = null;
         if(this.checkNewPeopleTimer != null)
         {
            this.checkNewPeopleTimer.stop();
         }
         if(Boolean(this.car))
         {
            this.car["destroy"]();
         }
         if(Boolean(this.dragon))
         {
            this.dragon["destroy"]();
         }
         if(Boolean(this.animal))
         {
            this.animal.visible = true;
            this.animal.clearClass();
         }
         this.AngelUnFollow();
         this.PigUnFollow();
         LocalUserInfo.lamuinfo = this.lamuinfo = null;
         try
         {
            this.avatarClass.reMoveInstanceMC();
         }
         catch(E:TypeError)
         {
         }
         this.avatarClass = null;
         GC.clearAll(this.avatarMC);
         try
         {
            this.avatarMC.parent.removeChild(this.avatarMC);
         }
         catch(E:TypeError)
         {
         }
         this.avatarMC = null;
         this.petmc = null;
         this.car = null;
         this.dragon = null;
         this.animal = null;
         this.lamu = null;
         this.lamuinfo = null;
         this.PetObj = null;
         this.Action = 0;
         this.Action2 = 0;
         this.specificObj = {};
         this.clothsArray = null;
         this.removeEffect();
         Tick.instance.removeCallback(this.onUpdate);
      }
      
      public function lamu_say(msg:String) : Boolean
      {
         var box:DialogBox = null;
         if(Boolean(this.avatarMC) && Boolean(this.avatarMC.pet_mc) && Boolean(this.avatarMC.pet_mc.numChildren))
         {
            box = DialogBox.showDialogBox(msg);
            box.setPosXY(this.avatarMC.pet_mc.x + 25,this.avatarMC.pet_mc.y - 10);
            box.mouseChildren = box.mouseEnabled = false;
            this.avatarMC.addChild(box);
            return true;
         }
         return false;
      }
      
      public function get hitBtn() : TailButtonView
      {
         return this._hitBtn;
      }
      
      public function get pet_hitBtn() : TailButtonView
      {
         return this._petHitBtn;
      }
      
      public function hideMount() : void
      {
         this.delAnimal();
         this.delDragon();
         this.delCar();
         this.AngelUnFollow();
      }
   }
}

