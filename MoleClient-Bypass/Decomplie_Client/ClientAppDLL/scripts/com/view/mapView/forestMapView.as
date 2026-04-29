package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.PetClassLogic.PetClassLogic;
   import com.logic.lamuMantraLogic.LamuMantra;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.logic.socket.getServerTimer.getServerTimerReq;
   import com.logic.socket.getServerTimer.getServerTimerRes;
   import com.logic.socket.presentGoods.PresentGoodsReq;
   import com.logic.socket.presentGoods.PresentGoodsRes;
   import com.logic.socket.randomItemLogic.randomItemReq;
   import com.logic.socket.randomItemLogic.randomItemRes;
   import com.module.activityModule.checkItem;
   import com.module.clothBuyModule.clothBuyModule;
   import com.module.cutMapModule.SaveCutMap;
   import com.module.deal.Deal;
   import com.module.pet.petClassLearnStatus;
   import com.module.pet.petLogic;
   import com.module.throwThing.throwHitTest;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.utils.Tool;
   import com.view.PeopleView.PeopleManageView;
   import com.view.mapView.activity.BackToYouthMapManager;
   import com.view.mapView.activity.Task83.DragonsTreasureActiviteCtl;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   
   public class forestMapView extends MapBase
   {
      
      private static var pho1:Boolean = false;
      
      private static var pho2:Boolean = false;
      
      private var lookMC:MovieClip;
      
      private var timer:Timer;
      
      private var helpBoolean:Boolean = false;
      
      private var nowPet_arr:Array;
      
      private var ClassNum:int;
      
      private var maigcTimer:Timer;
      
      private var gzmmnTimer:Timer;
      
      private var rabbitTimeFlag:Boolean = false;
      
      private var getRabbitNum:int = 0;
      
      private var lamuStartNum:int;
      
      private var _isHaveGoddess:uint;
      
      private var kindStr:String;
      
      public function forestMapView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         controlLevel.tutu_btn.visible = false;
         depthLevel.tutu_mc.visible = false;
         BC.addEvent(this,GV.onlineSocket,"GETBUTTERFLY_EVENT",this.butterFlyEvent);
         BC.addEvent(this,GV.onlineSocket,"GETFRUITER_EVENT",this.fruiterFlyEvent);
         BC.addEvent(this,controlLevel.redBtn,MouseEvent.CLICK,this.redEvent);
         BC.addEvent(this,controlLevel.tutu_btn,MouseEvent.CLICK,this.tutuFun);
         BC.addEvent(this,topLevel.tl_mc,"getYZ",this.getSYFun);
         var obj1:Object = {
            "btn":topLevel.tl_mc,
            "mc":topLevel.tl_mc,
            "id":"swf150002",
            "fre":2,
            "hide":true
         };
         throwHitTest.HitTestMC(obj1);
         controlLevel.activMC.mc_0.mc.gotoAndStop(2);
         controlLevel.activMC.mc_0.mc.mouseEnabled = false;
         GV.onlineSocket.addEventListener(randomItemRes.RANMOM_ITEM,this.activeHandler);
         randomItemReq.randomItemReqAction();
         var magicObj:petClassLearnStatus = petLogic.getPetMagicClass(GV.MAN_PEOPLE as PeopleManageView);
         if(!magicObj.hasFinish && magicObj.classID == 104 && magicObj.classStep == 5)
         {
            controlLevel.tutu_btn.visible = true;
            depthLevel.tutu_mc.visible = true;
         }
         else
         {
            controlLevel.tutu_btn.visible = false;
            depthLevel.tutu_mc.visible = false;
         }
         controlLevel.rabbit.visible = false;
         BC.addEvent(this,controlLevel["catchRabbit"],MouseEvent.CLICK,this.beginCatchRabbit);
         BC.addEvent(this,controlLevel["rabbit"],MouseEvent.CLICK,this.rabbitClick);
         BC.addEvent(this,controlLevel["rabbit"],"catchRabbit",this.catchRabbit);
         BC.addEvent(this,controlLevel["lamu"],"beginHit",this.hitTestRabbit);
         BC.addEvent(this,controlLevel["lamu"],"playover",this.lamuGoBack);
         SystemEventManager.addEventListener("openBQL",this.clickinteractMc);
         getServerTimerReq.getServerTimer(this,"getServerTimer");
         DragonsTreasureActiviteCtl.instance.InitMap();
         BackToYouthMapManager.instence.initView(controlLevel["npc_mc"]);
         GV.onlineSocket.addEventListener("getGameFraction",this.onSubmitFireBugScore);
      }
      
      private function beginCatchRabbit(e:MouseEvent) : void
      {
         var lamu:MovieClip = null;
         if(!this.rabbitTimeFlag)
         {
            Alert.showAlert(GV.MC_TopLever,"這些小兔子很狡猾哦，它們只有在晚上6—8點小摩爾吃晚飯時才來偷吃胡蘿蔔哦，那時候再來抓它們吧。","",6,"D");
            return;
         }
         if(this.getRabbitNum >= 3)
         {
            Alert.showAlert(GV.MC_TopLever,"你抓到了3隻兔子啦，其他兔子都被你嚇走了，要麼你明天再來抓吧！","",6,"D");
            return;
         }
         if(GV.MAN_PEOPLE.Petlevel > 0)
         {
            switch(GV.MAN_PEOPLE.Petlevel)
            {
               case 2:
                  this.lamuStartNum = 7;
                  break;
               case 3:
                  this.lamuStartNum = 14;
                  break;
               case 4:
                  this.lamuStartNum = 21;
                  break;
               case 101:
                  this.lamuStartNum = 0;
            }
            PeopleManageView(GV.MAN_PEOPLE).avatarMC.pet_mc.visible = false;
            lamu = MovieClip(controlLevel["lamu"]);
            lamu.visible = true;
            lamu.gotoAndStop(this.lamuStartNum + 1);
            BC.addEvent(this,lamu,Event.ENTER_FRAME,function(e:Event):void
            {
               if(Boolean(lamu.petBody))
               {
                  GF.setPetColor(lamu.petBody,GV.MyInfo_PetObj.Color);
               }
            });
         }
         else
         {
            GF.showAlert(MainManager.getGameLevel(),"    帶著你的小拉姆一起來吧，它可是抓小兔子的能手哦！","",100,"iknow",true,false,"E");
         }
      }
      
      private function lamuGoBack(e:Event) : void
      {
         MovieClip(controlLevel["lamu"]).visible = false;
         PeopleManageView(GV.MAN_PEOPLE).avatarMC.pet_mc.visible = true;
         MovieClip(controlLevel["lamu"]).gotoAndStop(this.lamuStartNum + 1);
         BC.removeEvent(this,controlLevel["lamu"],Event.ENTER_FRAME);
      }
      
      private function clickinteractMc(e:Event) : void
      {
         Tool.exchangeGoods(3632);
      }
      
      private function catchRabbit(e:EventTaomee) : void
      {
         this.kindStr = String(e.EventObj);
         ++this.getRabbitNum;
         this.checkCanRabbit();
         GV.onlineSocket.addEventListener(PresentGoodsRes.PRESENT_GOODS_SUCC,this.getRabbitSucc);
         GV.onlineSocket.addEventListener("ERROR_CMD_1116",this.getRabbitError);
         if(this.kindStr == "black")
         {
            PresentGoodsReq.req(66);
         }
         else if(this.kindStr == "white")
         {
            PresentGoodsReq.req(61);
         }
      }
      
      private function getRabbitSucc(e:Event) : void
      {
         if(this.kindStr == "black")
         {
            Alert.getIconByID_Alart(1270016,"    哇！你的小拉姆幫你抓到了一隻帥帥灰兔哦，趕快回牧場倉庫看看吧！");
         }
         else if(this.kindStr == "white")
         {
            Alert.getIconByID_Alart(1270015,"    哇！你的小拉姆幫你抓到了一隻眼鏡白兔哦，趕快回牧場倉庫看看吧！");
         }
         this.getRabbitError();
      }
      
      private function getRabbitError(e:Event = null) : void
      {
         this.controlLevel["rabbit"].gotoAndPlay(1);
         GV.onlineSocket.removeEventListener(PresentGoodsRes.PRESENT_GOODS_SUCC,this.getRabbitSucc);
         GV.onlineSocket.removeEventListener("ERROR_CMD_1116",this.getRabbitError);
      }
      
      private function rabbitClick(e:MouseEvent) : void
      {
         if(!MovieClip(controlLevel["lamu"]).visible)
         {
            return;
         }
         var flag:Boolean = false;
         if(Math.random() > 0.5)
         {
            flag = true;
         }
         var lamu:MovieClip = MovieClip(controlLevel["lamu"]);
         if(MovieClip(controlLevel["rabbit"]).currentFrame <= 4)
         {
            if(flag)
            {
               lamu.gotoAndStop(this.lamuStartNum + 2);
            }
            else
            {
               lamu.gotoAndStop(this.lamuStartNum + 3);
            }
         }
         else if(MovieClip(controlLevel["rabbit"]).currentFrame <= 8)
         {
            if(flag)
            {
               lamu.gotoAndStop(this.lamuStartNum + 4);
            }
            else
            {
               lamu.gotoAndStop(this.lamuStartNum + 5);
            }
         }
         else if(MovieClip(controlLevel["rabbit"]).currentFrame <= 12)
         {
            if(flag)
            {
               lamu.gotoAndStop(this.lamuStartNum + 6);
            }
            else
            {
               lamu.gotoAndStop(this.lamuStartNum + 7);
            }
         }
         else if(MovieClip(controlLevel["rabbit"]).currentFrame <= 16)
         {
            if(flag)
            {
               lamu.gotoAndStop(this.lamuStartNum + 2);
            }
            else
            {
               lamu.gotoAndStop(this.lamuStartNum + 3);
            }
         }
         else if(MovieClip(controlLevel["rabbit"]).currentFrame <= 20)
         {
            if(flag)
            {
               lamu.gotoAndStop(this.lamuStartNum + 4);
            }
            else
            {
               lamu.gotoAndStop(this.lamuStartNum + 5);
            }
         }
         else if(MovieClip(controlLevel["rabbit"]).currentFrame <= 24)
         {
            if(flag)
            {
               lamu.gotoAndStop(this.lamuStartNum + 6);
            }
            else
            {
               lamu.gotoAndStop(this.lamuStartNum + 7);
            }
         }
      }
      
      private function hitTestRabbit(e:Event) : void
      {
         var num:Number = NaN;
         var mc:MovieClip = MovieClip(controlLevel["rabbit"].getChildAt(0));
         var lamu:MovieClip = MovieClip(controlLevel["lamu"]);
         if(mc.currentLabel == "runover")
         {
            mc.gotoAndPlay("runout");
         }
         else if(mc.currentLabel == "eating")
         {
            num = lamu.currentFrame - this.lamuStartNum;
            if(num % 2 == 0)
            {
               mc.gotoAndPlay("hiting");
            }
            else
            {
               mc.gotoAndPlay("runout");
            }
         }
         else if(mc.currentLabel != "runout")
         {
            if(mc.currentLabel == "hiting")
            {
            }
         }
      }
      
      private function getServerDate(evt:EventTaomee) : void
      {
         var E:Date = evt.EventObj as Date;
         this.getServerTimer(E);
      }
      
      public function getServerTimer(E:Date) : void
      {
         BC.addEvent(this,GV.onlineSocket,getServerTimerRes.GET_SERVER_TIMER,this.getServerDate);
         var days:int = E.getDate();
         var hours:int = E.getHours();
         if(hours >= 18 && hours < 20)
         {
            if(!this.rabbitTimeFlag)
            {
               this.rabbitTimeFlag = true;
               this.checkHaveRabbit();
            }
         }
         else
         {
            this.rabbitTimeFlag = false;
            controlLevel.rabbit.visible = false;
         }
      }
      
      private function checkHaveRabbit() : void
      {
         BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.checkHaveRabbitBack);
         finishSomethingReq.sendReq(310);
      }
      
      private function checkHaveRabbitBack(e:EventTaomee) : void
      {
         if(e.EventObj.Type == 310)
         {
            this.getRabbitNum = e.EventObj.Done;
            this.checkCanRabbit();
         }
      }
      
      private function checkCanRabbit() : void
      {
         if(this.getRabbitNum < 3)
         {
            controlLevel.rabbit.visible = true;
         }
         else
         {
            controlLevel.rabbit.visible = false;
         }
      }
      
      private function getSYFun(E:Event) : void
      {
         topLevel.t2_mc.visible = true;
         BC.addEvent(this,topLevel.t2_mc,MouseEvent.CLICK,this.getSY2Fun);
      }
      
      private function getSY2Fun(E:Event) : void
      {
         BC.removeEvent(this,topLevel.t2_mc,MouseEvent.CLICK,this.getSY2Fun);
         topLevel.t2_mc.visible = false;
         Deal.BuyItem(190412,5,function(E:*):*
         {
            Alert.getIconByID_Alart(190412,"　　恭喜你獲得了5片新鮮的桑葉，趕快送給蠶寶寶吃吧！");
         },function(... E):*
         {
            Alert.getIconByID_Alart(190412,"　　今天你已經從螳螂這裡拿到很多桑葉了，明天再來吧。");
         });
      }
      
      private function tutuFun(event:MouseEvent) : void
      {
         depthLevel.tutu_mc.gotoAndStop(2);
         this.initTuTuGetPhoto();
      }
      
      private function initTuTuGetPhoto() : void
      {
         var magicObj:petClassLearnStatus = petLogic.getPetMagicClass(GV.MAN_PEOPLE as PeopleManageView);
         if(!magicObj.hasFinish && magicObj.classID == 104 && magicObj.classStep == 5 && Boolean(magicObj.LearnFlagArray[7]))
         {
            Alert.imagesBigAlert("　　太謝謝你了，這個照片太珍貴了。你的拉姆真能幹，多麼神奇的魔法呀。快回到魔法閣樓找你的老師領取畢業徽章吧。","resource/allJob/AlertPic/petMagicClass/103_104_2.swf");
            return;
         }
         if(this.helpBoolean)
         {
            return;
         }
         if(PeopleManageView(GV.MAN_PEOPLE).Petlevel > 0)
         {
            BC.addEvent(this,PetClassLogic.getPetClassLogics(),PetClassLogic.GET_PETCLASS,this.getLamuInfo);
            PetClassLogic.getPetClassLogics().GetPetClass(GV.MyInfo_PetObj.SpriteID);
         }
         else
         {
            Alert.imagesAlert("　　啊呀，忘帶拉姆來了。","lamu");
         }
      }
      
      private function getLamuInfo(eve:EventTaomee) : void
      {
         BC.removeEvent(this,PetClassLogic.getPetClassLogics(),PetClassLogic.GET_PETCLASS,this.getLamuInfo);
         this.nowPet_arr = eve.EventObj.petClassList;
         if(this.nowPet_arr.length == 0)
         {
            return;
         }
         for(var i:int = 0; i < this.nowPet_arr.length; )
         {
            if(this.nowPet_arr[i].classID == 104)
            {
               if(this.nowPet_arr[i].classStep == 5)
               {
                  this.ClassNum = this.nowPet_arr[i].classID;
                  if(this.nowPet_arr[i].arr[5] == 1)
                  {
                     if(this.nowPet_arr[i].arr[6] == 0 || this.nowPet_arr[i].arr[7] == 0)
                     {
                        topLevel.mmn_mc.gotoAndStop(2);
                        Alert.imagesBigAlert("　　我等了好多天了，摩摩鳥還是沒出現，聽說就是在漿果叢林呀。你能用感應魔法幫我拍到摩摩鳥的照片嗎？穿上記者服點擊摩摩鳥就能拍攝了。","resource/allJob/AlertPic/petMagicClass/103_104.swf",this.helpTuTuFun,"npcgo");
                        this.helpBoolean = true;
                        break;
                     }
                  }
                  else
                  {
                     Alert.imagesAlert("　　你帶的拉姆還沒報名考核哦。","lamu");
                  }
               }
            }
            i++;
         }
      }
      
      private function helpTuTuFun(E:*) : void
      {
         Alert.imagesBigAlert("　　我已經感應到了，看，摩摩鳥就在前面！\n看我的魔法感應！","resource/allJob/AlertPic/petMagicClass/103_104_1.swf",this.lamuSayFun);
      }
      
      private function lamuSayFun(E:*) : void
      {
         Alert.imagesBigAlert("　　小主人,在我釋放魔法後,快快點擊摩摩鳥,幫兔兔拍下它吧。","resource/allJob/AlertPic/petMagicClass/103_104_1.swf",this.userMagicFun);
      }
      
      private function userMagicFun(E:*) : void
      {
         BC.addEvent(this,LamuMantra,LamuMantra.BIBOBIBO,this.shikongganying);
         BC.addEvent(this,LamuMantra,LamuMantra.BIBOBIBO_OVER,this.hasShikongganying);
         GC.clearGTimeout(this.maigcTimer);
         this.maigcTimer = GC.setGTimeout(LamuMantra.shikongganying,1000,"shikongganying");
      }
      
      private function shikongganying(E:EventTaomee) : void
      {
         this.hasShikongganying();
      }
      
      private function hasShikongganying(E:* = null) : void
      {
         if(LamuMantra.currentMagic == "shikongganying")
         {
            topLevel.mmn_mc.gotoAndStop(3);
            GC.clearGInterval(this.gzmmnTimer);
            this.gzmmnTimer = GC.setGInterval(this.gzMmnFun,50);
            BC.addEvent(this,topLevel.gzmmn_mc,MouseEvent.CLICK,this.tryCameraHandler);
         }
         else
         {
            topLevel.mmn_mc.gotoAndStop(1);
            this.helpBoolean = false;
            GC.clearGInterval(this.gzmmnTimer);
         }
         MainManager.getStage().frameRate = 16;
      }
      
      private function tryCameraHandler(E:MouseEvent) : void
      {
         var tempNum:int = 0;
         if(!SaveCutMap.isUseCamera && Boolean(GV.MAN_PEOPLE))
         {
            tempNum = int(GV.JobLogics.chartUnusualCloth(GV.MAN_PEOPLE.clothsArray));
            if(!SaveCutMap.isUseCamera && GoodsInfo.ClothObject[tempNum] == "記者")
            {
               SaveCutMap.G_addEventListener(SaveCutMap.GET_CAMERA_CLASS,this.getCameraClass);
               SaveCutMap.GetCamera();
            }
            else
            {
               Alert.smileAlart("　　只能穿記者套裝才能拍照哦!");
            }
         }
      }
      
      private function getCameraClass(E:EventTaomee) : void
      {
         SaveCutMap.G_removeEventListener(SaveCutMap.GET_CAMERA_CLASS,this.getCameraClass);
         var tempClass:* = E.EventObj;
         tempClass.lockTargetMC(topLevel.gzmmn_mc);
         BC.addEvent(this,tempClass,Event.CLOSE,this.CameraOpen);
      }
      
      private function CameraOpen(E:Event) : void
      {
         BC.removeEvent(this,E.currentTarget,Event.COMPLETE,this.CameraOpen);
         if(!pho1)
         {
            pho1 = true;
            this.photo1Fun();
         }
         else if(!pho2)
         {
            pho2 = true;
            this.photo2Fun();
         }
      }
      
      private function gzMmnFun() : void
      {
         var rect:Rectangle = topLevel.mmn_mc.getRect(topLevel);
         topLevel.gzmmn_mc.x = rect.x + rect.width / 2;
         topLevel.gzmmn_mc.y = rect.y + rect.height / 2;
      }
      
      private function photo1Fun(E:* = null) : void
      {
         topLevel.photo1_mc.play();
         MainManager.getGameLevel().addChild(topLevel.photo1_mc);
         BC.addEvent(this,topLevel.photo1_mc,"over",this.helpOverFun);
      }
      
      private function photo2Fun(E:* = null) : void
      {
         BC.addEvent(this,topLevel.photo2_mc,"over",this.helpOverFun);
         topLevel.photo2_mc.play();
         MainManager.getGameLevel().addChild(topLevel.photo2_mc);
      }
      
      private function helpOverFun(E:* = null) : void
      {
         BC.removeEvent(this,topLevel.photo2_mc,"over",this.helpOverFun);
         for(var i:int = 0; i < this.nowPet_arr.length; i++)
         {
            if(this.nowPet_arr[i].classID == 104)
            {
               if(this.nowPet_arr[i].arr[6] == 0)
               {
                  this.nowPet_arr[i].arr[6] = 1;
               }
               else if(this.nowPet_arr[i].arr[7] == 0)
               {
                  this.nowPet_arr[i].arr[7] = 1;
                  GC.clearGInterval(this.gzmmnTimer);
                  BC.addEvent(this,PetClassLogic.getPetClassLogics(),"set_class_data",this.set_class_data);
               }
               PetClassLogic.getPetClassLogics().setClassData(PeopleManageView(GV.MAN_PEOPLE).PetID,this.ClassNum,this.nowPet_arr[i].arr);
               break;
            }
         }
      }
      
      private function set_class_data(event:EventTaomee) : void
      {
         BC.removeEvent(this,PetClassLogic.getPetClassLogics(),"set_class_data",this.set_class_data);
         Alert.imagesBigAlert("　　太謝謝你了，這個照片太珍貴了。你的拉姆真能幹，多麼神奇的魔法呀。快回到魔法閣樓找你的老師領取畢業徽章吧。","resource/allJob/AlertPic/petMagicClass/103_104_2.swf");
      }
      
      private function redEvent(evt:MouseEvent) : void
      {
         var itemObj:Object = new Object();
         itemObj.id = 12134;
         itemObj.price = 0;
         itemObj.info = "0";
         clothBuyModule.buyAction(itemObj);
      }
      
      private function butterFlyEvent(evt:Event) : void
      {
         var itemObj:Object = new Object();
         itemObj.id = 190038;
         itemObj.price = 0;
         itemObj.info = "0";
         clothBuyModule.buyAction(itemObj);
      }
      
      private function fruiterFlyEvent(evt:Event) : void
      {
         var itemObj:Object = new Object();
         itemObj.id = 12135;
         itemObj.price = 0;
         itemObj.info = "0";
         clothBuyModule.buyAction(itemObj);
      }
      
      private function checkItemEvent() : void
      {
         if(!LocalUserInfo.isVIP())
         {
            return;
         }
         GV.onlineSocket.addEventListener(checkItem.chekItem_suc,this.itemSucHandler);
         checkItem.checkItemHandler(1220018);
      }
      
      private function itemSucHandler(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(checkItem.chekItem_suc,this.itemSucHandler);
         if(evt.EventObj.num == 1)
         {
            controlLevel.LeafageMC.visible = true;
         }
      }
      
      private function activeHandler(evt:EventTaomee) : void
      {
         var tempArray:Array = null;
         var itemID:int = 0;
         var j:int = 0;
         var num:int = 0;
         var tempNum:int = 0;
         controlLevel.activMC.mc_0.mc.gotoAndStop(2);
         controlLevel.activMC.mc_0.mc.mouseEnabled = false;
         var itemArray:Array = evt.EventObj.itemArray;
         for(var i:int = 0; i < itemArray.length; i++)
         {
            tempArray = itemArray[i].itemArray;
            itemID = int(itemArray[i].itemID);
            for(j = 0; j < tempArray.length; j++)
            {
               num = int(tempArray[j]);
               tempNum = tempArray.length - j - 1;
               if(num == 1)
               {
                  controlLevel.activMC["mc_" + tempNum].mc.gotoAndStop(1);
                  controlLevel.activMC["mc_" + tempNum].mc.mouseEnabled = true;
                  controlLevel.activMC["mc_" + tempNum].discreteness.changeBool = false;
               }
            }
         }
      }
      
      private function clickHandler(evt:MouseEvent) : void
      {
         var tempMC:Class = null;
         if(!topLevel.getChildByName("lookMC"))
         {
            tempMC = GV.Lib_Map.getClass("maskMC");
            this.lookMC = new tempMC();
            this.lookMC.name = "lookMC";
            topLevel.addChild(this.lookMC);
            this.lookMC.buttonMode = true;
            this.lookMC.addEventListener(MouseEvent.MOUSE_MOVE,this.moveHandler);
            this.lookMC.addEventListener(MouseEvent.CLICK,this.removeClick);
         }
      }
      
      private function moveHandler(evt:Event) : void
      {
         this.lookMC.mc.startDrag(true);
      }
      
      private function removeClick(evt:MouseEvent) : void
      {
         this.lookMC.removeEventListener(MouseEvent.MOUSE_MOVE,this.moveHandler);
         this.lookMC.removeEventListener(MouseEvent.CLICK,this.removeClick);
         GC.stopAllMC(this.lookMC);
         GC.clearChildren(this.lookMC);
         this.lookMC.parent.removeChild(this.lookMC);
         this.lookMC = null;
      }
      
      private function onSubmitFireBugScore(e:*) : void
      {
         trace("收到時間了麼");
      }
      
      override public function destroy() : void
      {
         GC.clearGInterval(this.gzmmnTimer);
         GC.clearGTimeout(this.maigcTimer);
         SystemEventManager.removeEventListener("openBQL",this.clickinteractMc);
         GV.onlineSocket.removeEventListener(randomItemRes.RANMOM_ITEM,this.activeHandler);
         GV.onlineSocket.removeEventListener("getGameFraction",this.onSubmitFireBugScore);
         BC.removeEvent(this);
         DragonsTreasureActiviteCtl.instance.destroy();
         super.destroy();
      }
   }
}

