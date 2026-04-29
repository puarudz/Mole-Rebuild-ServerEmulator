package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.Tween.TweenLite;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.socket.getItemEveryDay.GetItemEveryDay;
   import com.module.activityModule.checkItem;
   import com.module.deal.Deal;
   import com.view.LamuWorld.LamuWorld;
   import com.view.LamuWorld.TreeBoss;
   import com.view.PeopleView.PeopleManageView;
   import com.view.mapView.activity.creatShareObject;
   import com.view.mapView.housebase.HouseBase;
   import fl.transitions.easing.Strong;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Timer;
   
   public class Treescene extends HouseBase
   {
      
      private var treeBoss:TreeBoss;
      
      private var lamuArea:Sprite;
      
      private var treeMC:MovieClip;
      
      private var prop:MovieClip;
      
      private var baowu:MovieClip;
      
      private var isbehurt:Boolean;
      
      private var sunArray:Array = [{
         "x":212,
         "y":328
      },{
         "x":264,
         "y":334
      },{
         "x":426,
         "y":334
      },{
         "x":514,
         "y":334
      },{
         "x":747,
         "y":220
      },{
         "x":723,
         "y":162
      },{
         "x":665,
         "y":152
      },{
         "x":665,
         "y":118
      },{
         "x":249,
         "y":138
      },{
         "x":284,
         "y":200
      },{
         "x":328,
         "y":272
      },{
         "x":322,
         "y":314
      },{
         "x":300,
         "y":380
      },{
         "x":204,
         "y":406
      },{
         "x":150,
         "y":200
      },{
         "x":158,
         "y":132
      },{
         "x":264,
         "y":102
      },{
         "x":249,
         "y":52
      },{
         "x":224,
         "y":212
      },{
         "x":460,
         "y":320
      },{
         "x":598,
         "y":304
      },{
         "x":713,
         "y":102
      },{
         "x":200,
         "y":76
      },{
         "x":170,
         "y":292
      },{
         "x":240,
         "y":272
      },{
         "x":170,
         "y":366
      },{
         "x":249,
         "y":370
      },{
         "x":373,
         "y":380
      },{
         "x":514,
         "y":376
      },{
         "x":440,
         "y":376
      },{
         "x":592,
         "y":350
      },{
         "x":787,
         "y":188
      },{
         "x":827,
         "y":232
      },{
         "x":249,
         "y":432
      },{
         "x":200,
         "y":158
      },{
         "x":284,
         "y":18
      }];
      
      private var sunLevel:Sprite;
      
      private var sunContent:Sprite;
      
      private var indexFrame:int = 0;
      
      private var deleteFrame:int = 0;
      
      private var attackMC:MovieClip;
      
      private var hasSunArray:Array = [{
         "flag":false,
         "x":634,
         "y":351
      },{
         "flag":false,
         "x":658,
         "y":370
      },{
         "flag":false,
         "x":692,
         "y":385
      },{
         "flag":false,
         "x":725,
         "y":374
      },{
         "flag":false,
         "x":748,
         "y":353
      }];
      
      private var isHaveYinji:Boolean = false;
      
      private var tempTimer:Timer;
      
      private var tempTimer2:Timer;
      
      public function Treescene()
      {
         super();
      }
      
      override protected function initView() : void
      {
      }
      
      override public function init() : void
      {
         super.init();
         if(GV.MAN_PEOPLE.Petlevel < 2)
         {
            return;
         }
         this.sunLevel = new Sprite();
         this.sunContent = new Sprite();
         top_mc.addChild(this.sunLevel);
         top_mc.addChild(this.sunContent);
         this.treeMC = depth_mc["treeMC"] as MovieClip;
         this.treeBoss = new TreeBoss(this.treeMC);
         var people:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         this.lamuArea = people.hitBtn;
         if(!LamuWorld.getInstance().isComplete)
         {
            BC.addEvent(this,GV.onlineSocket,"lamuComplete",this.setBossLive);
         }
         else
         {
            this.setBossLive();
         }
         this.attackMC = depth_mc.getChildByName("attackMC") as MovieClip;
         BC.addEvent(this,this.attackMC,"hurt_boss",this.hurtBossFun);
         BC.addEvent(this,this.treeBoss.boss,"dead_over",this.hitBossFun);
         this.prop = target_mc["prop"] as MovieClip;
         this.prop.mouseEnabled = false;
         this.baowu = target_mc["baowu"] as MovieClip;
         this.initLubi();
         this.baowu.buttonMode = true;
         BC.addEvent(this,this.baowu,MouseEvent.CLICK,this.fireClickFun);
         var addLive:SimpleButton = target_mc["addLive"] as SimpleButton;
         var addLive2:SimpleButton = target_mc["addLive2"] as SimpleButton;
         BC.addEvent(this,addLive,MouseEvent.CLICK,this.addLiveFun);
         BC.addEvent(this,addLive2,MouseEvent.CLICK,this.addLiveFun);
         BC.addEvent(this,this.prop,"get_thing",this.getThingFun);
      }
      
      private function addLiveFun(e:Event) : void
      {
         (e.currentTarget as SimpleButton).visible = false;
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         var itemID:int = p.lamuinfo.PetCloth;
         var max:int = 0;
         if(itemID == 1200035)
         {
            max = 20;
         }
         else
         {
            max = 16;
         }
         var num:int = Math.min(max,LamuWorld.getInstance().lives + 4);
         LamuWorld.getInstance().behurt(LamuWorld.getInstance().lives - num);
      }
      
      private function tipsBaowu() : void
      {
         var msg:String = "    你只有使用變身小樹苗技能才能得到這個寶貝哦,快去找木系酋長吧!";
         GF.showAlert(MainManager.getAppLevel(),msg,"",100,"iknow",true,false,"E");
      }
      
      private function getYinji(e:Event) : void
      {
         Deal.BuyItem(190595,1,function(... E):void
         {
            var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
            Alert.getIconByID_Alart(190595,"    恭喜你得到木系信物,快去交給木系酋長吧!");
         },function(errorNum:int):void
         {
         });
      }
      
      private function fireClickFun(evt:MouseEvent) : void
      {
         this.getThingByLame(190610);
      }
      
      private function initLubi() : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(!p.lamuinfo.hasSkill_Wood_By_Level(1))
         {
            BC.addEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.itemSucHandler);
            checkItem.checkItemHandler(190595);
         }
      }
      
      private function getThingByLame(id:int) : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         var main:Treescene = this;
         if(p.lamuinfo.skillType == 3)
         {
            p.lamu.geocaching(this.baowu,function(mc:MovieClip):*
            {
               return id;
            },function(E:*):*
            {
               Alert.getIconByID_Alart(id,"    恭喜你獲得" + GoodsInfo.getItemNameByID(id) + "，已經放入你主人的百寶箱中了！");
            },function(E:*):*
            {
               Alert.getIconByID_Alart(id,"    你今天已經拿了太多的" + GoodsInfo.getItemNameByID(id) + "，明天再來看看吧！");
            });
         }
         else
         {
            this.tipsBaowu();
         }
      }
      
      private function getThingFun(e:EventTaomee) : void
      {
         var msg:String = null;
         var id:int = e.EventObj as int;
         switch(id)
         {
            case 0:
               msg = "這是一個空箱子,下次再來吧!";
               GF.showAlert(MainManager.getAppLevel(),msg,"",100,"iknow",true,false,"E");
               break;
            case 190606:
               BC.addEvent(this,GV.onlineSocket,"read_1117",this.read117Handler);
               GetItemEveryDay.req_getItemEveryDay(17);
               break;
            case 190607:
               BC.addEvent(this,GV.onlineSocket,"read_1117",this.read117Handler);
               GetItemEveryDay.req_getItemEveryDay(18);
               break;
            case 190608:
               BC.addEvent(this,GV.onlineSocket,"read_1117",this.read117Handler);
               GetItemEveryDay.req_getItemEveryDay(19);
               break;
            case 190609:
               BC.addEvent(this,GV.onlineSocket,"read_1117",this.read117Handler);
               GetItemEveryDay.req_getItemEveryDay(20);
               break;
            case 190595:
               this.getYinji(null);
         }
      }
      
      private function read117Handler(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_1117",this.read117Handler);
         if(e.EventObj.itmeCount == 0)
         {
            Alert.smileAlart("今天你已經得到太多" + GoodsInfo.getItemNameByID(e.EventObj.itemid) + "，明天再來看看吧！");
         }
         else
         {
            Alert.getIconByID_Alart(e.EventObj.itemid);
         }
      }
      
      private function propClick(e:MouseEvent) : void
      {
         var num:int = 0;
         var msg:String = null;
         if(this.prop.currentLabel == "打开是碎片")
         {
            num = Math.random() * 10;
            if(num < 2)
            {
               BC.addEvent(this,GV.onlineSocket,"read_1117",this.read117Handler);
               GetItemEveryDay.req_getItemEveryDay(17);
            }
            else if(num < 5)
            {
               BC.addEvent(this,GV.onlineSocket,"read_1117",this.read117Handler);
               GetItemEveryDay.req_getItemEveryDay(18);
            }
            else if(num < 9)
            {
               BC.addEvent(this,GV.onlineSocket,"read_1117",this.read117Handler);
               GetItemEveryDay.req_getItemEveryDay(19);
            }
            else
            {
               BC.addEvent(this,GV.onlineSocket,"read_1117",this.read117Handler);
               GetItemEveryDay.req_getItemEveryDay(20);
            }
         }
         else
         {
            if(this.prop.currentLabel == "升上来")
            {
               return;
            }
            if(this.prop.currentLabel == "打开是空箱子")
            {
               msg = "這是一個空的寶箱,下次再來吧!";
               GF.showAlert(MainManager.getAppLevel(),msg,"",100,"iknow",true,false,"E");
            }
         }
         this.prop.gotoAndPlay("下去");
         this.prop.mouseEnabled = false;
         this.prop.mouseChildren = false;
      }
      
      private function hurtBossFun(e:Event) : void
      {
         var mc:MovieClip = null;
         if(this.treeBoss.boss.currentLabel != "虚空防护罩")
         {
            this.treeBoss.behurt();
         }
         else
         {
            mc = MovieClip(this.treeBoss.boss.getChildAt(0));
            if(mc.currentFrame < 37 && mc.currentFrame > 176)
            {
               this.treeBoss.behurt();
            }
         }
      }
      
      private function creatSun() : void
      {
         if(this.sunArray.length == 1)
         {
            this.sunArray = [{
               "x":212,
               "y":328
            },{
               "x":264,
               "y":334
            },{
               "x":426,
               "y":334
            },{
               "x":514,
               "y":334
            },{
               "x":747,
               "y":220
            },{
               "x":723,
               "y":162
            },{
               "x":665,
               "y":152
            },{
               "x":665,
               "y":118
            },{
               "x":249,
               "y":138
            },{
               "x":284,
               "y":200
            },{
               "x":328,
               "y":272
            },{
               "x":322,
               "y":314
            },{
               "x":300,
               "y":380
            },{
               "x":204,
               "y":406
            },{
               "x":150,
               "y":200
            },{
               "x":158,
               "y":132
            },{
               "x":264,
               "y":102
            },{
               "x":249,
               "y":52
            },{
               "x":224,
               "y":212
            },{
               "x":460,
               "y":320
            },{
               "x":598,
               "y":304
            },{
               "x":713,
               "y":102
            },{
               "x":200,
               "y":76
            },{
               "x":170,
               "y":292
            },{
               "x":240,
               "y":272
            },{
               "x":170,
               "y":366
            },{
               "x":249,
               "y":370
            },{
               "x":373,
               "y":380
            },{
               "x":514,
               "y":376
            },{
               "x":440,
               "y":376
            },{
               "x":592,
               "y":350
            },{
               "x":787,
               "y":188
            },{
               "x":827,
               "y":232
            },{
               "x":249,
               "y":432
            },{
               "x":200,
               "y":158
            },{
               "x":284,
               "y":18
            }];
         }
         if(this.sunLevel.numChildren > 10)
         {
            return;
         }
         var tempClass:Class = GV.Lib_Map.getClass("Sun") as Class;
         var sun:Sprite = new tempClass();
         var random:int = int(Math.random() * this.sunArray.length);
         var obj:Object = this.sunArray.splice(random,1)[0];
         sun.x = obj.x;
         sun.y = obj.y;
         sun.buttonMode = true;
         sun.rotation = 180;
         sun.alpha = 0;
         sun.scaleX = 0;
         sun.scaleY = 0;
         TweenLite.to(sun,0.5,{
            "rotation":0,
            "alpha":1,
            "scaleX":1,
            "scaleY":1
         });
         this.sunLevel.addChild(sun);
      }
      
      private function deleteComplete(... args) : void
      {
         var sun:Sprite = args[0];
         if(Boolean(sun.parent))
         {
            sun.parent.removeChild(sun);
         }
      }
      
      private function deleteSun(sun:Sprite = null) : void
      {
         if(this.sunLevel.numChildren > 0)
         {
            if(sun == null)
            {
               sun = this.sunLevel.getChildAt(0) as Sprite;
            }
            sun.buttonMode = false;
            TweenLite.to(sun,0.5,{
               "rotation":180,
               "alpha":0,
               "scaleX":0,
               "scaleY":0,
               "onComplete":this.deleteComplete,
               "onCompleteParams":[sun]
            });
         }
      }
      
      private function everyFun(item:*, index:int, array:Array) : Boolean
      {
         if(item.mc == null)
         {
            return false;
         }
         return true;
      }
      
      private function completeCheck() : void
      {
         for(var b:int = this.sunContent.numChildren - 1; b >= 0; b--)
         {
            this.hasSunArray[b].flag = false;
            this.sunContent.removeChildAt(b);
         }
         this.attackMC.gotoAndStop(6);
      }
      
      private function onEnterFrame(e:Event) : void
      {
         var mc:Sprite = null;
         var flag:Boolean = false;
         var f:Boolean = false;
         var t:int = 0;
         var obj:Object = null;
         var b:int = 0;
         ++this.indexFrame;
         ++this.deleteFrame;
         if(this.sunContent.numChildren > 5)
         {
            return;
         }
         if(this.indexFrame > 12)
         {
            this.indexFrame = 0;
            this.creatSun();
         }
         if(this.deleteFrame > 24)
         {
            this.deleteFrame = 0;
            this.deleteSun();
         }
         for(var i:int = 0; i < this.sunLevel.numChildren; i++)
         {
            mc = this.sunLevel.getChildAt(i) as Sprite;
            if(mc.buttonMode)
            {
               flag = mc.hitTestObject(GV.MAN_PEOPLE.pet_hitBtn);
               if(flag)
               {
                  trace("獲得一顆能量");
                  f = false;
                  for(t = 0; t < this.hasSunArray.length; t++)
                  {
                     if(this.hasSunArray[t].flag == false)
                     {
                        obj = this.hasSunArray[t];
                        obj.flag = true;
                        mc.buttonMode = false;
                        this.sunContent.addChild(mc);
                        mc.scaleX = 1;
                        mc.scaleY = 1;
                        mc.alpha = 1;
                        if(t == 4)
                        {
                           TweenLite.to(mc,(obj.x - mc.x) / 150,{
                              "x":obj.x,
                              "y":obj.y,
                              "alpha":1,
                              "onComplete":this.completeCheck,
                              "ease":Strong.easeOut
                           });
                        }
                        else
                        {
                           this.attackMC.gotoAndStop(this.attackMC.currentFrame + 1);
                           TweenLite.to(mc,(obj.x - mc.x) / 150,{
                              "x":obj.x,
                              "y":obj.y,
                              "alpha":1,
                              "ease":Strong.easeOut
                           });
                        }
                        f = true;
                        break;
                     }
                  }
                  if(!f)
                  {
                     this.deleteSun(mc);
                  }
                  break;
               }
            }
         }
         if(this.treeBoss.lives <= 0)
         {
            this.treeBoss.dead();
            this.attackMC.visible = false;
            for(b = this.sunContent.numChildren - 1; b >= 0; b--)
            {
               this.hasSunArray[b].flag = false;
               this.sunContent.removeChildAt(b);
            }
            for(b = this.sunLevel.numChildren - 1; b >= 0; b--)
            {
               this.sunLevel.removeChildAt(b);
            }
            BC.removeEvent(this,LevelManager.stage,Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      private function hitBossFun(e:Event) : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(e.type == "dead_over")
         {
            if(p.lamuinfo.hasSkill_Wood_By_Level(1))
            {
               this.givesuipian();
            }
            else if(this.isHaveYinji)
            {
               this.givesuipian();
            }
            else
            {
               this.saveLubi();
            }
            this.treeBoss.bossLive.hideLive();
         }
      }
      
      private function hadSaveLubi() : Boolean
      {
         var arr:Array = creatShareObject.getInstance().getSaveLubi();
         return arr.length != 0;
      }
      
      private function petSaveLubi() : Boolean
      {
         var arr:Array = creatShareObject.getInstance().getSaveLubi();
         for(var i:int = 0; i < arr.length; i++)
         {
            if(arr[i] == GV.MAN_PEOPLE.PetID)
            {
               return true;
            }
         }
         return false;
      }
      
      private function itemSucHandler(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.itemSucHandler);
         if(evt.EventObj.num <= 0)
         {
            this.isHaveYinji = false;
         }
         else
         {
            this.isHaveYinji = true;
         }
      }
      
      private function saveLubi() : void
      {
         this.prop.gotoAndPlay("打完鸟后露出宝箱");
      }
      
      private function givesuipian() : void
      {
         this.prop.gotoAndPlay("抽奖");
      }
      
      override public function destroy() : void
      {
         MoveTo.CanMove = true;
         GC.clearGInterval(this.tempTimer);
         GC.clearGInterval(this.tempTimer2);
         super.destroy();
      }
      
      private function setBossLive(e:* = null) : void
      {
         var live:Sprite = null;
         live = LamuWorld.getInstance().getBossLive(LamuWorld.TREE_BOSS);
         top_mc.addChild(live);
         live.x = 710;
         live.y = 85;
         this.treeBoss.initBossLive(live);
         this.treeBoss.init();
         this.treeBoss.scene = this;
         this.treeBoss.target = LamuWorld.getInstance();
         BC.addEvent(this,LevelManager.stage,Event.ENTER_FRAME,this.onEnterFrame);
      }
   }
}

