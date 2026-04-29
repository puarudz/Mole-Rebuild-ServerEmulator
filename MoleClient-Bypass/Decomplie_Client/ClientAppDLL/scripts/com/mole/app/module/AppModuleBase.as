package com.mole.app.module
{
   import com.common.Alert.Alert;
   import com.common.util.DisplayUtil;
   import com.global.staticData.ModuleNameManager;
   import com.module.activityModule.superPetLogin;
   import com.module.coin.CoinBuyNewModle;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.SimpleIntrPanelManager;
   import com.mole.app.manager.StatisticsManager;
   import com.mole.app.manager.SystemTimeController;
   import com.mole.app.manager.moduleTime.BaseModuleTimeCnt;
   import com.mole.app.manager.moduleTime.ModuleTimeInfo;
   import com.mole.app.map.MapManager;
   import com.mole.app.task.Task;
   import com.mole.app.task.TaskManager;
   import com.mole.app.task.type.TaskStateType;
   import com.mole.app.type.ModuleType;
   import com.view.mapView.activity.Task83.Anniversary;
   import com.view.mapView.activity.Task83.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import org.taomee.net.tmf.TmfByteArray;
   import org.taomee.utils.DepthUtil;
   
   public class AppModuleBase extends Sprite implements IAppModule
   {
      
      protected var _initData:Object;
      
      protected var _resultData:Object;
      
      private var _gameID:uint;
      
      private var _moduleTimeCnt:BaseModuleTimeCnt;
      
      protected var _moduleName:String;
      
      public function AppModuleBase(gameID:uint = 0)
      {
         super();
         this._gameID = gameID;
         BC.addEvent(this,this,MouseEvent.CLICK,this.onClickHandle);
      }
      
      private function onClickHandle(e:Event) : void
      {
         var targetName:String = e.target.name;
         this.checkTarName(targetName);
      }
      
      protected function checkTarName(targetName:String) : void
      {
         var mapID:uint = 0;
         var taskID:uint = 0;
         var task:Task = null;
         var spoName:String = null;
         var modulename:String = null;
         var buyInfoArr:Array = null;
         var year:Array = null;
         if(targetName.indexOf(ModuleNameManager.OPENMODULE) != -1)
         {
            this._moduleName = targetName.slice(11);
            this.moduleNameCheck(this._moduleName,1);
         }
         else if(targetName.indexOf(ModuleNameManager.GOTO) != -1)
         {
            if(mapID < 800)
            {
               mapID = uint(targetName.slice(5));
               if(mapID == MapManager.curMapID)
               {
                  Alert.angryAlart("  小摩爾已經在這個場景中了!");
               }
               else
               {
                  MapManager.enterMap(mapID);
               }
            }
            StatisticsManager.whenGoMap(mapID);
            this.close();
         }
         else if(targetName.indexOf(ModuleNameManager.TASK) != -1)
         {
            this.close();
            taskID = uint(targetName.slice(5));
            StatisticsManager.whenTask(taskID);
            task = TaskManager.getTask(taskID);
            if(task.state == TaskStateType.FINISH)
            {
               ModuleManager.openPanel(ModuleType.TASK_FILES_PANEL,taskID);
            }
            else
            {
               TaskManager.runTask(taskID);
            }
         }
         else
         {
            if(targetName.indexOf(ModuleNameManager.APPLYLAMU) != -1)
            {
               superPetLogin.gotoPay();
               return;
            }
            if(targetName.indexOf(ModuleNameManager.SPO) != -1)
            {
               spoName = targetName.slice(4);
               this._moduleName = spoName;
               this.moduleNameCheck(this._moduleName,2);
            }
            else if(targetName.indexOf(ModuleNameManager.CLEARMAP) != -1)
            {
               modulename = targetName.slice(9);
               StatisticsManager.whenOpenModule(modulename);
               MapManager.clearMap();
               ModuleManager.openPanel(modulename);
            }
            else if(targetName.indexOf(ModuleNameManager.SHOP_BUY) != -1)
            {
               buyInfoArr = targetName.substring(8,targetName.length).split("_");
               if(buyInfoArr.length == 1)
               {
                  buyInfoArr[1] = 1;
               }
               new CoinBuyNewModle().BuyModle(buyInfoArr[0],buyInfoArr[1]);
            }
            else if(targetName.indexOf(ModuleNameManager.OPENMOLESHOP) != -1)
            {
               Anniversary.getInstance().openMoleShop();
            }
            else if(targetName.indexOf(ModuleNameManager.OPENJIAOYIN) != -1)
            {
               this.close();
               year = targetName.split("_");
               ModuleManager.openPanel("FootPrintNewPanel",year[1]);
            }
            else if(targetName.indexOf(ModuleNameManager.URLMIBI) != -1)
            {
               this.close();
               navigateToURL(new URLRequest("http://game.61.com/web/christmas.shtml?tad=innermedia.mole.free.homepage_tmbanner"),"_blank");
            }
         }
      }
      
      protected function moduleNameCheck(moduleName:String, moduleIndex:uint = 1) : void
      {
         var moduletimeInfo:ModuleTimeInfo = null;
         this._moduleTimeCnt = new BaseModuleTimeCnt();
         if(this._moduleTimeCnt.hasModueName(this._moduleName))
         {
            moduletimeInfo = this._moduleTimeCnt.getModuleInfo(this._moduleName);
            if(moduletimeInfo.canOpen == 1)
            {
               Alert.angryAlart("  活動已經結束了哦！");
            }
            else if(moduletimeInfo.canOpen == 0)
            {
               this.openModuleKey(moduleName,moduleIndex);
            }
            else if(moduletimeInfo.canOpen == 2)
            {
               if(SystemTimeController.instance.checkSysTimeAchieve(moduletimeInfo.systimeID))
               {
                  this.openModuleKey(moduleName,moduleIndex);
               }
               else
               {
                  Alert.angryAlart(SystemTimeController.instance.getActivityOutTimeMsg(moduletimeInfo.systimeID));
               }
            }
            else
            {
               Alert.angryAlart("  功能還沒開發好，現在隻支持配置0和1的，謝謝！");
            }
         }
         else
         {
            this.openModuleKey(moduleName,moduleIndex);
         }
         StatisticsManager.whenOpenModule(this._moduleName);
         this.close();
      }
      
      private function openModuleKey(moduleName:String, moduleIndex:uint = 1) : void
      {
         if(moduleIndex == 1)
         {
            ModuleManager.openPanel(this._moduleName);
         }
         else if(moduleIndex == 2)
         {
            SimpleIntrPanelManager.show(moduleName);
         }
      }
      
      public function init(data:Object = null) : void
      {
         this._initData = data;
         DepthUtil.bringToTop(this);
         if(this.isStopMapSound)
         {
            SoundManager.stopAll(false);
         }
      }
      
      protected function get isStopMapSound() : Boolean
      {
         if(Boolean(this._initData))
         {
            if(this._initData is TmfByteArray)
            {
               return false;
            }
            if(this._initData.hasOwnProperty("isStopMapSound"))
            {
               return this._initData["isStopMapSound"];
            }
         }
         return false;
      }
      
      public function close() : void
      {
         dispatchEvent(new ModuleEvent(ModuleEvent.DESTROY,null,this._resultData));
      }
      
      public function destroy() : void
      {
         if(this.isStopMapSound)
         {
            SoundManager.openAll();
         }
         BC.removeEvent(this);
         DisplayUtil.removeForParent(this);
      }
      
      public function get inst() : AppModuleBase
      {
         return this;
      }
      
      public function get resultData() : Object
      {
         return this._resultData;
      }
      
      public function get gameID() : uint
      {
         return this._gameID;
      }
   }
}

