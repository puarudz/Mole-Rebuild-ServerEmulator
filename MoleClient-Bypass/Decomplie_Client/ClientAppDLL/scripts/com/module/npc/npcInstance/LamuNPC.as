package com.module.npc.npcInstance
{
   import com.common.Alert.Alert;
   import com.common.byteLoader.ByteLoader;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.info.LocalUserInfo;
   import com.core.manager.UIManager;
   import com.event.EventTaomee;
   import com.global.staticData.XMLInfo;
   import com.logic.socket.petSocket.adoptPet.petFoodReq;
   import com.logic.socket.petSocket.lamuSocket;
   import com.module.npc.NPCEvent;
   import com.module.npc.lamu.I_LamuNPC;
   import com.module.npc.lamu.I_LamuUIManage;
   import com.module.npc.lamu.LamuInfo;
   import com.module.npc.uiManage.LamuUIManage;
   import com.view.PeopleView.PeopleManageView;
   import com.view.mapView.activity.creatShareObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.filters.BlurFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import flash.utils.setTimeout;
   
   public dynamic class LamuNPC extends petNPC implements I_LamuNPC
   {
      
      public var _boneManaage:I_LamuUIManage;
      
      public var _masterID:uint;
      
      public var useSkillBool:int = 0;
      
      private var useSkillTimer:Timer;
      
      private var _lamuInfo:LamuInfo;
      
      private var dirArray:Array = ["down","leftdown","left","leftup","up","rightup","right","rightdown"];
      
      public function LamuNPC()
      {
         super(0);
      }
      
      public function get boneManaage() : I_LamuUIManage
      {
         return this._boneManaage;
      }
      
      public function setMasterID(masterID:uint, lamuInfo:LamuInfo) : void
      {
         this._masterID = masterID;
         this._lamuInfo = lamuInfo;
         BC.addEvent(this,GV.onlineSocket,"Pet_changeCloth_" + this._lamuInfo.masterID + "_" + this._lamuInfo.PetID,this.changPetCloth);
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.clearClass);
      }
      
      public function showSkillLevelUP(skill_value:int) : void
      {
         var skillUpEff:MovieClip = null;
         var value:int = int(skill_value - this.lamuInfo.skill_value);
         this.lamuInfo.skill_value = skill_value;
         if(Boolean(this.lamuInfo.skill_learnType))
         {
            skillUpEff = UIManager.getMovieClip("UI010_skillup_mc");
            skillUpEff.tipsTxt.value_txt.text = String(value);
            skillUpEff.gotoAndPlay(2);
            addChild(skillUpEff);
         }
      }
      
      private function changPetCloth(E:EventTaomee) : void
      {
         var i:uint = 0;
         var UserID:uint = uint(E.EventObj.UserID);
         var arr:Array = E.EventObj.arr;
         var p:PeopleManageView = GF.getPeopleByID(this._masterID);
         for(i = 0; i < arr.length; i++)
         {
            if(arr.length == 1 && arr[i].Flag == 0)
            {
               this._lamuInfo.PetCloth = 0;
               if(UserID == GV.MyInfo_userID && Boolean(LocalUserInfo.lamuinfo))
               {
                  LocalUserInfo.lamuinfo.PetCloth = 0;
               }
               if(Boolean(p) && p.hasLamu)
               {
                  p.lamuinfo.PetCloth = 0;
               }
            }
         }
         for(i = 0; i < arr.length; i++)
         {
            if(arr[i].Flag == 1)
            {
               this._lamuInfo.PetCloth = arr[i].ItemID;
               if(UserID == GV.MyInfo_userID && Boolean(LocalUserInfo.lamuinfo))
               {
                  LocalUserInfo.lamuinfo.PetCloth = arr[i].ItemID;
               }
               if(Boolean(p) && p.hasLamu)
               {
                  p.lamuinfo.PetCloth = arr[i].ItemID;
               }
            }
         }
         this.useSkillBool = 0;
         this.refurbish();
      }
      
      public function get saying() : Boolean
      {
         if(Boolean(myDialogBox) && Boolean(myDialogBox["visible"]))
         {
            return true;
         }
         return false;
      }
      
      override public function set visible(b:Boolean) : void
      {
         super.visible = b;
      }
      
      override public function get isDoAction() : Boolean
      {
         return visible;
      }
      
      override public function set isMoveing(b:Boolean) : void
      {
         _isMoveing = b;
         this._boneManaage.isMoveing = _isMoveing;
      }
      
      override public function set isDoAction(b:Boolean) : void
      {
         _isDoAction = b;
         this._boneManaage.isDoAction = _isDoAction;
      }
      
      override public function loadBone2() : void
      {
      }
      
      override public function loadNPC(NPC_ID:uint) : void
      {
         super.loadNPC(NPC_ID);
         BC.removeEvent(this,boneLoaderInfo.sharedEvents);
         this._boneManaage = new LamuUIManage() as I_LamuUIManage;
         this._boneManaage.setUILibrary(boneLoader,this._lamuInfo);
         this.x = 0;
         this.y = 0;
         this.refurbish();
      }
      
      public function refurbish() : void
      {
         var url:String = null;
         boneLoader = new Loader();
         boneLoaderInfo = boneLoader.contentLoaderInfo;
         var l:int = Boolean(this._lamuInfo.ClothObj) ? int(this._lamuInfo.ClothObj.Layer) : 0;
         if(Boolean(this._lamuInfo.isUserSKill))
         {
            url = "resource/petcloth/swf2/" + this._lamuInfo.isUserSKill + ".swf";
            this.ReloadlamuBone(url);
         }
         else if(l >= 65)
         {
            url = "resource/petcloth/swf2/" + this._lamuInfo.PetCloth + ".swf";
            this.ReloadlamuBone(url);
         }
         else if(l != 45 && (Boolean(this._lamuInfo.Petlevel == 5 && this._lamuInfo.skill_learnType) || Boolean(this._lamuInfo.Petlevel == 101 && this._lamuInfo.skill_learnType == 7)))
         {
            url = "resource/petcloth/swf2/pet" + this._lamuInfo.Petlevel + "/skill_" + this._lamuInfo.skill_learnType + ".swf";
            this.ReloadlamuBone(url);
         }
         else
         {
            url = boneLoader.contentLoaderInfo.url;
            if(Boolean(url))
            {
               url = url.split("\\").join("/");
               if(url.split("/").pop() != "lamubone.swf")
               {
                  url = "resource/NPC/lamubone.swf";
                  this.ReloadlamuBone(url);
               }
               else
               {
                  this._boneManaage.refurbish();
               }
            }
            else
            {
               url = "resource/NPC/lamubone.swf";
               this.ReloadlamuBone(url);
            }
         }
      }
      
      private function ReloadlamuBone(url:String) : void
      {
         var tb:ByteLoader = null;
         var onLoadComplete:Function = function(event:Event = null):void
         {
            if(Boolean(useSkillBool))
            {
               if(useSkillBool == 2 && tb.bytesTotal == tb.bytesLoaded)
               {
                  GC.clearGInterval(useSkillTimer);
                  ReloadlamuBone2(tb);
               }
            }
            else if(tb.bytesTotal == tb.bytesLoaded)
            {
               ReloadlamuBone2(tb);
            }
         };
         tb = new ByteLoader();
         BC.addEvent(this,tb,Event.COMPLETE,onLoadComplete);
         tb.load(VL.getURLRequest(url));
         if(Boolean(this.useSkillBool))
         {
            GC.clearGInterval(this.useSkillTimer);
            this.useSkillTimer = GC.setGInterval(function():void
            {
               var rgbofset:* = undefined;
               if(useSkillTimer.currentCount >= 13)
               {
                  useSkillBool = 2;
                  onLoadComplete();
               }
               else
               {
                  rgbofset = useSkillTimer.currentCount * 20;
                  if(_lamuInfo.skillType == 1)
                  {
                     LamuLevelMC.transform.colorTransform = new ColorTransform(1,1,1,1,rgbofset,-rgbofset,-rgbofset,0);
                  }
                  else if(_lamuInfo.skillType == 2)
                  {
                     rgbofset = useSkillTimer.currentCount * 16;
                     LamuLevelMC.transform.colorTransform = new ColorTransform(1,1,1,1,-rgbofset,-rgbofset,rgbofset,0);
                  }
                  else
                  {
                     LamuLevelMC.transform.colorTransform = new ColorTransform(1,1,1,1,-rgbofset,rgbofset,-rgbofset,0);
                  }
                  LamuLevelMC.filters = [new BlurFilter(useSkillTimer.currentCount * 5,useSkillTimer.currentCount)];
               }
            },"30:13");
         }
      }
      
      private function ReloadlamuBone2(tb:ByteLoader) : void
      {
         var tba:ByteArray;
         var thisObj:* = undefined;
         this._boneManaage.destroy();
         this._boneManaage.setUILibrary(boneLoader,this._lamuInfo);
         thisObj = this;
         BC.addEvent(this,boneLoader.contentLoaderInfo,Event.INIT,function(E:Event):void
         {
            BC.removeEvent(thisObj,E.currentTarget);
            onLoaded(E.currentTarget as LoaderInfo);
            thisObj = null;
         });
         tba = new ByteArray();
         tb.readBytes(tba);
         tba.position = 0;
         boneLoader.loadBytes(tba);
      }
      
      override public function onLoaded(_loaderInfo:LoaderInfo) : void
      {
         var tempMC:MovieClip = null;
         var p:PeopleManageView = null;
         try
         {
            LamuLevelMC = _loaderInfo.content as MovieClip;
            LamuLevelMC.filters = [];
         }
         catch(E:Error)
         {
            return;
         }
         if(!LamuLevelMC)
         {
            trace("LamuLevelMC不存在，拉姆加載出錯");
            return;
         }
         tempMC = LamuLevelMC.getChildAt(0) as MovieClip;
         tempMC.x = 0;
         tempMC.y = 0;
         tempMC.gotoAndStop(1);
         addChild(LamuLevelMC);
         hideButton();
         if(Boolean(this._lamuInfo.isUserSKill))
         {
            this.useSkillBool = 0;
         }
         if(this._masterID == GV.MyInfo_userID)
         {
            if(!creatShareObject.getInstance().getLahuWood())
            {
               p = GV.MAN_PEOPLE as PeopleManageView;
               if(Boolean(p.magicMC))
               {
                  GC.clearAll(p.magicMC);
                  p.magicMC = null;
               }
               this.visible = true;
            }
            else if(creatShareObject.getInstance().getLahuWood() == "shikongganying")
            {
               this.visible = true;
            }
            else
            {
               this.visible = false;
            }
         }
         else
         {
            this.visible = true;
         }
         NPCEvent.dispatchEvent(new NPCEvent(NPCEvent.ON_NPC_LOADED,this));
      }
      
      override protected function changeAnimalDir(E:*) : void
      {
         dirNum = int(E.EventObj);
         this._boneManaage["showAction"](this.dirArray[dirNum]);
         if(Boolean(E))
         {
            this._boneManaage["dispatchEvent"](E);
            dispatchEvent(E);
         }
      }
      
      override public function clearClass(E:* = null) : void
      {
         GC.clearGInterval(this.useSkillTimer);
         super.clearClass();
         this._boneManaage.destroy();
         GC.clearAllChildren(this);
         BC.removeEvent(this);
      }
      
      override protected function stopMove(E:* = null) : void
      {
         super.stopMove();
         this.boneManaage["showAction"]("");
         if(Boolean(E))
         {
            this._boneManaage["dispatchEvent"](E);
            dispatchEvent(E);
         }
      }
      
      override public function MoveTo(ex:int, ey:int) : void
      {
         if(this._boneManaage.currentDirection != "getItem")
         {
            moveEngine.MoveTo(this.x,this.y,ex,ey);
         }
      }
      
      override public function set scaleX(num:Number) : void
      {
         super.scaleX = 1;
         this._boneManaage.scaleX = num;
      }
      
      override public function set scaleY(num:Number) : void
      {
         super.scaleY = 1;
         this._boneManaage.scaleY = num;
      }
      
      override public function get scaleX() : Number
      {
         return this._boneManaage.scaleX;
      }
      
      override public function get scaleY() : Number
      {
         return this._boneManaage.scaleY;
      }
      
      override public function set x(num:Number) : void
      {
         super.x = num;
      }
      
      override public function set y(num:Number) : void
      {
         super.y = num;
      }
      
      override public function get x() : Number
      {
         return super.x;
      }
      
      override public function get y() : Number
      {
         return super.y;
      }
      
      public function get lamuInfo() : LamuInfo
      {
         return this._lamuInfo;
      }
      
      public function learningSkill(SkillType:uint, SkillLevel:uint) : void
      {
         var p:PeopleManageView;
         var lm:LamuNPC = null;
         if(!SkillType)
         {
            throw "使用技能type類型不能為0(@param type  技能系 火:1,水:2,木:3  ，@param level 技能等級)";
         }
         lm = this;
         BC.addEvent(this,GV.onlineSocket,"read_" + 1127,function(E:EventTaomee):void
         {
            var p:PeopleManageView = GF.getPeopleByID(_masterID);
            BC.removeEvent(lm,GV.onlineSocket,"read_" + 1127);
            BC.removeEvent(lm,GV.onlineSocket,"ERROR_CMD_" + 1127);
            var skillType:uint = uint(E.EventObj.skillType);
            var skillLevel:int = int(uint(E.EventObj.skillLevel));
            if(skillType == 1)
            {
               _lamuInfo.skill_Fire = skillLevel;
               if(Boolean(LocalUserInfo.lamuinfo))
               {
                  LocalUserInfo.lamuinfo.skill_Fire = skillLevel;
               }
            }
            else if(skillType == 2)
            {
               _lamuInfo.skill_Water = skillLevel;
               if(Boolean(LocalUserInfo.lamuinfo))
               {
                  LocalUserInfo.lamuinfo.skill_Water = skillLevel;
               }
            }
            else if(skillType == 3)
            {
               _lamuInfo.skill_Wood = skillLevel;
               if(Boolean(LocalUserInfo.lamuinfo))
               {
                  LocalUserInfo.lamuinfo.skill_Wood = skillLevel;
               }
            }
            trace("學習技能",skillType,skillLevel);
         });
         BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_" + 1127,function(E:EventTaomee):void
         {
            var p:PeopleManageView = GF.getPeopleByID(_masterID);
            BC.removeEvent(lm,GV.onlineSocket,"read_" + 1127);
            BC.removeEvent(lm,GV.onlineSocket,"ERROR_CMD_" + 1127);
         });
         p = GF.getPeopleByID(this._masterID);
         lamuSocket.setPetStep5Skill(this._lamuInfo.PetID,SkillType,SkillLevel);
      }
      
      public function useLamuSkill(type:int, level:int = 1) : void
      {
         var p1:PeopleManageView;
         var p:PeopleManageView;
         var t:int = 0;
         var lm:LamuNPC = null;
         var PetName:String = null;
         if(Boolean(this.useSkillBool))
         {
            return;
         }
         if(!type)
         {
            throw "使用技能type類型不能為0(@param type  技能系 火:1,水:2,木:3  ，@param level 技能等級)";
         }
         t = type - 1 + 1208000 + (level - 1) * 3;
         lm = this;
         PetName = "你的拉姆";
         p1 = GF.getPeopleByID(this._masterID) as PeopleManageView;
         if(p1.hasLamu)
         {
            if(p1.lamuinfo.isUserSKill == t)
            {
               return;
            }
            if(p1.lamuinfo.PetSick > 0)
            {
               Alert.angryAlart("　　你的拉姆生病了,不能使用技能!");
               return;
            }
            PetName = p1.lamuinfo.PetName;
         }
         BC.addEvent(this,GV.onlineSocket,"read_" + 1212,function(E:EventTaomee):void
         {
            var p:PeopleManageView = GF.getPeopleByID(_masterID);
            if(E.EventObj.userID == _masterID && E.EventObj.petID == _lamuInfo.PetID)
            {
               _boneManaage.showAction("skill_" + (1208000 + (t - 1208000) % 3));
               _boneManaage["cloth_visible"] = false;
               _boneManaage["frostAction"] = true;
               useSkillBool = 1;
               if(Boolean(LocalUserInfo.lamuinfo))
               {
                  LocalUserInfo.lamuinfo.isUserSKill = t;
               }
               _lamuInfo.isUserSKill = t;
               refurbish();
               BC.removeEvent(lm,GV.onlineSocket,"read_" + 1212);
               BC.removeEvent(lm,GV.onlineSocket,"ERROR_CMD_-100134");
            }
         });
         BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_-100134",function(E:EventTaomee):void
         {
            var p:PeopleManageView = GF.getPeopleByID(_masterID);
            if(p.hasLamu)
            {
               Alert.smileAlart("　　" + PetName + "已經沒有力氣了，快去給它餵食洗澡吧！");
            }
            BC.removeEvent(lm,GV.onlineSocket,"read_" + 1212);
            BC.removeEvent(lm,GV.onlineSocket,"ERROR_CMD_-100134");
         });
         p = GF.getPeopleByID(this._masterID);
         lamuSocket.useSkill(this._lamuInfo.PetID,t - 1208000 + 1);
      }
      
      public function delLamuSkill() : void
      {
         lamuSocket.revertSkill(this._lamuInfo.PetID,0);
         this._lamuInfo.isUserSKill = 0;
         this.useSkillBool = 0;
      }
      
      public function eatFood(foodItemID:uint, successFun:Function = null, failFun:Function = null) : void
      {
         var lm:LamuNPC = null;
         lm = this;
         BC.addEvent(this,GV.onlineSocket,"read_" + 505,function(E:Event):void
         {
            BC.removeEvent(lm,GV.onlineSocket,"read_" + 505);
            BC.removeEvent(lm,GV.onlineSocket,"ERROR_CMD_" + 505);
            showIconAction("food",foodItemID);
            if(successFun != null)
            {
               successFun(foodItemID);
            }
         });
         BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_" + 505,function(E:EventTaomee):void
         {
            BC.removeEvent(lm,GV.onlineSocket,"read_" + 505);
            BC.removeEvent(lm,GV.onlineSocket,"ERROR_CMD_" + 505);
            if(failFun != null)
            {
               failFun(foodItemID,E.EventObj);
            }
         });
         new petFoodReq().sendFoodReq(this._masterID,this._lamuInfo.PetID,foodItemID);
      }
      
      public function showIconAction(act:String, foodItemID:uint) : void
      {
         var lm:LamuNPC = null;
         var path:String = null;
         var ico_mc:MovieClip = null;
         lm = this;
         var _temp_4:* = BC;
         var _temp_3:* = lm;
         var _temp_2:* = this._boneManaage;
         var _temp_1:* = "eatItem";
         with({})
         {
            _temp_4.addEvent(_temp_3,_temp_2,_temp_1,function checkGetItem(E:*):void
            {
               var ld:Loader = null;
               BC.removeEvent(lm,_boneManaage,"eatItem");
               var mc:MovieClip = E.EventObj as MovieClip;
               GC.clearAllChildren(mc);
               if(foodItemID > 0)
               {
                  ld = new Loader();
                  ld.load(VL.getURLRequest(path + foodItemID + ".swf"));
                  mc.addChild(ld);
               }
            });
            if(!this._boneManaage.showAction(act))
            {
               ico_mc = UIManager.getMovieClip("UI010_eat_Eff_mc");
               ico_mc.loadICO(VL.getURLRequest(path + foodItemID + ".swf").url);
               addChild(ico_mc);
               this._boneManaage.showAction("rightdown");
            }
         }
         
         public function geocaching(findMC:DisplayObjectContainer, return_ItemID_Fun:Function = null, successFun:Function = null, failFun:Function = null) : void
         {
            var moveto:* = undefined;
            var p:PeopleManageView = null;
            var po:Point = null;
            var po2:Point = null;
            var lm:LamuNPC = null;
            var tempObject:Object = null;
            var tempSuc:Function = null;
            if(Boolean(this.useSkillBool) || this.boneManaage.currentDirection == "getItem")
            {
               return;
            }
            if(Boolean(LamuLevelMC) && Boolean(this._lamuInfo.isUserSKill))
            {
               moveto = getDefinitionByName("com.logic.FindPathLogic.MoveTo");
               moveto.CanAutoFind = false;
               p = GF.getPeopleByID(this._masterID) as PeopleManageView;
               if(parent == p.avatarMC.pet_mc)
               {
                  p.avatarClass.stopToHere();
               }
               po = new Point(this.x,this.y);
               po2 = findMC.localToGlobal(po);
               po2 = LamuLevelMC.parent.globalToLocal(po2);
               LamuLevelMC.x = po2.x;
               LamuLevelMC.y = po2.y;
               lm = this;
               tempObject = {};
               var _temp_6:* = BC;
               var _temp_5:* = this;
               var _temp_4:* = this._boneManaage;
               var _temp_3:* = "checkGetItem";
               with({})
               {
                  
                  _temp_6.addEvent(_temp_5,_temp_4,_temp_3,function checkGetItem(E:*):void
                  {
                     var mc:MovieClip = null;
                     var itemid:uint = 0;
                     BC.removeEvent(lm,_boneManaage,"checkGetItem");
                     if(return_ItemID_Fun != null)
                     {
                        mc = E.EventObj as MovieClip;
                        GC.clearAllChildren(mc);
                        itemid = uint(return_ItemID_Fun(mc));
                        if(checkCanGetItem(itemid))
                        {
                           onGeocaching(mc,itemid,tempObject,failFun);
                        }
                     }
                  });
                  BC.addEvent(this,this._boneManaage,"getItemOver",function(E:Event):void
                  {
                     BC.removeEvent(lm,_boneManaage,"getItemStart");
                     BC.removeEvent(lm,_boneManaage,"checkGetItem");
                     BC.removeEvent(lm,_boneManaage,"getItemOver");
                     LamuLevelMC.x = 0;
                     LamuLevelMC.y = 0;
                     moveto.CanAutoFind = true;
                     delLamuSkill();
                     if(tempSuc != null)
                     {
                        tempSuc();
                     }
                     _boneManaage.currentDirection = "down";
                  });
                  BC.addEvent(this,this._boneManaage,"getItemStart",function(E:*):void
                  {
                     var mc:MovieClip = E.EventObj as MovieClip;
                     mc.gotoAndPlay(2);
                  });
                  this._boneManaage.currentDirection = "getItem";
               }
            }
            
            public function checkCanGetItem(itemid:int, showTip:Boolean = true) : Boolean
            {
               var str:String = null;
               var obj:Object = XMLInfo.skill_Can_Geocaching[itemid];
               if(itemid == 0)
               {
                  return true;
               }
               if(Boolean(obj) && Boolean(obj.level <= this._lamuInfo.skillLevel) && (obj.type == this._lamuInfo.skillType || obj.type > 3))
               {
                  return true;
               }
               str = "";
               if(obj.type == 1)
               {
                  str = LamuInfo.fireArr[obj.level - 1];
               }
               else if(obj.type == 2)
               {
                  str = LamuInfo.waterArr[obj.level - 1];
               }
               else if(obj.type == 3)
               {
                  str = LamuInfo.woodArr[obj.level - 1];
               }
               if(showTip)
               {
                  Alert.angryAlart("　　必須使用變身＂" + str + "＂或更高的技能才能拿到" + GoodsInfo.getInfoById(itemid).name + "哦！");
               }
               return false;
            }
            
            private function onGeocaching(dpc:DisplayObjectContainer, itemid:int, sucObj:*, fail:Function) : void
            {
               var lm:LamuNPC = null;
               lm = this;
               if(!this._lamuInfo.skillType)
               {
                  trace("拉姆沒有使用技能變身！！！");
                  return;
               }
               BC.addEvent(this,GV.onlineSocket,"read_" + 1209,function(E:EventTaomee):void
               {
                  var skill_value:uint;
                  var ld:Loader = null;
                  var path:String = null;
                  var obj:Object = null;
                  BC.removeEvent(lm,GV.onlineSocket,"read_" + 1209);
                  BC.removeEvent(lm,GV.onlineSocket,"ERROR_CMD_" + 1209);
                  if(itemid > 0)
                  {
                     ld = new Loader();
                     path = path = GoodsInfo.getItemPathByID(itemid);
                     ld.load(VL.getURLRequest(path + itemid + ".swf"));
                     ld.x = -14;
                     ld.y = -34;
                     ld.scaleX = ld.scaleY = 0.5;
                     dpc.addChild(ld);
                     if(Boolean(lamuInfo) && lamuInfo.isUserSKill >= 1208012)
                     {
                        obj = XMLInfo.skill_Can_Geocaching[itemid];
                        if(Boolean(obj) && obj.level >= 5)
                        {
                           setTimeout(function():void
                           {
                              Alert.getIconByID_Alart(itemid,"    恭喜你獲得" + GoodsInfo.getItemNameByID(itemid) + ",已經放入你的" + GoodsInfo.getItemCollectionBoxNameByID(itemid) + "中！");
                           },1000);
                        }
                     }
                  }
                  skill_value = E.EventObj as uint;
                  if(Boolean(sucObj))
                  {
                     sucObj.levelupNum = skill_value - lamuInfo.skill_value;
                     sucObj.mc = dpc;
                  }
                  lamuInfo.skill_value = skill_value;
               });
               BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_" + 1209,function(E:EventTaomee):void
               {
                  BC.removeEvent(lm,GV.onlineSocket,"read_" + 1209);
                  BC.removeEvent(lm,GV.onlineSocket,"ERROR_CMD_" + 1209);
                  if(fail != null)
                  {
                     fail(E.EventObj);
                  }
               });
               lamuSocket.getSkillItem(this._lamuInfo.PetID,this._lamuInfo.isUserSKill - 1208000 + 1,itemid);
            }
         }
      }
      
      