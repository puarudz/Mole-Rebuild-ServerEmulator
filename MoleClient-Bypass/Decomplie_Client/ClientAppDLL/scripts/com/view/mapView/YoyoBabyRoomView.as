package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.field.animalInfo.AnimalInfo;
   import com.core.info.LocalUserInfo;
   import com.core.loading.Loading;
   import com.core.newloader.LoaderList;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.socket.NPCJob.NpcJobSocket;
   import com.logic.socket.animalDeal.AnimalDealSocket;
   import com.logic.socket.breed.BreedSocket;
   import com.logic.socket.examinePack.examinePackStuff;
   import com.logic.socket.farm.farmSocket;
   import com.module.LocusWork.CollectProp;
   import com.module.activityModule.checkItem;
   import com.module.deal.Deal;
   import com.module.helpPanel.HelpPanel;
   import com.module.messageTips.MT;
   import com.module.superGift.thanksgivingModule;
   import com.view.PeopleView.PeopleManageView;
   import com.view.activetyView.AnimalSaleView;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class YoyoBabyRoomView extends BasicMapView
   {
      
      private var isJoin:Boolean;
      
      private var sitNum:int;
      
      private var waitPanel:Sprite;
      
      private var haveTime:int;
      
      private var animal_obj:AnimalInfo;
      
      private var animalSale:AnimalSaleView;
      
      private var joinObj:Object;
      
      private var xiaoduTimer:Timer;
      
      private var du:int;
      
      private var checkID:int;
      
      private var myBreedID:int;
      
      private var kindFlag:int = 0;
      
      public function YoyoBabyRoomView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         depth_mc.mouseEnabled = false;
         depth_mc.mouseChildren = false;
         this.waitPanel = Sprite(top_mc["waitPanel"]);
         BC.addEvent(this,GV.onlineSocket,"POLICE_DUTY_EVENT",this.checkDutyEvent);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1923,this.enterGameHandler);
         BC.addEvent(this,this.target_mc["houseBtn"],MouseEvent.CLICK,this.houseClick);
         BC.addEvent(this,this.target_mc["saleSheep_btn"],MouseEvent.CLICK,this.saleSheep);
         BC.addEvent(this,this.target_mc["saleSheep1_btn"],MouseEvent.CLICK,this.saleSheep);
         BC.addEvent(this,this.target_mc["saleSheep2_btn"],MouseEvent.CLICK,this.saleSheep);
         BC.addEvent(this,this.target_mc["info_btn"],MouseEvent.CLICK,this.showYoyoPanel);
         BC.addEvent(this,target_mc["jnn_mc"],MouseEvent.CLICK,this.milking_the_cow);
         BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_-" + 100108,this.ErrorFun);
         BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_-" + 100077,this.ErrorFun);
         BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_-" + 100103,this.ErrorFun);
         BC.addEvent(this,this.waitPanel["close_btn"],MouseEvent.CLICK,this.waitClose);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1926,this.firstSelectBack);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1924,this.setPlace);
         BreedSocket.selectBreed();
         BreedSocket.getPlaceInfo();
         this.initDisinfection();
         this.setFence();
         this.kakunianFun();
      }
      
      override public function init() : void
      {
         this.tuzipeiyu();
      }
      
      private function kakunianFun() : void
      {
         BC.addEvent(this,target_mc.kakunian,MouseEvent.CLICK,this.domesticateFun);
         BC.addEvent(this,target_mc.kakunian_btn,MouseEvent.CLICK,this.kakunianPanleFun);
      }
      
      private function kakunianPanleFun(evt:MouseEvent) : void
      {
         thanksgivingModule.getInstance().openKakunianFun();
      }
      
      private function domesticateFun(evt:MouseEvent) : void
      {
         thanksgivingModule.getInstance().domesticateFun();
      }
      
      private function setPlace(e:EventTaomee) : void
      {
         var mc:MovieClip = null;
         var obj:Object = e.EventObj;
         mc = top_mc["head0"];
         if(Boolean(obj.userID1))
         {
            this.setHead(mc.mc,obj.animal1);
            mc.visible = true;
         }
         else
         {
            mc.visible = false;
         }
         mc = top_mc["head1"];
         if(Boolean(obj.userID2))
         {
            this.setHead(mc.mc,obj.animal2);
            mc.visible = true;
         }
         else
         {
            mc.visible = false;
         }
      }
      
      private function setHead(mc:MovieClip, id:int) : void
      {
         switch(id)
         {
            case 1270015:
               mc.gotoAndStop(1);
               break;
            case 1270016:
               mc.gotoAndStop(2);
               break;
            case 1270017:
               mc.gotoAndStop(3);
               break;
            case 1270054:
               mc.gotoAndStop(4);
               break;
            case 1270058:
               mc.gotoAndStop(5);
         }
      }
      
      private function tuzipeiyu() : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE;
         if(Boolean(p) && Boolean(p.animal))
         {
            this.animal_obj = p.animal.getAnimalData();
            if(Boolean(this.animal_obj) && (this.animal_obj.ID == 1270015 || this.animal_obj.ID == 1270016 || this.animal_obj.ID == 1270017 || this.animal_obj.ID == 1270054 || this.animal_obj.ID == 1270058))
            {
               this.setHead(top_mc["breedPanel"]["tuzi"] as MovieClip,this.animal_obj.ID);
               if(this.animal_obj.Mature_time == 0)
               {
                  top_mc["breedPanel"].visible = false;
               }
               else
               {
                  top_mc["breedPanel"].visible = true;
               }
            }
            else
            {
               top_mc["breedPanel"].visible = false;
            }
            return;
         }
         if(Boolean(top_mc) && Boolean(top_mc["breedPanel"]))
         {
            top_mc["breedPanel"].visible = false;
         }
      }
      
      private function milking_the_cow(E:* = null) : void
      {
         if(this.check_milking())
         {
            BC.addEvent(this,target_mc["jnn_mc"],"movie_over",this.getMilkFun);
            PeopleManageView(GV.MAN_PEOPLE).animal.visible = false;
            BC.removeEvent(this,target_mc["jnn_mc"],MouseEvent.CLICK,this.milking_the_cow);
            target_mc["jnn_mc"].gotoAndPlay(2);
         }
      }
      
      private function check_milking() : Boolean
      {
         if(!PeopleManageView(GV.MAN_PEOPLE).hasAnimal)
         {
            Alert.smileAlart(MT.getMsg(20002));
            return false;
         }
         var obj:AnimalInfo = PeopleManageView(GV.MAN_PEOPLE).Animal_Info;
         var tempInt:int = obj.PollinationNum;
         if(obj.ID != 1270044)
         {
            Alert.smileAlart(MT.getMsg(20004));
            return false;
         }
         if(obj.Mature_time == 0)
         {
            Alert.smileAlart(MT.getMsg(20003));
            return false;
         }
         if(tempInt == 0)
         {
            Alert.smileAlart(MT.getMsg(-12634));
            return false;
         }
         if(tempInt == 100)
         {
            Alert.smileAlart(MT.getMsg(-12635));
            return false;
         }
         return true;
      }
      
      private function getMilkFun(E:Event) : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + 1993,this.getMilk_Suc_Fun);
         BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_" + 1993,this.getMilk_Error_Fun);
         AnimalDealSocket.milking_the_cow();
      }
      
      private function getMilk_Error_Fun(E:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1993,this.getMilk_Suc_Fun);
         BC.removeEvent(this,GV.onlineSocket,"ERROR_CMD_" + 1993,this.getMilk_Error_Fun);
         PeopleManageView(GV.MAN_PEOPLE).animal.visible = true;
         BC.addEvent(this,target_mc["jnn_mc"],MouseEvent.CLICK,this.milking_the_cow);
      }
      
      private function getMilk_Suc_Fun(E:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1993,this.getMilk_Suc_Fun);
         BC.removeEvent(this,GV.onlineSocket,"ERROR_CMD_" + 1993,this.getMilk_Error_Fun);
         Alert.smileAlart(MT.getMsg(20001));
         PeopleManageView(GV.MAN_PEOPLE).animal.visible = true;
         PeopleManageView(GV.MAN_PEOPLE).Animal_Info.PollinationNum = 0;
         BC.addEvent(this,target_mc["jnn_mc"],MouseEvent.CLICK,this.milking_the_cow);
      }
      
      private function setFence() : void
      {
         NpcJobSocket.askNpcJob(25);
         BC.addEvent(this,GV.onlineSocket,NpcJobSocket.GET_JOB,this.getJobBack);
      }
      
      private function getJobBack(e:EventTaomee) : void
      {
         var obj:Object = e.EventObj;
         if(obj.jobID == 25)
         {
            if(obj.jobStatus == 1)
            {
               this.checkThing(190647);
               return;
            }
         }
         this.failurePigdoor();
      }
      
      private function checkThing(id:int) : void
      {
         this.checkID = id;
         GV.onlineSocket.addEventListener(checkItem.chekItem_suc,this.itemSucHandler);
         checkItem.checkItemHandler(id);
      }
      
      private function failurePigdoor(frame:int = 3) : void
      {
         depth_mc["pigdoor"].gotoAndStop(frame);
         botton_mc["pigdoorbtn"].visible = false;
      }
      
      private function getPropFun(e:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,CollectProp.GET_PROP,this.getPropFun);
         this.failurePigdoor();
         Deal.BuyItem(190647,1,function(... e):*
         {
            Alert.getIconByID_Alart(190647,"    恭喜你得到" + GoodsInfo.getItemNameByID(190647) + "，快去找建設署的大郵筒交任務吧！");
         },function(... e):*
         {
            Alert.smileAlart("    你已經擁有這件寶貝啦，所以不能再領取了哦！");
         });
      }
      
      private function initDisinfection() : void
      {
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.joinDisinfection);
      }
      
      private function joinDisinfection(evt:EventTaomee) : void
      {
         var message:String = "    莊園中出現了一批小老虎寶寶，由於它們本身生活在野外，不能完全適應莊園的環境，因此要給他們消毒並且打完預防針後才能生活在莊園之中。你只需要站在消毒室前操作30秒不要離開就可以完成全部過程了，準備好要開始了嗎？";
         var url:String = "resource/allJob/AlertPic/yoyo/Disinfection.swf";
         this.joinObj = Alert.showAlert(MainManager.getGameLevel(),url,message,Alert.CHANG_ALERT,"sure,cancel",true,false,"SMCUI");
         this.joinObj.addEventListener("CLICK" + 1,this.doActionHandler);
      }
      
      private function doActionHandler(evt:Event) : void
      {
         var imageArr:Array = new Array(190295,190296);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1915,this.haveTiger);
         examinePackStuff.examinePack_create(imageArr);
      }
      
      private function haveTiger(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1915,this.haveTiger);
         var goodMoleImage:Boolean = false;
         for(var r:int = 0; r < evt.EventObj.Count; r++)
         {
            if(evt.EventObj.arr[r].count > 0)
            {
               goodMoleImage = true;
               break;
            }
         }
         if(goodMoleImage)
         {
            BC.removeEvent(this,GV.onlineSocket,"fireAction_select",this.joinDisinfection);
            BC.addEvent(this,GV.onlineSocket,"iskaddish",this.kaddishEndHandler);
            this.xiaoduTimer = new Timer(30000,1);
            this.xiaoduTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onXiaoduTimer);
            this.xiaoduTimer.start();
            GV.MAN_PEOPLE.visible = false;
            depth_mc.xiaodu.panel.gotoAndPlay(2);
         }
         else
         {
            Alert.showAlert(MainManager.getGameLevel(),"    你還沒有小老虎寶寶哦，快點去養一隻小母虎吧，牠成年後就會生小老虎寶寶了。","",6,"E");
         }
      }
      
      private function onXiaoduTimer(evt:TimerEvent) : void
      {
         this.clearxiaoduTimer();
         BC.removeEvent(this,GV.onlineSocket,"iskaddish",this.kaddishEndHandler);
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.joinDisinfection);
         depth_mc.xiaodu.panel.gotoAndStop(1);
         GV.MAN_PEOPLE.visible = true;
         BC.addEvent(this,GV.onlineSocket,"read_" + 1987,this.onRead_1987);
         BreedSocket.allExchange(1);
      }
      
      private function onRead_1987(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1987,this.onRead_1987);
         Alert.showAlert(MainManager.getGameLevel(),"    你的小老虎寶寶已經全部消完毒並且注射了預防針，帶回去好好照顧牠們吧！","",6,"E");
      }
      
      private function kaddishEndHandler(evt:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"iskaddish",this.kaddishEndHandler);
         this.clearxiaoduTimer();
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.joinDisinfection);
         depth_mc.xiaodu.panel.gotoAndStop(1);
         GV.MAN_PEOPLE.visible = true;
      }
      
      private function clearxiaoduTimer() : void
      {
         if(this.xiaoduTimer != null)
         {
            this.xiaoduTimer.reset();
            this.xiaoduTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onXiaoduTimer);
            this.xiaoduTimer = null;
         }
      }
      
      private function showYoyoPanel(e:MouseEvent = null) : void
      {
         HelpPanel.getInstance().panelVisible("YOYO_PANEL");
      }
      
      private function saleSheep(evt:MouseEvent = null) : void
      {
         this.animalSale = new AnimalSaleView();
         this.animalSale.checkBuyInfo();
      }
      
      private function firstSelectBack(e:EventTaomee) : void
      {
         var kindID:int = 0;
         var breedObj:Object = null;
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1926,this.firstSelectBack);
         var obj:Object = e.EventObj;
         if(obj.count == 0)
         {
            this.depth_mc["breedhouse"].gotoAndStop(1);
            return;
         }
         var flag:int = 0;
         for(var i:int = 0; i < obj.count; i++)
         {
            breedObj = obj.arr[i];
            if(breedObj.itemID == 1270015 || breedObj.itemID == 1270016 || breedObj.itemID == 1270017)
            {
               flag = 1;
               break;
            }
            if(breedObj.itemID == 1270054 || breedObj.itemID == 1270058)
            {
               flag = 2;
               break;
            }
         }
         if(!flag)
         {
            this.depth_mc["breedhouse"].gotoAndStop(1);
         }
         else if(flag == 1)
         {
            this.depth_mc["breedhouse"].gotoAndStop(2);
         }
         else
         {
            this.depth_mc["breedhouse"].gotoAndStop(3);
         }
      }
      
      private function waitClose(e:MouseEvent = null) : void
      {
         BreedSocket.beginBreed(this.sitNum,false);
      }
      
      private function ErrorFun(e:EventTaomee) : void
      {
         var msg:String = null;
         if(e.type == "ERROR_CMD_-" + 100108)
         {
            msg = "非常抱歉你來晚了一步哦，這個位置被其他小摩爾搶佔了呢！";
         }
         else if(e.type == "ERROR_CMD_-" + 100077)
         {
            msg = "錯位的位置資訊";
         }
         else if(e.type == "ERROR_CMD_-" + 100103)
         {
            msg = "帶著一隻成年的兔子或派對犬之後，再過來培育小寶寶吧。";
         }
         this.moveLeaveHandler();
         GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
      }
      
      private function houseClick(e:MouseEvent) : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + 1926,this.selectBack);
         BreedSocket.selectBreed();
      }
      
      private function tipsStandBreed() : void
      {
         var msg:String = null;
         if(this.animal_obj != null && (this.animal_obj.ID != 1270015 && this.animal_obj.ID != 1270016 && this.animal_obj.ID != 1270017))
         {
            msg = "快回家帶一隻兔子過來吧，這樣你才會培育兔寶寶哦！";
         }
         else
         {
            msg = "想讓你家的兔子生兔寶寶嗎？那就趕快站到旁邊的木樁上，把兔子放進去吧！";
         }
         if(this.animal_obj != null && (this.animal_obj.ID != 1270054 && this.animal_obj.ID != 1270058))
         {
            msg = "快回家帶一隻派對犬過來吧，這樣你才會培育派對小狗狗哦！";
         }
         else
         {
            msg = "想讓你家的派對犬生小狗狗嗎？那就趕快站到旁邊的木樁上，把派對犬放進去吧！";
         }
         if(this.animal_obj == null)
         {
            msg = "帶著一隻成年的兔子或派對犬之後，再過來培育小寶寶吧。";
         }
         GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
      }
      
      private function selectBack(e:EventTaomee) : void
      {
         var kindID:int = 0;
         var breedObj:Object = null;
         var breedMC:MovieClip = null;
         var tempMC:MCLoader = null;
         var msg0:String = null;
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1926,this.selectBack);
         var obj:Object = e.EventObj;
         var flag:int = 0;
         if(obj.count == 0)
         {
            this.tipsStandBreed();
            return;
         }
         for(var i:int = 0; i < obj.count; i++)
         {
            breedObj = obj.arr[i];
            if(breedObj.itemID == 1270015 || breedObj.itemID == 1270016 || breedObj.itemID == 1270017)
            {
               this.haveTime = breedObj.time;
               this.myBreedID = breedObj.itemID;
               kindID = int(breedObj.kindID);
               flag = 1;
               break;
            }
            if(breedObj.itemID == 1270054 || breedObj.itemID == 1270058)
            {
               this.haveTime = breedObj.time;
               this.myBreedID = breedObj.itemID;
               kindID = int(breedObj.kindID);
               flag = 2;
               break;
            }
         }
         if(!flag)
         {
            this.tipsStandBreed();
         }
         else if(this.haveTime != 0)
         {
            breedMC = new MovieClip();
            breedMC.name = "breedMC";
            MainManager.getGameLevel().addChild(breedMC);
            tempMC = new MCLoader("module/external/breed.swf",breedMC,Loading.TITLE_AND_PERCENT,"正在打開兔子培育室");
            BC.addEvent(this,tempMC,MCLoadEvent.ON_SUCCESS,this.loadbreedOver);
            LoaderList.getInstance().addItem(tempMC,null,LoaderList.HIGHEST_AND_CLOSE_OTHERS);
         }
         else
         {
            if(flag == 1)
            {
               msg0 = "恭喜你，兔子已放回你的牧場中，剛培育出的兔寶寶已放入你的牧場倉庫中了！";
            }
            else if(flag == 2)
            {
               msg0 = "恭喜你，派對犬已放入你的牧場中，剛培育出的小狗狗已放入你的牧場倉庫中了！";
            }
            GF.showAlert(GV.MC_AppLever,msg0,"",100,"iknow",true,false,"E");
            BreedSocket.getBreedResult(kindID);
            this.depth_mc["breedhouse"].gotoAndStop(1);
         }
      }
      
      private function loadbreedOver(evt:MCLoadEvent) : void
      {
         var content:* = undefined;
         var haveTime:int = 0;
         var mainMC:* = evt.getParent();
         var childMC:* = evt.getLoader();
         content = childMC["content"];
         mainMC.addChild(childMC);
         BC.addEvent(this,content,Event.REMOVED_FROM_STAGE,this.ContentRemoved);
         BC.addEvent(this,content,"TimerOver",this.timerOverFun);
         haveTime = this.haveTime;
         setTimeout(function():*
         {
            content["setTime"](haveTime);
            if(myBreedID == 1270054 || myBreedID == 1270058)
            {
               content.gotoAndStop(3);
            }
            else
            {
               content.gotoAndStop(2);
            }
         },10);
      }
      
      private function ContentRemoved(e:Event) : void
      {
         var content:* = e.currentTarget;
         BC.removeEvent(this,content,Event.REMOVED_FROM_STAGE,this.ContentRemoved);
         BC.removeEvent(this,content,"TimerOver",this.timerOverFun);
      }
      
      private function timerOverFun(e:Event) : void
      {
         BC.removeEvent(this,e.currentTarget,"TimerOver",this.timerOverFun);
         e.currentTarget.parent.parent.parent.removeChild(e.currentTarget.parent.parent);
         this.houseClick(null);
      }
      
      private function checkDutyEvent(evt:EventTaomee) : void
      {
         var msg:String = null;
         var num:int = 0;
         if(evt.EventObj.mc.name.indexOf("pigdoor") == -1)
         {
            if(evt.EventObj.mc.name.indexOf("stool") != -1)
            {
               if(this.depth_mc["breedhouse"].currentFrame == 2)
               {
                  msg = "你家的小動物正在育嬰房裡，趕快點擊看看小寶寶還有多長時間才出生吧！";
                  GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
                  this.moveLeaveHandler();
                  return;
               }
               if(this.animal_obj == null || this.animal_obj.ID != 1270015 && this.animal_obj.ID != 1270016 && this.animal_obj.ID != 1270017 && this.animal_obj.ID != 1270054 && this.animal_obj.ID != 1270058)
               {
                  msg = "快帶著一隻成年的兔子或派對犬之後，再過來培育小寶寶吧。";
                  GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
                  return;
               }
               if(this.animal_obj.Mature_time == 0)
               {
                  msg = "你家的小動物還沒有長大哦，小動物只有成年了才能生小寶寶哦!";
                  GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
                  return;
               }
               if((this.animal_obj.ID != 1270054 || this.animal_obj.ID != 1270058) && Boolean(this.animal_obj.Outgo & 0x10))
               {
                  msg = "你身邊的小狗狗已經培育過一次小寶寶了，不能再次培育了哦！";
                  GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
                  return;
               }
               num = int(String(evt.EventObj.mc.name).substr(5));
               this.sitNum = num;
               if(this.sitNum < 0)
               {
                  this.sitNum = 0;
               }
               this.gameStartHandler();
            }
         }
      }
      
      private function itemSucHandler(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(checkItem.chekItem_suc,this.itemSucHandler);
         var obj:Object = evt.EventObj;
         if(this.checkID == 180006)
         {
            this.gameStartHandler();
         }
         else if(this.checkID == 190647)
         {
            if(obj.num < 1)
            {
               new CollectProp(depth_mc["pigdoor"]);
               BC.addEvent(this,GV.onlineSocket,CollectProp.GET_PROP,this.getPropFun);
            }
            else
            {
               this.failurePigdoor();
            }
         }
      }
      
      private function gameStartHandler() : void
      {
         if(!this.isJoin)
         {
            GV.isSitDown = true;
            BreedSocket.beginBreed(this.sitNum);
         }
      }
      
      private function enterGameHandler(e:EventTaomee) : void
      {
         var msg:String = null;
         var p:PeopleManageView = null;
         var breed_obj:Object = e.EventObj;
         if(breed_obj.breedNum == 0)
         {
            this.waitPanel.x = 529;
         }
         else if(breed_obj.breedNum == 1)
         {
            if(this.animal_obj.ID == 1270016 || this.animal_obj.ID == 1270017 || this.animal_obj.ID == 1270015)
            {
               msg = "非常抱歉，只有眼鏡白兔與帥帥灰兔或肥肥花兔才能生出兔寶寶哦！";
            }
            else
            {
               msg = "非常抱歉，只有紳士派對犬和派對禮賓犬才能生出小狗寶寶哦!";
            }
         }
         else if(breed_obj.breedNum == 2)
         {
            this.waitPanel.x = -529;
            msg = "\t你的小動物正在培育小寶寶呢，明天過來你就可以領取新出生的小寶寶啦！";
            this.animal_obj.Outgo |= 8;
            if(this.animal_obj.ID == 1270016 || this.animal_obj.ID == 1270017 || this.animal_obj.ID == 1270015)
            {
               this.depth_mc["breedhouse"].gotoAndStop(2);
            }
            else
            {
               this.depth_mc["breedhouse"].gotoAndStop(3);
            }
            this.moveLeaveHandler();
            p = GF.getPeopleByID(LocalUserInfo.getUserID());
            if(Boolean(p.animal))
            {
               p.animal.clearClass();
            }
            p = GF.getPeopleByID(breed_obj.otherUID);
            if(Boolean(p.animal))
            {
               p.animal.clearClass();
            }
            this.isJoin = false;
            this.backAnm();
         }
         else if(breed_obj.breedNum == 3)
         {
            msg = "你的小動物正在培育小寶寶呢，明天過來你就可以領取新出生的小寶寶了。";
         }
         if(breed_obj.breedNum == 2 || breed_obj.breedNum == 3 || breed_obj.breedNum == 1)
         {
            this.moveLeaveHandler();
            GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
         }
         if(breed_obj.breedNum == 4)
         {
            this.waitPanel.x = -529;
            this.moveLeaveHandler();
         }
      }
      
      public function backAnm() : void
      {
         farmSocket.farm_follow(PeopleManageView(GV.MAN_PEOPLE).animal.getAnimalData().NO,0);
         PeopleManageView(GV.MAN_PEOPLE).delAnimal();
      }
      
      private function leaveGameHandler(event:EventTaomee) : void
      {
         if(event.EventObj.UserID == LocalUserInfo.getUserID())
         {
            GV.isSitDown = false;
            this.sitNum = -1;
            this.isJoin = false;
         }
      }
      
      private function haveSitHandler(evt:EventTaomee) : void
      {
         var obj:Object = evt.EventObj;
         Alert.showAlert(MainManager.getAppLevel(),obj.msg,"",6,"D");
         this.sitNum = -1;
         this.moveLeaveHandler();
         this.isJoin = false;
      }
      
      private function waringEvent(event:EventTaomee) : void
      {
         if(event.EventObj.UserID == LocalUserInfo.getUserID())
         {
            this.noSheepTip();
            this.moveLeaveHandler();
         }
      }
      
      private function moveLeaveHandler() : void
      {
         var tempX:int = 524;
         var tempY:int = 373;
         MoveTo.AutoFind(tempX,tempY,GV.MAN_PEOPLE);
         GV.isSitDown = false;
      }
      
      private function noSheepTip(e:EventTaomee = null) : void
      {
         var msg:String = null;
         this.moveLeaveHandler();
         if(e == null)
         {
            msg = "快帶著一隻成年的兔子或者派對禮賓犬之後，再過來培育小寶寶吧。";
         }
         else
         {
            msg = "你身邊的這隻動物和對方小摩爾的動物不能培育小寶寶哦。";
         }
         GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
      }
      
      override public function destroy() : void
      {
         this.clearxiaoduTimer();
         if(this.waitPanel.x == 529)
         {
            BreedSocket.beginBreed(this.sitNum,false);
         }
         clearTimeout(this.du);
         super.destroy();
      }
   }
}

