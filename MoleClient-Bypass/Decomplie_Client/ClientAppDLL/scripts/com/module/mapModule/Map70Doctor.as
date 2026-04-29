package com.module.mapModule
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.socket.cure.GetCureAllInfo;
   import com.logic.socket.cure.SetCureAllInfo;
   import com.module.pet.petPanel;
   import com.view.PeopleView.PeopleManageView;
   import com.view.userPanelView.userPanelView;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   public class Map70Doctor extends Sprite
   {
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var botton_mc:MovieClip;
      
      private var Info_arr:Array;
      
      private var Pet_time:Timer;
      
      private var My_time:Timer;
      
      private var myAlt:*;
      
      private var my_petIP:uint = 100;
      
      private var my_docIP:uint = 100;
      
      private var my_doc_flag:uint = 0;
      
      private var close_arr:Array = [[12736,12737,12738]];
      
      private var _URL:String = "resource/allJob/AlertPic/andy/";
      
      private var OnePetOn_obj:Object;
      
      private var AllAlt_MC:MovieClip;
      
      private var JobOK_arr:Array;
      
      public function Map70Doctor()
      {
         super();
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeAllFun);
         BC.addEvent(this,GV.onlineSocket,GetCureAllInfo.BACK_ALL,this.MapInfo);
         SetCureAllInfo.GetAllInfo();
      }
      
      private function MapInfo(eve:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,GetCureAllInfo.BACK_ALL,this.MapInfo);
         this.Info_arr = eve.EventObj.obj.Arr;
         this.JobOK_arr = new Array();
         BC.addEvent(this,GV.onlineSocket,GetCureAllInfo.BACK_DOCTOR_ON,this.OneDocOn);
         BC.addEvent(this,GV.onlineSocket,GetCureAllInfo.BACK_DOCTOR_OUT,this.OneDocUP);
         BC.addEvent(this,GV.onlineSocket,GetCureAllInfo.BACK_INVALID_ON,this.OnePetOn);
         BC.addEvent(this,GV.onlineSocket,GetCureAllInfo.BACK_INVALID_OUT,this.OnePetUP);
         BC.addEvent(this,GV.onlineSocket,GetCureAllInfo.BACK_DOCTOR_ONE,this.OneDocOneJob);
         BC.addEvent(this,GV.onlineSocket,GetCureAllInfo.BACK_DOCTOR_TWO,this.OneDocTwoJob);
         BC.addEvent(this,GV.onlineSocket,GetCureAllInfo.BACK_DOCTOR_WORK,this.getWorkMoney);
         BC.addEvent(this,GV.onlineSocket,"dis_mapdoc_errorID",this.AltErrorFun);
         BC.addEvent(this,GV.onlineSocket,"lahm_go_home",this.MyPetBackFun);
         BC.addEvent(this,GV.onlineSocket,"iskaddish",this.MyMoveFun);
         this.setAllGameUI();
      }
      
      private function setAllGameUI() : void
      {
         var petMC:MovieClip = null;
         var msg:String = null;
         var PetMC:* = undefined;
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.DoctorOnFun);
         for(var i:uint = 0; i < 4; i++)
         {
            BC.addEvent(this,this.botton_mc["pet_" + i],MouseEvent.CLICK,this.PetOnFun);
            this.botton_mc["btn_" + i].visible = false;
            this.depth_mc["mc_" + i].Doc_mc.gotoAndStop(1);
            msg = "";
            if(this.Info_arr[i].Doctor_id != 0)
            {
               this.depth_mc["mc_" + i].Doc_mc.gotoAndStop(2);
            }
            if(this.Info_arr[i].Invalid_id != 0)
            {
               if(this.Info_arr[i].Doctor_id == 0)
               {
                  this.depth_mc["mc_" + i].Doc_mc.gotoAndStop(3);
               }
               petMC = this.getNowPeople(this.Info_arr[i].Invalid_id);
               petMC.petmc.visible = false;
               petMC.avatarMC.pet_mc.visible = false;
               if(petMC.PetSick == 0)
               {
                  if(Boolean(PeopleManageView(petMC).lamuinfo.hasSkillAvatar()))
                  {
                     msg = "pet" + petMC.Petlevel + "_" + PeopleManageView(petMC).lamuinfo.skill_learnType;
                  }
                  else
                  {
                     msg = "pet" + petMC.Petlevel;
                  }
               }
               else if(Boolean(PeopleManageView(petMC).lamuinfo.hasSkillAvatar()))
               {
                  msg = "pet" + petMC.Petlevel + "_" + PeopleManageView(petMC).lamuinfo.skill_learnType + "_" + petMC.PetSick;
               }
               else
               {
                  msg = "pet" + petMC.Petlevel + "_" + petMC.PetSick;
               }
               this.AddNewMC(msg,i);
               PetMC = this.getAddNewMC(msg,i);
               this.setPetColor(PetMC.petBody,petMC.PetColor);
            }
         }
         this.AllAlt_MC = new MovieClip();
         this.AllAlt_MC.name = "Alt_mc";
         MainManager.getAppLevel().addChild(this.AllAlt_MC);
      }
      
      private function DoctorOnFun(eve:EventTaomee) : void
      {
         var docIP:uint = 0;
         if(this.my_docIP != 100)
         {
            return;
         }
         if(this.my_petIP != 100)
         {
            return;
         }
         docIP = uint(eve.EventObj.type);
         if(this.Info_arr[docIP].Doctor_id == 0)
         {
            if(!GV.JobLogics.chartbagClothFun(this.close_arr))
            {
               this.myAlt = Alert.showAlert(this.AllAlt_MC,this._URL + "005.swf","    你真是一位有愛心的小摩爾啊！可是，要穿上拉姆救治師的服裝才可以救治小拉姆哦！",Alert.CHANG_ALERT,"iknow",true,false,"SMCUI");
               this.myAlt = null;
               return;
            }
            if(this.Info_arr[docIP].Invalid_id != 0)
            {
               if(LocalUserInfo.getUserID() == this.Info_arr[docIP].Invalid_id)
               {
                  return;
               }
               var _temp_4:* = BC;
               var _temp_3:* = this;
               var _temp_2:* = this.myAlt;
               var _temp_1:* = Alert.CLICK_ + "1";
               with({})
               {
                  
                  var _temp_8:* = BC;
                  var _temp_7:* = this;
                  var _temp_6:* = this.myAlt;
                  var _temp_5:* = Alert.CLICK_ + "2";
                  with({})
                  {
                     
                     _temp_8.addEvent(_temp_7,_temp_6,_temp_5,function NOBeginToDoc(eve:Event):void
                     {
                        BC.removeEvent(this,myAlt,Alert.CLICK_ + "2",NOBeginToDoc);
                        myAlt = null;
                     });
                  }
                  else
                  {
                     var _temp_12:* = BC;
                     var _temp_11:* = this;
                     var _temp_10:* = this.myAlt;
                     var _temp_9:* = Alert.CLICK_ + "1";
                     with({})
                     {
                        
                        var _temp_16:* = BC;
                        var _temp_15:* = this;
                        var _temp_14:* = this.myAlt;
                        var _temp_13:* = Alert.CLICK_ + "2";
                        with({})
                        {
                           
                           _temp_16.addEvent(_temp_15,_temp_14,_temp_13,function noToWork(eve:Event):void
                           {
                              BC.removeEvent(this,myAlt,Alert.CLICK_ + "2",noToWork);
                              myAlt = null;
                           });
                        }
                     }
                     else
                     {
                        this.showAltFun("抱歉這個位置已經有人\r換別的位置試試？");
                     }
                  }
                  
                  private function PetOnFun(eve:MouseEvent) : void
                  {
                     var str:String;
                     var petIP:uint = 0;
                     if(this.my_docIP != 100)
                     {
                        return;
                     }
                     if(this.my_petIP != 100)
                     {
                        return;
                     }
                     str = eve.currentTarget.name;
                     petIP = uint(str.substr(4,1));
                     if(!GV.JobLogics.havePetFollow())
                     {
                        this.showAltFun("請帶著你的拉姆吧！");
                        return;
                     }
                     if(petPanel.petUIMC.Flag == 1)
                     {
                        if(petPanel.petUIMC.BlackSick != 1 && petPanel.petUIMC.BlackSick != 2 && petPanel.petUIMC.BlackSick != 3)
                        {
                           this.showAltFun("你的拉姆所生的疾病不用打針，從配藥間裡買一瓶萬能藥水給它喝了就可以治好啦！");
                           return;
                        }
                     }
                     if(this.Info_arr[petIP].Invalid_id == 0)
                     {
                        if(this.Info_arr[petIP].Doctor_id == LocalUserInfo.getUserID())
                        {
                           return;
                        }
                        var _temp_6:* = BC;
                        var _temp_5:* = this;
                        var _temp_4:* = this.myAlt;
                        var _temp_3:* = Alert.CLICK_ + "1";
                        with({})
                        {
                           
                           var _temp_10:* = BC;
                           var _temp_9:* = this;
                           var _temp_8:* = this.myAlt;
                           var _temp_7:* = Alert.CLICK_ + "2";
                           with({})
                           {
                              
                              _temp_10.addEvent(_temp_9,_temp_8,_temp_7,function nosetPetOnIP(eve:Event):void
                              {
                                 BC.removeEvent(this,myAlt,Alert.CLICK_ + "2",nosetPetOnIP);
                                 myAlt = null;
                              });
                           }
                           else
                           {
                              this.showAltFun("很抱歉這個病床已經有拉姆了\r換別的床位試試吧！");
                           }
                        }
                        
                        private function NoDocPetUP() : void
                        {
                           if(Boolean(this.Pet_time))
                           {
                              GC.clearGTimeout(this.Pet_time);
                              this.Pet_time = null;
                              this.my_petIP = 100;
                              SetCureAllInfo.SetCureInvalidOut();
                              this.myAlt = Alert.showAlert(this.AllAlt_MC,this._URL + "007.swf","咦！好像沒有救治師來值班哦！你可以去配藥間看看啊，也可以選擇一個床位繼續等待哦！",Alert.CHANG_ALERT,"iknow",true,false,"SMCUI");
                              this.myAlt = null;
                           }
                        }
                        
                        private function MissDortor(eve:* = null) : void
                        {
                           if(Boolean(this.myAlt))
                           {
                              GC.clearAllChildren(this.AllAlt_MC);
                              this.myAlt = null;
                           }
                           if(Boolean(this.My_time))
                           {
                              GC.clearGTimeout(this.My_time);
                              this.My_time = null;
                              this.my_docIP = 100;
                              SetCureAllInfo.SetCureDortorOut();
                           }
                        }
                        
                        private function MyPetBackFun(eve:Event) : void
                        {
                           if(this.my_petIP != 100)
                           {
                              if(Boolean(this.Pet_time))
                              {
                                 GC.clearGTimeout(this.Pet_time);
                                 this.Pet_time = null;
                              }
                              this.my_petIP = 100;
                              SetCureAllInfo.SetCureInvalidOut();
                           }
                        }
                        
                        private function MyMoveFun(eve:Event = null) : void
                        {
                           if(this.my_docIP != 100)
                           {
                              if(Boolean(this.My_time))
                              {
                                 GC.clearGTimeout(this.My_time);
                                 this.My_time = null;
                              }
                              this.my_docIP = 100;
                              SetCureAllInfo.SetCureDortorOut();
                           }
                           if(this.my_petIP != 100)
                           {
                              if(Boolean(this.Pet_time))
                              {
                                 GC.clearGTimeout(this.Pet_time);
                                 this.Pet_time = null;
                              }
                              this.my_petIP = 100;
                              SetCureAllInfo.SetCureInvalidOut();
                           }
                        }
                        
                        private function OnePetOn(eve:EventTaomee) : void
                        {
                           var obj:Object = eve.EventObj.obj;
                           this.Info_arr[obj.IP].Invalid_id = obj.Invalid_id;
                           GC.clearAllChildren(this.depth_mc["mc_" + obj.IP].emp_mc);
                           this.botton_mc["btn_" + obj.IP].visible = false;
                           var msg:String = "";
                           var PeopleMC:MovieClip = this.getNowPeople(obj.Invalid_id);
                           if(obj.Invalid_id == LocalUserInfo.getUserID())
                           {
                              this.removeMyAlt();
                              this.Pet_time = GC.setGTimeout(this.NoDocPetUP,60000);
                           }
                           PeopleMC.petmc.visible = false;
                           PeopleMC.avatarMC.pet_mc.visible = false;
                           if(PeopleMC.PetSick == 0)
                           {
                              if(Boolean(PeopleManageView(PeopleMC).lamuinfo.hasSkillAvatar()))
                              {
                                 msg = "pet" + PeopleMC.Petlevel + "_" + PeopleManageView(PeopleMC).lamuinfo.skill_learnType;
                              }
                              else
                              {
                                 msg = "pet" + PeopleMC.Petlevel;
                              }
                           }
                           else if(Boolean(PeopleManageView(PeopleMC).lamuinfo.hasSkillAvatar()))
                           {
                              msg = "pet" + PeopleMC.Petlevel + "_" + PeopleManageView(PeopleMC).lamuinfo.skill_learnType + "_" + PeopleMC.PetSick;
                           }
                           else
                           {
                              msg = "pet" + PeopleMC.Petlevel + "_" + PeopleMC.PetSick;
                           }
                           this.AddNewMC(msg,obj.IP);
                           var PetMC:* = this.getAddNewMC(msg,obj.IP);
                           this.setPetColor(PetMC.petBody,PeopleMC.PetColor);
                           if(this.Info_arr[obj.IP].Doctor_id == LocalUserInfo.getUserID())
                           {
                              this.removeMyAlt();
                              this.OnePetOn_obj = this.Info_arr[obj.IP];
                              this.OnePetOn_obj.IP = obj.IP;
                              this.myAlt = Alert.showAlert(this.AllAlt_MC,this._URL + "009.swf","    你要為這隻可愛的小拉姆治療了嗎？記得要先確診好病症，再進行治療哦！",Alert.CHANG_ALERT,"getReady,nextCome",true,false,"SMCUI");
                              BC.addEvent(this,this.myAlt,Alert.CLICK_ + "1",this.StopWorkToDoc);
                              BC.addEvent(this,this.myAlt,Alert.CLICK_ + "2",this.MissDortor);
                           }
                           if(this.Info_arr[obj.IP].Doctor_id != 0)
                           {
                              if(Boolean(this.Pet_time))
                              {
                                 GC.clearGTimeout(this.Pet_time);
                                 this.Pet_time = null;
                              }
                              this.AddNewMC("one_sick",obj.IP);
                              this.depth_mc["mc_" + obj.IP].Doc_mc.gotoAndStop(2);
                           }
                           else
                           {
                              this.depth_mc["mc_" + obj.IP].Doc_mc.gotoAndStop(3);
                           }
                        }
                        
                        private function OnePetUP(eve:EventTaomee) : void
                        {
                           var obj:Object = eve.EventObj.obj;
                           var PeopleMC:MovieClip = this.getNowPeople(obj.Invalid_id);
                           PeopleMC.petmc.visible = true;
                           PeopleMC.avatarMC.pet_mc.visible = true;
                           GC.clearAllChildren(this.depth_mc["mc_" + obj.IP].emp_mc);
                           this.botton_mc["btn_" + obj.IP].visible = false;
                           if(obj.Invalid_id == LocalUserInfo.getUserID())
                           {
                              this.removeMyAlt();
                              this.my_petIP = 100;
                              if(Boolean(this.Pet_time))
                              {
                                 GC.clearGTimeout(this.Pet_time);
                                 this.Pet_time = null;
                              }
                           }
                           this.Info_arr[obj.IP].Invalid_id = 0;
                           if(this.Info_arr[obj.IP].Doctor_id == LocalUserInfo.getUserID())
                           {
                              this.removeMyAlt();
                              if(Boolean(this.My_time))
                              {
                                 GC.clearGTimeout(this.My_time);
                                 this.My_time = null;
                              }
                              var _temp_4:* = BC;
                              var _temp_3:* = this;
                              var _temp_2:* = this.myAlt;
                              var _temp_1:* = Alert.CLICK_ + "1";
                              with({})
                              {
                                 
                                 _temp_4.addEvent(_temp_3,_temp_2,_temp_1,function StopDocToWork(eve:Event):void
                                 {
                                    BC.removeEvent(this,myAlt,Alert.CLICK_ + "1",StopDocToWork);
                                    myAlt = null;
                                    var _temp_1:* = GC;
                                    with({})
                                    {
                                       My_time = _temp_1.setGTimeout(function NoPetDocUP():void
                                       {
                                          SetCureAllInfo.SetCureDortorWork();
                                       },60000);
                                    });
                                    BC.addEvent(this,this.myAlt,Alert.CLICK_ + "2",this.MissDortor);
                                 }
                                 if(this.Info_arr[obj.IP].Doctor_id != 0)
                                 {
                                    this.depth_mc["mc_" + obj.IP].Doc_mc.gotoAndStop(2);
                                 }
                                 else
                                 {
                                    this.depth_mc["mc_" + obj.IP].Doc_mc.gotoAndStop(1);
                                 }
                              }
                              
                              private function OneDocOn(eve:EventTaomee) : void
                              {
                                 /*
                                  * Decompilation error
                                  * Code may be obfuscated
                                  * Tip: You can try enabling "Deobfuscate code" option in Settings
                                  * Error type: IndexOutOfBoundsException (Index -1 out of bounds for length 0)
                                  */
                                 throw new flash.errors.IllegalOperationError("Not decompiled due to error");
                              }
                              
                              private function OneDocUP(eve:EventTaomee) : void
                              {
                                 var PetMC:MovieClip = null;
                                 var obj:Object = eve.EventObj.obj;
                                 this.depth_mc["mc_" + obj.IP].Doc_mc.gotoAndStop(1);
                                 this.botton_mc["btn_" + obj.IP].visible = false;
                                 GC.clearAllChildren(this.depth_mc["mc_" + obj.IP].emp_mc);
                                 var PeopleMC:MovieClip = this.getNowPeople(obj.Doctor_id);
                                 if(obj.Doctor_id == LocalUserInfo.getUserID())
                                 {
                                    this.removeMyAlt();
                                    this.my_docIP = 100;
                                    if(Boolean(this.My_time))
                                    {
                                       GC.clearGTimeout(this.My_time);
                                       this.My_time = null;
                                    }
                                    MoveTo.AutoFind(300,400,PeopleMC);
                                 }
                                 if(this.Info_arr[obj.IP].Invalid_id != 0)
                                 {
                                    PetMC = this.getNowPeople(this.Info_arr[obj.IP].Invalid_id);
                                    PetMC.petmc.visible = true;
                                    PetMC.avatarMC.pet_mc.visible = true;
                                 }
                                 if(this.Info_arr[obj.IP].Invalid_id == LocalUserInfo.getUserID())
                                 {
                                    this.removeMyAlt();
                                    this.my_petIP = 100;
                                    if(Boolean(this.Pet_time))
                                    {
                                       GC.clearGTimeout(this.Pet_time);
                                       this.Pet_time = null;
                                    }
                                    this.myAlt = Alert.showAlert(this.AllAlt_MC,this._URL + "007.swf","    很遺憾！正在治療的拉姆救治師離開了。不過沒有關係，你可以再換個病床等待，也可以去配藥間看看哦！",Alert.CHANG_ALERT,"iknow",true,false,"SMCUI");
                                    this.myAlt = null;
                                 }
                                 this.Info_arr[obj.IP].Doctor_id = 0;
                                 this.Info_arr[obj.IP].Invalid_id = 0;
                              }
                              
                              private function OneDocOneJob(eve:EventTaomee) : void
                              {
                                 var temp:* = undefined;
                                 var msg:String = null;
                                 var obj:Object = eve.EventObj.obj;
                                 var one_obj:Object = this.Info_arr[obj.IP];
                                 var petMC:MovieClip = this.getNowPeople(one_obj.Invalid_id);
                                 if(one_obj.Doctor_id == LocalUserInfo.getUserID())
                                 {
                                    this.removeMyAlt();
                                    temp = this.depth_mc["mc_" + obj.IP].emp_mc.getChildByName("Btn_mc");
                                    temp.gotoAndStop(uint(petMC.PetSick) + 2);
                                    this.RemoveNewMC("one_sick",obj.IP);
                                    this.My_time = GC.setGTimeout(this.MissDortor,10000);
                                    BC.addEvent(this,this.botton_mc["btn_" + obj.IP],MouseEvent.CLICK,this.DocTwoWork);
                                 }
                                 else if(one_obj.Invalid_id != 0)
                                 {
                                    this.RemoveNewMC("one_sick",obj.IP);
                                    msg = "sick_" + petMC.PetSick;
                                    this.AddNewMC(msg,obj.IP);
                                 }
                              }
                              
                              private function OneDocTwoJob(eve:EventTaomee) : void
                              {
                                 var msgs:String = null;
                                 var money_num:uint = 0;
                                 var msg:String = null;
                                 var url:String = null;
                                 var obj:Object = eve.EventObj.obj;
                                 var one_obj:Object = this.Info_arr[obj.IP];
                                 this.depth_mc["mc_" + obj.IP].Doc_mc.gotoAndStop(1);
                                 GC.clearAllChildren(this.depth_mc["mc_" + obj.IP].emp_mc);
                                 this.botton_mc["btn_" + obj.IP].visible = false;
                                 var PeopleMC:MovieClip = this.getNowPeople(obj.Doctor_id);
                                 var petMC:MovieClip = this.getNowPeople(one_obj.Invalid_id);
                                 petMC.petmc.visible = true;
                                 petMC.avatarMC.pet_mc.visible = true;
                                 one_obj.Doctor_name = PeopleMC.nickName;
                                 one_obj.Invalid_name = petMC.nickName;
                                 this.JobOK_arr.push(one_obj);
                                 this.showJobOKUI();
                                 if(obj.Doctor_id == LocalUserInfo.getUserID())
                                 {
                                    this.removeMyAlt();
                                    this.my_doc_flag = 0;
                                    this.my_docIP = 100;
                                    if(Boolean(this.My_time))
                                    {
                                       GC.clearGTimeout(this.My_time);
                                       this.My_time = null;
                                    }
                                    MoveTo.AutoFind(300,400,PeopleMC);
                                    msgs = "    你真棒！“" + petMC.nickName + "(" + one_obj.Invalid_id + ")”的拉姆經過你的治療後變得非常健康，你真是一位技術高超的拉姆救治師啊！獎勵你" + obj.Money + "摩爾豆，已放入你的百寶箱中。要再接再厲哦！";
                                    this.myAlt = Alert.showAlert(this.AllAlt_MC,this._URL + "009.swf",msgs,Alert.CHANG_ALERT,"iknow",true,false,"SMCUI");
                                    this.myAlt = null;
                                    money_num = LocalUserInfo.getYXQ() + obj.Money;
                                    LocalUserInfo.setYXQ(money_num);
                                 }
                                 if(one_obj.Invalid_id == LocalUserInfo.getUserID())
                                 {
                                    this.removeMyAlt();
                                    this.my_petIP = 100;
                                    if(Boolean(this.Pet_time))
                                    {
                                       GC.clearGTimeout(this.Pet_time);
                                       this.Pet_time = null;
                                    }
                                    msg = "";
                                    url = this._URL + "005.swf";
                                    if(petMC.PetSick == 0)
                                    {
                                       msg = "     哈哈，你的拉姆患沒有得病哦！為了以防萬一，救治師“" + PeopleMC.nickName + "(" + obj.Doctor_id + ")”幫它打了預防針。記得要好好照看它哦！";
                                       url = this._URL + "006.swf";
                                    }
                                    else
                                    {
                                       msg = "     哈哈！經過救治師“" + PeopleMC.nickName + "(" + obj.Doctor_id + ")”的診治，你的小拉姆已經完全康復啦！回家以後也要記得好好休息哦！";
                                    }
                                    this.myAlt = Alert.showAlert(this.AllAlt_MC,url,msg,Alert.CHANG_ALERT,"iknow",true,false,"SMCUI");
                                    this.myAlt = null;
                                 }
                                 petMC.PetSick = 0;
                                 this.Info_arr[obj.IP].Doctor_id = 0;
                                 this.Info_arr[obj.IP].Invalid_id = 0;
                              }
                              
                              private function getWorkMoney(eve:EventTaomee) : void
                              {
                                 var money:uint = 0;
                                 var msg:String = null;
                                 var money_num:uint = 0;
                                 var PeopleMC:MovieClip = null;
                                 var obj:Object = eve.EventObj.obj;
                                 this.depth_mc["mc_" + obj.IP].Doc_mc.gotoAndStop(1);
                                 this.botton_mc["btn_" + obj.IP].visible = false;
                                 if(obj.Doctor_id == LocalUserInfo.getUserID())
                                 {
                                    this.removeMyAlt();
                                    if(Boolean(this.My_time))
                                    {
                                       GC.clearGTimeout(this.My_time);
                                       this.My_time = null;
                                       this.my_docIP = 100;
                                    }
                                    money = uint(obj.Money);
                                    msg = "感謝你今天的認真值班，作為獎勵，" + money + "摩爾豆已經放入你的百寶箱了！快去看看吧！";
                                    this.showAltOKFun(msg);
                                    money_num = LocalUserInfo.getYXQ() + eve.EventObj.obj.Money;
                                    LocalUserInfo.setYXQ(money_num);
                                    PeopleMC = this.getNowPeople(LocalUserInfo.getUserID());
                                    MoveTo.AutoFind(300,400,PeopleMC);
                                 }
                                 this.Info_arr[obj.IP].Doctor_id = 0;
                              }
                              
                              private function StopWorkToDoc(eve:Event) : void
                              {
                                 BC.removeEvent(this,this.myAlt,Alert.CLICK_ + "1",this.StopWorkToDoc);
                                 this.myAlt = null;
                                 if(Boolean(this.My_time))
                                 {
                                    GC.clearGTimeout(this.My_time);
                                    this.My_time = null;
                                 }
                                 this.my_doc_flag = 1;
                                 var Cla:Class = GV.Lib_Map.getClass("Btn_mc") as Class;
                                 var mc:MovieClip = new Cla();
                                 mc.name = "Btn_mc";
                                 mc.IP = this.OnePetOn_obj.IP;
                                 mc.gotoAndStop(1);
                                 mc.buttonMode = true;
                                 mc.x = -55;
                                 mc.y = -120;
                                 this.depth_mc["mc_" + this.OnePetOn_obj.IP].emp_mc.addChild(mc);
                                 this.botton_mc["btn_" + this.OnePetOn_obj.IP].visible = true;
                                 this.My_time = GC.setGTimeout(this.MissDortor,10000);
                                 BC.addEvent(this,this.botton_mc["btn_" + this.OnePetOn_obj.IP],MouseEvent.CLICK,this.DocOneWork);
                                 var _Class:Class = GV.Lib_Map.getClass("doctor_UI") as Class;
                                 var _mc:MovieClip = new _Class();
                                 _mc.name = "doctor_UI_mc";
                                 _mc.x = 50;
                                 _mc.y = -80;
                                 this.depth_mc["mc_" + this.OnePetOn_obj.IP].emp_mc.addChild(_mc);
                              }
                              
                              private function DocOneWork(eve:MouseEvent) : void
                              {
                                 /*
                                  * Decompilation error
                                  * Code may be obfuscated
                                  * Tip: You can try enabling "Deobfuscate code" option in Settings
                                  * Error type: IndexOutOfBoundsException (Index -1 out of bounds for length 0)
                                  */
                                 throw new flash.errors.IllegalOperationError("Not decompiled due to error");
                              }
                              
                              private function DocTwoWork(eve:MouseEvent) : void
                              {
                                 /*
                                  * Decompilation error
                                  * Code may be obfuscated
                                  * Tip: You can try enabling "Deobfuscate code" option in Settings
                                  * Error type: IndexOutOfBoundsException (Index -1 out of bounds for length 0)
                                  */
                                 throw new flash.errors.IllegalOperationError("Not decompiled due to error");
                              }
                              
                              private function AddNewMC(msg:String, IP:uint) : void
                              {
                                 var Cla:Class = GV.Lib_Map.getClass(msg) as Class;
                                 var mc:MovieClip = new Cla();
                                 mc.name = msg;
                                 this.depth_mc["mc_" + IP].emp_mc.addChild(mc);
                              }
                              
                              private function RemoveNewMC(msg:String, IP:uint) : void
                              {
                                 var temp:* = this.depth_mc["mc_" + IP].emp_mc.getChildByName(msg);
                                 this.depth_mc["mc_" + IP].emp_mc.removeChild(temp);
                                 temp = null;
                              }
                              
                              private function getAddNewMC(msg:String, IP:uint) : *
                              {
                                 var MC:* = null;
                                 if(Boolean(this.depth_mc["mc_" + IP].emp_mc.getChildByName(msg)))
                                 {
                                    MC = this.depth_mc["mc_" + IP].emp_mc.getChildByName(msg);
                                 }
                                 return MC;
                              }
                              
                              private function getNowPeople(ID:uint) : MovieClip
                              {
                                 var MC:MovieClip = null;
                                 if(ID == LocalUserInfo.getUserID())
                                 {
                                    MC = GV.MAN_PEOPLE;
                                 }
                                 else
                                 {
                                    MC = GF.getPeopleByID(ID);
                                 }
                                 return MC;
                              }
                              
                              private function removeMyAlt() : void
                              {
                                 GC.clearAllChildren(this.AllAlt_MC);
                              }
                              
                              private function showAltFun(msg:String) : void
                              {
                                 Alert.showAlert(this.AllAlt_MC,msg,"",Alert.CHANG_ALERT,"iknow",true,false,"D");
                              }
                              
                              private function showAltOKFun(msg:String) : void
                              {
                                 Alert.showAlert(this.AllAlt_MC,msg,"",Alert.CHANG_ALERT,"iknow",true,false,"E");
                              }
                              
                              private function setPetColor(mc:*, colorNum:*) : void
                              {
                                 var _array:Array = null;
                                 try
                                 {
                                    _array = GV["petColor_" + colorNum];
                                    mc.transform.colorTransform = new ColorTransform(_array[0],_array[1],_array[2],_array[3],_array[4],_array[5],_array[6],_array[7]);
                                 }
                                 catch(E:TypeError)
                                 {
                                 }
                              }
                              
                              private function AltErrorFun(eve:EventTaomee) : void
                              {
                                 var PeopleMC:MovieClip = null;
                                 var PetMC:MovieClip = null;
                                 var IP:int = int(eve.EventObj.ID);
                                 var msg:String = "";
                                 var url:String = this._URL + "007.swf";
                                 switch(IP)
                                 {
                                    case -100013:
                                       msg = "已經在其它病床上坐下了哦！";
                                       this.showAltFun(msg);
                                       break;
                                    case -100014:
                                       msg = "抱歉這個位置已經有人\r換別的位置試試？";
                                       this.showAltFun(msg);
                                       break;
                                    case -100015:
                                       msg = "抱歉這個位置已經有人\r換別的位置試試？";
                                       this.showAltFun(msg);
                                       break;
                                    case -100016:
                                       msg = "    你真是位充滿愛心的救治師啊！今天的工作已經完成啦，你可以回去好好休息，明天再來。也可以繼續義務為小拉姆治療哦！";
                                       this.myAlt = Alert.showAlert(this.AllAlt_MC,url,msg,Alert.CHANG_ALERT,"iknow",true,false,"SMCUI");
                                       this.myAlt = null;
                                       break;
                                    case -100017:
                                       return;
                                    case -100018:
                                       return;
                                 }
                                 var obj:Object = null;
                                 if(this.my_docIP != 100)
                                 {
                                    obj = this.Info_arr[this.my_docIP];
                                    obj.IP = this.my_docIP;
                                    this.my_docIP = 100;
                                 }
                                 else if(this.my_petIP != 100)
                                 {
                                    obj = this.Info_arr[this.my_petIP];
                                    obj.IP = this.my_petIP;
                                    this.my_petIP = 100;
                                 }
                                 if(obj == null)
                                 {
                                    return;
                                 }
                                 var one_obj:Object = this.Info_arr[obj.IP];
                                 this.depth_mc["mc_" + obj.IP].Doc_mc.gotoAndStop(1);
                                 this.botton_mc["btn_" + obj.IP].visible = false;
                                 GC.clearAllChildren(this.depth_mc["mc_" + obj.IP].emp_mc);
                                 if(obj.Doctor_id == LocalUserInfo.getUserID())
                                 {
                                    PeopleMC = this.getNowPeople(obj.Doctor_id);
                                    if(Boolean(this.My_time))
                                    {
                                       GC.clearGTimeout(this.My_time);
                                       this.My_time = null;
                                    }
                                    MoveTo.AutoFind(300,400,PeopleMC);
                                    if(this.Info_arr[obj.IP].Invalid_id != 0)
                                    {
                                       PetMC = this.getNowPeople(this.Info_arr[obj.IP].Invalid_id);
                                       PetMC.petmc.visible = true;
                                       PetMC.avatarMC.pet_mc.visible = true;
                                    }
                                 }
                                 if(obj.Invalid_id == LocalUserInfo.getUserID())
                                 {
                                    if(Boolean(this.Pet_time))
                                    {
                                       GC.clearGTimeout(this.Pet_time);
                                       this.Pet_time = null;
                                    }
                                    PetMC = this.getNowPeople(obj.Invalid_id);
                                    PetMC.petmc.visible = true;
                                    PetMC.avatarMC.pet_mc.visible = true;
                                 }
                                 this.Info_arr[obj.IP].Doctor_id = 0;
                                 this.Info_arr[obj.IP].Invalid_id = 0;
                              }
                              
                              private function showJobOKUI() : void
                              {
                                 if(this.JobOK_arr.length > 4)
                                 {
                                    this.JobOK_arr.shift();
                                 }
                                 var linkTxt:TextField = this.target_mc.Job_over_mc.doc_txt;
                                 linkTxt.addEventListener(TextEvent.LINK,this.linkHandler);
                                 linkTxt.htmlText = "";
                                 for(var i:uint = 0; i < this.JobOK_arr.length; i++)
                                 {
                                    linkTxt.htmlText += "治療師" + this.createLink(this.JobOK_arr[i].Doctor_id,this.JobOK_arr[i].Doctor_name) + "治癒了" + this.createLink(this.JobOK_arr[i].Invalid_id,this.JobOK_arr[i].Invalid_name) + "的拉姆。<br />";
                                 }
                              }
                              
                              private function createLink(url:String, text:String) : String
                              {
                                 var link:String = "";
                                 return link + ("<font color=\'#0000FF\'>" + "<a href=\'event:" + url + "\'>" + text + "</a>" + "</font>");
                              }
                              
                              private function linkHandler(e:TextEvent) : void
                              {
                                 if(int(e.text) < 100)
                                 {
                                    return;
                                 }
                                 userPanelView.showUserPanel(int(e.text));
                              }
                              
                              public function removeAllFun(eve:* = null) : void
                              {
                                 BC.removeEvent(this);
                                 this.OnePetOn_obj = null;
                                 GC.clearAllChildren(this.AllAlt_MC);
                                 var MC:* = MainManager.getAppLevel().getChildByName("Alt_mc");
                                 MainManager.getAppLevel().removeChild(MC);
                                 MC = null;
                                 this.AllAlt_MC = null;
                                 this.myAlt = null;
                                 this.my_petIP = 100;
                                 this.my_docIP = 100;
                                 this.my_doc_flag = 0;
                                 if(Boolean(this.Pet_time))
                                 {
                                    GC.clearGTimeout(this.Pet_time);
                                    this.Pet_time = null;
                                 }
                                 if(Boolean(this.My_time))
                                 {
                                    GC.clearGTimeout(this.My_time);
                                    this.My_time = null;
                                 }
                              }
                           }
                        }
                        
                        