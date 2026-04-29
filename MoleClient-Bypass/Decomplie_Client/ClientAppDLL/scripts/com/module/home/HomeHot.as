package com.module.home
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.socket.getFrendList.GetFlowersReq;
   import com.logic.socket.getFrendList.GetFlowersRes;
   import com.logic.socket.getFrendList.sendFlowersReq;
   import com.logic.socket.getFrendList.sendFlowersRes;
   import com.logic.socket.getSceneUserInfo.GetSceneUserInfoReq;
   import com.logic.socket.getSceneUserInfo.GetSceneUserRes;
   import com.logic.socket.home.homeSocket;
   import com.module.changeClothsModule.prevView;
   import com.module.farm.FieldGuestList;
   import com.module.farm.FieldView;
   import com.module.newHouse.newHouseView;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class HomeHot
   {
      
      public static var ID:uint;
      
      public static var HotUI:*;
      
      public static var ListUI:Sprite;
      
      public static var HotUIClass:Class;
      
      public static var ListUIClass:Class;
      
      public static var FlowerNum:Number;
      
      public static var MudNum:Number;
      
      public static var sendBool:Boolean;
      
      private static var sendtype:uint;
      
      private static var Man:Class;
      
      private static var len:uint;
      
      private static var ScrollBar:*;
      
      private static var myTimeout:*;
      
      private static var MC:MovieClip;
      
      public static var Obj:Object;
      
      public static var VisitorArr:Array;
      
      public static var plantNum:uint;
      
      public static var farmNum:uint;
      
      public static var plantLVMum:uint;
      
      public static var farmLVNum:uint;
      
      private static var mcloader:MCLoader;
      
      private static var _hotType:int;
      
      public static var HotNum:uint = 0;
      
      private static var arrMC:Array = new Array();
      
      public static const HOT_TYPE_HOME:int = 1;
      
      public static const HOT_TYPE_FARM:int = 2;
      
      public function HomeHot()
      {
         super();
      }
      
      public static function init(id:uint, type:int = 1) : void
      {
         _hotType = type;
         ID = id;
         getFlowerAndHot();
      }
      
      public static function hotID() : *
      {
         var id:* = undefined;
         if(HomeView.hostID == 0)
         {
            id = newHouseView.houseID;
         }
         else
         {
            id = HomeView.hostID;
         }
         if(id == 0)
         {
            id = LocalUserInfo.getUserID();
         }
         return id;
      }
      
      public static function removeEvent(e:Event) : void
      {
         GV.onlineSocket.removeEventListener(GetSceneUserRes.GET_SCENE_INFO,getUserInfoFun);
         GV.onlineSocket.removeEventListener("read_" + 1911,onRead_1911);
         GV.onlineSocket.removeEventListener("removeMapEvent",removeEvent);
         GV.onlineSocket.dispatchEvent(new EventTaomee("friendEvent"));
         HotUI.close_btn.removeEventListener(MouseEvent.CLICK,closePanel);
         HotUI.flower_btn.removeEventListener(MouseEvent.CLICK,sendflowerOrmud);
         HotUI.mud_btn.removeEventListener(MouseEvent.CLICK,sendflowerOrmud);
         HotUI = null;
      }
      
      public static function getFlowerAndHot() : void
      {
         var flowerreq:GetFlowersReq = new GetFlowersReq();
         GV.onlineSocket.addEventListener(GetFlowersRes.GET_FLOWERS_LIST,getFlowersInfo);
         flowerreq.sendreq(ID);
      }
      
      public static function getFlowersInfo(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(GetFlowersRes.GET_FLOWERS_LIST,getFlowersInfo);
         HotNum = e.EventObj.hot;
         FlowerNum = e.EventObj.flowers;
         MudNum = e.EventObj.mud;
         try
         {
            HomeView.getInstance().RootMC.btnMC.hot_txt.text = HotNum;
         }
         catch(e:Error)
         {
         }
         try
         {
            newHouseView.getInstance().RootMC.houseTool.hot_txt.text = HotNum;
         }
         catch(e:Error)
         {
         }
      }
      
      public static function sendflowerOrmud(e:MouseEvent) : void
      {
         var sendf:sendFlowersReq = null;
         if(!HomeView.ismyhome)
         {
            if(!sendBool)
            {
               sendf = new sendFlowersReq();
               GV.onlineSocket.addEventListener(sendFlowersRes.SEND_FLOWERS_MUD_SUCC,showSendResult);
               sendtype = e.currentTarget.name == "flower_btn" ? 1 : 2;
               if(hotID() == LocalUserInfo.getUserID())
               {
                  Alert.showAlert(MainManager.getAppLevel(),"","你只能為其他摩爾的小屋獻鮮花或者投泥巴哦！",Alert.IKNOW_ALERT);
               }
               else
               {
                  sendBool = true;
                  sendf.sendreq(hotID(),sendtype);
               }
               closeflowersPanel();
            }
            else
            {
               closeflowersPanel();
               Alert.showAlert(MainManager.getAppLevel(),"","你已經評價過這個小屋了，下次再來吧！",Alert.IKNOW_ALERT);
            }
         }
         else
         {
            closeflowersPanel();
            Alert.showAlert(MainManager.getAppLevel(),"","你只能為其他摩爾的小屋獻鮮花或者投泥巴哦！",Alert.IKNOW_ALERT);
         }
      }
      
      public static function showSendResult(e:EventTaomee) : void
      {
         var name:String = null;
         GV.onlineSocket.removeEventListener(sendFlowersRes.SEND_FLOWERS_MUD_SUCC,showSendResult);
         if(HomeHot._hotType == HomeHot.HOT_TYPE_HOME)
         {
            if(HomeView.InHome)
            {
               name = HomeView.UserName + "的家園";
            }
            else
            {
               name = newHouseView.houseName + "的家園";
            }
         }
         else if(HomeHot._hotType == HomeHot.HOT_TYPE_FARM)
         {
            name = FieldView.UserName + "的牧場";
         }
         if(sendtype == 1)
         {
            HotUI.flower_txt.text = int(HotUI.flower_txt.text) + 1;
            Alert.showAlert(MainManager.getAppLevel(),"","你成功為" + name + "的小屋獻了一朵花哦！",Alert.IKNOW_ALERT);
         }
         else
         {
            HotUI.mud_txt.text = int(HotUI.mud_txt.text) + 1;
            Alert.showAlert(MainManager.getAppLevel(),"","你成功為" + name + "的小屋獻了一個泥巴哦！",Alert.IKNOW_ALERT);
         }
      }
      
      public static function closeflowersPanel(e:MouseEvent = null) : void
      {
      }
      
      public static function closePanel(e:MouseEvent = null) : void
      {
         HotUI.y = 1000;
      }
      
      public static function showPanel() : void
      {
         getPlantAndFarmLV();
      }
      
      private static function getPlantAndFarmLV() : void
      {
         GV.onlineSocket.addEventListener("read_" + 1911,onRead_1911);
         homeSocket.queryPlantAndFarm(hotID());
      }
      
      private static function onRead_1911(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 1911,onRead_1911);
         plantNum = evt.EventObj.plantLV;
         farmNum = evt.EventObj.farmLV;
         plantLVMum = evt.EventObj.plantLVNum;
         farmLVNum = evt.EventObj.farmLVNum;
         loadUI();
      }
      
      private static function loadUI() : void
      {
         var plantProgressGoFrame:int = 0;
         var farmProgressGoFrame:int = 0;
         if(!HotUI)
         {
            mcloader = new MCLoader("module/home/HomeFlower.swf",MainManager.getGameLevel(),1,"正在打開家園熱度...");
            mcloader.addEventListener(MCLoadEvent.ON_SUCCESS,loadSucc);
            mcloader.addEventListener(MCLoadEvent.ERROR,loadErr);
            mcloader.doLoad();
         }
         else
         {
            HotUI.plantTxt.text = plantNum;
            HotUI.farmTxt.text = farmNum;
            HotUI.plantLV.text = plantLVMum;
            HotUI.farmLV.text = farmLVNum;
            HotUI.plantTitleTxt.text = checkTitle(plantLVMum,1);
            HotUI.farmTitleTxt.text = checkTitle(farmLVNum,2);
            HotUI.plantImage.gotoAndStop(int(plantLVMum / 5) + 1);
            HotUI.farmImage.gotoAndStop(int(farmLVNum / 5) + 1);
            HotUI.plantProgressTxt.text = plantNum + "/" + showProgress(plantLVMum);
            plantProgressGoFrame = plantNum / (showProgress(plantLVMum) / HotUI.plantProgress.totalFrames);
            HotUI.plantProgress.gotoAndStop(plantProgressGoFrame);
            HotUI.farmProgressTxt.text = farmNum + "/" + showProgress(farmLVNum);
            farmProgressGoFrame = farmNum / (showProgress(farmLVNum) / HotUI.farmProgress.totalFrames);
            HotUI.farmProgress.gotoAndStop(farmProgressGoFrame);
            HotUI.x = 320;
            HotUI.y = 92;
            if(_hotType == HOT_TYPE_HOME)
            {
               GuestList.getInstance().showPanel();
            }
            else if(_hotType == HOT_TYPE_FARM)
            {
               FieldGuestList.getInstance().showPanel();
            }
         }
      }
      
      private static function loadErr(event:MCLoadEvent) : void
      {
         trace("加載出錯");
      }
      
      private static function loadSucc(event:MCLoadEvent) : void
      {
         arrMC = new Array();
         ScrollBar = null;
         VisitorArr = new Array();
         sendBool = false;
         GV.onlineSocket.addEventListener("removeMapEvent",removeEvent);
         var a:DisplayObjectContainer = event.getParent();
         var b:Loader = event.getLoader();
         HotUIClass = b.contentLoaderInfo.applicationDomain.getDefinition("hot_UI") as Class;
         ListUIClass = b.contentLoaderInfo.applicationDomain.getDefinition("list_UI") as Class;
         Man = b.contentLoaderInfo.applicationDomain.getDefinition("man") as Class;
         HotUI = new HotUIClass();
         ListUI = new ListUIClass();
         HotUI.y = 1000;
         ListUI.y = 1000;
         if(HomeHot._hotType == HomeHot.HOT_TYPE_HOME)
         {
            if(HomeView.InHome)
            {
               HotUI.name_txt.text = HomeView.UserName + "的家園";
            }
            else
            {
               HotUI.name_txt.text = newHouseView.houseName + "的家園";
            }
         }
         else if(HomeHot._hotType == HomeHot.HOT_TYPE_FARM)
         {
            HotUI.name_txt.text = FieldView.UserName + "的牧場";
         }
         HotUI.flower_txt.text = FlowerNum;
         HotUI.mud_txt.text = MudNum;
         HotUI.plantTxt.text = plantNum;
         HotUI.farmTxt.text = farmNum;
         HotUI.plantLV.text = plantLVMum;
         HotUI.farmLV.text = farmLVNum;
         HotUI.plantTitleTxt.text = checkTitle(plantLVMum,1);
         HotUI.farmTitleTxt.text = checkTitle(farmLVNum,2);
         HotUI.plantImage.gotoAndStop(int(plantLVMum / 5) + 1);
         HotUI.farmImage.gotoAndStop(int(farmLVNum / 5) + 1);
         HotUI.plantProgressTxt.text = plantNum + "/" + showProgress(plantLVMum);
         var plantProgressGoFrame:int = plantNum / (showProgress(plantLVMum) / HotUI.plantProgress.totalFrames);
         HotUI.plantProgress.gotoAndStop(plantProgressGoFrame);
         HotUI.farmProgressTxt.text = farmNum + "/" + showProgress(farmLVNum);
         var farmProgressGoFrame:int = farmNum / (showProgress(farmLVNum) / HotUI.farmProgress.totalFrames);
         HotUI.farmProgress.gotoAndStop(farmProgressGoFrame);
         GV.onlineSocket.addEventListener(GetSceneUserRes.GET_SCENE_INFO,getUserInfoFun);
         new GetSceneUserInfoReq().getSeceeUserInfo(hotID());
         HotUI.close_btn.addEventListener(MouseEvent.CLICK,closePanel);
         HotUI.flower_btn.addEventListener(MouseEvent.CLICK,sendflowerOrmud);
         HotUI.mud_btn.addEventListener(MouseEvent.CLICK,sendflowerOrmud);
         HotUI.x = 320;
         HotUI.y = 92;
         MainManager.getAppLevel().addChild(HotUI);
         MainManager.getAppLevel().addChild(ListUI);
         var mcloader:MCLoader = event.target as MCLoader;
         mcloader.clear();
         if(_hotType == HOT_TYPE_HOME)
         {
            GuestList.getInstance().showPanel();
         }
         else if(_hotType == HOT_TYPE_FARM)
         {
            FieldGuestList.getInstance().showPanel();
         }
      }
      
      private static function getUserInfoFun(E:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(GetSceneUserRes.GET_SCENE_INFO,getUserInfoFun);
         var userInfo:* = E.EventObj;
         new prevView(HotUI.headImage.mole,userInfo.Color.toString(16),userInfo.itemArr,userInfo);
      }
      
      public static function checkTitle(temp:uint, type:uint) : String
      {
         var retStr:String = "";
         if(int(temp / 5) == 0)
         {
            if(type == 1)
            {
               retStr = "花園幫手";
            }
            else if(type == 2)
            {
               retStr = "牧場幫手";
            }
         }
         else if(int(temp / 5) == 1)
         {
            if(type == 1)
            {
               retStr = "花園小匠";
            }
            else if(type == 2)
            {
               retStr = "實習牧場主";
            }
         }
         else if(int(temp / 5) == 2)
         {
            if(type == 1)
            {
               retStr = "花園工匠";
            }
            else if(type == 2)
            {
               retStr = "優秀牧場主";
            }
         }
         else if(int(temp / 5) >= 3)
         {
            if(type == 1)
            {
               retStr = "花園巧匠";
            }
            else if(type == 2)
            {
               retStr = "超級牧場主";
            }
         }
         return retStr;
      }
      
      public static function showProgress(tempNum:int) : int
      {
         var xyz:int = 0;
         for(var i:int = 1; i < tempNum + 1; i++)
         {
            xyz += i * 100;
         }
         return xyz;
      }
   }
}

