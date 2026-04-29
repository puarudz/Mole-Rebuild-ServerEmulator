package com.module.lamu
{
   import com.common.Alert.Alert;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.petSocket.keepPet.mypetKeepReq;
   import com.logic.socket.petSocket.keepPet.mypetKeepRes;
   import com.logic.socket.petSocket.keepPet.petBackKeepReq;
   import com.logic.socket.petSocket.keepPet.petBackKeepRes;
   import com.logic.socket.petSocket.keepPet.petKeepNumReq;
   import com.logic.socket.petSocket.keepPet.petKeepNumRes;
   import com.logic.socket.petSocket.keepPet.petKeepReq;
   import com.logic.socket.petSocket.keepPet.petKeepRes;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.*;
   
   public class lamuKeeping
   {
      
      public var target_mc:MovieClip;
      
      public var keepOrBackMC:*;
      
      public var keepDaysMC:*;
      
      public var sureKeepMC:*;
      
      public var lamuSelectMC:*;
      
      public var backSuccMC:*;
      
      public var lastBackTime:Number;
      
      public var keepDay:Number = 0;
      
      public var lamuAllNum:int = -1;
      
      public var dayArr:Array = [3,7,14];
      
      public var moneyArr:Array = [120,300,600];
      
      public var midArr:Array = [[0],[-1,1],[-2,0,2],[-3,-1,1,3]];
      
      public var petObj:Object;
      
      public var MyKeepPetObj:Object;
      
      public var BackPet:*;
      
      public var BackFoodArr:Array = [{
         "id":180001,
         "name":"巧克力豆"
      },{
         "id":180002,
         "name":"牛奶"
      },{
         "id":180003,
         "name":"泡泡浴"
      }];
      
      public function lamuKeeping(mc:MovieClip)
      {
         super();
         this.target_mc = mc;
         this.init();
      }
      
      public function init() : void
      {
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeEventHandler);
         this.target_mc.lamuNPC_btn.addEventListener(MouseEvent.CLICK,this.clickLamuNPC);
      }
      
      public function removeEventHandler(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeEventHandler);
         this.target_mc.lamuNPC_btn.removeEventListener(MouseEvent.CLICK,this.clickLamuNPC);
      }
      
      public function clickLamuNPC(e:MouseEvent) : void
      {
         this.target_mc.npc_10052.npc_mc.mc_1.gotoAndPlay(2);
         this.target_mc.npc_10052.npc_mc.mole_mc.body_mc.gotoAndPlay(2);
         this.target_mc.npc_10052.npc_mc.cloth_mc.gotoAndPlay(2);
         if(this.lamuAllNum < 0)
         {
            petKeepNumReq.sendReq(0);
            GV.onlineSocket.addEventListener(petKeepNumRes.GOODS_NUM_SUCC,this.getKeepNum);
         }
         else
         {
            this.showKeepOrBack();
         }
      }
      
      public function getKeepNum(e:EventTaomee = null) : void
      {
         GV.onlineSocket.removeEventListener(petKeepNumRes.GOODS_NUM_SUCC,this.getKeepNum);
         if(e.EventObj.Type == 0)
         {
            this.lamuAllNum = e.EventObj.Num;
            this.showKeepOrBack();
         }
      }
      
      public function showKeepOrBack() : void
      {
         var tempMC:Class = null;
         if(!GV.MC_AppLever.getChildByName("keepOrBack"))
         {
            tempMC = GV.Lib_Map.getClass("keepOrBack");
            this.keepOrBackMC = new tempMC();
            this.keepOrBackMC.lamuNum.htmlText = "    嗨～你好！我是彩虹姐姐，現在一共有<font color=\'#ff0000\'>" + this.lamuAllNum + "</font>個拉姆，在我的照顧下茁壯成長哦！";
            this.keepOrBackMC.name = "keepOrBack";
            this.keepOrBackMC.keep_btn.addEventListener(MouseEvent.CLICK,this.keepPet);
            this.keepOrBackMC.back_btn.addEventListener(MouseEvent.CLICK,this.backPet);
            GV.MC_AppLever.addChild(this.keepOrBackMC);
            this.keepOrBackMC.x = (GV.stageWidth - this.keepOrBackMC.width) / 2;
            this.keepOrBackMC.y = (GV.stageHeight - this.keepOrBackMC.height) / 2;
            this.keepOrBackMC.close_btn.addEventListener(MouseEvent.CLICK,this.removekeepOrBackMC);
         }
      }
      
      public function keepDaysFun() : void
      {
         var tempMC:Class = null;
         if(!GV.MC_AppLever.getChildByName("keepDays"))
         {
            this.removekeepOrBackMC();
            tempMC = GV.Lib_Map.getClass("keepDays");
            this.keepDaysMC = new tempMC();
            this.keepDaysMC.name = "keepDays";
            this.keepDaysMC.select0.addEventListener(MouseEvent.CLICK,this.PetDay);
            this.keepDaysMC.select1.addEventListener(MouseEvent.CLICK,this.PetDay);
            this.keepDaysMC.select2.addEventListener(MouseEvent.CLICK,this.PetDay);
            GV.MC_AppLever.addChild(this.keepDaysMC);
            this.keepDaysMC.x = (GV.stageWidth - this.keepDaysMC.width) / 2;
            this.keepDaysMC.y = (GV.stageHeight - this.keepDaysMC.height) / 2;
            this.keepDaysMC.close_btn.addEventListener(MouseEvent.CLICK,this.removekeepDaysMC);
         }
      }
      
      public function PetDay(e:MouseEvent) : void
      {
         var tempMC:Class = null;
         if(PeopleManageView(GV.MAN_PEOPLE).hasLamu)
         {
            this.keepDay = uint(e.target.name.slice(6));
            if(!GV.MC_AppLever.getChildByName("sureKeep"))
            {
               tempMC = GV.Lib_Map.getClass("sureKeep");
               this.sureKeepMC = new tempMC();
               this.sureKeepMC.name = "sureKeep";
               this.sureKeepMC.yes_btn.addEventListener(MouseEvent.CLICK,this.dokeepPet);
               this.sureKeepMC.no_btn.addEventListener(MouseEvent.CLICK,this.cancelKeep);
               this.sureKeepMC.x = (GV.stageWidth - this.sureKeepMC.width) / 2;
               this.sureKeepMC.y = (GV.stageHeight - this.sureKeepMC.height) / 2;
               GV.MC_AppLever.addChild(this.sureKeepMC);
               this.sureKeepMC.txt.text = "托管" + this.dayArr[this.keepDay] + "天需要花費" + this.moneyArr[this.keepDay] + "摩爾豆，你要確認托管嗎？";
            }
         }
         else
         {
            Alert.showAlert(GV.MC_AppLever,"你沒有帶著拉姆哦！","",Alert.CHANG_ALERT,"iknow",true,false,"D");
         }
      }
      
      public function dokeepPet(e:MouseEvent) : void
      {
         var p:PeopleManageView = PeopleManageView(GV.MAN_PEOPLE);
         trace(p,123);
         if(p.hasLamu)
         {
            this.cancelKeep();
            this.removekeepDaysMC();
            if(LocalUserInfo.getYXQ() >= this.moneyArr[this.keepDay])
            {
               LocalUserInfo.countYXQ(-this.moneyArr[this.keepDay]);
               petKeepReq.sendReq([p.lamuinfo.PetID],this.keepDay);
               GV.onlineSocket.addEventListener(petKeepRes.PET_KEEP_SUCC,this.KeepSucc);
            }
            else
            {
               Alert.showAlert(GV.MC_AppLever,"托管失敗！你沒有足夠的摩爾豆來支付托管費用哦！","",Alert.CHANG_ALERT,"iknow",true,false,"D");
            }
         }
         else
         {
            Alert.showAlert(GV.MC_AppLever,"你沒有帶著拉姆哦！","",Alert.CHANG_ALERT,"iknow",true,false,"D");
         }
      }
      
      public function KeepSucc(e:Event) : void
      {
         GV.MyInfo_Pet = 0;
         var moleObj:Object = GV.GF.getPeopleObj(GV.MyInfo_userID);
         moleObj.PetID = null;
         moleObj.PetColor = null;
         moleObj.Petlevel = null;
         var mole:* = GV.GF.getPeopleByID(GV.MyInfo_userID);
         if(mole.avatarClass.avatarMC.pet_mc.numChildren > 0)
         {
            mole.backPet();
            GV.onlineSocket.dispatchEvent(new Event("lahm_go_home"));
         }
         GV.onlineSocket.removeEventListener(petKeepRes.PET_KEEP_SUCC,this.KeepSucc);
         ++this.lamuAllNum;
         Alert.showAlert(GV.MC_AppLever,"托管成功！一定要記得在" + this.dayArr[this.keepDay] + "天托管期之內接你的拉姆回家哦！","",Alert.CHANG_ALERT,"iknow",true,false,"E");
      }
      
      public function cancelKeep(e:MouseEvent = null) : void
      {
         this.sureKeepMC.yes_btn.removeEventListener(MouseEvent.CLICK,this.dokeepPet);
         this.sureKeepMC.no_btn.removeEventListener(MouseEvent.CLICK,this.cancelKeep);
         this.sureKeepMC.parent.removeChild(this.sureKeepMC);
         this.sureKeepMC = null;
      }
      
      public function keepPet(e:MouseEvent) : void
      {
         if(PeopleManageView(GV.MAN_PEOPLE).hasLamu)
         {
            this.keepDaysFun();
         }
         else
         {
            Alert.showAlert(GV.MC_AppLever,"你沒有帶著拉姆哦！","",Alert.CHANG_ALERT,"iknow",true,false,"D");
         }
      }
      
      public function havePetFollow() : Boolean
      {
         this.petObj = GV.GF.getPeopleObj(GV.MyInfo_userID);
         if(this.petObj != null && Boolean(this.petObj.PetID))
         {
            return true;
         }
         return false;
      }
      
      public function backPet(e:MouseEvent) : void
      {
         this.removekeepOrBackMC();
         mypetKeepReq.sendReq();
         GV.onlineSocket.addEventListener(mypetKeepRes.MY_PET_KEEP_SUCC,this.getMyKeepPetSucc);
      }
      
      public function getMyKeepPetSucc(e:EventTaomee) : void
      {
         this.MyKeepPetObj = e.EventObj;
         GV.onlineSocket.removeEventListener(mypetKeepRes.MY_PET_KEEP_SUCC,this.getMyKeepPetSucc);
         if(e.EventObj.Num > 0)
         {
            this.showMyKeepPet();
         }
         else
         {
            Alert.showAlert(GV.MC_AppLever,"你沒有托管中的拉姆哦！","",Alert.CHANG_ALERT,"iknow",true,false,"D");
         }
      }
      
      public function showMyKeepPet() : void
      {
         var tempMC:Class = null;
         if(!GV.MC_AppLever.getChildByName("lamuSelect"))
         {
            tempMC = GV.Lib_Map.getClass("lamuSelect");
            this.lamuSelectMC = new tempMC();
            this.lamuSelectMC.name = "lamuSelect";
            this.lamuSelectMC.yes_btn.addEventListener(MouseEvent.CLICK,this.backMyPet);
            this.lamuSelectMC.no_btn.addEventListener(MouseEvent.CLICK,this.cancelBack);
            GV.MC_AppLever.addChild(this.lamuSelectMC);
            this.lamuSelectMC.x = (GV.stageWidth - this.lamuSelectMC.width) / 2;
            this.lamuSelectMC.y = (GV.stageHeight - this.lamuSelectMC.height) / 2;
            this.lamuSelectMC.close_btn.addEventListener(MouseEvent.CLICK,this.removelamuSelectMC);
            this.dupPet();
         }
      }
      
      public function dupPet() : void
      {
         var i:uint = 0;
         var mc:MovieClip = null;
         var petMC:MovieClip = null;
         var mc1:lamuAvatar = null;
         this.lastBackTime = this.getMaxOrMin(this.MyKeepPetObj.Arr,false);
         for(i = 0; i < 4; i++)
         {
            mc = this.lamuSelectMC["pet_" + i];
            mc.visible = false;
         }
         for(i = 0; i < this.MyKeepPetObj.Num; i++)
         {
            petMC = this.lamuSelectMC["pet_" + i];
            petMC.visible = true;
            if(i == 0)
            {
               petMC.pet_mc.scaleX = 1.3;
               petMC.pet_mc.scaleY = 1.3;
               this.BackPet = petMC.pet_mc;
            }
            petMC.name_txt.text = this.MyKeepPetObj.Arr[i].Nick;
            petMC.time_txt.text = String(int(this.MyKeepPetObj.Arr[i].Time / 3600)) + "小時";
            petMC.pet_mc.obj = this.MyKeepPetObj.Arr[i];
            petMC.btn.addEventListener(MouseEvent.CLICK,this.selectBackPet);
            GC.clearAllChildren(petMC.pet_mc);
            mc1 = new lamuAvatar();
            mc1.loadAvatar(this.MyKeepPetObj.Arr[i].lamuinfo);
            petMC.pet_mc.addChild(mc1);
         }
      }
      
      public function selectBackPet(e:Event) : void
      {
         if(Boolean(this.BackPet))
         {
            this.BackPet.scaleX = 1;
            this.BackPet.scaleY = 1;
         }
         this.BackPet = e.target.parent.pet_mc;
         this.BackPet.scaleX = 1.3;
         this.BackPet.scaleY = 1.3;
      }
      
      public function getMaxOrMin(arr:Array, mm:Boolean) : Number
      {
         var i:uint = 0;
         var num:Number = 0;
         num = Number(arr[0]["Time"]);
         if(mm)
         {
            return 0;
         }
         for(i = 0; i < arr.length; i++)
         {
            if(arr.length > i + 1)
            {
               num = num > arr[i + 1]["Time"] ? Number(arr[i + 1]["Time"]) : num;
               trace("i:" + i);
            }
         }
         return num;
      }
      
      public function backMyPet(e:Event) : void
      {
         this.removelamuSelectMC();
         petBackKeepReq.sendReq([this.BackPet.obj.PetID]);
         GV.onlineSocket.addEventListener(petBackKeepRes.PET_BACK_SUCC,this.myPetBackSucc);
      }
      
      public function cancelBack(e:Event) : void
      {
         this.removelamuSelectMC();
      }
      
      public function goodName(id:*) : *
      {
         for(var i:uint = 0; i < this.BackFoodArr.length; i++)
         {
            if(id == this.BackFoodArr[i].id)
            {
               return this.BackFoodArr[i].name;
            }
         }
      }
      
      public function myPetBackSucc(e:EventTaomee) : void
      {
         var TempClass:Class = null;
         --this.lamuAllNum;
         if(!GV.MC_AppLever.getChildByName("backSuccMC"))
         {
            TempClass = GV.Lib_Map.getClass("backPetSuccTip");
            this.backSuccMC = new TempClass();
            this.backSuccMC.name = "backSuccMC";
            this.backSuccMC.info.htmlText = "    你的拉姆真是太乖巧、太可愛啦，彩虹姐姐好喜歡它哦，所以決定送給你的拉姆<font color=\'#ff0000\'>" + this.goodName(e.EventObj.arr[0].kind) + "</font>做為獎勵哦,趕快回家看看吧！";
            this.backSuccMC.close_btn.addEventListener(MouseEvent.CLICK,this.removebackSuccMC);
            this.backSuccMC.iknow_btn.addEventListener(MouseEvent.CLICK,this.removebackSuccMC);
            this.backSuccMC.x = (GV.stageWidth - this.backSuccMC.width) / 2;
            this.backSuccMC.y = (GV.stageHeight - this.backSuccMC.height) / 2;
            GV.MC_AppLever.addChild(this.backSuccMC);
            GV.onlineSocket.removeEventListener(petBackKeepRes.PET_BACK_SUCC,this.myPetBackSucc);
         }
      }
      
      public function removebackSuccMC(e:MouseEvent = null) : void
      {
         this.backSuccMC.close_btn.removeEventListener(MouseEvent.CLICK,this.removebackSuccMC);
         this.backSuccMC.iknow_btn.removeEventListener(MouseEvent.CLICK,this.removebackSuccMC);
         GC.stopAllMC(this.backSuccMC);
         GC.clearChildren(this.backSuccMC);
         this.backSuccMC.parent.removeChild(this.backSuccMC);
         this.backSuccMC = null;
      }
      
      public function removekeepDaysMC(e:MouseEvent = null) : void
      {
         this.keepDaysMC.close_btn.removeEventListener(MouseEvent.CLICK,this.removekeepDaysMC);
         GC.stopAllMC(this.keepDaysMC);
         GC.clearChildren(this.keepDaysMC);
         this.keepDaysMC.parent.removeChild(this.keepDaysMC);
         this.keepDaysMC = null;
      }
      
      public function removelamuSelectMC(e:MouseEvent = null) : void
      {
         this.lamuSelectMC.close_btn.removeEventListener(MouseEvent.CLICK,this.removelamuSelectMC);
         GC.stopAllMC(this.lamuSelectMC);
         GC.clearChildren(this.lamuSelectMC);
         this.lamuSelectMC.parent.removeChild(this.lamuSelectMC);
         this.lamuSelectMC = null;
      }
      
      public function removekeepOrBackMC(e:MouseEvent = null) : void
      {
         this.keepOrBackMC.close_btn.removeEventListener(MouseEvent.CLICK,this.removekeepOrBackMC);
         GC.stopAllMC(this.keepOrBackMC);
         GC.clearChildren(this.keepOrBackMC);
         this.keepOrBackMC.parent.removeChild(this.keepOrBackMC);
         this.keepOrBackMC = null;
      }
      
      public function setPetColor(mc:MovieClip, colorNum:int) : void
      {
         var _array:Array = GV["petColor_" + colorNum];
         mc.transform.colorTransform = new ColorTransform(_array[0],_array[1],_array[2],_array[3],_array[4],_array[5],_array[6],_array[7]);
      }
   }
}

