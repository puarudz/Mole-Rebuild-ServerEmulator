package com.module.newAngel.constant
{
   import com.module.newAngel.info.AngelInfo;
   
   public class NewAngelStaticInfo
   {
      
      public static const NEW_ANGEL_MAX_LEVEL:uint = 100;
      
      public function NewAngelStaticInfo()
      {
         super();
      }
      
      public static function addAngelExp(angelInfo:AngelInfo, exp:uint) : void
      {
         var curLvNeedExp:uint = 0;
         var addLv:uint = 0;
         if(exp - angelInfo.angelNextLvExp >= 0)
         {
            exp -= angelInfo.angelNextLvExp;
            addLv = 1;
            while(exp > 0)
            {
               curLvNeedExp = getCurLvNeedExp(angelInfo.angelLv + addLv);
               if(exp - curLvNeedExp > 0)
               {
                  exp -= curLvNeedExp;
                  addLv++;
               }
               else
               {
                  angelInfo.angelNextLvExp -= exp;
                  exp = 0;
               }
            }
         }
         else
         {
            angelInfo.angelNextLvExp -= exp;
         }
         angelInfo.angelLv += addLv;
      }
      
      public static function getCurLvNeedExp(lv:uint) : uint
      {
         return Math.pow(lv,2) + lv * 10;
      }
      
      public static function getAddMaxExp(angelInfo:AngelInfo, exp:uint) : uint
      {
         var canAddExp:uint = 0;
         var curLvNeedExp:uint = 0;
         if(angelInfo.angelLv == angelInfo.staticInfo.evolution)
         {
            return 0;
         }
         var addLv:uint = 0;
         if(exp - angelInfo.angelNextLvExp >= 0)
         {
            exp -= angelInfo.angelNextLvExp;
            canAddExp += angelInfo.angelNextLvExp;
            addLv = 1;
            while(exp > 0)
            {
               curLvNeedExp = getCurLvNeedExp(angelInfo.angelLv + addLv);
               if(exp - curLvNeedExp > 0)
               {
                  exp -= curLvNeedExp;
                  canAddExp += curLvNeedExp;
                  addLv++;
                  if(angelInfo.angelLv + addLv == 100)
                  {
                     break;
                  }
               }
               else
               {
                  canAddExp += exp;
                  exp = 0;
               }
            }
         }
         else
         {
            canAddExp = exp;
         }
         return canAddExp;
      }
   }
}

