package com.mole.app.activity
{
   import com.common.Alert.Alert;
   import com.core.info.ServerUpTime;
   import com.event.EventTaomee;
   import com.module.activityModule.Presented;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.NPCDialogManager;
   import com.mole.app.manager.QueryItemCntManager;
   import com.mole.app.manager.SystemEventManager;
   import com.view.MapManageView.MapManageView;
   
   public class NPCTalkAct
   {
      
      private static var _inst:NPCTalkAct;
      
      private const DAYLIMIT:uint = 3;
      
      private const MAPIDARR:Array = [259,259,256,255,339,342,356,356];
      
      private const TYPE:Array = [3116,3117,3118,3119,3120,3121,3122,3123];
      
      private const DAYTYPE:Array = [2100000390,2100000391,2100000392,2100000393,2100000394,2100000395,2100000396,2100000397];
      
      private const SWAPTYPE:uint = 3124;
      
      private const ITEMID:uint = 1351715;
      
      private const TIPSTR:String = "感謝小摩爾的慰問，請去其他小夥伴那裡看看吧~";
      
      private var _query:QueryItemCntManager;
      
      private var _mapIndex:uint;
      
      private var day:uint;
      
      public function NPCTalkAct()
      {
         super();
      }
      
      public static function getInst() : NPCTalkAct
      {
         if(!_inst)
         {
            _inst = new NPCTalkAct();
         }
         return _inst;
      }
      
      public function setUp() : void
      {
         this.day = ServerUpTime.getInstance().date.date;
         if(this.day < this.DAYLIMIT)
         {
            return;
         }
         this._query = new QueryItemCntManager();
         SystemEventManager.addEventListener("npcTalk",this.npcTalkHandle);
         SystemEventManager.addEventListener("npcSwapPrize",this.npcSwapPrize);
         GV.onlineSocket.addEventListener("removeMapEvent",this.onChangeMap);
      }
      
      private function npcSwapPrize(e:SystemEvent) : void
      {
         var prizeID:uint = uint(e.data);
         this._mapIndex = prizeID - 1;
         this._query.addEventListener(QueryItemCntManager.DayTYPE_QUERY,this.dayTypeHandle);
         this._query.dayTypeQuery(this.DAYTYPE[this._mapIndex]);
      }
      
      private function dayTypeHandle(e:EventTaomee) : void
      {
         this._query.removeEventListener(QueryItemCntManager.DayTYPE_QUERY,this.dayTypeHandle);
         var times:uint = uint(e.EventObj);
         if(times == 0)
         {
            Presented.getInstance().celebrate1225(this.TYPE[this._mapIndex]);
         }
         else
         {
            Alert.angryAlart(this.TIPSTR);
         }
      }
      
      private function npcTalkHandle(e:SystemEvent) : void
      {
         var npcID:uint = uint(e.data);
         switch(npcID)
         {
            case 1:
               if(this.day < this.DAYLIMIT)
               {
                  NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(431));
               }
               else
               {
                  NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(432));
               }
               break;
            case 2:
               if(this.day < this.DAYLIMIT)
               {
                  NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(434));
               }
               else
               {
                  NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(435));
               }
               break;
            case 3:
               if(this.day < this.DAYLIMIT)
               {
                  NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(431));
               }
               else
               {
                  NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(432));
               }
               break;
            case 4:
               if(this.day < this.DAYLIMIT)
               {
                  NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(431));
               }
               else
               {
                  NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(432));
               }
               break;
            case 5:
               if(this.day < this.DAYLIMIT + 1)
               {
                  NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(431));
               }
               else
               {
                  NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(432));
               }
               break;
            case 6:
               if(this.day < this.DAYLIMIT + 1)
               {
                  NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(341));
               }
               else
               {
                  NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(342));
               }
               break;
            case 7:
               if(this.day < this.DAYLIMIT + 2)
               {
                  NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(341));
               }
               else
               {
                  NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(342));
               }
               break;
            case 8:
               if(this.day < this.DAYLIMIT + 2)
               {
                  NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(346));
               }
               else
               {
                  NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(344));
               }
         }
      }
      
      private function onChangeMap(e:*) : void
      {
         GV.onlineSocket.removeEventListener("removeMapEvent",this.onChangeMap);
         this.destroy();
      }
      
      public function destroy() : void
      {
         if(Boolean(this._query))
         {
            this._query.removeEventListener(QueryItemCntManager.DayTYPE_QUERY,this.dayTypeHandle);
            this._query = null;
         }
         SystemEventManager.removeEventListener("npcSwapPrize",this.npcSwapPrize);
         SystemEventManager.removeEventListener("npcTalk",this.npcTalkHandle);
         BC.removeEvent(this);
      }
   }
}

