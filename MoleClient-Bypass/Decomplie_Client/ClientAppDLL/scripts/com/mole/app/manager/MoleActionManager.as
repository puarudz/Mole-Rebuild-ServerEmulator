package com.mole.app.manager
{
   import com.logic.socket.action.ActionReq;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.info.MoleActionInfo;
   import com.mole.app.info.NPCDialogInfo;
   import com.mole.app.map.MapBase;
   import com.mole.app.map.MapManager;
   import com.mole.app.type.ActionType;
   import com.mole.app.utils.PlayMovie;
   import com.mole.config.info.Config;
   import com.mole.debug.DebugManager;
   import com.view.MapManageView.MapManageView;
   import com.view.PeopleView.PeopleManageView;
   import com.view.mapView.activity.Task83.StatisticsClass;
   import flash.utils.setTimeout;
   
   public class MoleActionManager
   {
      
      public function MoleActionManager()
      {
         super();
      }
      
      public static function doAction(actionInfo:MoleActionInfo) : void
      {
         var npcDialogInfo:NPCDialogInfo = null;
         var mapBase:MapBase = null;
         var valList:Array = null;
         var min:int = 0;
         var max:int = 0;
         var val:int = 0;
         var people:PeopleManageView = null;
         var sitParamArr:Array = null;
         if(actionInfo == null)
         {
            DebugManager.traceMsg("行動參數為空！");
            return;
         }
         switch(actionInfo.cmd)
         {
            case ActionType.SAY:
               NPCDialogManager.say(npcDialogInfo);
               break;
            case ActionType.OPEN_MODULE:
               ModuleManager.openModule(actionInfo.param,String(actionInfo.data));
               break;
            case ActionType.OPEN_PANEL:
               StatisticsClass.getInstance().init(67748716);
               ModuleManager.openPanel(actionInfo.param,String(actionInfo.data));
               break;
            case ActionType.OPEN_GAME:
               ModuleManager.openGame(actionInfo.param,String(actionInfo.data));
               break;
            case ActionType.PLAY_MOVIE:
               PlayMovie.play(actionInfo.param);
               break;
            case ActionType.MAP_SAY:
               npcDialogInfo = MapManageView.inst.mapControl.getNpcDialogInfo(actionInfo.param);
               NPCDialogManager.say(npcDialogInfo);
               break;
            case ActionType.TASK_FUNCTION:
            case ActionType.FUNCTION:
               actionInfo.param.apply(null,actionInfo.data);
               break;
            case ActionType.SYSTEM_ACT:
            case ActionType.SYSTEM_SAY_ACT:
               SystemEventManager.dispatchEvent(new SystemEvent(actionInfo.param,actionInfo.data));
               break;
            case ActionType.GO_MAP:
               MapManager.enterMap(actionInfo.param,actionInfo.data);
               break;
            case ActionType.ALT_MAP:
               MapManager.enterMap(actionInfo.param,actionInfo.data,false);
               break;
            case ActionType.RND_SAY:
               mapBase = MapManageView.inst.mapControl.map;
               if(Boolean(mapBase))
               {
                  valList = String(actionInfo.param).split("-");
                  min = int(valList[0]);
                  max = int(valList[1]);
                  val = Math.floor(Math.random() * (max - min + 1)) + min;
                  mapBase.mapSay(val);
               }
               break;
            case ActionType.SIT:
               people = GV.MAN_PEOPLE;
               if(Boolean(people))
               {
                  sitParamArr = String(actionInfo.param).split(Config.SEPARATOR);
                  new ActionReq().actions(3,uint(sitParamArr[0]));
                  people.sitDown(uint(sitParamArr[0]));
                  if(Boolean(sitParamArr[1]))
                  {
                     setTimeout(function():void
                     {
                        SystemEventManager.dispatchEvent(new SystemEvent(sitParamArr[1],actionInfo.data));
                     },1000);
                  }
               }
               break;
            case ActionType.INTR:
               SimpleIntrPanelManager.show(actionInfo.param);
         }
      }
   }
}

