package com.module.pet
{
   import com.common.Alert.*;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.manager.UIManager;
   import com.core.objectPool.ObjectPool;
   import com.event.EventTaomee;
   import com.logic.socket.petSocket.adoptPet.petEnterLeaveMapRes;
   import com.module.newHouse.newHouseView;
   import com.module.npc.NPCEvent;
   import com.module.npc.lamu.I_LamuNPC;
   import com.module.npc.lamu.LamuInfo;
   import com.module.npc.npcInstance.LamuNPC;
   import com.view.MapManageView.MapButtonView;
   import com.view.MapManageView.TailButtonView;
   import com.view.mapView.*;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.*;
   import flash.text.*;
   
   public class petInMapView extends MovieClip
   {
      
      public static var PetsPosArr:Array;
      
      public static var totalPetsPosArr:Array;
      
      public static var changePetPosCount:uint;
      
      public static var changePetPosArr:Array;
      
      public static var changePosBool:Boolean;
      
      public static var petloadNum:uint = 0;
      
      public static var petHelloArr:Array = ["你可以加username(userid)為好友讓他來接我哦！我是username(userid)的拉姆拉姆名",""];
      
      public var PetsObj:Object = new Object();
      
      public var onePetObj:Object = new Object();
      
      public var petDefaultPosX:Array = [331,388,225,494];
      
      public var petDefaultPosY:Array = [412,269,342,381];
      
      public var RootMC:*;
      
      public var petUIMC:*;
      
      public var petFoodMC:*;
      
      public var petMC:*;
      
      public var PetsCount:uint = 100;
      
      public var currentPage:uint;
      
      public var currentType:uint;
      
      public var NUM:uint = 12;
      
      public var itemArr:Array;
      
      public var buyFoodAlert:*;
      
      public var itemInfo:*;
      
      public var ItemID:uint;
      
      public var PetID:uint;
      
      public var playingPetMC:Object;
      
      public var loadFoodXMLBool:Boolean;
      
      public var actionGoods:MovieClip;
      
      public var bmd1:BitmapData;
      
      public var bmd2:BitmapData;
      
      public var oldIndex:uint;
      
      public var parentMC:MovieClip;
      
      public function petInMapView(obj:Object)
      {
         super();
         GV.onlineSocket.addEventListener(petEnterLeaveMapRes.GET_ENTER_LEAVE_SUCC,this.getOnePet);
         petInMapLogic.init();
         this.PetsObj = obj;
         this.PetsCount = this.PetsObj.count;
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeHandler);
         if(this.PetsCount > 0)
         {
            this.initPets();
         }
      }
      
      public function getOnePet(e:EventTaomee) : void
      {
         if(e.EventObj.Action == 0)
         {
            this.petInMapBackHome(e.EventObj);
         }
         else
         {
            petloadNum = this.PetsObj.arr.length;
            this.PetsObj.arr.push(e.EventObj);
            this.addPet(this.PetsObj.arr[petloadNum]);
         }
      }
      
      public function petInMapBackHome(obj:Object) : void
      {
         this.removePet(obj.UserID,obj.SpriteID);
      }
      
      public function initPets() : void
      {
         petloadNum = 0;
         this.addPet(this.PetsObj.arr[petloadNum]);
      }
      
      public function removeHandler(e:Event) : void
      {
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeHandler);
         GV.onlineSocket.removeEventListener(petEnterLeaveMapRes.GET_ENTER_LEAVE_SUCC,this.getOnePet);
      }
      
      public function addPet(infoObj:Object) : void
      {
         var pet:* = undefined;
         var pet_hitBtn:TailButtonView = null;
         var f:Function = null;
         var l:Function = null;
         var level:uint = uint(infoObj.Level);
         var lmifo:LamuInfo = new LamuInfo(infoObj);
         lmifo.upData2(infoObj);
         pet = ObjectPool.getObject(LamuNPC);
         pet.setMasterID(infoObj.UserID,lmifo);
         pet.loadNPC(999);
         pet.level = level;
         pet.obj = infoObj;
         pet.SpriteID = infoObj.SpriteID;
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
         petView.petDic["pet" + pet.obj.UserID + "_" + pet.obj.SpriteID] = pet;
         pet.name = "pet" + pet.obj.UserID + "_" + pet.obj.SpriteID;
         I_LamuNPC(pet).boneManaage.lamuName = lmifo.PetName;
         pet.moving = false;
         trace("-------------------0------------------------------------------------------");
         GV.MC_Depth.addChild(pet);
         trace("-----------------1--------------------------------------------------------");
         pet.x = int(Math.random() * 300) + 280;
         pet.y = int(Math.random() * 100) + 300;
         pet_hitBtn = new TailButtonView();
         pet_hitBtn.name = "petBtn_" + lmifo.masterID + "_" + lmifo.PetID;
         MapButtonView.getTarget().addChild(pet_hitBtn);
         pet_hitBtn.x = pet.x;
         pet_hitBtn.y = pet.y;
         pet_hitBtn.buttonMode = true;
         pet_hitBtn.scaleX = pet_hitBtn.scaleY = 0.8;
         pet_hitBtn.fineTailTarget(pet as DisplayObjectContainer);
         pet_hitBtn.addEventListener(MouseEvent.CLICK,this.clickPetHandle);
         f = function(E:NPCEvent):void
         {
            if(E.npc != pet)
            {
               return;
            }
            NPCEvent.removeEventListener(NPCEvent.ON_NPC_LOADED,f);
            E.npc.autoMove = true;
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
         this.loadPetSWF();
      }
      
      public function loadPetSWF() : void
      {
         ++petloadNum;
         if(petloadNum < this.PetsCount)
         {
            this.addPet(this.PetsObj.arr[petloadNum]);
         }
      }
      
      public function closePetPanel(e:* = null) : void
      {
         this.petUIMC.visible = false;
         this.petUIMC.x = -1800;
         this.petUIMC.SpriteID = -1;
         this.petUIMC.close_btn.removeEventListener(MouseEvent.CLICK,this.closePetPanel);
         this.petUIMC.follow_btn.removeEventListener(MouseEvent.CLICK,this.doPetFollow);
         this.petUIMC.attr_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.showAttr);
         this.petUIMC.attr_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.hideAttr);
      }
      
      public function doPetFollow(e:MouseEvent) : void
      {
         trace("//////////////跟隨的ＰＥＴ的ＩＤ：",this.petUIMC.SpriteID,GV.MyInfo_Pet);
         var mole:* = GV.GF.getPeopleByID(LocalUserInfo.getUserID());
         if(this.petUIMC.Level > 1)
         {
            if(this.petUIMC.Flag == 0 || this.petUIMC.Flag == 16 || this.petUIMC.Flag == 32)
            {
               if(GV.MyInfo_Pet != this.petUIMC.SpriteID)
               {
                  GV.MyInfo_PetName = this.petUIMC.name_txt.text;
                  GV.MyInfo_PetObj.Name = this.petUIMC.name_txt.text;
                  petInMapLogic.doPetFollowInMap(LocalUserInfo.getUserID(),this.petUIMC.SpriteID);
                  this.closePetPanel();
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
      }
      
      public function clickPetHandle(e:MouseEvent) : void
      {
         var obj:* = e.currentTarget.tailTarget.obj;
         if(obj.UserID == LocalUserInfo.getUserID())
         {
            this.showPetInfo(e);
         }
         else if(!I_LamuNPC(e.currentTarget.tailTarget).saying)
         {
            this.petSay(e.currentTarget.tailTarget,obj.UserName,obj.UserID,obj.Nick);
         }
      }
      
      public function petSay(mc:Object, username:String, userID:uint, Nick:String) : void
      {
         if(Math.random() > 0.5)
         {
            mc.say("你可以加" + username + "(" + userID + ")" + "為好友讓他來接我哦！");
         }
         else
         {
            mc.say("我是" + username + "(" + userID + ")" + "的拉姆" + Nick);
         }
      }
      
      public function showPetInfo(e:Event) : void
      {
         var petpanel:Class = null;
         trace("---------------------showPetInfo");
         var obj:Object = e.currentTarget.tailTarget.obj;
         if(!MainManager.getAppLevel().getChildByName("pet_panel_mc"))
         {
            petpanel = UIManager.getClass("pet_panel");
            this.petUIMC = new petpanel();
            this.petUIMC.name = "pet_panel_mc";
            MainManager.getAppLevel().addChild(this.petUIMC);
         }
         this.petUIMC.x = 300;
         this.petUIMC.y = 100;
         this.playingPetMC = e.currentTarget.tailTarget;
         this.petUIMC.name_txt.text = obj.Nick;
         this.petUIMC.health_mc.gotoAndStop(1);
         this.petUIMC.hour_txt.text = String(int(obj.Value / 3600));
         this.refreshUIData(obj);
         this.petUIMC.SpriteID = obj.SpriteID;
         this.PetID = obj.SpriteID;
         this.petUIMC.close_btn.addEventListener(MouseEvent.CLICK,this.closePetPanel);
         this.petUIMC.follow_btn.addEventListener(MouseEvent.CLICK,this.doPetFollow);
         this.petUIMC.attr_btn.addEventListener(MouseEvent.MOUSE_OVER,this.showAttr);
         this.petUIMC.attr_btn.addEventListener(MouseEvent.MOUSE_OUT,this.hideAttr);
         this.petUIMC.Level = obj.Level;
         this.petUIMC.Type = obj.Skill_Type;
         this.petUIMC.Nick = obj.Nick;
         this.petUIMC.Color = obj.Color;
         this.petUIMC.Flag = obj.Flag;
         this.petUIMC.pet_mc.gotoAndStop("lv" + this.petUIMC.Level + "-" + this.petUIMC.Type);
         this.petUIMC.pet_ye.gotoAndStop("lv" + this.petUIMC.Level + "-" + this.petUIMC.Type);
         this.setPetColor(this.petUIMC.pet_mc,obj.Color);
      }
      
      public function showAttr(e:* = null) : void
      {
         this.petUIMC.attr_mc.visible = true;
      }
      
      public function hideAttr(e:* = null) : void
      {
         this.petUIMC.attr_mc.visible = false;
      }
      
      public function refreshUIData(obj:Object) : void
      {
         for(var i:uint = 0; i < this.PetsObj.arr.length; i++)
         {
            if(this.PetsObj.arr[i].SpriteID == obj.SpriteID)
            {
               this.PetsObj.arr[i].Hungry = obj.Hungry;
               this.PetsObj.arr[i].Thirsty = obj.Thirsty;
               this.PetsObj.arr[i].Dirty = obj.Dirty;
               this.PetsObj.arr[i].Spirit = obj.Spirit;
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
      
      public function setPetColor(mc:DisplayObject, colorNum:uint) : void
      {
         var _array:Array = GV["petColor_" + colorNum];
         mc.transform.colorTransform = new ColorTransform(_array[0],_array[1],_array[2],_array[3],_array[4],_array[5],_array[6],_array[7]);
      }
      
      public function getpetinfo(petid:uint) : *
      {
         for(var i:uint = 0; i < this.PetsObj.arr.length; i++)
         {
            if(this.PetsObj.arr[i].SpriteID == petid)
            {
               return this.PetsObj.arr[i];
            }
         }
      }
      
      private function changeMaskColor(mc:MovieClip, i:int) : void
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
         var foodObj:MovieClip = E.target.parent as MovieClip;
         foodObj.gotoAndStop(2);
      }
      
      private function onBtnOut(E:MouseEvent) : void
      {
         var foodObj:MovieClip = E.target.parent as MovieClip;
         foodObj.gotoAndStop(1);
      }
      
      private function enoughMoney(goodPrice:Number) : Boolean
      {
         return LocalUserInfo.getYXQ() >= goodPrice;
      }
      
      public function startdrag(e:Event) : void
      {
      }
      
      public function showPetPlay(obj:Object) : void
      {
         var pet:MovieClip = this.getPetByID(obj.UserID,obj.SpriteID);
         trace(pet.name,"action:",obj.Action);
         pet.petBody.gotoAndStop(10 + Number(obj.Action));
      }
      
      public function getPetByID(id:uint, userID:uint = 0) : MovieClip
      {
         if(Boolean(userID))
         {
            return petView.petDic["pet" + userID + "_" + id] as MovieClip;
         }
         return petView.petDic["pet" + newHouseView.houseID + "_" + id] as MovieClip;
      }
      
      public function removePet(userid:uint, petid:uint) : void
      {
         for(var i:uint = 0; i < this.PetsObj.arr.length; i++)
         {
            trace("---Petid:",LocalUserInfo.getUserID() == userid,this.PetsObj.arr[i].SpriteID == petid);
            if(this.PetsObj.arr[i].PET == userid + "_" + petid)
            {
               trace("--------------------------del");
               this.PetsObj.arr.splice(i,1);
               --petloadNum;
               break;
            }
         }
         var pet:MovieClip = this.getPetByID(petid,userid);
         if(Boolean(pet))
         {
            I_LamuNPC(pet).clearClass();
         }
      }
   }
}

