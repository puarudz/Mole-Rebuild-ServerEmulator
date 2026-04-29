package com.module.pig.view.pig
{
   import com.common.data.HashMap;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.util.StringUtil;
   
   public class PigData
   {
      
      public static const Grow_State_Adult:int = 3;
      
      public static const Grow_State_Baby:int = 1;
      
      public static const Grow_State_Yonger:int = 2;
      
      public static const Sex_Female:int = 1;
      
      public static const Sex_Male:int = 0;
      
      public static const Max_Train_Point:int = 80;
      
      public static const Breed_Fat_Pig:int = 0;
      
      public static const Breed_Beauty_Pig:int = 1;
      
      public static const Breed_Strength_Pig:int = 2;
      
      private var _ready_work:Boolean = false;
      
      private var _data:HashMap;
      
      public function PigData()
      {
         super();
         this._data = new HashMap();
      }
      
      public function SecondToString(time:int, showDay:Boolean = false) : String
      {
         var day:int = 0;
         var hour:int = 0;
         var minute:int = 0;
         var str:String = "";
         if(showDay)
         {
            day = Math.floor(time / (24 * 3600));
            hour = Math.floor(time / 3600) % 24;
            minute = Math.floor(time / 60) % 60;
            if(day > 0)
            {
               str += day + "天";
            }
            if(hour > 0)
            {
               str += hour + "小時";
            }
            if(minute > 0)
            {
               str += minute + "分鐘";
            }
         }
         else
         {
            hour = Math.floor(time / 3600);
            minute = Math.floor(time / 60) % 60;
            if(hour > 0)
            {
               str += hour + "小時";
            }
            if(minute > 0)
            {
               str += minute + "分鐘";
            }
         }
         return str;
      }
      
      public function UpdateData(data:HashMap) : void
      {
         this._data.combine(data);
      }
      
      public function get age() : int
      {
         return this._data.getValue("age");
      }
      
      public function get babyTime() : int
      {
         return this._data.getValue("babyTime");
      }
      
      public function get breed() : int
      {
         var t:int = this.type;
         if(t < 10000)
         {
            return 0;
         }
         if(10000 <= t < 20000)
         {
            return 1;
         }
         return 2;
      }
      
      public function get dress_1() : int
      {
         return this._data.getValue("dress_1");
      }
      
      public function get dress_2() : int
      {
         return this._data.getValue("dress_2");
      }
      
      public function get fatherName() : String
      {
         return StringUtil.trim(this._data.getValue("fatherName"));
      }
      
      public function get generation() : int
      {
         return this._data.getValue("generation");
      }
      
      public function get glamour() : int
      {
         return this._data.getValue("glamour");
      }
      
      public function get growState() : int
      {
         return this.state & 3;
      }
      
      public function get growUpTime() : int
      {
         var day:int = 2;
         if(this.breed == PigData.Breed_Beauty_Pig)
         {
            day = 6;
         }
         if(this.breed == PigData.Breed_Strength_Pig)
         {
            day = 6;
         }
         return day * 24 * 3600;
      }
      
      public function get growthSpeed() : int
      {
         return this._data.getValue("growthSpeed");
      }
      
      public function get hungry() : int
      {
         return this._data.getValue("hunger");
      }
      
      public function get id() : int
      {
         return this._data.getValue("id");
      }
      
      public function get isCanMaking() : Boolean
      {
         return this.isDied == false && this.isDying == false && this.hungry != 100 && this.growState == Grow_State_Adult && this.isSpecialPigCanNotMake == false;
      }
      
      public function get isSpecialPigCanNotMake() : Boolean
      {
         return this.itemId == 1593030 || this.itemId == 1593034 || this.itemId == 1593032 || this.itemId == 1593033;
      }
      
      public function get isCanSeed() : Boolean
      {
         return this.isDied == false && this.isDying == false && Boolean(this.state & 0x0200);
      }
      
      public function get isCanTease() : Boolean
      {
         return this.isDied == false && this.isDying == false && this.teaseCont < 3;
      }
      
      public function get isCanTrain_1() : Boolean
      {
         var value:Boolean = this.hungry < 100 && Boolean(this.state & 0x80) == false && this.trainPoint < Max_Train_Point;
         return this.isDied == false && this.isDying == false && value;
      }
      
      public function get isCanTrain_2() : Boolean
      {
         var value:Boolean = this.hungry < 100 && Boolean(this.state & 0x0100) == false && this.trainPoint < Max_Train_Point;
         return this.isDied == false && this.isDying == false && value;
      }
      
      public function get isDied() : Boolean
      {
         return Boolean(this.state & 8);
      }
      
      public function get isDying() : Boolean
      {
         return Boolean(this.state & 4);
      }
      
      public function get isHasBaby() : Boolean
      {
         return Boolean(this.state & 0x10);
      }
      
      public function get isCanSendToTemp() : Boolean
      {
         return this.isHasBaby == false && this.isDied == false;
      }
      
      public function get isHasTwoBaby() : Boolean
      {
         return Boolean(this.state & 0x20);
      }
      
      public function get isHasVariationBaby() : Boolean
      {
         return Boolean(this.state & 0x40);
      }
      
      public function get isSpecial() : Boolean
      {
         return Boolean(this._data.getValue("isSpecial"));
      }
      
      public function get itemId() : int
      {
         return this._data.getValue("itemId");
      }
      
      public function get liftTime() : int
      {
         return this._data.getValue("liftTime");
      }
      
      public function get mateCount() : int
      {
         return this._data.getValue("mateCount");
      }
      
      public function get matherName() : String
      {
         return StringUtil.trim(this._data.getValue("matherName"));
      }
      
      public function get name() : String
      {
         return this._data.getValue("name");
      }
      
      public function set name(value:String) : void
      {
         this._data.add("name",value);
      }
      
      public function get sex() : int
      {
         return this._data.getValue("sex");
      }
      
      public function get star() : int
      {
         return this._data.getValue("generation");
      }
      
      public function get strength() : int
      {
         return this._data.getValue("strength");
      }
      
      public function get teaseCont() : int
      {
         return this._data.getValue("teaseCont");
      }
      
      public function get timeToDie() : int
      {
         return this.liftTime - this.age;
      }
      
      public function get timeToGrowUp() : int
      {
         return this.growUpTime - this.age;
      }
      
      public function get trainPoint() : int
      {
         return this._data.getValue("trainPoint");
      }
      
      public function get isTransformed() : Boolean
      {
         return this.transformId > 0 && this.transformTime > 0;
      }
      
      public function get transformId() : int
      {
         return this._data.getValue("transformId");
      }
      
      public function get transformTime() : int
      {
         return this._data.getValue("transformTime");
      }
      
      public function get type() : int
      {
         return GoodsInfo.getInfoById(this.itemId).Type;
      }
      
      public function get weight() : int
      {
         return this._data.getValue("weight");
      }
      
      public function get state() : int
      {
         return this._data.getValue("state");
      }
      
      public function get showId() : int
      {
         if(this.transformId > 0 && this.transformTime > 0)
         {
            return this.transformId;
         }
         if(this.dress_1 > 0)
         {
            return this.dress_1;
         }
         return this.itemId;
      }
      
      public function isCanShow() : Boolean
      {
         return this.breed == 1 && !this.isDied && !this.isTransformed && this.hungry != 100;
      }
      
      public function isCanWeigh() : Boolean
      {
         return this.breed == 0 && !this.isDied && this.hungry != 100;
      }
      
      public function isCanCarry() : Boolean
      {
         return this.breed != 0 && !this.isDied && !this.isDying && this.hungry != 100;
      }
      
      public function isCanIntensify() : Boolean
      {
         return !this.isDied && this.growState == Grow_State_Adult && this.isHasBaby == false;
      }
      
      public function get inJect() : Boolean
      {
         return this._data.getValue("able_inject");
      }
      
      public function get energy() : uint
      {
         return this._data.getValue("energy");
      }
      
      public function get maxEnergy() : uint
      {
         return this._data.getValue("max_energy");
      }
      
      public function isFullEnergy() : Boolean
      {
         return this.energy == this.maxEnergy;
      }
      
      public function get ready_work() : Boolean
      {
         return this._ready_work;
      }
      
      public function set ready_work(value:Boolean) : void
      {
         this._ready_work = value;
      }
   }
}

