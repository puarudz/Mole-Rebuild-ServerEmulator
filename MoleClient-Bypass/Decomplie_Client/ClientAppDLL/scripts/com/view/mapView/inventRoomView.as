package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.util.DisplayUtil;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.newloader.BaseMCLoader;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.global.staticData.CommandID;
   import com.logic.PetClassLogic.PowerClassInfo;
   import com.logic.socket.CSItems.CSReq;
   import com.logic.socket.CSItems.CSRes;
   import com.logic.socket.defend.defendSocket;
   import com.logic.socket.examinePack.examinePackStuff;
   import com.logic.socket.giveMeMoney.giveMeMoneyReq;
   import com.logic.socket.giveMeMoney.giveMeMoneyRes;
   import com.logic.socket.moleAction.moleActionReq;
   import com.logic.socket.moleAction.moleActionRes;
   import com.logic.socket.smc.PickItem.PickItemReq;
   import com.logic.socket.smc.PickItem.PickItemRes;
   import com.module.activityModule.checkItem;
   import com.module.coin.CoinBuyNewModle;
   import com.module.deal.Deal;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.mapModule.Map27Job175;
   import com.module.pet.petLogic;
   import com.module.query.QueryImpl;
   import com.module.sceneSoundModule.sceneSoundModule;
   import com.module.superPetModule.petItemModule;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.ActivityTmpDataManager;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.task.TaskManager;
   import com.view.JobView.ChildMapJob.JobMap27View;
   import com.view.MapManageView.MapButtonView;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class inventRoomView extends MapBase
   {
      
      public static var tree_bl:int = 0;
      
      public var target_mc:MovieClip;
      
      public var button_mc:MovieClip;
      
      private var sgm_mc:MovieClip;
      
      private var ISmotherBtn:Boolean = false;
      
      private var ISmotherGame:Boolean = false;
      
      private var moleaction:moleActionReq;
      
      private var forestJobMapViews:JobMap27View;
      
      private var ISrobot:Boolean = false;
      
      private var message:String;
      
      private var url:String;
      
      private var joinObj:Object;
      
      private var CoinBuyModles:CoinBuyNewModle;
      
      private var R7bool:Boolean = false;
      
      public function inventRoomView()
      {
         super();
         GV.onlineSocket.addEventListener(moleActionRes.MOLE_SLIDE,this.doBoomHandler);
      }
      
      override protected function initView() : void
      {
         this.moleaction = new moleActionReq();
         this.forestJobMapViews = new JobMap27View();
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.button_mc = GV.MC_mapFrame["buttonLevel"];
         QueryImpl.getInstance().QueryItem([190810],this.querySuccessFun,this.queryFailureFun);
         this.CoinBuyModles = new CoinBuyNewModle();
         this.button_mc.farm_mc.addEventListener(MouseEvent.MOUSE_OVER,this.doorOverHandler);
         this.button_mc.farm_mc.addEventListener(MouseEvent.MOUSE_OUT,this.doorOutHandler);
         GV.onlineSocket.addEventListener(sceneSoundModule.PLAY_MAPACTION,this.bellActionHandler);
         this.target_mc.allitem.item190016.item.methodgame_btn.addEventListener(MouseEvent.CLICK,this.loadGameUI);
         this.target_mc.allitem.item190016.item.method_btn.addEventListener(MouseEvent.MOUSE_DOWN,this.loadMotherUI);
         this.target_mc.forest_btn.addEventListener(MouseEvent.CLICK,this.CLICKForestFun);
         var task29State:uint = TaskManager.getTaskState(29);
         if(task29State == 0)
         {
            this.target_mc.robot_btn.visible = true;
            this.target_mc.forestOver_btn.visible = false;
         }
         else if(task29State == 2)
         {
            this.target_mc.robot_btn.visible = false;
            this.target_mc.forestOver_btn.visible = true;
         }
         this.target_mc.forestOver_btn.addEventListener(MouseEvent.CLICK,this.CLICKrobotOverFun);
         this.target_mc.robot_btn.addEventListener(MouseEvent.CLICK,this.CLICKrobotFun);
         petItemModule.itemVisibleHandler(this.target_mc);
         this.target_mc.mic_btn.addEventListener(MouseEvent.CLICK,this.micHandler);
         this.initGetHouseImage();
         BC.addEvent(this,this.target_mc.r8Btn,MouseEvent.CLICK,this.onR8Btn);
         PowerClassInfo.getInstanse().scene = this;
         PowerClassInfo.getInstanse().getClassData();
         this.target_mc.box0.buttonMode = this.target_mc.box1.buttonMode = this.target_mc.box2.buttonMode = this.target_mc.box3.buttonMode = true;
         BC.addEvent(this,this.target_mc.box0,MouseEvent.CLICK,this.boxClick);
         BC.addEvent(this,this.target_mc.box1,MouseEvent.CLICK,this.boxClick);
         BC.addEvent(this,this.target_mc.box2,MouseEvent.CLICK,this.boxClick);
         BC.addEvent(this,this.target_mc.box3,MouseEvent.CLICK,this.boxClick);
         (this.target_mc.box2 as MovieClip).addFrameScript(6,this.initDingziBox);
         BC.addEvent(this,this.button_mc.page_btn,MouseEvent.CLICK,this.showPageFun);
         BC.addEvent(this,this.button_mc["makeSwing"],MouseEvent.CLICK,this.swingClick);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1991,this.seeDefendFun);
         defendSocket.seedefendTime(LocalUserInfo.getUserID(),1320001);
         MapButtonView.regeditEvent(depthLevel.npc_10022,this.buyHandler);
         var Map27Job175s:Map27Job175 = new Map27Job175();
         Map27Job175s.Info();
         SystemEventManager.addEventListener("getSGMFun",this.getSGMFun);
         SystemEventManager.addEventListener("getSGMSuc",this.getSGMSuc);
         SystemEventManager.addEventListener("loveTestState27",this.loveTestState27Handler);
      }
      
      private function loveTestState27Handler(e:SystemEvent) : void
      {
         GV.onlineSocket.addCmdListener(CommandID.MOVIE_PLAY,this.back12047);
         GF.sendSocket(CommandID.MOVIE_PLAY,322,0);
      }
      
      private function back12047(e:SocketEvent) : void
      {
         var data:ByteArray;
         var type:uint;
         var flag:uint;
         var status:uint;
         var tempArrayFront:Array = null;
         var resultFront:Array = null;
         var tempArrayBehind:Array = null;
         var resultBehind:Array = null;
         GV.onlineSocket.removeCmdListener(CommandID.MOVIE_PLAY,this.back12047);
         data = e.data as ByteArray;
         data.position = 0;
         type = data.readUnsignedInt();
         flag = data.readUnsignedInt();
         status = data.readUnsignedInt();
         if(status == 1)
         {
            ActivityTmpDataManager.loveTestFlag = 2;
         }
         if(ActivityTmpDataManager.loveTestFlag == 1)
         {
            tempArrayFront = ActivityTmpDataManager.loveTestArray.slice(0,4);
            resultFront = tempArrayFront.filter(function(item:uint, index:int, array:Array):Boolean
            {
               return item == 1 ? true : false;
            });
            tempArrayBehind = ActivityTmpDataManager.loveTestArray.slice(4);
            resultBehind = tempArrayBehind.filter(function(item:uint, index:int, array:Array):Boolean
            {
               return item == 0 ? true : false;
            });
            if(ActivityTmpDataManager.loveTestArray[4] == 1)
            {
               if(resultBehind.length < tempArrayBehind.length)
               {
                  Alert.smileAlart("大衛：尼克的要求真高啊，機器人服務員還真不是個簡單的東西。");
               }
               else if(resultBehind.length == tempArrayBehind.length)
               {
                  mapSay(101);
               }
            }
            else if(ActivityTmpDataManager.loveTestArray[4] == 0)
            {
               if(resultFront.length < tempArrayFront.length)
               {
                  Alert.smileAlart("先要通過其他人的愛心測試喲");
               }
               else if(resultFront.length == tempArrayFront.length)
               {
                  mapSay(101);
               }
            }
            else
            {
               Alert.angryAlart("伺服器數據錯誤。");
            }
         }
         else if(ActivityTmpDataManager.loveTestFlag == 2)
         {
            Alert.smileAlart("愛心測試已經完成了！");
         }
         else
         {
            ModuleManager.openPanel("LoveTestPanel");
         }
      }
      
      private function getSGMSuc(e:SystemEvent) : void
      {
         Deal.BuyItem(13051,1,function(E:*):*
         {
            Alert.smileAlart("　　恭喜你！能召喚出時光門的時光之鏈已放入你的百寶箱中了，趕快拿出來用一用吧！");
         });
      }
      
      private function getSGMFun(e:SystemEvent) : void
      {
         GV.onlineSocket.addEventListener("read_" + 1915,this.checkHasSGM);
         examinePackStuff.examinePack_create([13051]);
      }
      
      private function checkHasSGM(E:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 1915,this.checkHasSGM);
         if(Boolean(E.EventObj.Count) && Boolean(E.EventObj.arr[0].itemID == 13051) && E.EventObj.arr[0].count > 0)
         {
            mapSay(25);
         }
         else if(!LocalUserInfo.isVIP())
         {
            Alert.SLAlart("　　親愛的小摩爾，時光門需要有超級拉姆的神奇力量才能使用哦！我們期待你的加入。");
            mapSay(24);
         }
         else if(PeopleManageView(GV.MAN_PEOPLE).Petlevel == 101)
         {
            mapSay(17);
         }
         else
         {
            mapSay(24);
         }
      }
      
      private function querySuccessFun(arr:Array) : void
      {
         var i:int = 0;
         try
         {
            for(i = 0; i < arr.length; i++)
            {
               if(arr[i].itemID == "190810")
               {
                  if(arr[i].count > 0)
                  {
                     tree_bl = arr[i].count;
                     return;
                  }
               }
               else
               {
                  tree_bl = 0;
               }
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function queryFailureFun(evt:EventTaomee) : void
      {
      }
      
      private function onR8Btn(evt:MouseEvent) : void
      {
         var loadGame:LoadGame = new LoadGame("module/external/R8EggMain.swf","正在加載R8孵蛋機",MainManager.getGameLevel());
         loadGame = null;
      }
      
      private function seeDefendFun(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1991,this.seeDefendFun);
         if(evt.EventObj.ID == 0)
         {
            this.R7bool = true;
         }
      }
      
      private function buyHandler(evt:MouseEvent) : void
      {
         var msg:String = "    Hi～你好，我是大衛的新發明阿七。只要租用了我，每週給我一根超能骨頭吃，你的植物就不會乾旱動物也不會逃跑啦。現在超拉禮包中每週贈送一根骨頭哦。";
         var url:String = "resource/allJob/AlertPic/defend/defend01.swf";
         var aler:* = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"hire,buy_energy",true,true,"SMCUI");
         BC.addEvent(this,aler,Alert.CLICK_ + "1",function(E:Event):*
         {
            if(LocalUserInfo.isVIP())
            {
               if(R7bool)
               {
                  CoinBuyModles.BuyModle(100555,1);
               }
               else
               {
                  Alert.smileAlart("    你已經租用一隻機器狗了，只要記得及時餵它，就可以把你的牧場和農場都照看好了。");
               }
            }
            else
            {
               Alert.SLAlart("    只有超級拉姆的神奇力量，才能把阿七帶回家，幫你看家護院哦！");
            }
         });
         BC.addEvent(this,aler,Alert.CLICK_ + "2",function(E:Event):*
         {
            CoinBuyModles.BuyModle(100556,1);
         });
      }
      
      private function swingClick(e:MouseEvent) : void
      {
         GV.onlineSocket.addEventListener(checkItem.chekItem_suc,this.haveSwingResult);
         checkItem.checkItemHandler(190478);
      }
      
      private function haveSwingResult(e:EventTaomee) : void
      {
         var msg:String = null;
         var url:String = null;
         GV.onlineSocket.removeEventListener(checkItem.chekItem_suc,this.haveSwingResult);
         if(e.EventObj.count < 1)
         {
            msg = "   你還沒有金色秋千圖紙，暫時無法製作哦！";
            url = "resource/allJob/icon/190478.swf";
            Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"sure",true,false,"EMP_BUY");
         }
         else
         {
            this.swingBeginFun();
         }
      }
      
      private function swingBeginFun() : void
      {
         var tempMC:Sprite = new Sprite();
         tempMC.name = "swingMC";
         MainManager.getTopLevel().addChild(tempMC);
         var mcloader:BaseMCLoader = new BaseMCLoader("module/external/Swing.swf",tempMC);
         mcloader.addEventListener(MCLoadEvent.ON_SUCCESS,this.swingHandler);
         mcloader.doLoad();
      }
      
      private function swingHandler(event:MCLoadEvent) : void
      {
         var content:DisplayObject = event.getContent();
         var mc:Sprite = event.getParent() as Sprite;
         mc.addChild(content);
         BC.addEvent(this,content,"GameOver",this.swingOver);
         BaseMCLoader(event.currentTarget).clear();
      }
      
      private function swingOver(e:EventTaomee) : void
      {
         var flag:Boolean = e.EventObj as Boolean;
         if(flag)
         {
            BC.addEvent(this,GV.onlineSocket,CSRes.GETITEM_OK,this.getItemOkHandler);
            CSReq.Info(578);
         }
      }
      
      private function getItemOkHandler(e:EventTaomee) : void
      {
         var msg:String = "    恭喜你獲得金色秋千，快到家園倉庫中看看吧！";
         var url:String = "resource/home/item/icon/1220115.swf";
         Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"sure",true,false,"EMP_BUY");
      }
      
      private function showPageFun(eve:MouseEvent) : void
      {
         var temp:MovieClip = GV.MC_mapFrame["page_mc"];
         temp.visible = true;
      }
      
      private function initDingziBox() : void
      {
         if(PowerClassInfo.getInstanse().workFlag && !PowerClassInfo.getInstanse().hasDingzi)
         {
            this.target_mc.box2.dingzi.visible = true;
         }
         else
         {
            this.target_mc.box2.dingzi.visible = false;
         }
      }
      
      private function boxClick(e:MouseEvent) : void
      {
         var msg:String = null;
         var url:String = null;
         var mov:MovieClip = e.currentTarget as MovieClip;
         var id:int = int(mov.name.slice(-1));
         var step:int = mov.currentFrame;
         if(id == 2)
         {
            if(step == 1)
            {
               mov.gotoAndStop(7);
            }
            else if(mov["dingzi"].visible == true)
            {
               mov["dingzi"].visible = false;
               PowerClassInfo.getInstanse().getDingzi();
               msg = "        恭喜你找到了釘子!";
               url = "resource/allJob/AlertPic/powerclass/dingzi.swf";
               Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
            }
            else
            {
               mov.gotoAndStop(1);
            }
         }
         else if(step == 1)
         {
            mov.gotoAndStop(7);
         }
         else
         {
            mov.gotoAndStop(1);
         }
      }
      
      private function micHandler(event:MouseEvent) : void
      {
         var prizeStr:String = null;
         var loadGame:LoadGame = null;
         var url:String = null;
         var Alt:* = undefined;
         var task58State:uint = TaskManager.getTaskState(58);
         if(task58State == 0)
         {
            prizeStr = "先閱讀一下RK的通緝令，再來整理這些機密資料吧！";
            GF.showAlert(MainManager.getAppLevel(),prizeStr,"",100,"iknow",true,false,"E");
         }
         else if(task58State == 1)
         {
            loadGame = new LoadGame("module/external/RkGameDoc.swf","正在打開碎片遊戲",MainManager.getGameLevel());
            loadGame = null;
         }
         else
         {
            prizeStr = "    感謝你協助警署找到搗蛋鬼RK的線索，警署將認真調查，爭取早日將RK抓捕歸案！rr    希望你能繼續為維護莊園安全作貢獻！";
            url = "resource/allJob/AlertPic/RK_2.swf";
            Alt = Alert.showAlert(MainManager.getAppLevel(),url,prizeStr,Alert.CHANG_ALERT,"iknow",true,false,"SMCUI");
         }
      }
      
      private function doorOverHandler(evt:MouseEvent) : void
      {
         this.target_mc.door_mc.gotoAndStop(2);
      }
      
      private function doorOutHandler(evt:MouseEvent) : void
      {
         this.target_mc.door_mc.gotoAndStop(1);
      }
      
      private function CLICKrobotOverFun(event:MouseEvent) : void
      {
         var mc:Sprite = null;
         var mcloader:MCLoader = null;
         if(this.ISrobot)
         {
            return;
         }
         if(!MainManager.getAppLevel().getChildByName("systemCollect2"))
         {
            mc = new Sprite();
            mc.name = "systemCollect2";
            MainManager.getAppLevel().addChild(mc);
            mcloader = new MCLoader("module/external/RobotCollectModule.swf",MainManager.getAppLevel(),1,"正在打開機器人面板");
            mcloader.addEventListener(MCLoadEvent.ON_SUCCESS,this.onload);
            mcloader.doLoad();
         }
      }
      
      private function onload(event:MCLoadEvent) : void
      {
         var mc:Sprite = MainManager.getAppLevel().getChildByName("systemCollect2") as Sprite;
         var parent:MovieClip = event.getParent() as MovieClip;
         var content:DisplayObject = event.getLoader();
         mc.addChild(content);
      }
      
      private function CLICKrobotFun(event:MouseEvent) : void
      {
         if(this.ISrobot)
         {
            return;
         }
         this.ISrobot = true;
         var url:String = "resource/allJob/icon/robotno.swf";
         var tip:String = "    是否馬上開始拼裝機器人R2？";
         var myAlert:* = Alert.showAlert(MainManager.getAppLevel(),url,tip,Alert.CHANG_ALERT,"getReady,nextCome",true,false,"EMP_BUY");
         myAlert.addEventListener(Alert.CLICK_ + "1",this.AddRobotGame);
         myAlert.addEventListener(Alert.CLICK_ + "2",this.showBtnRobotGame);
      }
      
      private function showBtnRobotGame(event:Event) : void
      {
         this.ISrobot = false;
      }
      
      private function AddRobotGame(event:Event) : void
      {
         var mcloader:MCLoader = null;
         this.ISrobot = false;
         if(!MainManager.getAppLevel().getChildByName("systemrobotgame"))
         {
            mcloader = new MCLoader("module/external/RobotGame.swf",MainManager.getAppLevel(),1,"正在打開組裝面板");
            mcloader.addEventListener(MCLoadEvent.ON_SUCCESS,this.onloadRobot);
            mcloader.doLoad();
         }
      }
      
      private function onloadRobot(event:MCLoadEvent) : void
      {
         GV.onlineSocket.addEventListener("OVER_MAP_JOB29",this.changMapUIShow);
         var parent:DisplayObjectContainer = event.getParent();
         var content:* = event.getLoader();
         content.name = "systemrobotgame";
         parent.addChild(content);
      }
      
      private function changMapUIShow(event:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("OVER_MAP_JOB29",this.changMapUIShow);
         this.target_mc.robot_btn.visible = false;
         this.target_mc.forestOver_btn.visible = true;
      }
      
      private function CLICKForestFun(event:MouseEvent) : void
      {
         this.target_mc.forest_btn.visible = false;
         depthLevel.forest_mc.gotoAndPlay(2);
         this.forestJobMapViews.info();
      }
      
      private function loadGameUI(event:MouseEvent) : void
      {
         var GameUI:MovieClip = null;
         var tempMC:MCLoader = null;
         if(!MainManager.getAppLevel().getChildByName("method_game_MC") && !this.ISmotherGame)
         {
            this.ISmotherGame = true;
            GameUI = new MovieClip();
            GameUI.name = "method_game_MC";
            MainManager.getAppLevel().addChild(GameUI);
            tempMC = new MCLoader("module/external/MapJobGame/Jobgame8.swf",GameUI,1,"正在進入實驗室");
            tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadGameOverHandler);
            tempMC.doLoad();
         }
      }
      
      private function loadGameOverHandler(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:* = evt.getLoader();
         mainMC.addChild(childMC);
         mainMC.x = 0;
         mainMC.y = 0;
         GV.onlineSocket.addEventListener("PoliceGame_CloseEvent",this.closePoliceGame);
         var mcloader:MCLoader = evt.target as MCLoader;
         mcloader.removeEventListener(MCLoadEvent.ON_SUCCESS,this.loadGameOverHandler);
         mcloader.clear();
      }
      
      private function closePoliceGame(event:EventTaomee = null) : void
      {
         var url:String = null;
         var str:String = null;
         var myAlert:* = undefined;
         GV.onlineSocket.removeEventListener("PoliceGame_CloseEvent",this.closePoliceGame);
         var temp:* = MainManager.getAppLevel().getChildByName("method_game_MC");
         GC.stopAllMC(temp);
         GC.clearAllChildren(temp);
         MainManager.getAppLevel().removeChild(temp);
         var myISnext:* = event.EventObj.isResult;
         if(Boolean(myISnext))
         {
            this.ISmotherGame = false;
            return;
         }
         var myBoolean:* = event.EventObj.result;
         if(Boolean(myBoolean))
         {
            GV.onlineSocket.addEventListener(PickItemRes.PICK_ITEM,this.showAlertFun);
            PickItemReq.pickItem(190016);
         }
         else
         {
            url = "resource/allJob/icon/190016no.swf";
            str = "    你配制出了一瓶相當危險的化學藥劑，看起來馬上要爆炸了，趕快丟掉它！";
            myAlert = Alert.showAlert(MainManager.getAppLevel(),url,str,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
            myAlert.addEventListener(Alert.CLICK_ + "1",this.showPeople);
            this.ISmotherGame = false;
         }
      }
      
      private function showAlertFun(event:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(PickItemRes.PICK_ITEM,this.showAlertFun);
         var url:String = "resource/allJob/icon/190016.swf";
         var str:String = "    恭喜你成功配制了一瓶化學加熱劑，已經放入你的百寶箱中。";
         Alert.showAlert(MainManager.getAppLevel(),url,str,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
      }
      
      private function showPeople(event:Event = null) : void
      {
         event.target.removeEventListener(Alert.CLICK_ + "1",this.showPeople);
         this.moleaction.sendAction(4);
      }
      
      private function loadMotherUI(event:MouseEvent) : void
      {
         var url:String = null;
         var tempMC:MovieClip = null;
         var myLoader:Loader = null;
         this.target_mc.motherMC.visible = false;
         if(!MainManager.getAppLevel().getChildByName("method_UI_MC") && !this.ISmotherBtn)
         {
            this.ISmotherBtn = true;
            url = "module/external/MapJobGame/Job8_27.swf";
            tempMC = new MovieClip();
            tempMC.name = "method_UI_MC";
            myLoader = new Loader();
            myLoader.load(VL.getURLRequest(url));
            tempMC.addChild(myLoader);
            MainManager.getAppLevel().addChild(tempMC);
            GV.onlineSocket.addEventListener("LL_method_CloseEvent",this.closeMotherUI);
         }
      }
      
      private function closeMotherUI(event:Event = null) : void
      {
         GV.onlineSocket.removeEventListener("LL_method_CloseEvent",this.closeMotherUI);
         var temp:* = MainManager.getAppLevel().getChildByName("method_UI_MC");
         GC.stopAllMC(temp);
         GC.clearAllChildren(temp);
         MainManager.getAppLevel().removeChild(temp);
      }
      
      private function doBoomHandler(evt:EventTaomee) : void
      {
         var tempmc:MovieClip = null;
         var mc:Class = null;
         var action:int = int(evt.EventObj.Action);
         if(action == 4)
         {
            tempmc = GF.getPeopleByID(evt.EventObj.UserID);
            mc = GV.Lib_Map.getClass("boom") as Class;
            tempmc.avatarMC.tomatoMC.addChild(new mc());
         }
      }
      
      private function bellActionHandler(evt:EventTaomee) : void
      {
         this.target_mc.bell_mc.gotoAndPlay(2);
      }
      
      private function initGetHouseImage() : void
      {
         this.button_mc.getImageBtn.addEventListener(MouseEvent.CLICK,this.onGetImageBtn);
      }
      
      private function onGetImageBtn(evt:MouseEvent) : void
      {
         BC.addEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.get160419);
         checkItem.checkItemHandler(160419);
      }
      
      private function get160419(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.get160419);
         if(evt.EventObj.num == 1)
         {
            GF.showAlert(GV.MC_AppLever,"\t你已經得到魔法雲朵變出的魔法拉姆雙層小屋啦，趕快去看看吧！","",100,"iknow",true,false,"E");
         }
         else if(GV.MAN_PEOPLE.Petlevel > 0)
         {
            if(GV.MAN_PEOPLE.Petlevel == 101 || petLogic.getPetMagicClass(GV.MAN_PEOPLE as PeopleManageView).hasFinish)
            {
               BC.addEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.itemSucHandler);
               checkItem.checkItemHandler(190392);
            }
            else
            {
               GF.showAlert(GV.MC_AppLever,"\t帶著超級拉姆或學完魔法課的拉姆一起過來吧，它們的神奇能力能幫助我們哦。","",100,"iknow",true,false,"E");
            }
         }
         else
         {
            GF.showAlert(GV.MC_AppLever,"\t帶著超級拉姆或學完魔法課的拉姆一起過來吧，它們的神奇能力能幫助我們哦。","",100,"iknow",true,false,"E");
         }
      }
      
      private function itemSucHandler(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.itemSucHandler);
         if(evt.EventObj.num == 1)
         {
            GF.showAlert(GV.MC_AppLever,"    聽說魔法雲朵就在有七色花的地方，帶著你的超級拉姆去找找吧。","",100,"iknow",true,false,"E");
         }
         else
         {
            this.message = "";
            this.url = "resource/allJob/AlertPic/rescue/GetHouseImage.swf";
            this.joinObj = Alert.showAlert(MainManager.getAppLevel(),this.url,this.message,Alert.CHANG_ALERT,"iknow",true,false,"SMCUI");
            this.joinObj.addEventListener("CLICK" + 1,this.getHouseImageF);
         }
      }
      
      private function getHouseImageF(evt:Event) : void
      {
         this.joinObj.removeEventListener("CLICK" + 1,this.getHouseImageF);
         var throwArr:Array = [];
         var getArr:Array = [{
            "kind":190392,
            "num":1
         }];
         GV.onlineSocket.addEventListener(giveMeMoneyRes.SERVER_GIVEMONEY,this.onImage);
         var giveCS:giveMeMoneyReq = new giveMeMoneyReq(throwArr,getArr);
      }
      
      private function onImage(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(giveMeMoneyRes.SERVER_GIVEMONEY,this.onImage);
         this.message = "    魔法拉姆雙層小屋設計圖紙已放入你的百寶箱中啦!";
         this.url = "resource/allJob/AlertPic/simpleAlertIcon/twoHouseIamge.swf";
         Alert.showAlert(MainManager.getAppLevel(),this.url,this.message,Alert.CHANG_ALERT,"iknow",true,false,"EMP_BUY");
      }
      
      override public function destroy() : void
      {
         if(Boolean(this.sgm_mc))
         {
            DisplayUtil.removeForParent(this.sgm_mc);
         }
         SystemEventManager.removeEventListener("getSGMFun",this.getSGMFun);
         SystemEventManager.removeEventListener("getSGMSuc",this.getSGMSuc);
         SystemEventManager.removeEventListener("loveTestState27",this.loveTestState27Handler);
         this.target_mc.robot_btn.removeEventListener(MouseEvent.CLICK,this.CLICKrobotFun);
         this.target_mc.forestOver_btn.removeEventListener(MouseEvent.CLICK,this.CLICKrobotOverFun);
         this.target_mc.allitem.item190016.item.methodgame_btn.removeEventListener(MouseEvent.CLICK,this.loadGameUI);
         this.target_mc.allitem.item190016.item.method_btn.removeEventListener(MouseEvent.MOUSE_DOWN,this.loadMotherUI);
         this.target_mc.mic_btn.removeEventListener(MouseEvent.CLICK,this.micHandler);
         if(Boolean(MainManager.getAppLevel().getChildByName("method_UI_MC")))
         {
            this.closeMotherUI();
         }
         if(Boolean(MainManager.getAppLevel().getChildByName("method_game_MC")))
         {
            this.closePoliceGame();
         }
         GV.onlineSocket.removeEventListener(sceneSoundModule.PLAY_MAPACTION,this.bellActionHandler);
         GV.onlineSocket.removeEventListener(moleActionRes.MOLE_SLIDE,this.doBoomHandler);
         this.button_mc.farm_mc.removeEventListener(MouseEvent.MOUSE_OVER,this.doorOverHandler);
         this.button_mc.farm_mc.removeEventListener(MouseEvent.MOUSE_OUT,this.doorOutHandler);
         this.button_mc.getImageBtn.removeEventListener(MouseEvent.CLICK,this.onGetImageBtn);
         this.R7bool = false;
         this.target_mc = null;
         this.button_mc = null;
         PowerClassInfo.getInstanse().clear();
         super.destroy();
      }
   }
}

