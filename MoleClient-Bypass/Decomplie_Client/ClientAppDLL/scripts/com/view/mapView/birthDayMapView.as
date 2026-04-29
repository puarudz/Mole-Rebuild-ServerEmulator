package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.birthday.getBirthdayCloth;
   import com.module.activityModule.Presented;
   import com.module.checkBirthday.CheckBirthday;
   import com.module.checkBirthday.CheckBooking;
   import com.module.checkBirthday.MyselfBirthday;
   import com.module.clothBuyModule.clothBuyModule;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.mapModule.Map57PMClass;
   import com.mole.app.manager.BufferManager;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.StatisticsManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.map.MapManager;
   import com.mole.app.task.TaskManager;
   import com.mole.app.task.type.TaskStateType;
   import com.mole.app.type.ModuleType;
   import com.mole.app.utils.PlayMovie;
   import com.view.JobView.ChildMapJob.JobMap57View;
   import com.view.mapView.activity.Task83.StatisticsClass;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.net.URLRequest;
   import flash.net.sendToURL;
   
   public class birthDayMapView extends MapBase
   {
      
      private var itemArray:Array = [12227,12228,12279,12229];
      
      private var target_mc:MovieClip;
      
      private var depth_mc:MovieClip;
      
      private var botton_mc:MovieClip;
      
      private var clothMC:MovieClip;
      
      private var soundHao:Sound;
      
      private var haoChanler:SoundChannel;
      
      private var JobMap57Views:JobMap57View;
      
      private var CheckBirthdayClass:CheckBirthday;
      
      public function birthDayMapView()
      {
         super();
         sendToURL(new URLRequest("http://g.cn.miaozhen.com/x.gif?k=1002815&p=3xzOG0&rt=2&o="));
      }
      
      override protected function initView() : void
      {
         var bgSound:Class;
         var Map57PMClass_a:Map57PMClass;
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         this.JobMap57Views = new JobMap57View();
         StatisticsClass.getInstance().init(67747601);
         bgSound = GV.Lib_Map.getClass("bgSound");
         this.soundHao = new bgSound();
         Map57PMClass_a = new Map57PMClass();
         Map57PMClass_a.Info(this.botton_mc,this.target_mc);
         this.depth_mc.mouseEnabled = false;
         this.depth_mc.mouseChildren = false;
         BC.addEvent(this,this.target_mc.JobBtn,MouseEvent.CLICK,this.beginJob);
         BC.addEvent(this,this.target_mc.cakeBtn,MouseEvent.CLICK,this.birthdayHandler);
         BC.addEvent(this,this.target_mc.bookBtn,MouseEvent.CLICK,this.bookBtnHandler);
         BC.addEvent(this,this.target_mc.giftBtn,MouseEvent.CLICK,this.giftBtnHandler);
         BC.addEvent(this,this.target_mc.getBirthDayCloth_mc,MouseEvent.CLICK,this.getBirthDayClothFun);
         BC.addEvent(this,this.target_mc.singBtn,MouseEvent.CLICK,this.playSoundHandler);
         this.visBirthday();
         tip.tipTailDisPlayObject(buttonLevel.decorate_btn,"生日派對我做主");
         BC.addEvent(this,buttonLevel.decorate_btn,MouseEvent.CLICK,function(e:MouseEvent):void
         {
            ModuleManager.openPanel(ModuleType.KFC_BIRTHDAY_DECORATE_PANEL,{"userID":LocalUserInfo.getUserID()});
         });
         SystemEventManager.addEventListener("openKFCGPresentame",this.openKFCGPresentame);
         BufferManager.addBufferEvent(BufferManager.KFC_MAGIC_DETECT_STEP,this.KFCMagicHandle);
         BufferManager.getBuffer(BufferManager.KFC_MAGIC_DETECT_STEP);
      }
      
      private function KFCMagicHandle(e:EventTaomee) : void
      {
         var movie:PlayMovie = null;
         var movie5:PlayMovie = null;
         var times:uint = uint(e.EventObj);
         if(times == 4)
         {
            movie = PlayMovie.play("resource/map/cartoon/cartoon3.swf",null,null,function():void
            {
               movie.destroy();
               BufferManager.setBuffer(BufferManager.KFC_MAGIC_DETECT_STEP,5);
               MapManager.enterMap(176);
            });
         }
         else if(times == 7)
         {
            movie5 = PlayMovie.play("resource/map/cartoon/cartoon5.swf",null,null,function():void
            {
               var movie6:* = undefined;
               movie5.destroy();
               movie6 = PlayMovie.play("resource/map/cartoon/cartoon6.swf",null,null,function():void
               {
                  movie6.destroy();
                  BufferManager.setBuffer(BufferManager.KFC_MAGIC_DETECT_STEP,8);
                  Presented.getInstance().celebrate1225(2724);
                  StatisticsManager.send(315);
               });
            });
         }
      }
      
      private function openKFCGPresentame(e:*) : void
      {
         ModuleManager.openPanel("KFCGoldClawIntroPanel");
      }
      
      private function getBirthDayClothFun(E:MouseEvent) : void
      {
         StatisticsClass.getInstance().init(67747604);
         if(this.target_mc.isDown == null)
         {
            if(!this.CheckBirthdayClass)
            {
               new CheckBirthday().checkBirth(this,"checkIsBirthDayFun");
            }
         }
         else
         {
            this.checkIsBirthDayFun(this.target_mc.isDown);
         }
      }
      
      public function checkIsBirthDayFun(isBirthDay:uint) : void
      {
         var info:String = null;
         var strInfo:String = null;
         this.target_mc.isDown = isBirthDay;
         if(isBirthDay == 2)
         {
            info = "　　你還沒有填寫過生日預約呢，\n快去旁邊的生日預約板上寫下你的生日吧！";
            GF.showAlert(MainManager.getAppLevel(),info,"",100,"iknow",true,false,"D");
         }
         else if(isBirthDay == 1)
         {
            new getBirthdayCloth().doAction();
            BC.removeEvent(this,this.target_mc.getBirthDayCloth_mc,MouseEvent.CLICK,this.getBirthDayClothFun);
         }
         else
         {
            strInfo = "   你的生日還沒有到呢！\n別著急哦！生日的時候再來吧！";
            Alert.showAlert(MainManager.getAppLevel(),strInfo,"",Alert.ICO_ALERT2,"D");
         }
      }
      
      private function visBirthday() : void
      {
         new MyselfBirthday(this.depth_mc);
      }
      
      private function playSoundHandler(evt:MouseEvent) : void
      {
         if(this.target_mc.singBtn.currentFrame == 1)
         {
            this.haoChanler = this.soundHao.play(0,1000000);
            this.target_mc.singBtn.gotoAndStop(2);
         }
         else
         {
            this.haoChanler.stop();
            this.target_mc.singBtn.gotoAndStop(1);
         }
      }
      
      private function birthdayHandler(event:MouseEvent) : void
      {
         StatisticsManager.send(200);
         var loadGame:LoadGame = new LoadGame("module/game/Docake.swf","正在打開DIY生日蛋糕",MainManager.getGameLevel());
         loadGame.panle.addEventListener(Event.REMOVED_FROM_STAGE,this.overDocakeGame);
         loadGame = null;
         if(this.haoChanler != null)
         {
            this.haoChanler.stop();
         }
         this.target_mc.singBtn.gotoAndStop(1);
      }
      
      private function overDocakeGame(evt:Event) : void
      {
         evt.currentTarget.addEventListener(Event.REMOVED_FROM_STAGE,this.overDocakeGame);
         if(TaskManager.getTask(579).state == TaskStateType.OPEN)
         {
            TaskManager.overTask(579);
            Alert.smileAlart("恭喜你，已成為KFC美食店普通小店員啦！可得到1000摩爾豆/月的薪資哦!");
            LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + 1000);
         }
      }
      
      private function bookBtnHandler(event:MouseEvent) : void
      {
         StatisticsClass.getInstance().init(67747602);
         var loadGame:LoadGame = new LoadGame("module/external/BirthdayAirboat.swf","正在打開生日預約",MainManager.getAppLevel());
         loadGame = null;
      }
      
      private function giftBtnHandler(event:MouseEvent) : void
      {
         var checkBooking:CheckBooking = new CheckBooking();
         checkBooking = null;
      }
      
      private function beginJob(event:MouseEvent) : void
      {
         this.JobMap57Views.chartFun();
      }
      
      private function buyClickHandler(evt:MouseEvent) : void
      {
         var tempName:String = evt.target.name;
         var num:int = int(tempName.substring(4)) - 1;
         var itemObj:Object = new Object();
         var id:int = int(this.itemArray[num]);
         var obj:Object = GF.getItemName(id);
         itemObj.id = id;
         itemObj.price = obj.@Price;
         itemObj.info = obj.@Name;
         clothBuyModule.buyAction(itemObj);
      }
      
      private function removeClothHandler(evt:MouseEvent = null) : void
      {
         for(var i:int = 1; i < 5; i++)
         {
            this.clothMC["btn_" + i].removeEventListener(MouseEvent.CLICK,this.buyClickHandler);
         }
         this.clothMC.closeBtn.removeEventListener(MouseEvent.CLICK,this.removeClothHandler);
         GC.clearAllChildren(this.clothMC);
         this.clothMC.parent.removeChild(this.clothMC);
         this.clothMC = null;
      }
      
      override public function destroy() : void
      {
         SystemEventManager.removeEventListener("openKFCGPresentame",this.openKFCGPresentame);
         if(this.haoChanler != null)
         {
            this.haoChanler.stop();
         }
         if(this.clothMC != null)
         {
            this.removeClothHandler();
         }
         BC.removeEvent(this);
         this.JobMap57Views = null;
         this.target_mc = null;
         this.depth_mc = null;
         this.botton_mc = null;
         BufferManager.removeBufferEvent(BufferManager.KFC_MAGIC_DETECT_STEP,this.KFCMagicHandle);
         super.destroy();
      }
   }
}

