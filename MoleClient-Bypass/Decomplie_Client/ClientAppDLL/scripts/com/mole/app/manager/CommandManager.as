package com.mole.app.manager
{
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.manager.LevelManager;
   import com.core.newloader.MCLoader;
   import com.event.MCLoadEvent;
   import com.global.staticData.CommandID;
   import com.mole.app.map.MapManager;
   import com.mole.app.task.Task;
   import com.mole.app.task.TaskManager;
   import com.mole.app.type.ModuleType;
   import com.mole.debug.DebugManager;
   import flash.utils.ByteArray;
   
   public class CommandManager
   {
      
      public static const KEY:String = "key";
      
      public static const DEBUG:String = "debug";
      
      private static var _cmdStr:String = "";
      
      public function CommandManager()
      {
         super();
      }
      
      public static function execute(cmdStr:String) : void
      {
         var param:Array = null;
         var cmdArr:Array = cmdStr.split(" ");
         switch(cmdArr[0])
         {
            case KEY:
               if(DebugManager.DEBUG)
               {
                  param = cmdArr.slice(2);
                  keyDebug(cmdArr[1],param);
               }
               break;
            case DEBUG:
               if(!DebugManager.DEBUG)
               {
                  DebugManager.DEBUG = true;
               }
               break;
            default:
               DebugManager.execute(cmdArr);
         }
      }
      
      private static function keyDebug(keyStr:String, param:Array) : void
      {
         var onLoadWishPond:Function = null;
         var resID:uint = 0;
         var clothIds:Array = null;
         var tba:ByteArray = null;
         var mcloader:MCLoader = null;
         var roleType:uint = 0;
         var task:Task = null;
         var j:int = 0;
         onLoadWishPond = function(event:MCLoadEvent):void
         {
            var content:* = event.getContent();
            mcloader.removeEventListener(MCLoadEvent.ON_SUCCESS,onLoadWishPond);
            mcloader.clear();
            mcloader = null;
         };
         var tmpStr:String = keyStr.toUpperCase();
         switch(tmpStr)
         {
            case "Z":
               SimpleIntrPanelManager.show(param[0]);
               break;
            case "A":
               GF.switchMap(uint(param[0]),true);
               break;
            case "B":
               task = TaskManager.getTask(uint(param[0]));
               task.state = 1;
               break;
            case "C":
               ModuleManager.openPanel("ChildrenDayGiftPanel",null,"",null,false);
               break;
            case "D":
               ModuleManager.openPanel("YoYoShoppingPanel",null,"",null,false);
               break;
            case "E":
               ModuleManager.openPanel(param[0],null,"正在加載模塊",null);
               break;
            case "F":
               LevelManager.stage.frameRate = 60;
               MapManager.clearMap();
               resID = DownLoadManager.add("module/external/BubbleMainB2.swf",ResType.DISPLAY_OBJECT,true);
               DownLoadManager.addEvent(resID,function(e:DownLoadEvent):void
               {
                  LevelManager.topLevel.addChild(e.data);
               });
               break;
            case "G":
               ModuleManager.openGame(param[0],null,"正在加載遊戲，請耐心等待......");
               break;
            case "Y":
               clothIds = String(param[0]).split("|");
               tba = new ByteArray();
               tba.writeUnsignedInt(clothIds.length);
               for(j = 0; j < clothIds.length; j++)
               {
                  tba.writeUnsignedInt(clothIds[j]);
               }
               GF.sendSocket(CommandID.useUDProperty,tba);
               break;
            case "I":
               ModuleManager.openPanel("NewYearLoginPanel");
               break;
            case "J":
               ModuleManager.openPanel("AngelTreasureCompetitionPanel");
               break;
            case "K":
               mcloader = new MCLoader("module/external/WishPond.swf",GV.MC_AppLever,1,"正在打開許願面板");
               mcloader.addEventListener(MCLoadEvent.ON_SUCCESS,onLoadWishPond);
               mcloader.doLoad();
               break;
            case "L":
               ModuleManager.openPanel("DressGamePanel");
               break;
            case "M":
               ModuleManager.openPanel("LovelyChangeClothPanel");
               break;
            case "N":
               ModuleManager.openPanel("GreedyCatPanel");
               break;
            case "O":
               ModuleManager.openPanel("LoveSeasonSwapPanel");
               break;
            case "P":
               ModuleManager.openPanel("MoleNewOldJoyPanel");
               break;
            case "Q":
               ModuleManager.openPanel("KaLuoLaDiaryPanel");
               break;
            case "X":
               ModuleManager.openPanel("MagicSpiritMainPanel",1);
               break;
            case "CHANGE":
               roleType = uint(param[0]);
               TransfigurationManager.changeRoleType(roleType);
               break;
            case "SPORT":
               ModuleManager.openGame(ModuleType.SPORTS_SHOT_GAME);
         }
      }
   }
}

