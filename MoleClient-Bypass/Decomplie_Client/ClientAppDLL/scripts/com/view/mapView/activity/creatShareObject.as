package com.view.mapView.activity
{
   import com.mole.net.MoleSharedObject;
   import flash.net.SharedObject;
   
   public class creatShareObject
   {
      
      private static var instance:creatShareObject;
      
      public var jobLogic1:int = 0;
      
      public var jobLogic2:int = 0;
      
      public var jobLogic4:int = 0;
      
      public var jobLogic6:int = 0;
      
      public var jobLogic8:Array = [false,false,false];
      
      public var jobLogic9:int = 0;
      
      public var jobLogic11:int = 0;
      
      public var jobLogic12:int = 0;
      
      public var jobLogic13:int = 0;
      
      public var jobLogic14:Array = [false,false];
      
      private var lahuWood:String;
      
      public var currentDay:int;
      
      public var jobCount:int;
      
      public var bearCurrentDay:int;
      
      public var bearJobCount:int;
      
      public function creatShareObject()
      {
         super();
      }
      
      public static function getInstance() : creatShareObject
      {
         if(instance == null)
         {
            instance = new creatShareObject();
         }
         return instance;
      }
      
      public function getShareObject() : SharedObject
      {
         return MoleSharedObject.moleSO;
      }
      
      public function getClickChineseNewYear() : Number
      {
         if(this.getShareObject().data.ClickChineseNewYear == null)
         {
            this.getShareObject().data.ClickChineseNewYear = 0;
         }
         return this.getShareObject().data.ClickChineseNewYear;
      }
      
      public function setClickChineseNewYear(sign:Number) : void
      {
         this.getShareObject().data.ClickChineseNewYear = sign;
      }
      
      public function getPuzzlesTimer() : Number
      {
         if(this.getShareObject().data.puzzlesTimer == null)
         {
            this.getShareObject().data.puzzlesTimer = 0;
         }
         return this.getShareObject().data.puzzlesTimer;
      }
      
      public function setPuzzlesTimer(sign:Number) : void
      {
         this.getShareObject().data.puzzlesTimer = sign;
      }
      
      public function getIsHomeQiShiOver() : int
      {
         if(this.getShareObject().data.isHomeQiShiOver == null)
         {
            this.getShareObject().data.isHomeQiShiOver = 0;
         }
         return this.getShareObject().data.isHomeQiShiOver;
      }
      
      public function setIsHomeQiShiOver(sign:int) : void
      {
         this.getShareObject().data.isHomeQiShiOver = sign;
      }
      
      public function getDepression() : int
      {
         if(this.getShareObject().data.Depression == null)
         {
            this.getShareObject().data.Depression = 0;
         }
         return this.getShareObject().data.Depression;
      }
      
      public function setDepression(sign:int) : void
      {
         this.getShareObject().data.Depression = sign;
      }
      
      public function getDepression182() : int
      {
         if(this.getShareObject().data.Depression182 == null)
         {
            this.getShareObject().data.Depression182 = 0;
         }
         return this.getShareObject().data.Depression182;
      }
      
      public function setDepression182(sign:int) : void
      {
         this.getShareObject().data.Depression182 = sign;
      }
      
      public function getEDTask42() : int
      {
         if(this.getShareObject().data.EDTask42 == null)
         {
            this.getShareObject().data.EDTask42 = 0;
         }
         return this.getShareObject().data.EDTask42;
      }
      
      public function setEDTask42(sign:int) : void
      {
         this.getShareObject().data.EDTask42 = sign;
      }
      
      public function getFoodMenuCurrentPage() : int
      {
         if(this.getShareObject().data.foodMenuCurrentPage == null)
         {
            this.getShareObject().data.foodMenuCurrentPage = 0;
         }
         return this.getShareObject().data.foodMenuCurrentPage;
      }
      
      public function setFoodMenuCurrentPage(sign:int) : void
      {
         this.getShareObject().data.foodMenuCurrentPage = sign;
      }
      
      public function getMiller() : int
      {
         if(this.getShareObject().data.isMiller == null)
         {
            this.getShareObject().data.isMiller = 0;
         }
         return this.getShareObject().data.isMiller;
      }
      
      public function setMiller(sign:int) : void
      {
         this.getShareObject().data.isMiller = sign;
      }
      
      public function getBearCurrentDay() : int
      {
         if(this.getShareObject().data.bearCurrentDay == null)
         {
            this.getShareObject().data.bearCurrentDay = 0;
         }
         return this.getShareObject().data.bearCurrentDay;
      }
      
      public function setBearCurrentDay(day:int) : void
      {
         this.getShareObject().data.bearCurrentDay = day;
      }
      
      public function getBearJobCount() : int
      {
         if(this.getShareObject().data.bearJobCount == null)
         {
            this.getShareObject().data.bearJobCount = 0;
         }
         return this.getShareObject().data.bearJobCount;
      }
      
      public function setBearJobCount(count:int) : void
      {
         this.getShareObject().data.bearJobCount = count;
      }
      
      public function getMedal37() : int
      {
         if(this.getShareObject().data.medal37 == null)
         {
            this.getShareObject().data.medal37 = 5;
         }
         return this.getShareObject().data.medal37;
      }
      
      public function setMedal37(tempNum:int) : void
      {
         this.getShareObject().data.medal37 = tempNum;
      }
      
      public function getMedal77() : int
      {
         if(this.getShareObject().data.medal77 == null)
         {
            this.getShareObject().data.medal77 = 5;
         }
         return this.getShareObject().data.medal77;
      }
      
      public function setMedal77(tempNum:int) : void
      {
         this.getShareObject().data.medal77 = tempNum;
      }
      
      public function getMedal3() : int
      {
         if(this.getShareObject().data.medal3 == null)
         {
            this.getShareObject().data.medal3 = 5;
         }
         return this.getShareObject().data.medal3;
      }
      
      public function setMedal3(tempNum:int) : void
      {
         this.getShareObject().data.medal3 = tempNum;
      }
      
      public function getMedal8() : int
      {
         if(this.getShareObject().data.medal8 == null)
         {
            this.getShareObject().data.medal8 = 5;
         }
         return this.getShareObject().data.medal8;
      }
      
      public function setMedal8(tempNum:int) : void
      {
         this.getShareObject().data.medal8 = tempNum;
      }
      
      public function getMedal10() : int
      {
         if(this.getShareObject().data.medal10 == null)
         {
            this.getShareObject().data.medal10 = 5;
         }
         return this.getShareObject().data.medal10;
      }
      
      public function setMedal10(tempNum:int) : void
      {
         this.getShareObject().data.medal10 = tempNum;
      }
      
      public function getHotCupBackShow() : int
      {
         if(this.getShareObject().data.hotCupBackShow == null)
         {
            this.getShareObject().data.hotCupBackShow = 0;
         }
         return this.getShareObject().data.hotCupBackShow;
      }
      
      public function setHotCupBackShow() : void
      {
         this.getShareObject().data.hotCupBackShow = 1;
      }
      
      public function getLahuWood() : String
      {
         return this.lahuWood;
      }
      
      public function setLahuWood(temp:String) : void
      {
         this.lahuWood = temp;
      }
      
      public function get42ch() : int
      {
         if(this.getShareObject().data.ch == null)
         {
            this.getShareObject().data.ch = 0;
         }
         return this.getShareObject().data.ch;
      }
      
      public function set42ch(temp:int) : void
      {
         this.getShareObject().data.ch = temp;
      }
      
      public function get59SL() : int
      {
         if(this.getShareObject().data.chSL == null)
         {
            this.getShareObject().data.chSL = 0;
         }
         return this.getShareObject().data.chSL;
      }
      
      public function set59SL(temp:int) : void
      {
         this.getShareObject().data.chSL = temp;
      }
      
      public function getGuiGuiJi() : int
      {
         if(this.getShareObject().data.gaigaiji == null)
         {
            this.getShareObject().data.gaigaiji = 0;
         }
         return this.getShareObject().data.gaigaiji;
      }
      
      public function setGuiGuiJi(temp:int) : void
      {
         this.getShareObject().data.gaigaiji = temp;
      }
      
      public function getLeavesSuccess() : int
      {
         if(this.getShareObject().data.leavesSuccess == null)
         {
            this.getShareObject().data.leavesSuccess = 0;
         }
         return this.getShareObject().data.leavesSuccess;
      }
      
      public function setLeavesSuccess(temp:int) : void
      {
         this.getShareObject().data.leavesSuccess = temp;
      }
      
      public function getTryMachine() : Object
      {
         if(this.getShareObject().data.tryMachine == null)
         {
            this.getShareObject().data.tryMachine = {
               "AbcStr":"",
               "AbcArr":[],
               "UserArr":[],
               "islai":false
            };
         }
         return this.getShareObject().data.tryMachine;
      }
      
      public function setTryMachine(temp:Object) : void
      {
         this.getShareObject().data.tryMachine = temp;
      }
      
      public function getCurrentDay() : int
      {
         if(this.getShareObject().data.currentDay == null)
         {
            this.getShareObject().data.currentDay = 0;
         }
         return this.getShareObject().data.currentDay;
      }
      
      public function setCurrentDay(day:int) : void
      {
         this.getShareObject().data.currentDay = day;
      }
      
      public function getJobCount() : int
      {
         if(this.getShareObject().data.jobCount == null)
         {
            this.getShareObject().data.jobCount = 0;
         }
         return this.getShareObject().data.jobCount;
      }
      
      public function setJobCount(count:int) : void
      {
         this.getShareObject().data.jobCount = count;
      }
      
      public function getEnglishFlag() : int
      {
         if(this.getShareObject().data.englishFlag == null)
         {
            this.getShareObject().data.englishFlag = false;
         }
         return this.getShareObject().data.englishFlag;
      }
      
      public function setEnglishFlag(flag:Boolean) : void
      {
         this.getShareObject().data.englishFlag = flag;
      }
      
      public function getJoinGhostHouseSign() : int
      {
         if(this.getShareObject().data.JGHSign == null)
         {
            this.getShareObject().data.JGHSign = 0;
         }
         return this.getShareObject().data.JGHSign;
      }
      
      public function setJoinGhostHouseSign(temp:int) : void
      {
         this.getShareObject().data.JGHSign = temp;
      }
      
      public function getJackIDHouseSign() : int
      {
         if(this.getShareObject().data.JackGHSign == null)
         {
            this.getShareObject().data.JackGHSign = 0;
         }
         return this.getShareObject().data.JackGHSign;
      }
      
      public function setJackIDHouseSign(temp:int) : void
      {
         this.getShareObject().data.JackGHSign = temp;
      }
      
      public function getLastHelper() : Object
      {
         return this.getShareObject().data.lastHelper;
      }
      
      public function setLastHelper(temp:Object) : void
      {
         this.getShareObject().data.lastHelper = temp;
      }
      
      public function getIsGetSeed() : uint
      {
         if(this.getShareObject().data.isGetSeed == null)
         {
            this.getShareObject().data.isGetSeed = 0;
         }
         return this.getShareObject().data.isGetSeed;
      }
      
      public function setIsGetSeed(temp:int) : void
      {
         this.getShareObject().data.isGetSeed = temp;
      }
      
      public function getMapMCPlay() : uint
      {
         if(this.getShareObject().data.mcPlayNum == null)
         {
            this.getShareObject().data.mcPlayNum = 0;
         }
         return this.getShareObject().data.mcPlayNum;
      }
      
      public function setMapMCPlay(temp:int) : void
      {
         this.getShareObject().data.mcPlayNum = temp;
      }
      
      public function getMap123MCPlay() : uint
      {
         if(this.getShareObject().data.mc123PlayNum == null)
         {
            this.getShareObject().data.mc123PlayNum = 0;
         }
         return this.getShareObject().data.mc123PlayNum;
      }
      
      public function setMap123MCPlay(temp:int) : void
      {
         this.getShareObject().data.mc123PlayNum = temp;
      }
      
      public function getIsGiveMiller() : uint
      {
         if(this.getShareObject().data.isGiveMiller == null)
         {
            this.getShareObject().data.isGiveMiller = 0;
         }
         return this.getShareObject().data.isGiveMiller;
      }
      
      public function setIsGiveMiller(temp:int) : void
      {
         this.getShareObject().data.isGiveMiller = temp;
      }
      
      public function getCollectViewEdition() : uint
      {
         if(this.getShareObject().data.CollectViewEdition == null)
         {
            this.getShareObject().data.CollectViewEdition = 0;
         }
         return this.getShareObject().data.CollectViewEdition;
      }
      
      public function setCollectViewEdition(temp:int) : void
      {
         this.getShareObject().data.CollectViewEdition = temp;
      }
      
      public function getLastJobID() : uint
      {
         if(this.getShareObject().data.LastJobID == null)
         {
            this.getShareObject().data.LastJobID = 0;
         }
         return this.getShareObject().data.LastJobID;
      }
      
      public function setLastJobID(id:uint) : void
      {
         this.getShareObject().data.LastJobID = id;
      }
      
      public function getTask125Num() : uint
      {
         if(this.getShareObject().data.Task125Num == null)
         {
            this.getShareObject().data.Task125Num = 0;
         }
         return this.getShareObject().data.Task125Num;
      }
      
      public function setTask125Num(id:uint) : void
      {
         this.getShareObject().data.Task125Num = id;
      }
      
      public function getMapUse() : uint
      {
         if(this.getShareObject().data.MapUse == null)
         {
            this.getShareObject().data.MapUse = 0;
         }
         return this.getShareObject().data.MapUse;
      }
      
      public function setMapUse(id:uint) : void
      {
         this.getShareObject().data.MapUse = id;
      }
      
      public function getSportInfo() : uint
      {
         if(this.getShareObject().data.SportInfo == null)
         {
            this.getShareObject().data.SportInfo = 0;
         }
         return this.getShareObject().data.SportInfo;
      }
      
      public function setSportInfo(id:uint) : void
      {
         this.getShareObject().data.SportInfo = id;
      }
      
      public function getBtnUse() : uint
      {
         if(this.getShareObject().data.BtnUse == null)
         {
            this.getShareObject().data.BtnUse = 0;
         }
         return this.getShareObject().data.BtnUse;
      }
      
      public function setBtnUse(id:uint) : void
      {
         this.getShareObject().data.BtnUse = id;
      }
      
      public function getSaveLubi() : Array
      {
         if(this.getShareObject().data.saveLubi as Array == null)
         {
            this.getShareObject().data.saveLubi = new Array();
         }
         return this.getShareObject().data.saveLubi;
      }
      
      public function setSaveLubi(petID:uint) : void
      {
         this.getShareObject().data.saveLubi.push(petID);
      }
      
      public function setMoleTips(date:Date) : void
      {
         var obj:Object = this.getShareObject().data.moleTips;
         obj.year = date.getFullYear();
         obj.day = date.getDay();
         obj.month = date.getMonth();
      }
      
      public function getMoleTips() : Object
      {
         var obj:Object = null;
         if(this.getShareObject().data.moleTips == null)
         {
            obj = this.getShareObject().data.moleTips = new Object();
            obj.year = 0;
            obj.day = 0;
            obj.month = 0;
         }
         return this.getShareObject().data.moleTips;
      }
      
      public function getMonsterObj() : Object
      {
         var obj:Object = null;
         if(this.getShareObject().data.monster == null)
         {
            obj = this.getShareObject().data.monster = new Object();
            obj.index = 1;
         }
         return this.getShareObject().data.monster;
      }
      
      public function setMonsterObj(obj:Object) : void
      {
         this.getShareObject().data.monster = obj;
      }
      
      public function getDiaoxiang() : Date
      {
         return this.getShareObject().data.diaoxiang;
      }
      
      public function setDiaoxiang(b:Date) : void
      {
         this.getShareObject().data.diaoxiang = b;
      }
      
      public function setOpenFristLibao(d:Date) : void
      {
         this.getShareObject().data.libaoDate = d.time;
      }
      
      public function getOpenFristLibao() : Date
      {
         if(this.getShareObject().data.libaoDate == null)
         {
            return null;
         }
         return new Date(this.getShareObject().data.libaoDate);
      }
      
      public function setPlayTask284(flag:int) : void
      {
         this.getShareObject().data.PlayTask284 = flag;
      }
      
      public function getPlayTask284() : int
      {
         if(this.getShareObject().data.PlayTask284 == null)
         {
            return 0;
         }
         return this.getShareObject().data.PlayTask284;
      }
      
      public function setPlayTask240(flag:int) : void
      {
         this.getShareObject().data.PlayTask240 = flag;
      }
      
      public function getPlayTask240() : int
      {
         if(this.getShareObject().data.PlayTask240 == null)
         {
            return 0;
         }
         return this.getShareObject().data.PlayTask240;
      }
      
      public function setPlayTask240int(flag:int) : void
      {
         this.getShareObject().data.PlayTask240int = flag;
      }
      
      public function getPlayTask240int() : int
      {
         if(this.getShareObject().data.PlayTask240int == null)
         {
            return 0;
         }
         return this.getShareObject().data.PlayTask240int;
      }
      
      public function setTaotaoLe(flag:int) : void
      {
         this.getShareObject().data.TaotaoLe = flag;
      }
      
      public function getTaotaoLe() : int
      {
         if(this.getShareObject().data.TaotaoLe == null)
         {
            return 0;
         }
         return this.getShareObject().data.TaotaoLe;
      }
      
      public function setNoteData(flag:int) : void
      {
         this.getShareObject().data.NoteData = flag;
      }
      
      public function getNoteData() : int
      {
         if(this.getShareObject().data.NoteData == null)
         {
            return 0;
         }
         return this.getShareObject().data.NoteData;
      }
      
      public function getLoadAngelFightCur() : int
      {
         if(this.getShareObject().data.LoadAngelFightCur == null)
         {
            return 1;
         }
         return this.getShareObject().data.LoadAngelFightCur;
      }
      
      public function setLoadAngelFightCur(value:int) : void
      {
         this.getShareObject().data.LoadAngelFightCur = value;
      }
      
      public function getLoadAngelFightTol() : Array
      {
         if(this.getShareObject().data.LoadAngelFightTol == null)
         {
            this.getShareObject().data.LoadAngelFightTol = [];
         }
         return this.getShareObject().data.LoadAngelFightTol;
      }
      
      public function setIsDance(flag:Boolean = true) : void
      {
         this.getShareObject().data.isDance = flag;
      }
      
      public function getIsDance() : Boolean
      {
         return this.getShareObject().data.isDance;
      }
      
      public function setLoadAngelFightTol(id:int, flag:Boolean) : void
      {
         var arr:Array = this.getLoadAngelFightTol();
         if(arr == null)
         {
            arr = [];
         }
         var ind:int = arr.indexOf(id);
         var f:Boolean = false;
         if(ind == -1)
         {
            if(flag)
            {
               f = true;
               arr.push(id);
            }
         }
         else if(!flag)
         {
            f = true;
            arr.splice(ind,1);
         }
         if(f)
         {
            this.getShareObject().data.LoadAngelFightTol = arr;
         }
      }
   }
}

