package com.module.pet
{
   import com.module.house.petXML;
   import com.module.newHouse.newHouseView;
   import com.module.npc.lamu.I_LamuNPC;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.*;
   
   public class petStatus
   {
      
      public static var POEM:Array = ["哈,哈,嘿，菩提校長有三奇，聽我慢慢說詳細","第一奇，屋子裡面都是寶，真的總比假的少","第二奇，帽子底下有秘密，頭發蓋不住頭皮","第三奇，滿嘴都是大道理，其實一點不稀奇"];
      
      private var PETMC:MovieClip;
      
      private var PETINFO:Object;
      
      private var Interval:uint = 0;
      
      private var poeminterval:uint = 0;
      
      private var poemIndex:uint = 0;
      
      private var statusArr:Array = new Array();
      
      private var firstBool:Boolean = true;
      
      private var timer:Timer;
      
      private var gotoRan:uint;
      
      private var wordmc:*;
      
      private var saying:Boolean;
      
      public function petStatus(mc:MovieClip)
      {
         super();
         var ran:Number = Math.random();
         POEM = ["我們每天在成長","小小腳印來記錄","要問腳印在哪裡","時報可要看仔細"];
         this.PETMC = mc;
      }
      
      public function clearStatusInterval() : void
      {
         if(this.Interval != 0)
         {
            clearInterval(this.Interval);
         }
      }
      
      public function changeStatus(info:Object) : void
      {
         this.PETINFO = info;
         this.clearStatusInterval();
         if(this.PETINFO.Flag == 2)
         {
            this.statusDeath();
            return;
         }
         if(this.PETMC.LanLevel > 0 || this.PETMC.level > 100)
         {
            if(GF.BT(this.PETINFO.Skill,2))
            {
               this.poemIndex = 0;
               this.poeminterval = setInterval(this.doPoemInterval,5000);
            }
         }
         else
         {
            this.status4();
         }
      }
      
      public function doPoemInterval() : void
      {
         trace("唱：－－－－－－〉",POEM[this.poemIndex]);
         if(this.poemIndex < POEM.length)
         {
            this.PETMC.say(POEM[this.poemIndex]);
            ++this.poemIndex;
         }
         else
         {
            this.poemIndex = 0;
            clearInterval(this.poeminterval);
            this.status4();
         }
      }
      
      public function sayword(i:int) : String
      {
         var attr:Object = null;
         if(!newHouseView.isMyHouse)
         {
            return "";
         }
         if(i > 180000)
         {
            attr = petXML.getGoodsAttr(i);
            return this.getword(petLanXML.LanArr[this.PETMC.LanLevel - 1][attr].lang3);
         }
         switch(i)
         {
            case 2:
               return this.getword(this.getwordObj(2));
            case 3:
               return this.getword(this.getwordObj(3));
            case 4:
               return this.getword(this.getwordObj(4));
            case 41:
               return this.getword(petLanXML.LanArr[this.PETMC.LanLevel - 1][3].lang1);
            case 42:
               return this.getword(petLanXML.LanArr[this.PETMC.LanLevel - 1][3].lang2);
            case 43:
               return this.getword(petLanXML.LanArr[this.PETMC.LanLevel - 1][3].lang3);
            case 44:
               return this.getword(petLanXML.LanArr[this.PETMC.LanLevel - 1][3].lang0);
            case 45:
               return this.getword(petLanXML.LanArr[this.PETMC.LanLevel - 1][3].lang0);
            case 61:
               return this.getword(petLanXML.LanArr[this.PETMC.LanLevel - 1][0].lang0);
            case 62:
               return this.getword(petLanXML.LanArr[this.PETMC.LanLevel - 1][1].lang0);
            case 63:
               return this.getword(petLanXML.LanArr[this.PETMC.LanLevel - 1][2].lang0);
            case 81:
               return this.getword(petLanXML.LanArr[this.PETMC.LanLevel - 1][4].lang0);
            default:
               return "555555555";
         }
      }
      
      public function getwordObj(i:uint) : String
      {
         if(i == 2)
         {
            if(this.PETINFO.Hungry > 30 && this.PETINFO.Hungry < 70)
            {
               return petLanXML.LanArr[this.PETMC.LanLevel - 1][0].lang1;
            }
         }
         if(i == 3)
         {
            if(this.PETINFO.Thirsty > 30 && this.PETINFO.Thirsty < 60)
            {
               return petLanXML.LanArr[this.PETMC.LanLevel - 1][1].lang0;
            }
         }
         if(i == 4)
         {
            if(this.PETINFO.Dirty > 30 && this.PETINFO.Dirty < 60)
            {
               return petLanXML.LanArr[this.PETMC.LanLevel - 1][2].lang0;
            }
         }
         if(this.PETINFO.Flag == 1)
         {
            return petLanXML.LanArr[this.PETMC.LanLevel - 1][4].lang3;
         }
         return "";
      }
      
      public function getword(word:String) : String
      {
         var petword:String = null;
         var arr:Array = null;
         trace("getword---->",word);
         if(word != "")
         {
            arr = new Array();
            while(word.indexOf("_") > 0)
            {
               arr.push(word.slice(0,word.indexOf("_")));
               word = word.substr(word.indexOf("_") + 1,word.length);
            }
            arr.push(word);
            petword = arr[Math.floor(Math.random() * arr.length)];
            return this.addMyName(petword);
         }
         return "";
      }
      
      public function addMyName(word:String) : String
      {
         var pattern:RegExp = /x/i;
         return word.replace(pattern,GV.MyInfo_nickName);
      }
      
      public function petsay(e:Event = null) : void
      {
         this.petsayWord(this.statusArr[this.gotoRan]);
         trace("---..");
      }
      
      public function petsayWithMole(txt:String) : void
      {
         if(this.PETMC.LanLevel > 0 && txt.length > 1 || this.PETMC.level > 100)
         {
            I_LamuNPC(this.PETMC).say(txt);
         }
      }
      
      public function petsayWord(i:int) : void
      {
         var str:String = null;
         if(this.PETMC.LanLevel > 0)
         {
            if(!I_LamuNPC(this.PETMC).saying)
            {
               str = this.sayword(i);
               if(str != "" && str.length > 1)
               {
                  I_LamuNPC(this.PETMC).say(str);
               }
            }
         }
      }
      
      public function doInterval() : void
      {
         var ran:uint = uint(Math.random() * 100);
         try
         {
            if(ran > 0)
            {
               try
               {
                  this.gotoRan = uint(Math.random() * this.statusArr.length);
                  if(this.firstBool)
                  {
                     this.firstBool = false;
                     this.gotoRan = 3;
                  }
                  if(this.PETMC.petBody.getChildAt(0).currentFrame == this.PETMC.petBody.getChildAt(0).totalFrames)
                  {
                     this.PETMC.petBody.gotoAndStop(this.statusArr[this.gotoRan]);
                     this.PETMC.petFood.gotoAndStop(this.statusArr[this.gotoRan]);
                     this.PETMC.petTool.gotoAndStop(this.statusArr[this.gotoRan]);
                     this.PETMC.petBody.addEventListener("actionOver",this.petsay);
                  }
               }
               catch(err:Error)
               {
                  clearStatusInterval();
               }
            }
         }
         catch(err:Error)
         {
            clearStatusInterval();
         }
      }
      
      private function status4() : void
      {
         this.statusArr = [2,3,4];
         if(this.PETINFO.Flag == 0)
         {
            this.status3();
            if(this.PETINFO.Spirit <= 10)
            {
               this.statusArr.push(45);
            }
            else if(this.PETINFO.Spirit > 10 && this.PETINFO.Spirit <= 30)
            {
               this.statusArr.push(44);
            }
            else if(this.PETINFO.Spirit > 30 && this.PETINFO.Spirit <= 69)
            {
               this.statusArr.push(41);
            }
            else if(this.PETINFO.Spirit > 69 && this.PETINFO.Spirit <= 89)
            {
               this.statusArr.push(42);
            }
            else
            {
               this.statusArr.push(43);
            }
            this.Interval = setInterval(this.doInterval,int(Math.random() * 10000) + 10000);
            this.doInterval();
         }
         else if(this.PETINFO.Flag == 1)
         {
            this.statusArr.push(81);
            this.status3();
            if(this.PETINFO.Spirit <= 10)
            {
               this.statusArr.push(45);
            }
            else if(this.PETINFO.Spirit > 10 && this.PETINFO.Spirit <= 30)
            {
               this.statusArr.push(44);
            }
            else if(this.PETINFO.Spirit > 30 && this.PETINFO.Spirit <= 69)
            {
               this.statusArr.push(41);
            }
            this.Interval = setInterval(this.doInterval,int(Math.random() * 10000) + 10000);
            this.doInterval();
         }
         else
         {
            this.statusDeath();
         }
      }
      
      private function statusDeath() : void
      {
         try
         {
            this.PETMC.petBody.gotoAndStop(101);
            this.PETMC.petFood.gotoAndStop(101);
            this.PETMC.petTool.gotoAndStop(101);
         }
         catch(err:Error)
         {
         }
      }
      
      private function status3() : void
      {
         if(this.PETINFO.Hungry <= 30)
         {
            this.statusArr.push(61);
         }
         if(this.PETINFO.Thirsty <= 30)
         {
            this.statusArr.push(62);
         }
         if(this.PETINFO.Dirty <= 30)
         {
            this.statusArr.push(63);
         }
      }
   }
}

