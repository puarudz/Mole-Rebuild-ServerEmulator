package com.logic.JobLogic
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.global.staticData.MapsConfig;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.logic.socket.PKsocket.GameKingSocket;
   import com.logic.socket.getSceneUserInfo.GetSceneUserInfoReq;
   import com.logic.socket.lookBag.LookBagReq;
   import com.logic.socket.lookBag.LookBagRes;
   import com.logic.socket.task.TaskChangeProtocol;
   import com.logic.socket.task.TaskGetListProtocol;
   import com.module.ListSMC.conSMC;
   import com.module.deal.Deal;
   import com.mole.app.task.Task;
   import com.mole.app.task.TaskManager;
   import org.taomee.bean.BaseBean;
   
   public class JobLogic extends BaseBean
   {
      
      public static var rescueStatus:uint;
      
      private static var _inst:JobLogic;
      
      public static var hasgot190645:Boolean;
      
      public static var got180065:Boolean;
      
      public static var bagArray:Array = new Array();
      
      public static var integralArr:Array = new Array();
      
      public static var nowJobList:Array = new Array();
      
      public static var one_arr:Array = new Array();
      
      public static var two_arr:Array = new Array();
      
      public static var three_arr:Array = new Array();
      
      public static var four_arr:Array = new Array();
      
      public static var five_arr:Array = new Array();
      
      public static var six_arr:Array = new Array();
      
      public static var seven_arr:Array = new Array();
      
      public static var eight_arr:Array = new Array();
      
      public static var nine_arr:Array = new Array();
      
      public static var ten_arr:Array = new Array();
      
      public static var eleven_arr:Array = new Array();
      
      private static var _other_arr:Array = new Array();
      
      public static var JOBLIST:String = "joblist";
      
      public static var CHANGlISTOVER:String = "changList_over";
      
      public static var ONLYJOBLIST:String = "only_joblist";
      
      public static var BAGOTHERLIST:String = "bagOtherlist";
      
      public static var NOJOB:String = "noJob";
      
      public static var ALLJOB:String = "allJob";
      
      public static var HEREINFO:String = "hereinfo";
      
      public static var CHARTNOWJOBARR:String = "chartNowJob_arr";
      
      public static var maps_arr:Array = [105,14,45,113];
      
      public static var hasGoneMap84:uint = 0;
      
      public static var fishCloth_flag:Boolean = false;
      
      public var lookBagClass:LookBagReq;
      
      public var controlClass:conSMC;
      
      public var GetSceneUserInfoReqs:GetSceneUserInfoReq;
      
      private var smcFlag:uint = 4;
      
      public var chartNowGoods_num:Array = new Array();
      
      public var chartJobOver_type:int = 0;
      
      private var myObj:Object = {
         0:0,
         1:1,
         2:2,
         3:3,
         4:4,
         5:5,
         6:6,
         7:7,
         8:8,
         9:9,
         "a":10,
         "b":11,
         "c":12,
         "d":13,
         "e":14,
         "f":15
      };
      
      private var myMoreBag_arr:Array = [190034];
      
      private var no_OnlyJobID_arr:Array = [{
         "ID":171,
         "Num":[3,5,1]
      },{
         "ID":58,
         "Num":[0,0,0,0,0,0,0,0,0,0]
      }];
      
      public function JobLogic()
      {
         super();
         _inst = this;
      }
      
      public static function get inst() : JobLogic
      {
         return _inst;
      }
      
      public static function get other_arr() : Array
      {
         return _other_arr;
      }
      
      override public function start() : void
      {
         GV.PetJobLogics = new PetJobLogic();
         this.lookBagClass = new LookBagReq();
         this.init();
         finish();
      }
      
      public function init() : void
      {
         this.controlClass = new conSMC();
         this.controlClass.addEventListener(conSMC.ALLDATE,this.backHereInfoJob);
         this.controlClass.init();
         BC.addEvent(this,GV.onlineSocket,"build_over",this.build_overHandler);
      }
      
      private function build_overHandler(e:EventTaomee) : void
      {
         var task221State:uint = 0;
         GV.MAN_PEOPLE.visible = true;
         if(Boolean(e.EventObj.flag))
         {
            task221State = TaskManager.getTaskState(221);
            if(task221State == 2)
            {
               got180065 = true;
            }
            else if(task221State == 1)
            {
               Deal.BuyItem(190645,1,function(ItemnID:uint):void
               {
                  hasgot190645 = true;
               });
            }
         }
      }
      
      private function backHereInfoJob(event:EventTaomee) : void
      {
         this.controlClass.removeEventListener(conSMC.ALLDATE,this.backHereInfoJob);
         one_arr = conSMC.oneList_arr;
         two_arr = conSMC.twoList_arr;
         three_arr = conSMC.threeList_arr;
         four_arr = conSMC.fourList_arr;
         five_arr = conSMC.fiveList_arr;
         six_arr = conSMC.sixList_arr;
         seven_arr = conSMC.sevenList_arr;
         eight_arr = conSMC.eightList_arr;
         nine_arr = conSMC.nineList_arr;
         ten_arr = conSMC.tenList_arr;
         eleven_arr = conSMC.eleven_arr;
         _other_arr = conSMC.otherList_arr;
      }
      
      public function sandJob(type:Number = 0) : void
      {
         TaskGetListProtocol.send(LocalUserInfo.getUserID());
      }
      
      public function changJobList(id:int, state:int = 0) : void
      {
         var task:Task = TaskManager.getTask(id);
         TaskChangeProtocol.send(id,state);
      }
      
      public function sandBeg(type:int = 128) : void
      {
         this.lookBagClass.lookBag(LocalUserInfo.getUserID(),type,0);
         GV.onlineSocket.addEventListener(LookBagRes.BAG_OVER,this.getBagList);
      }
      
      public function getBagList(evt:* = null) : void
      {
         GV.onlineSocket.removeEventListener(LookBagRes.BAG_OVER,this.getBagList);
         var bagObj:Object = evt.EventObj.obj;
         bagArray = bagObj.arr;
         GV.onlineSocket.dispatchEvent(new EventTaomee(BAGOTHERLIST,{"obj":bagObj}));
      }
      
      public function sandGame() : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + 1462,this.mygamelist);
         GameKingSocket.usergamelist(LocalUserInfo.getUserID());
      }
      
      private function mygamelist(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1462,this.mygamelist);
         var bagObj:Object = evt.EventObj;
         integralArr = bagObj.arr;
         GV.onlineSocket.dispatchEvent(new EventTaomee(BAGOTHERLIST,{"obj":bagObj}));
      }
      
      public function findJobTaskStatus(a:int) : int
      {
         var task:Task = TaskManager.getTask(a);
         if(Boolean(task))
         {
            return task.state;
         }
         return 0;
      }
      
      public function findJobArr(p:int) : Object
      {
         var k:uint = 0;
         var myArr:Object = new Object();
         if(p >= 24 && p <= 130)
         {
            for(k = 0; k < _other_arr.length; k++)
            {
               if(p == _other_arr[k].TaskID)
               {
                  myArr = _other_arr[k];
                  break;
               }
            }
         }
         else if(p > 170)
         {
            for(k = 0; k < _other_arr.length; k++)
            {
               if(p == _other_arr[k].TaskID)
               {
                  myArr = _other_arr[k];
                  break;
               }
            }
         }
         else if(p > 130 && p < 141)
         {
            myArr = four_arr[p - 131];
         }
         else if(p > 140 && p < 151)
         {
            myArr = seven_arr[p - 141];
         }
         else if(p > 150 && p < 161)
         {
            myArr = five_arr[p - 151];
         }
         else if(p > 160 && p < 171)
         {
            myArr = six_arr[p - 161];
         }
         else if(p > 220 && p < 221)
         {
            myArr = eight_arr[p - 221];
         }
         else if(p >= 16)
         {
            myArr = three_arr[p - 16];
         }
         else if(p >= 8)
         {
            myArr = two_arr[p - 8];
         }
         else
         {
            myArr = one_arr[p];
         }
         return myArr;
      }
      
      public function chartbagClothFun(p:*, _arr:Array = null) : Boolean
      {
         var ia:int = 0;
         var all_num:int = 0;
         var pp:* = undefined;
         var i:int = 0;
         var a:int = 0;
         var myBoolean:Boolean = false;
         var clothArray:Array = LocalUserInfo.getClothItem();
         if(Boolean(_arr))
         {
            clothArray = _arr;
         }
         var arr:Array = new Array();
         if(clothArray != arr)
         {
            for(ia = 0; ia < p.length; ia++)
            {
               all_num = 0;
               pp = p[ia];
               for(i = 0; i < clothArray.length; i++)
               {
                  for(a = 0; a < pp.length; a++)
                  {
                     if(clothArray[i].id == pp[a])
                     {
                        all_num += 1;
                     }
                  }
               }
               if(all_num == pp.length)
               {
                  myBoolean = true;
               }
            }
         }
         return myBoolean;
      }
      
      public function getJobName(myNum:uint) : String
      {
         return GoodsInfo.ClothObject[myNum];
      }
      
      public function chartUnusualCloth(clothArr:Array = null) : int
      {
         var myNum:int = 0;
         var clothArray:Array = clothArr != null ? clothArr : LocalUserInfo.getClothItem();
         clothArray = clothArray.slice(0);
         clothArray.sortOn("layer",16);
         while(Boolean(clothArray[0]) && clothArray[0].layer < 5)
         {
            clothArray.shift();
         }
         var tempArray:Array = new Array();
         for(var i:int = 0; i < clothArray.length; i++)
         {
            tempArray.push(clothArray[i].id);
         }
         tempArray.sort();
         var str:String = String(tempArray);
         if(Boolean(clothArray.length) && GoodsInfo.ClothObject[str] != null)
         {
            myNum = int(GoodsInfo.ClothObject[str]);
         }
         return myNum;
      }
      
      public function chartItemIDCloth(itemID:uint) : Boolean
      {
         var mole:* = GV.GF.getPeopleByID(LocalUserInfo.getUserID());
         if(!mole)
         {
            return false;
         }
         var myNum:Boolean = false;
         var clothArray:Array = GV.MAN_PEOPLE.clothsArray;
         clothArray = clothArray.slice(0);
         clothArray.sortOn("layer",16);
         var tempArray:Array = new Array();
         for(var i:int = 0; i < clothArray.length; i++)
         {
            tempArray.push(int(clothArray[i].id));
         }
         tempArray.sort();
         if(Boolean(clothArray.length) && tempArray.indexOf(itemID) > -1)
         {
            myNum = true;
         }
         return myNum;
      }
      
      public function chartgameFun(p:*, s:int) : Boolean
      {
         var b:int = 0;
         var myBoolean:Boolean = false;
         var arr:Array = new Array();
         if(integralArr != arr)
         {
            for(b = 0; b < integralArr.length; b++)
            {
               if(integralArr[b].GameID == p && integralArr[b].GameScore >= s)
               {
                  myBoolean = true;
               }
            }
         }
         return myBoolean;
      }
      
      public function chartbagFun(p:*) : Boolean
      {
         var b:int = 0;
         var myBoolean:Boolean = false;
         var arr:Array = new Array();
         if(bagArray != arr)
         {
            for(b = 0; b < bagArray.length; b++)
            {
               if(bagArray[b].id == p)
               {
                  myBoolean = true;
               }
            }
         }
         return myBoolean;
      }
      
      public function chartNowJobArr(id:int) : void
      {
         var pp:* = undefined;
         var i:int = 0;
         var ic:int = 0;
         var chartNowJob_nums:int = id;
         if(Boolean(MainManager.getAppLevel().getChildByName("smcListMC")))
         {
            pp = MainManager.getAppLevel().getChildByName("smcListMC");
            MainManager.getAppLevel().removeChild(pp);
         }
         var JobInfo:Object = this.findJobArr(chartNowJob_nums);
         JobInfo.TaskStatus = TaskManager.getTaskState(chartNowJob_nums);
         var arr:Array = JobInfo.goods.split(";");
         this.chartNowGoods_num = null;
         this.chartNowGoods_num = new Array();
         this.chartNowGoods_num = arr;
         GV.nowJob_Arr = null;
         GV.nowJob_Arr = new Array();
         if(JobInfo.TaskStatus == 0)
         {
            for(i = 0; i < arr.length; i++)
            {
               GV.nowJob_Arr.push(0);
            }
         }
         else if(JobInfo.TaskStatus == 1)
         {
            GV.onlineSocket.addEventListener(GetItemCountRes.GET_ITEMCOUNT,this.chartGoodsFun);
            this.chartNowGoodsFun();
         }
         else if(JobInfo.TaskStatus == 2)
         {
            for(ic = 0; ic < 4; ic++)
            {
               GV.nowJob_Arr.push(1);
            }
         }
      }
      
      public function chartNowGoodsFun(ip:int = 0) : void
      {
         var a:* = this.chartNowGoods_num[ip];
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),a,2);
      }
      
      public function chartGoodsFun(e:*) : void
      {
         var ip:uint = 0;
         var ip_ID:uint = 0;
         var obj:Object = e.EventObj.obj;
         if(GV.nowJob_Arr.length < this.chartNowGoods_num.length)
         {
            ip = GV.nowJob_Arr.length;
            ip_ID = uint(this.chartNowGoods_num[ip]);
            if(obj.Count == 0)
            {
               GV.nowJob_Arr.push(0);
            }
            else if(obj.arr[0].itemCount == 1 && this.chartItemIDCloth(ip_ID) && ip_ID == 12018)
            {
               GV.nowJob_Arr.push(0);
            }
            else if(obj.arr[0].itemCount > 0)
            {
               GV.nowJob_Arr.push(1);
            }
            else
            {
               GV.nowJob_Arr.push(0);
            }
         }
         if(GV.nowJob_Arr.length >= this.chartNowGoods_num.length)
         {
            GV.onlineSocket.removeEventListener(GetItemCountRes.GET_ITEMCOUNT,this.chartGoodsFun);
            GV.onlineSocket.dispatchEvent(new EventTaomee(CHARTNOWJOBARR,{"arr":GV.nowJob_Arr}));
         }
         else
         {
            this.chartNowGoodsFun(GV.nowJob_Arr.length);
         }
      }
      
      public function chartNewJobArr(id:uint) : void
      {
         this.chartNowGoods_num = null;
         this.chartNowGoods_num = new Array();
         this.chartNowGoods_num.push(id);
         GV.onlineSocket.addEventListener(BAGOTHERLIST,this.chartNewGoodsBack);
         this.sandBeg(128);
      }
      
      private function chartNewGoodsBack(event:EventTaomee) : void
      {
         var goods_info:Object = null;
         var b:int = 0;
         var c:uint = 0;
         GV.onlineSocket.removeEventListener(BAGOTHERLIST,this.chartNewGoodsBack);
         var ID:uint = uint(this.chartNowGoods_num[0]);
         var JobInfo:Object = this.findJobArr(ID);
         JobInfo.TaskStatus = TaskManager.getTaskState(ID);
         var goods_arr:Array = JobInfo.goods.split(";");
         var count_arr:Array = [];
         this.chartNowGoods_num = new Array();
         for(var a:uint = 0; a < goods_arr.length; a++)
         {
            this.chartNowGoods_num.push(0);
            count_arr.push(0);
         }
         for(var i:uint = 0; i < this.no_OnlyJobID_arr.length; i++)
         {
            if(this.no_OnlyJobID_arr[i].ID == ID)
            {
               goods_info = this.no_OnlyJobID_arr[i];
               break;
            }
         }
         if(bagArray.length > 0)
         {
            for(b = 0; b < bagArray.length; b++)
            {
               for(c = 0; c < goods_arr.length; c++)
               {
                  if(bagArray[b].id == goods_arr[c])
                  {
                     if(bagArray[b].itemCount >= goods_info.Num[c])
                     {
                        this.chartNowGoods_num[c] = 1;
                     }
                     count_arr[c] = bagArray[b].itemCount;
                  }
               }
            }
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(CHARTNOWJOBARR,{
            "arr":this.chartNowGoods_num,
            "num":count_arr
         }));
      }
      
      public function chartRandom(num:int) : Boolean
      {
         var ap:int = int(Math.random() * 100);
         if(ap < num)
         {
            return true;
         }
         return false;
      }
      
      public function checkLen(txt:String) : int
      {
         var testSTR:String = null;
         var strNum:int = 0;
         var L:int = txt.length;
         for(var i:int = 0; i < L; i++)
         {
            testSTR = txt.slice(i,i + 1);
            if(testSTR.charCodeAt(0) > 130)
            {
               strNum += 2;
            }
            else
            {
               strNum++;
            }
         }
         return strNum;
      }
      
      public function getPrimitiveColors(colorStr:String) : Array
      {
         var tempStr:String = null;
         var A:String = null;
         var B:String = null;
         var a:String = colorStr;
         if(a.indexOf("#") > -1)
         {
            a = a.slice(1);
         }
         while(a.length < 6)
         {
            a = "0" + a;
         }
         a = a.toLocaleLowerCase();
         var tempArray:Array = [];
         for(var i:uint = 0; i < 6; i += 2)
         {
            tempStr = a.substr(i,2);
            A = tempStr.substr(0,1);
            B = tempStr.substr(1,1);
            tempArray.push(this.myObj[A] * 16 + this.myObj[B]);
         }
         return tempArray;
      }
      
      public function havePetFollow() : Boolean
      {
         var petObj:Object = GV.GF.getPeopleObj(GV.MyInfo_userID);
         if(Boolean(petObj != null) && Boolean(petObj.PetID) || GV.MAN_PEOPLE.Petlevel > 0)
         {
            return true;
         }
         return false;
      }
      
      public function isNumber(aa:String) : Boolean
      {
         var bb:* = undefined;
         var num:int = aa.length;
         for(var i:int = 0; i < num; i++)
         {
            bb = aa.substr(i,1);
            if(bb >= 0 && bb != " ")
            {
               return false;
            }
         }
         return true;
      }
      
      public function getMapName(ID:uint) : String
      {
         return MapsConfig.MapsInfo[ID.toString()]["note"];
      }
   }
}

