package com.module.userInfo.view
{
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.manager.UIManager;
   import com.event.EventTaomee;
   import com.global.staticData.MapsConfig;
   import com.global.staticData.XMLInfo;
   import com.logic.socket.home.homeSocket;
   import com.logic.socket.lockHome.lockHomeRes;
   import com.logic.socket.modUserInfo.*;
   import com.module.PK.PKInfoManager;
   import com.module.PK.PKManager;
   import com.module.activityModule.checkCloth;
   import com.module.changeClothsModule.prevView;
   import com.mole.app.task.TaskManager;
   import com.view.userPanelView.MyHonor;
   import com.view.userPanelView.MyProfession;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.ui.Keyboard;
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   
   public class MyUserView extends MovieClip
   {
      
      public static var instance:MyUserView;
      
      public static var USER_NIKENAME_CHANGE:String = "user_nikename";
      
      private var count:int;
      
      private var modUserInfoReq:ModUserInfoReq;
      
      private var byte:ByteArray;
      
      private var nameArr:Array;
      
      private var nameBool:Boolean;
      
      private var namestr:String;
      
      private var useinfoMC:MovieClip;
      
      private var honorArray:Array;
      
      public function MyUserView()
      {
         super();
         GV.onlineSocket.addEventListener(lockHomeRes.USER_LOCKHOME,this.changeVip);
      }
      
      public static function getInstance() : MyUserView
      {
         if(instance == null)
         {
            instance = new MyUserView();
         }
         return instance;
      }
      
      private static function sortGloryICO(gloryIcoArray:Array) : void
      {
         for(var i:int = 0; i < gloryIcoArray.length; i++)
         {
            gloryIcoArray[i].x = i * 30 + 79;
         }
      }
      
      public function init(userMC:MovieClip) : void
      {
         this.useinfoMC = userMC;
         this.namestr = "";
         setTimeout(function():void
         {
            initUserInfoMC();
         },100);
         this.byte = new ByteArray();
         this.modUserInfoReq = new ModUserInfoReq();
         try
         {
            GV.onlineSocket.addEventListener(ModUserInfoRes.MOD_USER_INFO,this.changeUserInfo);
         }
         catch(e:Error)
         {
         }
      }
      
      private function initUserInfoMC(evt:Event = null) : void
      {
         var strText:String = null;
         var exp1:Number = NaN;
         var exp2:Number = NaN;
         var gloryIcoArray:Array = [];
         var date:Date = new Date(Number(LocalUserInfo.getBirthday()) * 1000);
         this.useinfoMC.drag_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.drag_start);
         this.useinfoMC.drag_mc.addEventListener(MouseEvent.MOUSE_UP,this.drag_stop);
         this.useinfoMC.drag_mc.addEventListener(MouseEvent.MOUSE_MOVE,this.drag_move);
         this.useinfoMC.pen.buttonMode = true;
         this.useinfoMC.king_level.buttonMode = true;
         this.useinfoMC.pen.addEventListener(MouseEvent.CLICK,this.penClick);
         this.useinfoMC.king_level.addEventListener(MouseEvent.CLICK,this.showPKInfo);
         this.useinfoMC.name_txt.addEventListener(KeyboardEvent.KEY_DOWN,this.keyEnter);
         this.useinfoMC.name_txt.alwaysShowSelection = false;
         this.useinfoMC.name_txt.useRichTextClipboard = true;
         this.useinfoMC.name_txt.selectable = true;
         this.useinfoMC.useID.alwaysShowSelection = false;
         this.useinfoMC.useID.useRichTextClipboard = true;
         this.useinfoMC.useID.selectable = true;
         this.useinfoMC.name_txt.addEventListener(Event.CHANGE,this.textStrict);
         this.useinfoMC.name_txt.text = String(LocalUserInfo.getNickName());
         this.useinfoMC.useID.text = String(LocalUserInfo.getUserID());
         if(LocalUserInfo.getUserID() > GV.userIDLimit)
         {
            this.useinfoMC.icon_mc.visible = false;
            this.useinfoMC.status_txt.text = "遊客";
         }
         else
         {
            this.useinfoMC.status_txt.text = "";
            this.setIcon();
         }
         if(GF.returnGM(LocalUserInfo.getUserID()))
         {
            this.useinfoMC.status_txt.text = "";
         }
         this.useinfoMC.level.text = String(GF.leve(LocalUserInfo.getExp()));
         if(Number(this.useinfoMC.level.text) >= 200)
         {
            this.useinfoMC.level.text = "200";
            this.useinfoMC.Exp_txt.text = GF.getExpByLevel(200) + "/" + GF.getExpByLevel(200);
            this.useinfoMC.exp_mc.width = 60;
         }
         else
         {
            exp1 = GF.getExpByLevel(int(this.useinfoMC.level.text));
            exp2 = GF.getExpByLevel(int(this.useinfoMC.level.text) + 1);
            this.useinfoMC.Exp_txt.text = LocalUserInfo.getExp() - exp1 + "/" + (exp2 - exp1);
            this.useinfoMC.exp_mc.width = (LocalUserInfo.getExp() - exp1) / (exp2 - exp1) * 60;
         }
         if(Boolean(LocalUserInfo.getEngineer()))
         {
            gloryIcoArray.push(this.useinfoMC.Engineer_level);
            this.useinfoMC.Engineer_level.gotoAndStop(LocalUserInfo.getEngineer() + 1);
         }
         else
         {
            this.useinfoMC.Engineer_level.gotoAndStop(1);
         }
         var num:int = this.useinfoMC.icon_mc.numChildren + 2;
         this.useinfoMC.Engineer_level.x = this.useinfoMC.icon_mc.x + num * 22;
         this.getPlantAndFarmLV();
         this.useinfoMC.year.autoSize = TextFieldAutoSize.CENTER;
         this.useinfoMC.month.autoSize = TextFieldAutoSize.CENTER;
         this.useinfoMC.day.autoSize = TextFieldAutoSize.CENTER;
         this.useinfoMC.year.text = String(date.getFullYear());
         this.useinfoMC.month.text = String(date.getMonth() + 1);
         this.useinfoMC.day.text = String(date.getDate());
         this.useinfoMC.money_txt.text = String(LocalUserInfo.getYXQ());
         this.useinfoMC.Strong_txt.text = String(LocalUserInfo.getStrong());
         this.useinfoMC.IQ_txt.text = String(LocalUserInfo.getIQ());
         this.useinfoMC.Charm_txt.text = String(LocalUserInfo.getCharm());
         this.useinfoMC.king_level.gotoAndStop(PKManager.kingLevel(LocalUserInfo.getGameKing()) + 1);
         this.useinfoMC.close_btn.addEventListener(MouseEvent.CLICK,this.closeMC);
         this.useinfoMC.mole.outline_mc.visible = false;
         new prevView(this.useinfoMC.mole,LocalUserInfo.getFamily().toString(16),LocalUserInfo.getClothItem());
         new MyProfession(this.useinfoMC.myprofession,LocalUserInfo.getUserID());
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeEventHandler);
         sortGloryICO(gloryIcoArray);
         this.honorArray = [];
         this.honorArray.push(this.useinfoMC.Engineer_level);
         this.useinfoMC.Engineer_level.id = this.honorArray.length - 1;
         this.honorArray.push(this.useinfoMC.king_level);
         this.useinfoMC.king_level.id = this.honorArray.length - 1;
         this.useinfoMC.king_level.value = LocalUserInfo.getGameKing();
         this.honorArray.push(this.useinfoMC.planter_level);
         this.useinfoMC.planter_level.id = this.honorArray.length - 1;
         this.useinfoMC.planter_level.value = LocalUserInfo.getPlanter();
         this.honorArray.push(this.useinfoMC.farmer_level);
         this.useinfoMC.farmer_level.id = this.honorArray.length - 1;
         this.useinfoMC.farmer_level.value = LocalUserInfo.getFarmer();
         this.honorArray.push(this.useinfoMC.Restaurant_level);
         this.useinfoMC.Restaurant_level.id = this.honorArray.length - 1;
         this.useinfoMC.Restaurant_level.value = LocalUserInfo.getDining();
         new MyHonor(this.useinfoMC.myhonor,LocalUserInfo.getUserID(),this.honorArray);
         if(Boolean(XMLInfo.baseinfoArr[0][0]))
         {
            tip.tipTailDisPlayObject(this.useinfoMC.pen,XMLInfo.baseinfoArr[0][0]);
         }
         if(Boolean(XMLInfo.baseinfoArr[1]))
         {
            tip.tipTailDisPlayObject(this.useinfoMC.icon_1_mc,XMLInfo.baseinfoArr[1]);
         }
         if(Boolean(XMLInfo.baseinfoArr[2]))
         {
            tip.tipTailDisPlayObject(this.useinfoMC.icon_2_mc,XMLInfo.baseinfoArr[2]);
         }
         if(Boolean(XMLInfo.baseinfoArr[3]))
         {
            tip.tipTailDisPlayObject(this.useinfoMC.icon_3_mc,XMLInfo.baseinfoArr[3]);
         }
         if(Boolean(XMLInfo.baseinfoArr[4]))
         {
            tip.tipTailDisPlayObject(this.useinfoMC.icon_4_mc,XMLInfo.baseinfoArr[4]);
         }
         if(Boolean(XMLInfo.baseinfoArr[5]))
         {
            tip.tipTailDisPlayObject(this.useinfoMC.icon_5_mc,XMLInfo.baseinfoArr[5]);
         }
         if(Boolean(XMLInfo.baseinfoArr[6]))
         {
            tip.tipTailDisPlayObject(this.useinfoMC.icon_6_mc,XMLInfo.baseinfoArr[6]);
         }
         tip.tipTailDisPlayObject(this.useinfoMC.dou_mc,"摩爾豆");
      }
      
      private function changeVip(evt:*) : void
      {
         var chageVipObj:Object = new Object();
         chageVipObj = evt.EventObj;
         LocalUserInfo.setVip(chageVipObj.Vip);
         this.setIcon();
      }
      
      private function getPlantAndFarmLV() : void
      {
         GV.onlineSocket.addEventListener("read_" + 1911,this.onRead_1911);
         homeSocket.queryPlantAndFarm(LocalUserInfo.getUserID());
      }
      
      private function onRead_1911(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 1911,this.onRead_1911);
         LocalUserInfo.setPlanter(evt.EventObj.plantLVNum);
         LocalUserInfo.setFarmer(evt.EventObj.farmLVNum);
         var planterNum:int = int(LocalUserInfo.getPlanter());
         this.useinfoMC.planter_level.gotoAndStop(int(planterNum / 5) + 1);
         var farmerNum:int = int(LocalUserInfo.getFarmer());
         this.useinfoMC.farmer_level.gotoAndStop(int(farmerNum / 5) + 1);
         this.useinfoMC.Restaurant_level.gotoAndStop(int(int(LocalUserInfo.hasDining()) + LocalUserInfo.getDining()));
      }
      
      private function showPKInfo(event:*) : void
      {
         var task300State:uint = TaskManager.getTaskState(300);
         if(Boolean(MapsConfig.MapsInfo[LocalUserInfo.getMapID()]) && Boolean(MapsConfig.MapsInfo[LocalUserInfo.getMapID()].isNewUserMap))
         {
            return;
         }
         if(task300State == 1)
         {
            return;
         }
         PKInfoManager.getInstance().init();
      }
      
      private function textStrict(event:*) : void
      {
         this.byte = new ByteArray();
         this.byte.writeUTFBytes(event.target.text);
         if(this.byte.length > 16)
         {
            event.target.text = this.namestr;
         }
         else
         {
            this.namestr = event.target.text;
         }
      }
      
      private function getPrimitiveColors(colorStr:String) : Array
      {
         var tempStr:String = null;
         var A:String = null;
         var B:String = null;
         var myObj:Object = {
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
      
      public function closeMC(evt:MouseEvent = null) : void
      {
         this.useinfoMC.parent.removeChild(this.useinfoMC);
         GV.usrinfoBool = false;
      }
      
      private function drag_start(evt:MouseEvent) : void
      {
         GF.setDrag(this.useinfoMC);
      }
      
      private function drag_stop(evt:MouseEvent) : void
      {
         GF.stopDrag(this.useinfoMC);
      }
      
      private function drag_move(evt:MouseEvent) : void
      {
         evt.updateAfterEvent();
      }
      
      private function penClick(event:MouseEvent) : void
      {
         ++this.count;
         if(this.count == 1)
         {
            event.target.parent.gotoAndStop(2);
            this.useinfoMC.name_txt.type = TextFieldType.INPUT;
            this.useinfoMC.name_txt.border = true;
            if(Boolean(XMLInfo.baseinfoArr[0][1]))
            {
               tip.tipTailDisPlayObject(this.useinfoMC.pen,XMLInfo.baseinfoArr[0][1]);
            }
         }
         else
         {
            if(this.useinfoMC.name_txt.length <= 0)
            {
               return;
            }
            if(Boolean(XMLInfo.baseinfoArr[0][0]))
            {
               tip.tipTailDisPlayObject(this.useinfoMC.pen,XMLInfo.baseinfoArr[0][0]);
            }
            event.target.gotoAndStop(1);
            this.modUserInfoReq.modUserInfo(this.useinfoMC.name_txt.text);
            this.useinfoMC.name_txt.type = TextFieldType.DYNAMIC;
            this.useinfoMC.name_txt.border = false;
            this.count = 0;
         }
      }
      
      private function keyEnter(event:KeyboardEvent) : void
      {
         if(event.keyCode == Keyboard.ENTER)
         {
            if(event.target.text.length <= 0)
            {
               return;
            }
            this.modUserInfoReq.modUserInfo(event.target.text);
            this.useinfoMC.pen.gotoAndStop(1);
            event.target.type = TextFieldType.DYNAMIC;
            event.target.border = false;
         }
      }
      
      private function changeUserInfo(evt:*) : void
      {
         var id:* = evt.EventObj.UserID;
         if(id == LocalUserInfo.getUserID())
         {
            GV.MyInfo_nickName = evt.EventObj.Nick;
            LocalUserInfo.setNickName(evt.EventObj.Nick);
            GV.MAN_PEOPLE.nickName = evt.EventObj.Nick;
            this.useinfoMC.name_txt.text = String(LocalUserInfo.getNickName());
            MainManager.getGlobalObject().data.nickName = LocalUserInfo.getNickName();
            MainManager.getGlobalObject().flush();
         }
         var tempMC:* = GF.getPeopleByID(id);
         if(checkCloth.checkOtherItem(12619,id))
         {
            tempMC.avatarMC.nickName_txt.htmlText = "<font color=\'#FF0000\'>" + String(evt.EventObj.Nick) + "</font>";
         }
         else
         {
            tempMC.avatarMC.nickName_txt.text = evt.EventObj.Nick;
         }
         if(GF.returnGM(id))
         {
            tempMC.avatarMC.nickName_txt.textColor = 255;
         }
         this.updateOnlineList(evt);
      }
      
      private function updateOnlineList(evt:*) : void
      {
         for(var i:uint = 0; i < GV.OnLineArray.length; i++)
         {
            if(evt.EventObj.UserID == GV.OnLineArray[i].UserID)
            {
               GV.OnLineArray[i].Nick = evt.EventObj.Nick;
               break;
            }
         }
      }
      
      private function removeEventHandler(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeEventHandler);
         this.useinfoMC.close_btn.removeEventListener(MouseEvent.CLICK,this.closeMC);
         this.useinfoMC.name_txt.removeEventListener(Event.CHANGE,this.textStrict);
         this.useinfoMC.drag_mc.removeEventListener(MouseEvent.MOUSE_DOWN,this.drag_start);
         this.useinfoMC.drag_mc.removeEventListener(MouseEvent.MOUSE_UP,this.drag_stop);
         this.useinfoMC.drag_mc.removeEventListener(MouseEvent.MOUSE_MOVE,this.drag_move);
         this.useinfoMC.king_level.removeEventListener(MouseEvent.CLICK,this.showPKInfo);
         this.useinfoMC.pen.removeEventListener(MouseEvent.CLICK,this.penClick);
         GV.onlineSocket.removeEventListener(ModUserInfoRes.MOD_USER_INFO,this.changeUserInfo);
         this.useinfoMC.name_txt.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyEnter);
         BC.removeEvent(this);
      }
      
      private function setIcon() : void
      {
         this.setIconMcHandler(10);
         for(var i:int = 2; i >= 0; i--)
         {
            if(Boolean(LocalUserInfo.getVip() >> i & 1))
            {
               this.setIconMcHandler(i);
            }
         }
      }
      
      private function setIconMcHandler(num:int) : void
      {
         var mc:MovieClip = null;
         switch(num)
         {
            case 0:
               mc = this.addChildMC("slIcon");
               if(Boolean(XMLInfo.baseinfoArr[7]))
               {
                  tip.tipTailDisPlayObject(mc,XMLInfo.baseinfoArr[7]);
               }
               break;
            case 1:
               break;
            case 2:
               this.useinfoMC.icon_mc.removeChildAt(0);
               mc = this.addChildMC("smcIcon");
               if(Boolean(XMLInfo.baseinfoArr[8]))
               {
                  tip.tipTailDisPlayObject(mc,XMLInfo.baseinfoArr[8]);
               }
               break;
            default:
               mc = this.useinfoMC.icon_mc.getChildAt(0);
               if(Boolean(mc) && Boolean(XMLInfo.baseinfoArr[9]))
               {
                  tip.tipTailDisPlayObject(mc,XMLInfo.baseinfoArr[9]);
               }
         }
      }
      
      private function addChildMC(str:String) : MovieClip
      {
         var tempClass:Class = UIManager.getClass(str) as Class;
         var iconMC:MovieClip = new tempClass();
         var num:int = int(this.useinfoMC.icon_mc.numChildren);
         iconMC.x = num * 17 + num * 3;
         this.useinfoMC.icon_mc.addChild(iconMC);
         return iconMC;
      }
   }
}

