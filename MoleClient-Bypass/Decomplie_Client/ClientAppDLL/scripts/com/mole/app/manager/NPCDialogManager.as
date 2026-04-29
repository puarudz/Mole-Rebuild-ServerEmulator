package com.mole.app.manager
{
   import com.common.data.HashMap;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import com.logic.mapEvent.MapEvent;
   import com.mole.app.info.MoleActionInfo;
   import com.mole.app.info.NPCDialogInfo;
   import com.mole.app.info.NPCDialogOptionInfo;
   import com.mole.app.interfaces.INPCDialog;
   import com.mole.app.type.ActionType;
   import com.view.toolView.toolView;
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class NPCDialogManager
   {
      
      private static var _faceMap:HashMap;
      
      private static var _dialog:INPCDialog;
      
      private static var NPCDialogClass:Class;
      
      private static var _isShowTool:Boolean = true;
      
      public function NPCDialogManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         GV.onlineSocket.addEventListener(MapEvent.READY_CHANGE_MAP,onDestroyDialog);
         _faceMap = new HashMap();
         _faceMap.add("正常",1);
         _faceMap.add("開心",2);
         _faceMap.add("焦急",3);
         _faceMap.add("悲傷",4);
         _faceMap.add("憤怒",5);
         _faceMap.add("傷心",6);
         _faceMap.add("生氣",7);
         _faceMap.add("無聊",8);
         _faceMap.add("靈感",9);
         _faceMap.add("失望",10);
         _faceMap.add("疑惑",11);
         _faceMap.add("驚訝",12);
         _faceMap.add("感動",13);
      }
      
      private static function onDestroyDialog(e:Event) : void
      {
         destroyDialog();
      }
      
      public static function getFaceID(face:String) : int
      {
         return _faceMap.getValue(face);
      }
      
      public static function destroyDialog(showTool:Boolean = true) : void
      {
         if(Boolean(_dialog))
         {
            _dialog.removeEventListener(Event.CLOSE,onClose);
            _dialog.destroy();
            GV.onlineSocket.dispatchEvent(new Event("dialogClosed"));
            _dialog = null;
         }
         if(showTool)
         {
            toolView.getInstance().show();
         }
      }
      
      public static function say(info:NPCDialogInfo) : void
      {
         var resID:uint = 0;
         if(Boolean(NPCDialogClass))
         {
            say1(info);
         }
         else
         {
            resID = DownLoadManager.add(ModuleManager.PANEL_PATH + "NPCDialogPanel.swf",ResType.DISPLAY_OBJECT,true);
            DownLoadManager.addEvent(resID,function(e:DownLoadEvent):void
            {
               NPCDialogClass = e.loader.contentLoaderInfo.applicationDomain.getDefinition("com.mole.panel.fragmentary.NPCDialog") as Class;
               say1(info);
            });
         }
      }
      
      private static function say1(info:NPCDialogInfo) : void
      {
         if(Boolean(_dialog))
         {
            if(_dialog.npcID == info.id)
            {
               toolView.getInstance().hide();
               _dialog.say(info);
               return;
            }
            destroyDialog(false);
         }
         toolView.getInstance().hide();
         _dialog = new NPCDialogClass();
         _dialog.addEventListener(Event.CLOSE,onClose);
         _dialog.say(info);
         LevelManager.dialogLevel.addChild(_dialog as DisplayObject);
      }
      
      private static function onClose(e:EventTaomee) : void
      {
         destroyDialog();
      }
      
      public static function customSay(id:uint, msg:String, option:String, face:String = null) : void
      {
         if(face == null)
         {
            face = "正常";
         }
         var optionInfo:NPCDialogOptionInfo = new NPCDialogOptionInfo(option,ActionType.NONE);
         var info:NPCDialogInfo = new NPCDialogInfo(id,face,msg,[optionInfo]);
         NPCDialogManager.say(info);
      }
      
      public static function execute(actionInfo:MoleActionInfo, isShowTool:Boolean = false) : void
      {
         _isShowTool = isShowTool;
         if(actionInfo.cmd != ActionType.RND_SAY && actionInfo.cmd != ActionType.SAY && actionInfo.cmd != ActionType.SYSTEM_SAY_ACT && actionInfo.cmd != ActionType.MAP_SAY && actionInfo.cmd != ActionType.TASK_FUNCTION || actionInfo.cmd == ActionType.TASK_FUNCTION && isShowTool)
         {
            destroyDialog(true);
         }
         if(actionInfo.cmd != ActionType.NONE)
         {
            MoleActionManager.doAction(actionInfo);
         }
      }
   }
}

