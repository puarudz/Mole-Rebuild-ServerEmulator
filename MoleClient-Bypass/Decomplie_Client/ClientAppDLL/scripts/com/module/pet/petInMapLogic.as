package com.module.pet
{
   import com.common.Alert.*;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.petSocket.adoptPet.*;
   import com.module.house.floorViewStatic;
   import flash.events.Event;
   
   public class petInMapLogic
   {
      
      public static var petinforeq:petInfoReq;
      
      public static var petfoodreq:petFoodReq;
      
      public static var petfollowreq:petFollowOutReq;
      
      public static var petnickreq:modPetNickReq;
      
      public static var petposreq:petPosReq;
      
      public static var petplayreq:petPlayReq;
      
      public static var petview:petView;
      
      public static var petInMap:petInMapView;
      
      public static var IS_SUPER_PET:String = "IS_SUPER_PET";
      
      public static var IS_SUPER_PET_SUCCESS:String = "is_super_pet_success";
      
      public function petInMapLogic()
      {
         super();
      }
      
      public static function init() : void
      {
         petinforeq = new petInfoReq();
         GV.onlineSocket.addEventListener("removeMapEvent",removeHandler);
         GV.onlineSocket.addEventListener("GET_PETFOLLOW_SUCC",petBackHomeSucc);
         GV.onlineSocket.addEventListener(petFollowOutRes.GET_PETFOLLOW_OUT_SUCC,petFollowInMapSucc);
      }
      
      public static function petBackHomeSucc(e:EventTaomee) : void
      {
         var obj:Object = e.EventObj;
         var mole:* = GV.GF.getPeopleByID(obj.UserID);
         if(!Boolean(obj.Status))
         {
            backPetBeforeFollow(mole,obj);
         }
      }
      
      public static function removeHandler(e:Event) : void
      {
         GV.onlineSocket.removeEventListener("removeMapEvent",removeHandler);
         GV.onlineSocket.removeEventListener("GET_PETFOLLOW_SUCC",petBackHomeSucc);
         GV.onlineSocket.removeEventListener(petFollowOutRes.GET_PETFOLLOW_OUT_SUCC,petFollowInMapSucc);
      }
      
      public static function doPethome(petid:uint) : void
      {
         GV.onlineSocket.dispatchEvent(new Event("lahm_go_home"));
         var petreq:petFollowReq = new petFollowReq();
         petreq.sendFollowReq(petid,0);
      }
      
      public static function doPetFollowInMap(userid:uint, petid:uint) : void
      {
         petfollowreq = new petFollowOutReq();
         petfollowreq.sendFollowReq(userid,petid);
      }
      
      public static function petFollowInMapSucc(e:EventTaomee) : void
      {
         var obj:Object = e.EventObj;
         var mole:* = GV.GF.getPeopleByID(obj.UserID);
         if(LocalUserInfo.getUserID() == obj.UserID)
         {
            trace("我帶在外玩的寵物在身上");
            updateGVPetInfo(obj);
            dopetFollowOrBack(obj,mole);
         }
         else
         {
            trace("別人帶在外玩的寵物在身上");
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
         GV.MyInfo_PetObj.Name = GV.MyInfo_PetName;
      }
      
      public static function dopetFollowOrBack(obj:Object, mole:*) : void
      {
         var moleObj:Object = null;
         if(Boolean(obj.Status))
         {
            petInMap.removePet(obj.UserID,obj.SpriteID);
            if(mole.avatarClass.avatarMC.pet_mc.numChildren > 0)
            {
               mole.backPet();
            }
            moleObj = GV.GF.getPeopleObj(obj.UserID);
            moleObj.PetID = obj.SpriteID;
            moleObj.PetColor = obj.Color;
            moleObj.Petlevel = obj.Level;
            mole.PetID = obj.SpriteID;
            mole.PetColor = obj.Color;
            mole.Petlevel = obj.Level;
            mole.PetObj = obj;
            updateGVPetInfo(obj);
            mole.addPet();
         }
      }
      
      public static function getPetJob(e:EventTaomee) : void
      {
         GV.MyInfo_PetObj.Job = e.EventObj.obj.Arr;
         trace(GV.MyInfo_PetObj.Job);
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
      
      public static function petReq(petid:uint) : void
      {
         if(LocalUserInfo.getMapID() != 0)
         {
            petinforeq.sendInfoReq(LocalUserInfo.getMapID(),petid);
         }
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
      
      public static function molePlayPet(userid:int, petid:int) : void
      {
         petplayreq = new petPlayReq();
         petplayreq.sendPlayReq(userid,petid);
      }
      
      public static function showPetPlay(e:EventTaomee) : void
      {
         try
         {
            petview.showPetPlay(e.EventObj);
         }
         catch(err:Error)
         {
         }
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
      
      public static function PetCan(jobID:uint, PetLevel:uint) : Boolean
      {
         var PetObj:Object = null;
         var len:uint = 0;
         var i:uint = 0;
         if(havePetFollow())
         {
            if(GF.getPeopleObj(GV.MyInfo_userID).Petlevel >= PetLevel)
            {
               PetObj = GV.MyInfo_PetObj;
               len = uint(PetObj.Job.length);
               if(len > 0)
               {
                  for(i = 0; i < len; i++)
                  {
                     if(!(Boolean(PetObj.Job[i] as String)))
                     {
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
         }
         return false;
      }
      
      public static function havePetFollow(id:int = -1) : Boolean
      {
         if(id == -1)
         {
            id = LocalUserInfo.getUserID();
         }
         var petObj:Object = GF.getPeopleObj(id);
         if(petObj != null && Boolean(petObj.PetID))
         {
            return true;
         }
         return false;
      }
      
      public static function isSuperPet() : void
      {
         GV.onlineSocket.addEventListener(IsSuperPetRes.IS_SL_SUCC,superPetResult);
         IsSuperPetReq.sendReq();
      }
      
      public static function superPetResult(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(IsSuperPetRes.IS_SL_SUCC,superPetResult);
         LocalUserInfo.SuperPet(Boolean(e.EventObj.Flag));
         GV.onlineSocket.dispatchEvent(new EventTaomee(IS_SUPER_PET,{"bool":Boolean(e.EventObj.Flag)}));
      }
      
      public static function getPetNumInMap() : void
      {
         var petnum:petMapNumReq = new petMapNumReq();
         GV.onlineSocket.addEventListener(petMapNumRes.GET_PET_MAP_SUCC,getPetNum);
         petnum.sendReq();
      }
      
      public static function getPetNum(e:EventTaomee) : void
      {
         petInMap = new petInMapView(e.EventObj);
         GV.onlineSocket.removeEventListener(petMapNumRes.GET_PET_MAP_SUCC,getPetNum);
      }
   }
}

