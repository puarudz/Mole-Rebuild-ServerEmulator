package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.logic.socket.shopItem.BuyItemReq;
   import com.logic.socket.shopItem.BuyItemRes;
   import com.logic.socket.smc.PickItem.PickItemRes;
   import com.module.activityModule.giftModule;
   import com.module.clothBuyModule.clothBuyModule;
   import com.module.helpPanel.HelpPanel;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.mapModule.Map52PetClass15;
   import com.module.superPetModule.petItemModule;
   import com.module.teacherDay.Teacherday;
   import com.mole.app.map.MapBase;
   import com.mole.app.task.TaskManager;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.utils.Timer;
   
   public class ClassMapView extends MapBase
   {
      
      public static const PUMPKIN_GAME_WIN:String = "pumpkinGameWin";
      
      private var topMC:MovieClip;
      
      private var target_mc:MovieClip;
      
      private var depth_mc:MovieClip;
      
      private var botton_mc:MovieClip;
      
      private var look_mc:MovieClip;
      
      private var uncleArray:Array;
      
      private var teacherday:Teacherday;
      
      public var kevinNPCLogic:MovieClip;
      
      public var soundHao:Sound;
      
      public var haoChanler:SoundChannel;
      
      private var Buys:BuyItemReq;
      
      private var help:MovieClip;
      
      private var IsGoods:Boolean;
      
      private var goodsBool:Boolean = true;
      
      private var myTimer:Timer;
      
      private var teachTimer:Timer;
      
      private var studyList:Array = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
      
      private var ignorantList:Array = new Array();
      
      private var taskObj:Object;
      
      private var task79Obje:Object;
      
      private var joinObj:Object;
      
      private var message:String;
      
      private var url:String;
      
      private var boxMC:MovieClip;
      
      public function ClassMapView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         this.topMC = GV.MC_mapFrame["top_mc"];
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.lookHandler);
         var bgSound:Class = GV.Lib_Map.getClass("sound_select");
         this.soundHao = new bgSound();
         BC.addEvent(this,this.target_mc.getJob_btn,MouseEvent.CLICK,this.chartPetJob);
         BC.addEvent(this,this.topMC.schoolSongBtn,MouseEvent.CLICK,this.schoolSongHandler);
         BC.addEvent(this,this.target_mc.fishBox_mc,MouseEvent.CLICK,this.initGame);
         BC.addEvent(this,this.target_mc.pic1_btn,MouseEvent.CLICK,this.initGame);
         BC.addEvent(this,this.target_mc.pic2_btn,MouseEvent.CLICK,this.initGame);
         BC.addEvent(this,this.target_mc.lamutest_btn,MouseEvent.CLICK,this.initLamuTestGame);
         BC.addEvent(this,this.target_mc.sound_btn,MouseEvent.MOUSE_OVER,this.BoxOverHandler);
         BC.addEvent(this,this.target_mc.sound_btn,MouseEvent.MOUSE_OUT,this.BoxOutHandler);
         BC.addEvent(this,this.target_mc.sound_btn,MouseEvent.CLICK,this.BoxClickHandler);
         BC.addEvent(this,this.target_mc.kevin_npcMC,MouseEvent.CLICK,this.kevinSay);
         BC.addEvent(this,this.target_mc.fire_action,MouseEvent.MOUSE_OVER,this.WindowOverHandler);
         BC.addEvent(this,this.target_mc.fire_action,MouseEvent.MOUSE_OUT,this.WindowOutHandler);
         BC.addEvent(this,this.target_mc["pumpkinBtn"],MouseEvent.CLICK,this.pumpkinGame);
         BC.addEvent(this,GV.onlineSocket,"lamuLanguagueTestGameEvent",this.lamuLanguagueTestGameEventHandler);
         BC.addEvent(this,GV.onlineSocket,PUMPKIN_GAME_WIN,this.carvePumpkinWinHandler);
         BC.addEvent(this,GV.onlineSocket,PickItemRes.PICK_ITEM,this.onPickItem);
         BC.addEvent(this,this.target_mc.clearMud_btn,MouseEvent.CLICK,this.getclearMud);
         BC.addEvent(this,this.target_mc.awardBtn,MouseEvent.CLICK,this.awardBtnHandler);
         var Map52PetClass15s:Map52PetClass15 = new Map52PetClass15();
         Map52PetClass15s.beginInfo();
         var t:Loader = new Loader();
         var tempPath:String = "module/lamuCertificate/LamuCertificate.swf";
         t.load(VL.getURLRequest(tempPath));
         BC.addEvent(this,this.target_mc.certification_btn,MouseEvent.CLICK,this.certificationHandler);
         this.target_mc.book_mc.buttonMode = true;
      }
      
      private function certificationHandler(e:MouseEvent) : void
      {
         GV.onlineSocket.dispatchEvent(new Event("showCertification"));
      }
      
      private function lamuLanguagueTestGameEventHandler(e:EventTaomee) : void
      {
         var arr:Array = null;
         var rightCount:int = int(e.EventObj.rightCount);
         if(rightCount == 7)
         {
            BC.addEvent(this,GV.PetJobLogics,"overOne_petResult",this.showPassGameTip);
            arr = [{
               "petID":GV.MyInfo_PetObj.SpriteID,
               "classID":16
            }];
            GV.PetJobLogics.SetOverOneClass(arr);
         }
      }
      
      private function showPassGameTip(eve:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.PetJobLogics,"overOne_petResult",this.showPassGameTip);
         var pet_arr:Array = GV.MyInfo_PetObj.Job;
         for(var i:int = 0; i < pet_arr.length; i++)
         {
            if(pet_arr[i].ClassID == 16)
            {
               pet_arr[i].Status = 3;
            }
         }
         GV.MyInfo_PetObj.Job = pet_arr;
         var url:String = "resource/allJob/AlertPic/kv/petclass15_2.swf";
         var msg:String = "    你的拉姆已經順利通過了動物課1的考試！快去領獎台領取畢業證書吧！";
         this.showNextAlt(url,msg);
      }
      
      private function showNextAlt(url:String, msg:String) : void
      {
         Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"iknow",true,false,"SMCUI");
      }
      
      private function initLamuTestGame(e:MouseEvent) : void
      {
         if(GV.MAN_PEOPLE.Petlevel <= 1)
         {
            var url:String = "resource/allJob/AlertPic/kv/petclass15_2.swf";
            var msg:String = "    你還沒有帶著拉姆，不能參加動物課1考試哦！";
            this.showNextAlt(url,msg);
            return;
         }
         var pet_arr:Array = GV.MyInfo_PetObj.Job;
         if(pet_arr[0] == null)
         {
            url = "resource/allJob/AlertPic/kv/petclass15_2.swf";
            msg = "    拉姆要先在學院教導處學習動物課1，才能來參加考試哦。通過考試，拉姆就可以聽懂動物們說話了！";
            this.showNextAlt(url,msg);
            return;
         }
         var hasPetLanguage:Boolean = false;
         for(var i:uint = 0; i < pet_arr.length; i++)
         {
            if(pet_arr[i].ClassID == 16)
            {
               hasPetLanguage = true;
               if(pet_arr[i].Status == 3)
               {
                  url = "resource/allJob/AlertPic/kv/petclass15_2.swf";
                  msg = "    親愛的小拉姆，你已經通過了拉姆動物課1的考核哦！";
                  this.showNextAlt(url,msg);
                  return;
               }
               if(pet_arr[i].Days < 3)
               {
                  url = "resource/allJob/AlertPic/kv/petclass15_2.swf";
                  msg = "    這裡是拉姆動物課1考試！你的拉姆還沒有學完動物課1。快去學院教導處給它報名選課吧。通過考試，拉姆就可以聽懂動物們說話！";
                  this.showNextAlt(url,msg);
                  return;
               }
            }
         }
         if(!hasPetLanguage)
         {
            url = "resource/allJob/AlertPic/kv/petclass15_2.swf";
            msg = "    拉姆要先在學院教導處學習動物課1，才能來參加考試哦。通過考試，拉姆就可以聽懂動物們說話了！";
            this.showNextAlt(url,msg);
            return;
         }
         url = "module/game/lamuLangueTest.swf";
         msg = "正在加載拉姆動物課1語言考試";
         var loadGame:LoadGame = new LoadGame(url,msg,MainManager.getGameLevel());
         loadGame = null;
      }
      
      private function examineEvent(event:MouseEvent) : void
      {
         var itemObj:Object = new Object();
         itemObj.id = 12331;
         itemObj.price = 0;
         itemObj.info = "";
         clothBuyModule.buyAction(itemObj);
      }
      
      private function awardBtnHandler(event:MouseEvent) : void
      {
         HelpPanel.getInstance().panelVisible("AWARD");
      }
      
      private function schoolSongHandler(event:MouseEvent) : void
      {
         var loadGame:LoadGame = new LoadGame("module/external/SchoolSong.swf","正在打開拉姆校歌",MainManager.getAppLevel());
         loadGame = null;
      }
      
      private function giftHandler(evt:MouseEvent) : void
      {
         var type:Number = 6;
         var str:String = "resource/giftItem/gift026.swf";
         var info:String = "你的超級拉姆幫你找到了大禮包,要撿起來嗎?";
         giftModule.succMsg = "物品已經放入你拉姆的背包裡了";
         giftModule.giftData = "giftGuideData_1";
         giftModule.isPet = true;
         giftModule.giftHandler(type,str,info);
         petItemModule.setPetEffectHandler();
      }
      
      private function AddInfo() : void
      {
         this.Buys = new BuyItemReq();
         this.IsGoods = true;
         BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.chartGoodsFun);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),190045,0);
      }
      
      private function chartGoodsFun(e:*) : void
      {
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.chartGoodsFun);
         var obj:Object = e.EventObj.obj;
         if(obj.Count == 0)
         {
            this.IsGoods = false;
         }
         if(TaskManager.getTaskState(16) >= 2)
         {
            this.IsGoods = true;
         }
         this.chartPetJobFun();
      }
      
      private function getclearMud(event:MouseEvent) : void
      {
         var ap:Array = null;
         var llgg:uint = 0;
         var no_num:uint = 0;
         var hasLearn:Boolean = false;
         var i:uint = 0;
         BC.removeEvent(this,this.target_mc.clearMud_btn,MouseEvent.CLICK,this.getclearMud);
         if(GV.MyInfo_PetObj.Level >= 101)
         {
            this.getTool();
         }
         else if(GV.MyInfo_PetObj.Level > 1)
         {
            ap = GV.MyInfo_PetObj.Job;
            llgg = ap.length;
            no_num = 0;
            hasLearn = false;
            for(i = 0; i < llgg; i++)
            {
               if(ap[i].ClassID == 14)
               {
                  hasLearn = true;
                  if(ap[i].Days < 7)
                  {
                     this.alertLearn();
                  }
                  else
                  {
                     this.getTool();
                  }
               }
            }
            if(!hasLearn)
            {
               this.alertLearn();
            }
         }
      }
      
      private function alertLearn() : void
      {
         var url:String = "resource/allJob/AlertPic/kv3.swf";
         var info:String = "    你必須帶著學會清泥巴課程的拉姆或者超級拉姆才能領取樂刷刷哦！";
         Alert.showAlert(MainManager.getAppLevel(),url,info,Alert.CHANG_ALERT,"otherJob_konw",true,true,"npcUI");
      }
      
      private function getTool() : void
      {
         BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getToolResult);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),180026,0);
      }
      
      private function getToolResult(e:*) : void
      {
         var url:String = null;
         var info:String = null;
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getToolResult);
         var obj:Object = e.EventObj.obj;
         if(obj.Count == 0)
         {
            BC.addEvent(this,GV.onlineSocket,BuyItemRes.BUY_ITEM_SUCCESS,this.BuyResult);
            if(this.Buys == null)
            {
               this.Buys = new BuyItemReq();
            }
            this.Buys.buyItems(180026,1);
         }
         else
         {
            url = "resource/allJob/AlertPic/kv3.swf";
            info = "    你已經成功領取樂刷刷了哦！";
            Alert.showAlert(MainManager.getAppLevel(),url,info,Alert.CHANG_ALERT,"otherJob_konw",true,true,"npcUI");
         }
      }
      
      private function BuyResult(e:*) : void
      {
         BC.removeEvent(this,GV.onlineSocket,BuyItemRes.BUY_ITEM_SUCCESS,this.BuyResult);
         var info:String = "    樂刷刷已經放入你的拉姆背包中，趕快去看看吧！";
         var url:String = "resource/pet/icon/180026.swf";
         Alert.showAlert(MainManager.getAppLevel(),url,info,Alert.CHANG_ALERT,"sure",true,false,"EMP");
      }
      
      private function chartPetJob(event:MouseEvent) : void
      {
         this.AddInfo();
      }
      
      private function chartPetJobFun() : void
      {
         var BpetObj:Object = null;
         var ap:Array = null;
         var llgg:uint = 0;
         var no_num:uint = 0;
         var i:uint = 0;
         if(this.IsGoods)
         {
            this.getGoods(3);
            return;
         }
         if(Boolean(GV.JobLogics.havePetFollow()))
         {
            BpetObj = GF.getPeopleObj(GV.MyInfo_userID);
            if(BpetObj.Petlevel > 100)
            {
               this.getGoods(1);
               return;
            }
            if(GV.MyInfo_PetObj.Job == "no")
            {
               this.getGoods(2);
               return;
            }
            ap = GV.MyInfo_PetObj.Job;
            llgg = ap.length;
            no_num = 0;
            for(i = 0; i < llgg; i++)
            {
               if(ap[i].ClassID == 13)
               {
                  if(ap[i].Days < 1)
                  {
                     this.getGoods(2);
                     return;
                  }
                  this.getGoods(1);
                  return;
               }
               no_num++;
            }
            if(no_num == llgg)
            {
               this.getGoods(2);
               return;
            }
         }
         else
         {
            this.getGoods(2);
         }
      }
      
      private function getGoods(type:uint) : void
      {
         var url:String = null;
         var info:String = null;
         var myAle:* = undefined;
         if(type == 1)
         {
            url = "resource/allJob/AlertPic/kvLetterBook.swf";
            info = "    太好了，你已經學會了手工課了。我給你頒發個學習證書，你可以去艾米那裡申請成為記者哦！";
            myAle = Alert.showAlert(MainManager.getAppLevel(),url,info,Alert.CHANG_ALERT,"otherJob_konw",true,true,"SMCUI");
            BC.addEvent(this,myAle,Alert.CLICK_ + "1",this.beginBuy);
            return;
         }
         if(type == 2)
         {
            url = "resource/allJob/AlertPic/kv3.swf";
            info = "    你必須帶著學會手工課的拉姆或者超級拉姆才能領取手工課證書哦！";
            myAle = Alert.showAlert(MainManager.getAppLevel(),url,info,Alert.CHANG_ALERT,"otherJob_konw",true,true,"npcUI");
         }
         else if(type == 3)
         {
            url = "resource/allJob/AlertPic/kv3.swf";
            info = "    你已經成功領取手工課證書了哦！";
            myAle = Alert.showAlert(MainManager.getAppLevel(),url,info,Alert.CHANG_ALERT,"otherJob_konw",true,true,"npcUI");
         }
      }
      
      private function beginBuy(event:*) : void
      {
         BC.addEvent(this,GV.onlineSocket,"sameEvent",this.clearSameEvent);
         BC.addEvent(this,GV.onlineSocket,BuyItemRes.BUY_ITEM_SUCCESS,this.BuyFun);
         GV.itemID = 3;
         this.Buys.buyItems(190045,1);
      }
      
      private function clearSameEvent(evt:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"sameEvent",this.clearSameEvent);
         BC.removeEvent(this,GV.onlineSocket,BuyItemRes.BUY_ITEM_SUCCESS,this.BuyFun);
      }
      
      private function BuyFun(event:EventTaomee) : void
      {
         var myAle:* = undefined;
         BC.removeEvent(this,GV.onlineSocket,BuyItemRes.BUY_ITEM_SUCCESS,this.BuyFun);
         var info:String = "恭喜!你成功領取了手工課證書！";
         var url:String = "resource/allJob/icon/190045.swf";
         myAle = Alert.showAlert(MainManager.getAppLevel(),url,info,Alert.CHANG_ALERT,"sure",true,false,"EMP");
      }
      
      private function WindowOverHandler(evt:MouseEvent) : void
      {
         this.target_mc.window_mc.gotoAndStop(2);
      }
      
      private function WindowOutHandler(evt:MouseEvent) : void
      {
         this.target_mc.window_mc.gotoAndStop(1);
      }
      
      private function BoxOverHandler(evt:MouseEvent) : void
      {
         this.target_mc.sound_btn.gotoAndPlay(2);
      }
      
      private function BoxOutHandler(evt:MouseEvent) : void
      {
         this.target_mc.sound_btn.gotoAndStop(1);
      }
      
      private function BoxClickHandler(evt:MouseEvent) : void
      {
         if(this.haoChanler == null)
         {
            this.haoChanler = this.soundHao.play(0,100000);
         }
      }
      
      private function initGame(E:MouseEvent) : void
      {
      }
      
      private function kevinSay(E:MouseEvent) : void
      {
         this.teacherday = new Teacherday("kv");
         this.target_mc.kevin_npcMC.mole_mc.body_mc.gotoAndPlay(2);
         this.target_mc.kevin_npcMC.hear_mc.gotoAndPlay(2);
         this.target_mc.kevin_npcMC.cloth_mc.gotoAndPlay(2);
         this.target_mc.kevin_npcMC.shoe_mc.gotoAndPlay(2);
      }
      
      private function lookHandler(evt:EventTaomee) : void
      {
         var tempMC:Class = null;
         if(evt.EventObj.type != 1)
         {
            if(!MainManager.getAppLevel().getChildByName("look_mc"))
            {
               tempMC = GV.Lib_Map.getClass("lookMC");
               this.look_mc = new tempMC();
               MainManager.getAppLevel().addChild(this.look_mc);
               this.look_mc.close_btn.addEventListener(MouseEvent.CLICK,this.removeLookHnalder);
            }
         }
      }
      
      private function removeLookHnalder(evt:MouseEvent = null) : void
      {
         this.look_mc.close_btn.removeEventListener(MouseEvent.CLICK,this.removeLookHnalder);
         GC.clearAllChildren(this.look_mc);
         this.look_mc.parent.removeChild(this.look_mc);
         this.look_mc = null;
      }
      
      private function closeBtnHnalder(event:MouseEvent) : void
      {
         this.help.closeBtn.removeEventListener(MouseEvent.CLICK,this.closeBtnHnalder);
         MainManager.getAppLevel().removeChild(this.help);
         this.help = null;
      }
      
      override public function destroy() : void
      {
         if(this.haoChanler != null)
         {
            this.haoChanler.stop();
            this.soundHao = null;
            this.haoChanler = null;
         }
         if(this.look_mc != null)
         {
            this.removeLookHnalder();
         }
         super.destroy();
      }
      
      private function pumpkinGame(event:MouseEvent) : void
      {
         var sprite:Sprite = null;
         var mcloader:MCLoader = null;
         if(!MainManager.getGameLevel().getChildByName("carvePumpkin"))
         {
            sprite = new Sprite();
            sprite.name = "carvePumpkin";
            MainManager.getGameLevel().addChild(sprite);
            mcloader = new MCLoader("module/game/CarvePumpkin.swf",MainManager.getGameLevel(),1,"正在加載遊戲");
            mcloader.addEventListener(MCLoadEvent.ON_SUCCESS,this.onLoadGame);
            mcloader.doLoad();
         }
      }
      
      private function onLoadGame(event:MCLoadEvent) : void
      {
         var container:DisplayObjectContainer = event.getParent();
         var content:DisplayObject = event.getContent();
         container.addChild(content);
      }
      
      private function carvePumpkinWinHandler(event:Event) : void
      {
      }
      
      private function onCheckItem(event:EventTaomee) : void
      {
      }
      
      private function onPickItem(event:EventTaomee) : void
      {
         Alert.showAlert(MainManager.getAppLevel(),"恭喜!\n" + GoodsInfo.getItemNameByID(190043) + "已經放入百寶箱中!","",6,"E");
      }
   }
}

