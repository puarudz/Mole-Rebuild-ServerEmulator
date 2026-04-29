package com.mole.app.christmas
{
   import com.common.Alert.Alert;
   import com.event.EventTaomee;
   import com.logic.socket.angelsAndDemons.AngelsWarEndResultsSocket;
   import com.logic.socket.angelsAndDemons.KillMonsterSocket;
   import com.module.tommyWork.submarineWork;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.type.ModuleType;
   
   public class ChristmasAngelData
   {
      
      public static var taskID:uint;
      
      public static var mode:uint = 0;
      
      public function ChristmasAngelData()
      {
         super();
      }
      
      public static function regeditGameOver() : void
      {
         GV.onlineSocket.addEventListener("tdGameOver",tdGameOver);
      }
      
      private static function tdGameOver(e:EventTaomee) : void
      {
         var beatEnemyCount:int = 0;
         var i:Object = null;
         var totalScore:int = 0;
         GV.onlineSocket.removeEventListener("tdGameOver",tdGameOver);
         if(GV.MapInfo_mapID == 38)
         {
            if(e.EventObj.isWin == 1)
            {
               submarineWork.instance().InitWork();
            }
            return;
         }
         var obj:Object = e.EventObj;
         if(obj.id == 88 || obj.id == 89 || obj.id == 90)
         {
            GV.onlineSocket.addEventListener("read_" + 7072,GiveGameAward);
         }
         for(i in obj.enemy)
         {
            beatEnemyCount += obj.enemy[i].count;
         }
         trace("後台最大戰利品數量：" + KillMonsterSocket.b_count);
         for(i in obj.prizeArr)
         {
            if(obj.prizeArr[i].prize_id == 1353433)
            {
               if(obj.prizeArr[i].prize_count > KillMonsterSocket.b_count)
               {
                  trace("超出後台限制了！");
                  obj.prizeCount = KillMonsterSocket.b_count;
                  obj.prizeArr[i].prize_count = KillMonsterSocket.b_count;
               }
            }
         }
         totalScore = beatEnemyCount * 10 + obj.starCount * 10 + obj.lifeCount * 10 + obj.winScore;
         AngelsWarEndResultsSocket.angelsWarEndResultsFun(obj.id,int(obj.clearance),obj.round,totalScore,obj.enemy,obj.prizeArr,obj.attackArr);
      }
      
      private static function GiveGameAward(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 7072,GiveGameAward);
         if(e.EventObj.count > 0)
         {
            Alert.smileAlart("　　恭喜你獲得" + e.EventObj.count + "個“時光碎片“！");
         }
      }
      
      public static function openGame(id:uint) : void
      {
         taskID = id;
         ModuleManager.openPanel(ModuleType.CHRISTMAS_ANGEL_SELECT_PANEL);
      }
   }
}

