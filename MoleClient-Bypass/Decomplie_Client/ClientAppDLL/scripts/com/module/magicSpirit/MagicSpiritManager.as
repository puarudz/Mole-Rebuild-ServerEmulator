package com.module.magicSpirit
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.socket.GetLimitStatus;
   import com.module.magicSpirit.bag.BagMagicSpiritManager;
   import com.mole.app.info.NPCDialogInfo;
   import com.mole.app.info.NPCDialogOptionInfo;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.NPCDialogManager;
   import com.mole.app.map.MapManager;
   import com.mole.app.module.AppModuleControl;
   import com.mole.app.module.ModuleEvent;
   import com.mole.app.type.ActionType;
   import com.mole.app.type.ModuleType;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class MagicSpiritManager extends EventDispatcher
   {
      
      private static var _inst:MagicSpiritManager;
      
      public var selectType:uint;
      
      public var levelPage:uint;
      
      public var isFight:Boolean;
      
      private var _levelId:uint;
      
      private var _subLevel:uint;
      
      private var _isWin:Boolean;
      
      private var _current_task:uint;
      
      private var _propStatusArr:Array;
      
      private var _itemName:Array = ["豆沙月餅","鮮肉月餅","桂花月餅","抹茶月餅","五仁月餅"];
      
      private var _itemNum:Array = [0,0,0,0,0];
      
      private var _tempName:Array = [];
      
      private var _tempNum:Array = [];
      
      public var isCloseFightSound:Boolean;
      
      public var pvpType:uint = 0;
      
      public function MagicSpiritManager()
      {
         super();
         GV.onlineSocket.addEventListener("MagciSpirite_gameEnd",this.addevent);
         GV.onlineSocket.addEventListener("MagicSpirite_figth",this.beginFight);
         GV.onlineSocket.addEventListener("MagicSpirite_figth_1023",this.beginFight);
         GV.onlineSocket.addEventListener("MagicSpirite_fight_4009",this.beginFight);
         GV.onlineSocket.addEventListener("MagicSpirite_fight_4010",this.beginFight);
         GV.onlineSocket.addEventListener("MagicSpirite_fightEggs",this.beginFight);
         GV.onlineSocket.addEventListener("MagicSpirite_fight_4011",this.beginFight);
         GV.onlineSocket.addCmdListener(CommandID.MOLE_INVITATION_SERVER_PUSH,this.molingInvitationHandle);
         this._propStatusArr = new Array();
         GV.onlineSocket.addEventListener("MagciSpirite_PVPEnd",this.pvpBattleEnd);
      }
      
      public static function getInstance() : MagicSpiritManager
      {
         if(_inst == null)
         {
            _inst = new MagicSpiritManager();
         }
         return _inst;
      }
      
      public function beginGameByLeveId(id:uint) : void
      {
         var recdata:ByteArray = null;
         if(BagMagicSpiritManager.getInstance().isBagFull)
         {
            Alert.smileAlart("       摩靈背包滿了，先去清理摩靈背包！");
            return;
         }
         if(BagMagicSpiritManager.getInstance().getUserInfo.nowTeamInfo == null)
         {
            Alert.smileAlart("       快去摩靈背包裡設置你的出戰摩靈陣容吧！");
            return;
         }
         if(BagMagicSpiritManager.getInstance().getUserInfo.nowTeamInfo[0] > 0)
         {
            GV.onlineSocket.addCmdListener(CommandID.MAGICSPRITE_BTL_READY_NOTI,this.battleReadyNotiHandler);
            recdata = new ByteArray();
            recdata.writeShort(id);
            recdata.writeShort(1);
            GF.sendSocket(CommandID.MAGICSPRITE_CREATE_BTL,recdata);
         }
         else
         {
            Alert.angryAlart("你還沒有設置隊長，快去背包裡面設置吧！");
         }
      }
      
      private function pvpBattleEnd(e:EventTaomee) : void
      {
         if(this.pvpType == 3)
         {
            if(Boolean(e.EventObj))
            {
               if(Boolean(e.EventObj.isWin))
               {
                  GV.onlineSocket.addEventListener("SocketEvent_Data" + CommandID.cli_proto_get_limit_info,this.getInfoHadle);
                  GetLimitStatus.send([10034]);
               }
            }
         }
         else
         {
            ModuleManager.openPanel("MagicSpiriteArenaPanel");
         }
         this.pvpType = 0;
      }
      
      private function getInfoHadle(e:*) : void
      {
         GV.onlineSocket.removeEventListener("SocketEvent_Data" + CommandID.cli_proto_get_limit_info,this.getInfoHadle);
         var arr:Array = e.bodyInfo.getInfo as Array;
         if(arr[0] < 10)
         {
            ModuleManager.openPanel("GiftLotteryPanel");
         }
         else
         {
            Alert.smileAlart("恭喜小摩爾戰勝了對手！但是獎勵一天只能抽取十次哦~請繼續加油登上排行榜最高峰吧！");
         }
      }
      
      private function molingInvitationHandle(e:SocketEvent) : void
      {
         var msg:String = null;
         var type:int = 0;
         var score:int = 0;
         var molingName:String = null;
         var pname:String = null;
         var itemid:int = 0;
         var bytearr:ByteArray = e.data as ByteArray;
         if(bytearr != null)
         {
            msg = "";
            type = int(bytearr.readUnsignedInt());
            molingName = "";
            pname = "";
            switch(type)
            {
               case 0:
                  pname = bytearr.readUTFBytes(16);
                  molingName = GoodsInfo.getItemNameByID(bytearr.readUnsignedInt());
                  msg = "恭喜你獲得了" + pname + "分享給你的" + molingName + "摩靈。和他一起徵戰摩靈世界吧。";
                  break;
               case 1:
                  molingName = GoodsInfo.getItemNameByID(bytearr.readUnsignedInt());
                  itemid = int(bytearr.readUnsignedInt());
                  score = int(bytearr.readUnsignedInt());
                  msg = "恭喜你成功分享了自己的" + molingName + "摩靈，獲得了" + score + "積分！";
                  break;
               case 2:
                  itemid = int(bytearr.readUnsignedInt());
                  score = int(bytearr.readUnsignedInt());
                  msg = "你邀請的小夥伴完成了新手七日禮，你獲得了" + score + "積分！" + "快去兌換獎品吧。";
                  break;
               case 3:
                  itemid = int(bytearr.readUnsignedInt());
                  score = int(bytearr.readUnsignedInt());
                  msg = "你邀請的小夥伴已經在摩靈傳說中達到20級，你獲得了" + score + "積分！" + "快去兌換獎品吧。";
            }
            Alert.smileAlart(msg);
         }
      }
      
      public function get propStatusArr() : Array
      {
         return this._propStatusArr;
      }
      
      public function queryPropStatus() : void
      {
         GV.onlineSocket.addCmdListener(CommandID.cli_proto_get_limit_info,this.onRewaredLastHandle);
         GF.sendSocket(CommandID.cli_proto_get_limit_info,4,45,46,47,48);
      }
      
      private function onRewaredLastHandle(e:*) : void
      {
         var flag:uint = 0;
         GV.onlineSocket.removeCmdListener(CommandID.cli_proto_get_limit_info,this.onRewaredLastHandle);
         var bytearr:ByteArray = e.data as ByteArray;
         this._propStatusArr.length = 0;
         if(bytearr == null)
         {
            return;
         }
         var count:uint = bytearr.readUnsignedInt();
         for(var i:uint = 0; i < count; i++)
         {
            flag = bytearr.readUnsignedInt();
            this._propStatusArr.push(flag);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("MagicSpiriteShopPropStatus",this._propStatusArr));
      }
      
      private function beginFight(e:EventTaomee) : void
      {
         var recdata:ByteArray = null;
         var level:uint = 0;
         if(BagMagicSpiritManager.getInstance().getUserInfo.nowTeamInfo == null)
         {
            Alert.smileAlart("       快去摩靈背包裡設置你的出戰摩靈陣容吧！");
            return;
         }
         if(BagMagicSpiritManager.getInstance().getUserInfo.nowTeamInfo[0] > 0)
         {
            GV.onlineSocket.addCmdListener(CommandID.MAGICSPRITE_BTL_READY_NOTI,this.battleReadyNotiHandler);
            recdata = new ByteArray();
            if(e.type == "MagicSpirite_figth")
            {
               recdata.writeShort(4001);
            }
            if(e.type == "MagicSpirite_figth_1023")
            {
               recdata.writeShort(4002);
            }
            if(e.type == "MagicSpirite_fightEggs")
            {
               level = uint(e.EventObj.level);
               recdata.writeShort(level);
            }
            if(e.type == "MagicSpirite_fight_4009")
            {
               recdata.writeShort(4009);
            }
            if(e.type == "MagicSpirite_fight_4010")
            {
               recdata.writeShort(4010);
            }
            if(e.type == "MagicSpirite_fight_4011")
            {
               recdata.writeShort(4011);
            }
            recdata.writeShort(1);
            GF.sendSocket(CommandID.MAGICSPRITE_CREATE_BTL,recdata);
         }
         else
         {
            Alert.angryAlart("你還沒有設置隊長，快去背包裡面設置吧！",function():void
            {
            });
         }
      }
      
      private function battleReadyNotiHandler(event:SocketEvent) : void
      {
         var appControl:AppModuleControl = null;
         GV.onlineSocket.removeCmdListener(CommandID.MAGICSPRITE_BTL_READY_NOTI,this.battleReadyNotiHandler);
         var recData:ByteArray = event.data as ByteArray;
         if(recData.length > 0)
         {
            MapManager.clearMap();
            appControl = ModuleManager.openPanel(ModuleType.MolingBattleMainPanel,recData);
            appControl.addEventListener(ModuleEvent.LOAD_PRECOMPLETE,this.battleModuleLoaded);
         }
      }
      
      private function battleModuleLoaded(event:ModuleEvent) : void
      {
         var appControl:AppModuleControl = event.target as AppModuleControl;
         appControl.removeEventListener(ModuleEvent.LOAD_PRECOMPLETE,this.battleModuleLoaded);
      }
      
      private function getCurrentTask(evt:SocketEvent) : void
      {
         var resData:ByteArray;
         var count:uint;
         GV.onlineSocket.removeCmdListener(11009,this.getCurrentTask);
         resData = evt.data as ByteArray;
         count = resData.readUnsignedInt();
         this._current_task = resData.readUnsignedInt();
         if(this._levelId == 3003 && this._current_task == 3 || this._levelId == 3004 && this._current_task == 4 || this._levelId == 3005 && this._current_task == 5)
         {
            GF.sendSocket(11053,2,0);
            Alert.smileAlart("恭喜小摩爾通過探索火神盃的秘密，驚喜的發現了5枚火神徽章",function():void
            {
               ModuleManager.openPanel("FireCupSecretePanel");
            });
         }
      }
      
      public function addevent(e:EventTaomee) : void
      {
         var npcOptionInfo:NPCDialogOptionInfo = null;
         var npcDialogInfo:NPCDialogInfo = null;
         var sayList:Array = null;
         this._levelId = e.EventObj.levelId;
         this._subLevel = e.EventObj.subLevelId;
         this._isWin = e.EventObj.isWin;
         if(this._subLevel == 1 && this._isWin)
         {
            if(this._levelId == 3003 || this._levelId == 3004 || this._levelId == 3005)
            {
               GV.onlineSocket.addCmdListener(11009,this.getCurrentTask);
               GF.sendSocket(11009,1,10011);
            }
         }
         if(e.EventObj.levelId == 1009 && e.EventObj.subLevelId == 2)
         {
            GF.sendSocket(CommandID.cli_proto_recoder_older_entrust_times,506,1);
         }
         sayList = [];
         if(e.EventObj.levelId == 4001)
         {
            if(Boolean(e.EventObj.isWin))
            {
               npcOptionInfo = new NPCDialogOptionInfo("哇，我贏了耶",ActionType.FUNCTION,function():void
               {
                  npcOptionInfo = new NPCDialogOptionInfo("哦！！！",ActionType.FUNCTION,sendEventOver);
                  sayList[0] = npcOptionInfo;
                  npcDialogInfo = new NPCDialogInfo(10287,"開心","如果你知道這個石頭疙瘩的再生能力有多強，強過金剛狼，你就不會那麼開心了，快走吧！",sayList);
                  NPCDialogManager.say(npcDialogInfo);
               });
               sayList.push(npcOptionInfo);
               npcDialogInfo = new NPCDialogInfo(10287,"開心","表現不錯喲，那麼我們還是速度溜走吧！。",sayList);
               NPCDialogManager.say(npcDialogInfo);
            }
            else
            {
               npcOptionInfo = new NPCDialogOptionInfo("啊？",ActionType.FUNCTION,function():void
               {
                  npcOptionInfo = new NPCDialogOptionInfo("是！女王大人",ActionType.FUNCTION,sendEventOver);
                  sayList[0] = npcOptionInfo;
                  npcDialogInfo = new NPCDialogInfo(10287,"失望","別啊了，速度速度！",sayList);
                  NPCDialogManager.say(npcDialogInfo);
               });
               sayList.push(npcOptionInfo);
               npcDialogInfo = new NPCDialogInfo(10287,"失望","厄，輸了啊，快逃~~~~~~",sayList);
               NPCDialogManager.say(npcDialogInfo);
            }
         }
         if(e.EventObj.levelId == 4002)
         {
            if(!e.EventObj.isWin)
            {
               npcOptionInfo = new NPCDialogOptionInfo("老師~",ActionType.FUNCTION,function():void
               {
                  npcOptionInfo = new NPCDialogOptionInfo("哦~",ActionType.FUNCTION,sendTask1023Over);
                  sayList[0] = npcOptionInfo;
                  npcDialogInfo = new NPCDialogInfo(10287,"正常","走，我們離開吧！我來擋住！",sayList);
                  NPCDialogManager.say(npcDialogInfo);
               });
               sayList.push(npcOptionInfo);
               npcDialogInfo = new NPCDialogInfo(10287,"正常","勝還是敗都不重要，敗也可以反勝，失敗中能看到他們的弱點才能迎來最終的勝利。",sayList);
               NPCDialogManager.say(npcDialogInfo);
            }
            else
            {
               npcOptionInfo = new NPCDialogOptionInfo("恩！",ActionType.FUNCTION,function():void
               {
                  npcOptionInfo = new NPCDialogOptionInfo(".....",ActionType.FUNCTION,sendTask1023Over);
                  sayList[0] = npcOptionInfo;
                  npcDialogInfo = new NPCDialogInfo(10287,"失望","王，我馬上就去辦，放心！",sayList);
                  NPCDialogManager.say(npcDialogInfo);
               });
               sayList.push(npcOptionInfo);
               npcDialogInfo = new NPCDialogInfo(10287,"正常","勝還是敗都不重要，勝只是暫時的勝，他們不斷吸取的摩靈的能量，很快就可以再戰！走吧！",sayList);
               NPCDialogManager.say(npcDialogInfo);
            }
         }
         if(e.EventObj.levelId == 4004)
         {
            if(Boolean(e.EventObj.isWin))
            {
               Alert.smileAlart("恭喜小摩爾獲得真假摩幻蛋積分X2,摩爾豆X1000");
            }
         }
         if(e.EventObj.levelId == 4005)
         {
            if(Boolean(e.EventObj.isWin))
            {
               Alert.smileAlart("恭喜小摩爾獲得真假摩幻蛋積分X4,摩爾豆X4000");
            }
         }
         if(e.EventObj.levelId == 4006)
         {
            if(Boolean(e.EventObj.isWin))
            {
               Alert.smileAlart("恭喜小摩爾獲得真假摩幻蛋積分X6,摩爾豆X1000");
            }
         }
         if(e.EventObj.levelId == 4007)
         {
            if(Boolean(e.EventObj.isWin))
            {
               Alert.smileAlart("恭喜小摩爾獲得真假摩幻蛋積分X8,摩爾豆X3000");
            }
         }
         if(e.EventObj.levelId == 4008)
         {
            if(Boolean(e.EventObj.isWin))
            {
               Alert.smileAlart("恭喜小摩爾獲得真假摩幻蛋積分X10,摩爾豆X4000");
            }
         }
         if(e.EventObj.levelId == 4009)
         {
            if(Boolean(e.EventObj.isWin))
            {
               GF.sendSocket(CommandID.LAMU_MOONCAKE_PARTY);
            }
         }
         if(e.EventObj.levelId == 4010)
         {
            if(Boolean(e.EventObj.isWin))
            {
               GV.onlineSocket.dispatchEvent(new EventTaomee("MagicSpirit4010Over"));
            }
         }
      }
      
      private function sendTask1023Over() : void
      {
         GV.onlineSocket.dispatchEvent(new Event("Task1023GamepanelOver"));
      }
      
      private function sendEventOver() : void
      {
         GV.onlineSocket.dispatchEvent(new Event("Task1022GamepanelOver"));
      }
      
      public function magicSpiritePVP(type:uint, flag:uint, userId:uint, rank:uint = 0) : void
      {
         GF.sendSocket(CommandID.MAGICSPRITE_PVP_CREATE_BTL,type,flag,rank,userId);
         GV.onlineSocket.addCmdListener(CommandID.MAGICSPRITE_PVP_CREATE_BTL,this.onReadyBtl);
         GV.onlineSocket.addCmdListener(CommandID.MAGICSPRITE_PVP_READY_NOTI,this.onEnemyInfo);
      }
      
      private function onReadyBtl(e:*) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.MAGICSPRITE_PVP_CREATE_BTL,this.onReadyBtl);
         var recData:ByteArray = e.data as ByteArray;
         if(recData == null)
         {
            return;
         }
         var flag:uint = recData.readUnsignedInt();
         if(flag == 0)
         {
            Alert.smileAlart("    挑戰異常，稍後再試");
            GV.onlineSocket.dispatchEvent(new Event("refreshCd"));
         }
      }
      
      private function onEnemyInfo(e:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.MAGICSPRITE_PVP_READY_NOTI,this.onEnemyInfo);
         var byteData:ByteArray = e.data as ByteArray;
         MapManager.clearMap();
         ModuleManager.openPanel("MolingPVPMainPanel",byteData);
      }
   }
}

