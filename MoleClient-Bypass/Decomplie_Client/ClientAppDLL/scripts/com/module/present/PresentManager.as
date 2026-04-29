package com.module.present
{
   import com.common.Alert.Alert;
   import com.common.view.MCScrollBar.MCScrollBarPresent;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.global.staticData.XMLInfo;
   import com.logic.socket.lookBag.LookBagReq;
   import com.logic.socket.lookBag.LookBagRes;
   import com.logic.socket.presentGoods.PresentGoodsReq;
   import com.logic.socket.presentGoods.PresentGoodsRes;
   import com.module.friendList.friendView.FView;
   import com.view.toolView.toolView;
   import com.view.userPanelView.userPanelView;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   
   public class PresentManager
   {
      
      private static var ID:uint;
      
      private static var Type:uint;
      
      private static var Arr:Array;
      
      private static var PresentObj:Object;
      
      private static var mcloader:MCLoader;
      
      private static var Panel:*;
      
      private static var FindReq:LookBagReq;
      
      private static var FindArr:Array;
      
      private static var MyNeedNum:Array;
      
      private static var MC:*;
      
      private static var VisitorArr:Array;
      
      private static var len:uint;
      
      private static var Man:Class;
      
      private static var arrMC:Array;
      
      private static var ScrollBar:MCScrollBarPresent;
      
      private static var SelectMC:MovieClip;
      
      private static var Path:String = "resource/allJob/icon/";
      
      public static var showFriendPanelBool:Boolean = true;
      
      private static var myObj:Object = {
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
      
      private static var _maxCount:int = 1;
      
      private static var _countCount:int = 1;
      
      public function PresentManager()
      {
         super();
      }
      
      public static function maxCount(val:int) : void
      {
         _maxCount = val;
      }
      
      public static function init(id:uint) : void
      {
         var o:Object = null;
         var tempXML:XML = null;
         var len:uint = 0;
         var i:uint = 0;
         var obj:Object = null;
         if(!Panel)
         {
            BC.addEvent(PresentManager,GV.onlineSocket,PresentGoodsRes.PRESENT_FRIEND_GOODS_SUCC,sendSucc);
            BC.addEvent(PresentManager,GV.onlineSocket,"removeMapEvent",removeHandler);
            ID = id;
            if(Boolean(Arr))
            {
               PresentObj = Arr[ID];
            }
            else
            {
               Arr = new Array();
               tempXML = XMLInfo.PresentXML;
               len = uint(tempXML.children().length());
               for(i = 0; i < len; i++)
               {
                  obj = new Object();
                  obj.ID = tempXML.Item[i]["ID"];
                  obj.Type = tempXML.Item[i]["Type"];
                  obj.Name = tempXML.Item[i]["Name"];
                  obj.Path = tempXML.Item[i]["Path"];
                  obj.NeedID = tempXML.Item[i]["NeedID"].split(",");
                  obj.NeedName = tempXML.Item[i]["NeedName"];
                  obj.NeedNum = tempXML.Item[i]["NeedNum"].split(",");
                  obj.Info = tempXML.Item[i]["Info"];
                  Arr[obj.ID] = obj;
               }
               PresentObj = Arr[ID];
            }
            o = PresentObj;
            Type = PresentObj.Type;
            mybagReq();
         }
         else
         {
            closePanel();
            init(id);
         }
      }
      
      private static function loadUI() : void
      {
         var url:String = null;
         if(!Panel)
         {
            url = "module/Present/Present.swf";
            if(LocalUserInfo.getMapID() != 76)
            {
               url = "module/Present/PresentFarm.swf";
            }
            mcloader = new MCLoader(url,MainManager.getGameLevel(),1,"打開禮物贈送面板");
            mcloader.addEventListener(MCLoadEvent.ON_SUCCESS,loadSucc);
            mcloader.addEventListener(MCLoadEvent.ERROR,loadErr);
            mcloader.doLoad();
         }
         else
         {
            initPanel();
         }
      }
      
      private static function loadErr(event:MCLoadEvent) : void
      {
         trace("加載出錯");
      }
      
      private static function loadSucc(event:MCLoadEvent) : void
      {
         var a:DisplayObjectContainer = event.getParent();
         var b:Loader = event.getLoader();
         Man = b.contentLoaderInfo.applicationDomain.getDefinition("man") as Class;
         var c:DisplayObject = event.getContent();
         var root:DisplayObject = c;
         Panel = root["Panel"];
         MainManager.getGameLevel().addChild(Panel);
         var mcloader:MCLoader = event.target as MCLoader;
         mcloader.clear();
         initPanel();
      }
      
      private static function mybagReq() : void
      {
         FindReq = new LookBagReq();
         BC.addEvent(PresentManager,GV.onlineSocket,LookBagRes.BAG_OVER,getFindArr);
         FindReq.lookBag(GV.MyInfo_userID,128,0);
      }
      
      private static function closePanel(e:Event = null) : void
      {
         Panel.x = 1000;
         GV.onlineSocket.dispatchEvent(new EventTaomee("post_card_close"));
         removeHandler();
      }
      
      private static function sendSucc(e:EventTaomee) : void
      {
         MyNeedNum[0] -= PresentObj.NeedNum[0];
         MyNeedNum[1] -= PresentObj.NeedNum[1];
         MyNeedNum[2] -= PresentObj.NeedNum[2];
         updateMyGoods();
         var obj:Object = e.EventObj;
         LocalUserInfo.setCharm(LocalUserInfo.getCharm() + 2);
         if(obj.getItemID == 190460)
         {
            maxCount(_maxCount - _countCount);
            if(Boolean(Panel.num_mc))
            {
               Panel.num_mc["max"] = _maxCount;
            }
            Alert.showAlert(MainManager.getGameLevel(),"","恭喜你獲得" + int(2 * _countCount) + "點魅力值，還額外得到了一張友誼券哦，趕快抽取幸運大獎吧！",Alert.IKNOW_ALERT);
         }
         else
         {
            Alert.showAlert(MainManager.getGameLevel(),"","恭喜你，得到了" + int(2 * _countCount) + "點魅力值！禮品已經送出去了哦！願你們的友誼長存！",Alert.IKNOW_ALERT);
         }
      }
      
      private static function sendPresent(e:MouseEvent) : void
      {
         var sendid:uint = 0;
         var namearr:Array = null;
         var str:String = null;
         var i:uint = 0;
         if(MyNeedNum[0] >= PresentObj.NeedNum[0] && MyNeedNum[1] >= PresentObj.NeedNum[1] && MyNeedNum[2] >= PresentObj.NeedNum[2])
         {
            sendid = uint(Panel.userid_txt.text);
            if(isNaN(Panel.userid_txt.text))
            {
               if(Panel.userid_txt.text == "輸入米米號：")
               {
                  Alert.showAlert(MainManager.getGameLevel(),"","你還沒有選擇要贈送的好友哦！",Alert.IKNOW_ALERT);
               }
               else
               {
                  if(Boolean(SelectMC))
                  {
                     SelectMC.gotoAndStop(1);
                  }
                  Alert.showAlert(MainManager.getGameLevel(),"","請輸入正確的米米號!",Alert.IKNOW_ALERT);
               }
            }
            else
            {
               sendid = uint(Panel.userid_txt.text);
               if(sendid >= 50000 && sendid <= GV.userIDLimit)
               {
                  if(Panel.msg.text == "請在這輸入祝福語!")
                  {
                     Panel.msg.text = "";
                  }
                  if(LocalUserInfo.getUserID() == sendid)
                  {
                     Alert.showAlert(MainManager.getGameLevel(),"","只能贈送給別人禮品哦!",Alert.IKNOW_ALERT);
                     return;
                  }
                  if(LocalUserInfo.getMapID() != 76)
                  {
                     _countCount = Panel.num_mc["value"];
                     PresentGoodsReq.PresentToFirend(Type,Panel.msg.text,sendid,_countCount);
                  }
                  else
                  {
                     PresentGoodsReq.PresentToFirend(Type,Panel.msg.text,sendid);
                  }
               }
               else
               {
                  Alert.showAlert(MainManager.getGameLevel(),"","請輸入正確的米米號!",Alert.IKNOW_ALERT);
               }
            }
         }
         else
         {
            namearr = PresentObj.NeedName.split(",");
            str = "";
            for(i = 0; i < 3; i++)
            {
               if(uint(PresentObj.NeedNum[i]) != 0)
               {
                  str += PresentObj.NeedNum[i] + "個" + namearr[i];
                  if(i != 2)
                  {
                     str += ",";
                  }
               }
            }
            if(LocalUserInfo.getMapID() != 76)
            {
               Alert.showAlert(MainManager.getGameLevel(),"","    嘿！你現在沒有這種禮品可以贈送了！",Alert.IKNOW_ALERT);
               return;
            }
            Alert.showAlert(MainManager.getGameLevel(),"","嘿！你的材料好像不夠哦！合成" + PresentObj.Name + "需要" + str + "。",Alert.IKNOW_ALERT);
         }
      }
      
      private static function initPanel() : void
      {
         loadIcon();
         updateMyGoods();
         Panel.x = 100;
         Panel.y = 60;
         BC.addEvent(PresentManager,Panel.userid_txt,Event.CHANGE,changeUserid);
         BC.addEvent(PresentManager,Panel.userid_txt,FocusEvent.FOCUS_IN,focusInUserid);
         BC.addEvent(PresentManager,Panel.msg,FocusEvent.FOCUS_IN,focusInHandler);
         BC.addEvent(PresentManager,Panel.close_btn,MouseEvent.CLICK,closePanel);
         BC.addEvent(PresentManager,Panel.cancel_btn,MouseEvent.CLICK,closePanel);
         BC.addEvent(PresentManager,Panel.send_btn,MouseEvent.CLICK,sendPresent);
         Panel.pname_txt.text = PresentObj.Name;
         Panel.pinfo_txt.text = PresentObj.Info;
         Panel.pneed_txt.text = "需要以下物品：" + PresentObj.NeedName;
         GV.onlineSocket.dispatchEvent(new EventTaomee("post_card_close"));
         showFriendPanelBool = false;
         BC.addEvent(PresentManager,GV.onlineClass,"post_card_fview",FriendInfo);
         toolView.getInstance().showFriend();
      }
      
      private static function changeUserid(event:Event) : void
      {
         if(Boolean(SelectMC))
         {
            SelectMC.gotoAndStop(1);
         }
      }
      
      private static function focusInUserid(event:FocusEvent) : void
      {
         Panel.userid_txt.text = "";
      }
      
      private static function focusInHandler(event:FocusEvent) : void
      {
         Panel.msg.text = "";
      }
      
      private static function updateMyGoods() : void
      {
         for(var i:uint = 0; i < 3; i++)
         {
            if(uint(PresentObj.NeedNum[i]) != 0)
            {
               Panel["num" + i].visible = true;
               Panel["num" + i].text = PresentObj.NeedNum[i] + "/" + MyNeedNum[i];
            }
            else
            {
               Panel["num" + i].visible = false;
            }
         }
      }
      
      private static function loadIcon() : void
      {
         var ll:Loader = null;
         var l:Loader = new Loader();
         l.load(VL.getURLRequest(PresentObj.Path + ID + ".swf"));
         Panel.picon.addChild(l);
         for(var i:uint = 0; i < 3; i++)
         {
            if(uint(PresentObj.NeedNum[i]) != 0)
            {
               Panel["pneed" + i].visible = true;
               ll = new Loader();
               ll.load(VL.getURLRequest(Path + PresentObj.NeedID[i] + ".swf"));
               Panel["pneed" + i].addChild(ll);
            }
            else
            {
               Panel["pneed" + i].visible = false;
            }
         }
      }
      
      private static function getFindArr(e:EventTaomee) : void
      {
         var i:uint = 0;
         var j:uint = 0;
         var namearr:Array = null;
         var str:String = null;
         BC.removeEvent(PresentManager,GV.onlineSocket,LookBagRes.BAG_OVER,getFindArr);
         trace(e);
         MyNeedNum = [0,0,0];
         FindArr = e.EventObj.obj.arr;
         for(i = 0; i < FindArr.length; i++)
         {
            for(j = 0; j < 3; j++)
            {
               if(PresentObj.NeedID[j] == FindArr[i].id)
               {
                  MyNeedNum[j] = FindArr[i].itemCount;
               }
            }
         }
         if(MyNeedNum[0] >= PresentObj.NeedNum[0] && MyNeedNum[1] >= PresentObj.NeedNum[1] && MyNeedNum[2] >= PresentObj.NeedNum[2])
         {
            loadUI();
         }
         else
         {
            namearr = PresentObj.NeedName.split(",");
            str = "";
            for(i = 0; i < 3; i++)
            {
               if(uint(PresentObj.NeedNum[i]) != 0)
               {
                  str += PresentObj.NeedNum[i] + "個" + namearr[i];
                  if(i != 2)
                  {
                     str += ",";
                  }
               }
            }
            if(LocalUserInfo.getMapID() != 76)
            {
               Alert.showAlert(MainManager.getGameLevel(),"","    嘿！你現在沒有這種綿羊可以贈送了！",Alert.IKNOW_ALERT);
               return;
            }
            Alert.showAlert(MainManager.getGameLevel(),"","嘿！你的材料好像不夠哦！合成" + PresentObj.Name + "需要" + str + "。",Alert.IKNOW_ALERT);
         }
      }
      
      private static function FriendInfo(e:Event) : void
      {
         var add_obj:Object = null;
         showFriendPanelBool = true;
         var fmc:DisplayObject = MainManager.getGameLevel().getChildByName("friendMC");
         if(Boolean(fmc))
         {
            fmc.visible = false;
         }
         arrMC = new Array();
         var obj:Object = {};
         obj.arr = new Array();
         var Arr:Array = FView.arrMC;
         for(var i:uint = 0; i < Arr.length; i++)
         {
            if(Arr[i].id == 1)
            {
               break;
            }
            add_obj = {};
            add_obj.UserID = Arr[i].id;
            add_obj.Color = Arr[i].Color;
            add_obj.Nick = Arr[i].userName.text;
            add_obj.Vip = Arr[i].vip;
            if(Boolean(Arr[i].online))
            {
               add_obj.Status = 1;
            }
            else
            {
               add_obj.Status = 3;
            }
            obj.arr.push(add_obj);
         }
         showVisitor(obj.arr);
      }
      
      private static function showVisitor(arr:Array) : void
      {
         var i:uint = 0;
         if(LocalUserInfo.getMapID() != 76)
         {
            Panel.bg_mc.height = 210;
            Panel.num_mc["max"] = _maxCount;
         }
         else
         {
            Panel.bg_mc.height = 265;
         }
         MC = Panel.visitorUI;
         VisitorArr = arr;
         len = VisitorArr.length;
         if(len > 6)
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
         updateOnlineMan();
      }
      
      public static function updateOnlineMan() : void
      {
         var userIDArray:Array = null;
         var i:uint = 0;
         var mc:Object = null;
         trace("在線的有",userIDArray);
         userIDArray = FView.userIDArray;
         if(Boolean(userIDArray))
         {
            for(i = 0; i < userIDArray.length; i++)
            {
               mc = MC.manMC.getChildByName("mc" + userIDArray[i]);
               if(Boolean(mc))
               {
                  showColor(mc);
                  mc.online = true;
               }
               else
               {
                  trace("顯示(friendsList)中沒這個人",userIDArray[i]);
               }
            }
            arrMC.sort(sortOnNum);
            reshowMan();
         }
      }
      
      public static function showColor(mc:Object) : void
      {
         mc.prev_pet.visible = true;
         mc.prev_mc.visible = true;
         mc.prev_mc.pv_color.visible = true;
         mc.prev_pet.pv_color.visible = true;
         var colorObj:Array = getPrimitiveColors(mc.Color.toString(16));
         if(Boolean(mc.vip))
         {
            mc.sortnum = 2;
            mc.prev_mc.visible = false;
            mc.prev_pet.pv_color.pv_color.transform.colorTransform = new ColorTransform(colorObj[0] / 256,colorObj[1] / 256,colorObj[2] / 256,1);
         }
         else
         {
            mc.sortnum = 4;
            mc.prev_pet.visible = false;
            mc.prev_mc.pv_color.pv_color.transform.colorTransform = new ColorTransform(colorObj[0] / 256,colorObj[1] / 256,colorObj[2] / 256,1);
         }
      }
      
      public static function sortOnNum(a:MovieClip, b:MovieClip) : Number
      {
         var aPrice:Number = Number(a.sortnum);
         var bPrice:Number = Number(b.sortnum);
         if(aPrice > bPrice)
         {
            return 1;
         }
         if(aPrice < bPrice)
         {
            return -1;
         }
         return 0;
      }
      
      public static function reshowMan() : void
      {
         for(var i:uint = 0; i < arrMC.length; i++)
         {
            arrMC[i].y = 36 * i;
         }
      }
      
      private static function changePlace(a:Point, b:Point) : void
      {
         var ay:Number = a.y;
         a.y = b.y;
         b.y = ay;
      }
      
      private static function initMan(manInfo:*, bool:Boolean) : void
      {
         var temp:Object = new Man();
         temp.visible = false;
         temp.prev_pet.visible = false;
         temp.prev_mc.pv_color.visible = false;
         temp.id = manInfo.UserID;
         temp.name = "mc" + temp.id;
         temp.userName.text = manInfo.Nick;
         temp.sortnum = 6;
         temp.head_btn.addEventListener(MouseEvent.CLICK,showFriendPanel);
         temp.select_btn.addEventListener(MouseEvent.CLICK,selectFriend);
         temp.Color = Number(manInfo.Color);
         var colorObj:Array = getPrimitiveColors(temp.Color.toString(16));
         temp.prev_mc.pv_color.pv_color.transform.colorTransform = new ColorTransform(colorObj[0] / 256,colorObj[1] / 256,colorObj[2] / 256,1);
         arrMC.push(temp);
         MC.manMC.addChild(temp);
      }
      
      private static function selectFriend(evt:MouseEvent) : void
      {
         if(Boolean(SelectMC))
         {
            SelectMC.gotoAndStop(1);
            if(evt.target.parent.select_mc == SelectMC)
            {
               SelectMC = null;
               Panel.userid_txt.text = "輸入米米號：";
               return;
            }
         }
         SelectMC = evt.target.parent.select_mc;
         SelectMC.gotoAndStop(2);
         Panel.userid_txt.text = evt.target.parent.id;
      }
      
      private static function showFriendPanel(evt:MouseEvent) : void
      {
         userPanelView.showUserPanel(evt.target.parent.id);
      }
      
      private static function getPrimitiveColors(colorStr:String) : Array
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
      
      private static function initScrollBar() : void
      {
         var i:uint = 0;
         if(len > 6)
         {
            arrange(arrMC);
            MC.scroll_mc.visible = true;
            if(!ScrollBar)
            {
               if(LocalUserInfo.getMapID() != 76)
               {
                  ScrollBar = new MCScrollBarPresent(MC.scroll_mc,MC.manMC,178,205);
               }
               else
               {
                  ScrollBar = new MCScrollBarPresent(MC.scroll_mc,MC.manMC,178,253);
               }
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
            for(i = len; i < 6; i++)
            {
               addBG();
            }
            MC.scroll_mc.drag_mc.visible = false;
            MC.scroll_mc.line_mc.visible = false;
            arrange(arrMC);
         }
      }
      
      private static function addBG() : void
      {
         var temp:* = new Man();
         temp.userName.text = "";
         temp.sortnum = 8;
         temp.prev_mc.visible = false;
         temp.prev_pet.visible = false;
         arrMC.push(temp);
         MC.manMC.addChild(temp);
      }
      
      private static function arrange(arr:Array) : void
      {
         for(var k:uint = 0; k < arr.length; k++)
         {
            arr[k].y = 36 * k;
            arr[k].visible = true;
         }
      }
      
      private static function removeHandler(e:Event = null) : void
      {
         _countCount = 1;
         _maxCount = 1;
         showFriendPanelBool = true;
         SelectMC = null;
         Panel = null;
         ScrollBar = null;
         GV.onlineSocket.dispatchEvent(new EventTaomee("Present_Manager_Event"));
         BC.removeEvent(PresentManager);
      }
   }
}

