package com.module.pet
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.info.LocalUserInfo;
   import com.core.objectPool.ObjectPool;
   import com.core.socketlogic.ClientOnLineSerSocket;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.JobLogic.PetJobLogic;
   import com.logic.socket.petSocket.lamuSocket;
   import com.logic.socket.postCard.getOnlyNumReq;
   import com.module.house.petXML;
   import com.module.newHouse.newHouseView;
   import com.module.npc.NPCEvent;
   import com.module.npc.lamu.I_LamuNPC;
   import com.module.npc.lamu.LamuInfo;
   import com.module.npc.npcInstance.LamuNPC;
   import com.mole.app.info.NPCDialogInfo;
   import com.mole.app.info.NPCDialogOptionInfo;
   import com.mole.app.manager.LamuReviveManager;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.NPCDialogManager;
   import com.mole.app.type.ActionType;
   import com.view.MapManageView.MapButtonView;
   import com.view.MapManageView.TailButtonView;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.text.TextFieldType;
   import flash.utils.Dictionary;
   
   public class petView extends MovieClip
   {
      
      public static var totalPetsCount:uint;
      
      public static var PetsPosArr:*;
      
      public static var totalPetsPosArr:*;
      
      public static var ItemID:uint;
      
      public static var changePetPosCount:uint;
      
      public static var changePetPosArr:Array;
      
      public static var changePosBool:Boolean;
      
      public static var petGoodsArr:Array;
      
      public static var petGoodsTypeArr:Array;
      
      public static var PetsObj:Object = new Object();
      
      public static var PetsCount:uint = 100;
      
      public static var playPetID:Array = [];
      
      public static var petPosNum:uint = 0;
      
      public static var petloadNum:uint = 0;
      
      public static var petPlayArr:Array = [180011,180012,180013];
      
      public static var petLanArr:Array = new Array();
      
      public static var petDic:Dictionary = new Dictionary(true);
      
      public static var POEM:Array = ["哈,哈,嘿，菩提校長有三奇，聽我慢慢說詳細","第一奇，屋子裡面都是寶，真的總比假的少","第二奇，帽子底下有秘密，頭發蓋不住頭皮","第三奇，滿嘴都是大道理，其實一點不稀奇"];
      
      public static var LAN:Array = ["你好","拜拜","大家好","我想你","你真好","吃了嗎","開心嗎","想我嗎","hi"];
      
      public static var LAN1:Array = ["你好","拜拜","大家好","我想你","你真好"];
      
      public static var LAN2:Array = [{
         "lan":"吃了嗎",
         "arr":["雞腿，漢堡統統拿來！","你別拿剩飯糊弄我！","你還問，快餓死了！"]
      },{
         "lan":"開心嗎",
         "arr":["你開心，我就開心！","你來陪我，我就開心。","我們一起玩球最開心！"]
      },{
         "lan":"想我嗎",
         "arr":["想，很想，非常想！","我一個人很寂寞很孤單！","你早把我忘了！"]
      }];
      
      public var DragBool:Boolean;
      
      public var DragPetPoint:Point;
      
      public var onePetObj:Object = new Object();
      
      public var petDefaultPosX:Array = [331,388,225,494];
      
      public var petDefaultPosY:Array = [412,269,342,381];
      
      public var RootMC:MovieClip;
      
      public var petUIMC:*;
      
      public var petFoodMC:*;
      
      public var petMC:*;
      
      public var currentPage:uint;
      
      public var currentType:uint;
      
      public var NUM:uint = 12;
      
      public var itemArr:Array;
      
      public var buyFoodAlert:*;
      
      public var itemInfo:Object;
      
      public var PetID:uint;
      
      public var playingPetMC:MovieClip;
      
      public var loadFoodXMLBool:Boolean;
      
      public var actionGoods:MovieClip;
      
      public var bmd1:BitmapData;
      
      public var bmd2:BitmapData;
      
      public var oldIndex:uint;
      
      public var parentMC:MovieClip;
      
      public var oldx:Number;
      
      public var oldy:Number;
      
      public var backOldPos:Boolean = false;
      
      public var arry:Array = [];
      
      public var arrNO:Array = [];
      
      private var _curPet:I_LamuNPC;
      
      private var _curLamuInfo:LamuInfo;
      
      public function petView(obj:Object)
      {
         super();
         PetsObj = obj;
         this.initTime();
      }
      
      public function initTime() : void
      {
         this.RootMC = newHouseView.getInstance().RootMC;
         this.petUIMC = this.RootMC["petUIMC"];
         this.petUIMC.visible = false;
         this.petFoodMC = this.petUIMC.petFoodMC;
         PetsCount = PetsObj.count;
         GV.MC_AppLever.addChild(this.petUIMC);
         petPosNum = 0;
         petloadNum = 0;
         this.init();
         GV.onlineSocket.addEventListener("add_Pet_Food",this.addPetFood);
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeHandler);
         GV.onlineClass.addEventListener(ClientOnLineSerSocket.SEND_CHATMSG,this.sayWithMole);
      }
      
      public function addPetFood(e:EventTaomee) : void
      {
         var j:uint = 0;
         var petData:Object = e.EventObj;
         var alreadyhave:Boolean = false;
         if(newHouseView.isMyHouse)
         {
            for(j = 0; j < petGoodsArr.length; j++)
            {
               if(petData.ID == petGoodsArr[j].ID)
               {
                  alreadyhave = true;
                  if(petData.Type == 1)
                  {
                     petGoodsArr[j].Count += petData.Num;
                  }
               }
            }
            if(!alreadyhave)
            {
               petGoodsArr.push(GoodsInfo.getInfoById(petData.ID));
               petGoodsArr[petGoodsArr.length - 1].Count = 1;
            }
         }
         this.showFoods();
      }
      
      public function removeHandler(e:Event) : void
      {
         petDic = new Dictionary(true);
         playPetID = [];
         GV.onlineSocket.removeEventListener("add_Pet_Food",this.addPetFood);
         GV.onlineClass.removeEventListener(ClientOnLineSerSocket.SEND_CHATMSG,this.sayWithMole);
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeHandler);
         this.petUIMC.close_btn.removeEventListener(MouseEvent.CLICK,this.closePetPanel);
         this.petUIMC.drag_mc.removeEventListener(MouseEvent.MOUSE_DOWN,this.drag_start);
         this.petUIMC.drag_mc.removeEventListener(MouseEvent.MOUSE_UP,this.drag_stop);
         this.petUIMC.drag_mc.removeEventListener(MouseEvent.MOUSE_MOVE,this.drag_move);
         this.petUIMC.pen.btn.removeEventListener(MouseEvent.CLICK,this.penClick);
         this.petUIMC.attr_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.showAttr);
         this.petUIMC.attr_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.hideAttr);
         petLanXML.removeEventListener("dispatchPetLanXMLLoaded",this.loadPetLanXMLSuccess);
         this.petUIMC.follow_btn.removeEventListener(MouseEvent.CLICK,this.doPetFollow);
         this.petUIMC.food_btn.removeEventListener(MouseEvent.CLICK,this.doPetFood);
      }
      
      public function init() : void
      {
         var i:uint = 0;
         var obj:Object = null;
         this.initPanel();
         if(newHouseView.isMyHouse)
         {
            GV.GetPetNum = PetsCount;
            newHouseView.getInstance().myhouseLogic.showPetGoods();
            newHouseView.getInstance().myhouseLogic.addEventListener("dispatchPetGoods",this.getPetGoods);
            if(GV.MyInfo_Pet == 0)
            {
               changePetPosArr = new Array();
               changePetPosCount = PetsCount;
               for(i = 0; i < PetsCount; i++)
               {
                  obj = new Object();
                  obj.SpriteID = PetsObj.arr[i].SpriteID;
                  obj.PosX = Math.random() * 100 - 50 + 400;
                  obj.PosY = Math.random() * 100 - 50 + 400;
                  changePetPosArr.push(obj);
               }
            }
         }
         petLanXML.loadPetLanXML();
         petLanXML.addEventListener("dispatchPetLanXMLLoaded",this.loadPetLanXMLSuccess);
      }
      
      public function loadPetLanXMLSuccess(e:Event) : void
      {
         petLanXML.removeEventListener("dispatchPetLanXMLLoaded",this.loadPetLanXMLSuccess);
         var petidArr:Array = new Array();
         for(var i:uint = 0; i < PetsCount; i++)
         {
            petidArr.push(PetsObj.arr[i].SpriteID);
         }
         GV.PetJobLogics.addEventListener(PetJobLogic.ARRPETCLASSFLAG,this.getPetLanLevel);
         GV.PetJobLogics.chartMsgClass(petidArr,[1,2,15]);
      }
      
      public function getPetLanLevel(e:EventTaomee) : void
      {
         petLanArr = e.EventObj.arr;
         GV.PetJobLogics.removeEventListener(PetJobLogic.ARRPETCLASSFLAG,this.getPetLanLevel);
         if(PetsCount > 0)
         {
            this.loadPetSWF(PetsObj.arr[petloadNum].Level);
         }
         else
         {
            getOnlyNumReq.Info();
         }
      }
      
      public function getPetGoods(e:EventTaomee) : void
      {
         petGoodsArr = e.EventObj.PetGoods;
         newHouseView.getInstance().myhouseLogic.removeEventListener("dispatchPetGoods",this.getPetGoods);
         petXML.loadPetXML();
         petXML.addEventListener("dispatchPetXMLLoaded",this.loadPetXMLSuccess);
      }
      
      public function loadPetXMLSuccess(e:Event) : void
      {
         var i:uint = 0;
         var itemCount:uint = 0;
         if(GV.MapInfo_mapID > 10000)
         {
            this.petFoodMC.type1_btn.addEventListener(MouseEvent.CLICK,this.changeFoodType);
            this.petFoodMC.type2_btn.addEventListener(MouseEvent.CLICK,this.changeFoodType);
            petXML.removeEventListener("dispatchPetXMLLoaded",this.loadPetXMLSuccess);
            for(i = 0; i < petGoodsArr.length; i++)
            {
               itemCount = uint(petGoodsArr[i].itemCount);
               petGoodsArr[i] = GoodsInfo.getInfoById(petGoodsArr[i].id);
               petGoodsArr[i].Count = itemCount;
            }
            this.TypeGoods();
            this.currentPage = 1;
            this.petFoodMC.P_btn.addEventListener(MouseEvent.CLICK,this.preGoodPage);
            this.petFoodMC.N_btn.addEventListener(MouseEvent.CLICK,this.nextGoodPage);
            this.showFoods();
         }
      }
      
      public function TypeGoods() : void
      {
         petGoodsTypeArr = new Array();
         petGoodsTypeArr[0] = new Array();
         petGoodsTypeArr[1] = new Array();
         for(var i:uint = 0; i < petGoodsArr.length; i++)
         {
            petGoodsTypeArr[uint(petGoodsArr[i].Type) - 1].push(petGoodsArr[i]);
         }
      }
      
      public function preGoodPage(e:Event) : void
      {
         if(this.currentPage > 1)
         {
            --this.currentPage;
            this.showFoods(this.currentPage,this.currentType);
         }
      }
      
      public function nextGoodPage(e:Event) : void
      {
         if(this.currentPage < petGoodsTypeArr[this.currentType - 1].length / this.NUM)
         {
            ++this.currentPage;
            this.showFoods(this.currentPage,this.currentType);
         }
      }
      
      public function changeFoodType(e:Event) : void
      {
         this.showFoods(1,Number(e.target.name.slice(4,5)));
      }
      
      public function initPanel() : void
      {
         this.petUIMC.SpriteID = -1;
         this.petUIMC.attr_mc.visible = false;
         this.petUIMC.foodback_btn.visible = false;
         this.petUIMC.food_btn.visible = true;
         this.petUIMC.close_btn.addEventListener(MouseEvent.CLICK,this.closePetPanel);
         this.petUIMC.drag_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.drag_start);
         this.petUIMC.drag_mc.addEventListener(MouseEvent.MOUSE_UP,this.drag_stop);
         this.petUIMC.drag_mc.addEventListener(MouseEvent.MOUSE_MOVE,this.drag_move);
         this.petUIMC.pen.btn.addEventListener(MouseEvent.CLICK,this.penClick);
         this.petUIMC.attr_btn.addEventListener(MouseEvent.MOUSE_OVER,this.showAttr);
         this.petUIMC.attr_btn.addEventListener(MouseEvent.MOUSE_OUT,this.hideAttr);
         if(newHouseView.isMyHouse)
         {
            this.petUIMC.follow_btn.addEventListener(MouseEvent.CLICK,this.doPetFollow);
            this.petUIMC.food_btn.addEventListener(MouseEvent.CLICK,this.doPetFood);
         }
         else
         {
            this.petUIMC.follow_btn.visible = false;
            this.petUIMC.food_btn.visible = false;
         }
      }
      
      public function loadOnePetSWF(obj:Object) : void
      {
         var tempLoader:Loader = new Loader();
         this.onePetObj = obj;
         PetsObj.arr.push(this.onePetObj);
         this.addPet(this.onePetObj);
      }
      
      public function loadPetSWF(level:Object) : void
      {
         if(newHouseView.isMyHouse && int(level) > 100)
         {
            LocalUserInfo.SuperPet(true);
         }
         this.completeHandler();
      }
      
      public function OnecompleteHandler(e:Event) : void
      {
         e.target.removeEventListener(Event.COMPLETE,this.OnecompleteHandler);
         var url:String = e.target.url.split("?")[0];
         var level:String = url.slice(-7,-4);
         if(isNaN(Number(level)))
         {
            level = url.slice(-5,-4);
         }
         this.addPet(this.onePetObj);
      }
      
      public function completeHandler() : void
      {
         this.addPet(PetsObj.arr[petloadNum]);
         ++petloadNum;
         if(petloadNum < PetsCount)
         {
            this.loadPetSWF(PetsObj.arr[petloadNum].Level);
         }
         else
         {
            getOnlyNumReq.Info();
         }
      }
      
      public function candyNum() : void
      {
      }
      
      public function getLanLevel(petID:uint) : uint
      {
         var Flag:uint = 0;
         var j:uint = 0;
         for(var i:uint = 0; i < petLanArr.length; i++)
         {
            if(petID == petLanArr[i].petID)
            {
               Flag = 0;
               for(j = 0; j < petLanArr[i].Flag_arr.length; j++)
               {
                  if(petLanArr[i].Flag_arr[j] == 1 || petLanArr[i].Flag_arr[j] == 2 || petLanArr[i].Flag_arr[j] == 15)
                  {
                     Flag += petLanArr[i].Flag_arr[j];
                  }
               }
               return Flag;
            }
         }
         return 0;
      }
      
      public function addPet(infoObj:Object) : void
      {
         var bool:Boolean;
         var i:uint;
         var level:uint;
         var lmifo:LamuInfo;
         var pet:MovieClip = null;
         var pet_hitBtn:TailButtonView = null;
         var f:Function = null;
         var l:Function = null;
         if(infoObj.Flag == 4 || infoObj.Flag == 8 || infoObj.Flag == 16 || infoObj.Flag == 32 || infoObj.Flag == 64)
         {
            return;
         }
         bool = false;
         for(i = 0; i < PetsObj.arr.length; i++)
         {
            if(PetsObj.arr[i].SpriteID == infoObj.SpriteID)
            {
               bool = true;
               break;
            }
         }
         if(!bool)
         {
            PetsObj.arr.push(infoObj);
         }
         level = uint(infoObj.Level);
         lmifo = new LamuInfo(infoObj);
         lmifo.upData2(infoObj);
         if(Boolean(GV.MC_Depth.getChildByName("pet" + infoObj.SpriteID)))
         {
            pet = GV.MC_Depth.getChildByName("pet" + infoObj.SpriteID) as MovieClip;
         }
         else
         {
            pet = ObjectPool.getObject(LamuNPC) as MovieClip;
            pet.setMasterID(lmifo.masterID,lmifo);
            pet.loadNPC(999);
            pet.level = level;
            pet.obj = infoObj;
            pet.SpriteID = infoObj.SpriteID;
            pet.LanLevel = this.getLanLevel(pet.SpriteID);
            if(pet.level > 100)
            {
               pet.LanLevel = 18;
            }
            if(infoObj.BlackSick > 0)
            {
               pet.say("/" + (24 + infoObj.BlackSick));
            }
            else
            {
               pet.petstatus = new petStatus(pet);
               pet.petstatus.changeStatus(infoObj);
            }
            petDic["pet" + pet.obj.UserID + "_" + pet.obj.SpriteID] = pet;
            pet.name = "pet" + pet.obj.SpriteID;
            I_LamuNPC(pet).boneManaage.lamuName = lmifo.PetName;
            pet.moving = false;
            GV.MC_Depth.addChild(pet);
            pet.x = int(Math.random() * 300) + 280;
            pet.y = int(Math.random() * 100) + 300;
         }
         if(Boolean(MapButtonView.getTarget().getChildByName("petBtn_" + lmifo.masterID + "_" + lmifo.PetID)))
         {
            pet_hitBtn = MapButtonView.getTarget().getChildByName("petBtn_" + lmifo.masterID + "_" + lmifo.PetID) as TailButtonView;
         }
         else
         {
            pet_hitBtn = new TailButtonView();
            pet_hitBtn.name = "petBtn_" + lmifo.masterID + "_" + lmifo.PetID;
            MapButtonView.getTarget().addChild(pet_hitBtn);
         }
         pet_hitBtn.x = pet.x;
         pet_hitBtn.y = pet.y;
         pet_hitBtn.buttonMode = true;
         pet_hitBtn.scaleX = pet_hitBtn.scaleY = 0.8;
         pet_hitBtn.fineTailTarget(pet as DisplayObjectContainer);
         pet_hitBtn.addEventListener(MouseEvent.MOUSE_OVER,this.cantmove);
         pet_hitBtn.addEventListener(MouseEvent.CLICK,this.clickPetHandle);
         pet_hitBtn.addEventListener(MouseEvent.MOUSE_OUT,this.canmove);
         f = function(E:NPCEvent):void
         {
            if(E.npc != pet)
            {
               return;
            }
            NPCEvent.removeEventListener(NPCEvent.ON_NPC_LOADED,f);
            if(playPetID.indexOf(pet.SpriteID) >= 0)
            {
               pet.visible = false;
            }
         };
         NPCEvent.addEventListener(NPCEvent.ON_NPC_LOADED,f);
         l = function(E:NPCEvent):void
         {
            if(E.npc != pet)
            {
               return;
            }
            NPCEvent.removeEventListener(NPCEvent.ON_NPC_LEAVE,l);
            pet_hitBtn.destroy();
            var btn:TailButtonView = pet_hitBtn as TailButtonView;
            if(Boolean(btn))
            {
               btn.destroy();
               GC.clearAll(btn);
            }
         };
         NPCEvent.addEventListener(NPCEvent.ON_NPC_LEAVE,l);
      }
      
      public function dragPet(e:MouseEvent) : void
      {
         this.DragBool = true;
         this.DragPetPoint = new Point(e.stageX,e.stageY);
      }
      
      public function movePet(e:MouseEvent) : void
      {
         if(this.DragBool)
         {
            e.target.parent.x = e.stageX - 10;
            e.target.parent.y = e.stageY - 10;
         }
      }
      
      public function playPet(e:MouseEvent) : void
      {
         this.DragBool = false;
         this.clickPetHandle(e);
      }
      
      public function findPetPlayGoods(pet:Object, p:Object) : void
      {
         var good:Object = null;
         var ld:Object = null;
         var petgood:Object = null;
         var thegood:MovieClip = null;
         for(var i:uint = 0; i < this.RootMC.depth_mc.numChildren; i++)
         {
            good = this.RootMC.depth_mc.getChildAt(i);
            if(good is MovieClip)
            {
               ld = good.getChildAt(0);
               if(Boolean(pet.hitTestObject(ld)))
               {
                  if(ld is Loader)
                  {
                     petgood = ld.content;
                     if(Boolean(petgood.mc2))
                     {
                        if(Boolean(petgood.mc2.needPet))
                        {
                           trace("是寵物玩的家具",good.ID);
                           if(Boolean(petgood.mc2.hitTestPoint(p.x,p.y,true)))
                           {
                              thegood = petgood.mc2.getChildAt(0);
                              thegood.gotoAndStop(2);
                              this.setPetColor(thegood.pet.petBody,pet.obj.Color);
                              break;
                           }
                        }
                     }
                  }
               }
            }
         }
      }
      
      public function outPet(e:MouseEvent) : void
      {
         this.DragBool = false;
      }
      
      public function wordInLan(lan:Array, word:String) : Boolean
      {
         for(var i:uint = 0; i < lan.length; i++)
         {
            if(lan[i] == word)
            {
               return true;
            }
         }
         return false;
      }
      
      public function Petlan2(lanarr:Array, msg:String) : String
      {
         for(var i:uint = 0; i < lanarr.length; )
         {
            if(msg == lanarr[i].lan)
            {
               return lanarr[i].arr[int(Math.random() * lanarr.length)];
            }
            i++;
         }
         return "哈哈";
      }
      
      public function sayWithMole(e:EventTaomee) : void
      {
         var i:uint = 0;
         var SpriteID:int = 0;
         var pet:Object = null;
         var lantime:Number = NaN;
         if(e.EventObj.obj.Friend == 0 && e.EventObj.obj.ID == GV.MyInfo_userID && this.wordInLan(LAN,e.EventObj.obj.MSG))
         {
            for(i = 0; i < PetsObj.arr.length; i++)
            {
               SpriteID = int(PetsObj.arr[i].SpriteID);
               pet = petDic["pet" + PetsObj.arr[i].UserID + "_" + SpriteID];
               if(Boolean(pet))
               {
                  if(pet.LanLevel == 1)
                  {
                     lantime = GF.getLocalGameHighScore("pet" + GV.MyInfo_userID + pet.SpriteID);
                     if(lantime < 2)
                     {
                        GF.updateLocalGameHighScore("pet" + GV.MyInfo_userID + pet.SpriteID,++lantime);
                        pet.petstatus.petsayWithMole(LAN1[int(Math.random() * LAN1.length)]);
                     }
                     else if(this.wordInLan(LAN1,e.EventObj.obj.MSG))
                     {
                        pet.petstatus.petsayWithMole(e.EventObj.obj.MSG);
                     }
                  }
                  else if(pet.LanLevel > 1)
                  {
                     if(this.wordInLan(LAN1,e.EventObj.obj.MSG))
                     {
                        pet.petstatus.petsayWithMole(e.EventObj.obj.MSG);
                     }
                     else
                     {
                        pet.petstatus.petsayWithMole(this.Petlan2(LAN2,e.EventObj.obj.MSG));
                     }
                  }
               }
            }
         }
      }
      
      public function cantmove(petid:uint) : void
      {
         if(!newHouseView.getInstance().editMode)
         {
            MoveTo.CanMove = false;
         }
      }
      
      public function canmove(petid:uint) : void
      {
         if(!newHouseView.getInstance().editMode)
         {
            MoveTo.CanMove = true;
         }
      }
      
      public function removePet(petid:uint) : void
      {
         var btn:TailButtonView = null;
         var ln:LamuNPC = LamuNPC(petDic["pet" + newHouseView.houseID + "_" + petid]);
         if(Boolean(ln))
         {
            ln.clearClass();
            btn = MapButtonView.getTarget().getChildByName("petBtn_" + ln._masterID + "_" + petid) as TailButtonView;
            if(Boolean(btn))
            {
               btn.destroy();
               GC.clearAll(btn);
            }
         }
      }
      
      public function showAttr(e:* = null) : void
      {
         this.petUIMC.attr_mc.visible = true;
      }
      
      public function hideAttr(e:* = null) : void
      {
         this.petUIMC.attr_mc.visible = false;
      }
      
      public function closePetPanel(e:* = null) : void
      {
         this.petUIMC.x = -1800;
         this.petUIMC.SpriteID = -1;
         this.petUIMC.foodback_btn.visible = false;
         this.petUIMC.food_btn.visible = newHouseView.isMyHouse ? true : false;
      }
      
      public function doPetFollow(e:Event) : void
      {
         var i:uint = 0;
         if(this.petUIMC.Level > 1)
         {
            if(this.petUIMC.Flag == 0)
            {
               if(GV.MyInfo_Pet != this.petUIMC.SpriteID)
               {
                  for(i = 0; i < PetsObj.arr.length; i++)
                  {
                     if(PetsObj.arr[i].SpriteID == this.petUIMC.SpriteID)
                     {
                        PetsObj.arr.splice(i,1);
                        break;
                     }
                  }
                  GV.MyInfo_PetName = this.petUIMC.name_txt.text;
                  petLogic.doPetFollow(this.petUIMC.SpriteID,1);
                  this.closePetPanel();
               }
               else
               {
                  trace("這個寵物已經跟隨了");
               }
            }
            else if(this.petUIMC.Flag == 1)
            {
               Alert.showAlert(GV.MC_AppLever,"","目前你的拉姆" + this.petUIMC.Nick + "生病了，無法跟隨哦！",Alert.IKNOW_ALERT);
            }
            else if(this.petUIMC.Flag == 2)
            {
               Alert.showAlert(GV.MC_AppLever,"","目前你的拉姆" + this.petUIMC.Nick + "死亡了，無法跟隨哦！",Alert.IKNOW_ALERT);
            }
         }
         else
         {
            trace("這個寵物等級不夠");
         }
      }
      
      public function clickPetHandle(e:Event) : void
      {
         var sayList:Array = null;
         var npcOptionInfo:NPCDialogOptionInfo = null;
         var npcDialogInfo:NPCDialogInfo = null;
         LamuReviveManager.pet = this._curPet = e.currentTarget.tailTarget as I_LamuNPC;
         this._curLamuInfo = e.currentTarget.tailTarget.lamuInfo;
         if(this._curLamuInfo.isDie && new Date().time - this._curLamuInfo.PetSickTime * 1000 > 3600 * 12 * 7)
         {
            if(newHouseView.isMyHouse == false)
            {
               return;
            }
            sayList = new Array();
            npcOptionInfo = new NPCDialogOptionInfo("小拉姆的天堂？",ActionType.TASK_FUNCTION,this.say2,false);
            sayList.push(npcOptionInfo);
            npcOptionInfo = new NPCDialogOptionInfo("沒什麼事！",ActionType.NONE);
            sayList.push(npcOptionInfo);
            npcDialogInfo = new NPCDialogInfo(10070,"正常","55555，小主人，我好可憐的！你這麼長時間不來照顧我，我都變成這個樣子了！我馬上要飛去小拉姆的天堂了！",sayList);
            NPCDialogManager.say(npcDialogInfo);
            return;
         }
         if(!newHouseView.getInstance().editMode)
         {
            if(newHouseView.isMyHouse)
            {
               this._curLamuInfo = e.currentTarget.tailTarget.lamuInfo;
               if(this._curLamuInfo.Petlevel > 1)
               {
                  petPanel.init(LocalUserInfo.getUserID(),this._curLamuInfo.PetID,0,PetsObj);
               }
               else if(this._curLamuInfo.Petlevel == 1)
               {
                  Alert.showAlert(GV.MC_AppLever,"","目前你的拉姆" + this._curLamuInfo.PetName + "還在種子階段，需要" + (24 - Math.floor(this._curLamuInfo.PetValue / 3600)) + "小時才能出來陪你玩哦!",Alert.IKNOW_ALERT);
               }
            }
            else
            {
               this._curLamuInfo = e.currentTarget.tailTarget.lamuInfo;
               if(this._curLamuInfo.Petlevel > 1)
               {
                  petPanel.init(GV.MapInfo_mapID,this._curLamuInfo.PetID,2,PetsObj);
               }
            }
         }
      }
      
      private function say2() : void
      {
         var npcOptionInfo:NPCDialogOptionInfo = null;
         var sayList:Array = new Array();
         npcOptionInfo = new NPCDialogOptionInfo("不要啊！我來救你！",ActionType.FUNCTION,this.onCheckHas180006Item);
         sayList.push(npcOptionInfo);
         npcOptionInfo = new NPCDialogOptionInfo("小拉姆，一路平安！",ActionType.TASK_FUNCTION,this.say4,false);
         sayList.push(npcOptionInfo);
         var npcDialogInfo:NPCDialogInfo = new NPCDialogInfo(10070,"正常","是啊！那裡應該是一個很漂亮很漂亮的地方！我會把我喜歡的衣服全部都帶著，這些都是小主人送給我的啊！",sayList);
         NPCDialogManager.say(npcDialogInfo);
      }
      
      private function say4() : void
      {
         var npcOptionInfo:NPCDialogOptionInfo = null;
         var sayList:Array = new Array();
         npcOptionInfo = new NPCDialogOptionInfo("小拉姆，我會想你的！",ActionType.FUNCTION,this.onLeaveLamu);
         sayList.push(npcOptionInfo);
         var npcDialogInfo:NPCDialogInfo = new NPCDialogInfo(10070,"正常","小主人，小拉姆要走了，小拉姆會想你的！永別了~~~~",sayList);
         NPCDialogManager.say(npcDialogInfo);
      }
      
      private function onCheckHas180006Item() : void
      {
         ModuleManager.openPanel("LamuReviveAlert1",this._curLamuInfo);
      }
      
      private function onLeaveLamu() : void
      {
         lamuSocket.setLamuLeave(this._curLamuInfo.PetID);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1257,this.read1257Fun);
         var p:Loader = new Loader();
         this._curPet["parent"].addChild(p);
         p.x = this._curPet.x;
         p.y = this._curPet.y;
         p.load(VL.getURLRequest("resource/pet/death/lamudeath.swf"));
      }
      
      private function read1257Fun(nd:*) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1257,this.read1257Fun);
         this._curPet.clearClass();
      }
      
      public function playWithPet(e:Event) : void
      {
         trace("---------------------playWithPet");
         var pet:MovieClip = e.target.parent;
         this.playingPetMC = pet;
         var ran:uint = uint(petPlayArr[int(Math.random() * 3)]);
         if(this.petUIMC.Flag != 2 && pet.obj.Flag != 2)
         {
            this.petAction(pet,ran);
         }
         trace("GV.MyInfo_userID:::1",GV.MyInfo_userID);
      }
      
      public function showPetInfo(e:Event) : void
      {
         var obj:Object = e.target.parent.obj;
         for(var i:uint = 0; i < PetsObj.arr.length; i++)
         {
            if(PetsObj.arr[i].SpriteID == obj.SpriteID)
            {
               obj = PetsObj.arr[i];
               break;
            }
         }
         if(!newHouseView.getInstance().editMode)
         {
            if(obj.Level > 1)
            {
               this.backFoodPanel();
               this.petUIMC.x = 88;
               this.petFoodMC.x = -1800;
               trace("+++++++++++點的寵物的等級是：",obj.Level);
               if(obj.Level <= 0)
               {
                  this.petUIMC.food_btn.visible = false;
                  this.petUIMC.follow_btn.visible = false;
               }
               else
               {
                  this.petUIMC.food_btn.visible = true;
                  this.petUIMC.follow_btn.visible = true;
               }
               this.playingPetMC = e.target.parent;
               this.petUIMC.name_txt.text = obj.Nick;
               trace("-----------flag+1",obj.Flag + 1);
               this.petUIMC.health_mc.gotoAndStop(obj.Flag + 1);
               this.petUIMC.hour_txt.text = String(int(obj.Value / 3600));
               this.refreshUIData(obj);
               this.petUIMC.SpriteID = obj.SpriteID;
               this.PetID = obj.SpriteID;
               trace("寵物ＩＤ：",this.PetID);
               this.petUIMC.Level = obj.Level;
               this.petUIMC.Nick = obj.Nick;
               this.petUIMC.Color = obj.Color;
               this.petUIMC.Flag = obj.Flag;
               this.petUIMC.pet_mc.gotoAndStop(this.petUIMC.Level);
               this.petUIMC.pet_ye.gotoAndStop(this.petUIMC.Level);
               this.setPetColor(this.petUIMC.pet_mc,obj.Color);
               this.showFoodPanel();
            }
            else
            {
               Alert.showAlert(GV.MC_AppLever,"","目前你的拉姆" + obj.Nick + "還在種子階段，需要" + (24 - Math.floor(obj.Value / 3600)) + "小時才能出來陪你玩哦!",Alert.IKNOW_ALERT);
            }
         }
      }
      
      public function startDragPet(e:* = null) : void
      {
         if(newHouseView.getInstance().editMode)
         {
            e.target.parent.startDrag();
         }
      }
      
      public function stopDragPet(e:* = null) : void
      {
      }
      
      public function ChangeThePetColor(petData:Object) : void
      {
         if(newHouseView.isMyHouse)
         {
            this.updateFoodArr(petData);
            petPanel.closePetPanel();
         }
         var pet:Object = petDic["pet" + petData.UserID + "_" + petData.SpriteID];
         pet.obj.Color = petData.ColorType;
         pet.lamuinfo.PetColor = petData.ColorType;
      }
      
      public function setPetColor(mc:DisplayObject, colorNum:uint) : void
      {
         var _array:Array = GV["petColor_" + colorNum];
         mc.transform.colorTransform = new ColorTransform(_array[0],_array[1],_array[2],_array[3],_array[4],_array[5],_array[6],_array[7]);
      }
      
      public function doPetFood(e:Event) : void
      {
         if(Boolean(e.target.parent.Level))
         {
            this.showFoodPanel();
         }
      }
      
      private function getFoodInfo(e:Event) : void
      {
      }
      
      private function backFoodPanel(e:* = null) : void
      {
         this.petFoodMC.x = -1800;
         this.petUIMC.foodback_btn.visible = false;
         this.petUIMC.food_btn.visible = true;
      }
      
      private function showFoodPanel() : void
      {
         this.petUIMC.foodback_btn.visible = true;
         this.petUIMC.food_btn.visible = !this.petUIMC.foodback_btn.visible;
         this.petUIMC.foodback_btn.addEventListener(MouseEvent.CLICK,this.backFoodPanel);
         this.petFoodMC.x = 255;
      }
      
      private function showFoods(pagenum:uint = 1, Type:uint = 1) : void
      {
         var temp:Object = null;
         var tempLoader:Loader = null;
         this.petFoodMC.type1_mc.gotoAndStop(2);
         this.petFoodMC.type2_mc.gotoAndStop(2);
         this.petFoodMC["type" + Type + "_mc"].gotoAndStop(1);
         this.showFoodPanel();
         this.currentPage = pagenum;
         this.currentType = Type;
         this.clearItems();
         var arr:Array = petGoodsTypeArr[this.currentType - 1];
         var totalpage:uint = arr.length % this.NUM == 0 ? uint(arr.length / this.NUM) : uint(Math.floor(arr.length / this.NUM) + 1);
         this.petFoodMC.page_txt.text = this.currentPage + "/" + totalpage;
         for(var i:int = (this.currentPage - 1) * this.NUM; i < this.currentPage * this.NUM; i++)
         {
            temp = this.petFoodMC["I" + (i - (this.currentPage - 1) * this.NUM)];
            if(arr[i] != null)
            {
               temp.ID = arr[i].ID;
               temp.Name = arr[i].Name;
               temp.Type = arr[i].Type;
               temp.Count = arr[i].Count;
               temp.Grade = arr[i].Grade;
               temp.Price = arr[i].Price;
               temp.Hungry = arr[i].Hungry;
               temp.Thirsty = arr[i].Thirsty;
               temp.Dirty = arr[i].Dirty;
               temp.Spirit = arr[i].Spirit;
               temp.Eat = arr[i].Eat;
               temp.Tool = arr[i].Tool;
               temp.ColorType = arr[i].ColorType;
               temp.btn.visible = true;
               if(temp.Type == 2)
               {
                  temp.num_txt.text = "";
               }
               else
               {
                  temp.num_txt.text = temp.Count;
               }
               temp.btn.addEventListener(MouseEvent.MOUSE_OVER,this.onBtnOver);
               temp.btn.addEventListener(MouseEvent.MOUSE_OUT,this.onBtnOut);
               temp.btn.addEventListener(MouseEvent.CLICK,this.userFood);
               tempLoader = new Loader();
               tempLoader.load(VL.getURLRequest("resource/pet/icon/" + arr[i].ID + ".swf"));
               temp.loadimg.addChild(tempLoader);
            }
            else
            {
               temp.btn.enabled = false;
            }
         }
      }
      
      private function getGoodsType(Type:Object) : Array
      {
         var arr:Array = new Array();
         for(var i:uint = 0; i < petGoodsArr.length; i++)
         {
            if(petGoodsArr[i].Type == Type)
            {
               arr.push(petGoodsArr[i]);
            }
         }
         return arr;
      }
      
      private function userFood(e:Event) : void
      {
         this.itemInfo = e.target.parent;
         ItemID = this.itemInfo.ID;
         if(this.petUIMC.Flag == 0)
         {
            if(this.itemInfo.ID == 180005)
            {
               Alert.showAlert(GV.MC_AppLever,"","目前你的拉姆" + this.petUIMC.Nick + "沒生病，不能餵藥哦！",Alert.IKNOW_ALERT);
            }
            else if(this.itemInfo.ID == 180006)
            {
               Alert.showAlert(GV.MC_AppLever,"","目前你的拉姆" + this.petUIMC.Nick + "沒死亡，不能復活哦！",Alert.IKNOW_ALERT);
            }
            else
            {
               this.initBuy();
            }
         }
         else if(this.petUIMC.Flag == 1)
         {
            if(this.itemInfo.ID == 180005)
            {
               this.initBuy();
            }
            else if(this.itemInfo.ID == 180006)
            {
               Alert.showAlert(GV.MC_AppLever,"","目前你的拉姆" + this.petUIMC.Nick + "沒死亡，不能復活哦！",Alert.IKNOW_ALERT);
            }
            else
            {
               this.initBuy();
            }
         }
         else if(this.petUIMC.Flag == 2)
         {
            if(this.itemInfo.ID == 180005)
            {
               Alert.showAlert(GV.MC_AppLever,"","目前你的拉姆" + this.petUIMC.Nick + "死亡了，無法餵藥哦！",Alert.IKNOW_ALERT);
            }
            else if(this.itemInfo.ID == 180006)
            {
               this.initBuy();
            }
            else
            {
               Alert.showAlert(GV.MC_AppLever,"","目前你的拉姆" + this.petUIMC.Nick + "死亡了，無法餵養哦！",Alert.IKNOW_ALERT);
            }
         }
      }
      
      private function initBuy() : void
      {
      }
      
      private function canEat() : Boolean
      {
         return this.itemInfo.Eat.indexOf(this.petUIMC.Level) >= 0 ? true : false;
      }
      
      private function canTool() : Boolean
      {
         return this.itemInfo.Tool >= 1;
      }
      
      public function updatePetData(petData:Object) : void
      {
         this.updateFoodArr(petData);
         if(newHouseView.isMyHouse)
         {
            this.showFoods(this.currentPage,this.currentType);
            this.updatePetInfo(petData);
         }
         if(petPanel.Locked)
         {
            petPanel.refreshUIData(petData);
            petPanel.closePetPanel();
         }
         this.showPetAction(petData.SpriteID,petData.Action);
      }
      
      private function updatePetInfo(petData:Object) : void
      {
         for(var i:uint = 0; i < PetsCount; i++)
         {
            if(PetsObj.arr[i].SpriteID == petData.SpriteID)
            {
               PetsObj.arr[i].Flag = petData.Flag;
               PetsObj.arr[i].Hungry = petData.Hungry;
               PetsObj.arr[i].Thirsty = petData.Thirsty;
               PetsObj.arr[i].Dirty = petData.Dirty;
               PetsObj.arr[i].Spirit = petData.Spirit;
               if(petData.BlackSick != -1)
               {
                  PetsObj.arr[i].BlackSick = petData.BlackSick;
               }
               break;
            }
         }
      }
      
      private function updateFoodArr(petData:Object) : void
      {
         var j:uint = 0;
         if(newHouseView.isMyHouse)
         {
            for(j = 0; j < petGoodsArr.length; j++)
            {
               if(petData.Action == petGoodsArr[j].ID)
               {
                  if(petData.Type == 1)
                  {
                     petGoodsArr[j].Count -= 1;
                  }
                  if(petGoodsArr[j].Count == 0)
                  {
                     petGoodsArr.splice(j,1);
                     this.TypeGoods();
                     break;
                  }
               }
            }
         }
      }
      
      private function showPetAction(petid:uint, ItemID:uint) : void
      {
         this.playingPetMC = this.getPetByID(petid);
         if(Boolean(this.playingPetMC))
         {
            this.playingPetMC.currentFood = ItemID;
            this.petAction(this.playingPetMC,ItemID);
         }
      }
      
      public function petLive(petid:uint) : void
      {
         for(var i:uint = 0; i < PetsObj.arr.length; i++)
         {
            if(PetsObj.arr[i].SpriteID == petid)
            {
               PetsObj.arr[i].Flag = 0;
               break;
            }
         }
      }
      
      public function petAction(mc:Object, i:uint) : void
      {
         var obj:Object = GoodsInfo.getInfoById(i);
         if(Boolean(obj.EatType))
         {
            mc.showIconAction(obj.EatType,i);
         }
         else
         {
            trace("特殊物品!!!");
         }
      }
      
      public function feedcompleteHandler(e:Event) : void
      {
         e.target.removeEventListener(Event.COMPLETE,this.feedcompleteHandler);
         var food:DisplayObject = e.target.content.root.getChildAt(0);
         this.playingPetMC.feedMC.addChild(food);
         food.addEventListener("gotoEnd",this.showPet);
         this.hidePet(this.playingPetMC);
         this.setPetColor(food["petBody"],this.playingPetMC.obj.Color);
      }
      
      public function hidePet(mc:MovieClip) : void
      {
         for(var i:uint = 0; i < mc.numChildren; i++)
         {
            mc.getChildAt(i).visible = false;
         }
         mc.feedMC.visible = true;
      }
      
      public function getpetinfo(petid:uint) : *
      {
         for(var i:uint = 0; i < PetsObj.arr.length; i++)
         {
            if(PetsObj.arr[i].SpriteID == petid)
            {
               return PetsObj.arr[i];
            }
         }
      }
      
      public function showPet(e:Event) : void
      {
         var i:uint = 0;
         trace("---showPet-----------",ItemID);
         if(ItemID == 180026)
         {
            this.RootMC["houseTool"]["clearMud_mc"].play();
            this.RootMC["houseTool"]["flowers_mc"].mud.text = 0;
         }
         var mc:Object = e.target.parent.parent;
         if(Boolean(mc))
         {
            if(Boolean(mc.petstatus))
            {
               mc.petstatus.changeStatus(this.getpetinfo(mc.SpriteID));
               mc.petstatus.petsayWord(ItemID);
            }
            for(i = 0; i < mc.numChildren; i++)
            {
               mc.getChildAt(i).visible = true;
               try
               {
                  mc.getChildAt(i).gotoAndStop(2);
               }
               catch(e:Error)
               {
               }
            }
         }
      }
      
      public function refreshUIData(obj:Object) : void
      {
         for(var i:uint = 0; i < PetsObj.arr.length; i++)
         {
            if(PetsObj.arr[i].SpriteID == obj.SpriteID)
            {
               PetsObj.arr[i].Hungry = obj.Hungry;
               PetsObj.arr[i].Thirsty = obj.Thirsty;
               PetsObj.arr[i].Dirty = obj.Dirty;
               PetsObj.arr[i].Spirit = obj.Spirit;
            }
         }
         this.petUIMC.attr_mc.hungry_txt.text = obj.Hungry + "/100";
         this.petUIMC.attr_mc.thirsty_txt.text = obj.Thirsty + "/100";
         this.petUIMC.attr_mc.dirty_txt.text = obj.Dirty + "/100";
         this.petUIMC.attr_mc.spirit_txt.text = obj.Spirit + "/100";
         this.changeMaskColor(this.petUIMC.hungry_percent,obj.Hungry);
         this.changeMaskColor(this.petUIMC.thirsty_percent,obj.Thirsty);
         this.changeMaskColor(this.petUIMC.dirty_percent,obj.Dirty);
         this.changeMaskColor(this.petUIMC.spirit_percent,obj.Spirit);
      }
      
      private function changeMaskColor(mc:Object, i:uint) : void
      {
         if(i < 31)
         {
            mc.mask_mc.gotoAndStop(1);
         }
         else if(i > 69)
         {
            mc.mask_mc.gotoAndStop(3);
         }
         else
         {
            mc.mask_mc.gotoAndStop(2);
         }
         mc.mask_mc.width = i;
      }
      
      private function clearItems() : void
      {
         var temp:Object = null;
         for(var i:uint = 0; i < this.NUM; i++)
         {
            temp = this.petFoodMC["I" + i];
            temp.num_txt.text = "";
            try
            {
               if(temp.ID != null)
               {
                  temp.loadimg.removeChildAt(0);
                  temp.btn.visible = false;
               }
            }
            catch(err:Error)
            {
            }
         }
      }
      
      public function drag_start(evt:MouseEvent) : void
      {
         this.petUIMC.startDrag();
      }
      
      public function drag_stop(evt:MouseEvent) : void
      {
         this.petUIMC.stopDrag();
      }
      
      public function drag_move(evt:MouseEvent) : void
      {
         evt.updateAfterEvent();
      }
      
      private function onBtnOver(E:MouseEvent) : void
      {
         var foodObj:MovieClip = E.target.parent;
         foodObj.gotoAndStop(2);
      }
      
      private function onBtnOut(E:MouseEvent) : void
      {
         var foodObj:MovieClip = E.target.parent;
         foodObj.gotoAndStop(1);
      }
      
      private function enoughMoney(goodPrice:Number) : Boolean
      {
         return LocalUserInfo.getYXQ() >= goodPrice;
      }
      
      private function penClick(event:MouseEvent) : void
      {
         if(event.target.parent.currentFrame == 1)
         {
            event.target.parent.gotoAndStop(2);
            this.petUIMC.name_txt.type = TextFieldType.INPUT;
            this.petUIMC.name_txt.border = true;
         }
         else if(this.petUIMC.name_txt.text != this.petUIMC.Nick)
         {
            event.target.parent.gotoAndStop(1);
            petLogic.modPetNick(this.petUIMC.SpriteID,this.petUIMC.name_txt.text);
            this.petUIMC.name_txt.type = TextFieldType.DYNAMIC;
            this.petUIMC.name_txt.border = false;
            this.petUIMC.Nick = this.petUIMC.name_txt.text;
            this.playingPetMC.obj.Nick = this.petUIMC.name_txt.text;
            GV.MyInfo_PetName = this.petUIMC.Nick;
         }
      }
      
      public function showPetPlay(obj:Object) : void
      {
         var pet:Object = petDic["pet" + obj.UserID + "_" + obj.SpriteID];
         if(Boolean(pet) && Boolean(pet.petBody as MovieClip))
         {
            pet.petBody.gotoAndStop(10 + Number(obj.Action));
         }
      }
      
      public function getPetByID(id:uint, userID:uint = 0) : MovieClip
      {
         if(Boolean(userID))
         {
            return petDic["pet" + userID + "_" + id] as MovieClip;
         }
         return petDic["pet" + newHouseView.houseID + "_" + id] as MovieClip;
      }
      
      public function hideAllPet() : void
      {
         this.getPetInHouse(false);
      }
      
      public function showAllPet() : void
      {
         this.getPetInHouse(true);
      }
      
      public function getPetInHouse(PetVisible:Boolean = true) : void
      {
         var pet:DisplayObject = null;
         for(var i:uint = 0; i < PetsCount; i++)
         {
            pet = petDic["pet" + PetsObj.arr[i].UserID + "_" + PetsObj.arr[i].SpriteID];
            if(pet is MovieClip)
            {
               pet.visible = PetVisible;
            }
         }
      }
   }
}

