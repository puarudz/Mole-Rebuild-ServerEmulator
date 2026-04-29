package com.mole.app.activity
{
   import com.common.Alert.Alert;
   import com.event.EventTaomee;
   import com.logic.mapEvent.MapEvent;
   import com.module.activityModule.Presented;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.info.NPCDialogInfo;
   import com.mole.app.info.NPCDialogOptionInfo;
   import com.mole.app.manager.BufferManager;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.NPCDialogManager;
   import com.mole.app.manager.QueryItemCntManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapManager;
   import com.mole.app.type.ActionType;
   import com.mole.app.utils.PlayMovie;
   import com.view.MapManageView.MapManageView;
   import com.view.PeopleView.PeopleManageView;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   
   public class TimeMachine extends EventDispatcher
   {
      
      private static var _instance:TimeMachine;
      
      public static const TIME_MACHINE_OPEN:String = "openTimeMachine";
      
      public static const TIME_MACHINE_STATUS_CHANGE:String = "changeTimeMachineStatus";
      
      private var _status:int = -1;
      
      private var _function:Function;
      
      private var _dialogInfo:NPCDialogInfo;
      
      private var _dialogOption:NPCDialogOptionInfo;
      
      private var _queryItemCnt:QueryItemCntManager;
      
      private var _playMovie:PlayMovie;
      
      private var _presented:Presented;
      
      private var _medicineFlag:Boolean;
      
      public function TimeMachine()
      {
         super();
      }
      
      public static function getInstance() : TimeMachine
      {
         return _instance = _instance || new TimeMachine();
      }
      
      public static function setup() : void
      {
         getInstance().setupTimeMachine();
      }
      
      public static function getMachineStatus() : uint
      {
         if(getInstance()._status < 8)
         {
            return 1;
         }
         return 2;
      }
      
      private function setupTimeMachine() : void
      {
         addEventListener(TIME_MACHINE_OPEN,this.onOpenTimeMachine);
         BC.addEvent(this,GV.onlineSocket,MapEvent.CHANGE_MAP_COMPLETE,this.onEnterMap);
         SystemEventManager.addEventListener(TIME_MACHINE_STATUS_CHANGE,this.onStatusChangeHandler);
         SystemEventManager.addEventListener("goMapTimeMachine",this.goMapHandler);
      }
      
      private function onStatusChangeHandler(evt:EventTaomee) : void
      {
         var status:uint = uint(evt.EventObj);
         if(status > this._status)
         {
            this._status = status;
            BufferManager.setBuffer(BufferManager.TIME_MACHINE,status);
         }
      }
      
      private function onOpenTimeMachine(evt:EventTaomee) : void
      {
         if(this._status == -1)
         {
            this._function = this.openTimeMachineView;
            this.checkActivityStatus();
         }
         else
         {
            this.openTimeMachineView();
         }
      }
      
      private function onEnterMap(e:EventTaomee) : void
      {
         if(MapManager.curMapID == 27 || MapManager.curMapID == 53 || MapManager.curMapID == 70 || MapManager.curMapID == 105)
         {
            if(this._status == -1)
            {
               this._function = this.checkStatusInMap;
               this.checkActivityStatus();
            }
            else
            {
               this.checkStatusInMap();
            }
         }
      }
      
      private function checkStatusInMap() : void
      {
         if(MapManager.curMapID == 27)
         {
            MapManageView.inst.mapLevel.controlLevel["timeMachine_mc"].visible = false;
         }
         switch(this._status)
         {
            case 0:
            case 1:
               if(MapManager.curMapID == 27)
               {
                  MapManageView.inst.mapLevel.controlLevel["timeMachine_mc"].visible = false;
                  this.addNPCDialog(2,30);
               }
               break;
            case 2:
               if(MapManager.curMapID == 53)
               {
                  this.addNPCDialog(3,20);
               }
               break;
            case 3:
               if(MapManager.curMapID == 70)
               {
                  SystemEventManager.addEventListener("beginFindSeedTimeMachine",this.beginFindSeedTimeMachine);
                  this.addNPCDialog(1,10);
               }
               break;
            case 4:
               if(MapManager.curMapID == 70)
               {
                  SystemEventManager.addEventListener("playMakeMedicineMovie",this.playMakeMedicineMovie);
                  this.addNPCDialog(1,this.checkHasEnoughSeedForAndi,ActionType.FUNCTION);
               }
               break;
            case 5:
               if(MapManager.curMapID == 53)
               {
                  this.addNPCDialog(3,22);
               }
               break;
            case 6:
               if(MapManager.curMapID == 105)
               {
                  this.playGetOldMachineMovie();
               }
               break;
            case 7:
               if(MapManager.curMapID == 27)
               {
                  MapManageView.inst.mapLevel.controlLevel["timeMachine_mc"].visible = true;
                  SystemEventManager.addEventListener("clickOldMachine",this.getClickOldMachine);
                  this.addNPCDialog(2,31);
               }
               break;
            case 8:
               this.setStatus8();
               break;
            case 9:
               if(MapManager.curMapID == 27)
               {
                  MapManageView.inst.mapLevel.controlLevel["timeMachine_mc"].visible = false;
                  SystemEventManager.addEventListener("playMakeMachineMovie",this.playMakeMachineMovie);
                  SystemEventManager.addEventListener("openMakePanelTimeMachine",this.openMakePanelTimeMachine);
                  this.addNPCDialog(2,this.checkTreeCount,ActionType.FUNCTION);
               }
               break;
            case 10:
               if(MapManager.curMapID == 27)
               {
                  MapManageView.inst.mapLevel.controlLevel["timeMachine_mc"].visible = true;
                  MapManageView.inst.mapLevel.controlLevel["timeMachine_mc"].gotoAndStop(2);
               }
         }
      }
      
      private function beginFindSeedTimeMachine(evt:Event) : void
      {
         SystemEventManager.removeEventListener("beginFindSeedTimeMachine",this.beginFindSeedTimeMachine);
         this.setStatus(1,4);
         this.checkStatusInMap();
      }
      
      private function checkHasEnoughSeedForAndi() : void
      {
         this._queryItemCnt = new QueryItemCntManager();
         this._queryItemCnt.addEventListener(QueryItemCntManager.SOMEGOODS_QUERY,this.onGetEnoughSeedForAndiResponse);
         this._queryItemCnt.someGoosQuery([12138,1230034]);
      }
      
      private function onGetEnoughSeedForAndiResponse(evt:EventTaomee) : void
      {
         this._queryItemCnt.removeEventListener(QueryItemCntManager.SOMEGOODS_QUERY,this.onGetEnoughSeedForAndiResponse);
         var data:Array = evt.EventObj as Array;
         if(data[0] < 1 || data[1] < 1)
         {
            NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(15));
         }
         else
         {
            NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(13));
         }
         this._queryItemCnt = null;
      }
      
      private function playMakeMedicineMovie(evt:SystemEvent) : void
      {
         this._presented = new Presented();
         this._presented.exchange1243(2951,this.onSwapMedicine);
         this._playMovie = PlayMovie.play("resource/intrswf/TimeMachineMakeMedicine.swf",null,null,null,null,MapManageView.inst.mapLevel.topLevel,true,"正在加載動畫",false);
         this._playMovie.addEventListener(PlayMovie.MOVIE_PALY_OVER,this.onPlayMakeMedicineMovieComplete);
         MapManageView.inst.mapLevel.controlLevel["npc_10020"].visible = false;
      }
      
      private function onSwapMedicine(itemList:Array) : void
      {
         for(var i:uint = 0; i < itemList.length; i++)
         {
            if((itemList[i] as Object).itemID == 15315)
            {
               this._medicineFlag = true;
            }
         }
         if(this._medicineFlag)
         {
            this.setStatus(1,5);
         }
      }
      
      private function onPlayMakeMedicineMovieComplete(evt:Event) : void
      {
         MapManageView.inst.mapLevel.controlLevel["npc_10020"].visible = true;
         if(Boolean(this._playMovie))
         {
            if(Boolean(this._playMovie.movie_mc))
            {
               this._playMovie.movie_mc.stop();
            }
            this._playMovie.removeEventListener(PlayMovie.MOVIE_PALY_OVER,this.onPlayMakeMedicineMovieComplete);
            this._playMovie = null;
         }
         if(this._medicineFlag)
         {
            SystemEventManager.removeEventListener("playMakeMedicineMovie",this.playMakeMedicineMovie);
            Alert.smileAlart("\t恭喜獲得快速記憶力恢復藥劑",this.goMap53);
            Alert.smileAlart("\t恭喜獲得一個國王南瓜獎勵",this.goMap53);
         }
         else
         {
            Alert.angryAlart("\t藥水製作失敗，請重新製作。");
         }
      }
      
      private function goMap53(evt:Event) : void
      {
         MapManager.enterMap(53);
      }
      
      private function goMapHandler(evt:SystemEvent) : void
      {
         var data:Array = String(evt.data).split(",");
         this._status = data[0];
         BufferManager.setBuffer(BufferManager.TIME_MACHINE,this._status);
         MapManager.enterMap(data[1]);
      }
      
      private function playGetOldMachineMovie() : void
      {
         this._playMovie = PlayMovie.play("resource/intrswf/TimeMachineGetOldMachine.swf",null,null,null,null,MapManageView.inst.mapLevel.topLevel,true,"正在加載動畫",false);
         this._playMovie.addEventListener(PlayMovie.MOVIE_PALY_OVER,this.onPlayGetOldMachineMovieComplete);
      }
      
      private function onPlayGetOldMachineMovieComplete(evt:Event) : void
      {
         if(Boolean(this._playMovie))
         {
            if(Boolean(this._playMovie.movie_mc))
            {
               this._playMovie.movie_mc.stop();
            }
            this._playMovie.removeEventListener(PlayMovie.MOVIE_PALY_OVER,this.onPlayGetOldMachineMovieComplete);
            this._playMovie = null;
         }
         this._presented = new Presented();
         this._presented.exchange1243(2952,this.onSwapOldMachine);
      }
      
      private function onSwapOldMachine(itemList:Array) : void
      {
         var i:uint;
         var getOldMachineFlag:Boolean = false;
         for(i = 0; i < itemList.length; i++)
         {
            if((itemList[i] as Object).itemID == 191111)
            {
               getOldMachineFlag = true;
            }
         }
         if(getOldMachineFlag)
         {
            this._status = 7;
            BufferManager.setBuffer(BufferManager.TIME_MACHINE,this._status);
            Alert.smileAlart("\t獲得一個大衛時光機，快去找大衛吧。",function(evt:Event):void
            {
               MapManager.enterMap(27);
            });
         }
      }
      
      private function getClickOldMachine(evt:SystemEvent) : void
      {
         MapManageView.inst.mapLevel.controlLevel["timeMachine_mc"].addEventListener(MouseEvent.CLICK,this.onClickOldMachineHandler);
         MapManageView.inst.mapLevel.controlLevel["timeMachine_mc"].buttonMode = true;
      }
      
      private function onClickOldMachineHandler(evt:MouseEvent) : void
      {
         MapManageView.inst.mapLevel.controlLevel["timeMachine_mc"].removeEventListener(MouseEvent.CLICK,this.onClickOldMachineHandler);
         SystemEventManager.addEventListener("timeMachinePasswordCorrect",this.timeMachinePasswordCorrect);
         ModuleManager.openPanel("DavidMachineSecretPanel");
      }
      
      private function timeMachinePasswordCorrect(evt:Event) : void
      {
         SystemEventManager.removeEventListener("timeMachinePasswordCorrect",this.timeMachinePasswordCorrect);
         this._playMovie = PlayMovie.play("resource/intrswf/TimeMachineOldMachineBreak.swf",null,null,null,null,MapManageView.inst.mapLevel.topLevel,true,"正在加載動畫",false);
         this._playMovie.addEventListener(PlayMovie.MOVIE_PALY_OVER,this.oldMachineBreak);
         MapManageView.inst.mapLevel.depthLevel["npc_10016"].visible = false;
         MapManageView.inst.mapLevel.depthLevel["npc_10022"].visible = false;
         var peopleView:PeopleManageView = GV.MAN_PEOPLE;
         if(Boolean(peopleView))
         {
            peopleView.visible = false;
         }
      }
      
      private function oldMachineBreak(evt:Event) : void
      {
         MapManageView.inst.mapLevel.depthLevel["npc_10016"].visible = true;
         MapManageView.inst.mapLevel.depthLevel["npc_10022"].visible = true;
         var peopleView:PeopleManageView = GV.MAN_PEOPLE;
         if(Boolean(peopleView))
         {
            peopleView.visible = true;
         }
         if(Boolean(this._playMovie))
         {
            if(Boolean(this._playMovie.movie_mc))
            {
               this._playMovie.movie_mc.stop();
            }
            this._playMovie.removeEventListener(PlayMovie.MOVIE_PALY_OVER,this.oldMachineBreak);
            this._playMovie = null;
         }
         this._presented = new Presented();
         this._presented.exchange1243(2953,this.onSwapCloth);
      }
      
      private function onSwapCloth(itemList:Array) : void
      {
         var i:uint;
         var getOldMachineFlag:Boolean = false;
         for(i = 0; i < itemList.length; i++)
         {
            if((itemList[i] as Object).itemID == 15291)
            {
               getOldMachineFlag = true;
            }
         }
         if(getOldMachineFlag)
         {
            SystemEventManager.removeEventListener("clickOldMachine",this.getClickOldMachine);
            this.setStatus(2,8);
            Alert.smileAlart("\t恭喜獲得叢林仙子套裝。",function(evt:Event):void
            {
               ModuleManager.openPanel("NewTimeMachinePanel");
               setStatus8();
            });
         }
      }
      
      private function setStatus8() : void
      {
         if(MapManager.curMapID == 27)
         {
            MapManageView.inst.mapLevel.controlLevel["timeMachine_mc"].visible = false;
            this.addNPCDialog(2,35);
            SystemEventManager.addEventListener("getTreeSeedTimeMachine",this.getTreeSeedTimeMachine);
         }
      }
      
      private function getTreeSeedTimeMachine(evt:SystemEvent) : void
      {
         this._presented = new Presented();
         this._presented.exchange1243(2954,this.onSwapTreeSeed);
      }
      
      private function onSwapTreeSeed(itemList:Array) : void
      {
         var getOldMachineFlag:Boolean = false;
         for(var i:uint = 0; i < itemList.length; i++)
         {
            if((itemList[i] as Object).itemID == 1230136)
            {
               getOldMachineFlag = true;
            }
         }
         if(getOldMachineFlag)
         {
            SystemEventManager.removeEventListener("getTreeSeedTimeMachine",this.getTreeSeedTimeMachine);
            this.setStatus(2,9);
            Alert.smileAlart("\t獲得時光古樹種子*10，白色漿果種子*10，大衛鐵樺樹種子*20，快去種植吧。");
         }
      }
      
      private function checkTreeCount() : void
      {
         this._queryItemCnt = new QueryItemCntManager();
         this._queryItemCnt.addEventListener(QueryItemCntManager.SOMEGOODS_QUERY,this.checkTreeCountResponse);
         this._queryItemCnt.someGoosQuery([191108,191109,191110]);
      }
      
      private function checkTreeCountResponse(evt:EventTaomee) : void
      {
         this._queryItemCnt.removeEventListener(QueryItemCntManager.SOMEGOODS_QUERY,this.checkTreeCountResponse);
         var data:Array = evt.EventObj as Array;
         if(data[0] < 5 || data[1] < 5 || data[2] < 10)
         {
            NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(42));
         }
         else
         {
            NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(40));
         }
      }
      
      private function playMakeMachineMovie(evt:SystemEvent) : void
      {
         this._playMovie = PlayMovie.play("resource/intrswf/TimeMachineMakeNewMachine.swf",null,null,null,null,MapManageView.inst.mapLevel.topLevel,true,"正在加載動畫",false);
         this._playMovie.addEventListener(PlayMovie.MOVIE_PALY_OVER,this.makeNewMachineMovieComplete);
         MapManageView.inst.mapLevel.depthLevel["npc_10016"].visible = false;
         MapManageView.inst.mapLevel.depthLevel["npc_10022"].visible = false;
         var peopleView:PeopleManageView = GV.MAN_PEOPLE;
         if(Boolean(peopleView))
         {
            peopleView.visible = false;
         }
      }
      
      private function makeNewMachineMovieComplete(evt:Event) : void
      {
         MapManageView.inst.mapLevel.depthLevel["npc_10016"].visible = true;
         MapManageView.inst.mapLevel.depthLevel["npc_10022"].visible = true;
         var peopleView:PeopleManageView = GV.MAN_PEOPLE;
         if(Boolean(peopleView))
         {
            peopleView.visible = true;
         }
         if(Boolean(this._playMovie))
         {
            if(Boolean(this._playMovie.movie_mc))
            {
               this._playMovie.movie_mc.stop();
            }
            this._playMovie.removeEventListener(PlayMovie.MOVIE_PALY_OVER,this.makeNewMachineMovieComplete);
            this._playMovie = null;
         }
         NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(41));
      }
      
      private function openMakePanelTimeMachine(evt:SystemEvent) : void
      {
         SystemEventManager.addEventListener("makeMachineComplete",this.makeNewMachineComplete);
         ModuleManager.openPanel("TimeMachineGamePanel");
      }
      
      private function makeNewMachineComplete(evt:Event) : void
      {
         SystemEventManager.removeEventListener("makeMachineComplete",this.makeNewMachineComplete);
         this._presented = new Presented();
         this._presented.exchange1243(2955,this.onSwapCompleteReward);
      }
      
      private function onSwapCompleteReward(itemList:Array) : void
      {
         var getOldMachineFlag:Boolean = false;
         for(var i:uint = 0; i < itemList.length; i++)
         {
            if((itemList[i] as Object).itemID == 15287)
            {
               getOldMachineFlag = true;
            }
         }
         if(getOldMachineFlag)
         {
            SystemEventManager.removeEventListener("playMakeMachineMovie",this.playMakeMachineMovie);
            SystemEventManager.removeEventListener("openMakePanelTimeMachine",this.openMakePanelTimeMachine);
            this.setStatus(2,10);
            Alert.smileAlart("\t獲得時光守護者套裝。");
         }
      }
      
      private function checkActivityStatus() : void
      {
         BufferManager.addBufferEvent(BufferManager.TIME_MACHINE,this.getMachineBuffer);
         BufferManager.getBuffer(BufferManager.TIME_MACHINE);
      }
      
      private function getMachineBuffer(evt:EventTaomee) : void
      {
         BufferManager.removeBufferEvent(BufferManager.TIME_MACHINE,this.getMachineBuffer);
         this._status = uint(evt.EventObj);
         if(this._function != null)
         {
            this._function();
            this._function = null;
         }
      }
      
      private function openTimeMachineView() : void
      {
         if(this._status < 8)
         {
            ModuleManager.openPanel("OldTimeMachinePanel",this._status);
         }
         else
         {
            ModuleManager.openPanel("NewTimeMachinePanel",this._status);
         }
      }
      
      private function addNPCDialog(dialogId:uint, param:*, action:String = "s") : void
      {
         this._dialogInfo = MapManageView.inst.mapControl.getNpcDialogInfoForMachine(dialogId);
         if(Boolean(this._dialogInfo))
         {
            this._dialogInfo.optionList.unshift(this.getOption(action,param));
         }
      }
      
      private function getOption(action:String = "s", param:* = null) : NPCDialogOptionInfo
      {
         this._dialogOption = new NPCDialogOptionInfo("能回到過去的時光機",action,param);
         return this._dialogOption;
      }
      
      private function setStatus(dialogId:uint, status:int) : void
      {
         var optionList:Array = null;
         var optionInfo:NPCDialogOptionInfo = null;
         var i:uint = 0;
         this._status = status;
         BufferManager.setBuffer(BufferManager.TIME_MACHINE,this._status);
         this._dialogInfo = MapManageView.inst.mapControl.getNpcDialogInfoForMachine(dialogId);
         if(Boolean(this._dialogInfo))
         {
            optionList = this._dialogInfo.optionList;
            for(i = 0; i < optionList.length; i++)
            {
               optionInfo = optionList[i] as NPCDialogOptionInfo;
               if(optionInfo.option == "能回到過去的時光機")
               {
                  optionList.splice(i,1);
               }
            }
         }
      }
   }
}

