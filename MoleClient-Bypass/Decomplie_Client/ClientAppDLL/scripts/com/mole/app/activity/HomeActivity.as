package com.mole.app.activity
{
   import com.common.Alert.Alert;
   import com.common.util.DisplayUtil;
   import com.core.MainManager;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.info.LocalUserInfo;
   import com.global.staticData.MapsConfig;
   import com.logic.mapEvent.MapEvent;
   import com.logic.socket.home.HomeCarSocket;
   import com.mole.app.info.NPCDialogInfo;
   import com.mole.app.info.NPCDialogOptionInfo;
   import com.mole.app.manager.NPCDialogManager;
   import com.mole.app.manager.NPCInfoManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.type.ActionType;
   import com.mole.app.utils.Tool;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class HomeActivity
   {
      
      private static var _inst:HomeActivity;
      
      public var isInTask:Boolean = false;
      
      public var targetNpcID:uint;
      
      private var index:int;
      
      public var targetMapID:uint;
      
      public var targetNpcArr:Array = [10164,10165,10166,10167,10168,10169,10170,10171];
      
      public var targetNpcNameArr:Array = ["lillian","rachel","tiny","yourick","eson","mana","willm","hans"];
      
      public var relateNpcArr:Array = [10042,10020,10050,10021,10029,10019,10039,10063];
      
      public var relateMapArr:Array = [17,18,79,45,62,44,75,143];
      
      public var targetMapArr:Array = [142,9,8,6,61,37,3,4];
      
      public var mapPtArr:Array = [new Point(450,260),new Point(200,470),new Point(480,390),new Point(430,260),new Point(400,490),new Point(260,160),new Point(380,480),new Point(260,460)];
      
      public function HomeActivity()
      {
         super();
      }
      
      public static function get inst() : HomeActivity
      {
         if(_inst == null)
         {
            _inst = new HomeActivity();
         }
         return _inst;
      }
      
      public static function npcSay(npcID:uint, msg:String, option:String, type:String = "none", param:* = null) : void
      {
         var npcOptionInfo:NPCDialogOptionInfo = null;
         var sayList:Array = [];
         npcOptionInfo = new NPCDialogOptionInfo(option,type,param);
         sayList.push(npcOptionInfo);
         var info:NPCDialogInfo = new NPCDialogInfo(npcID,"正常",msg,sayList);
         NPCDialogManager.say(info);
      }
      
      public function startTask() : void
      {
         this.isInTask = true;
         this.targetNpcID = this.targetNpcArr[int(Math.random() * 8)];
         this.targetMapID = this.targetMapArr[int(Math.random() * 8)];
         this.index = this.targetNpcArr.indexOf(this.targetNpcID);
         HomeCarSocket.RentACar();
         BC.addEvent(this,GV.onlineSocket,MapEvent.CHANGE_MAP_COMPLETE,this.changeMapOver);
         GF.showWordBoxMSG("愛心宅急送,尋找" + NPCInfoManager.getNPCInfo(this.targetNpcID).name + ",他在" + MapsConfig.MapsInfo[this.targetMapID].note + "喲!");
      }
      
      public function addYaliEvent() : void
      {
         var yali:MovieClip = null;
         if(LocalUserInfo.getMapID() == 66)
         {
            yali = GV.MC_mapFrame["top_mc"].npc_10009;
            yali.buttonMode = true;
            BC.addEvent(this,yali,MouseEvent.CLICK,this.clickYali);
         }
      }
      
      private function clickYali(e:MouseEvent) : void
      {
         if(!this.isInTask)
         {
            npcSay(10009,HomeConstant.MSG0,HomeConstant.OPT0,ActionType.OPEN_PANEL,"HomePanel");
         }
         else
         {
            npcSay(10009,HomeConstant.MSG3 + NPCInfoManager.getNPCInfo(this.targetNpcID).name + HomeConstant.MSG4,HomeConstant.OPT2);
         }
      }
      
      private function changeMapOver(e:*) : void
      {
         var resID:uint = 0;
         var i:int = 0;
         GF.showWordBoxMSG("愛心宅急送,尋找" + NPCInfoManager.getNPCInfo(this.targetNpcID).name + ",他在" + MapsConfig.MapsInfo[this.targetMapID].note + "喲!");
         var mapid:int = LocalUserInfo.getMapID();
         if(mapid == this.targetMapID)
         {
            resID = DownLoadManager.add(HomeConstant.NPC_PATH + this.targetNpcNameArr[this.index] + ".swf",ResType.DISPLAY_OBJECT);
            DownLoadManager.addEvent(resID,this.onLoadTargetNpcOver);
         }
         else
         {
            for(i = 0; i < 8; i++)
            {
               if(mapid == this.relateMapArr[i])
               {
                  if(i == this.index)
                  {
                     npcSay(this.relateNpcArr[i],HomeConstant.MSG6 + NPCInfoManager.getNPCInfo(this.targetNpcID).name + HomeConstant.MSG7 + MapsConfig.MapsInfo[this.targetMapID].note,HomeConstant.OPT3);
                  }
                  else
                  {
                     npcSay(this.relateNpcArr[i],NPCInfoManager.getNPCInfo(this.targetNpcID).name + HomeConstant.MSG5,HomeConstant.OPT3);
                  }
                  break;
               }
            }
         }
      }
      
      private function onLoadTargetNpcOver(e:DownLoadEvent) : void
      {
         var npc:MovieClip = (e.data as MovieClip).getChildAt(0) as MovieClip;
         MainManager.getAppLevel().addChild(npc);
         var mapIndex:int = this.targetMapArr.indexOf(this.targetMapID);
         npc.x = this.mapPtArr[mapIndex].x;
         npc.y = this.mapPtArr[mapIndex].y;
         npc.buttonMode = true;
         BC.addEvent(this,npc,MouseEvent.CLICK,this.onClickTargetNpc);
      }
      
      private function onClickTargetNpc(e:MouseEvent) : void
      {
         DisplayUtil.removeForParent(e.currentTarget as DisplayObject);
         SystemEventManager.addEventListener("homeActivityOverEvent",this.overTask);
         npcSay(this.targetNpcID,HomeConstant["MSG" + (9 + this.index)],HomeConstant.OPT4,ActionType.SYSTEM_ACT,"homeActivityOverEvent");
      }
      
      private function overTask(e:*) : void
      {
         SystemEventManager.removeEventListener("homeActivityOverEvent",this.overTask);
         Tool.exchangeGoods(2101);
         Alert.smileAlart("      愛心宅急送完成！獲得30個愛心花瓣！");
         this.isInTask = false;
         BC.removeEvent(this,GV.onlineSocket,MapEvent.CHANGE_MAP_COMPLETE,this.changeMapOver);
         HomeCarSocket.DOWNCar();
      }
   }
}

