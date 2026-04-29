package com.logic.PeopleCountLogic
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.info.LocalUserInfo;
   import com.core.info.MapInfo;
   import com.core.objectPool.ObjectPool;
   import com.event.EventTaomee;
   import com.global.staticData.MapsConfig;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.MapManageLogic.MapDepthManageLogic;
   import com.logic.MapManageLogic.MapModelLogic;
   import com.logic.socket.leaveMapOrRoom.LeaveMapRes;
   import com.module.newAngel.NewAngelManager;
   import com.module.npc.lamu.LamuInfo;
   import com.mole.app.manager.PeopleManager;
   import com.view.MapManageView.MapManageView;
   import com.view.PeopleView.PeopleManageView;
   import com.view.transfiguration.TransfigurationView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class PeopleCountLogic extends EventDispatcher
   {
      
      public static var peopleList:Array;
      
      public static var AirLayerPList:Array;
      
      public static var FloorLayerPList:Array;
      
      public static var OtherLayerPList:Array;
      
      public static var owner:PeopleCountLogic;
      
      private static var leaveID:String;
      
      private static var addpeopleID:String;
      
      private static var currentLoadNum:int;
      
      private static var totalNum:int;
      
      public static var ONPEOPLEINIT:String = "onPeopleInit";
      
      public static var ONPEOPLEINMAP:String = "onPeopleInMap";
      
      public static var ONPEOPLEOUTMAP:String = "onPeopleOutMap";
      
      public static var onAddChildPeopleOver:String = "onAddChildPeopleOver";
      
      public static var onAddChildManOver:String = "onAddChildManOver";
      
      public static var onLoadPeopleOver:String = "onLoadPeopleOver";
      
      public static var onLoadManOver:String = "onLoadManOver";
      
      public static var PeoPleAction:String = "PeoPleAction";
      
      public static var onAddPeople:String = "addPeople";
      
      public static var onDelPeople:String = "DelPeople";
      
      private var isFirst:Boolean = true;
      
      public function PeopleCountLogic()
      {
         super();
         currentLoadNum = 0;
         GF.getPeopleByID = this.getPeopleByID;
         GF.clearPeoples = this.clearPeoples;
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         BC.addEvent(this,GV.onlineSocket,LeaveMapRes.LEAVE_MAP_ROOM,this.getClearUserData);
         peopleList = new Array();
         AirLayerPList = new Array();
         FloorLayerPList = new Array();
         OtherLayerPList = new Array();
         totalNum = 0;
         owner = this;
      }
      
      public static function getAllPeopleList() : Array
      {
         return peopleList;
      }
      
      public static function checkAllPeopleByFun(fun:Function) : void
      {
         var arr:Array = getAllPeopleList();
         if(Boolean(arr))
         {
            arr.every(function(o:Object, index:int, arr:Array):Boolean
            {
               fun(o.Instance);
               return true;
            });
         }
      }
      
      public function getClearUserData(evt:*) : void
      {
         var obj:Object = new Object();
         obj.type = evt.EventObj.type;
         obj.data = evt.EventObj.data;
         this.changeOnlinePeople(obj);
      }
      
      public function changeOnlinePeople(E:*) : void
      {
         var tempTimer:Timer = null;
         var i:uint = 0;
         var temp1_obj:Object = null;
         var tempMC:MovieClip = null;
         var temp2_obj:Object = null;
         var j:int = 0;
         var array:Array = E.data;
         if(E.type == 1 && array != null)
         {
            peopleList = new Array();
            PeopleCountLogic.FloorLayerPList = new Array();
            for(i = 0; i < array.length; i++)
            {
               this.addPeople(array[i]);
            }
            currentLoadNum = array.length;
            this.onOnePeopleLoaded();
            tempTimer = new Timer(200,1);
            BC.addEvent(this,tempTimer,TimerEvent.TIMER_COMPLETE,this.initPeopleStatus);
            tempTimer.start();
            GV.OnLineArray = E.data;
            MapDepthManageLogic.setAllPeopleDepth();
            dispatchEvent(new Event(onAddChildPeopleOver));
            GV.onlineSocket.dispatchEvent(new EventTaomee(ONPEOPLEINIT,array));
         }
         else if(E.type == 2)
         {
            if(!peopleList)
            {
               return;
            }
            temp1_obj = array[0];
            this.addPeople(temp1_obj);
            GV.OnLineArray.push(temp1_obj);
            tempMC = GF.getPeopleByID(temp1_obj.UserID);
            if(Boolean(tempMC))
            {
               tempMC.checkNewPeople();
            }
            GV.onlineSocket.dispatchEvent(new EventTaomee(ONPEOPLEINMAP,tempMC));
         }
         else if(E.type == 3)
         {
            if(!peopleList)
            {
               return;
            }
            temp2_obj = array[0];
            leaveID = temp2_obj.UserID;
            peopleList.every(this.deletePeople);
            for(j = 0; j < GV.OnLineArray.length; j++)
            {
               if(GV.OnLineArray[j].UserID == temp2_obj.UserID)
               {
                  GV.OnLineArray.splice(j,1);
                  break;
               }
            }
            for(j = 0; j < FloorLayerPList.length; j++)
            {
               if(FloorLayerPList[j].ID == temp2_obj.UserID)
               {
                  FloorLayerPList.splice(j,1);
                  break;
               }
            }
            dispatchEvent(new EventTaomee(ONPEOPLEOUTMAP,GF.getPeopleByID(temp2_obj.UserID)));
            GV.onlineSocket.dispatchEvent(new EventTaomee(ONPEOPLEOUTMAP,temp2_obj.UserID));
         }
         totalNum = peopleList.length;
         try
         {
            this.refurbishTouchPeople();
         }
         catch(e:*)
         {
         }
      }
      
      private function deletePeople(element:*, index:int, arr:Array) : Boolean
      {
         var peopleMC:MovieClip = null;
         var bool:Boolean = element.ID != leaveID;
         if(!bool)
         {
            dispatchEvent(new EventTaomee("DelPeople",{
               "user_id":element.ID,
               "user_mc":element.Instance
            }));
            peopleMC = element.Instance;
            peopleMC["clearEvents"]();
            peopleMC.parent.removeChild(peopleMC);
            arr.splice(index,1);
            if(currentLoadNum > 0)
            {
               --currentLoadNum;
            }
         }
         return bool;
      }
      
      private function addPeople(obj:Object) : void
      {
         var mc:PeopleManageView = null;
         var p:PeopleManageView = null;
         if(obj.UserID != GV.MyInfo_userID)
         {
            if(Boolean(MapsConfig.MapsInfo[obj.MapID]) && Boolean(MapsConfig.MapsInfo[obj.MapID].isNewUserMap))
            {
               return;
            }
         }
         if(MapManageView.inst.mapLevel.depthLevel == null)
         {
            return;
         }
         p = MapManageView.inst.mapLevel.depthLevel.getChildByName("Body_" + obj.UserID) as PeopleManageView;
         if(p == null && !GV.isSwitchMap)
         {
            if(!ObjectPool.getObjectCount(PeopleManageView))
            {
               mc = new PeopleManageView();
               mc.canFly = obj.Can_Fly;
               mc.isDynamic = 1;
               mc.nickName = obj.Nick;
               mc.gender = obj.gender;
               mc.address = "0";
               mc.Family = obj.Color;
               mc.id = obj.UserID;
               mc.name = "Body_" + obj.UserID;
               mc.Vip = obj.Vip;
               mc.Status = obj.Status;
               mc.PosX = obj.PosX;
               mc.PosY = obj.PosY;
               mc.MapID = obj.MapID;
               mc.ItemCount = obj.ItemCount;
               mc.roleType = obj.roleType;
               mc.clothsArray = obj.clothArry;
               mc.x = mc.PosX;
               mc.y = mc.PosY;
               mc.Direction = obj.Direction;
               mc.Action = obj.Action;
               mc.Action2 = obj.Action2;
               mc.Activity = obj.Activity;
               obj.Activity.position = 0;
               mc.fireCup_teamNum = obj.Activity.readUnsignedInt();
               obj.Activity.position = 0;
               mc.PetID = obj.PetID;
               mc.PetColor = obj.PetColor;
               mc.Petlevel = obj.Petlevel;
               mc.PetCloth = mc.Pet_cloth = obj.Pet_cloth;
               mc.PetHonor = obj.Pet_honor;
               mc.PetSick = obj.PetSick;
               mc.layer = "FloorLayer";
               mc.PetSkill = obj.Reserved1;
               mc.changeBody = 0;
               MapModelLogic.ManageLever.addChild(mc);
               peopleList.push({
                  "ID":mc.id,
                  "Instance":mc
               });
               FloorLayerPList.push({
                  "ID":mc.id,
                  "Instance":mc
               });
               if(mc.id == LocalUserInfo.getUserID())
               {
                  NewAngelManager.instance.followNewAngelID = obj.angelIndex;
                  LocalUserInfo.setFireCup_teamNum(mc.fireCup_teamNum);
                  if(TransfigurationView.buckerNum == 1)
                  {
                     mc.Action = 10020;
                  }
                  mc.hasLamu = obj.PetID > 0;
                  if(mc.hasLamu)
                  {
                     if(Boolean(LocalUserInfo.lamuinfo))
                     {
                        LocalUserInfo.lamuinfo.upData(obj);
                        mc.lamuinfo = LocalUserInfo.lamuinfo;
                     }
                     else
                     {
                        mc.lamuinfo = new LamuInfo(obj);
                        LocalUserInfo.lamuinfo = mc.lamuinfo;
                     }
                  }
                  GV.petColor = obj.PetColor;
                  LocalUserInfo.setClothItem(mc.clothsArray);
                  GV.MAN_PEOPLE = mc;
                  GV.MAN_PEOPLE.avatarMC.shadow_mc.gotoAndStop(5);
                  mc.visible = true;
                  dispatchEvent(new Event(onAddChildManOver));
                  MoveTo.addMouseEventToStage();
                  try
                  {
                     switch(GV.MapInfo_mapID)
                     {
                        case 21:
                           GV.onlineClass.walking(510,310,GV.MAN_PEOPLE.id);
                           mc.x = 510;
                           mc.y = 310;
                     }
                  }
                  catch(E:*)
                  {
                  }
               }
               else
               {
                  mc.hasLamu = obj.PetID > 0;
                  if(mc.hasLamu)
                  {
                     mc.lamuinfo = new LamuInfo(obj);
                  }
                  if(LocalUserInfo.getIsHideOtherMole())
                  {
                     mc.visible = false;
                     LocalUserInfo.setIsHideOtherMole(true,mc);
                  }
               }
               this.ParsePeopleInfo(mc,obj);
            }
            else
            {
               mc = ObjectPool.getObject(PeopleManageView);
               mc.canFly = obj.Can_Fly;
               mc.isDynamic = 1;
               mc.updateProperty();
               mc.nickName = obj.Nick;
               mc.gender = obj.gender;
               mc.address = "0";
               mc.Family = obj.Color;
               mc.id = obj.UserID;
               mc.name = "Body_" + obj.UserID;
               mc.Vip = obj.Vip;
               mc.Status = obj.Status;
               mc.PosX = obj.PosX;
               mc.PosY = obj.PosY;
               mc.MapID = obj.MapID;
               mc.ItemCount = obj.ItemCount;
               mc.roleType = obj.roleType;
               mc.clothsArray = obj.clothArry;
               mc.x = mc.PosX;
               mc.y = mc.PosY;
               mc.Direction = obj.Direction;
               mc.Action = obj.Action;
               mc.Action2 = obj.Action2;
               mc.Activity = obj.Activity;
               obj.Activity.position = 0;
               mc.fireCup_teamNum = obj.Activity.readUnsignedInt();
               obj.Activity.position = 0;
               mc.PetID = obj.PetID;
               mc.PetColor = obj.PetColor;
               mc.Petlevel = obj.Petlevel;
               mc.PetCloth = mc.Pet_cloth = obj.Pet_cloth;
               mc.PetHonor = obj.Pet_honor;
               mc.PetSick = obj.PetSick;
               mc.layer = "FloorLayer";
               mc.PetSkill = obj.Reserved1;
               mc.changeBody = 0;
               MapModelLogic.ManageLever.addChild(mc);
               peopleList.push({
                  "ID":mc.id,
                  "Instance":mc
               });
               FloorLayerPList.push({
                  "ID":mc.id,
                  "Instance":mc
               });
               if(mc.id == LocalUserInfo.getUserID())
               {
                  if(TransfigurationView.buckerNum == 1)
                  {
                     mc.Action = 10020;
                  }
                  else if(TransfigurationView.buckerNum == 2)
                  {
                     mc.Action = 17027;
                  }
                  mc.hasLamu = obj.PetID > 0;
                  if(mc.hasLamu)
                  {
                     if(Boolean(LocalUserInfo.lamuinfo))
                     {
                        LocalUserInfo.lamuinfo.upData(obj);
                        mc.lamuinfo = LocalUserInfo.lamuinfo;
                     }
                     else
                     {
                        mc.lamuinfo = new LamuInfo(obj);
                        LocalUserInfo.lamuinfo = mc.lamuinfo;
                     }
                  }
                  GV.petColor = obj.PetColor;
                  LocalUserInfo.setClothItem(mc.clothsArray);
                  GV.MAN_PEOPLE = mc;
                  GV.MAN_PEOPLE.avatarMC.shadow_mc.gotoAndStop(5);
                  mc.visible = true;
                  dispatchEvent(new Event(onAddChildManOver));
                  MoveTo.addMouseEventToStage();
                  try
                  {
                     switch(GV.MapInfo_mapID)
                     {
                        case 21:
                           GV.onlineClass.walking(510,310,GV.MAN_PEOPLE.id);
                           mc.x = 510;
                           mc.y = 310;
                     }
                  }
                  catch(E:*)
                  {
                  }
               }
               else
               {
                  mc.hasLamu = obj.PetID > 0;
                  if(mc.hasLamu)
                  {
                     mc.lamuinfo = new LamuInfo(obj);
                  }
                  if(LocalUserInfo.getIsHideOtherMole())
                  {
                     mc.visible = false;
                     LocalUserInfo.setIsHideOtherMole(true,mc);
                  }
               }
               this.ParsePeopleInfo(mc,obj);
            }
            dispatchEvent(new EventTaomee("addPeople",{
               "user_id":mc.id,
               "user_mc":mc
            }));
            if(PeopleManager.isHideMount)
            {
               mc.hideMount();
            }
         }
      }
      
      private function initPeopleStatus(E:TimerEvent) : void
      {
         var item:* = undefined;
         BC.removeEvent(this,E.target,TimerEvent.TIMER_COMPLETE,this.initPeopleStatus);
         E.target.stop();
         for each(item in peopleList)
         {
            try
            {
               if(item.Instance.checkNewPeopleTimer == null)
               {
                  item.Instance.isNewPeople = false;
               }
            }
            catch(E:TypeError)
            {
            }
         }
      }
      
      private function onOnePeopleLoaded(E:* = null) : void
      {
         if(Boolean(E) && E.EventObj.target == GV.MAN_PEOPLE)
         {
            BC.removeEvent(this,E.target);
            dispatchEvent(new Event(onLoadManOver));
         }
         else
         {
            dispatchEvent(new Event(onLoadManOver));
         }
         if(currentLoadNum == totalNum)
         {
            if(this.isFirst)
            {
               this.isFirst = false;
               this.onAllPeopleLoaded();
            }
         }
      }
      
      private function onAllPeopleLoaded() : void
      {
         dispatchEvent(new Event(onLoadPeopleOver));
      }
      
      private function getPeopleByID(id:*) : MovieClip
      {
         var item:Object = null;
         var bool:Boolean = false;
         for each(item in peopleList)
         {
            bool = id == item.ID;
            if(bool)
            {
               break;
            }
         }
         if(bool)
         {
            return item.Instance;
         }
         return null;
      }
      
      public function clearPeoples(all:Boolean = true) : void
      {
         var tempitem:* = undefined;
         var item:* = undefined;
         if(all)
         {
            for each(tempitem in peopleList)
            {
               item = tempitem.Instance;
               item["clearEvents"]();
               if(Boolean(item.parent))
               {
                  item.parent.removeChild(item);
               }
            }
            peopleList = new Array();
            FloorLayerPList = new Array();
            currentLoadNum = 0;
         }
         else
         {
            for each(tempitem in peopleList)
            {
               item = tempitem.Instance;
               if(item != GV.MAN_PEOPLE)
               {
                  item["clearEvents"]();
                  if(Boolean(item.parent))
                  {
                     item.parent.removeChild(item);
                  }
               }
            }
            peopleList = new Array();
            FloorLayerPList = new Array();
            currentLoadNum = 0;
         }
      }
      
      private function getAllPeoplesPox(E:*) : void
      {
         var tempitem:* = undefined;
         var mc:MovieClip = null;
         var tempList:Array = E.EventObj.arr;
         for each(tempitem in tempList)
         {
            if(tempitem.id != LocalUserInfo.getUserID())
            {
               mc = this.getPeopleByID(tempitem.id);
               if(mc != null)
               {
                  mc.x = tempitem.x;
                  mc.y = tempitem.y;
               }
            }
         }
         MapDepthManageLogic.setAllPeopleDepth();
      }
      
      public function setTimeout_getAllUserStutas(E:*) : void
      {
         MapDepthManageLogic.setAllPeopleDepth();
      }
      
      private function refurbishTouchPeople() : void
      {
         var item:* = undefined;
         GV.peopleTouchArray = new Array();
         for each(item in peopleList)
         {
            GV.peopleTouchArray.push(item.Instance);
         }
      }
      
      private function removeEventHandler(evt:EventTaomee) : void
      {
         BC.removeEvent(this);
         GV.peopleTouchArray = null;
         peopleList = null;
         owner = null;
      }
      
      private function ParsePeopleInfo(mc:MovieClip, obj:Object) : void
      {
         var driveId:int = 0;
         var snowMC:* = mc.getChildByName("snowGameMc");
         if(Boolean(snowMC))
         {
            GC.clearAll(snowMC);
         }
         if(MapInfo.getMapInfo(obj.MapID).digTreasureId >= 0)
         {
            if(obj.digTreasureLvl < 10)
            {
               mc.getVisualize(mc,1,17023);
            }
            else if(obj.digTreasureLvl >= 10 && obj.digTreasureLvl < 20)
            {
               mc.getVisualize(mc,1,17024);
            }
            else
            {
               mc.getVisualize(mc,1,17025);
            }
            driveId = int(obj.dragonInfo.ItemID);
            if(driveId > 0 && GoodsInfo.getInfoById(driveId).Type == 1)
            {
               mc.hasDragon = driveId > 0;
               if(Boolean(mc.hasDragon))
               {
                  mc.addDragon(obj.dragonInfo);
               }
            }
         }
         else if(obj.superGuide == 1)
         {
            mc.getVisualize(mc,1,17027);
         }
         else if(LocalUserInfo.getMapType() == 34)
         {
            mc.getVisualize(mc,1,17026);
            mc.hasPig = obj.hasPig;
            if(Boolean(mc.hasPig))
            {
               mc.PigFollow(obj.pigObj);
            }
         }
         else
         {
            mc.hasDragon = obj.dragonInfo.ItemID > 0;
            mc.hasCar = obj.hasCar;
            mc.hasAnimal = obj.hasAnimal;
            mc.hasAngel = obj.hasAngel;
            mc.hasPig = obj.hasPig;
            if(Boolean(mc.hasDragon))
            {
               mc.addDragon(obj.dragonInfo);
            }
            if(Boolean(mc.hasCar))
            {
               mc.addCar(obj.carObj);
            }
            if(Boolean(mc.hasAnimal))
            {
               mc.addAnimalOrUpDate(obj.animalObj);
            }
            if(Boolean(mc.hasAngel))
            {
               if(GoodsInfo.getType(obj.angelId) == 30)
               {
                  mc.AngelFollow(obj.angelId);
               }
               else if(GoodsInfo.getType(obj.angelId) == 41)
               {
                  if(mc.followNewAngelID != undefined)
                  {
                     mc.NewAngelFollow(obj.angelId,mc.followNewAngelID);
                  }
                  else
                  {
                     mc.NewAngelFollow(obj.angelId,obj.angelIndex);
                  }
               }
            }
            if(Boolean(mc.hasPig))
            {
               mc.PigFollow(obj.pigObj);
            }
            if(mc.Action > 100)
            {
               mc.getVisualize(mc,3,mc.Action);
            }
            else
            {
               mc.getVisualize(mc,1);
            }
         }
      }
   }
}

