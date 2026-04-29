package com.logic.PetClassLogic
{
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.petClass.ListItem.AcceptPetClassReq;
   import com.logic.socket.petClass.ListItem.AcceptPetClassRes;
   import com.logic.socket.petClass.ListItem.GetPetClassReq;
   import com.logic.socket.petClass.ListItem.GetPetClassRes;
   import com.logic.socket.petClass.ListItem.GiveupPetClassReq;
   import com.logic.socket.petClass.ListItem.GiveupPetClassRes;
   import com.logic.socket.petClass.ListItem.SubmitPetClassReq;
   import com.logic.socket.petClass.ListItem.SubmitPetClassRes;
   import com.logic.socket.petClass.expandItem.GetPetClassJobReq;
   import com.logic.socket.petClass.expandItem.GetPetClassJobRes;
   import com.logic.socket.petClass.expandItem.SetPetClassJobReq;
   import com.logic.socket.petClass.expandItem.SetPetClassJobRes;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.Sprite;
   
   public class PetClassLogic extends Sprite
   {
      
      public static var PetClassLogics:PetClassLogic;
      
      public static var GET_PETCLASS:String = "get_petclass";
      
      public static var ACCEPT_PETCLASS:String = "accept_petclass";
      
      public static var SUBMIT_PETCLASS:String = "submit_petclass";
      
      public static var GIVEUP_PETCLASS:String = "giveup_petclass";
      
      public static var ONEPETCLASS:String = "one_pet_class";
      
      public static var ALLPETCLASS:String = "all_pet_class";
      
      public static var GETCLASSDATA:String = "get_class_data";
      
      public static var SETCLASSDATA:String = "set_class_data";
      
      private var petLevel:uint;
      
      public function PetClassLogic()
      {
         super();
      }
      
      public static function getPetClassLogics() : PetClassLogic
      {
         if(!PetClassLogics)
         {
            PetClassLogics = new PetClassLogic();
         }
         return PetClassLogics;
      }
      
      public function GetAllPetClass(petID:uint, level:uint) : void
      {
         this.petLevel = level;
         BC.addEvent(this,GV.onlineSocket,GetPetClassRes.GET_CLASS,this.backAllClassInfoObj);
         GetPetClassReq.GetPetClass(petID,101,104);
      }
      
      private function backAllClassInfoObj(evt:EventTaomee = null) : void
      {
         var i:int = 0;
         var obj:Object = null;
         BC.removeEvent(this,GV.onlineSocket,GetPetClassRes.GET_CLASS,this.backAllClassInfoObj);
         var arr:Array = evt.EventObj.petClass;
         var defaultPetClass:Array = new Array({
            "classID":102,
            "className":"魔法力量課",
            "classStep":0
         },{
            "classID":103,
            "className":"魔法守護課",
            "classStep":0
         },{
            "classID":104,
            "className":"魔法感應課",
            "classStep":0
         });
         var defaultSLPetClass:Array = new Array({
            "classID":101,
            "className":"魔法變身課",
            "classStep":0
         },{
            "classID":102,
            "className":"魔法力量課",
            "classStep":0
         },{
            "classID":103,
            "className":"魔法守護課",
            "classStep":0
         },{
            "classID":104,
            "className":"魔法感應課",
            "classStep":0
         });
         if(arr.length == 0)
         {
            if(this.petLevel == 101)
            {
               this.dispatchEvent(new EventTaomee("get_allpetclass",{"petClassList":defaultSLPetClass}));
            }
            else
            {
               this.dispatchEvent(new EventTaomee("get_allpetclass",{"petClassList":defaultPetClass}));
            }
         }
         else if(this.petLevel == 101)
         {
            obj = arr[0];
            if(obj.classStep == 6)
            {
               for(i = 0; i < 4; i++)
               {
                  defaultSLPetClass[i].classStep = 6;
               }
            }
            else
            {
               defaultSLPetClass[0].classStep = arr[0].classStep;
            }
            this.dispatchEvent(new EventTaomee("get_allpetclass",{"petClassList":defaultSLPetClass}));
         }
         else
         {
            for(i = 0; i < defaultPetClass.length; i++)
            {
               if(defaultPetClass[i].classID == arr[0].classID)
               {
                  defaultPetClass[i].classStep = arr[0].classStep;
               }
            }
            this.dispatchEvent(new EventTaomee("get_allpetclass",{"petClassList":defaultPetClass}));
         }
      }
      
      public function GetPetClass(petID:uint = 0) : void
      {
         BC.addEvent(this,GV.onlineSocket,GetPetClassRes.GET_CLASS,this.backClassInfoObj);
         GetPetClassReq.GetPetClass(petID,101,104);
      }
      
      private function backClassInfoObj(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,GetPetClassRes.GET_CLASS,this.backClassInfoObj);
         var arr:Array = evt.EventObj.petClass;
         var list:Array = this.sortPetClassList(arr);
         this.dispatchEvent(new EventTaomee("get_petclass",{"petClassList":list}));
      }
      
      private function sortPetClassList(list:Array) : Array
      {
         var newList:Array = null;
         var petID:* = undefined;
         var i:int = 0;
         var obj:Object = null;
         if(!GV.JobLogics.havePetFollow())
         {
            return list;
         }
         newList = list;
         petID = GV.MyInfo_PetObj.SpriteID;
         for(i = 0; i < list.length; i++)
         {
            obj = list[i];
            if(obj.petID == petID)
            {
               newList.splice(i,1);
               newList.splice(0,0,obj);
               return newList;
            }
         }
         return newList;
      }
      
      public function acceptPetClass(petID:uint, classID:uint, classStep:uint) : void
      {
         BC.addEvent(this,GV.onlineSocket,AcceptPetClassRes.ACCEPT_CLASS,this.acceptPetClassBack);
         BC.addEvent(this,GV.onlineSocket,"petclass_errorID",this.errorCodeBack);
         AcceptPetClassReq.AcceptPetClass(petID,classID,classStep);
      }
      
      private function acceptPetClassBack(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,AcceptPetClassRes.ACCEPT_CLASS,this.acceptPetClassBack);
         BC.removeEvent(this,GV.onlineSocket,"petclass_errorID",this.errorCodeBack);
         LocalUserInfo.Magic_task = 1;
         this.dispatchEvent(new EventTaomee("accept_petclass",{"errorID":0}));
      }
      
      public function submitPetClass(petID:uint, classID:uint, classStep:uint) : void
      {
         BC.addEvent(this,GV.onlineSocket,SubmitPetClassRes.SUBMIT_PETCLASS,this.submitPetClassBack);
         SubmitPetClassReq.SubmitPetClass(petID,classID,classStep);
      }
      
      private function submitPetClassBack(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,SubmitPetClassRes.SUBMIT_PETCLASS,this.submitPetClassBack);
         if(evt.EventObj.petFlag == 0)
         {
            LocalUserInfo.Magic_task = 0;
         }
         this.dispatchEvent(new EventTaomee("submit_petclass",{"flag":evt.EventObj.petFlag}));
      }
      
      public function giveupPetClass(petID:uint, classID:uint) : void
      {
         BC.addEvent(this,GV.onlineSocket,GiveupPetClassRes.GIVEUP_PETCLASS,this.giveupPetClassBack);
         GiveupPetClassReq.GiveupPetClass(petID,classID);
      }
      
      private function giveupPetClassBack(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,GiveupPetClassRes.GIVEUP_PETCLASS,this.giveupPetClassBack);
         if(evt.EventObj.petFlag == 0)
         {
            LocalUserInfo.Magic_task = 0;
         }
         this.dispatchEvent(new EventTaomee("giveup_petclass"));
      }
      
      public function getClassData(petID:uint, classID:uint) : void
      {
         var peopleView:PeopleManageView = GV.MAN_PEOPLE;
         var tarPetID:uint = peopleView.PetID;
         if(Boolean(tarPetID))
         {
            BC.addEvent(this,GV.onlineSocket,GetPetClassJobRes.GET_BACK,this.getClassDataBack);
            GetPetClassJobReq.GetInfo(tarPetID,classID);
         }
      }
      
      private function getClassDataBack(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,GetPetClassJobRes.GET_BACK,this.getClassDataBack);
         var classDataObj:Object = evt.EventObj.obj;
         this.dispatchEvent(new EventTaomee("get_class_data",{"obj":classDataObj}));
      }
      
      public function setClassData(petID:uint, classID:uint, jobArr:Array) : void
      {
         BC.addEvent(this,GV.onlineSocket,SetPetClassJobRes.GET_BACK,this.setClassDataBack);
         SetPetClassJobReq.SetInfo(petID,classID,jobArr);
      }
      
      private function setClassDataBack(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,SetPetClassJobRes.GET_BACK,this.setClassDataBack);
         this.dispatchEvent(new EventTaomee("set_class_data"));
      }
      
      private function errorCodeBack(evt:EventTaomee = null) : void
      {
         trace("拉姆魔法課程~~~~~~~~~~~~~~~~~~~~~~~~~~~" + evt.EventObj.ID);
         BC.removeEvent(this,GV.onlineSocket,AcceptPetClassRes.ACCEPT_CLASS,this.acceptPetClassBack);
         BC.removeEvent(this,GV.onlineSocket,"petclass_errorID",this.errorCodeBack);
         this.dispatchEvent(new EventTaomee("accept_petclass",{"errorID":evt.EventObj.ID}));
      }
   }
}

