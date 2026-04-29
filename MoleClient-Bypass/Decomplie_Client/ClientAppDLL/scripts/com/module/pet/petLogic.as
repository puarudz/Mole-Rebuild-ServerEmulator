package com.module.pet
{
   import com.common.Alert.*;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.JobLogic.PetJobLogic;
   import com.logic.socket.cure.GetCureAllInfo;
   import com.logic.socket.petSocket.adoptPet.*;
   import com.module.house.floorViewStatic;
   import com.view.PeopleView.PeopleManageView;
   import flash.events.Event;
   
   public class petLogic
   {
      
      public static var petinforeq:petInfoReq;
      
      public static var petfoodreq:petFoodReq;
      
      public static var pettoolreq:petToolReq;
      
      public static var petColorreq:petChangeColorReq;
      
      public static var petfollowreq:petFollowReq;
      
      public static var petnickreq:modPetNickReq;
      
      public static var petposreq:petPosReq;
      
      public static var petplayreq:petPlayReq;
      
      public static var petview:petView;
      
      public static var isDispatch:Boolean;
      
      public static var IS_SUPER_PET:String = "IS_SUPER_PET";
      
      public static var IS_SUPER_PET_SUCCESS:String = "is_super_pet_success";
      
      public function petLogic()
      {
         super();
      }
      
      public static function init() : void
      {
         petinforeq = new petInfoReq();
         GV.onlineSocket.addEventListener(petInfoRes.GET_PETINFO_SUCC,showAllPet);
         if(LocalUserInfo.getMapID() != 0)
         {
            petinforeq.sendInfoReq(LocalUserInfo.getMapID(),0);
         }
         GV.onlineSocket.addEventListener(GetCureAllInfo.BACK_EAT_MEDICINE,EatMedicineSucc);
         GV.onlineSocket.addEventListener("GET_PETPLAY_SUCC",showPetPlay);
         GV.onlineSocket.addEventListener("GET_PETFOOD_SUCC",feedPetSucc);
         GV.onlineSocket.addEventListener("GET_PETFOLLOW_SUCC",petFollowSucc);
         GV.onlineSocket.addEventListener("removeMapEvent",removeHandler);
         GV.onlineSocket.addEventListener(petDead.PET_DEAD,dopetDead);
         GV.onlineSocket.addEventListener(petChangeColorRes.CHANGE_PET_COLOR_SUCC,petChangeColorSucc);
      }
      
      public static function removeHandler(e:Event) : void
      {
         petview = null;
         GV.onlineSocket.removeEventListener(GetCureAllInfo.BACK_EAT_MEDICINE,EatMedicineSucc);
         GV.onlineSocket.removeEventListener(petChangeColorRes.CHANGE_PET_COLOR_SUCC,petChangeColorSucc);
         GV.onlineSocket.removeEventListener(petDead.PET_DEAD,dopetDead);
         GV.onlineSocket.removeEventListener("removeMapEvent",removeHandler);
         GV.onlineSocket.removeEventListener(petInfoRes.GET_PETINFO_SUCC,showAllPet);
         GV.onlineSocket.removeEventListener("GET_PETPLAY_SUCC",showPetPlay);
         GV.onlineSocket.removeEventListener("GET_PETFOOD_SUCC",feedPetSucc);
         GV.onlineSocket.removeEventListener("GET_PETFOLLOW_SUCC",petFollowSucc);
      }
      
      public static function dopetDead(e:EventTaomee) : void
      {
         Alert.showAlert(MainManager.getAppLevel(),"","你的拉姆" + e.EventObj.Nick + "已經永遠離你而去，看來你不是一個合格的好主人哦！",Alert.IKNOW_ALERT);
      }
      
      public static function showAllPet(e:EventTaomee) : void
      {
         if(e.EventObj.count > 0)
         {
            if(!petview)
            {
               petview = new petView(e.EventObj);
            }
            else if(e.EventObj.UserID == LocalUserInfo.getUserID())
            {
               if(e.EventObj.arr[0].SpriteID != GV.MyInfo_PetObj.SpriteID)
               {
                  petview.loadOnePetSWF(e.EventObj.arr[0]);
               }
            }
         }
         else
         {
            petview = new petView(e.EventObj);
         }
      }
      
      public static function petReq(petid:uint) : void
      {
         petinforeq.sendInfoReq(LocalUserInfo.getMapID(),petid);
      }
      
      public static function showOnePet(e:EventTaomee) : void
      {
         if(e.EventObj.count > 0)
         {
            petview.loadOnePetSWF(e.EventObj.arr[0]);
         }
      }
      
      public static function doFeedPet(userid:uint, petid:uint, itemid:uint) : void
      {
         petfoodreq = new petFoodReq();
         petfoodreq.sendFoodReq(userid,petid,itemid);
      }
      
      public static function doToolPet(petid:uint, itemid:uint) : void
      {
         pettoolreq = new petToolReq();
         pettoolreq.sendToolReq(petid,itemid);
      }
      
      public static function ChangePetColor(petid:uint, itemid:uint, color:uint) : void
      {
         petColorreq = new petChangeColorReq();
         petColorreq.sendReq(petid,itemid,color);
      }
      
      public static function petChangeColorSucc(e:EventTaomee) : void
      {
         trace("--------------變色ＯＫ");
         petview.ChangeThePetColor(e.EventObj);
      }
      
      public static function EatMedicineSucc(e:EventTaomee) : void
      {
         petPanel.refreshSick(e.EventObj);
         petview.updatePetData(e.EventObj);
      }
      
      public static function feedPetSucc(e:EventTaomee) : void
      {
         petview.updatePetData(e.EventObj);
      }
      
      public static function doPetFollow(petid:uint, status:uint) : void
      {
         if(Boolean(status))
         {
         }
         petfollowreq = new petFollowReq();
         GV.onlineSocket.addEventListener("GET_PETFOLLOW_SUCC",petFollowSucc);
         petfollowreq.sendFollowReq(petid,status);
      }
      
      public static function petFollowSucc(e:EventTaomee) : void
      {
         trace("------petFollowSucc------");
         var obj:Object = e.EventObj;
         var mole:* = GV.GF.getPeopleByID(obj.UserID);
         if(LocalUserInfo.getUserID() == obj.UserID)
         {
            trace("我帶自己家的寵物在身上(我放回我家的寵物)");
            dopetFollowOrBack(obj,mole);
            updateGVPetInfo(obj);
            if(obj.Status == 0)
            {
               GV.MyInfo_PetObj = new Object();
               GV.MyInfo_Pet = 0;
            }
            GV.PetJobLogics.chartNowPetClass(mole.PetID);
            GV.PetJobLogics.addEventListener(PetJobLogic.CHARTONEALLINFO,getPetJob);
         }
         else
         {
            trace("我看見這房子的主人帶他的寵物在身上");
            dopetFollowOrBack(obj,mole);
         }
      }
      
      public static function updateGVPetInfo(obj:Object) : void
      {
         GV.MyInfo_Pet = obj.SpriteID;
         GV.MyInfo_PetObj.SpriteID = obj.SpriteID;
         GV.MyInfo_PetObj.Level = obj.Level;
         GV.MyInfo_PetObj.Color = obj.Color;
         GV.MyInfo_PetObj.Status = obj.Status;
         GV.MyInfo_PetObj.Hungry = obj.Hungry;
         GV.MyInfo_PetObj.Thirsty = obj.Thirsty;
         GV.MyInfo_PetObj.Dirty = obj.Dirty;
         GV.MyInfo_PetObj.Spirit = obj.Spirit;
         GV.MyInfo_PetObj.Skill = obj.Skill;
         GV.MyInfo_PetObj.Cloth = obj.Cloth;
         GV.MyInfo_PetObj.Honor = obj.Honor;
         GV.MyInfo_PetObj.Name = obj.Nick;
      }
      
      public static function dopetFollowOrBack(obj:Object, mole:Object) : void
      {
         var moleObj:Object = null;
         if(Boolean(obj.Status))
         {
            petview.removePet(obj.SpriteID);
            if(mole.avatarClass.avatarMC.pet_mc.numChildren > 0)
            {
               showBackPet(mole.PetID);
               mole.backPet();
            }
            moleObj = GV.GF.getPeopleObj(obj.UserID);
            moleObj.PetID = obj.SpriteID;
            moleObj.PetColor = obj.Color;
            moleObj.Petlevel = obj.Level;
            mole.PetID = obj.SpriteID;
            mole.PetColor = obj.Color;
            mole.Petlevel = obj.Level;
            mole.PetSkill = obj.Skill;
            mole.PetCloth = obj.Cloth;
            mole.PetHonor = obj.Honor;
            mole.PetObj = obj;
            mole.addPet();
         }
      }
      
      public static function getPetJob(e:EventTaomee) : void
      {
         GV.MyInfo_PetObj.Job = e.EventObj.obj.Arr;
      }
      
      public static function PetPlayWithGood(good:*) : void
      {
         var mole:* = GV.GF.getPeopleByID(LocalUserInfo.getUserID());
         mole.backPet();
      }
      
      public static function backPetBeforeFollow(mole:*, obj:Object) : void
      {
         mole.backPet();
         var moleObj:Object = GV.GF.getPeopleObj(obj.UserID);
         moleObj.PetID = 0;
         if(LocalUserInfo.getMapID() == obj.UserID)
         {
            showBackPet(obj.SpriteID);
         }
         if(obj.UserID == LocalUserInfo.getUserID())
         {
            GV.MyInfo_Pet = 0;
         }
      }
      
      public static function showBackPet(id:uint) : void
      {
         petReq(id);
      }
      
      public static function modPetNick(petid:uint, nick:String) : void
      {
         petnickreq = new modPetNickReq();
         petnickreq.sendPetNick(petid,nick);
         GV.onlineSocket.addEventListener("MOD_PET_NICK",petNickSucc);
      }
      
      public static function petNickSucc(e:Event) : void
      {
      }
      
      public static function changePetPos() : void
      {
         if(petView.changePosBool)
         {
            petposreq = new petPosReq();
            petposreq.sendPosReq(petView.changePetPosCount,petView.changePetPosArr);
            GV.onlineSocket.addEventListener("SAVE_PETPOS_SUCC",petPosSucc);
         }
         else
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee("allGoodsLoaded",{"Tile":floorViewStatic.map}));
         }
      }
      
      public static function petPosSucc(e:Event) : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("allGoodsLoaded",{"Tile":floorViewStatic.map}));
         GV.onlineSocket.removeEventListener("SAVE_PETPOS_SUCC",petPosSucc);
      }
      
      public static function molePlayPet(userid:uint, petid:uint) : void
      {
         petplayreq = new petPlayReq();
         petplayreq.sendPlayReq(userid,petid);
      }
      
      public static function showPetPlay(e:EventTaomee) : void
      {
         petview.showPetPlay(e.EventObj);
      }
      
      public static function updatePetJob(jobid:uint, status:uint) : void
      {
         for(var i:uint = 0; i < GV.MyInfo_PetObj.Job.length; i++)
         {
            if(GV.MyInfo_PetObj.Job[i].ClassID == jobid)
            {
               GV.MyInfo_PetObj.Job[i].Status = status;
            }
         }
      }
      
      public static function PetCan(jobID:int, PetLevel:int = 1) : Boolean
      {
         var PetObj:Object = null;
         var len:uint = 0;
         var i:uint = 0;
         if(havePetFollow())
         {
            if(GF.getPeopleByID(GV.MyInfo_userID).Petlevel == 101)
            {
               return true;
            }
            if(jobID > 100)
            {
               return PetMagicCan(jobID);
            }
            if(GF.getPeopleObj(GV.MyInfo_userID).Petlevel >= PetLevel)
            {
               PetObj = GV.MyInfo_PetObj;
               len = uint(PetObj.Job.length);
               if(len > 0)
               {
                  for(i = 0; i < len; i++)
                  {
                     if(Boolean(PetObj.Job[i] as String))
                     {
                        return false;
                     }
                     if(PetObj.Job[i].ClassID == jobID)
                     {
                        if(PetObj.Job[i].Days == PetObj.Job[i].AllDays)
                        {
                           if(PetObj.Job[i].Status == 3)
                           {
                              return true;
                           }
                        }
                     }
                  }
               }
            }
         }
         return false;
      }
      
      public static function PetMagicCan(jobID:int) : Boolean
      {
         var PetLevel:int = 0;
         var PetObj:Object = null;
         var len:uint = 0;
         var i:uint = 0;
         if(havePetFollow())
         {
            PetLevel = 1;
            if(PeopleManageView(GV.MAN_PEOPLE).Petlevel >= PetLevel)
            {
               PetObj = GV.MyInfo_PetObj;
               len = uint(PetObj.Job.length);
               if(len > 0)
               {
                  for(i = 0; i < len; i++)
                  {
                     if(Boolean(PetObj.Job[i] as String))
                     {
                        return false;
                     }
                     if(PetObj.Job[i].ClassID == 101 && GV.MyInfo_PetObj.Level > 100 && PetObj.Job[i].classStep == 6)
                     {
                        if(jobID != 101 && jobID > 100 && jobID <= 104)
                        {
                           return true;
                        }
                     }
                     if(PetObj.Job[i].ClassID == jobID && PetObj.Job[i].classStep == 6)
                     {
                        return true;
                     }
                  }
               }
            }
         }
         return false;
      }
      
      public static function setPetMagicOK() : void
      {
         var jobID:int = 0;
         var PetLevel:int = 0;
         var PetObj:Object = null;
         var len:uint = 0;
         var i:uint = 0;
         if(havePetFollow())
         {
            PetLevel = 1;
            if(GF.getPeopleObj(GV.MyInfo_userID).Petlevel >= PetLevel)
            {
               PetObj = GV.MyInfo_PetObj;
               len = uint(PetObj.Job.length);
               if(len > 0)
               {
                  for(i = 0; i < len; i++)
                  {
                     jobID = int(PetObj.Job[i].ClassID);
                     if(jobID > 100 && jobID <= 104)
                     {
                        PetObj.Job[i].classStep = 6;
                     }
                  }
               }
            }
         }
      }
      
      public static function havePetFollow(id:int = -1) : Boolean
      {
         if(id == -1)
         {
            id = LocalUserInfo.getUserID();
         }
         var p:PeopleManageView = GF.getPeopleByID(id) as PeopleManageView;
         if(Boolean(p) && p.hasLamu)
         {
            return true;
         }
         return false;
      }
      
      public static function isSuperPet(bool:Boolean = false) : void
      {
         isDispatch = bool;
         GV.onlineSocket.addEventListener(IsSuperPetRes.IS_SL_SUCC,superPetResult);
         IsSuperPetReq.sendReq();
      }
      
      public static function superPetResult(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(IsSuperPetRes.IS_SL_SUCC,superPetResult);
         LocalUserInfo.SuperPet(Boolean(e.EventObj.Flag));
         if(!isDispatch)
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee(IS_SUPER_PET,{"bool":Boolean(e.EventObj.Flag)}));
         }
      }
      
      public static function getPetMagicClass(petMaster:PeopleManageView) : petClassLearnStatus
      {
         var pet_arr:Array = null;
         var i:int = 0;
         var obj:Object = null;
         if(petMaster.Petlevel > 0)
         {
            pet_arr = GV.MyInfo_PetObj.Job as Array;
            if(!pet_arr || Boolean(pet_arr) && Boolean(pet_arr[0] == "null"))
            {
               return new petClassLearnStatus(0);
            }
            for(i = 0; i < pet_arr.length; i++)
            {
               if(pet_arr[i].ClassID > 100 && pet_arr[i].ClassID < 105)
               {
                  obj = pet_arr[i];
                  return new petClassLearnStatus(obj.ClassID,obj.arr,obj.classStep == 6,obj.classStep);
               }
            }
            return new petClassLearnStatus(0);
         }
         return new petClassLearnStatus(-1);
      }
   }
}

