package com.module.activityModule
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.global.links.Links;
   import com.global.staticData.XMLInfo;
   import com.logic.socket.finishSomething.finishedSomethingReq;
   import com.logic.socket.finishSomething.finishedSomethingRes;
   import com.logic.socket.petSocket.adoptPet.petNumReq;
   import com.logic.socket.petSocket.adoptPet.petNumRes;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.*;
   
   public class giftModule
   {
      
      public static var iconMC:MovieClip;
      
      public static var giftTip:MovieClip;
      
      public static var tempLoad:Loader;
      
      public static var infoArr:Array;
      
      public static var type:Number;
      
      public static var succMsg:String;
      
      private static var thisAlter:Object;
      
      public static var giftData:String = "giftData";
      
      public static var isPet:Boolean = false;
      
      public function giftModule()
      {
         super();
      }
      
      public static function giftHandler(typeNum:Number, str:String, giftInfo:String) : void
      {
         var tipMC:Class = null;
         GV.onlineSocket.addEventListener("removeMapEvent",removeAllEvent);
         type = typeNum;
         if(tempLoad == null)
         {
            tempLoad = new Loader();
         }
         if(!GV.MC_AppLever.getChildByName("giftTip"))
         {
            tempLoad.unload();
            tempLoad.load(VL.getURLRequest(Links.getUrl(str)));
            tipMC = GV.Lib_Map.getClass("giftTip") as Class;
            giftTip = new tipMC();
            giftTip.name = "giftTip";
            GV.MC_AppLever.addChild(giftTip);
            giftTip.x = (GV.stageWidth - giftTip.width) / 2;
            giftTip.y = (GV.stageHeight - giftTip.height) / 2;
            giftTip.mc_load.addChild(tempLoad);
            giftTip.mc_load.scaleX = 1.5;
            giftTip.mc_load.scaleY = 1.5;
            giftTip.mc_load.x = 110;
            giftTip.mc_load.y = 41.2;
            giftTip.info.text = giftInfo;
            giftTip.enter_btn.addEventListener(MouseEvent.CLICK,ClickHandler);
            giftTip.cancel_btn.addEventListener(MouseEvent.CLICK,CancelHandler);
         }
      }
      
      public static function giftHandlerNew(typeNum:Number) : void
      {
         var dataObj:Object = null;
         GV.onlineSocket.addEventListener("removeMapEvent",removeAllEvent);
         dataObj = queryGiftModuleXML(typeNum);
         try
         {
            type = dataObj.type;
            succMsg = dataObj.succMsg;
            giftData = dataObj.giftData;
            isPet = dataObj.isPet;
         }
         catch(err:Error)
         {
            throw new Error("XMLInfo.giftModuleXML 數據錯誤！！！type = " + dataObj.type);
         }
         thisAlter = Alert.showAlert(MainManager.getGameLevel(),dataObj.sourcePath,dataObj.alertMsg,Alert.CHANG_ALERT,"sure,cancel",true,false,"EMP_BUY");
         thisAlter.addEventListener(Alert.CLICK_ + "1",ClickHandler);
         thisAlter.addEventListener(Alert.CLICK_ + "2",CancelHandler);
      }
      
      private static function queryGiftModuleXML(typeSign:Number) : Object
      {
         var retObj:Object = new Object();
         var thisXML:XML = XMLInfo.giftModuleXML;
         for(var xmlRound:int = 0; xmlRound < thisXML.item.length(); xmlRound++)
         {
            if(thisXML.item[xmlRound].@type == typeSign)
            {
               retObj.type = thisXML.item[xmlRound].@type;
               retObj.mapId = thisXML.item[xmlRound].@mapId;
               retObj.sourcePath = thisXML.item[xmlRound].@sourcePath;
               retObj.alertMsg = thisXML.item[xmlRound].@alertMsg;
               retObj.succMsg = thisXML.item[xmlRound].@succMsg;
               retObj.giftData = thisXML.item[xmlRound].@giftData;
               retObj.isPet = thisXML.item[xmlRound].@isPet;
               trace("****************" + xmlRound + "*********************");
               trace(thisXML.item[xmlRound].@type + "對比：" + retObj.type);
               trace(thisXML.item[xmlRound].@mapId + "對比：" + retObj.mapId);
               trace(thisXML.item[xmlRound].@sourcePath + "對比：" + retObj.sourcePath);
               trace(thisXML.item[xmlRound].@alertMsg + "對比：" + retObj.alertMsg);
               trace(thisXML.item[xmlRound].@succMsg + "對比：" + retObj.succMsg);
               trace(thisXML.item[xmlRound].@giftData + "對比：" + retObj.giftData);
               trace(thisXML.item[xmlRound].@isPet + "對比：" + retObj.isPet);
               trace("*****************" + xmlRound + "********************");
            }
         }
         return retObj;
      }
      
      public static function ClickHandler(evt:*) : void
      {
         if(type == 100)
         {
            CancelHandler();
            return;
         }
         if(!isPet)
         {
            GV.onlineSocket.addEventListener(petNumRes.GET_PETNUM_SUCC,getPetCount);
            petNumReq.sendNumReq(GV.MyInfo_userID);
         }
         else
         {
            checkItemHandler();
         }
         isPet = false;
      }
      
      private static function getPetCount(evt:EventTaomee) : void
      {
         var msgTemp:String = null;
         GV.onlineSocket.removeEventListener(petNumRes.GET_PETNUM_SUCC,getPetCount);
         if(evt.EventObj.Count >= 1)
         {
            checkItemHandler();
         }
         else
         {
            CancelHandler();
            msgTemp = "目前你還沒有拉姆\n暫時還不能領取哦！";
            GF.showAlert(GV.MC_AppLever,msgTemp,"",100,"iknow",true,false,"E");
         }
      }
      
      public static function checkItemHandler() : void
      {
         CancelHandler();
         GV.onlineSocket.addEventListener(finishedSomethingRes.FINISHED_SOMETHING_SUCC,giftSucHandler);
         finishedSomethingReq.sendReq(type);
      }
      
      private static function CancelHandler(evt:* = null) : void
      {
         if(thisAlter != null)
         {
            thisAlter.removeEventListener(Alert.CLICK_ + "1",ClickHandler);
            thisAlter.removeEventListener(Alert.CLICK_ + "2",CancelHandler);
         }
         if(giftTip != null)
         {
            giftTip.enter_btn.removeEventListener(MouseEvent.CLICK,ClickHandler);
            giftTip.cancel_btn.removeEventListener(MouseEvent.CLICK,CancelHandler);
            GC.clearAllChildren(giftTip);
            giftTip.parent.removeChild(giftTip);
            giftTip = null;
         }
         if(tempLoad != null)
         {
            tempLoad.unload();
         }
      }
      
      private static function giftSucHandler(evt:EventTaomee) : void
      {
         var itemID:int = 0;
         var addr:String = null;
         var msg:String = null;
         GV.onlineSocket.removeEventListener(finishedSomethingRes.FINISHED_SOMETHING_SUCC,giftSucHandler);
         if(evt.EventObj.count == 0)
         {
            GF.showAlert(GV.MC_AppLever,"不能太貪心哦，你已經拿過了^_^","",100,"iknow",true,false,"E");
            return;
         }
         if(evt.EventObj.type > 100)
         {
            itemID = int(evt.EventObj.arr[0].ItemID);
            addr = GF.getItemName(itemID).@Name;
            msg = addr + "已經放入你的投擲箱中";
            GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
            return;
         }
         GF.showAlert(GV.MC_AppLever,succMsg,"",100,"iknow",true,false,"E");
      }
      
      private static function removeAllEvent(evt:EventTaomee) : void
      {
         if(thisAlter != null)
         {
            thisAlter.removeEventListener(Alert.CLICK_ + "1",ClickHandler);
            thisAlter.removeEventListener(Alert.CLICK_ + "2",CancelHandler);
         }
         if(giftTip != null)
         {
            CancelHandler();
         }
         GV.onlineSocket.removeEventListener(finishedSomethingRes.FINISHED_SOMETHING_SUCC,giftSucHandler);
         GV.onlineSocket.removeEventListener("removeMapEvent",removeAllEvent);
      }
   }
}

