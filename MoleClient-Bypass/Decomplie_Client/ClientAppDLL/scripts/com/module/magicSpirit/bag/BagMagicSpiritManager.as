package com.module.magicSpirit.bag
{
   import com.common.Alert.Alert;
   import com.core.info.LocalUserInfo;
   import com.global.staticData.CommandID;
   import com.global.staticData.database.MagicSpirit.MagicSpiriteAchievementDefined;
   import com.global.staticData.database.MagicSpirit.MagicSpiriteAchievementDefintion;
   import com.module.magicSpirit.data.MagicSpiritInfo;
   import com.module.magicSpirit.data.MagicSpiritUserInfo;
   import com.module.magicSpirit.event.MagicSpiritEvent;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class BagMagicSpiritManager extends EventDispatcher
   {
      
      private static var inst:BagMagicSpiritManager;
      
      public var bagOPenStatic:uint = 1;
      
      private var _bagListList:Vector.<MagicSpiritInfo>;
      
      private var _userInfo:MagicSpiritUserInfo;
      
      public var _isFrist:Boolean = true;
      
      public var _isPlaytog:Boolean = false;
      
      public var isCanDrag:Boolean = true;
      
      private var _friendNowTeamInfo:Array = [];
      
      public function BagMagicSpiritManager()
      {
         super();
         GV.onlineSocket.addCmdListener(CommandID.MAGICSPIRIT_BAG_INFO,this.onGetBagInfo);
         GV.onlineSocket.addCmdListener(CommandID.MAGICSPIRIT_SET_FIGHT_STATIC,this.onSetFightStatic);
         GV.onlineSocket.addCmdListener(CommandID.MAGICSPIRIT_USER_INFO,this.onGetUserInfo);
         GV.onlineSocket.addCmdListener(CommandID.MAGICSPIRIT_GET_INFO_FOR_USERID,this.onGetFrendInfo);
         GV.onlineSocket.addCmdListener(CommandID.MAGICSPIRIT_BAG_FULL,this.onBagFull);
         GV.onlineSocket.addCmdListener(CommandID.MAGICSPIRITE_ACHIEVEMENT_OVER_ALERT,this.onAchievement);
         this.sendSocketToServer();
         this._bagListList = new Vector.<MagicSpiritInfo>();
      }
      
      public static function getInstance() : BagMagicSpiritManager
      {
         if(inst == null)
         {
            inst = new BagMagicSpiritManager();
         }
         return inst;
      }
      
      public function setup() : void
      {
         GF.sendSocket(CommandID.MAGICSPIRIT_BAG_INFO,0);
      }
      
      public function sendSocketToServer() : void
      {
         GF.sendSocket(CommandID.MAGICSPIRIT_BAG_INFO,0);
      }
      
      public function sendGetUserInfo() : void
      {
         GF.sendSocket(CommandID.MAGICSPIRIT_USER_INFO,LocalUserInfo.getUserID());
      }
      
      private function onBagFull(e:SocketEvent) : void
      {
         Alert.smileAlart("背包中的摩靈已滿，請擴充摩靈背包");
      }
      
      private function onAchievement(e:SocketEvent) : void
      {
         var recData:ByteArray = e.data as ByteArray;
         var id:uint = recData.readUnsignedInt();
         var defintion:MagicSpiriteAchievementDefintion = MagicSpiriteAchievementDefined.getDefintionById(id);
         Alert.smileAlart("   恭喜你獲得成就：" + defintion.name);
      }
      
      private function onGetBagInfo(e:SocketEvent) : void
      {
         var magicSpiritInfo:MagicSpiritInfo = null;
         var count:uint = 0;
         var i:uint = 0;
         var recData:ByteArray = e.data as ByteArray;
         if(Boolean(recData) && Boolean(recData.length))
         {
            recData.position = 0;
            count = recData.readUnsignedInt();
            this._bagListList.length = 0;
            for(i = 0; i < count; i++)
            {
               magicSpiritInfo = new MagicSpiritInfo();
               magicSpiritInfo.catchTime = recData.readUnsignedInt();
               magicSpiritInfo.fairyId = recData.readUnsignedInt();
               magicSpiritInfo.attr = recData.readUnsignedByte();
               magicSpiritInfo.level = recData.readUnsignedByte();
               magicSpiritInfo.exp = recData.readUnsignedInt();
               magicSpiritInfo.hp = recData.readUnsignedShort();
               magicSpiritInfo.attack = recData.readUnsignedShort();
               magicSpiritInfo.restoreForce = recData.readUnsignedShort();
               magicSpiritInfo.activeSkill = recData.readUnsignedShort();
               magicSpiritInfo.activeSkillLevel = recData.readUnsignedByte();
               magicSpiritInfo.passiveSkill = recData.readUnsignedShort();
               magicSpiritInfo.isfrend = recData.readUnsignedByte();
               magicSpiritInfo.isLeader = recData.readUnsignedByte();
               magicSpiritInfo.status = recData.readUnsignedByte();
               this._bagListList.push(magicSpiritInfo);
            }
         }
         this.reloadMagicSpiritStatus();
         this.refreshBag();
         if(this._isFrist)
         {
            this._isFrist = false;
            this.sendGetUserInfo();
         }
      }
      
      private function onGetUserInfo(e:SocketEvent) : void
      {
         var userInfo:MagicSpiritUserInfo = null;
         var recData:ByteArray = e.data as ByteArray;
         if(Boolean(recData))
         {
            recData.position = 0;
            userInfo = new MagicSpiritUserInfo(recData);
            if(userInfo.userid == LocalUserInfo.getUserID())
            {
               this._userInfo = userInfo;
               this.reloadMagicSpiritStatus();
               dispatchEvent(new MagicSpiritEvent(MagicSpiritEvent.MAGIC_SPIRIT_USER_INFO,this._userInfo));
            }
            else
            {
               this.getFriendMagicSpiritInfo(userInfo);
               dispatchEvent(new MagicSpiritEvent(MagicSpiritEvent.MAGIC_SPIRIT_GRT_OTHER_INFO,userInfo));
            }
         }
      }
      
      private function reloadMagicSpiritStatus() : void
      {
         var info:MagicSpiritInfo = null;
         if(Boolean(this._bagListList.length > 0) && Boolean(this._userInfo) && Boolean(this._userInfo.nowTeamInfo))
         {
            for each(info in this._bagListList)
            {
               info.status = this._userInfo.nowTeamInfo.indexOf(info.catchTime) >= 0 ? 1 : 0;
            }
         }
      }
      
      private function getFriendMagicSpiritInfo(info:MagicSpiritUserInfo) : void
      {
         var recdata:ByteArray = null;
         var i:uint = 0;
         var j:uint = 0;
         var userInfo:MagicSpiritUserInfo = info;
         var arr:Array = new Array();
         this._friendNowTeamInfo.length = 0;
         if(userInfo.nowTeamInfo != null)
         {
            for(i = 0; i < userInfo.nowTeamInfo.length; i++)
            {
               if(userInfo.nowTeamInfo[i] > 0)
               {
                  arr.push(userInfo.nowTeamInfo[i]);
               }
               this._friendNowTeamInfo.push(userInfo.nowTeamInfo[i]);
            }
            recdata = new ByteArray();
            if(arr.length > 0)
            {
               recdata.writeUnsignedInt(userInfo.userid);
               recdata.writeUnsignedInt(arr.length);
               for(j = 0; j < arr.length; j++)
               {
                  recdata.writeUnsignedInt(arr[j]);
               }
               GF.sendSocket(CommandID.MAGICSPIRIT_GET_INFO_FOR_USERID,recdata);
            }
            else
            {
               Alert.smileAlart("    該玩家還沒有隊伍");
            }
         }
         else
         {
            Alert.smileAlart("      該玩家還沒有隊伍");
         }
      }
      
      private function onGetFrendInfo(e:SocketEvent) : void
      {
         var spiritInfoList:Vector.<MagicSpiritInfo> = null;
         var tempList:Vector.<MagicSpiritInfo> = null;
         var spiritInfo:MagicSpiritInfo = null;
         var userid:uint = 0;
         var count:uint = 0;
         var i:uint = 0;
         var j:uint = 0;
         var recData:ByteArray = e.data as ByteArray;
         if(recData != null)
         {
            recData.position = 0;
            spiritInfoList = new Vector.<MagicSpiritInfo>();
            tempList = new Vector.<MagicSpiritInfo>();
            userid = recData.readUnsignedInt();
            count = recData.readUnsignedInt();
            spiritInfoList.length = 5;
            for(i = 0; i < count; i++)
            {
               spiritInfo = new MagicSpiritInfo();
               spiritInfo.catchTime = recData.readUnsignedInt();
               spiritInfo.fairyId = recData.readUnsignedInt();
               spiritInfo.attr = recData.readUnsignedByte();
               spiritInfo.level = recData.readUnsignedByte();
               spiritInfo.exp = recData.readUnsignedInt();
               spiritInfo.hp = recData.readUnsignedShort();
               spiritInfo.attack = recData.readUnsignedShort();
               spiritInfo.restoreForce = recData.readUnsignedShort();
               spiritInfo.activeSkill = recData.readUnsignedShort();
               spiritInfo.activeSkillLevel = recData.readUnsignedByte();
               spiritInfo.passiveSkill = recData.readUnsignedShort();
               spiritInfo.isfrend = recData.readUnsignedByte();
               spiritInfo.isLeader = recData.readUnsignedByte();
               spiritInfo.status = recData.readUnsignedByte();
               for(j = 0; j < this._friendNowTeamInfo.length; j++)
               {
                  if(this._friendNowTeamInfo[j] == spiritInfo.catchTime)
                  {
                     spiritInfoList[j] = spiritInfo;
                  }
               }
            }
            dispatchEvent(new MagicSpiritEvent(MagicSpiritEvent.MAGIC_SPIRIT_GET_FRIEND_TEAM_INFO,spiritInfoList));
         }
      }
      
      private function onSetFightStatic(e:SocketEvent) : void
      {
         var recData:ByteArray = e.data as ByteArray;
         recData.position = 0;
         var castchTime:uint = recData.readUnsignedInt();
         var flag:uint = recData.readUnsignedInt();
         this.changeFightStatusByCatchTime(castchTime,flag);
      }
      
      public function get bagMagicSpiritInfoList() : Vector.<MagicSpiritInfo>
      {
         return this._bagListList.concat();
      }
      
      public function get isBagFull() : Boolean
      {
         if(Boolean(this._bagListList) && Boolean(this._userInfo))
         {
            return this._bagListList.length >= this._userInfo.bagSzie;
         }
         return false;
      }
      
      public function getSpiritNumByItem(fairyId:uint) : Vector.<MagicSpiritInfo>
      {
         var info:MagicSpiritInfo = null;
         var id:uint = 0;
         var tempVec:Vector.<MagicSpiritInfo> = new Vector.<MagicSpiritInfo>();
         for(var i:uint = 0; i < this._bagListList.length; i++)
         {
            info = this._bagListList[i];
            if(info.fairyId == fairyId)
            {
               tempVec.push(info);
            }
         }
         return tempVec;
      }
      
      public function ChangeSyntheTicstatus(catchTM:uint, bool:Boolean) : void
      {
         var Info:MagicSpiritInfo = this.getSpiritInfoBycatchTime(catchTM);
         if(Info != null)
         {
            Info.syntheticStatus = bool;
         }
         this.refreshBag();
      }
      
      public function ChangeSellstatus(catchTM:uint, bool:Boolean) : void
      {
         var Info:MagicSpiritInfo = this.getSpiritInfoBycatchTime(catchTM);
         if(Info != null)
         {
            Info.sellStatus = bool;
         }
         this.refreshBag();
      }
      
      public function refreshBag() : void
      {
         dispatchEvent(new MagicSpiritEvent(MagicSpiritEvent.MAGIC_SPIRIT_BAG_INFO,this._bagListList.concat()));
      }
      
      public function get getUserInfo() : MagicSpiritUserInfo
      {
         return this._userInfo;
      }
      
      public function getSpiritInfoBycatchTime(catchTM:uint) : MagicSpiritInfo
      {
         var tempInfo:MagicSpiritInfo = null;
         var info:MagicSpiritInfo = null;
         for(var i:uint = 0; i < this._bagListList.length; i++)
         {
            tempInfo = this._bagListList[i];
            if(tempInfo.catchTime == catchTM)
            {
               info = tempInfo;
               break;
            }
         }
         return info;
      }
      
      public function changeFightStatusByCatchTime(catchTM:uint, flag:uint) : void
      {
         var info:MagicSpiritInfo = null;
         for(var i:uint = 0; i < this._bagListList.length; i++)
         {
            info = this._bagListList[i];
            if(info.catchTime == catchTM)
            {
               info.status = flag;
               dispatchEvent(new MagicSpiritEvent(MagicSpiritEvent.MAGIC_SPIRIT_BAG_INFO,this._bagListList.concat()));
            }
         }
      }
      
      public function clearSyntheticStatus() : void
      {
         var info:MagicSpiritInfo = null;
         for(var i:uint = 0; i < this._bagListList.length; i++)
         {
            info = this._bagListList[i];
            info.syntheticStatus = false;
         }
      }
      
      public function clearSellStatus() : void
      {
         var info:MagicSpiritInfo = null;
         for(var i:uint = 0; i < this._bagListList.length; i++)
         {
            info = this._bagListList[i];
            info.sellStatus = false;
         }
         GF.sendSocket(CommandID.MAGICSPIRIT_BAG_INFO,0);
      }
      
      public function get getUserNowTeamAttribute() : Number
      {
         var info:MagicSpiritInfo = null;
         var i:uint = 0;
         var fightNum:Number = 0;
         var advanceFight:uint = 0;
         var selfInfo:MagicSpiritUserInfo = BagMagicSpiritManager.getInstance().getUserInfo;
         if(this._userInfo.nowTeamInfo != null)
         {
            for(i = 0; i < 5; i++)
            {
               info = this.getSpiritInfoBycatchTime(this._userInfo.nowTeamInfo[i]);
               if(info != null)
               {
                  if(info.passiveSkill > 0)
                  {
                     advanceFight = 100;
                  }
                  else
                  {
                     advanceFight = 0;
                  }
                  fightNum += Number(info.hp) + Number(info.attack) * 2.69 + Number(info.restoreForce) * 4.82 + Number(info.activeSkillLevel * 10) + advanceFight;
               }
            }
         }
         else
         {
            fightNum = 0;
         }
         return fightNum;
      }
   }
}

