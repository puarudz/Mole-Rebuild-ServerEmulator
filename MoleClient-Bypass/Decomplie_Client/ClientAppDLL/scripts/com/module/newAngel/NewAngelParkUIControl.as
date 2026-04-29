package com.module.newAngel
{
   import com.common.tip.tip;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.event.EventTaomee;
   import com.mole.app.manager.ModuleManager;
   import com.mole.utils.URLUtil;
   import com.view.MapManageView.MapButtonView;
   import com.view.MapManageView.MapManageView;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.ColorTransform;
   import flash.net.URLRequest;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   public class NewAngelParkUIControl
   {
      
      private static const TIMER_INTERAL:uint = 60;
      
      private static const COMM_ADD_NIMBUS:uint = 60;
      
      private static const VIP_ADD_NIMBUS:uint = 80;
      
      private var leaveBtn:MovieClip;
      
      private var myAngelBtn:MovieClip;
      
      private var incubationBtn:MovieClip;
      
      private var packageBtn:MovieClip;
      
      private var mergeBtn:MovieClip;
      
      private var angelShopBtn:MovieClip;
      
      private var mountsBtn:MovieClip;
      
      private var angelBookBtn:MovieClip;
      
      private var userNickTxt:TextField;
      
      private var nimbusTxt:TextField;
      
      private var addNimbusBtn:SimpleButton;
      
      private var fightBtn:SimpleButton;
      
      private var angel_txt:TextField;
      
      private var intrBtn:SimpleButton;
      
      private var getBackBtn:SimpleButton;
      
      private var flowerMc:MovieClip;
      
      private var flowerBtn:DisplayObject;
      
      private var doorMc:MovieClip;
      
      private var doorBtn:DisplayObject;
      
      private var fuhuaMc:MovieClip;
      
      private var bookBtn:MovieClip;
      
      private var timer:Timer;
      
      private var loader:Loader;
      
      private var headMc:MovieClip;
      
      private var _uiMc:MovieClip;
      
      public function NewAngelParkUIControl(uiMc:MovieClip)
      {
         super();
         this._uiMc = uiMc;
         this.leaveBtn = uiMc.getChildByName("leaveBtn") as MovieClip;
         this.myAngelBtn = uiMc.getChildByName("my_angel_btn") as MovieClip;
         this.incubationBtn = uiMc.getChildByName("incubation_btn") as MovieClip;
         this.packageBtn = uiMc.getChildByName("package_btn") as MovieClip;
         this.mergeBtn = uiMc.getChildByName("merge_btn") as MovieClip;
         this.angelShopBtn = uiMc.getChildByName("angelShop_btn") as MovieClip;
         this.mountsBtn = uiMc.getChildByName("mounts_btn") as MovieClip;
         this.fightBtn = uiMc.getChildByName("angel_fight_btn") as SimpleButton;
         this.angelBookBtn = uiMc.getChildByName("angel_book_btn") as MovieClip;
         this.angel_txt = uiMc.getChildByName("angel_txt") as TextField;
         this.userNickTxt = uiMc.getChildByName("userNick_txt") as TextField;
         this.nimbusTxt = uiMc.getChildByName("nimbus_txt") as TextField;
         this.addNimbusBtn = uiMc.getChildByName("addNimbus_btn") as SimpleButton;
         this.intrBtn = uiMc.getChildByName("intr_btn") as SimpleButton;
         this.getBackBtn = uiMc.getChildByName("getBack_btn") as SimpleButton;
         this.flowerMc = GV.MC_mapFrame["depth_mc"]["flowerMc"];
         this.doorMc = GV.MC_mapFrame["depth_mc"]["doorMc"];
         this.fuhuaMc = GV.MC_mapFrame["top_mc"]["fuhuaMc"];
         this.bookBtn = GV.MC_mapFrame["control_mc"]["book_mc"];
         this.intrBtn.visible = false;
         this.leaveBtn.buttonMode = true;
         this.myAngelBtn.buttonMode = true;
         this.incubationBtn.buttonMode = true;
         this.packageBtn.buttonMode = true;
         this.mergeBtn.buttonMode = true;
         this.angelShopBtn.buttonMode = true;
         this.mountsBtn.buttonMode = true;
         this.angelBookBtn.buttonMode = true;
         this.userNickTxt.text = LocalUserInfo.getNickName();
         this.nimbusTxt.text = NewAngelManager.instance.parkNimbus + "/" + NewAngelManager.instance.parkNimMax;
         this.timer = new Timer(TIMER_INTERAL,0);
         this.timer.start();
         this.loader = new Loader();
         this.loader.load(new URLRequest(URLUtil.getMoleHeadURL()));
         this.addEvent();
      }
      
      private function timerHandler(evt:TimerEvent) : void
      {
         var passTimer:uint = ServerUpTime.getInstance().serverTime / 1000 - NewAngelManager.instance.lastAddNimbusTimer;
         if(passTimer >= 60 * 60)
         {
            passTimer = ServerUpTime.getInstance().serverTime / 1000;
            if(LocalUserInfo.isVIP())
            {
               NewAngelManager.instance.parkNimbus = Math.min(NewAngelManager.instance.parkNimMax,NewAngelManager.instance.parkNimbus + VIP_ADD_NIMBUS);
            }
            else
            {
               NewAngelManager.instance.parkNimbus = Math.min(NewAngelManager.instance.parkNimMax,NewAngelManager.instance.parkNimbus + COMM_ADD_NIMBUS);
            }
            this.nimbusTxt.text = NewAngelManager.instance.parkNimbus + "/" + NewAngelManager.instance.parkNimMax;
         }
      }
      
      private function addEvent() : void
      {
         NewAngelManager.instance.addEventListener(NewAngelManager.NEW_ANGEL_CHANGE_REIKI,this.changeNimbusOver);
         this.myAngelBtn.addEventListener(MouseEvent.CLICK,this.openModuleHandler);
         this.incubationBtn.addEventListener(MouseEvent.CLICK,this.openModuleHandler);
         this.packageBtn.addEventListener(MouseEvent.CLICK,this.openModuleHandler);
         this.mergeBtn.addEventListener(MouseEvent.CLICK,this.openModuleHandler);
         this.angelShopBtn.addEventListener(MouseEvent.CLICK,this.openModuleHandler);
         this.mountsBtn.addEventListener(MouseEvent.CLICK,this.openModuleHandler);
         this.fightBtn.addEventListener(MouseEvent.CLICK,this.openModuleHandler);
         this.angelBookBtn.addEventListener(MouseEvent.CLICK,this.openModuleHandler);
         this.addNimbusBtn.addEventListener(MouseEvent.CLICK,this.openModuleHandler);
         this.intrBtn.addEventListener(MouseEvent.CLICK,this.openModuleHandler);
         this.getBackBtn.addEventListener(MouseEvent.CLICK,this.openModuleHandler);
         this.fuhuaMc.addEventListener(MouseEvent.CLICK,this.openModuleHandler);
         this.flowerBtn = MapButtonView.regeditEvent(this.flowerMc,this.gotoFlower);
         this.doorBtn = MapButtonView.regeditEvent(this.doorMc,this.openModuleHandler);
         this.bookBtn.addEventListener(MouseEvent.CLICK,this.openModuleHandler);
         this.timer.addEventListener(TimerEvent.TIMER,this.timerHandler);
         if(LocalUserInfo.isVIP())
         {
            tip.tipTailDisPlayObject(this.nimbusTxt,"VIP玩家靈氣值上限為1600," + "VIP 每小時恢復" + VIP_ADD_NIMBUS + "點靈氣" + "\n普通玩家靈氣值上限為1000," + "非VIP每小時恢復" + COMM_ADD_NIMBUS + "點靈氣");
            tip.tipTailDisPlayObject(this.angel_txt,"vip玩家根據vip等級可同時培養9到12隻天使，最多可培養48小時" + "\n普通玩家可同時培養8隻天使，最多可培養24小時");
         }
         tip.tipTailDisPlayObject(this.getBackBtn,"收回全部天使");
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.headLoadComplete);
         this.leaveBtn.addEventListener(MouseEvent.MOUSE_OVER,this.showBtnContainer);
         this.leaveBtn.addEventListener(MouseEvent.MOUSE_OUT,this.hideBtnContainer);
         this.leaveBtn.mc.angelBtn.mouseEnabled = false;
         MapManageView.inst.initMySite(this.leaveBtn.mc,this,this.leavePark);
      }
      
      private function removeEvent() : void
      {
         NewAngelManager.instance.removeEventListener(NewAngelManager.NEW_ANGEL_CHANGE_REIKI,this.changeNimbusOver);
         this.myAngelBtn.removeEventListener(MouseEvent.CLICK,this.openModuleHandler);
         this.fuhuaMc.removeEventListener(MouseEvent.CLICK,this.openModuleHandler);
         this.incubationBtn.removeEventListener(MouseEvent.CLICK,this.openModuleHandler);
         this.packageBtn.removeEventListener(MouseEvent.CLICK,this.openModuleHandler);
         this.mergeBtn.removeEventListener(MouseEvent.CLICK,this.openModuleHandler);
         this.angelShopBtn.removeEventListener(MouseEvent.CLICK,this.openModuleHandler);
         this.mountsBtn.removeEventListener(MouseEvent.CLICK,this.openModuleHandler);
         this.fightBtn.removeEventListener(MouseEvent.CLICK,this.openModuleHandler);
         this.angelBookBtn.removeEventListener(MouseEvent.CLICK,this.openModuleHandler);
         this.addNimbusBtn.removeEventListener(MouseEvent.CLICK,this.openModuleHandler);
         this.intrBtn.removeEventListener(MouseEvent.CLICK,this.openModuleHandler);
         this.getBackBtn.removeEventListener(MouseEvent.CLICK,this.openModuleHandler);
         this.bookBtn.removeEventListener(MouseEvent.CLICK,this.openModuleHandler);
         MapButtonView.removeEvent(this.flowerBtn);
         MapButtonView.removeEvent(this.doorBtn);
         BC.removeEvent(this,GV.MAN_PEOPLE,PeopleManageView.ON_GO_OVER,this.goFlowerOver);
         this.timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.headLoadComplete);
         this.leaveBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.showBtnContainer);
         this.leaveBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.hideBtnContainer);
         BC.removeEvent(this);
      }
      
      private function showBtnContainer(evt:MouseEvent) : void
      {
         this.leaveBtn.gotoAndStop(2);
         this.leaveBtn.mc.visible = true;
      }
      
      private function hideBtnContainer(evt:MouseEvent) : void
      {
         this.leaveBtn.gotoAndStop(1);
      }
      
      private function leavePark(evt:MouseEvent) : void
      {
         GF.switchMap(1);
      }
      
      private function headLoadComplete(evt:Event) : void
      {
         this.loader.removeEventListener(Event.COMPLETE,this.headLoadComplete);
         this.headMc = LoaderInfo(evt.target).content as MovieClip;
         this.headMc.x = 10;
         this.headMc.y = 66;
         this._uiMc.addChild(this.headMc);
         var colorObj:Object = GV.myInfo_Color;
         this.headMc.face_mc.face_color.transform.colorTransform = new ColorTransform(colorObj.red / 256,colorObj.green / 256,colorObj.blue / 256,1);
         this.headMc.face_mc.face_bg.gotoAndStop(1);
         this.headMc.face_mc.face_side.gotoAndStop(1);
      }
      
      private function changeNimbusOver(e:EventTaomee) : void
      {
         this.nimbusTxt.text = NewAngelManager.instance.parkNimbus + "/" + NewAngelManager.instance.parkNimMax;
      }
      
      private function gotoFlower(e:MouseEvent) : void
      {
         BC.addEvent(this,GV.MAN_PEOPLE,PeopleManageView.ON_GO_OVER,this.goFlowerOver);
         PeopleManageView(GV.MAN_PEOPLE).moveTo(412,238);
      }
      
      private function goFlowerOver(e:*) : void
      {
         if(GV.MAN_PEOPLE.x == 412 && GV.MAN_PEOPLE.y == 238)
         {
            BC.removeEvent(this,GV.MAN_PEOPLE,PeopleManageView.ON_GO_OVER,this.goFlowerOver);
            this.flowerMc.gotoAndStop(2);
         }
      }
      
      private function openModuleHandler(evt:MouseEvent) : void
      {
         switch(evt.currentTarget)
         {
            case this.myAngelBtn:
               ModuleManager.openPanel("NewAngelBagPanel");
               break;
            case this.incubationBtn:
               ModuleManager.openPanel("NewAngelIncubationPanel");
               break;
            case this.packageBtn:
               ModuleManager.openPanel("NewAngelPackagePanel");
               break;
            case this.addNimbusBtn:
               ModuleManager.openPanel("NewAngelAddNimbusPanel");
               break;
            case this.doorBtn:
               ModuleManager.openPanel("NewAngelMatePanel");
               break;
            case this.mergeBtn:
               ModuleManager.openPanel("NewAngelMatePanel");
               break;
            case this.angelShopBtn:
               ModuleManager.openPanel("NewAngelShopsPanel");
               break;
            case this.mountsBtn:
               ModuleManager.openPanel("NewAngelMountsPanel");
               break;
            case this.angelBookBtn:
               ModuleManager.openPanel("NewAngelHandbookPanel");
               break;
            case this.intrBtn:
               ModuleManager.openPanel("NewAngelUpHelpPanel");
               break;
            case this.getBackBtn:
               NewAngelManager.instance.getAllAngelFromPark();
               break;
            case this.fightBtn:
               ModuleManager.openPanel("NewAngelFightModule",0,"正在加載天使戰鬥",null,false,true);
               break;
            case this.fuhuaMc:
               ModuleManager.openPanel("NewAngelIncubationPanel");
               break;
            case this.bookBtn:
               ModuleManager.openPanel("NewAngelHandbookPanel");
         }
      }
      
      public function destroy() : void
      {
         this.removeEvent();
         this.timer.stop();
         if(Boolean(this.headMc))
         {
            this._uiMc.removeChild(this.headMc);
         }
         this.loader = null;
         this.headMc = null;
         this._uiMc = null;
         this.timer = null;
         this.leaveBtn = null;
         this.myAngelBtn = null;
         this.incubationBtn = null;
         this.packageBtn = null;
         this.mergeBtn = null;
         this.angelShopBtn = null;
         this.mountsBtn = null;
         this.angelBookBtn = null;
      }
   }
}

