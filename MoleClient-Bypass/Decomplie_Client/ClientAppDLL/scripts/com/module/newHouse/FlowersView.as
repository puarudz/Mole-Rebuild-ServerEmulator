package com.module.newHouse
{
   import com.common.Alert.*;
   import com.common.view.MCScrollBar.MCScrollBar;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.getFrendList.GetVisitorReq;
   import com.logic.socket.getFrendList.GetVisitorRes;
   import com.logic.socket.getFrendList.sendFlowersReq;
   import com.logic.socket.getFrendList.sendFlowersRes;
   import com.view.userPanelView.userPanelView;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class FlowersView extends MovieClip
   {
      
      public static var RootMC:MovieClip;
      
      public static var houseTool:MovieClip;
      
      public static var visitorPanel:MovieClip;
      
      public static var flowersPanel:MovieClip;
      
      public static var Obj:Object;
      
      public static var VisitorArr:Array;
      
      public static var panelbool:Boolean;
      
      private static var Man:Class;
      
      private static var sendtype:uint;
      
      private static var len:uint;
      
      private static var sendBool:Boolean;
      
      private static var ScrollBar:*;
      
      private static var myTimeout:*;
      
      private static var MC:MovieClip;
      
      private static var arrMC:Array = new Array();
      
      public static var myObj:Object = {
         0:0,
         1:1,
         2:2,
         3:3,
         4:4,
         5:5,
         6:6,
         7:7,
         8:8,
         9:9,
         "a":10,
         "b":11,
         "c":12,
         "d":13,
         "e":14,
         "f":15
      };
      
      public function FlowersView()
      {
         super();
      }
      
      public static function init(mc:MovieClip, obj:Object) : void
      {
         if(!panelbool)
         {
            arrMC = new Array();
            Man = GV.Lib_Map.getClass("man");
            GV.onlineSocket.addEventListener("removeMapEvent",removeHandler);
            panelbool = true;
            Obj = obj;
            RootMC = mc;
            houseTool = RootMC.houseTool;
            houseTool.visible = true;
            if(GV.MapInfo_mapID != LocalUserInfo.getUserID())
            {
               houseTool.depot_mc.visible = false;
               houseTool.lock_mc.visible = false;
               houseTool.book_mc.visible = false;
               houseTool.edit_mc.visible = false;
            }
            houseTool.hotHouse.hot.text = Obj.hot;
            houseTool.flowers_mc.flowers.text = Obj.flowers;
            houseTool.flowers_mc.mud.text = Obj.mud;
            houseTool.hotHouse.btn.addEventListener(MouseEvent.CLICK,OpenVisitor);
            houseTool.hotHouse.btn.addEventListener(MouseEvent.MOUSE_OVER,goto2);
            houseTool.hotHouse.btn.addEventListener(MouseEvent.MOUSE_OUT,goto1);
            houseTool.flowers_mc.btn.addEventListener(MouseEvent.CLICK,OpenFlowers);
            houseTool.flowers_mc.btn.addEventListener(MouseEvent.MOUSE_OVER,goto2);
            houseTool.flowers_mc.btn.addEventListener(MouseEvent.MOUSE_OUT,goto1);
            flowersPanel = RootMC.flower_mud;
            MainManager.getGameLevel().addChild(flowersPanel);
            flowersPanel.close_btn.addEventListener(MouseEvent.CLICK,closeflowersPanel);
            flowersPanel.flower_btn.addEventListener(MouseEvent.CLICK,sendflowerOrmud);
            flowersPanel.mud_btn.addEventListener(MouseEvent.CLICK,sendflowerOrmud);
         }
      }
      
      public static function OpenVisitor(e:Event) : void
      {
         var visitorReq:GetVisitorReq = null;
         if(!visitorPanel)
         {
            visitorReq = new GetVisitorReq();
            GV.onlineSocket.addEventListener(GetVisitorRes.GET_VISITOR_LIST,showVisitor);
            visitorReq.sendreq(GV.MapInfo_mapID);
         }
         else
         {
            visitorPanel.x = 94;
         }
      }
      
      public static function showVisitor(e:EventTaomee) : void
      {
         var i:uint = 0;
         GV.onlineSocket.removeEventListener(GetVisitorRes.GET_VISITOR_LIST,showVisitor);
         visitorPanel = RootMC.visitor_panel;
         MainManager.getAppLevel().addChild(visitorPanel);
         visitorPanel.drag_mc.addEventListener(MouseEvent.MOUSE_DOWN,drag_start);
         visitorPanel.drag_mc.addEventListener(MouseEvent.MOUSE_UP,drag_stop);
         visitorPanel.drag_mc.addEventListener(MouseEvent.MOUSE_MOVE,drag_move);
         visitorPanel.close_btn.addEventListener(MouseEvent.CLICK,closeMC);
         visitorPanel.bg_mc.height = 265;
         MC = visitorPanel.visitorUI;
         VisitorArr = e.EventObj.arr;
         len = VisitorArr.length;
         if(len > 7)
         {
            for(i = 0; i < len; i++)
            {
               initMan(VisitorArr[i],false);
            }
            initScrollBar();
         }
         else
         {
            for(i = 0; i < len; i++)
            {
               initMan(VisitorArr[i],false);
            }
            initScrollBar();
         }
         visitorPanel.x = 94;
         visitorPanel.y = 110;
      }
      
      public static function sendflowerOrmud(e:MouseEvent) : void
      {
         var sendf:sendFlowersReq = null;
         trace(LocalUserInfo.getUserID(),GV.MapInfo_mapID);
         if(LocalUserInfo.getUserID() != GV.MapInfo_mapID)
         {
            if(!sendBool)
            {
               sendf = new sendFlowersReq();
               sendBool = true;
               GV.onlineSocket.addEventListener(sendFlowersRes.SEND_FLOWERS_MUD_SUCC,showSendResult);
               sendtype = e.currentTarget.name == "flower_btn" ? 1 : 2;
               sendf.sendreq(GV.MapInfo_mapID,sendtype);
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
         GV.onlineSocket.removeEventListener(sendFlowersRes.SEND_FLOWERS_MUD_SUCC,showSendResult);
         if(sendtype == 1)
         {
            houseTool.flowers_mc.flowers.text = int(houseTool.flowers_mc.flowers.text) + 1;
            Alert.showAlert(MainManager.getAppLevel(),"","你成功為" + GV.Room_Name + "的小屋獻了一朵花哦！",Alert.IKNOW_ALERT);
         }
         else
         {
            houseTool.flowers_mc.mud.text = int(houseTool.flowers_mc.mud.text) + 1;
            Alert.showAlert(MainManager.getAppLevel(),"","你成功為" + GV.Room_Name + "的小屋獻了一個泥巴哦！",Alert.IKNOW_ALERT);
         }
      }
      
      public static function closeflowersPanel(e:MouseEvent = null) : void
      {
         flowersPanel.x = -1000;
      }
      
      public static function closeMC(e:MouseEvent) : void
      {
         visitorPanel.x = -1000;
      }
      
      public static function initMan(manInfo:Object, bool:*) : void
      {
         var temp:Object = new Man();
         temp.visible = false;
         temp.prev_pet.visible = false;
         temp.id = manInfo.UserID;
         temp.name = "mc" + temp.id;
         temp.userName.text = manInfo.Nick;
         var date:Date = new Date(manInfo.Time * 1000);
         temp.time.text = date.getFullYear() + "/" + int(date.getMonth() + 1) + "/" + date.getDate();
         date = null;
         temp.head_btn.addEventListener(MouseEvent.CLICK,showFriendPanel);
         temp.Color = Number(manInfo.Color);
         var colorObj:Array = getPrimitiveColors(temp.Color.toString(16));
         temp.prev_mc.pv_color.pv_color.transform.colorTransform = new ColorTransform(colorObj[0] / 256,colorObj[1] / 256,colorObj[2] / 256,1);
         arrMC.push(temp);
         MC.manMC.addChild(temp);
      }
      
      private static function showFriendPanel(evt:MouseEvent) : void
      {
         userPanelView.showUserPanel(evt.target.parent.id);
      }
      
      public static function getPrimitiveColors(colorStr:String) : Array
      {
         var tempStr:String = null;
         var A:String = null;
         var B:String = null;
         var a:String = colorStr;
         if(a.indexOf("#") > -1)
         {
            a = a.slice(1);
         }
         while(a.length < 6)
         {
            a = "0" + a;
         }
         a = a.toLocaleLowerCase();
         var tempArray:Array = [];
         for(var i:uint = 0; i < 6; i += 2)
         {
            tempStr = a.substr(i,2);
            A = tempStr.substr(0,1);
            B = tempStr.substr(1,1);
            tempArray.push(myObj[A] * 16 + myObj[B]);
         }
         return tempArray;
      }
      
      public static function initScrollBar() : void
      {
         var i:int = 0;
         if(len > 7)
         {
            arrange(arrMC);
            MC.scroll_mc.visible = true;
            if(!ScrollBar)
            {
               ScrollBar = new MCScrollBar(MC.scroll_mc,MC.manMC,178,253);
            }
            else
            {
               ScrollBar.reSet();
            }
            MC.scroll_mc.drag_mc.visible = true;
            MC.scroll_mc.line_mc.visible = true;
         }
         else
         {
            for(i = int(len); i < 7; i++)
            {
               addBG();
            }
            MC.scroll_mc.drag_mc.visible = false;
            MC.scroll_mc.line_mc.visible = false;
            arrange(arrMC);
         }
      }
      
      public static function addBG() : void
      {
         var temp:Object = new Man();
         temp.time.visible = false;
         temp.userName.text = "";
         temp.prev_mc.visible = false;
         temp.prev_pet.visible = false;
         arrMC.push(temp);
         MC.manMC.addChild(temp);
      }
      
      public static function arrange(arr:Array) : void
      {
         for(var k:uint = 0; k < arr.length; k++)
         {
            arr[k].y = 36 * k;
            arr[k].visible = true;
         }
      }
      
      public static function OpenFlowers(e:Event) : void
      {
         if(LocalUserInfo.getUserID() != GV.MapInfo_mapID)
         {
            flowersPanel.x = 300;
            flowersPanel.y = 200;
         }
         else
         {
            closeflowersPanel();
            Alert.showAlert(MainManager.getAppLevel(),"","你只能為其他摩爾的小屋獻鮮花或者投泥巴哦！",Alert.IKNOW_ALERT);
         }
      }
      
      public static function showFlowers(e:EventTaomee) : void
      {
      }
      
      public static function removeHandler(e:Event) : void
      {
         sendBool = false;
         panelbool = false;
         if(Boolean(visitorPanel))
         {
            visitorPanel.drag_mc.removeEventListener(MouseEvent.MOUSE_DOWN,drag_start);
            visitorPanel.drag_mc.removeEventListener(MouseEvent.MOUSE_UP,drag_stop);
            visitorPanel.drag_mc.removeEventListener(MouseEvent.MOUSE_MOVE,drag_move);
            visitorPanel.close_btn.removeEventListener(MouseEvent.CLICK,closeMC);
         }
         visitorPanel = null;
         ScrollBar = null;
         GV.onlineSocket.dispatchEvent(new EventTaomee("friendEvent"));
         GV.onlineSocket.removeEventListener("removeMapEvent",removeHandler);
         houseTool.hotHouse.btn.removeEventListener(MouseEvent.CLICK,OpenVisitor);
         houseTool.flowers_mc.btn.removeEventListener(MouseEvent.CLICK,OpenFlowers);
         flowersPanel.close_btn.removeEventListener(MouseEvent.CLICK,closeflowersPanel);
         flowersPanel.flower_btn.removeEventListener(MouseEvent.CLICK,sendflowerOrmud);
         flowersPanel.mud_btn.removeEventListener(MouseEvent.CLICK,sendflowerOrmud);
         houseTool.hotHouse.btn.removeEventListener(MouseEvent.MOUSE_OVER,goto2);
         houseTool.hotHouse.btn.removeEventListener(MouseEvent.MOUSE_OUT,goto1);
         houseTool.flowers_mc.btn.removeEventListener(MouseEvent.MOUSE_OVER,goto2);
         houseTool.flowers_mc.btn.removeEventListener(MouseEvent.MOUSE_OUT,goto1);
      }
      
      public static function drag_start(evt:MouseEvent) : void
      {
         visitorPanel.startDrag();
      }
      
      public static function drag_stop(evt:MouseEvent) : void
      {
         visitorPanel.stopDrag();
      }
      
      public static function drag_move(evt:MouseEvent) : void
      {
         evt.updateAfterEvent();
      }
      
      public static function goto2(e:Event) : void
      {
         showtip(e.target.parent);
         e.target.parent.gotoAndStop(2);
      }
      
      public static function goto1(e:Event) : void
      {
         cleartip();
         e.target.parent.gotoAndStop(1);
      }
      
      public static function showtip(mc:DisplayObject) : void
      {
         var btnName:String = null;
         btnName = mc.name;
         cleartip();
         myTimeout = setTimeout(function():void
         {
            switch(btnName)
            {
               case "flowers_mc":
                  GF.showTip("鮮花與泥巴",{
                     "x":920,
                     "y":270
                  });
                  break;
               case "hotHouse":
                  GF.showTip("熱度與腳印",{
                     "x":920,
                     "y":210
                  });
            }
         },300);
      }
      
      private static function cleartip() : void
      {
         if(myTimeout != null)
         {
            clearTimeout(myTimeout);
            GF.clearTip();
         }
      }
   }
}

