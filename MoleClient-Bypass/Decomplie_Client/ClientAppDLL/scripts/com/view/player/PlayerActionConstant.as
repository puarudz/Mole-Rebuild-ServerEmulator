package com.view.player
{
   public class PlayerActionConstant
   {
      
      public static const PLAYER_ACTION_TYPE_0:uint = 1001;
      
      public static const PLAYER_ACTION_TYPE_1:uint = 1002;
      
      public static const PLAYER_ACTION_TYPE_2:uint = 1003;
      
      public static const RUN_DOWN:uint = 0;
      
      public static const RUN_LEFT_DOWN:uint = 1;
      
      public static const RUN_LEFT:uint = 2;
      
      public static const RUN_LEFT_UP:uint = 3;
      
      public static const RUN_UP:uint = 4;
      
      public static const RUN_RIGHT_UP:uint = 5;
      
      public static const RUN_RIGHT:uint = 6;
      
      public static const RUN_RIGHT_DOWN:uint = 7;
      
      public static const STAND_DOWN:uint = 8;
      
      public static const STAND_LEFT_DOWN:uint = 9;
      
      public static const STAND_LEFT:uint = 10;
      
      public static const STAND_LEFT_UP:uint = 11;
      
      public static const STAND_UP:uint = 12;
      
      public static const STAND_RIGHT_UP:uint = 13;
      
      public static const STAND_RIGHT:uint = 14;
      
      public static const STAND_RIGHT_DOWN:uint = 15;
      
      public static const SIT_DOWN:uint = 0;
      
      public static const SIT_LEFT_DOWN:uint = 1;
      
      public static const SIT_LEFT:uint = 2;
      
      public static const SIT_LEFT_UP:uint = 3;
      
      public static const SIT_UP:uint = 4;
      
      public static const SIT_RIGHT_UP:uint = 5;
      
      public static const SIT_RIGHT:uint = 6;
      
      public static const SIT_RIGHT_DOWN:uint = 7;
      
      public static const WAVE:uint = 0;
      
      public static const DANCE:uint = 1;
      
      public static const THROW_RIGHT_UP:uint = 2;
      
      public static const THROW_LEFT_DOWN:uint = 3;
      
      public static const THROW_LEFT_UP:uint = 4;
      
      public static const THROW_RIGHT_DOWN:uint = 5;
      
      public static const SPECIAL:uint = 6;
      
      public static const ACTION_RUN:uint = 0;
      
      public static const ACTION_STAND:uint = 1;
      
      public static const ACTION_SIT:uint = 2;
      
      public static const ACTION_WAVE:uint = 3;
      
      public static const ACTION_DANCE:uint = 4;
      
      public static const ACTION_THROW:uint = 5;
      
      public static const ACTION_SPECIAL:uint = 6;
      
      private static const RUN_INDEX:Array = [];
      
      private static const STAND_INDEX:Array = [];
      
      private static const SIT_INDEX:Array = [];
      
      private static const THROW_INDEX:Array = [];
      
      private static const NEW_ANGEL_STAND_INDEX:Array = [];
      
      private static const NEW_ANGEL_RUN_INDEX:Array = [];
      
      RUN_INDEX.push(RUN_DOWN);
      RUN_INDEX.push(RUN_LEFT_DOWN);
      RUN_INDEX.push(RUN_LEFT);
      RUN_INDEX.push(RUN_LEFT_UP);
      RUN_INDEX.push(RUN_UP);
      RUN_INDEX.push(RUN_RIGHT_UP);
      RUN_INDEX.push(RUN_RIGHT);
      RUN_INDEX.push(RUN_RIGHT_DOWN);
      STAND_INDEX.push(STAND_DOWN);
      STAND_INDEX.push(STAND_LEFT_DOWN);
      STAND_INDEX.push(STAND_LEFT);
      STAND_INDEX.push(STAND_LEFT_UP);
      STAND_INDEX.push(STAND_UP);
      STAND_INDEX.push(STAND_RIGHT_UP);
      STAND_INDEX.push(STAND_RIGHT);
      STAND_INDEX.push(STAND_RIGHT_DOWN);
      SIT_INDEX.push(SIT_DOWN);
      SIT_INDEX.push(SIT_LEFT_DOWN);
      SIT_INDEX.push(SIT_LEFT);
      SIT_INDEX.push(SIT_LEFT_UP);
      SIT_INDEX.push(SIT_UP);
      SIT_INDEX.push(SIT_RIGHT_UP);
      SIT_INDEX.push(SIT_RIGHT);
      SIT_INDEX.push(SIT_RIGHT_DOWN);
      THROW_INDEX.push(THROW_LEFT_DOWN);
      THROW_INDEX.push(THROW_LEFT_DOWN);
      THROW_INDEX.push(THROW_LEFT_UP);
      THROW_INDEX.push(THROW_LEFT_UP);
      THROW_INDEX.push(THROW_RIGHT_UP);
      THROW_INDEX.push(THROW_RIGHT_UP);
      THROW_INDEX.push(THROW_RIGHT_DOWN);
      THROW_INDEX.push(THROW_RIGHT_DOWN);
      NEW_ANGEL_STAND_INDEX.push(0);
      NEW_ANGEL_STAND_INDEX.push(1);
      NEW_ANGEL_STAND_INDEX.push(2);
      NEW_ANGEL_STAND_INDEX.push(3);
      NEW_ANGEL_STAND_INDEX.push(4);
      NEW_ANGEL_STAND_INDEX.push(3);
      NEW_ANGEL_STAND_INDEX.push(2);
      NEW_ANGEL_STAND_INDEX.push(1);
      NEW_ANGEL_RUN_INDEX.push(5);
      NEW_ANGEL_RUN_INDEX.push(6);
      NEW_ANGEL_RUN_INDEX.push(7);
      NEW_ANGEL_RUN_INDEX.push(8);
      NEW_ANGEL_RUN_INDEX.push(9);
      NEW_ANGEL_RUN_INDEX.push(8);
      NEW_ANGEL_RUN_INDEX.push(7);
      NEW_ANGEL_RUN_INDEX.push(6);
      
      public function PlayerActionConstant()
      {
         super();
      }
      
      public static function getActionTypeId(action:uint) : uint
      {
         switch(action)
         {
            case ACTION_RUN:
            case ACTION_STAND:
               return PLAYER_ACTION_TYPE_0;
            case ACTION_SIT:
               return PLAYER_ACTION_TYPE_1;
            case ACTION_WAVE:
            case ACTION_DANCE:
            case ACTION_THROW:
            case ACTION_SPECIAL:
               return PLAYER_ACTION_TYPE_2;
            default:
               return PLAYER_ACTION_TYPE_0;
         }
      }
      
      public static function getActionIndex(actionId:uint, dir:uint) : uint
      {
         dir = Math.min(dir,7);
         if(actionId == ACTION_RUN)
         {
            return RUN_INDEX[dir];
         }
         if(actionId == ACTION_STAND)
         {
            return STAND_INDEX[dir];
         }
         if(actionId == ACTION_SIT)
         {
            return SIT_INDEX[dir];
         }
         if(actionId == ACTION_WAVE)
         {
            return WAVE;
         }
         if(actionId == ACTION_DANCE)
         {
            return DANCE;
         }
         if(actionId == ACTION_THROW)
         {
            return THROW_INDEX[dir];
         }
         if(actionId == ACTION_SPECIAL)
         {
            return SPECIAL;
         }
         return STAND_DOWN;
      }
      
      public static function getNewRoleActionIndex(actionId:uint, dir:uint) : uint
      {
         dir = Math.min(dir,7);
         var rtnIndex:uint = 0;
         switch(actionId)
         {
            case ACTION_RUN:
               if(dir >= 3 && dir <= 5)
               {
                  rtnIndex = 1;
               }
               else
               {
                  rtnIndex = 0;
               }
               break;
            case ACTION_STAND:
               if(dir >= 3 && dir <= 5)
               {
                  rtnIndex = 3;
               }
               else
               {
                  rtnIndex = 2;
               }
               break;
            case ACTION_SIT:
               if(dir >= 3 && dir <= 5)
               {
                  rtnIndex = 1;
               }
               else
               {
                  rtnIndex = 0;
               }
               break;
            case ACTION_WAVE:
               rtnIndex = 0;
               break;
            case ACTION_DANCE:
               rtnIndex = 1;
               break;
            case ACTION_THROW:
               if(dir >= 3 && dir <= 5)
               {
                  rtnIndex = 3;
               }
               else
               {
                  rtnIndex = 2;
               }
         }
         return rtnIndex;
      }
      
      public static function getNewAngelActionIndex(actionId:uint, dir:uint) : uint
      {
         dir = Math.min(dir,7);
         if(actionId == ACTION_RUN)
         {
            return NEW_ANGEL_RUN_INDEX[dir];
         }
         if(actionId == ACTION_STAND)
         {
            return NEW_ANGEL_STAND_INDEX[dir];
         }
         return 0;
      }
   }
}

