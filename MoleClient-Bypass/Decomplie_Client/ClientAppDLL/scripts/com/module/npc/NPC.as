package com.module.npc
{
   import com.common.data.HashMap;
   import com.common.util.XMLToObject;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.global.staticData.XMLInfo;
   import com.module.npc.dialog.INPCDialog;
   import com.module.npc.npcInstance.MoleNPC;
   import com.module.npc.npcInstance.petNPC;
   import com.module.npc.task.TaskEvent;
   import com.mole.app.task.TaskManager;
   import com.view.MapManageView.MapButtonView;
   import com.view.MapManageView.TailButtonView;
   
   public class NPC
   {
      
      private static var _npcInfoHash:HashMap;
      
      private static var _npcHash:HashMap;
      
      public function NPC()
      {
         super();
      }
      
      public static function init() : void
      {
         var i:int;
         var info:NPCInfo = null;
         _npcInfoHash = new HashMap();
         _npcHash = new HashMap();
         var obj:Object = XMLToObject.convert(XMLInfo.NPCTalkXML);
         var a:Array = obj.npclist.npc is Array ? obj.npclist.npc : [obj.npclist.npc];
         var len:int = int(a.length);
         for(i = 0; i < len; i++)
         {
            info = new NPCInfo(a[i]);
            _npcInfoHash.add(info.id,info);
            _npcInfoHash.add(info.en_name,info);
         }
         NPCEvent.addEventListener(NPCEvent.ON_NPC_ENTER,function(E:NPCEvent):void
         {
            _npcHash.add(E.npc.npcInfo.id,E.npc);
         });
         NPCEvent.addEventListener(NPCEvent.ON_NPC_LEAVE,function(E:NPCEvent):void
         {
            _npcHash.remove(E.npc.npcInfo.id);
         });
      }
      
      public static function getNPCInfo(npcID:uint) : NPCInfo
      {
         return _npcInfoHash.getValue(npcID);
      }
      
      public static function getNPCInfoByName(name:String) : NPCInfo
      {
         return _npcInfoHash.getValue(name);
      }
      
      private static function upDataNPCInfo(E:TaskEvent) : void
      {
      }
      
      private static function upDataTaskInfoAttitudeObj(E:EventTaomee) : void
      {
      }
      
      public static function addNPCInMap() : void
      {
         var key:* = undefined;
         var npcinfo:NPCInfo = null;
         if(TaskManager.getTaskState(300) == 1)
         {
            return;
         }
         var keys:Array = _npcInfoHash.keys;
         for each(key in keys)
         {
            if(Boolean(int(key)))
            {
               npcinfo = getNPCInfo(key);
               if(npcinfo.mapID == LocalUserInfo.getMapID())
               {
                  getNPCInstance(npcinfo.id,true);
               }
            }
         }
      }
      
      public static function addDialog(id:uint) : INPCDialog
      {
         return null;
      }
      
      public static function getNPCTailButton(npcinfo:NPCInfo) : TailButtonView
      {
         if(Boolean(npcinfo))
         {
            return MapButtonView.getTarget().getChildByName(npcinfo.en_name) as TailButtonView;
         }
         return null;
      }
      
      public static function getInMapNPCInfoList() : Array
      {
         var i:* = undefined;
         var npcinfo:NPCInfo = null;
         var npcList:Array = new Array();
         var keys:Array = _npcInfoHash.keys;
         for each(i in keys)
         {
            npcinfo = getNPCInfo(i);
            if(npcinfo.mapID == LocalUserInfo.getMapID())
            {
               npcList.push(npcinfo);
            }
         }
         return npcList;
      }
      
      public static function getNPCInstance(npcID:uint, bool:Boolean = false) : *
      {
         var npcinfo:NPCInfo = null;
         var npc:* = _npcHash.getValue(npcID);
         if(!npc)
         {
            npcinfo = getNPCInfo(npcID);
            if(!npcinfo)
            {
               return npc;
            }
            if(bool || npcinfo.mapID == LocalUserInfo.getMapID())
            {
               if(npcID == 999 || npcID == 998 || npcID == 997 || npcID == 996 || npcID == 1015)
               {
                  npc = petNPC.showNPCInstance(npcID);
               }
               else
               {
                  npc = MoleNPC.showNPCInstance(npcID);
               }
            }
         }
         return npc;
      }
   }
}

