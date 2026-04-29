package com.logic.JobLogic
{
   import com.event.EventTaomee;
   import com.logic.socket.petClass.ListItem.GetPetClassReq;
   import com.logic.socket.petClass.ListItem.GetPetClassRes;
   import com.logic.socket.petSocket.keepPet.petKeepNumReq;
   import com.logic.socket.petSocket.keepPet.petKeepNumRes;
   import com.logic.socket.petSocket.learnPet.AllLearnListReq;
   import com.logic.socket.petSocket.learnPet.AllLearnListRes;
   import com.logic.socket.petSocket.learnPet.BeginLearnReq;
   import com.logic.socket.petSocket.learnPet.BeginLearnRes;
   import com.logic.socket.petSocket.learnPet.OneLearnListReq;
   import com.logic.socket.petSocket.learnPet.OneLearnListRes;
   import com.logic.socket.petSocket.learnPet.OverLearnReq;
   import com.logic.socket.petSocket.learnPet.OverLearnRes;
   import com.logic.socket.petSocket.learnPet.StopLearnReq;
   import com.logic.socket.petSocket.learnPet.StopLearnRes;
   import com.module.pet.PetJobXML;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   public class PetJobLogic extends EventDispatcher
   {
      
      public static var MyPets:Object;
      
      public static var MyPets_arr:Array;
      
      public static var GETPETCLASSXML:String = "gethere_petclass_xml";
      
      public static var ALLSTUDYINGNUM:String = "allstudy_petnum";
      
      public static var GETMYALLPETISCLASS:String = "allpet_class_flag";
      
      public static var RECAPTPETRESULT:String = "recapteOne_petResult";
      
      public static var BEGINPETRESULT:String = "beginOne_petResult";
      
      public static var OVERONERESULT:String = "overOne_petResult";
      
      public static var MAKEONEALLINFO:String = "makeOne_allclass_info";
      
      public static var CHARTONEALLINFO:String = "chartOne_allclass_info";
      
      public static var ONEPETCLASSFLAG:String = "onepet_class_flag";
      
      public static var ONEPETONECLATEST:String = "onepet_oneclass_testflag";
      
      public static var ARRPETCLASSFLAG:String = "arrpet_class_flag";
      
      public var allClass_num:uint = 16;
      
      private var Lel_list:Array = [[16,15,14,13,1,12],[16,15,14,13,1,2,12],[16,15,14,13,1,2,11,12],[16,15,14,13,1,2,11,12],[16]];
      
      public var class_arr:Array;
      
      public var nowPet_info:Object;
      
      public var MyTest:Object;
      
      public var testCla_arr:Array;
      
      private var NowPetClass_Obj:Object;
      
      public function PetJobLogic(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public function LoadPetClassXML() : void
      {
         var PetJobXMLs:PetJobXML = new PetJobXML();
         BC.addEvent(this,PetJobXMLs,PetJobXML.ALLDATE,this.LoadXMLBack);
      }
      
      public function LoadXMLBack(event:EventTaomee) : void
      {
         BC.removeEvent(this);
         this.class_arr = event.EventObj.CLASS_arr;
         var myObj:Object = {"arr":this.class_arr};
         dispatchEvent(new EventTaomee(GETPETCLASSXML,myObj));
      }
      
      public function GetAllStuding() : void
      {
         BC.addEvent(this,GV.onlineSocket,petKeepNumRes.GOODS_NUM_SUCC,this.BackAllStuding);
         petKeepNumReq.sendReq(1);
      }
      
      public function BackAllStuding(event:EventTaomee) : void
      {
         var All_Lamu:uint = 0;
         BC.removeEvent(this,GV.onlineSocket,petKeepNumRes.GOODS_NUM_SUCC,this.BackAllStuding);
         if(event.EventObj.Type == 1)
         {
            All_Lamu = uint(event.EventObj.Num);
         }
         var myObj:Object = {"num":All_Lamu};
         dispatchEvent(new EventTaomee(ALLSTUDYINGNUM,myObj));
      }
      
      public function GetOneClassList(petObj:Object) : void
      {
         this.nowPet_info = null;
         this.nowPet_info = petObj;
         BC.addEvent(this,GV.onlineClass,OneLearnListRes.ONEPETLEARNLIST,this.BackOneClassList);
         OneLearnListReq.getOneList(petObj.PetID,1,this.allClass_num,0);
      }
      
      public function BackOneClassList(event:EventTaomee) : void
      {
         var i:uint = 0;
         var j:uint = 0;
         var llg:uint = 0;
         var showlg:uint = 0;
         var ii:uint = 0;
         var k:uint = 0;
         BC.removeEvent(this,GV.onlineClass,OneLearnListRes.ONEPETLEARNLIST,this.BackOneClassList);
         var back_obj:Object = event.EventObj.Allobj;
         var one:Object = new Object();
         var pet_lel:uint = uint(this.nowPet_info.Petlevel);
         var back_list:Array = [];
         var list:Array = [];
         var lg:uint = 0;
         var makeArr:Array = [];
         var mesClassArr:Array = [];
         var showArr:Array = [];
         if(pet_lel == 1)
         {
            this.nowPet_info.ClassList = "no";
         }
         else if(back_obj.Cnt == 0)
         {
            if(pet_lel < 101)
            {
               list = this.Lel_list[pet_lel - 2];
            }
            else
            {
               list = this.Lel_list[uint(this.Lel_list.length - 1)];
            }
            lg = list.length;
            for(i = 0; i < lg; i++)
            {
               one = this.class_arr[list[i]];
               if(one.Type != "no")
               {
                  makeArr.push(one);
               }
               else
               {
                  mesClassArr.push(one);
               }
            }
            if(mesClassArr[0] != undefined)
            {
               showArr.push(mesClassArr[0]);
            }
            makeArr = makeArr.concat(showArr);
            this.nowPet_info.ClassList = makeArr;
         }
         else
         {
            back_list = back_obj.Arr;
            if(pet_lel < 101)
            {
               list = this.Lel_list[pet_lel - 2];
            }
            else
            {
               list = this.Lel_list[uint(this.Lel_list.length - 1)];
            }
            lg = list.length;
            for(j = 0; j < lg; j++)
            {
               one = this.class_arr[list[j]];
               for(k = 0; k < back_list.length; k++)
               {
                  if(one.CLASSID == back_list[k].ClassID)
                  {
                     one.Flag = back_list[k].Status;
                     one.FlagDays = back_list[k].Days;
                     one.LeaveDays = uint(one.AllDays - one.FlagDays);
                  }
               }
               if(one.Type != "no")
               {
                  makeArr.push(one);
               }
               else
               {
                  mesClassArr.push(one);
               }
            }
            llg = mesClassArr.length;
            showlg = 0;
            for(ii = 0; ii < llg; ii++)
            {
               if(mesClassArr[ii].Flag == 3)
               {
                  showlg = ii + 2;
                  break;
               }
               if(mesClassArr[ii].FlagDays < mesClassArr[ii].AllDays)
               {
                  showlg = ii + 1;
                  break;
               }
            }
            showArr = mesClassArr.slice(0,showlg);
            makeArr = makeArr.concat(showArr);
            this.nowPet_info.ClassList = makeArr;
         }
         var myObj:Object = {"obj":this.nowPet_info};
         dispatchEvent(new EventTaomee(MAKEONEALLINFO,myObj));
      }
      
      public function GetOneClassInfo(PetID:uint, beginID:uint, lastID:uint, status:uint) : void
      {
         BC.addEvent(this,GV.onlineClass,OneLearnListRes.ONEPETLEARNLIST,this.BackOneClassInfo);
         trace("PetID,beginID,lastID,status",PetID,beginID,lastID,status);
         OneLearnListReq.getOneList(PetID,beginID,lastID,status);
      }
      
      public function BackOneClassInfo(event:EventTaomee) : void
      {
         var lg:uint = 0;
         var back_list:Array = null;
         var next_ip:uint = 0;
         var p:uint = 0;
         var k:uint = 0;
         BC.removeEvent(this,GV.onlineClass,OneLearnListRes.ONEPETLEARNLIST,this.BackOneClassInfo);
         var back_obj:Object = event.EventObj.Allobj;
         var myObj:Object = {"obj":back_obj};
         dispatchEvent(new EventTaomee(ONEPETCLASSFLAG,myObj));
         if(MyPets_arr.length > 0)
         {
            lg = MyPets_arr.length;
            back_list = [];
            next_ip = 0;
            for(p = 0; p < lg; p++)
            {
               if(back_obj.PetID == MyPets_arr[p].petID)
               {
                  next_ip = p;
                  if(back_obj.Cnt == 0)
                  {
                     MyPets_arr[p].Flag = 0;
                     MyPets_arr[p].Flag_arr = [];
                  }
                  else
                  {
                     back_list = back_obj.Arr;
                     for(k = 0; k < back_list.length; k++)
                     {
                        if(back_list[k].Status == 3)
                        {
                           MyPets_arr[p].Flag = back_list[k].ClassID;
                           MyPets_arr[p].Flag_arr.push(back_list[k].ClassID);
                        }
                     }
                  }
                  break;
               }
            }
            this.BeginChart(next_ip + 1);
         }
      }
      
      public function SetOnePetBeginClass(petID:uint, classID:uint, days:uint) : void
      {
         BC.addEvent(this,GV.onlineClass,BeginLearnRes.SETPETCLASS,this.BackOneBeginResult);
         var arr:Array = [{
            "petID":petID,
            "classID":classID,
            "days":days
         }];
         BeginLearnReq.setClass(arr);
      }
      
      public function BackOneBeginResult(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineClass,BeginLearnRes.SETPETCLASS,this.BackOneBeginResult);
         dispatchEvent(new EventTaomee(BEGINPETRESULT));
      }
      
      public function GetAllPetClass() : void
      {
         BC.addEvent(this,GV.onlineClass,AllLearnListRes.PET_ALL_CLASS,this.BackAllPetClass);
         AllLearnListReq.getAllPet();
      }
      
      public function BackAllPetClass(event:EventTaomee) : void
      {
         var myObj:Object = null;
         var obj:Object = null;
         BC.removeEvent(this,GV.onlineClass,AllLearnListRes.PET_ALL_CLASS,this.BackAllPetClass);
         myObj = event.EventObj.obj;
         if(myObj.Num == 0)
         {
            obj = {"myObj":myObj};
            dispatchEvent(new EventTaomee(GETMYALLPETISCLASS,obj));
         }
         else
         {
            obj = {"myObj":myObj};
            dispatchEvent(new EventTaomee(GETMYALLPETISCLASS,obj));
         }
      }
      
      public function SetPetBackHome(arr:Array) : void
      {
         BC.addEvent(this,GV.onlineClass,StopLearnRes.SOTPPETCLASS,this.BackRecapteResult);
         StopLearnReq.StopOneClass(arr);
      }
      
      public function BackRecapteResult(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineClass,StopLearnRes.SOTPPETCLASS,this.BackRecapteResult);
         dispatchEvent(new EventTaomee(RECAPTPETRESULT));
      }
      
      public function SetOverOneClass(Arr:Array) : void
      {
         BC.addEvent(this,GV.onlineClass,OverLearnRes.OVERONEPETCLASS,this.BackOverResult);
         OverLearnReq.overOneClass(Arr);
      }
      
      public function BackOverResult(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineClass,OverLearnRes.OVERONEPETCLASS,this.BackOverResult);
         dispatchEvent(new EventTaomee(OVERONERESULT));
      }
      
      public function chartMsgClass(arr:Array, classIDArr:Array) : void
      {
         var one:Object = null;
         this.removeHereInfo();
         MyPets.classIDArr = classIDArr;
         var lg:uint = arr.length;
         for(var i:uint = 0; i < lg; i++)
         {
            one = {
               "petID":arr[i],
               "Flag":0
            };
            MyPets_arr.push(one);
            MyPets_arr[i].Flag_arr = [];
         }
         this.BeginChart();
      }
      
      public function BeginChart(num:uint = 0) : void
      {
         var obj:Object = null;
         if(num < MyPets_arr.length)
         {
            this.GetOneClassInfo(MyPets_arr[num].petID,MyPets.classIDArr[0],MyPets.classIDArr[MyPets.classIDArr.length - 1],0);
         }
         else
         {
            obj = {"arr":MyPets_arr};
            dispatchEvent(new EventTaomee(ARRPETCLASSFLAG,obj));
         }
      }
      
      public function chartNowClassTest(petIDs:uint, classIDs:uint) : void
      {
         this.removeHereInfo();
         this.MyTest = {
            "petID":petIDs,
            "classID":classIDs
         };
         var PetJobXMLs:PetJobXML = new PetJobXML();
         BC.addEvent(this,PetJobXMLs,PetJobXML.ALLDATE,this.testLoadXMLBack);
      }
      
      public function testLoadXMLBack(event:EventTaomee) : void
      {
         BC.removeEvent(this);
         this.testCla_arr = event.EventObj.CLASS_arr;
         BC.addEvent(this,GV.onlineClass,OneLearnListRes.ONEPETLEARNLIST,this.BeginMakeTest);
         OneLearnListReq.getOneList(this.MyTest.petID,this.MyTest.classID,this.MyTest.classID,0);
      }
      
      public function BeginMakeTest(event:EventTaomee) : void
      {
         var Bln:Boolean = false;
         BC.removeEvent(this,GV.onlineClass,OneLearnListRes.ONEPETLEARNLIST,this.BeginMakeTest);
         var back_obj:Object = event.EventObj.Allobj;
         var arr:Object = this.testCla_arr[back_obj.Arr[0].ClassID];
         if(back_obj.Days == arr.AllDays && back_obj.Arr[0].Status != 3)
         {
            Bln = true;
         }
         var obj:Object = {"result":Bln};
         dispatchEvent(new EventTaomee(ONEPETONECLATEST,obj));
      }
      
      public function chartNowPetClass(petID:uint) : void
      {
         this.removeHereInfo();
         BC.addEvent(this,GV.onlineClass,OneLearnListRes.ONEPETLEARNLIST,this.BackChartOneClassList);
         OneLearnListReq.getOneList(petID,1,this.allClass_num,0);
      }
      
      public function BackChartOneClassList(event:EventTaomee) : void
      {
         var Arr:Array = null;
         var lg:uint = 0;
         var i:uint = 0;
         BC.removeEvent(this,GV.onlineClass,OneLearnListRes.ONEPETLEARNLIST,this.BackChartOneClassList);
         var allDays_arr:Array = [];
         allDays_arr[1] = allDays_arr[11] = allDays_arr[12] = 7;
         allDays_arr[2] = allDays_arr[15] = 14;
         var back_obj:Object = event.EventObj.Allobj;
         if(back_obj.Cnt > 0)
         {
            Arr = back_obj.Arr;
            lg = Arr.length;
            for(i = 0; i < lg; i++)
            {
               Arr[i].AllDays = allDays_arr[Arr[i].ClassID];
            }
         }
         else
         {
            back_obj.Cnt = 0;
            back_obj.Arr = [];
         }
         this.NowPetClass_Obj = back_obj;
         BC.addEvent(this,GV.onlineSocket,GetPetClassRes.GET_CLASS,this.getAddPetClass);
         GetPetClassReq.GetPetClass(back_obj.PetID,101,104);
      }
      
      private function getAddPetClass(eve:EventTaomee) : void
      {
         var i:uint = 0;
         var obj:Object = null;
         BC.removeEvent(this,GV.onlineSocket,GetPetClassRes.GET_CLASS,this.getAddPetClass);
         var arr:Array = eve.EventObj.petClass;
         if(arr[0] != null)
         {
            for(i = 0; i < arr.length; i++)
            {
               obj = {};
               obj.ClassID = arr[i].classID;
               if(arr[i].classStep > 0 && arr[i].classStep < 6)
               {
                  obj.Status = 1;
               }
               else if(arr[i].classStep == 6)
               {
                  obj.Status = 2;
               }
               else if(arr[i].classStep == 0)
               {
                  obj.Status = 0;
               }
               obj.Days = 0;
               obj.classStep = arr[i].classStep;
               obj.arr = arr[i].arr;
               this.NowPetClass_Obj.Arr.push(obj);
            }
         }
         this.NowPetClass_Obj.Cnt += this.NowPetClass_Obj.Arr.length;
         dispatchEvent(new EventTaomee(CHARTONEALLINFO,{"obj":this.NowPetClass_Obj}));
      }
      
      private function removeHereInfo() : void
      {
         MyPets_arr = [];
         this.testCla_arr = [];
         MyPets = null;
         this.MyTest = null;
         MyPets = new Object();
         this.MyTest = new Object();
      }
   }
}

