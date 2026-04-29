package com.view.mapView.activity.PenguinFindMM
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.field.animalInfo.AnimalInfo;
   import com.core.manager.AssetsManage;
   import com.event.EventTaomee;
   import com.global.links.Links;
   import com.logic.socket.PenguinFindSocket.PenguinFindSocket;
   import com.logic.socket.enterGame.EnterGameRes;
   import com.module.farm.FieldView;
   import com.module.farm.IAnimal_Follow;
   import com.view.PeopleView.ClothAction;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class PenguinFindMM
   {
      
      private static var instance:PenguinFindMM;
      
      private static var canotNew:Boolean = true;
      
      public var animal:IAnimal_Follow;
      
      private var mainMC:MovieClip;
      
      private var penguinData:int;
      
      private var hasPenguin:Boolean;
      
      private var joinObj:Object;
      
      private var sayArr:Array = new Array();
      
      private var sayArrOnTask:Array = ["別瞎逛了，盡耽誤小豬掙胡蘿蔔，快帶小豬去東部遊樂場！","走錯了，走錯了，是在西部遊樂場，真是個迷糊的小摩爾！","快去尼爾拉塔，小豬敢確定他們一定是往那裡去了！Oh~小豬似乎看見了胡蘿蔔！","胡蘿蔔，小豬的胡蘿蔔，艾爾警官小豬來囉！"];
      
      public function PenguinFindMM()
      {
         super();
         if(canotNew)
         {
            throw new Error("PenguinFindMM不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : PenguinFindMM
      {
         if(!instance)
         {
            canotNew = false;
            instance = new PenguinFindMM();
            canotNew = true;
         }
         return instance;
      }
      
      public function init(tempMc:MovieClip) : void
      {
         this.mainMC = tempMc;
         GV.onlineSocket.addEventListener("CAR_GAME_MAP",this.onUsingMapHandler);
         GV.onlineSocket.addEventListener(EnterGameRes.ENTER_GAME,this.onUsingMapHandler);
         GV.onlineSocket.addEventListener("wordMapChang_over",this.onWordMapChang_over);
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         this.getPenguinData();
      }
      
      private function getPenguinData() : void
      {
         GV.onlineSocket.addEventListener("read_" + 1387,this.onRead1387);
         PenguinFindSocket.getPenguinData();
      }
      
      private function onRead1387(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 1387,this.onRead1387);
         this.penguinData = evt.EventObj.saveData;
         if(this.penguinData == 0)
         {
            this.mainMC.penguinMc.visible = true;
            this.mainMC.penguinMc.buttonMode = true;
            this.mainMC.penguinMc.addEventListener(MouseEvent.CLICK,this.onPenguinMcHandler);
         }
         else if(this.penguinData == 1)
         {
            if(this.hasPenguin)
            {
               this.mainMC.penguinMc.visible = false;
            }
            else
            {
               this.mainMC.penguinMc.gotoAndStop(3);
               this.mainMC.penguinMc.visible = true;
               this.mainMC.penguinMc.buttonMode = true;
               this.mainMC.penguinMc.addEventListener(MouseEvent.CLICK,this.onPenguinMcHandler);
            }
         }
         else
         {
            this.mainMC.penguinMc.visible = false;
         }
      }
      
      private function onPenguinMcHandler(evt:MouseEvent) : void
      {
         var msg:String = null;
         this.mainMC.penguinMc.buttonMode = false;
         this.mainMC.penguinMc.removeEventListener(MouseEvent.CLICK,this.onPenguinMcHandler);
         if(this.mainMC.penguinMc.currentFrame == 1)
         {
            GV.onlineSocket.addEventListener("read_" + 1388,this.onRead1388);
            PenguinFindSocket.setPenguinData(1,1);
         }
         else if(this.mainMC.penguinMc.currentFrame == 2)
         {
            msg = "    嗚嗚嗚，你是誰？一艘裝滿貨物的大船撞到了我生活的冰島上，我和爸爸失散了，這可怎麼辦呢？\n" + "    紅紅的大鼻子，爸爸一定在附近找我，你能帶著我去有冰的地方看看嗎？爸爸說不定就在那！";
            this.alterPanel(msg);
         }
         else if(this.mainMC.penguinMc.currentFrame == 3)
         {
            msg = "    嗚嗚嗚……紅紅的大鼻子，你不要我了嗎？我想我的爸爸，爸爸一定會在有冰的地方找我，你能帶我去嗎？";
            this.alterPanel(msg);
         }
      }
      
      private function alterPanel(tempMess:String) : void
      {
         var message:String = tempMess;
         var url:String = "resource/allJob/AlertPic/PenguinFindMM/PenguinFindMM_02.swf";
         this.joinObj = Alert.showAlert(MainManager.getGameLevel(),url,message,Alert.CHANG_ALERT,"npcgo,notgo",true,false,"SMCUI");
         this.joinObj.addEventListener("CLICK" + 1,this.doActionHandler);
         this.joinObj.addEventListener("CLICK" + 2,this.doActionHandler);
      }
      
      private function doActionHandler(evt:Event) : void
      {
         this.joinObj.removeEventListener("CLICK" + 1,this.doActionHandler);
         this.joinObj.removeEventListener("CLICK" + 2,this.doActionHandler);
         if(evt.type == "CLICK2")
         {
            this.mainMC.penguinMc.buttonMode = true;
            this.mainMC.penguinMc.addEventListener(MouseEvent.CLICK,this.onPenguinMcHandler);
         }
         else
         {
            this.hasPenguin = true;
            this.withPenguin(1);
            this.mainMC.penguinMc.visible = false;
            setTimeout(function():void
            {
               animal.say("    那我就跟著你啦，帶我去有冰的地方找爸爸吧！");
            },500);
         }
      }
      
      private function onRead1388(evt:Event) : void
      {
         GV.onlineSocket.addEventListener("showOver",this.onShowOver);
         this.mainMC.penguinMc.gotoAndStop(2);
      }
      
      private function onShowOver(evt:Event) : void
      {
         GV.onlineSocket.removeEventListener("showOver",this.onShowOver);
         this.mainMC.penguinMc.buttonMode = true;
         this.mainMC.penguinMc.addEventListener(MouseEvent.CLICK,this.onPenguinMcHandler);
      }
      
      private function onUsingMapHandler(evt:EventTaomee) : void
      {
         if(this.hasPenguin)
         {
            this.animal.visible = false;
            GF.showAlert(MainManager.getGameLevel(),"    哎呀，你跑得太快，企鵝寶寶跟不上啦！快回神秘湖找它吧。","",100,"iknow",true,false,"E");
            this.hasPenguin = false;
         }
      }
      
      private function onWordMapChang_over(evt:EventTaomee) : void
      {
         if(this.hasPenguin)
         {
            this.withPenguin(1);
            setTimeout(function():void
            {
               animal.say("    那我就跟著你啦，帶我去有冰的地方找爸爸吧！");
            },500);
         }
      }
      
      public function getHasPenguin() : Boolean
      {
         return this.hasPenguin;
      }
      
      public function withPenguin(animalID:int = 0) : void
      {
         var loadLibcomplete:Function = null;
         loadLibcomplete = function(E:Event):void
         {
            BC.removeEvent(ClothAction,FieldView.Field_Lib,AssetsManage.ON_COMPLETE,loadLibcomplete);
            flowPeople(animalID);
         };
         BC.addEvent(ClothAction,FieldView.Field_Lib,AssetsManage.ON_COMPLETE,loadLibcomplete);
         FieldView.Field_Lib.IncludeLib("Field_Lib",Links.getUrl("module/field/FieldManage.swf"),"正在召喚...",false);
      }
      
      private function flowPeople(animalID:uint) : void
      {
         var fieldAnimalClass:Class = FieldView.Field_Lib.getClass("LandAnimal_Follow");
         var anm:Object = new Object();
         anm.NO = 7777;
         anm.ID = animalID;
         anm.Flag = 0;
         anm.Value = 1;
         anm.Type = 1;
         var tobj:Object = GoodsInfo.getInfoById(animalID);
         anm.typeObject = tobj.typeObject;
         anm.id = anm.ID;
         anm.name = tobj.name;
         anm.price = tobj.price;
         anm.Class = tobj.Class;
         anm.LevelArray = tobj.LevelArray;
         anm.quantifier = tobj.quantifier;
         anm.Fruit = tobj.Fruit;
         anm.growth = tobj.growth;
         anm.water = tobj.water;
         anm.speed = tobj.speed;
         anm.floatSpeed = tobj.floatSpeed;
         anm.floatMoveTime = tobj.floatMoveTime;
         anm.baseMoveTime = tobj.baseMoveTime;
         anm.acedia = tobj.acedia;
         if(this.animal != null)
         {
            this.animal.visible = false;
            this.animal = null;
         }
         var fieldAnimal:IAnimal_Follow = new fieldAnimalClass() as IAnimal_Follow;
         fieldAnimal.showAnimal(new AnimalInfo(anm));
         fieldAnimal.followMole(PeopleManageView(GV.MAN_PEOPLE));
         this.animal = fieldAnimal;
         this.animal.visible = true;
      }
      
      public function removeMapEvent() : void
      {
         GV.onlineSocket.removeEventListener("CAR_GAME_MAP",this.onUsingMapHandler);
         GV.onlineSocket.removeEventListener(EnterGameRes.ENTER_GAME,this.onUsingMapHandler);
         GV.onlineSocket.removeEventListener("wordMapChang_over",this.onWordMapChang_over);
      }
      
      private function removeEventHandler(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 1387,this.onRead1387);
         GV.onlineSocket.removeEventListener("read_" + 1388,this.onRead1388);
         this.mainMC.penguinMc.removeEventListener(MouseEvent.CLICK,this.onPenguinMcHandler);
         GV.onlineSocket.removeEventListener("showOver",this.onShowOver);
         if(this.joinObj != null)
         {
            this.joinObj.removeEventListener("CLICK" + 1,this.doActionHandler);
            this.joinObj.removeEventListener("CLICK" + 2,this.doActionHandler);
         }
         BC.removeEvent(this);
      }
   }
}

