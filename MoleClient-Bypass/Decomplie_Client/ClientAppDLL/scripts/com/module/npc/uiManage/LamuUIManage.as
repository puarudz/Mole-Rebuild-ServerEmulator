package com.module.npc.uiManage
{
   import com.common.util.MovieClipUtil;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MoveTo;
   import com.module.npc.lamu.I_LamuUIManage;
   import com.module.npc.lamu.LamuInfo;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.FrameLabel;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.URLRequest;
   import flash.text.TextField;
   import flash.utils.setTimeout;
   
   public class LamuUIManage extends EventDispatcher implements I_LamuUIManage
   {
      
      private static var dirObj:Object = {};
      
      dirObj["sit_down"] = "down";
      dirObj["sit_leftdown"] = "leftdown";
      dirObj["sit_left"] = "left";
      dirObj["sit_leftup"] = "leftup";
      dirObj["sit_up"] = "up";
      dirObj["sit_rightup"] = "rightup";
      dirObj["sit_right"] = "right";
      dirObj["sit_rightdown"] = "rightdown";
      
      private var boneLoader:Loader;
      
      private var boneLoaderInfo:LoaderInfo;
      
      protected var LamuLevelMC:MovieClip;
      
      protected var DirAnimalMC:MovieClip;
      
      protected var ActionMC0:MovieClip;
      
      protected var ActionMC1:MovieClip;
      
      protected var ActionMC2:MovieClip;
      
      public var frostAction:Boolean = false;
      
      public var _isMoveing:Boolean = false;
      
      public var _isDoAction:Boolean = false;
      
      public var _hasColor:Boolean = true;
      
      public var _clothvisible:Boolean = true;
      
      private var _lamuName:String = "";
      
      private var dirArray:Array = ["down","leftdown","left","leftup","up","rightup","right","rightdown"];
      
      private var actObj:Object = {};
      
      private var _lamuInfo:LamuInfo;
      
      private var cloth_mc:MovieClip;
      
      private var clothLevel_mc:MovieClip;
      
      private var ActionMC3:MovieClip;
      
      private var clothloader:Loader;
      
      private var lamu_txt:TextField;
      
      public var _currentDirection:String = "down";
      
      public var displayLevel:int = 0;
      
      private var _scaleX:Number = 1;
      
      private var _scaleY:Number = 1;
      
      public function LamuUIManage()
      {
         super();
      }
      
      public function setUILibrary(lib:Loader, lamuInfo:LamuInfo) : void
      {
         this.resetData();
         this.boneLoader = lib;
         this.boneLoaderInfo = this.boneLoader.contentLoaderInfo;
         this._lamuInfo = lamuInfo;
         this.refurbish();
         BC.addEvent(this,this.boneLoaderInfo.sharedEvents,"getLamuLevelMC",this.getLamuLevelMC);
         BC.addEvent(this,this.boneLoaderInfo.sharedEvents,"noColor",this.noColorMC);
      }
      
      public function resetData() : void
      {
         this.boneLoader = null;
         this.boneLoaderInfo = null;
         this.LamuLevelMC = null;
         this.DirAnimalMC = null;
         this.ActionMC0 = null;
         this.ActionMC1 = null;
         this.ActionMC2 = null;
         this.ActionMC3 = null;
         this._isMoveing = false;
         this._isDoAction = false;
         this._hasColor = true;
         this.frostAction = false;
         this.cloth_visible = true;
         this.actObj = {};
         this._lamuInfo = null;
         this.cloth_mc = null;
         this.clothLevel_mc = null;
         this.clothloader = null;
         this.lamu_txt = null;
         this._currentDirection = "down";
      }
      
      public function refurbish() : void
      {
         BC.removeEvent(this);
         this.loadCloth();
      }
      
      public function set currentDirection(dir:String) : void
      {
         if(this.frostAction)
         {
            return;
         }
         if(Boolean(dirObj[dir]))
         {
            dir = dirObj[dir];
         }
         if(this.isDoAction || Boolean(this._currentDirection != dir) && Boolean(this.actObj[this.currentDirection]))
         {
            if(this._lamuInfo.isDie && dir == "revival")
            {
               this._lamuInfo.isDie = false;
            }
            else if(dir == "dight")
            {
               this.cloth_visible = false;
            }
            else
            {
               this.cloth_visible = true;
            }
            this._currentDirection = dir;
            if(Boolean(this.ActionMC0))
            {
               GC.clearAll(this.ActionMC0);
            }
            if(Boolean(this.ActionMC1))
            {
               GC.clearAll(this.ActionMC1);
            }
            if(Boolean(this.ActionMC2))
            {
               GC.clearAll(this.ActionMC2);
            }
            if(Boolean(this.ActionMC3))
            {
               GC.clearAll(this.ActionMC3);
            }
            this.ActionMC0 = null;
            this.ActionMC1 = null;
            this.ActionMC2 = null;
            this.ActionMC3 = null;
            this.changeBoneDirection();
         }
         else
         {
            this.synchroCloth();
         }
      }
      
      public function get currentDirection() : String
      {
         return this._currentDirection;
      }
      
      private function synchroCloth() : void
      {
         if(!this.ActionMC1)
         {
            return;
         }
         if(this._lamuInfo.isDie)
         {
            MovieClipUtil.gotoAndStop(this.DirAnimalMC,"die");
            return;
         }
         var num:int = this.ActionMC1.currentFrame + 1;
         if(this.isMoveing || this.displayLevel > 3)
         {
            if(Boolean(this.ActionMC0))
            {
               this.ActionMC0.gotoAndPlay(num);
            }
            if(Boolean(this.ActionMC1))
            {
               this.ActionMC1.gotoAndPlay(num);
            }
            if(Boolean(this.ActionMC2))
            {
               this.ActionMC2.gotoAndPlay(num);
            }
            if(Boolean(this.ActionMC3))
            {
               this.ActionMC3.gotoAndPlay(num);
            }
         }
         else if(this._currentDirection.indexOf("skill_") >= 0)
         {
            if(Boolean(this.ActionMC0))
            {
               this.ActionMC0.gotoAndPlay(num);
            }
            if(Boolean(this.ActionMC1))
            {
               this.ActionMC1.gotoAndPlay(num);
            }
            if(Boolean(this.ActionMC2))
            {
               this.ActionMC2.gotoAndPlay(num);
            }
            if(Boolean(this.ActionMC3))
            {
               this.ActionMC3.gotoAndPlay(num);
            }
         }
         else if(this.isDoAction)
         {
            if(Boolean(this.ActionMC0))
            {
               this.ActionMC0.gotoAndPlay(num);
            }
            if(Boolean(this.ActionMC1))
            {
               this.ActionMC1.gotoAndPlay(num);
            }
            if(Boolean(this.ActionMC2))
            {
               this.ActionMC2.gotoAndPlay(num);
            }
            if(Boolean(this.ActionMC3))
            {
               this.ActionMC3.gotoAndPlay(num);
            }
         }
         else
         {
            if(Boolean(this.ActionMC0))
            {
               this.ActionMC0.gotoAndStop(2);
            }
            if(Boolean(this.ActionMC1))
            {
               this.ActionMC1.gotoAndStop(2);
            }
            if(Boolean(this.ActionMC2))
            {
               this.ActionMC2.gotoAndStop(2);
            }
            if(Boolean(this.ActionMC3))
            {
               this.ActionMC3.gotoAndStop(2);
            }
         }
      }
      
      public function loadCloth() : void
      {
         var req:URLRequest = null;
         var p:PeopleManageView = null;
         if(this._lamuInfo.isDie || Boolean(this._lamuInfo.isUserSKill))
         {
            this.clearCloth();
            this.clearBone();
         }
         else if(Boolean(this._lamuInfo.PetCloth))
         {
            if(this._lamuInfo.ClothObj.Layer >= 65)
            {
               this.clearCloth();
               this.clearBone();
            }
            else
            {
               if(!this.clothloader)
               {
                  this.clothloader = new Loader();
               }
               req = VL.getURLRequest("resource/petcloth/swf2/" + this._lamuInfo.PetCloth + ".swf");
               this.clothloader.load(req);
               BC.addEvent(this,this.clothloader.contentLoaderInfo.sharedEvents,"getLamuMC",this.getClothMC);
               BC.addEvent(this,this.clothloader.contentLoaderInfo.sharedEvents,"getLamuLevelMC",this.getClothLevelMC);
               BC.addEvent(this,this.clothloader.contentLoaderInfo.sharedEvents,"petBone3",this.petCloth);
            }
         }
         else if(Boolean(this.clothLevel_mc))
         {
            this.clearCloth();
            this.checkClothType();
         }
         if(this._lamuInfo.masterID == GV.MyInfo_userID)
         {
            p = GV.MAN_PEOPLE as PeopleManageView;
            if(p.hasLamu && p.lamuinfo.PetID == this._lamuInfo.PetID)
            {
               MoveTo.CanAutoFind = true;
            }
         }
      }
      
      private function clearBone() : void
      {
         GC.clearAll(this.ActionMC0);
         GC.clearAll(this.ActionMC1);
         GC.clearAll(this.ActionMC2);
         this.ActionMC0 = null;
         this.ActionMC1 = null;
         this.ActionMC2 = null;
         this.LamuLevelMC = null;
         this.DirAnimalMC = null;
      }
      
      private function clearCloth() : void
      {
         if(Boolean(this.clothloader))
         {
            BC.removeEvent(this,this.clothloader.contentLoaderInfo.sharedEvents);
            this.clothloader.unload();
         }
         GC.clearAll(this.ActionMC3);
         this.clothLevel_mc = null;
         this.cloth_mc = null;
         this.ActionMC3 = null;
      }
      
      public function addEvent() : void
      {
         if(Boolean(this.boneLoaderInfo))
         {
            BC.addEvent(this,this.boneLoaderInfo.sharedEvents,"getLamuMC",this.getDirAnimalMC);
            BC.addEvent(this,this.boneLoaderInfo.sharedEvents,"action",this.contentAction);
            BC.addEvent(this,this.boneLoaderInfo.sharedEvents,"petBone0",this.checkChangeStep0);
            BC.addEvent(this,this.boneLoaderInfo.sharedEvents,"petBone1",this.checkChangeStep1);
            BC.addEvent(this,this.boneLoaderInfo.sharedEvents,"petBone2",this.checkChangeStep2);
         }
      }
      
      public function changeBoneDirection() : void
      {
         if(!this.DirAnimalMC)
         {
            return;
         }
         if(this.dirArray.indexOf(this._currentDirection) >= 0)
         {
            this.isDoAction = false;
         }
         MovieClipUtil.gotoAndStop(this.DirAnimalMC,this._currentDirection);
         if(!this.cloth_mc)
         {
            return;
         }
         MovieClipUtil.gotoAndStop(this.cloth_mc,this._currentDirection);
      }
      
      private function getClothMC(E:*) : void
      {
         this.cloth_mc = E.EventObj as MovieClip;
         this.cloth_mc.addFrameScript(0,null);
         if(this._lamuInfo.isDie)
         {
            this.cloth_mc.visible = false;
            return;
         }
         MovieClipUtil.gotoAndStop(this.cloth_mc,this.currentDirection);
         this.scaleX = this._scaleX;
         this.scaleY = this._scaleY;
         this.synchroCloth();
      }
      
      private function getClothLevelMC(E:*) : void
      {
         this.clothLevel_mc = E.EventObj as MovieClip;
         this.lamuName = this._lamuName;
         setTimeout(function():void
         {
            addEvent();
            checkClothType();
         },100);
      }
      
      private function checkClothType() : void
      {
         var l:int = Boolean(this._lamuInfo.ClothObj) ? int(this._lamuInfo.ClothObj.Layer) : 0;
         if(Boolean(this.LamuLevelMC) && Boolean(this.clothLevel_mc))
         {
            if(Boolean(this._lamuInfo.isUserSKill))
            {
               this.LamuLevelMC.visible = true;
               this.LamuLevelMC.gotoAndStop("level2");
               if(this._lamuInfo.skillType == 3)
               {
                  this.displayLevel = 2;
               }
               else
               {
                  this.displayLevel = 5;
               }
            }
            else if(l == 65)
            {
               if(Boolean(this._lamuInfo.skill_learnType))
               {
                  this.LamuLevelMC.gotoAndStop("level" + this._lamuInfo.Petlevel + "_" + this._lamuInfo.skill_learnType);
               }
               else
               {
                  this.LamuLevelMC.gotoAndStop("level2");
               }
               this.LamuLevelMC.visible = true;
               this.clothLevel_mc.visible = false;
               this.displayLevel = 2;
            }
            else if(l == 75)
            {
               if(Boolean(this._lamuInfo.skill_learnType))
               {
                  this.LamuLevelMC.gotoAndStop("level" + this._lamuInfo.Petlevel + "_" + this._lamuInfo.skill_learnType);
               }
               else
               {
                  this.LamuLevelMC.gotoAndStop("level" + this._lamuInfo.Petlevel);
               }
               this.LamuLevelMC.visible = true;
               this.displayLevel = this._lamuInfo.Petlevel;
            }
            else if(l == 45)
            {
               this.LamuLevelMC.visible = true;
               this.clothLevel_mc.visible = true;
               this.LamuLevelMC.gotoAndStop("level2");
               this.clothLevel_mc.gotoAndStop("level2");
               this.displayLevel = 2;
            }
            else
            {
               this.LamuLevelMC.visible = true;
               if(Boolean(this._lamuInfo.isUserSKill))
               {
                  this.LamuLevelMC.visible = true;
                  this.LamuLevelMC.gotoAndStop("level2");
                  if(this._lamuInfo.skillType == 3)
                  {
                     this.displayLevel = 2;
                  }
                  else
                  {
                     this.displayLevel = 5;
                  }
               }
               else if(Boolean(this._lamuInfo.Petlevel == 5) && Boolean(this._lamuInfo.skill_learnType) || this._lamuInfo.Petlevel == 101 && this._lamuInfo.skill_learnType == 7)
               {
                  this.LamuLevelMC.gotoAndStop("level" + this._lamuInfo.Petlevel + "_" + this._lamuInfo.skill_learnType);
                  this.clothLevel_mc.gotoAndStop("level" + this._lamuInfo.Petlevel + "_" + this._lamuInfo.skill_learnType);
                  this.displayLevel = this._lamuInfo.Petlevel;
               }
               else
               {
                  this.LamuLevelMC.gotoAndStop("level" + this._lamuInfo.Petlevel);
                  this.clothLevel_mc.gotoAndStop("level" + this._lamuInfo.Petlevel);
                  this.displayLevel = this._lamuInfo.Petlevel;
               }
            }
         }
         else if(Boolean(this.LamuLevelMC) && (Boolean(this._lamuInfo.isUserSKill || l == 0) || Boolean(l >= 65)))
         {
            if(Boolean(this._lamuInfo.PetCloth))
            {
               l = int(this._lamuInfo.ClothObj.Layer);
               if(Boolean(this._lamuInfo.isUserSKill))
               {
                  this.LamuLevelMC.visible = true;
                  this.LamuLevelMC.gotoAndStop("level2");
                  if(this._lamuInfo.skillType == 3)
                  {
                     this.displayLevel = 2;
                  }
                  else
                  {
                     this.displayLevel = 5;
                  }
               }
               else if(l == 65)
               {
                  this.LamuLevelMC.visible = true;
                  this.LamuLevelMC.gotoAndStop("level2");
                  this.displayLevel = 2;
               }
               else if(l == 75)
               {
                  this.LamuLevelMC.visible = true;
                  if(Boolean(this._lamuInfo.skill_learnType))
                  {
                     this.LamuLevelMC.gotoAndStop("level" + this._lamuInfo.Petlevel + "_" + this._lamuInfo.skill_learnType);
                  }
                  else
                  {
                     this.LamuLevelMC.gotoAndStop("level" + this._lamuInfo.Petlevel);
                  }
                  this.displayLevel = this._lamuInfo.Petlevel;
               }
               else
               {
                  this.LamuLevelMC.visible = true;
                  if(Boolean(this._lamuInfo.skill_learnType))
                  {
                     this.LamuLevelMC.gotoAndStop("level" + this._lamuInfo.Petlevel + "_" + this._lamuInfo.skill_learnType);
                     this.displayLevel = this._lamuInfo.Petlevel;
                  }
                  else
                  {
                     this.LamuLevelMC.gotoAndStop("level" + this._lamuInfo.Petlevel);
                     this.displayLevel = this._lamuInfo.Petlevel;
                  }
               }
            }
            else
            {
               this.LamuLevelMC.visible = true;
               if(Boolean(this._lamuInfo.isUserSKill))
               {
                  this.LamuLevelMC.gotoAndStop("level2");
                  if(this._lamuInfo.skillType == 3)
                  {
                     this.displayLevel = 2;
                  }
                  else
                  {
                     this.displayLevel = 5;
                  }
               }
               else if(Boolean(this._lamuInfo.Petlevel == 5) && Boolean(this._lamuInfo.skill_learnType) || this._lamuInfo.Petlevel == 101 && this._lamuInfo.skill_learnType == 7)
               {
                  this.LamuLevelMC.gotoAndStop("level" + this._lamuInfo.Petlevel + "_" + this._lamuInfo.skill_learnType);
                  this.displayLevel = this._lamuInfo.Petlevel;
               }
               else
               {
                  this.LamuLevelMC.gotoAndStop("level" + this._lamuInfo.Petlevel);
                  this.displayLevel = this._lamuInfo.Petlevel;
               }
            }
         }
      }
      
      private function petCloth(E:*) : void
      {
         GC.clearAll(this.ActionMC3);
         this.ActionMC3 = E.EventObj as MovieClip;
         if(!this.ActionMC1)
         {
            return;
         }
         var index:int = this.ActionMC1.parent.getChildIndex(this.ActionMC1);
         this.ActionMC1.parent.addChild(this.ActionMC3);
         this.cloth_visible = this._clothvisible;
         this.synchroCloth();
      }
      
      private function contentAction(E:*) : void
      {
         var obj:Object = E.EventObj;
         dispatchEvent(new EventTaomee(obj.type,obj.data));
      }
      
      public function getLamuLevelMC(E:*) : void
      {
         this.LamuLevelMC = E.EventObj as MovieClip;
         this.LamuLevelMC.addFrameScript(0,null);
         this.LamuLevelMC.stop();
         this.lamuName = this._lamuName;
         setTimeout(function():void
         {
            try
            {
               addEvent();
               checkClothType();
            }
            catch(E:Error)
            {
            }
         },100);
      }
      
      public function getDirAnimalMC(E:*) : void
      {
         var labels:Array;
         var i:uint;
         var label:FrameLabel = null;
         this.DirAnimalMC = E.EventObj as MovieClip;
         this.actObj = {};
         labels = this.DirAnimalMC.currentLabels;
         for(i = 0; i < labels.length; i++)
         {
            label = labels[i];
            this.actObj[label.name] = label.frame;
         }
         this.DirAnimalMC.addFrameScript(0,null);
         this.synchroCloth();
         this.scaleX = this._scaleX;
         this.scaleY = this._scaleY;
         BC.addEvent(this,this.DirAnimalMC,Event.REMOVED_FROM_STAGE,function(E:Event):void
         {
            trace(E);
         });
         BC.addEvent(this,this.DirAnimalMC,Event.ADDED_TO_STAGE,function(E:Event):void
         {
            trace(E);
         });
      }
      
      private function checkChangeStep0(E:*) : void
      {
         GC.clearAll(this.ActionMC0);
         this.ActionMC0 = E.EventObj as MovieClip;
         this.ActionMC0.addFrameScript(0,null);
         if(!(this.isDoAction && this.DirAnimalMC.currentLabel != "dance"))
         {
            this.ActionMC0.addFrameScript(this.ActionMC0.totalFrames - 3,this.goto2);
         }
         this.synchroCloth();
      }
      
      private function checkChangeStep1(E:*) : void
      {
         var index:int = 0;
         if(!this.ActionMC1)
         {
            this.ActionMC1 = E.EventObj as MovieClip;
         }
         this.ActionMC1.addFrameScript(0,null);
         if(Boolean(this.DirAnimalMC) && this.DirAnimalMC.currentLabel != "getItem")
         {
            this.flushFrameFun();
         }
         if(Boolean(this.ActionMC3))
         {
            index = this.ActionMC1.parent.getChildIndex(this.ActionMC1);
            this.ActionMC1.parent.addChild(this.ActionMC3);
            this.cloth_visible = this._clothvisible;
         }
         if(this.isMoveing || this.isDoAction || this.displayLevel > 3)
         {
            this.ActionMC1.gotoAndPlay(2);
         }
         else
         {
            this.ActionMC1.gotoAndStop(2);
         }
         if(this._hasColor)
         {
            GF.setPetColor(this.ActionMC1,this._lamuInfo.PetColor);
         }
         this.synchroCloth();
      }
      
      private function flushFrameFun() : void
      {
         this.ActionMC1.addFrameScript(2,this.synchroCloth);
         if(this.isDoAction && this.DirAnimalMC.currentLabel == "football")
         {
            this.ActionMC1.addFrameScript(this.ActionMC1.totalFrames - 3,this.gotoAndStop_1);
         }
         else if(this.isDoAction && this.DirAnimalMC.currentLabel != "dance")
         {
            this.ActionMC1.addFrameScript(this.ActionMC1.totalFrames - 3,this.gotoAndStop_1);
         }
         else
         {
            this.ActionMC1.addFrameScript(this.ActionMC1.totalFrames - 3,this.goto2);
         }
      }
      
      private function resetAction() : void
      {
         this.showAction("down");
      }
      
      private function goto2() : void
      {
         if(Boolean(this.ActionMC1))
         {
            this.ActionMC1.gotoAndPlay(2);
         }
      }
      
      private function gotoAndStop_1() : void
      {
         if(Boolean(this.ActionMC1))
         {
            this.ActionMC1.gotoAndStop(1);
         }
      }
      
      private function checkChangeStep2(E:*) : void
      {
         GC.clearAll(this.ActionMC2);
         this.ActionMC2 = E.EventObj as MovieClip;
         this.ActionMC2.addFrameScript(0,null);
         if(!(this.isDoAction && this.DirAnimalMC.currentLabel != "dance"))
         {
            this.ActionMC2.addFrameScript(this.ActionMC2.totalFrames - 3,this.goto2);
         }
         this.synchroCloth();
      }
      
      private function noColorMC(E:*) : void
      {
         this._hasColor = false;
      }
      
      public function set cloth_visible(b:Boolean) : void
      {
         if(Boolean(this.ActionMC3))
         {
            this.ActionMC3.visible = b;
         }
         this._clothvisible = b;
      }
      
      public function get cloth_visible() : Boolean
      {
         return this._clothvisible;
      }
      
      public function showAction(act:String) : Boolean
      {
         if(!this.ActionMC1)
         {
            return false;
         }
         if(act == "")
         {
            this.isMoveing = false;
            this.isDoAction = false;
            if(this.dirArray.indexOf(this._currentDirection) >= 0)
            {
               this.currentDirection = this._currentDirection;
            }
            return true;
         }
         if(Boolean(this.actObj[act]))
         {
            if(this.dirArray.indexOf(act) >= 0)
            {
               this.isDoAction = false;
            }
            else
            {
               this.isDoAction = true;
            }
            this.currentDirection = act;
            return true;
         }
         return false;
      }
      
      public function set scaleX(num:Number) : void
      {
         this._scaleX = num;
         if(Boolean(this.DirAnimalMC))
         {
            this.DirAnimalMC.scaleX = num;
         }
         if(Boolean(this.cloth_mc))
         {
            this.cloth_mc.scaleX = num;
         }
      }
      
      public function set scaleY(num:Number) : void
      {
         this._scaleY = num;
         if(Boolean(this.DirAnimalMC))
         {
            this.DirAnimalMC.scaleY = num;
         }
         if(Boolean(this.cloth_mc))
         {
            this.cloth_mc.scaleY = num;
         }
      }
      
      public function get scaleX() : Number
      {
         return this._scaleX;
      }
      
      public function get scaleY() : Number
      {
         return this._scaleY;
      }
      
      public function set isMoveing(b:Boolean) : void
      {
         this._isMoveing = b;
      }
      
      public function set isDoAction(b:Boolean) : void
      {
         this._isDoAction = b;
      }
      
      public function set lamuName(name:String) : void
      {
         if(name == null)
         {
            throw "拉姆名字設置為空!";
         }
         this._lamuName = name;
         if(Boolean(this.LamuLevelMC) && Boolean(this.LamuLevelMC.lamu_txt))
         {
            this.LamuLevelMC.lamu_txt.textColor = 0;
            this.LamuLevelMC.lamu_txt.text = this._lamuName;
         }
         if(Boolean(this.clothLevel_mc) && Boolean(this.clothLevel_mc.lamu_txt))
         {
            this.clothLevel_mc.lamu_txt.textColor = 0;
            this.clothLevel_mc.lamu_txt.text = this._lamuName;
         }
      }
      
      public function get isMoveing() : Boolean
      {
         return this._isMoveing;
      }
      
      public function get isDoAction() : Boolean
      {
         return this._isDoAction;
      }
      
      public function get lamuName() : String
      {
         return this._lamuName;
      }
      
      public function get lamuInfo() : LamuInfo
      {
         return this._lamuInfo;
      }
      
      public function checkCloths() : void
      {
         var label:FrameLabel = null;
         var p:PeopleManageView = null;
         var labels:Array = this.DirAnimalMC.currentLabels;
         if(!this.DirAnimalMC)
         {
            return;
         }
         var cb:String = this.DirAnimalMC.currentLabel;
         for(var i:uint = 0; i < labels.length - 1; i++)
         {
            label = labels[i];
            if(i == labels.length - 2)
            {
               ++this._lamuInfo.PetCloth;
               if(this._lamuInfo.PetCloth < 1200001 || this._lamuInfo.PetCloth == 1200040)
               {
                  this._lamuInfo.PetCloth = 1200001;
                  ++this._lamuInfo.Petlevel;
                  if(this._lamuInfo.Petlevel > 5)
                  {
                     this._lamuInfo.Petlevel = 101;
                  }
               }
               p = GV.MAN_PEOPLE as PeopleManageView;
               setTimeout(p.lamu["refurbish"],500);
            }
            else if(label.name == cb)
            {
               this.showAction(labels[i + 1].name);
               setTimeout(this.checkCloths,500);
               break;
            }
         }
      }
      
      public function destroy() : void
      {
         GC.clearAll(this.LamuLevelMC);
         BC.removeEvent(this);
         GC.clearAll(this.clothLevel_mc);
         this.resetData();
      }
   }
}

