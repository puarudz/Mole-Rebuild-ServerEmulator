package com.module.pig
{
   import com.core.MainManager;
   import com.module.pig.view.pig.PigData;
   import flash.display.MovieClip;
   
   public class PigTipCtl
   {
      
      private static var _data:PigData;
      
      private static var _ui:MovieClip;
      
      private static var _x:Number;
      
      private static var _y:Number;
      
      private static const Max_Width:Number = 960;
      
      private static const Max_Height:Number = 560;
      
      public function PigTipCtl()
      {
         super();
      }
      
      public static function ShowTip(data:PigData, x:Number, y:Number) : void
      {
         ClearTip();
         _data = data;
         _x = x;
         _y = y;
         if(_data != null)
         {
            if(Boolean(_ui))
            {
               GC.clearAll(_ui);
               _ui = null;
            }
            DoShowTip();
         }
      }
      
      private static function DoShowTip() : void
      {
         if(_data == null)
         {
            return;
         }
         var data:PigData = _data;
         _ui = PigHouseUI.instance.GetMovieClip("pigTip_mc");
         _ui.parent_mc.visible = false;
         _ui.seed_mc.visible = false;
         _ui.make_mc.visible = false;
         _ui.canSeed_mc.visible = false;
         var offsetY:Number = 6;
         var height:Number = _ui.sex_mc.y + _ui.sex_mc.height + offsetY;
         var line:int = 1;
         if(data.name == null)
         {
            return;
         }
         _ui.name_txt.text = data.name;
         _ui.sex_mc.gotoAndStop(data.sex + 1);
         if(data.fatherName != "" && data.matherName != "")
         {
            _ui.parent_mc.y = height;
            _ui.parent_mc.visible = true;
            _ui.parent_mc.father_txt.text = data.fatherName;
            _ui.parent_mc.mother_txt.text = data.matherName;
            height += _ui.parent_mc.height + offsetY;
            line += 2;
         }
         if(data.sex == PigData.Sex_Male)
         {
            if(data.growState == PigData.Grow_State_Adult)
            {
               if(data.isCanMaking && data.breed == PigData.Breed_Fat_Pig)
               {
                  _ui.make_mc.y = height;
                  height += _ui.make_mc.height + offsetY;
                  _ui.make_mc.visible = true;
                  line++;
               }
            }
            else if(data.isSpecialPigCanNotMake == false && data.breed == PigData.Breed_Fat_Pig)
            {
               _ui.seed_mc.y = height;
               height += _ui.seed_mc.height + offsetY;
               _ui.seed_mc.visible = true;
               _ui.seed_mc.type_mc.gotoAndStop(3);
               _ui.seed_mc.time_txt.text = data.SecondToString(data.timeToGrowUp);
               line++;
            }
         }
         else if(data.growState != PigData.Grow_State_Adult)
         {
            _ui.seed_mc.y = height;
            height += _ui.seed_mc.height + offsetY;
            _ui.seed_mc.visible = true;
            _ui.seed_mc.type_mc.gotoAndStop(1);
            _ui.seed_mc.time_txt.text = data.SecondToString(data.timeToGrowUp);
            line++;
         }
         else
         {
            if(data.isHasBaby)
            {
               _ui.seed_mc.y = height;
               height += _ui.seed_mc.height + offsetY;
               _ui.seed_mc.visible = true;
               _ui.seed_mc.type_mc.gotoAndStop(2);
               _ui.seed_mc.time_txt.text = data.SecondToString(data.babyTime);
               line++;
            }
            if(data.isCanMaking && data.breed == PigData.Breed_Fat_Pig)
            {
               if(data.isCanSeed)
               {
                  _ui.canSeed_mc.y = height;
                  _ui.canSeed_mc.visible = true;
               }
               _ui.make_mc.y = height;
               height += _ui.make_mc.height + offsetY;
               _ui.make_mc.visible = true;
               line++;
            }
            else if(data.isCanSeed)
            {
               _ui.canSeed_mc.y = height;
               height += _ui.canSeed_mc.height + offsetY;
               _ui.canSeed_mc.visible = true;
               _ui.canSeed_mc.x = _ui.make_mc.x;
               line++;
            }
         }
         _ui.bg_mc.gotoAndStop(line);
         _ui.x = _x + 30;
         _ui.y = _y - height - 10;
         if(_ui.x + _ui.width > Max_Width)
         {
            _ui.x = Max_Width - _ui.width;
         }
         if(_ui.y + height > Max_Height)
         {
            _ui.y = Max_Height - height;
         }
         _ui.mouseChildren = false;
         _ui.mouseChildren = false;
         MainManager.getAppLevel().addChild(_ui);
      }
      
      public static function ClearTip() : void
      {
         if(Boolean(_ui))
         {
            GC.clearAll(_ui);
            _ui = null;
         }
         _x = 0;
         _y = 0;
         _data = null;
      }
   }
}

