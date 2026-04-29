package com.module.newAngel
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.util.DisplayUtil;
   import com.common.util.StringUtil;
   import com.core.MainManager;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.module.newAngel.info.AngelIncubateInfo;
   import com.module.newAngel.info.AngelInfo;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.OnlineManager;
   import com.mole.app.manager.StatisticsManager;
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import org.taomee.ds.HashMap;
   import org.taomee.net.SocketEvent;
   
   public class NewAngelManager extends EventDispatcher
   {
      
      private static var _instance:NewAngelManager;
      
      public static const NEW_ANGEL_ENTER_PARK:String = "new_angel_enter_park";
      
      public static const NEW_ANGEL_GET_BAG:String = "new_angel_get_bag";
      
      public static const NEW_ANGEL_INCUBATE:String = "new_angel_incubate";
      
      public static const NEW_ANGEL_GET_INCUBATE_INFO:String = "new_angel_get_incubate_info";
      
      public static const NEW_ANGEL_MUTUAL:String = "new_angel_mutual";
      
      public static const NEW_ANGEL_GET_PACKAGE:String = "new_angel_get_package";
      
      public static const NEW_ANGEL_GET_ITEMS:String = "new_angel_get_items";
      
      public static const NEW_ANGEL_GET_BACK:String = "new_angel_get_back";
      
      public static const NEW_ANGEL_CHANGE_STATE:String = "new_angel_change_state";
      
      public static const NEW_ANGEL_CULTURE:String = "new_angel_culture";
      
      public static const NEW_ANGEL_IN_PARK_CHANGE:String = "new_angel_in_park_change";
      
      public static const NEW_ANGEL_CHANGE_NICK:String = "new_angel_change_nick";
      
      public static const NEW_ANGEL_USE_ITEM_OVER:String = "new_angel_use_item_over";
      
      public static const NEW_ANGEL_ADD_EXP:String = "new_angel_add_exp";
      
      public static const NEW_ANGEL_CHANGE_REIKI:String = "new_angel_add_reiki";
      
      public static const NEW_ANGEL_GET_BOOK:String = "NewAngelManager_NEW_ANGEL_GET_BOOK";
      
      public static const NEW_ANGEL_MATE:String = "NewAngelManager_NEW_ANGEL_MATE";
      
      public static const NEW_ANGEL_QUERY_FOLLOW_ANGEL:String = "new_angel_query_follow_angel";
      
      public static const NEW_ANGEL_GET_MOUNT:String = "NEW_ANGEL_GET_MOUNT";
      
      public var _parkMaxAngelCount:uint;
      
      public var parkNimbus:uint;
      
      public var parkNimMax:uint;
      
      public var parkTrainMax:uint;
      
      public var inParkAngel:Vector.<AngelInfo>;
      
      public var inBagAngel:Vector.<AngelInfo>;
      
      public var inPackageAngel:Vector.<AngelInfo>;
      
      public var packagePage:uint;
      
      public var curPackagePage:uint;
      
      public var packageType:uint;
      
      public var lastAddNimbusTimer:uint;
      
      public var curIncubateAngelInfo:AngelIncubateInfo;
      
      public var angelParkItems:Vector.<Array>;
      
      public var inParkAngelStartTimeMap:HashMap;
      
      public var followNewAngelID:int;
      
      private var tempExp:int;
      
      private var useItemID:int;
      
      private var strArr:Array = ["忠誠","生命","攻擊","防禦","速度","範圍"];
      
      private var tempUserID:int;
      
      public function NewAngelManager()
      {
         super();
         this.inParkAngel = new Vector.<AngelInfo>();
         this.inBagAngel = new Vector.<AngelInfo>();
         this.inPackageAngel = new Vector.<AngelInfo>();
         this.angelParkItems = new Vector.<Array>();
         this.inParkAngelStartTimeMap = new HashMap();
      }
      
      public static function get instance() : NewAngelManager
      {
         if(!_instance)
         {
            _instance = new NewAngelManager();
         }
         return _instance;
      }
      
      public function enterAngelPark(userId:uint) : void
      {
         GV.onlineSocket.addCmdListener(CommandID.NEW_ANGEL_ENTER_PARK,this.enterParkHandler);
         GF.sendSocket(CommandID.NEW_ANGEL_ENTER_PARK,userId);
      }
      
      private function enterParkHandler(evt:SocketEvent) : void
      {
         var angelInfo:AngelInfo = null;
         GV.onlineSocket.removeCmdListener(CommandID.NEW_ANGEL_ENTER_PARK,this.enterParkHandler);
         var recData:ByteArray = evt.data as ByteArray;
         this.parkNimbus = recData.readUnsignedInt();
         this.parkNimMax = recData.readUnsignedInt();
         this.parkTrainMax = recData.readUnsignedInt();
         this.lastAddNimbusTimer = ServerUpTime.getInstance().serverTime / 1000;
         var curInParkAngelCount:uint = recData.readUnsignedInt();
         this.inParkAngel = new Vector.<AngelInfo>();
         this.inParkAngelStartTimeMap = new HashMap();
         for(var ix:int = 0; ix < curInParkAngelCount; ix++)
         {
            angelInfo = new AngelInfo(recData);
            angelInfo.angelSkill = recData.readUnsignedInt();
            this.inParkAngel.push(angelInfo);
            this.inParkAngelStartTimeMap.add(angelInfo.id,angelInfo.startTime);
         }
         dispatchEvent(new EventTaomee(NEW_ANGEL_ENTER_PARK));
      }
      
      public function getAngelParkItems() : void
      {
         GV.onlineSocket.addCmdListener(CommandID.NEW_ANGEL_GET_ITEMS,this.getItemsHandler);
         GF.sendSocket(CommandID.NEW_ANGEL_GET_ITEMS);
      }
      
      private function getItemsHandler(evt:SocketEvent) : void
      {
         var itemID:int = 0;
         var cnt:int = 0;
         GV.onlineSocket.removeCmdListener(CommandID.NEW_ANGEL_GET_ITEMS,this.getItemsHandler);
         var recData:ByteArray = evt.data as ByteArray;
         var count:uint = recData.readUnsignedInt();
         this.angelParkItems = new Vector.<Array>();
         for(var ix:int = 0; ix < count; ix++)
         {
            itemID = int(recData.readUnsignedInt());
            cnt = int(recData.readUnsignedInt());
            this.angelParkItems.push([itemID,cnt]);
         }
         dispatchEvent(new EventTaomee(NEW_ANGEL_GET_ITEMS));
      }
      
      public function getAngelBag() : void
      {
         GV.onlineSocket.addCmdListener(CommandID.NEW_ANGEL_GET_BAG,this.getBagHandler);
         GF.sendSocket(CommandID.NEW_ANGEL_GET_BAG);
      }
      
      private function getBagHandler(evt:SocketEvent) : void
      {
         var angelInfo:AngelInfo = null;
         GV.onlineSocket.removeCmdListener(CommandID.NEW_ANGEL_GET_BAG,this.getBagHandler);
         var recData:ByteArray = evt.data as ByteArray;
         var curInParkAngelCount:uint = recData.readUnsignedInt();
         this.inBagAngel = new Vector.<AngelInfo>();
         for(var ix:int = 0; ix < curInParkAngelCount; ix++)
         {
            angelInfo = new AngelInfo(recData);
            angelInfo.angelSkill = recData.readUnsignedInt();
            this.inBagAngel.push(angelInfo);
         }
         dispatchEvent(new EventTaomee(NEW_ANGEL_GET_BAG));
      }
      
      public function getAngelPackage(page:uint, packType:uint = 1, raceType:uint = 0, orderByLv:uint = 0, orderBySex:uint = 0, pageNum:uint = 12) : void
      {
         GV.onlineSocket.addCmdListener(CommandID.NEW_ANGEL_GET_PACKAGE,this.getPackageHandler);
         GF.sendSocket(CommandID.NEW_ANGEL_GET_PACKAGE,page,packType,raceType,orderByLv,orderBySex,pageNum);
      }
      
      private function getPackageHandler(evt:SocketEvent) : void
      {
         var angelInfo:AngelInfo = null;
         GV.onlineSocket.removeCmdListener(CommandID.NEW_ANGEL_GET_PACKAGE,this.getPackageHandler);
         var recData:ByteArray = evt.data as ByteArray;
         this.packagePage = recData.readUnsignedInt();
         this.curPackagePage = recData.readUnsignedInt();
         this.packageType = recData.readUnsignedInt();
         var curInParkAngelCount:uint = recData.readUnsignedInt();
         this.inPackageAngel = new Vector.<AngelInfo>();
         for(var ix:int = 0; ix < curInParkAngelCount; ix++)
         {
            angelInfo = new AngelInfo(recData);
            angelInfo.angelSkill = recData.readUnsignedInt();
            this.inPackageAngel.push(angelInfo);
         }
         dispatchEvent(new EventTaomee(NEW_ANGEL_GET_PACKAGE));
      }
      
      public function incubateAngel(angelId:uint) : void
      {
         var needNimbus:uint = 0;
         var step:uint = GoodsInfo.getAngelInfoById(angelId).step;
         switch(step)
         {
            case 1:
               needNimbus = 200;
               break;
            case 2:
               needNimbus = 300;
               break;
            case 3:
               needNimbus = 500;
               break;
            default:
               needNimbus = 200;
         }
         if(this.parkNimbus >= needNimbus)
         {
            GV.onlineSocket.addCmdListener(CommandID.NEW_ANGEL_INCUBATE,this.incubateHandler);
            GF.sendSocket(CommandID.NEW_ANGEL_INCUBATE,angelId);
         }
         else
         {
            Alert.angryAlart("孵化所需靈氣不足,當前需要" + needNimbus);
         }
      }
      
      private function incubateHandler(evt:SocketEvent) : void
      {
         var needNimbus:uint = 0;
         GV.onlineSocket.removeCmdListener(CommandID.NEW_ANGEL_INCUBATE,this.incubateHandler);
         var recData:ByteArray = evt.data as ByteArray;
         var state:uint = recData.readUnsignedInt();
         switch(state)
         {
            case 0:
               this.curIncubateAngelInfo = new AngelIncubateInfo(recData);
               this.reduceItem(this.curIncubateAngelInfo.angelStaticId,1);
               dispatchEvent(new EventTaomee(NEW_ANGEL_INCUBATE));
               switch(this.curIncubateAngelInfo.angelStaticInfo.step)
               {
                  case 1:
                     needNimbus = 200;
                     break;
                  case 2:
                     needNimbus = 300;
                     break;
                  case 3:
                     needNimbus = 500;
                     break;
                  default:
                     needNimbus = 200;
               }
               if(this.parkNimbus >= needNimbus)
               {
                  this.parkNimbus -= needNimbus;
               }
               dispatchEvent(new EventTaomee(NEW_ANGEL_CHANGE_REIKI));
               StatisticsManager.send(25);
               break;
            case 1:
               Alert.angryAlart("您的靈氣值不夠哦!");
               break;
            case 2:
               Alert.angryAlart("有正在孵化的天使寶寶哦!");
               break;
            case 3:
               Alert.angryAlart("您當前沒有這個天使寶寶哦!");
         }
      }
      
      public function getIncubateAngelInfo() : void
      {
         GV.onlineSocket.addCmdListener(CommandID.NEW_ANGEL_GET_INCUBATE,this.getIncubateHandler);
         GF.sendSocket(CommandID.NEW_ANGEL_GET_INCUBATE);
      }
      
      public function getIncubateHandler(evt:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.NEW_ANGEL_GET_INCUBATE,this.getIncubateHandler);
         var recData:ByteArray = evt.data as ByteArray;
         var isExist:Boolean = recData.readUnsignedInt() == 1;
         if(isExist)
         {
            this.curIncubateAngelInfo = new AngelIncubateInfo(recData);
         }
         dispatchEvent(new EventTaomee(NEW_ANGEL_GET_INCUBATE_INFO));
      }
      
      public function getAngelBack(angelId:uint) : void
      {
         GV.onlineSocket.addCmdListener(CommandID.NEW_ANGEL_GET_BACK,this.getAngelBackHandler);
         GF.sendSocket(CommandID.NEW_ANGEL_GET_BACK,angelId);
      }
      
      private function getAngelBackHandler(evt:SocketEvent) : void
      {
         var angelInfo:AngelInfo = null;
         GV.onlineSocket.removeCmdListener(CommandID.NEW_ANGEL_GET_BACK,this.getAngelBackHandler);
         var recData:ByteArray = evt.data as ByteArray;
         var state:uint = recData.readUnsignedInt();
         if(state == 1)
         {
            dispatchEvent(new EventTaomee(NEW_ANGEL_GET_BACK));
            angelInfo = new AngelInfo(recData);
            angelInfo.angelSkill = recData.readUnsignedInt();
            ModuleManager.openPanel("NewAngelInfoPanel",{
               "userID":0,
               "angelInfo":angelInfo
            });
            this.curIncubateAngelInfo = null;
         }
         else
         {
            Alert.angryAlart("取回天使寶寶失敗!");
         }
      }
      
      public function doMutual(angelId:uint, order:uint, optVal:uint) : void
      {
         GV.onlineSocket.addCmdListener(CommandID.NEW_ANGEL_MUTUAL,this.mutualHandler);
         GF.sendSocket(CommandID.NEW_ANGEL_MUTUAL,angelId,order,optVal);
      }
      
      private function mutualHandler(evt:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.NEW_ANGEL_MUTUAL,this.mutualHandler);
         var recData:ByteArray = evt.data as ByteArray;
         var state:uint = recData.readUnsignedInt();
         this.curIncubateAngelInfo.angelLastOptTime = uint(ServerUpTime.getInstance().serverTime / 1000);
         dispatchEvent(new EventTaomee(NEW_ANGEL_MUTUAL,state));
      }
      
      public function changeAngelState(angelVec:Vector.<Array>) : void
      {
         GV.onlineSocket.addCmdListener(CommandID.NEW_ANGEL_CHANGE_POSITION,this.changeAngelStateBack);
         var arr:ByteArray = new ByteArray();
         arr.writeUnsignedInt(angelVec.length);
         for(var ix:int = 0; ix < angelVec.length; ix++)
         {
            arr.writeUnsignedInt(angelVec[ix][0]);
            arr.writeUnsignedInt(angelVec[ix][1]);
         }
         GF.sendSocket(CommandID.NEW_ANGEL_CHANGE_POSITION,arr);
      }
      
      private function changeAngelStateBack(evt:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.NEW_ANGEL_CHANGE_POSITION,this.changeAngelStateBack);
         var recData:ByteArray = evt.data as ByteArray;
         var state:uint = recData.readUnsignedInt();
         dispatchEvent(new EventTaomee(NEW_ANGEL_CHANGE_STATE,state));
         if(state == 0)
         {
            Alert.angryAlart("天使不存在!");
         }
         else if(state == 1)
         {
            Alert.angryAlart("天使背包已滿!");
         }
      }
      
      public function cultureAngel(angelId:uint) : void
      {
         GV.onlineSocket.addCmdListener(CommandID.NEW_ANGEL_CULTURE,this.cultureAngelBack);
         GF.sendSocket(CommandID.NEW_ANGEL_CULTURE,angelId);
      }
      
      private function cultureAngelBack(evt:SocketEvent) : void
      {
         var ix:int = 0;
         GV.onlineSocket.removeCmdListener(CommandID.NEW_ANGEL_CULTURE,this.cultureAngelBack);
         var recData:ByteArray = evt.data as ByteArray;
         var angelId:uint = recData.readUnsignedInt();
         var state:uint = recData.readUnsignedInt();
         switch(state)
         {
            case 0:
               ix = 0;
               for(ix = 0; ix < this.inBagAngel.length; ix++)
               {
                  if(this.inBagAngel[ix].id == angelId)
                  {
                     if(this.parkNimbus >= this.inBagAngel[ix].angelLv * 2)
                     {
                        this.parkNimbus -= this.inBagAngel[ix].angelLv * 2;
                     }
                     dispatchEvent(new EventTaomee(NEW_ANGEL_CHANGE_REIKI));
                     this.inParkAngel.push(this.inBagAngel[ix]);
                     this.inParkAngelStartTimeMap.add(angelId,uint(ServerUpTime.getInstance().serverTime / 1000));
                     dispatchEvent(new EventTaomee(NEW_ANGEL_IN_PARK_CHANGE,{
                        "type":"add",
                        "angelInfo":this.inBagAngel[ix]
                     }));
                     this.inBagAngel.splice(ix,1);
                     break;
                  }
               }
               for(ix = 0; ix < this.inPackageAngel.length; ix++)
               {
                  if(this.inPackageAngel[ix].id == angelId)
                  {
                     if(this.parkNimbus >= this.inPackageAngel[ix].angelLv * 2)
                     {
                        this.parkNimbus -= this.inPackageAngel[ix].angelLv * 2;
                     }
                     dispatchEvent(new EventTaomee(NEW_ANGEL_CHANGE_REIKI));
                     this.inParkAngel.push(this.inPackageAngel[ix]);
                     this.inParkAngelStartTimeMap.add(angelId,uint(ServerUpTime.getInstance().serverTime / 1000));
                     dispatchEvent(new EventTaomee(NEW_ANGEL_IN_PARK_CHANGE,{
                        "type":"add",
                        "angelInfo":this.inPackageAngel[ix]
                     }));
                     this.inPackageAngel.splice(ix,1);
                     break;
                  }
               }
               dispatchEvent(new EventTaomee(NEW_ANGEL_CULTURE,angelId));
               break;
            case 1:
               Alert.angryAlart("天使園不能再容納天使了哦!");
               break;
            case 2:
               Alert.angryAlart("天使園靈氣值不足!");
         }
      }
      
      public function getAllAngelFromPark() : void
      {
         if(this.inParkAngel.length > 0)
         {
            GV.onlineSocket.addCmdListener(CommandID.NEW_ANGEL_CULTURE_BACK,this.getAngelBackAllResponse);
            GF.sendSocket(CommandID.NEW_ANGEL_CULTURE_BACK,this.inParkAngel[0].id,this.inParkAngel[0].angelStaticId);
         }
      }
      
      private function getAngelBackAllResponse(evt:SocketEvent) : void
      {
         var angelInfo:AngelInfo = null;
         var ix:int = 0;
         var lastAngelInfo:AngelInfo = null;
         GV.onlineSocket.removeCmdListener(CommandID.NEW_ANGEL_CULTURE_BACK,this.getAngelBackAllResponse);
         var recData:ByteArray = evt.data as ByteArray;
         var state:uint = recData.readUnsignedInt();
         if(state == 1 || state == 2 || state == 3)
         {
            angelInfo = new AngelInfo(recData);
            for(ix = 0; ix < this.inParkAngel.length; ix++)
            {
               if(this.inParkAngel[ix].id == angelInfo.id)
               {
                  lastAngelInfo = this.inParkAngel[ix];
                  this.inParkAngel.splice(ix,1);
                  dispatchEvent(new EventTaomee(NEW_ANGEL_IN_PARK_CHANGE,{
                     "type":"remove",
                     "angelInfo":angelInfo
                  }));
                  if(this.inParkAngel.length > 0)
                  {
                     this.getAllAngelFromPark();
                  }
                  else
                  {
                     this.alert("    天使都已收回到背包或倉庫");
                  }
               }
            }
         }
      }
      
      public function getAngelFromPark(angelId:uint, angelStaticId:uint, totalExp:int) : void
      {
         this.tempExp = totalExp;
         GV.onlineSocket.addCmdListener(CommandID.NEW_ANGEL_CULTURE_BACK,this.getAngelBackResponse);
         GF.sendSocket(CommandID.NEW_ANGEL_CULTURE_BACK,angelId,angelStaticId);
      }
      
      private function getAngelBackResponse(evt:SocketEvent) : void
      {
         var angelInfo:AngelInfo = null;
         var ix:int = 0;
         var lastAngelInfo:AngelInfo = null;
         GV.onlineSocket.removeCmdListener(CommandID.NEW_ANGEL_CULTURE_BACK,this.getAngelBackResponse);
         var recData:ByteArray = evt.data as ByteArray;
         var state:uint = recData.readUnsignedInt();
         if(state == 1 || state == 2 || state == 3)
         {
            angelInfo = new AngelInfo(recData);
            for(ix = 0; ix < this.inParkAngel.length; ix++)
            {
               if(this.inParkAngel[ix].id == angelInfo.id)
               {
                  lastAngelInfo = this.inParkAngel[ix];
                  if(Boolean(lastAngelInfo) && lastAngelInfo.angelLv != angelInfo.angelLv)
                  {
                     ModuleManager.openPanel("NewAngelUpgradePanel",{
                        "last":lastAngelInfo,
                        "cur":angelInfo,
                        "exp":this.tempExp
                     });
                  }
                  this.inParkAngel.splice(ix,1);
                  dispatchEvent(new EventTaomee(NEW_ANGEL_IN_PARK_CHANGE,{
                     "type":"remove",
                     "angelInfo":angelInfo
                  }));
               }
            }
         }
      }
      
      public function changeAngelNick(angelId:uint, nickName:String) : void
      {
         GV.onlineSocket.addCmdListener(CommandID.NEW_ANGEL_CHANGE_NICK,this.changeAngelNickBack);
         var byteArr:ByteArray = new ByteArray();
         byteArr.writeUnsignedInt(angelId);
         byteArr.writeBytes(StringUtil.FillString(nickName,16));
         GF.sendSocket(CommandID.NEW_ANGEL_CHANGE_NICK,byteArr);
      }
      
      private function changeAngelNickBack(evt:SocketEvent) : void
      {
         var angelId:uint = 0;
         var angelNick:String = null;
         var ix:int = 0;
         GV.onlineSocket.removeCmdListener(CommandID.NEW_ANGEL_CHANGE_NICK,this.changeAngelNickBack);
         var recData:ByteArray = evt.data as ByteArray;
         var state:Boolean = recData.readUnsignedInt() == 1;
         if(state)
         {
            angelId = recData.readUnsignedInt();
            for(angelNick = recData.readUTFBytes(16); ix < this.inBagAngel.length; )
            {
               if(this.inBagAngel[ix].id == angelId)
               {
                  this.inBagAngel[ix].angelNick = angelNick;
                  break;
               }
               ix++;
            }
            while(ix < this.inPackageAngel.length)
            {
               if(this.inPackageAngel[ix].id == angelId)
               {
                  this.inPackageAngel[ix].angelNick = angelNick;
                  break;
               }
               ix++;
            }
            dispatchEvent(new EventTaomee(NEW_ANGEL_CHANGE_NICK));
         }
         else
         {
            Alert.angryAlart("天使改名失敗!");
         }
      }
      
      public function reduceItem(itemId:uint, count:int) : void
      {
         for(var ix:int = 0; ix < this.angelParkItems.length; ix++)
         {
            if(this.angelParkItems[ix][0] == itemId)
            {
               this.angelParkItems[ix][1] -= count;
               if(this.angelParkItems[ix][1] <= 0)
               {
                  this.angelParkItems.splice(ix,1);
                  return;
               }
            }
         }
      }
      
      public function addItem(itemId:uint, count:int) : void
      {
         for(var ix:int = 0; ix < this.angelParkItems.length; ix++)
         {
            if(this.angelParkItems[ix][0] == itemId)
            {
               this.angelParkItems[ix][1] += count;
               return;
            }
         }
      }
      
      public function userItem(itemID:int, angelIndex:int, angelItemID:int) : void
      {
         this.useItemID = itemID;
         OnlineManager.send(CommandID.NEW_ANGEL_USE_ITEM_FOR_ANGEL,itemID,angelIndex,angelItemID);
         GV.onlineSocket.addCmdListener(CommandID.NEW_ANGEL_USE_ITEM_FOR_ANGEL,this.useItemOver);
      }
      
      private function useItemOver(e:SocketEvent) : void
      {
         var angelInfo:AngelInfo = null;
         var aInfo:AngelInfo = null;
         var type:int = 0;
         var variables:int = 0;
         var preGrowth:int = 0;
         var ix:int = 0;
         GV.onlineSocket.removeCmdListener(CommandID.NEW_ANGEL_USE_ITEM_FOR_ANGEL,this.useItemOver);
         var bodyData:ByteArray = e.data as ByteArray;
         var state:int = int(bodyData.readUnsignedInt());
         if(state == 4)
         {
            angelInfo = new AngelInfo(bodyData);
            for each(aInfo in this.inBagAngel)
            {
               if(aInfo.id == angelInfo.id)
               {
                  angelInfo.angelSkill = aInfo.angelSkill;
                  break;
               }
            }
            type = int(GoodsInfo.getInfoById(this.useItemID).Object);
            variables = int(GoodsInfo.getInfoById(this.useItemID).Variables);
            if(type >= 2 && type <= 7)
            {
               this.alert("      " + angelInfo.angelNick + "的" + this.strArr[type - 2] + "增加了" + variables + "點。");
            }
            else if(type == 8)
            {
               while(ix < this.inBagAngel.length)
               {
                  if(this.inBagAngel[ix].id == angelInfo.id)
                  {
                     preGrowth = int(this.inBagAngel[ix].angelGrowth);
                     this.inBagAngel[ix].angelGrowth = angelInfo.angelGrowth;
                     break;
                  }
                  ix++;
               }
               this.alert("      " + angelInfo.angelNick + "的成長值由" + preGrowth + "變成了" + angelInfo.angelGrowth + "。");
            }
            dispatchEvent(new EventTaomee(NEW_ANGEL_USE_ITEM_OVER,{
               "state":state,
               "angelInfo":angelInfo
            }));
         }
         else if(state == 1)
         {
            this.alert("      天使的單項屬性最多只能通過果實增加50點!");
         }
         else if(state == 3)
         {
            this.alert("      該天使的忠誠值為100，不用再提升");
         }
      }
      
      public function addExp(itemID:int, angelIndex:int, angelItemID:int) : void
      {
         this.tempExp = GoodsInfo.getInfoById(itemID).Variables;
         OnlineManager.send(CommandID.NEW_ANGEL_ADD_EXP,itemID,angelIndex,angelItemID);
         GV.onlineSocket.addCmdListener(CommandID.NEW_ANGEL_ADD_EXP,this.addExpOver);
      }
      
      private function addExpOver(e:SocketEvent) : void
      {
         var angelInfo:AngelInfo = null;
         var aInfo:AngelInfo = null;
         var lastAngelInfo:AngelInfo = null;
         var ix:int = 0;
         GV.onlineSocket.removeCmdListener(CommandID.NEW_ANGEL_ADD_EXP,this.addExpOver);
         var bodyData:ByteArray = e.data as ByteArray;
         var state:int = int(bodyData.readUnsignedInt());
         if(state == 3 || state == 4 || state == 5)
         {
            angelInfo = new AngelInfo(bodyData);
            for each(aInfo in this.inBagAngel)
            {
               if(aInfo.id == angelInfo.id)
               {
                  angelInfo.angelSkill = aInfo.angelSkill;
               }
            }
            lastAngelInfo = this.getAngelInfoFromBagOrPackage(angelInfo.id);
            if(angelInfo.angelLv == lastAngelInfo.angelLv)
            {
               this.alert("      " + angelInfo.angelNick + "獲得了" + this.tempExp + "經驗," + "當前" + angelInfo.angelLv + "級，還需" + angelInfo.angelNextLvExp + "經驗升級。");
            }
            if(Boolean(lastAngelInfo) && lastAngelInfo.angelLv != angelInfo.angelLv)
            {
               ModuleManager.openPanel("NewAngelUpgradePanel",{
                  "last":lastAngelInfo,
                  "cur":angelInfo,
                  "exp":this.tempExp
               });
               NewAngelPopMsg.instance.popMsg(angelInfo.angelNick + "升級了！");
            }
            for(ix = 0; ix < this.inBagAngel.length; ix++)
            {
               if(this.inBagAngel[ix].id == angelInfo.id)
               {
                  this.inBagAngel[ix] = angelInfo;
               }
            }
            dispatchEvent(new EventTaomee(NEW_ANGEL_ADD_EXP,{
               "state":state,
               "angelInfo":angelInfo
            }));
         }
      }
      
      public function getMount(angelItemID:int) : void
      {
         OnlineManager.addErrorListener(CommandID.NEW_ANGEL_GET_MOUNTS,this.onGetMountError);
         OnlineManager.send(CommandID.NEW_ANGEL_GET_MOUNTS,angelItemID);
         GV.onlineSocket.addCmdListener(CommandID.NEW_ANGEL_GET_MOUNTS,this.getMountOver);
      }
      
      private function onGetMountError(e:*) : void
      {
      }
      
      private function getMountOver(e:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.NEW_ANGEL_GET_MOUNTS,this.getMountOver);
         var bodyData:ByteArray = e.data as ByteArray;
         var id:int = int(bodyData.readUnsignedInt());
         if(id > 2)
         {
            Alert.smileAlart("    恭喜你獲得" + GoodsInfo.getItemNameByID(id) + "坐騎！已放入你的騎寵背包中！");
         }
         else if(id == 0)
         {
            Alert.smileAlart("      你還未擁有該天使哦！");
         }
         else if(id == 2)
         {
            Alert.smileAlart("      你已經擁有了該坐騎！");
         }
      }
      
      public function addReiki(itemID:int, count:int) : void
      {
         OnlineManager.send(CommandID.NEW_ANGEL_USE_ITEM_FOR_PARK,itemID,count);
         GV.onlineSocket.addCmdListener(CommandID.NEW_ANGEL_USE_ITEM_FOR_PARK,this.addReikiOver);
      }
      
      private function addReikiOver(e:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.NEW_ANGEL_USE_ITEM_FOR_PARK,this.addReikiOver);
         var bodyData:ByteArray = e.data as ByteArray;
         var state:int = int(bodyData.readUnsignedInt());
         var reiki:int = int(bodyData.readUnsignedInt());
         this.parkNimbus = reiki;
         if(state == 1)
         {
            dispatchEvent(new EventTaomee(NEW_ANGEL_CHANGE_REIKI,{
               "state":state,
               "reiki":reiki
            }));
         }
         else if(state == 0)
         {
            this.alert("      水晶不足，水晶可參與活動或戰鬥中有機率掉落");
         }
         else if(state == 2)
         {
            this.alert("      今天可使用該水晶的次數已經達到上限!");
         }
      }
      
      public function queryFolloerAngel(userID:int, angelIndex:int) : void
      {
         this.tempUserID = userID;
         GV.onlineSocket.addCmdListener(CommandID.NEW_ANGEL_QUERY_FOLLOW_ANGEL,this.queryFollowAngelOver);
         OnlineManager.send(CommandID.NEW_ANGEL_QUERY_FOLLOW_ANGEL,userID,angelIndex);
      }
      
      private function queryFollowAngelOver(e:SocketEvent) : void
      {
         var angelInfo:AngelInfo = null;
         GV.onlineSocket.removeCmdListener(CommandID.NEW_ANGEL_QUERY_FOLLOW_ANGEL,this.queryFollowAngelOver);
         var bodyData:ByteArray = e.data as ByteArray;
         var state:int = int(bodyData.readUnsignedInt());
         if(state == 1)
         {
            angelInfo = new AngelInfo(bodyData);
            angelInfo.angelSkill = bodyData.readUnsignedInt();
            ModuleManager.openPanel("NewAngelInfoPanel",{
               "userID":this.tempUserID,
               "angelInfo":angelInfo
            });
         }
      }
      
      public function alert(msg:String = "") : void
      {
         var loadAlertOver:Function = null;
         loadAlertOver = function(e:DownLoadEvent):void
         {
            var txt:TextField;
            var mc:MovieClip = null;
            var tClose:Function = null;
            mc = (e.data as MovieClip).getChildAt(0) as MovieClip;
            MainManager.getAppLevel().addChild(mc);
            txt = mc.getChildByName("txt") as TextField;
            if(msg != "")
            {
               txt.text = msg;
            }
            tClose = function():void
            {
               DisplayUtil.removeForParent(mc);
               mc.close_btn.removeEventListener(MouseEvent.CLICK,tClose);
            };
            mc.close_btn.addEventListener(MouseEvent.CLICK,tClose);
         };
         var resID:int = int(DownLoadManager.add("module/external/exeModule/newAngelAlert.swf",ResType.DISPLAY_OBJECT));
         DownLoadManager.addEvent(resID,loadAlertOver);
      }
      
      public function getAngelInfoFromBagOrPackage(angelId:uint) : AngelInfo
      {
         var angelInfo:AngelInfo = null;
         var ix:int = 0;
         for(ix = 0; ix < this.inBagAngel.length; ix++)
         {
            if(this.inBagAngel[ix].id == angelId)
            {
               return this.inBagAngel[ix];
            }
         }
         for(ix = 0; ix < this.inPackageAngel.length; ix++)
         {
            if(this.inPackageAngel[ix].id == angelId)
            {
               return this.inPackageAngel[ix];
            }
         }
         return null;
      }
      
      public function get parkMaxAngelCount() : int
      {
         var addCount:uint = 0;
         if(LocalUserInfo.isVIP())
         {
            addCount = 0;
            switch(LocalUserInfo.getSLstar())
            {
               case 1:
                  addCount = 1;
                  break;
               case 2:
               case 3:
                  addCount = 2;
                  break;
               case 4:
               case 5:
                  addCount = 3;
                  break;
               default:
                  addCount = 4;
            }
            return 8 + addCount;
         }
         return 8;
      }
      
      public function requestHandbookData() : void
      {
         OnlineManager.send(CommandID.NEW_ANGEL_GET_BOOK);
         GV.onlineSocket.addCmdListener(CommandID.NEW_ANGEL_GET_BOOK,this.respondHandbookHandle);
      }
      
      private function respondHandbookHandle(e:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.NEW_ANGEL_GET_BOOK,this.respondHandbookHandle);
         var handbook:Array = [];
         var bodyData:ByteArray = e.data as ByteArray;
         var itemNum:int = int(bodyData.readUnsignedInt());
         for(var i:int = 0; i < itemNum; i++)
         {
            handbook.push({
               "id":bodyData.readUnsignedInt(),
               "flag":bodyData.readUnsignedInt()
            });
         }
         this.dispatchEvent(new EventTaomee(NEW_ANGEL_GET_BOOK,handbook));
      }
      
      public function requestMate(manId:int, manItemId:int, womanId:int, womanItemId:int, itemId:int) : void
      {
         OnlineManager.send(CommandID.NEW_ANGEL_MATE,manId,manItemId,womanId,womanItemId,itemId);
         GV.onlineSocket.addCmdListener(CommandID.NEW_ANGEL_MATE,this.respondMateHandle);
      }
      
      private function respondMateHandle(e:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.NEW_ANGEL_MATE,this.respondMateHandle);
         var data:Object = {};
         var bodyData:ByteArray = e.data as ByteArray;
         data["state"] = bodyData.readUnsignedInt();
         data["angelId"] = bodyData.readUnsignedInt();
         data["itemId"] = bodyData.readUnsignedInt();
         data["itemNum"] = bodyData.readUnsignedInt();
         this.dispatchEvent(new EventTaomee(NEW_ANGEL_MATE,data));
      }
   }
}

