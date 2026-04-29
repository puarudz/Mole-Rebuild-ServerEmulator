package com.module.pet
{
   import com.common.Alert.*;
   import com.common.Alert.type.AlertType;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.info.MapInfo;
   import com.core.loading.Loading;
   import com.core.newloader.LoaderList;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.global.staticData.MapsConfig;
   import com.logic.socket.cure.SetCureAllInfo;
   import com.logic.socket.lookBag.LookBagReq;
   import com.logic.socket.lookBag.LookBagRes;
   import com.logic.socket.petSocket.adoptPet.*;
   import com.logic.socket.shopItem.BuyItemReq;
   import com.logic.socket.shopItem.BuyItemRes;
   import com.module.activityModule.checkItem;
   import com.module.home.HomeView;
   import com.module.newHouse.newHouseView;
   import com.module.npc.lamu.LamuInfo;
   import com.module.query.QueryImpl;
   import com.mole.app.manager.BufferManager;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.task.TaskManager;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextFieldType;
   
   public class petPanel
   {
      
      private static var InitBool:Boolean;
      
      private static var PanelMC:MovieClip;
      
      public static var petUIMC:MovieClip;
      
      private static var petFoodMC:MovieClip;
      
      private static var infoClass:MCLoader;
      
      public static var Locked:Boolean;
      
      private static var ClothLocked:Boolean;
      
      private static var HonorLocked:Boolean;
      
      private static var CertificationLocked:Boolean;
      
      private static var PetType:uint;
      
      public static var PetID:uint;
      
      private static var UserID:uint;
      
      private static var currentPage:uint;
      
      private static var currentType:uint;
      
      private static var TypeArr:Array;
      
      private static var PetAllItem:Array;
      
      private static var PetsObj:Object;
      
      public static var ClothDataArr:Object;
      
      public static var HonorDataArr:Object;
      
      public static var CertificationArr:Object;
      
      public static var itemInfo:Object;
      
      public static var ItemID:uint;
      
      public static var doPetFollowBool:Boolean;
      
      public static var feedAlert:*;
      
      public static var NUM:uint = 12;
      
      public static var usedClothID:uint = 0;
      
      public static var oldClothID:uint = 0;
      
      public static var usedHonorID:uint = 0;
      
      public static var oldHonorID:uint = 0;
      
      private static var lvlArr:Array = ["種子階段","初級階段","中級階段","高級階段","高級階段","超級拉姆"];
      
      private static var lvldataArr:Array = [1,30,90];
      
      private static var presentLvl:uint = 0;
      
      private static var skillLvlDataArr:Array = [0,40,180,660,1340,2660,4280,6840,9800,14000,18700,9999999];
      
      public function petPanel()
      {
         super();
      }
      
      public static function init(userid:uint, petid:uint, petType:uint, petsObj:Object = null) : void
      {
         if(!Locked)
         {
            Locked = true;
            PetsObj = petView.PetsObj;
            PetID = petid;
            UserID = userid;
            ClothLocked = false;
            HonorLocked = false;
            CertificationLocked = false;
            ClothDataArr = GoodsInfo.getInfoById(1200001);
            HonorDataArr = GoodsInfo.getInfoById(1210001);
            CertificationArr = GoodsInfo.getInfoById(1310001);
            doPetFollowBool = false;
            PetType = petType;
            PetAllItem = new Array();
            PetAllItem[1] = new Array();
            PetAllItem[2] = new Array();
            PetAllItem[3] = new Array();
            PetAllItem[4] = new Array();
            PetAllItem[5] = new Array();
            PanelMC = new MovieClip();
            loadPanel();
         }
      }
      
      private static function loadPanel(evt:* = null) : void
      {
         GV.onlineSocket.addEventListener("removeMapEvent",removeHandler);
         if(PanelMC.parent == null && !GV.isChangeMap)
         {
            MainManager.getTopLevel().addChild(PanelMC);
            PanelMC.visible = true;
            PanelMC.PetID = 0;
            PanelMC.UserID = 0;
            infoClass = new MCLoader("module/petUI/petUI.swf",PanelMC,Loading.TITLE_AND_PERCENT,"正在打開寵物面板");
            infoClass.addEventListener(MCLoadEvent.ON_SUCCESS,loadPetPanelOverHandler);
            LoaderList.getInstance().addItem(infoClass,null,LoaderList.HIGH,true);
         }
      }
      
      public static function initPanel() : void
      {
         petUIMC.SpriteID = -1;
         petUIMC.foodback_btn.visible = false;
         petUIMC.food_btn.visible = true;
         petUIMC.close_btn.addEventListener(MouseEvent.CLICK,closePanel);
         petUIMC.drag_mc.addEventListener(MouseEvent.MOUSE_DOWN,drag_start);
         petUIMC.drag_mc.addEventListener(MouseEvent.MOUSE_UP,drag_stop);
         petUIMC.drag_mc.addEventListener(MouseEvent.MOUSE_MOVE,drag_move);
         petUIMC.pen.btn.addEventListener(MouseEvent.CLICK,penClick);
         petUIMC.follow_btn.addEventListener(MouseEvent.CLICK,doPetFollow);
         petUIMC.healing_btn.addEventListener(MouseEvent.CLICK,doPetFollow);
         petUIMC.revival_btn.addEventListener(MouseEvent.CLICK,revivalFun);
         petUIMC.back_btn.addEventListener(MouseEvent.CLICK,doPetBackHome);
         petUIMC.food_btn.addEventListener(MouseEvent.CLICK,doPetFood);
         petUIMC.foodback_btn.addEventListener(MouseEvent.CLICK,hidePetFood);
         petUIMC.look_btn.addEventListener(MouseEvent.CLICK,showHonorPanel);
         petUIMC.feed_btn.addEventListener(MouseEvent.CLICK,showFoodPanel);
      }
      
      public static function showHonorPanel(e:MouseEvent) : void
      {
         currentType = 3;
         petFoodMC.type1_btn.y = -1000;
         petFoodMC.type1_mc.y = -1000;
         petFoodMC.type2_btn.y = -1000;
         petFoodMC.type2_mc.y = -1000;
         petFoodMC.type3_btn.y = 20;
         petFoodMC.type3_mc.y = 39;
         petFoodMC.type4_btn.y = -1000;
         petFoodMC.type4_mc.y = -1000;
         petFoodMC.type5_btn.y = -1000;
         petFoodMC.type5_mc.y = -1000;
         petFoodMC.type1_mc.gotoAndStop(2);
         petFoodMC.type2_mc.gotoAndStop(2);
         petFoodMC.type3_mc.gotoAndStop(1);
         petFoodMC.type4_mc.gotoAndStop(2);
         petFoodMC.type5_mc.gotoAndStop(2);
         changeHonorType();
      }
      
      public static function showFoodPanel(e:Event) : void
      {
         currentType = 1;
         showPetGoods();
      }
      
      public static function showPetGoods2() : void
      {
         var lookBagClass:LookBagReq = new LookBagReq();
         lookBagClass.lookBag(LocalUserInfo.getUserID(),64,0);
         GV.onlineSocket.addEventListener(LookBagRes.BAG_OVER,getPetGoods2);
      }
      
      public static function getPetGoods2(e:EventTaomee) : void
      {
         var itemCount:uint = 0;
         var petGoodsArr:Array = e.EventObj.obj.arr;
         for(var i:uint = 0; i < petGoodsArr.length; i++)
         {
            itemCount = uint(petGoodsArr[i].itemCount);
            petGoodsArr[i] = GoodsInfo.getInfoById(petGoodsArr[i].id);
            petGoodsArr[i].Count = itemCount;
         }
         PetAllItem[1] = petGoodsArr;
         GV.onlineSocket.removeEventListener(LookBagRes.BAG_OVER,getPetGoods2);
         showFoods(1,1,false);
      }
      
      public static function showPetGoods() : void
      {
         var lookBagClass:LookBagReq = new LookBagReq();
         lookBagClass.lookBag(LocalUserInfo.getUserID(),64,0);
         GV.onlineSocket.addEventListener(LookBagRes.BAG_OVER,getPetGoods);
      }
      
      public static function getPetGoods(e:EventTaomee) : void
      {
         var itemCount:uint = 0;
         var petGoodsArr:Array = e.EventObj.obj.arr;
         for(var i:uint = 0; i < petGoodsArr.length; i++)
         {
            itemCount = uint(petGoodsArr[i].itemCount);
            petGoodsArr[i] = GoodsInfo.getInfoById(petGoodsArr[i].id);
            petGoodsArr[i].Count = itemCount;
         }
         PetAllItem[1] = petGoodsArr;
         GV.onlineSocket.removeEventListener(LookBagRes.BAG_OVER,getPetGoods);
         petUIMC.food_btn.visible = false;
         petUIMC.foodback_btn.visible = false;
         petFoodMC.visible = true;
         petFoodMC.type1_mc.gotoAndStop(1);
         petFoodMC.type2_mc.gotoAndStop(2);
         petFoodMC.type3_mc.gotoAndStop(2);
         petFoodMC.type4_mc.gotoAndStop(2);
         petFoodMC.type1_btn.y = 20;
         petFoodMC.type1_mc.y = 39;
         petFoodMC.type2_btn.y = -1000;
         petFoodMC.type2_mc.y = -1000;
         petFoodMC.type3_btn.y = -1000;
         petFoodMC.type3_mc.y = -1000;
         petFoodMC.type4_btn.y = -1000;
         petFoodMC.type4_mc.y = -1000;
         petFoodMC.type5_btn.y = -1000;
         petFoodMC.type5_mc.y = -1000;
         showFoods(1,1,false);
      }
      
      public static function doPetBackHome(e:Event) : void
      {
         if(GV.MyInfo_PetObj.Level > 1)
         {
            if(Boolean(MapsConfig.MapsInfo[LocalUserInfo.getMapID()]) && Boolean(MapsConfig.MapsInfo[LocalUserInfo.getMapID()].isLamuWorld))
            {
               Alert.smileAlart("\t\t黑森林非常危險，拉姆不可以單獨回去...");
               closePetPanel();
               return;
            }
            petInMapLogic.doPethome(PetID);
         }
         closePetPanel();
      }
      
      public static function hidePetFood(e:Event) : void
      {
         petUIMC.food_btn.visible = true;
         petUIMC.foodback_btn.visible = false;
         petFoodMC.visible = false;
      }
      
      public static function doPetFood(e:MouseEvent) : void
      {
         petUIMC.food_btn.visible = false;
         petUIMC.foodback_btn.visible = true;
         petFoodMC.visible = true;
         switch(PetType)
         {
            case 0:
               break;
            case 1:
               changeFoodType(e);
               break;
            case 2:
               break;
            case 3:
               changeHonorType(e);
         }
      }
      
      public static function BtnPos() : void
      {
         var posArr:Array = [[20,39,70,88,120,137,170,187,220,237],[20,39,70,88,120,137,170,187,220,237],[-1000,-1000,-1000,-1000,20,39,70,88,120,137],[-1000,-1000,-1000,-1000,20,39,70,88,120,137]];
         petFoodMC.type1_btn.y = posArr[PetType][0];
         petFoodMC.type1_mc.y = posArr[PetType][1];
         petFoodMC.type2_btn.y = posArr[PetType][2];
         petFoodMC.type2_mc.y = posArr[PetType][3];
         petFoodMC.type3_btn.y = posArr[PetType][4];
         petFoodMC.type3_mc.y = posArr[PetType][5];
         petFoodMC.type4_btn.y = posArr[PetType][6];
         petFoodMC.type4_mc.y = posArr[PetType][7];
         petFoodMC.type5_btn.y = posArr[PetType][8];
         petFoodMC.type5_mc.y = posArr[PetType][9];
      }
      
      public static function loadPetPanelOverHandler(evt:MCLoadEvent) : void
      {
         InitBool = true;
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:Loader = evt.getLoader();
         var tempClass:* = childMC.contentLoaderInfo.applicationDomain.getDefinition("petPanelMC");
         petUIMC = new tempClass();
         initPanel();
         petFoodMC = petUIMC.petFoodMC;
         petFoodMC.type1_btn.addEventListener(MouseEvent.CLICK,changeFoodType);
         petFoodMC.type2_btn.addEventListener(MouseEvent.CLICK,changeClothType);
         petFoodMC.type3_btn.addEventListener(MouseEvent.CLICK,changeHonorType);
         petFoodMC.type4_btn.addEventListener(MouseEvent.CLICK,changeCertificationType);
         petFoodMC.type5_btn.addEventListener(MouseEvent.CLICK,changeSkillType);
         petFoodMC.P_btn.addEventListener(MouseEvent.CLICK,preGoodPage);
         petFoodMC.N_btn.addEventListener(MouseEvent.CLICK,nextGoodPage);
         petUIMC.loadmc = childMC;
         mainMC.addChild(petUIMC);
         PanelMC.x = 204.55;
         PanelMC.y = 110.5;
         PanelMC.visible = true;
         PanelMC.parent.setChildIndex(PanelMC,PanelMC.parent.numChildren - 1);
         infoClass = null;
         showPetPanel();
         chartTask382();
      }
      
      private static function chartTask382() : void
      {
         if(TaskManager.getTask(382).state >= 2)
         {
            BufferManager.addBufferEvent(BufferManager.TASK_382_201408_1,backTask382_1);
            BufferManager.getBuffer(BufferManager.TASK_382_201408_1);
         }
      }
      
      private static function backTask382_1(e:EventTaomee) : void
      {
         BufferManager.removeBufferEvent(BufferManager.TASK_382_201408_1,backTask382_1);
         var flag:int = int(e.EventObj);
         if(flag == 0)
         {
            BufferManager.setBuffer(BufferManager.TASK_382_201408_1,1);
            ModuleManager.openPanel("Task382Flag_1",{"URL":"newTaskPetUI"});
         }
      }
      
      public static function getGoodsObj(id:Number, xml:XML) : Object
      {
         var obj:Object = null;
         var len:int = xml.children().length();
         for(var j:int = 0; j < len; j++)
         {
            if(id == Number(xml.Item[j]["ID"]))
            {
               obj = new Object();
               obj = new Object();
               obj.ID = xml.Item[j]["ID"];
               obj.Name = xml.Item[j]["Name"];
               obj.Grade = xml.Item[j]["Grade"];
               obj.Price = xml.Item[j]["Price"];
               obj.Layer = xml.Item[j]["Layer"];
               obj.Level = xml.Item[j]["Level"];
               return obj;
            }
         }
         return "id錯了";
      }
      
      public static function changeFoodType(e:MouseEvent) : void
      {
         showFoods(1,1);
      }
      
      public static function changeClothType(e:MouseEvent = null) : void
      {
         if(!ClothLocked)
         {
            ClothLocked = true;
            GV.onlineSocket.addEventListener(petClothRes.PET_GET_ITEM_SUCC,getClothItem);
            petClothReq.petItemReq(UserID,PetID,1200001,1200001 + ClothDataArr.len,0);
         }
         else
         {
            showCloth(1,2);
         }
      }
      
      public static function changeHonorType(e:MouseEvent = null) : void
      {
         if(!HonorLocked)
         {
            HonorLocked = true;
            GV.onlineSocket.addEventListener(petClothRes.PET_GET_ITEM_SUCC,getHonorItem);
            petClothReq.petItemReq(UserID,PetID,1210001,1210001 + HonorDataArr.len,0);
         }
         else
         {
            showHonor(1,3);
         }
      }
      
      public static function changeCertificationType(e:MouseEvent = null) : void
      {
         if(!CertificationLocked)
         {
            CertificationLocked = true;
            GV.onlineSocket.addEventListener(petClothRes.PET_GET_ITEM_SUCC,getCertificationItem);
            petClothReq.petItemReq(UserID,PetID,1310001,1310001 + CertificationArr.len,0);
         }
         else
         {
            showCertification(1,4);
         }
      }
      
      public static function changeSkillType(e:MouseEvent = null) : void
      {
         showSkill(1,5);
      }
      
      public static function getClothItem(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(petClothRes.PET_GET_ITEM_SUCC,getClothItem);
         for(var i:uint = 0; i < e.EventObj.arr.length; i++)
         {
            PetAllItem[2].push(e.EventObj.arr[i]);
         }
         initNotUsed(PetAllItem[2]);
         showCloth(1,2);
      }
      
      public static function getHonorItem(e:EventTaomee) : void
      {
         petFoodMC.visible = true;
         GV.onlineSocket.removeEventListener(petClothRes.PET_GET_ITEM_SUCC,getHonorItem);
         for(var i:uint = 0; i < e.EventObj.arr.length; i++)
         {
            PetAllItem[3].push(e.EventObj.arr[i]);
         }
         trace("_______得到榮譽");
         initNotUsed(PetAllItem[3]);
         showHonor(1,3);
      }
      
      public static function getCertificationItem(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(petClothRes.PET_GET_ITEM_SUCC,getCertificationItem);
         for(var i:uint = 0; i < e.EventObj.arr.length; i++)
         {
            PetAllItem[4].push(e.EventObj.arr[i]);
         }
         initNotUsed(PetAllItem[4]);
         showCertification(1,4);
      }
      
      public static function showPetPanel() : void
      {
         PanelMC.x = 204.55;
         PanelMC.y = 110.5;
         if(PanelMC.UserID == UserID && PetID == PanelMC.PetID && PanelMC.visible)
         {
            return;
         }
         PanelMC.visible = true;
         petUIMC.back_btn.visible = false;
         petUIMC.look_btn.visible = false;
         petUIMC.feed_btn.visible = false;
         petUIMC.healing_btn.visible = false;
         petUIMC.revival_btn.visible = false;
         switch(PetType)
         {
            case 0:
               petUIMC.foodback_btn.visible = true;
               petUIMC.food_btn.visible = false;
               petUIMC.pen.visible = true;
               petUIMC.follow_btn.visible = false;
               petUIMC.back_btn.visible = false;
               petFoodMC.visible = true;
               PetAllItem[1] = petView.petGoodsArr;
               showPanelData(getPetInfo());
               showFoods(1,1);
               if(petUIMC.BlackSick == 1 || petUIMC.BlackSick == 2 || petUIMC.BlackSick == 3 || petUIMC.Flag == 1)
               {
                  petUIMC.healing_btn.visible = true;
               }
               else if(petUIMC.Flag == 2)
               {
                  petUIMC.revival_btn.visible = true;
               }
               else
               {
                  petUIMC.follow_btn.visible = true;
               }
               break;
            case 1:
               otherMolePetInfo();
               petUIMC.foodback_btn.visible = false;
               petUIMC.food_btn.visible = true;
               petUIMC.pen.visible = true;
               petUIMC.follow_btn.visible = false;
               petUIMC.back_btn.visible = true;
               petFoodMC.visible = false;
               showPetGoods2();
               break;
            case 2:
               showPanelData(getPetInfo());
               petUIMC.look_btn.visible = false;
               petUIMC.feed_btn.visible = true;
               petUIMC.food_btn.visible = true;
               petUIMC.foodback_btn.visible = false;
               petFoodMC.visible = false;
               petUIMC.pen.visible = false;
               petUIMC.follow_btn.visible = false;
               break;
            case 3:
               otherMolePetInfo();
               petUIMC.feed_btn.visible = true;
               petUIMC.pen.visible = false;
               petUIMC.foodback_btn.visible = false;
               petFoodMC.visible = false;
               petUIMC.food_btn.visible = true;
               petUIMC.follow_btn.visible = false;
         }
         PanelMC.PetID = PetID;
         PanelMC.UserID = LocalUserInfo.getUserID();
         BtnPos();
      }
      
      public static function showOtherMolePet(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(petInfoRes.GET_PETINFO_SUCC,showOtherMolePet);
         var obj:Object = e.EventObj.arr[0];
         showPanelData(obj);
      }
      
      public static function otherMolePetInfo() : void
      {
         GV.onlineSocket.addEventListener(petInfoRes.GET_PETINFO_SUCC,showOtherMolePet);
         var petinfo:petInfoReq = new petInfoReq();
         petinfo.sendInfoReq(UserID,PetID);
      }
      
      public static function updatePetInfo() : void
      {
         var i:uint = 0;
         if(Boolean(PetsObj.arr))
         {
            for(i = 0; i < PetsObj.arr.length; i++)
            {
               if(PetsObj.arr[i].SpriteID == PetID)
               {
                  PetsObj.arr[i].Cloth = usedClothID;
                  PetsObj.arr[i].Honor = usedHonorID;
                  break;
               }
            }
         }
      }
      
      public static function getPetInfo() : Object
      {
         var obj:Object = null;
         for(var i:uint = 0; i < PetsObj.arr.length; i++)
         {
            if(PetsObj.arr[i].SpriteID == PetID)
            {
               obj = PetsObj.arr[i];
               break;
            }
         }
         return obj;
      }
      
      public static function showclothtip(e:Event) : void
      {
         var tempPoint:Point = e.currentTarget.parent.localToGlobal(new Point(e.currentTarget.x + 25,e.currentTarget.y - 10));
         GF.showTip(e.currentTarget.itemname,{
            "noDelay":true,
            "x":tempPoint.x,
            "y":tempPoint.y
         });
      }
      
      public static function showhonortip(e:Event) : void
      {
         var tempPoint:Point = e.currentTarget.parent.localToGlobal(new Point(e.currentTarget.x + 25,e.currentTarget.y - 10));
         GF.showTip(e.currentTarget.itemname,{
            "noDelay":true,
            "x":tempPoint.x,
            "y":tempPoint.y
         });
      }
      
      public static function showhealthtip(e:Event) : void
      {
         var namearr:Array = ["健康","生病中，可以使用萬能藥水來治療","已死亡，請在家裡祈禱，使拉姆復活","帕拉森凍傷症，使用水瑩救治藥水或萬能藥水","沸厄燙炎症，使用炎火救治藥水或萬能藥水","皮癢癢過敏症，使用金沙救治藥水或萬能藥水"];
         var itemMC:MovieClip = e.currentTarget as MovieClip;
         var tempPoint:Point = itemMC.parent.localToGlobal(new Point(itemMC.x + 30,itemMC.y + 20));
         GF.showTip(namearr[itemMC.currentFrame - 1],{
            "noDelay":true,
            "x":tempPoint.x,
            "y":tempPoint.y
         });
      }
      
      public static function showPanelData(obj:Object) : void
      {
         presentLvl = 0;
         petUIMC.lamuinfo = obj.lamuinfo;
         petUIMC.name_txt.text = obj.Nick;
         if(Boolean(GF.getPeopleByID(obj.UserID)))
         {
            petUIMC.host_txt.text = GF.getPeopleByID(obj.UserID).nickName;
         }
         else
         {
            petUIMC.host_txt.text = obj.UserID + "";
         }
         var date:Date = new Date(Number(obj.Birthday * 1000));
         petUIMC.birthday_txt.text = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
         petUIMC.health_mc.gotoAndStop(obj.Flag + 1);
         petUIMC.health_mc.addEventListener(MouseEvent.MOUSE_OVER,showhealthtip);
         refreshUIData(obj);
         if(obj.BlackSick > 0)
         {
            petUIMC.health_mc.gotoAndStop(obj.BlackSick + 3);
         }
         petUIMC.SpriteID = obj.SpriteID;
         PetID = obj.SpriteID;
         petUIMC.Level = obj.Level;
         petUIMC.Type = obj.Skill_Type;
         petUIMC.Nick = obj.Nick;
         petUIMC.Color = obj.Color;
         petUIMC.Flag = obj.Flag;
         petUIMC.BlackSick = obj.BlackSick;
         petUIMC.Cloth = obj.Cloth;
         petUIMC.Honor = obj.Honor;
         if(petUIMC.Type < 7 && petUIMC.Level == 101)
         {
            petUIMC.Type = 0;
         }
         if(Boolean(petUIMC.Type) && petUIMC.Level < 5)
         {
            petUIMC.Type = 0;
         }
         if(petUIMC.Type == 7 && petUIMC.Level < 101)
         {
            petUIMC.Level = 4;
            petUIMC.Type = 0;
         }
         petUIMC.pet_mc.gotoAndStop("lv" + petUIMC.Level + "-" + petUIMC.Type);
         petUIMC.pet_ye.gotoAndStop("lv" + petUIMC.Level + "-" + petUIMC.Type);
         GF.setPetColor(petUIMC.pet_mc,obj.Color);
         usedClothID = obj.Cloth;
         oldClothID = usedClothID;
         usedHonorID = obj.Honor;
         oldHonorID = obj.Honor;
         loadCloth(obj.Cloth);
         loadHonor(obj.Honor);
         petUIMC.growth_txt.addEventListener(MouseEvent.MOUSE_OVER,showLvlTip);
         petUIMC.skillLvl_txt.addEventListener(MouseEvent.MOUSE_OVER,showSkillLvlTip);
         getSkillItem(obj);
      }
      
      private static function showLvlTip(e:MouseEvent) : void
      {
         if(petUIMC.Level > 100)
         {
            GF.showTip(lvlArr[5]);
         }
         else
         {
            GF.showTip(lvlArr[petUIMC.Level - 1]);
         }
      }
      
      private static function showSkillLvlTip(e:MouseEvent) : void
      {
         if(petUIMC.Type == 1)
         {
            GF.showTip("霹靂火系 " + presentLvl + " 級");
         }
         else if(petUIMC.Type == 2)
         {
            GF.showTip("神奇水系 " + presentLvl + " 級");
         }
         else if(petUIMC.Type == 4)
         {
            GF.showTip("彈力木系 " + presentLvl + " 級");
         }
         else if(petUIMC.Type == 7)
         {
            GF.showTip("神力超拉 " + presentLvl + " 級");
         }
         else
         {
            GF.showTip("第五階段後開啟");
         }
      }
      
      private static function getSkillItem(obj:Object) : void
      {
         var i:uint = 0;
         var tempArr:Array = new Array();
         var p:LamuInfo = obj.lamuinfo;
         var tempStr:String = "";
         tempStr = "fire";
         for(i = 1; i <= 32; i++)
         {
            if(p.hasSkill_Fire_By_Level(i))
            {
               tempArr.push(tempStr + i);
            }
         }
         tempStr = "water";
         for(i = 1; i <= 32; i++)
         {
            if(p.hasSkill_Water_By_Level(i))
            {
               tempArr.push(tempStr + i);
            }
         }
         tempStr = "wood";
         for(i = 1; i <= 32; i++)
         {
            if(p.hasSkill_Wood_By_Level(i))
            {
               tempArr.push(tempStr + i);
            }
         }
         PetAllItem[5] = tempArr;
      }
      
      public static function loadCloth(itemID:uint) : void
      {
         var layer:int = 0;
         var tempLoader:Loader = null;
         if(petUIMC.cloth_mc.numChildren > 0)
         {
            GC.clearAllChildren(petUIMC.cloth_mc);
         }
         if(itemID != 0)
         {
            layer = int(GoodsInfo.getInfoById(itemID).Layer);
            if(layer < 45 || layer == 75)
            {
               petUIMC.pet_ye.visible = true;
               petUIMC.pet_ye.scaleX = 0.8;
               petUIMC.pet_ye.scaleY = 0.8;
            }
            else
            {
               petUIMC.pet_ye.visible = false;
            }
            tempLoader = new Loader();
            tempLoader.load(VL.getURLRequest("resource/petcloth/swf/cloth/" + itemID + ".swf"));
            petUIMC.cloth_mc.itemname = GoodsInfo.getItemNameByID(itemID);
            petUIMC.cloth_mc.addChild(tempLoader);
            petUIMC.cloth_mc.scaleX = 0.8;
            petUIMC.cloth_mc.scaleY = 0.8;
         }
         else
         {
            petUIMC.pet_ye.visible = true;
            petUIMC.pet_ye.scaleX = 0.8;
            petUIMC.pet_ye.scaleY = 0.8;
         }
         petUIMC.cloth_mc.addEventListener(MouseEvent.CLICK,clothBackToBag);
      }
      
      public static function clothBackToBag(e:MouseEvent) : void
      {
         if(PetType == 0 || PetType == 1)
         {
            if(petUIMC.cloth_mc.numChildren > 0)
            {
               petUIMC.pet_ye.visible = true;
               petUIMC.pet_ye.scaleX = 0.8;
               petUIMC.pet_ye.scaleY = 0.8;
               currentType = 2;
               GC.clearAllChildren(petUIMC.cloth_mc);
               PetAllItem[2].push({
                  "ItemID":usedClothID,
                  "Flag":0,
                  "Count":1
               });
               usedClothID = 0;
            }
            changeClothType(e);
         }
      }
      
      public static function loadHonor(itemID:uint) : void
      {
         var tempLoader:Loader = null;
         if(petUIMC.honor_mc.numChildren > 0)
         {
            GC.clearAllChildren(petUIMC.honor_mc);
         }
         if(itemID != 0)
         {
            tempLoader = new Loader();
            tempLoader.load(VL.getURLRequest("resource/pethonor/icon/" + itemID + ".swf"));
            petUIMC.honor_mc.itemname = GoodsInfo.getItemNameByID(itemID);
            petUIMC.honor_mc.addChild(tempLoader);
            petUIMC.honor_mc.addEventListener(MouseEvent.MOUSE_OVER,showhonortip);
         }
         petUIMC.honor_mc.addEventListener(MouseEvent.CLICK,HonorBackToBag);
      }
      
      public static function HonorBackToBag(e:MouseEvent) : void
      {
         if(PetType == 0 || PetType == 1)
         {
            if(petUIMC.honor_mc.numChildren > 0)
            {
               currentType = 3;
               GC.clearAllChildren(petUIMC.honor_mc);
               trace("honor 放到包中ItemID",usedHonorID);
               PetAllItem[3].push({
                  "ItemID":usedHonorID,
                  "Flag":0,
                  "Count":1
               });
               usedHonorID = 0;
            }
            changeHonorType(e);
         }
      }
      
      public static function refreshSick(obj:Object) : void
      {
         var i:uint = 0;
         if(PetType == 0 || PetType == 2)
         {
            for(i = 0; i < PetsObj.arr.length; i++)
            {
               if(PetsObj.arr[i].SpriteID == obj.SpriteID)
               {
                  PetsObj.arr[i].BlackSick = 0;
                  return;
               }
            }
         }
      }
      
      public static function refreshUIData(obj:Object) : void
      {
         var i:uint = 0;
         var tempUint:uint = 0;
         if(PetType == 0 || PetType == 2)
         {
            for(i = 0; i < PetsObj.arr.length; i++)
            {
               if(PetsObj.arr[i].SpriteID == obj.SpriteID)
               {
                  PetsObj.arr[i].Hungry = obj.Hungry;
                  PetsObj.arr[i].Thirsty = obj.Thirsty;
                  PetsObj.arr[i].Dirty = obj.Dirty;
                  PetsObj.arr[i].Spirit = obj.Spirit;
                  PetsObj.arr[i].Flag = obj.Flag;
                  if(obj.BlackSick != -1)
                  {
                     PetsObj.arr[i].BlackSick = obj.BlackSick;
                  }
               }
            }
         }
         try
         {
            petUIMC.skill_txt.text = "0/40";
            petUIMC.health_mc.gotoAndStop(obj.Flag + 1);
            petUIMC.attr_mc.hungry_txt.text = obj.Hungry + "/100";
            petUIMC.attr_mc.thirsty_txt.text = obj.Thirsty + "/100";
            petUIMC.attr_mc.dirty_txt.text = obj.Dirty + "/100";
            petUIMC.attr_mc.spirit_txt.text = obj.Spirit + "/100";
            if(obj.Level < 4)
            {
               petUIMC.growth_txt.text = String(int(obj.Value / 3600)) + "/" + 24 * lvldataArr[obj.Level - 1];
               tempUint = Math.min(100 * int(obj.Value / 3600) / (24 * lvldataArr[obj.Level - 1]),100);
               changeMaskColor(petUIMC.growth_percent,tempUint);
            }
            else
            {
               petUIMC.growth_txt.text = String(int(obj.Value / 3600)) + "小時";
               changeMaskColor(petUIMC.growth_percent,100);
            }
            changeMaskColor(petUIMC.hungry_percent,obj.Hungry);
            changeMaskColor(petUIMC.thirsty_percent,obj.Thirsty);
            changeMaskColor(petUIMC.dirty_percent,obj.Dirty);
            changeMaskColor(petUIMC.spirit_percent,obj.Spirit);
            petUIMC.skill_txt.visible = false;
            if(obj.Skill_Type != 0)
            {
               petUIMC.skill_txt.visible = true;
               for(i = 1; i < skillLvlDataArr.length; i++)
               {
                  if(obj.Skill_Value <= skillLvlDataArr[i] - 1)
                  {
                     if(i == skillLvlDataArr.length - 1)
                     {
                        petUIMC.skill_txt.text = Math.max(1,i).toString();
                        presentLvl = Math.max(1,i);
                        petUIMC.skillLvl_txt.text = "已達到最高等級";
                        changeMaskColor(petUIMC.skillLvl_percent,100);
                        break;
                     }
                     petUIMC.skill_txt.text = i.toString();
                     presentLvl = i;
                     petUIMC.skillLvl_txt.text = obj.Skill_Value - skillLvlDataArr[i - 1] + "/" + (skillLvlDataArr[i] - skillLvlDataArr[i - 1]);
                     tempUint = Math.min(100 * (obj.Skill_Value - skillLvlDataArr[i - 1]) / (skillLvlDataArr[i] - skillLvlDataArr[i - 1]),100);
                     changeMaskColor(petUIMC.skillLvl_percent,tempUint);
                     break;
                  }
               }
            }
            else
            {
               petUIMC.skillLvl_txt.text = "0/0";
               changeMaskColor(petUIMC.skillLvl_percent,0);
            }
         }
         catch(err:Error)
         {
         }
      }
      
      private static function changeMaskColor(mc:MovieClip, i:uint) : void
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
      
      public static function preGoodPage(e:Event) : void
      {
         if(currentPage > 1)
         {
            --currentPage;
            if(currentType == 1)
            {
               showFoods(currentPage,currentType);
            }
            else if(currentType == 2)
            {
               showCloth(currentPage,currentType);
            }
            else if(currentType == 3)
            {
               showHonor(currentPage,currentType);
            }
            else if(currentType == 4)
            {
               showCertification(currentPage,currentType);
            }
            else if(currentType == 5)
            {
               showSkill(currentPage,currentType);
            }
         }
      }
      
      public static function nextGoodPage(e:Event) : void
      {
         var num:uint = uint(PetAllItem[currentType].length);
         var pagefloat:Number = num / NUM;
         var totalpage:uint = int(pagefloat) == pagefloat ? uint(pagefloat) : uint(int(pagefloat + 1));
         if(currentPage < totalpage)
         {
            ++currentPage;
            if(currentType == 1)
            {
               showFoods(currentPage,currentType);
            }
            else if(currentType == 2)
            {
               showCloth(currentPage,currentType);
            }
            else if(currentType == 3)
            {
               showHonor(currentPage,currentType);
            }
            else if(currentType == 4)
            {
               showCertification(currentPage,currentType);
            }
            else if(currentType == 5)
            {
               showSkill(currentPage,currentType);
            }
         }
      }
      
      private static function onBtnClick(e:MouseEvent) : void
      {
         var p:PeopleManageView = null;
         var name:String = null;
         if(currentType == 1)
         {
            itemInfo = e.target.parent;
            if(itemInfo.Count <= 0)
            {
               return;
            }
            ItemID = itemInfo.ID;
            petView.ItemID = ItemID;
            if(HomeView.ismyhome)
            {
               userFood(e);
            }
            else if(GV.MyInfo_Pet == petUIMC.SpriteID)
            {
               userFood(null);
            }
            else if(MapInfo.currentMapInfo().name != MapInfo.MAPTYPE_HOME)
            {
               if(newHouseView.houseID == LocalUserInfo.getUserID())
               {
                  userFood(null);
               }
               else
               {
                  p = GF.getPeopleByID(LamuInfo(petUIMC.lamuinfo).masterID);
                  name = Boolean(p) ? p.nickName : String(LamuInfo(petUIMC.lamuinfo).masterID);
                  feedAlert = Alert.showAlert(MainManager.getAlertLevel(),"","你是否想使用" + itemInfo.SingleName + "來照料" + name + "的拉姆？",Alert.SELECT_ALERT);
                  feedAlert.addEventListener("CLICK" + 1,feedyes);
                  feedAlert.addEventListener("CLICK" + 2,feedno);
               }
            }
            else
            {
               feedAlert = Alert.showAlert(MainManager.getAlertLevel(),"","你是否想使用" + itemInfo.SingleName + "來照料" + newHouseView.houseName + "的拉姆？",Alert.SELECT_ALERT);
               feedAlert.addEventListener("CLICK" + 1,feedyes);
               feedAlert.addEventListener("CLICK" + 2,feedno);
            }
         }
         else if(currentType == 2)
         {
            userCloth(e);
         }
         else if(currentType == 3)
         {
            userHonor(e);
         }
      }
      
      private static function feedyes(e:Event) : void
      {
         feedAlert.removeEventListener("CLICK" + 1,feedyes);
         feedAlert.removeEventListener("CLICK" + 2,feedno);
         userFood(e);
      }
      
      private static function feedno(e:Event) : void
      {
         feedAlert.removeEventListener("CLICK" + 1,feedyes);
         feedAlert.removeEventListener("CLICK" + 2,feedno);
      }
      
      private static function otherClickSickLahm() : void
      {
         if(!newHouseView.isMyHouse)
         {
            Alert.showAlert(MainManager.getAlertLevel(),"","這隻的拉姆得了黑森林怪病，所以不能餵養！熱心的小摩爾快去告訴它的主人吧！",Alert.IKNOW_ALERT);
            return;
         }
      }
      
      private static function showillness(msg:String, id:*) : void
      {
         Alert.showAlert(MainManager.getAlertLevel(),"",msg,Alert.IKNOW_ALERT);
      }
      
      private static function userFood(e:Event) : void
      {
         if(petUIMC.Flag == 0 && petUIMC.BlackSick == 0)
         {
            if(itemInfo.ID == 180005)
            {
               Alert.showAlert(MainManager.getAlertLevel(),"","目前這隻拉姆" + petUIMC.Nick + "沒生病，不能餵藥哦！",Alert.IKNOW_ALERT);
            }
            else if(itemInfo.ID == 180006)
            {
               Alert.showAlert(MainManager.getAlertLevel(),"","目前這隻拉姆" + petUIMC.Nick + "沒死亡，不能復活哦！",Alert.IKNOW_ALERT);
            }
            else if(itemInfo.ID >= 180050 && itemInfo.ID < 180053)
            {
               Alert.showAlert(MainManager.getAlertLevel(),"","目前這隻拉姆" + petUIMC.Nick + "沒生病，不能餵藥哦！",Alert.IKNOW_ALERT);
            }
            else
            {
               initBuy();
            }
         }
         else if(petUIMC.Flag == 1 || petUIMC.BlackSick != 0)
         {
            if(itemInfo.ID == 180005)
            {
               initBuy();
            }
            else if(itemInfo.ID == 180050 && petUIMC.BlackSick == 1)
            {
               SetCureAllInfo.EatMedicine(LamuInfo(petUIMC.lamuinfo).masterID,PetID,180050);
            }
            else if(itemInfo.ID == 180051 && petUIMC.BlackSick == 2)
            {
               SetCureAllInfo.EatMedicine(LamuInfo(petUIMC.lamuinfo).masterID,PetID,180051);
            }
            else if(itemInfo.ID == 180052 && petUIMC.BlackSick == 3)
            {
               SetCureAllInfo.EatMedicine(LamuInfo(petUIMC.lamuinfo).masterID,PetID,180052);
            }
            else
            {
               Alert.smileAlart("    拉姆生病了，趕緊用“萬能藥水”為它治病吧！",function(e:Event):void
               {
                  if(LocalUserInfo.getYXQ() >= 400)
                  {
                     QueryImpl.getInstance().QueryItem([180005],function(arr:Array):void
                     {
                        if(Boolean(arr[0].count))
                        {
                           closePanel();
                           petLogic.doFeedPet(LamuInfo(petUIMC.lamuinfo).masterID,PetID,180005);
                        }
                        else
                        {
                           Alert.smileAlart("    “萬能藥水”需要耗費400摩爾豆？你現在擁有" + LocalUserInfo.getYXQ() + "摩爾豆，確定使用麼？",function(e:Event):void
                           {
                              new BuyItemReq().buyItems(180005,1);
                              GV.onlineSocket.addEventListener(BuyItemRes.BUY_ITEM_SUCCESS,onBuyItem180005);
                           },AlertType.SURE + "," + AlertType.CANCEL);
                        }
                     });
                  }
                  else
                  {
                     Alert.smileAlart("    “萬能藥水”需要耗費400摩爾豆？你現在擁有" + LocalUserInfo.getYXQ() + "摩爾豆。");
                  }
               },AlertType.SURE + "," + AlertType.CANCEL);
            }
         }
         else if(petUIMC.Flag == 2)
         {
            if(itemInfo.ID == 180005)
            {
               Alert.showAlert(MainManager.getAlertLevel(),"","目前這隻拉姆" + petUIMC.Nick + "死亡了，無法餵藥哦,快點使用復活十字架使他復活吧",Alert.IKNOW_ALERT);
            }
            else if(itemInfo.ID == 180006)
            {
               initBuy();
            }
            else
            {
               Alert.showAlert(MainManager.getAlertLevel(),"","目前這隻拉姆" + petUIMC.Nick + "死亡了，無法餵養哦,快點使用復活十字架使他復活吧",Alert.IKNOW_ALERT);
            }
         }
      }
      
      private static function onBuyItem180005(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(BuyItemRes.BUY_ITEM_SUCCESS,onBuyItem180005);
         closePanel();
         petLogic.doFeedPet(LamuInfo(petUIMC.lamuinfo).masterID,PetID,180005);
      }
      
      private static function initBuy() : void
      {
         if(canEat())
         {
            if(canTool())
            {
               if(HomeView.ismyhome)
               {
                  if(itemInfo.Tool == 1)
                  {
                     GV.onlineSocket.addEventListener("GET_PETFOOD_SUCC",updatePetData);
                     petLogic.doToolPet(PetID,ItemID);
                  }
                  else if(itemInfo.Tool == 2)
                  {
                     petLogic.ChangePetColor(PetID,ItemID,itemInfo.ColorType);
                  }
               }
               else
               {
                  Alert.angryAlart("　　這件物品暫時還無法使用哦！");
               }
            }
            else
            {
               GV.onlineSocket.addEventListener("GET_PETFOOD_SUCC",updatePetData);
               petLogic.doFeedPet(LamuInfo(petUIMC.lamuinfo).masterID,PetID,ItemID);
            }
         }
         else
         {
            Alert.angryAlart("　　這件物品暫時還無法使用哦！");
         }
      }
      
      private static function updatePetData(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("GET_PETFOOD_SUCC",updatePetData);
         var obj:Object = e.EventObj;
         var mc:* = petView.petDic["pet" + (Boolean(obj.UserID) ? obj.UserID : GV.MyInfo_userID) + "_" + PetID] as MovieClip;
         if(Boolean(mc))
         {
            petUIMC.health_mc.gotoAndStop(obj.Flag + 1);
            petUIMC.attr_mc.hungry_txt.text = obj.Hungry + "/100";
            petUIMC.attr_mc.thirsty_txt.text = obj.Thirsty + "/100";
            petUIMC.attr_mc.dirty_txt.text = obj.Dirty + "/100";
            petUIMC.attr_mc.spirit_txt.text = obj.Spirit + "/100";
            petAction(mc,obj.Action);
            refreshUIData(e.EventObj);
         }
         closePanel();
      }
      
      public static function petAction(mc:Object, i:uint) : void
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
      
      private static function canEat() : Boolean
      {
         return itemInfo.Eat.indexOf(petUIMC.Level) >= 0 ? true : false;
      }
      
      private static function canTool() : Boolean
      {
         return itemInfo.Tool >= 1;
      }
      
      private static function userCloth(e:Event) : void
      {
         var iteminfo:Object = null;
         if(PetType == 0 || PetType == 1)
         {
            itemInfo = e.target.parent;
            ItemID = itemInfo.ID;
            iteminfo = GoodsInfo.getInfoById(ItemID);
            if(petUIMC.Level > 1 && petUIMC.Level < 100)
            {
               if(!(ItemID == 1200006 || ItemID == 1200007))
               {
                  if(iteminfo.Owner == 2)
                  {
                     Alert.showAlert(MainManager.getAlertLevel(),"","無法裝扮這件屬於超級拉姆的物品！",Alert.IKNOW_ALERT);
                     return;
                  }
               }
            }
            if(usedClothID == 0)
            {
               delCloth();
            }
            else
            {
               delCloth();
               pushCloth();
            }
            usedClothID = ItemID;
            clearItems();
            loadCloth(usedClothID);
            showCloth(currentPage,currentType);
         }
      }
      
      private static function userHonor(e:Event) : void
      {
         if(PetType == 0 || PetType == 1)
         {
            trace("++++++++++++使用ＦＯuserHonor");
            itemInfo = e.target.parent;
            ItemID = itemInfo.ID;
            if(usedHonorID == 0)
            {
               delHonor();
            }
            else
            {
               delHonor();
               pushHonor();
            }
            usedHonorID = ItemID;
            clearItems();
            loadHonor(usedHonorID);
            showHonor(currentPage,currentType);
         }
         else
         {
            trace("別人的寵物不能使用");
         }
      }
      
      private static function delCloth() : void
      {
         for(var i:uint = 0; i < PetAllItem[2].length; i++)
         {
            if(PetAllItem[2][i].ItemID == ItemID)
            {
               PetAllItem[2].splice(i,1);
            }
         }
      }
      
      private static function delHonor() : void
      {
         for(var i:uint = 0; i < PetAllItem[3].length; i++)
         {
            if(PetAllItem[3][i].ItemID == ItemID)
            {
               PetAllItem[3].splice(i,1);
            }
         }
      }
      
      private static function pushCloth() : void
      {
         PetAllItem[2].push({
            "ItemID":usedClothID,
            "Flag":1,
            "Count":1
         });
      }
      
      private static function pushHonor() : void
      {
         trace("pushHonor usedHonorID",pushHonor);
         PetAllItem[3].push({
            "ItemID":usedHonorID,
            "Flag":1,
            "Count":1
         });
      }
      
      private static function initNotUsed(arr:Array) : void
      {
         for(var i:uint = 0; i < arr.length; )
         {
            arr[i].Flag = 0;
            i++;
         }
      }
      
      private static function closePanel(e:Event = null) : void
      {
         Locked = false;
         if(PetType == 0 || PetType == 1)
         {
            if(oldHonorID != usedHonorID)
            {
               saveHonor();
            }
            else if(oldClothID != usedClothID)
            {
               saveCloth();
            }
            updatePetInfo();
         }
         PanelMC.y = -1000;
         PanelMC.visible = false;
      }
      
      private static function saveClothSucc(e:Event = null) : void
      {
         if(doPetFollowBool)
         {
            doPetFollowNow();
            doPetFollowBool = false;
         }
      }
      
      private static function saveCloth() : void
      {
         GV.onlineSocket.addEventListener(petClothRes.PET_CLOTH_CHANGE_SUCC,saveClothSucc);
         var changedArr:Array = [];
         if(oldClothID == 0)
         {
            trace("之前沒有穿衣服");
            if(usedClothID != 0)
            {
               changedArr = [{
                  "ItemID":usedClothID,
                  "Flag":1
               }];
               oldClothID = usedClothID;
            }
         }
         else if(usedClothID != 0)
         {
            changedArr = [{
               "ItemID":oldClothID,
               "Flag":0
            },{
               "ItemID":usedClothID,
               "Flag":1
            }];
            changedArr = [{
               "ItemID":usedClothID,
               "Flag":1
            }];
            oldClothID = usedClothID;
         }
         else
         {
            changedArr = [{
               "ItemID":oldClothID,
               "Flag":0
            }];
            oldClothID = 0;
         }
         petClothReq.change_cloth(PetID,changedArr);
      }
      
      private static function saveHonorSucc(e:Event) : void
      {
         GV.onlineSocket.removeEventListener(petClothRes.PET_HONOR_CHANGE_SUCC,saveHonorSucc);
         if(oldClothID != usedClothID)
         {
            saveCloth();
         }
         else
         {
            saveClothSucc();
         }
      }
      
      private static function saveHonor() : void
      {
         GV.onlineSocket.addEventListener(petClothRes.PET_HONOR_CHANGE_SUCC,saveHonorSucc);
         var changedArr:Array = [];
         if(oldHonorID == 0)
         {
            trace("之前沒有帶榮譽");
            if(usedHonorID != 0)
            {
               changedArr = [{
                  "ItemID":usedHonorID,
                  "Flag":1
               }];
               oldHonorID = usedHonorID;
            }
         }
         else if(usedHonorID != 0)
         {
            changedArr = [{
               "ItemID":oldHonorID,
               "Flag":0
            },{
               "ItemID":usedHonorID,
               "Flag":1
            }];
            changedArr = [{
               "ItemID":usedHonorID,
               "Flag":1
            }];
            oldHonorID = usedHonorID;
         }
         else
         {
            changedArr = [{
               "ItemID":oldHonorID,
               "Flag":0
            }];
            oldHonorID = 0;
         }
         petClothReq.change_honor(PetID,changedArr);
      }
      
      private static function clearItems() : void
      {
         var temp:Object = null;
         for(var i:uint = 0; i < NUM; i++)
         {
            temp = petFoodMC["I" + i];
            temp.num_txt.text = "";
            temp.gotoAndStop(1);
            temp.btn.removeEventListener(MouseEvent.MOUSE_OVER,onBtnOver);
            temp.btn.removeEventListener(MouseEvent.MOUSE_OUT,onBtnOut);
            temp.btn.removeEventListener(MouseEvent.CLICK,onBtnClick);
            try
            {
               temp.loadimg.removeChildAt(0);
               temp.btn.visible = false;
            }
            catch(err:Error)
            {
            }
         }
      }
      
      private static function onBtnOver(E:MouseEvent) : void
      {
         var itemMC:MovieClip = E.currentTarget.parent as MovieClip;
         itemMC.gotoAndStop(2);
         var indexNum:int = int(itemMC.num);
         var typeStr:String = itemMC.type;
         var tempPoint:Point = itemMC.parent.localToGlobal(new Point(itemMC.x + 25,itemMC.y - 10));
         GF.showTip(itemMC.Name,{
            "noDelay":true,
            "x":tempPoint.x,
            "y":tempPoint.y
         });
      }
      
      private static function onBtnOut(E:MouseEvent) : void
      {
         var foodObj:Object = E.target.parent;
         foodObj.gotoAndStop(1);
         GF.clearTip();
      }
      
      private static function showCloth(pagenum:uint = 1, Type:uint = 1) : void
      {
         var temp:Object = null;
         var tempLoader:Loader = null;
         updatePanelStatus(pagenum,Type);
         var arr:Array = PetAllItem[currentType];
         var totalpage:uint = arr.length % NUM == 0 ? uint(arr.length / NUM) : uint(Math.floor(arr.length / NUM) + 1);
         petFoodMC.page_txt.text = currentPage + "/" + totalpage;
         for(var i:int = (currentPage - 1) * NUM; i < currentPage * NUM; i++)
         {
            temp = petFoodMC["I" + (i - (currentPage - 1) * NUM)];
            if(arr[i] != null)
            {
               temp.ID = arr[i].ItemID;
               temp.Name = GoodsInfo.getItemNameByID(temp.ID);
               temp.Count = arr[i].Count;
               temp.btn.visible = true;
               temp.num_txt.text = "";
               temp.btn.addEventListener(MouseEvent.MOUSE_OVER,onBtnOver);
               temp.btn.addEventListener(MouseEvent.MOUSE_OUT,onBtnOut);
               temp.btn.addEventListener(MouseEvent.CLICK,onBtnClick);
               tempLoader = new Loader();
               trace("-------------loading food icon",arr[i].ItemID);
               tempLoader.load(VL.getURLRequest("resource/petcloth/icon/" + arr[i].ItemID + ".swf"));
               temp.loadimg.addChild(tempLoader);
            }
            else
            {
               temp.btn.enabled = false;
            }
         }
      }
      
      private static function showHonor(pagenum:uint = 1, Type:uint = 1) : void
      {
         var temp:Object = null;
         var tempLoader:Loader = null;
         updatePanelStatus(pagenum,Type);
         var arr:Array = PetAllItem[currentType];
         var totalpage:uint = arr.length % NUM == 0 ? uint(arr.length / NUM) : uint(Math.floor(arr.length / NUM) + 1);
         petFoodMC.page_txt.text = currentPage + "/" + totalpage;
         for(var i:int = (currentPage - 1) * NUM; i < currentPage * NUM; i++)
         {
            temp = petFoodMC["I" + (i - (currentPage - 1) * NUM)];
            if(arr[i] != null)
            {
               temp.ID = arr[i].ItemID;
               temp.Name = GoodsInfo.getItemNameByID(temp.ID);
               temp.Count = arr[i].Count;
               temp.btn.visible = true;
               temp.num_txt.text = "";
               temp.btn.addEventListener(MouseEvent.MOUSE_OVER,onBtnOver);
               temp.btn.addEventListener(MouseEvent.MOUSE_OUT,onBtnOut);
               temp.btn.addEventListener(MouseEvent.CLICK,onBtnClick);
               tempLoader = new Loader();
               trace("-------------loading food icon",arr[i].ItemID);
               tempLoader.load(VL.getURLRequest("resource/pethonor/icon/" + arr[i].ItemID + ".swf"));
               temp.loadimg.addChild(tempLoader);
            }
            else
            {
               temp.btn.enabled = false;
            }
         }
      }
      
      private static function showCertification(pagenum:uint = 1, Type:uint = 1) : void
      {
         var temp:Object = null;
         var tempLoader:Loader = null;
         updatePanelStatus(pagenum,Type);
         var arr:Array = PetAllItem[currentType];
         var totalpage:uint = arr.length % NUM == 0 ? uint(arr.length / NUM) : uint(Math.floor(arr.length / NUM) + 1);
         petFoodMC.page_txt.text = currentPage + "/" + totalpage;
         for(var i:int = (currentPage - 1) * NUM; i < currentPage * NUM; i++)
         {
            temp = petFoodMC["I" + (i - (currentPage - 1) * NUM)];
            if(arr[i] != null)
            {
               temp.ID = arr[i].ItemID;
               temp.Name = GoodsInfo.getItemNameByID(temp.ID);
               temp.Count = arr[i].Count;
               temp.btn.visible = true;
               temp.num_txt.text = "";
               temp.btn.addEventListener(MouseEvent.MOUSE_OVER,onBtnOver);
               temp.btn.addEventListener(MouseEvent.MOUSE_OUT,onBtnOut);
               temp.btn.addEventListener(MouseEvent.CLICK,onBtnClick);
               tempLoader = new Loader();
               trace("-------------loading food icon",arr[i].ItemID);
               tempLoader.load(VL.getURLRequest("resource/pethonor/icon/" + arr[i].ItemID + ".swf"));
               temp.loadimg.addChild(tempLoader);
            }
            else
            {
               temp.btn.enabled = false;
            }
         }
      }
      
      private static function showSkill(pagenum:uint = 1, Type:uint = 1) : void
      {
         var temp:Object = null;
         var tempLoader:Loader = null;
         updatePanelStatus(pagenum,Type);
         var arr:Array = PetAllItem[currentType];
         var totalpage:uint = arr.length % NUM == 0 ? uint(arr.length / NUM) : uint(Math.floor(arr.length / NUM) + 1);
         petFoodMC.page_txt.text = currentPage + "/" + totalpage;
         for(var i:int = (currentPage - 1) * NUM; i < currentPage * NUM; i++)
         {
            temp = petFoodMC["I" + (i - (currentPage - 1) * NUM)];
            if(arr[i] != null)
            {
               temp.Name = getSkillName(arr[i]);
               temp.btn.visible = true;
               temp.num_txt.text = "";
               temp.btn.addEventListener(MouseEvent.MOUSE_OVER,onBtnOver);
               temp.btn.addEventListener(MouseEvent.MOUSE_OUT,onBtnOut);
               temp.btn.addEventListener(MouseEvent.CLICK,onBtnClick);
               tempLoader = new Loader();
               trace("-------------loading food icon",arr[i]);
               tempLoader.load(VL.getURLRequest("resource/petSkill/icon/" + arr[i] + ".swf"));
               temp.loadimg.addChild(tempLoader);
            }
            else
            {
               temp.btn.enabled = false;
            }
         }
      }
      
      private static function getSkillName(Cstr:String = null) : String
      {
         if(Cstr.substr(0,4) == "fire" && Boolean(LamuInfo.fireArr[int(Cstr.substr(Cstr.length - 1,1)) - 1]))
         {
            return LamuInfo.fireArr[int(Cstr.substr(Cstr.length - 1,1)) - 1];
         }
         if(Cstr.substr(0,5) == "water" && Boolean(LamuInfo.waterArr[int(Cstr.substr(Cstr.length - 1,1)) - 1]))
         {
            return LamuInfo.waterArr[int(Cstr.substr(Cstr.length - 1,1)) - 1];
         }
         if(Cstr.substr(0,4) == "wood" && Boolean(LamuInfo.woodArr[int(Cstr.substr(Cstr.length - 1,1)) - 1]))
         {
            return LamuInfo.woodArr[int(Cstr.substr(Cstr.length - 1,1)) - 1];
         }
         return "未知物品";
      }
      
      private static function showFoods(pagenum:uint = 1, Type:uint = 1, bool:Boolean = true) : void
      {
         var temp:Object = null;
         var tempLoader:Loader = null;
         if(bool)
         {
            updatePanelStatus(pagenum,Type);
         }
         else
         {
            currentPage = pagenum;
            currentType = Type;
            clearItems();
         }
         var arr:Array = PetAllItem[currentType];
         var totalpage:uint = arr.length % NUM == 0 ? uint(arr.length / NUM) : uint(Math.floor(arr.length / NUM) + 1);
         petFoodMC.page_txt.text = currentPage + "/" + totalpage;
         for(var i:int = (currentPage - 1) * NUM; i < currentPage * NUM; i++)
         {
            temp = petFoodMC["I" + (i - (currentPage - 1) * NUM)];
            if(arr[i] != null)
            {
               temp.ID = arr[i].ID;
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
               temp.Name = arr[i].Name;
               temp.SingleName = arr[i].Name;
               if(temp.Hungry > 0)
               {
                  temp.Name += "\n" + "飢餓:+" + temp.Hungry;
               }
               else if(temp.Hungry < 0)
               {
                  temp.Name += "\n" + "飢餓:" + temp.Hungry;
               }
               if(temp.Thirsty > 0)
               {
                  temp.Name += "\n" + "口渴:+" + temp.Thirsty;
               }
               else if(temp.Thirsty < 0)
               {
                  temp.Name += "\n" + "口渴:" + temp.Thirsty;
               }
               if(temp.Dirty > 0)
               {
                  temp.Name += "\n" + "清潔:+" + temp.Dirty;
               }
               else if(temp.Dirty < 0)
               {
                  temp.Name += "\n" + "清潔:" + temp.Dirty;
               }
               if(temp.Spirit > 0)
               {
                  temp.Name += "\n" + "心情:+" + temp.Spirit;
               }
               else if(temp.Spirit < 0)
               {
                  temp.Name += "\n" + "心情:" + temp.Spirit;
               }
               temp.btn.visible = true;
               if(temp.Type == 2)
               {
                  temp.num_txt.text = "";
               }
               else
               {
                  temp.num_txt.text = temp.Count;
               }
               temp.btn.addEventListener(MouseEvent.MOUSE_OVER,onBtnOver);
               temp.btn.addEventListener(MouseEvent.MOUSE_OUT,onBtnOut);
               temp.btn.addEventListener(MouseEvent.CLICK,onBtnClick);
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
      
      private static function updatePanelStatus(pagenum:uint = 1, Type:uint = 1) : void
      {
         petFoodMC.type1_mc.gotoAndStop(2);
         petFoodMC.type2_mc.gotoAndStop(2);
         petFoodMC.type3_mc.gotoAndStop(2);
         petFoodMC.type4_mc.gotoAndStop(2);
         petFoodMC.type5_mc.gotoAndStop(2);
         petFoodMC["type" + Type + "_mc"].gotoAndStop(1);
         currentPage = pagenum;
         currentType = Type;
         clearItems();
      }
      
      public static function doPetFollow(e:Event) : void
      {
         doPetFollowBool = true;
         if(oldHonorID != usedHonorID)
         {
            saveHonor();
         }
         else if(oldClothID != usedClothID)
         {
            saveCloth();
         }
         else
         {
            doPetFollowNow();
         }
         PanelMC.y = -1000;
         PanelMC.visible = false;
         updatePetInfo();
      }
      
      public static function revivalFun(e:Event) : void
      {
         GV.onlineSocket.addEventListener(checkItem.chekItem_suc,itemSucHandler);
         checkItem.checkItemHandler(180006);
      }
      
      private static function itemSucHandler(evt:EventTaomee) : void
      {
         var alert:* = undefined;
         GV.onlineSocket.removeEventListener(checkItem.chekItem_suc,itemSucHandler);
         if(evt.EventObj.num <= 0)
         {
            alert = GF.showAlert(MainManager.getAlertLevel(),"    你沒有復活十字架了，趕緊去愛心教堂中找克勞神父領取吧","",Alert.CHANG_ALERT,"go,ok",true,false,"E");
            alert.addEventListener(Alert.CLICK_ + "1",alertApplyHandler);
         }
         else
         {
            itemInfo = {
               "Eat":"2,3,4,5,101,102",
               "Tool":0,
               "SingleName":"復活十字架",
               "ID":180006
            };
            ItemID = itemInfo.ID;
            petView.ItemID = ItemID;
            userFood(null);
         }
      }
      
      private static function alertApplyHandler(e:Event) : void
      {
         e.currentTarget.removeEventListener(Alert.CLICK_ + "1",alertApplyHandler);
         GV.Room_DefaultRoomID = 0;
         LocalUserInfo.setMapID(0);
         GF.switchMap(18);
      }
      
      public static function doPetFollowNow(e:Event = null) : void
      {
         var i:uint = 0;
         if(petUIMC.Level > 1)
         {
            if(petUIMC.Flag == 0 || petUIMC.Flag == 1)
            {
               if(GV.MyInfo_Pet != petUIMC.SpriteID)
               {
                  for(i = 0; i < PetsObj.arr.length; i++)
                  {
                     if(PetsObj.arr[i].SpriteID == petUIMC.SpriteID)
                     {
                        PetsObj.arr.splice(i,1);
                        break;
                     }
                  }
                  GV.MyInfo_PetName = petUIMC.name_txt.text;
                  petLogic.doPetFollow(petUIMC.SpriteID,1);
                  closePetPanel();
               }
            }
            else if(petUIMC.Flag == 2)
            {
               Alert.showAlert(MainManager.getAlertLevel(),"","目前你的拉姆" + petUIMC.Nick + "死亡了，無法跟隨哦！",Alert.IKNOW_ALERT);
            }
         }
      }
      
      public static function closePetPanel(e:* = null) : void
      {
         GF.clearTip();
         Locked = false;
         if(InitBool || PanelMC != null)
         {
            PanelMC.x = -1800;
            PanelMC.visible = false;
         }
      }
      
      public static function drag_start(evt:MouseEvent) : void
      {
         petUIMC.startDrag();
      }
      
      public static function drag_stop(evt:MouseEvent) : void
      {
         petUIMC.stopDrag();
      }
      
      public static function drag_move(evt:MouseEvent) : void
      {
         evt.updateAfterEvent();
      }
      
      private static function removeHandler(e:Event) : void
      {
         closePetPanel();
         GV.onlineSocket.removeEventListener("removeMapEvent",removeHandler);
      }
      
      private static function penClick(event:MouseEvent) : void
      {
         if(event.target.parent.currentFrame == 1)
         {
            event.target.parent.gotoAndStop(2);
            petUIMC.name_txt.type = TextFieldType.INPUT;
            petUIMC.name_txt.border = true;
         }
         else
         {
            event.target.parent.gotoAndStop(1);
            petLogic.modPetNick(petUIMC.SpriteID,petUIMC.name_txt.text);
            petUIMC.name_txt.type = TextFieldType.DYNAMIC;
            petUIMC.name_txt.border = false;
            petUIMC.Nick = petUIMC.name_txt.text;
            GV.MyInfo_PetName = petUIMC.Nick;
         }
      }
   }
}

