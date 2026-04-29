package com.module.npc.lamu
{
   import com.common.data.goodsInfo.GoodsInfo;
   
   public class LamuInfo
   {
      
      public static var fireArr:Array = ["小火苗","旺盛火焰","爆烈燃燒","火焰漩渦","流星火","星火涅槃"];
      
      public static var waterArr:Array = ["小水滴","水花碎片","水上蔓延","似水奔騰","水龍","水上狂舞"];
      
      public static var woodArr:Array = ["小樹苗","樹根纏繞","通天藤蔓","飛花炫舞","野蠻生長","上天入地"];
      
      public static var skillDataArr:Array = [0,0,180,1340,4280,9800,18700];
      
      public var PetBirthday:uint;
      
      public var PetValue:uint;
      
      public var ClothObj:Object;
      
      private var _PetCloth:int;
      
      private var _PetFlag:uint;
      
      private var _isUserSKill:int = 0;
      
      public var skillType:int = 0;
      
      public var skillLevel:int = 0;
      
      public var PetID:int;
      
      public var _PetName:String;
      
      public var PetColor:int;
      
      public var PetHonor:int;
      
      public var PetSick:int;
      
      public var PetSickTime:int;
      
      public var PetLearning:int;
      
      public var changeBody:int;
      
      public var masterID:uint;
      
      public var Status_Hungry:int;
      
      public var Status_Thirsty:int;
      
      public var Status_Dirty:int;
      
      public var Status_Spirit:int;
      
      public var Petlevel:int;
      
      public var skill_Fire:int = 0;
      
      public var skill_Water:int = 0;
      
      public var skill_Wood:int = 0;
      
      public var skill_learnType:int = 0;
      
      public var skill_value:int = 0;
      
      private var skill_Box_Item1:int = 0;
      
      private var skill_Box_Item2:int = 0;
      
      private var skill_Box_Item3:int = 0;
      
      public function LamuInfo(obj:Object)
      {
         super();
         this.upData(obj);
      }
      
      public function upData(obj:Object) : void
      {
         var action:int = 0;
         this.PetID = obj.PetID;
         this.PetColor = obj.PetColor;
         this.Petlevel = obj.Petlevel;
         this.PetCloth = obj.Pet_cloth;
         this.PetHonor = obj.Pet_honor;
         this.PetSick = Boolean(this.PetSick) ? this.PetSick : int(obj.PetSick);
         this.PetSick = Boolean(this.PetSick) ? this.PetSick : int(obj.Sick_type);
         this.PetSickTime = obj.SickTime;
         this.PetLearning = obj.Reserved1;
         this.skill_Fire = obj.skill_Fire;
         this.skill_Water = obj.skill_Water;
         this.skill_Wood = obj.skill_Wood;
         this.skill_learnType = obj.Skill_Type;
         this.skill_value = obj.Skill_Value;
         this.skill_Box_Item1 = obj.item1;
         this.skill_Box_Item2 = obj.item2;
         this.skill_Box_Item3 = obj.item3;
         this.changeBody = 0;
         this.masterID = obj.UserID;
         this.PetName = obj.PetName;
         this.checkAndUpSkillType();
         if(Boolean(obj.Pet_action))
         {
            action = int(obj.Pet_action) - 1;
            this.skillType = action % 3 + 1;
            this.skillLevel = int(action / 3) + 1;
            this._isUserSKill = 1208000 + int(action / 3) * 3 + this.skillType - 1;
         }
         if(this.Petlevel == 101 && this.skill_learnType != 7)
         {
            this.skill_learnType = 0;
         }
      }
      
      public function upData2(obj:Object) : void
      {
         var action:int = 0;
         this.PetID = obj.SpriteID;
         this._PetFlag = obj.Flag;
         this.PetBirthday = obj.Birthday;
         this.PetValue = obj.Value;
         this.PetColor = obj.Color;
         this.Petlevel = obj.Level;
         this.Status_Hungry = obj.Hungry;
         this.Status_Thirsty = obj.Thirsty;
         this.Status_Dirty = obj.Dirty;
         this.Status_Spirit = obj.Spirit;
         this.PetCloth = obj.Cloth;
         this.PetHonor = obj.Honor;
         this.PetSick = Boolean(this.PetSick) ? this.PetSick : int(obj.PetSick);
         this.PetSick = Boolean(this.PetSick) ? this.PetSick : int(obj.Sick_type);
         this.PetSickTime = obj.SickTime;
         this.PetLearning = obj.Skill;
         this.changeBody = 0;
         this.masterID = obj.UserID;
         this.skill_Fire = obj.skill_Fire;
         this.skill_Water = obj.skill_Water;
         this.skill_Wood = obj.skill_Wood;
         this.PetName = obj.PetName;
         this.skill_learnType = obj.Skill_Type;
         this.skill_value = obj.Skill_Value;
         this.skill_Box_Item1 = obj.item1;
         this.skill_Box_Item2 = obj.item2;
         this.skill_Box_Item3 = obj.item3;
         this.checkAndUpSkillType();
         if(Boolean(obj.Pet_action))
         {
            action = int(obj.Pet_action) - 1;
            this.skillType = action % 3 + 1;
            this.skillLevel = int(action / 3) + 1;
            this._isUserSKill = 1208000 + int(action / 3) * 3 + this.skillType - 1;
         }
         if(this.Petlevel == 101 && this.skill_learnType != 7)
         {
            this.skill_learnType = 0;
         }
      }
      
      public function checkAndUpSkillType() : void
      {
         if(this.skill_learnType == 0)
         {
            this.skill_Fire = Boolean(this.skill_Fire) ? 1 : 0;
            this.skill_Water = Boolean(this.skill_Water) ? 1 : 0;
            this.skill_Wood = Boolean(this.skill_Wood) ? 1 : 0;
            this.skill_Box_Item1 = Boolean(this.skill_Fire) ? 1 : 0;
            this.skill_Box_Item2 = Boolean(this.skill_Water) ? 2 : 0;
            this.skill_Box_Item3 = Boolean(this.skill_Wood) ? 3 : 0;
         }
         else if(this.skill_learnType == 1)
         {
            this.skill_Water = 1;
            this.skill_Wood = 1;
         }
         else if(this.skill_learnType == 2)
         {
            this.skill_Fire = 1;
            this.skill_Wood = 1;
         }
         else if(this.skill_learnType == 4)
         {
            this.skill_Fire = 1;
            this.skill_Water = 1;
         }
         else if(this.skill_learnType == 7 && this.Petlevel == 5)
         {
            this.Petlevel = 4;
            this.skill_Fire = 1;
            this.skill_Water = 1;
            this.skill_Wood = 1;
            this.skill_Box_Item1 = 1;
            this.skill_Box_Item2 = 2;
            this.skill_Box_Item3 = 3;
         }
      }
      
      public function get isDie() : Boolean
      {
         return this._PetFlag == 2;
      }
      
      public function set isDie(b:Boolean) : void
      {
         if(b)
         {
            this._PetFlag = 2;
         }
         else
         {
            this._PetFlag = 1;
         }
      }
      
      public function get isDisease() : Boolean
      {
         return this._PetFlag == 1;
      }
      
      public function hasSkill_Fire() : Boolean
      {
         return this.skill_Fire > 0;
      }
      
      public function hasSkill_Water() : Boolean
      {
         return this.skill_Water > 0;
      }
      
      public function hasSkill_Wood() : Boolean
      {
         return this.skill_Wood > 0;
      }
      
      public function hasSkillAvatar() : int
      {
         if(this.skill_learnType == 7 && this.Petlevel == 101)
         {
            return 4;
         }
         if(this.skill_learnType > 0 && this.Petlevel == 5)
         {
            if(this.skill_learnType == 1)
            {
               return 1;
            }
            if(this.skill_learnType == 2)
            {
               return 2;
            }
            if(this.skill_learnType == 4)
            {
               return 3;
            }
         }
         return 0;
      }
      
      public function getSkillBoxInfo(num:int) : Object
      {
         var type:int = 0;
         var level:int = 0;
         if(Boolean(this["skill_Box_Item" + num]) && Boolean(this.skill_learnType))
         {
            type = int(this["skill_Box_Item" + num] - 1) % 3 + 1;
            level = int((this["skill_Box_Item" + num] - 1) / 3) + 1;
            return {
               "l":level,
               "t":type,
               "v":this["skill_Box_Item" + num]
            };
         }
         if(num == 1 && this.hasSkill_Fire_By_Level(1))
         {
            return {
               "l":1,
               "t":num,
               "v":1
            };
         }
         if(num == 2 && this.hasSkill_Water_By_Level(1))
         {
            return {
               "l":1,
               "t":num,
               "v":2
            };
         }
         if(num == 3 && this.hasSkill_Wood_By_Level(1))
         {
            return {
               "l":1,
               "t":num,
               "v":3
            };
         }
         return {
            "l":0,
            "t":0,
            "v":0
         };
      }
      
      public function setSkillBoxInfo(num:int, type:int, lv:int) : void
      {
         this["skill_Box_Item" + num] = (lv - 1) * 3 + type;
      }
      
      public function hasSkill_Fire_By_Level(lv:int) : Boolean
      {
         return Boolean(this.skill_Fire >> lv - 1 & 1);
      }
      
      public function hasSkill_Water_By_Level(lv:int) : Boolean
      {
         return Boolean(this.skill_Water >> lv - 1 & 1);
      }
      
      public function hasSkill_Wood_By_Level(lv:int) : Boolean
      {
         return Boolean(this.skill_Wood >> lv - 1 & 1);
      }
      
      public function canLearnSkillFire(lv:int) : Boolean
      {
         if(lv < 1 || lv > skillDataArr.length - 1 || this.hasSkill_Fire_By_Level(lv))
         {
            return false;
         }
         if(this.skill_value >= skillDataArr[lv])
         {
            if(this.skill_learnType == 1 || this.skill_learnType == 7)
            {
               return true;
            }
         }
         return false;
      }
      
      public function canLearnSkillWater(lv:int) : Boolean
      {
         if(lv < 1 || lv > skillDataArr.length - 1 || this.hasSkill_Water_By_Level(lv))
         {
            return false;
         }
         if(this.skill_value >= skillDataArr[lv])
         {
            if(this.skill_learnType == 2 || this.skill_learnType == 7)
            {
               return true;
            }
         }
         return false;
      }
      
      public function canLearnSkillWood(lv:int) : Boolean
      {
         if(lv < 1 || lv > skillDataArr.length - 1 || this.hasSkill_Wood_By_Level(lv))
         {
            return false;
         }
         if(this.skill_value >= skillDataArr[lv])
         {
            if(this.skill_learnType == 4 || this.skill_learnType == 7)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get isUserSKill() : int
      {
         return this._isUserSKill;
      }
      
      public function set isUserSKill(skillEffItemID:int) : void
      {
         this._isUserSKill = skillEffItemID;
         if(this._isUserSKill > 1208096)
         {
            throw "技能裝扮過界 isUserSKill=" + this._isUserSKill;
         }
         if(this._isUserSKill > 0)
         {
            this.skillLevel = int((this._isUserSKill - 1208000) / 3) + 1;
            this.skillType = (this._isUserSKill - 1208000) % 3 + 1;
         }
         else
         {
            this.skillType = 0;
         }
      }
      
      public function get PetName() : String
      {
         return this._PetName;
      }
      
      public function set PetName(lamuname:String) : void
      {
         if(Boolean(this.PetID) && lamuname == null)
         {
            trace("拉姆名字為空！");
         }
         this._PetName = lamuname;
      }
      
      public function get PetCloth() : int
      {
         return this._PetCloth;
      }
      
      public function set PetCloth(itemid:int) : void
      {
         this._PetCloth = itemid;
         if(Boolean(this._PetCloth))
         {
            this.ClothObj = GoodsInfo.getInfoById(this._PetCloth);
         }
         else
         {
            this.ClothObj = {};
         }
      }
   }
}

