package com.module.mapModule
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.GameframeLogic.GameframeLogic;
   import com.logic.PetClassLogic.PetClassLogic;
   import com.module.activityModule.SoundControlModule;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.pet.petLogic;
   import com.mole.app.map.MapManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class Map81PetMagicClass extends Sprite
   {
      
      private var now_IP:uint = 0;
      
      private var now_flag:uint = 0;
      
      private var now_PetID:uint = 0;
      
      private var nowPet_arr:Array;
      
      private var Game_name:String = "";
      
      private var msg_arr:Array = [{
         "msg0":"    我是魔法超級拉姆Mr.黃澄澄，哈哈，看我72變！rr    如果以為我隻會變外形，那你就錯了，還有神秘能力，等你學會了你就知道了。rr    只有超級拉姆才有可能學會哦！",
         "msg1":"    嘿嘿，準備好接受我的地獄式訓練吧~rr    你可以在右上角的課程表裡看到你的學習任務。rr    讓我們開始今天的課程吧！",
         "msg2":"    嘿，歡迎你回來上課，讓我們快開始今天的課程吧。",
         "msg102":"    這週你的拉姆已經學很多了，明天再來吧。rr    學習魔法不能操之過急哦。",
         "msg3":"    很好，看樣子你是個執著的摩爾，不輕易放棄。好吧，我們趕快開始第二課吧。",
         "msg4":"    在生日飛艇上辦生日會是多麼高興啊，可是有個小摩爾卻不知怎麼哭了，你能幫上它嗎？",
         "msg104":"    超級精靈在練習場等你，課外練習要認真做哦。完成後就來找我考試吧。",
         "msg5":"    超級精靈在練習場等你，課外練習要認真做哦。完成後就來找我考試吧。",
         "msg6":"    你的拉姆已經得我真傳，不用再學啦！rr    快去外面試試吧，讓你的朋友們看看你有多厲害！rr    記得要說是我教的哦！",
         "msg7":"    小摩爾很感激你呢，這才是魔法真正的意義，你和你的拉姆已經做到了魔法師精神。rr    我很高興地宣布，（拉姆名字）順利畢業！rr    不記得的時候可以看看左邊的快捷語言，沒準就想起來了。要珍惜哦！",
         "msg106":"    你還沒有完成考試哦，加油！"
      },{
         "msg0":"    嘿，我是魔法力量拉姆Mr.紅彤彤。感謝小摩爾幫我的主人找回了友情，我也想幫助小摩爾的拉姆學會更強的本領。rr    學會了我的本領後，小拉姆會更加強壯，在你打工的時候，他就能發揮非常大的作用啦。快來試試吧！",
         "msg1":"    報名成功！你看，你的拉姆已經迫不及待了。快快，我們這就開始課程吧。",
         "msg2":"    嘿，歡迎你回來上課，讓我們快開始今天的課程吧。",
         "msg102":"    你做到了，真聰明。想必你不僅是個運動健將，還有很好的運動習慣。明天的課程也要加油!",
         "msg3":"    嘿，歡迎你回來上課，讓我們快開始今天的課程吧。",
         "msg4":"    絲姐姐的小屋漏水了，這可怎麼辦呀？天就快下雨了，看著滿屋的漂亮衣服就要被雨淋濕，絲姐姐急的都要哭了。魔法力量拉姆快快幫助絲姐姐吧！",
         "msg104":"    火精靈在練習場等你，課外練習要認真做哦。完成後就來找我考試吧。",
         "msg5":"    火精靈在練習場等你，課外練習要認真做哦。完成後就來找我考試吧。",
         "msg6":"    我記得你的拉姆哦，他已經從我這裡畢業啦。你看他現在多強壯呀。",
         "msg7":"    你的拉姆已經順利畢業啦。並且用自己的技能幫助了別人，拉姆很高興呢。rr    從此，帶著你的拉姆去打工，他會讓你更有效率哦。",
         "msg106":"    你還沒有完成考試哦，加油！"
      },{
         "msg0":"    你好啊，我是魔法守護拉姆Miss.綠茸茸。幫助著木精靈一直守護著黑森林的大榕樹。家在我心中，永遠是最重要的地方。學會我的能力，不僅讓家裡變的井井有條，還有神奇技能哦！",
         "msg1":"    報名成功！這就開始吧，要有耐心哦。",
         "msg2":"    嘿，歡迎你回來上課，讓我們快開始今天的課程吧。",
         "msg102":"    基礎知識看來掌握的不錯，很有潛力哦。明天的課程也要加油。",
         "msg3":"    嘿，歡迎你回來上課，讓我們快開始今天的課程吧。",
         "msg4":"    梅森的菜園子豐收啦，可是壞兔子們也已經虎視眈眈很久。快去幫梅森趕走壞兔子，決不能讓他們不勞而獲！",
         "msg104":"    木精靈在練習場等你，課外練習要認真做哦。完成後就來找我考試吧。",
         "msg5":"    木精靈在練習場等你，課外練習要認真做哦。完成後就來找我考試吧。",
         "msg6":"    你的拉姆已經學會我的能力啦。要加油哦，和拉姆一起把小屋變的更加漂亮！",
         "msg7":"    你的正義和能力及時幫助了梅森，這才是魔法真正的意義，你和你的拉姆已經做到了魔法師精神。我宣布，你的拉姆順利畢業！",
         "msg106":"    你還沒有完成考試哦，要進入考場考試嗎？"
      },{
         "msg0":"    你好啊，我是魔法感應拉姆Mr.藍幽幽。我擁有最強的洞察力，無所不知，無所不曉。世界上飛的最快的鳥，在我眼中也是慢的像蝸牛一般。",
         "msg1":"    哈，是不是很想趕快學會啊？別著急，心急吃不了熱豆腐。從基礎的開始吧。",
         "msg2":"    嘿，歡迎你回來上課，讓我們快開始今天的課程吧。",
         "msg102":"    很有潛力，你的拉姆很適合學習我的能力。明天的課程也要加油。",
         "msg3":"    嘿，歡迎你回來上課，讓我們快開始今天的課程吧。",
         "msg4":"    兔兔最近寫完稿子就跑去漿果森林，艾米很是好奇，原來兔兔是想拍攝到神秘的摩摩鳥的照片，你能幫助她完成心願嗎？",
         "msg104":"    水精靈在練習場等你，課外練習要認真做哦。完成後就來找我考試吧。",
         "msg5":"    水精靈在練習場等你，課外練習要認真做哦。完成後就來找我考試吧。",
         "msg6":"    你的拉姆已經學會我的能力了，快去試試吧。",
         "msg7":"    你用你的魔法幫助了兔兔，這才是魔法真正的意義，你和你的拉姆已經做到了魔法師精神。恭喜你，順利畢業。",
         "msg106":"    你還沒有完成考試哦，加油！"
      }];
      
      public function Map81PetMagicClass()
      {
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeEvent);
         super();
      }
      
      public function setBtnMC(MC:MovieClip) : void
      {
      }
      
      private function MouseOverMC(eve:MouseEvent) : void
      {
         var btn_name:String = eve.currentTarget.name;
         var IP:uint = uint(btn_name.slice(6,9));
         var temp_mc:MovieClip = GV.MC_mapFrame["control_mc"];
         temp_mc["mc_" + IP].gotoAndStop(2);
      }
      
      private function MouseOutMC(eve:MouseEvent) : void
      {
         var btn_name:String = eve.currentTarget.name;
         var IP:uint = uint(btn_name.slice(6,9));
         var temp_mc:MovieClip = GV.MC_mapFrame["control_mc"];
         temp_mc["mc_" + IP].gotoAndStop(1);
      }
      
      private function MouseMC(eve:MouseEvent = null) : void
      {
         var btn_name:String = null;
         if(eve != null)
         {
            btn_name = eve.currentTarget.name;
            this.now_IP = uint(btn_name.slice(6,9));
         }
         if(GV.MAN_PEOPLE.Petlevel <= 0)
         {
            if(this.now_IP == 101)
            {
               this.showTipEFun("    你沒有帶著超級拉姆哦！");
            }
            else
            {
               this.showTipEFun("    你沒有帶著拉姆哦！");
            }
            return;
         }
         if(GV.MyInfo_PetObj.Level < 3)
         {
            this.showTipEFun("    你的拉姆還沒有能力學習哦！");
            return;
         }
         BC.addEvent(this,PetClassLogic.getPetClassLogics(),PetClassLogic.GET_PETCLASS,this.getOneInfo);
         PetClassLogic.getPetClassLogics().GetPetClass(GV.MyInfo_PetObj.SpriteID);
         this.now_PetID = GV.MyInfo_PetObj.SpriteID;
      }
      
      private function getOneInfo(eve:EventTaomee) : void
      {
         var p:uint = 0;
         var one_arr:Array = null;
         var obj:Object = null;
         BC.removeEvent(this,PetClassLogic.getPetClassLogics(),PetClassLogic.GET_PETCLASS,this.getOneInfo);
         this.nowPet_arr = eve.EventObj.petClassList;
         if(this.nowPet_arr[0] != null)
         {
            for(p = 0; p < this.nowPet_arr.length; p++)
            {
               if(this.nowPet_arr[p].classStep > 0 && this.nowPet_arr[p].classStep < 6 && this.nowPet_arr[p].classID == this.now_IP)
               {
                  if(this.now_IP == 101 && GV.MyInfo_PetObj.Level < 100)
                  {
                     this.showTipEFun("    你的拉姆已經無法繼續超級魔法課程了，點擊課程表裡放棄課程，就可報名學習其他魔法課啦。");
                     return;
                  }
                  if(this.now_IP != 101 && GV.MyInfo_PetObj.Level > 100)
                  {
                     this.showTipEFun("    魔法老師們為你的超級拉姆準備了更適合的超級魔法課程，點擊課程表裡的放棄課程，就可找Mr.黃澄澄學習啦！");
                     return;
                  }
               }
            }
         }
         if(this.now_IP == 101 && GV.MyInfo_PetObj.Level < 100)
         {
            this.showTipEFun("    普通拉姆的體質還不能適應超級拉姆的課程哦！");
            return;
         }
         if(this.now_IP != 101 && GV.MyInfo_PetObj.Level > 100)
         {
            this.showTipEFun("    超級拉姆有量身訂做的特別課程哦！");
            return;
         }
         if(this.nowPet_arr[0] == null)
         {
            this.beginClassTip(this.now_IP);
            return;
         }
         for(var pp:uint = 0; pp < this.nowPet_arr.length; pp++)
         {
            if(this.nowPet_arr[pp].classStep > 0 && this.nowPet_arr[pp].classStep < 6 && this.nowPet_arr[pp].classID != this.now_IP)
            {
               this.showTipEFun("    一個拉姆只能學習一種魔法哦！你帶著的拉姆已經在學習中了，可以帶其他的拉姆來學習。");
               return;
            }
         }
         for(var i:uint = 0; i < this.nowPet_arr.length; i++)
         {
            if(this.nowPet_arr[i].classID == this.now_IP)
            {
               this.now_flag = this.nowPet_arr[i].classStep;
               if(this.nowPet_arr[i].classStep == 0)
               {
                  this.beginClassTip(this.now_IP);
                  return;
               }
               if(this.nowPet_arr[i].classStep == 5)
               {
                  one_arr = this.nowPet_arr[i].arr.slice(0,5);
                  obj = this.msg_arr[this.now_IP - 101];
                  if(one_arr.indexOf(0) == -1)
                  {
                     if(this.nowPet_arr[i].arr[5] == 0)
                     {
                        this.beginExamTip(this.now_IP);
                     }
                     else if(this.now_IP == 103)
                     {
                        if(this.nowPet_arr[i].arr[6] == 1)
                        {
                           this.overClass(this.now_IP);
                        }
                        else
                        {
                           this.showNotOver(this.now_IP);
                        }
                     }
                     else if(this.now_IP == 102)
                     {
                        if(this.nowPet_arr[i].arr[6] == 1 && this.nowPet_arr[i].arr[7] == 1 && this.nowPet_arr[i].arr[8] == 1)
                        {
                           this.overClass(this.now_IP);
                        }
                        else
                        {
                           this.showNotOver(this.now_IP);
                        }
                     }
                     else if(this.nowPet_arr[i].arr[6] == 1 && this.nowPet_arr[i].arr[7] == 1)
                     {
                        this.overClass(this.now_IP);
                     }
                     else
                     {
                        this.showNotOver(this.now_IP);
                     }
                  }
                  else
                  {
                     this.showTipSMCFun(this.now_IP + "_" + this.now_flag + ".swf",obj["msg" + this.now_flag]);
                  }
                  return;
               }
               if(this.nowPet_arr[i].classStep == 6)
               {
                  this.showTipSMCFun(this.now_IP + "_6.swf",this.msg_arr[this.now_IP - 101].msg6);
                  return;
               }
               if(Boolean(uint(this.nowPet_arr[i].classStep) / 2 as uint))
               {
                  this.beginClass();
                  return;
               }
               this.flagAddGame();
               return;
            }
         }
      }
      
      private function beginClassTip(IP:uint) : void
      {
         this.now_flag = 1;
         var url:String = "resource/allJob/AlertPic/petMagicClass/" + this.now_IP + ".swf";
         var msg:String = this.msg_arr[this.now_IP - 101].msg0;
         var myAlt:* = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"getReady,notgo",true,false,"SMCUI");
         BC.addEvent(this,myAlt,Alert.CLICK_ + "1",this.beginClass);
      }
      
      private function beginClass(eve:Event = null) : void
      {
         var flag:uint = 0;
         if(!GV.JobLogics.havePetFollow())
         {
            if(this.now_IP == 101)
            {
               this.showTipEFun("    你沒有帶著超級拉姆哦！");
            }
            else
            {
               this.showTipEFun("    你沒有帶著拉姆哦！");
            }
            return;
         }
         if(this.now_flag == 4)
         {
            flag = 3;
         }
         else
         {
            flag = this.now_flag;
         }
         BC.addEvent(this,PetClassLogic.getPetClassLogics(),PetClassLogic.ACCEPT_PETCLASS,this.showFirstGameTip);
         PetClassLogic.getPetClassLogics().acceptPetClass(GV.MyInfo_PetObj.SpriteID,this.now_IP,flag);
      }
      
      private function showFirstGameTip(eve:EventTaomee) : void
      {
         var myAlt:* = undefined;
         var pet_arr:Array = null;
         var class_obj:Object = null;
         var i:int = 0;
         BC.removeEvent(this,PetClassLogic.getPetClassLogics(),PetClassLogic.ACCEPT_PETCLASS,this.showFirstGameTip);
         var url:String = "";
         var msg:String = "";
         var obj:Object = this.msg_arr[this.now_IP - 101];
         if(eve.EventObj.errorID < 0)
         {
            url = this.now_IP + "_10" + this.now_flag + ".swf";
            msg = obj["msg" + (this.now_flag + 100)];
            this.showTipSMCFun(url,msg);
            return;
         }
         if(this.now_flag == 4)
         {
            pet_arr = GV.MyInfo_PetObj.Job;
            if(pet_arr[0] == null)
            {
               GV.MyInfo_PetObj.Job.Cnt = 1;
               class_obj = {
                  "ClassID":this.now_IP,
                  "Status":1,
                  "Days":0,
                  "classStep":5
               };
               pet_arr[0] = class_obj;
            }
            else
            {
               for(i = 0; i < pet_arr.length; i++)
               {
                  if(pet_arr[i].ClassID > 100 && pet_arr[i].ClassID < 105 && pet_arr[i].classStep < 5)
                  {
                     GV.MyInfo_PetObj.Job[i].classStep = 5;
                  }
               }
            }
         }
         else
         {
            url = "resource/allJob/AlertPic/petMagicClass/" + this.now_IP + "_" + this.now_flag + ".swf";
            msg = obj["msg" + this.now_flag];
            myAlt = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"nextClass,notgo",true,false,"SMCUI");
            BC.addEvent(this,myAlt,Alert.CLICK_ + "1",this.tipAddGame);
            if(this.now_flag > 1)
            {
               ++this.now_flag;
            }
         }
      }
      
      private function beginExamTip(IP:uint) : void
      {
         var url:String = "resource/allJob/AlertPic/petMagicClass/" + IP + ".swf";
         var msg:String = this.msg_arr[IP - 101].msg4;
         var myAlt:* = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"nextClass,notgo",true,false,"SMCUI");
         BC.addEvent(this,myAlt,Alert.CLICK_ + "1",this.beginExamFun,false,0,true);
      }
      
      private function beginExamFun(evt:Event = null) : void
      {
         if(!GV.JobLogics.havePetFollow())
         {
            if(this.now_IP == 101)
            {
               this.showTipEFun("    你沒有帶著超級拉姆哦！");
            }
            else
            {
               this.showTipEFun("    你沒有帶著拉姆哦！");
            }
            return;
         }
         this.nowPet_arr[0].arr[5] = 1;
         BC.addEvent(this,PetClassLogic.getPetClassLogics(),PetClassLogic.SETCLASSDATA,this.beginExamBack);
         PetClassLogic.getPetClassLogics().setClassData(GV.MyInfo_PetObj.SpriteID,this.now_IP,this.nowPet_arr[0].arr);
      }
      
      private function beginExamBack(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,PetClassLogic.getPetClassLogics(),PetClassLogic.SETCLASSDATA,this.beginExamBack);
         if(this.now_IP == 103)
         {
            this.getInExam();
         }
         else
         {
            GV.JobViews.showJob(1001);
         }
      }
      
      private function showNotOver(IP:uint) : void
      {
         var myAlt:* = undefined;
         var url:String = "resource/allJob/AlertPic/petMagicClass/" + IP + ".swf";
         var msg:String = this.msg_arr[IP - 101].msg106;
         if(IP == 103)
         {
            myAlt = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"getReady,notgo",true,false,"SMCUI");
            BC.addEvent(this,myAlt,Alert.CLICK_ + "1",this.getInExam);
         }
         else
         {
            myAlt = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"iknow",true,false,"SMCUI");
         }
      }
      
      private function getInExam(e:Event = null) : void
      {
         GV.Room_DefaultRoomID = 0;
         LocalUserInfo.setMapID(0);
         GF.switchMap(97);
      }
      
      private function overClass(IP:uint) : void
      {
         var url:String = "resource/allJob/AlertPic/petMagicClass/" + IP + ".swf";
         var msg:String = "";
         switch(IP)
         {
            case 101:
               msg = "    小摩爾很感激你呢，這才是魔法真正的意義，你和你的拉姆已經做到了魔法師精神。rr    我很高興地宣布，" + this.nowPet_arr[0].petNick + "順利畢業！rr    不記得的時候可以看看左邊的快捷語言，沒準就想起來了。要珍惜哦！";
               break;
            case 102:
               msg = "    " + this.nowPet_arr[0].petNick + "已經順利畢業啦。並且用自己的技能幫助了別人，拉姆很高興呢。rr    從此，帶著你的拉姆去打工，他會讓你更有效率哦。";
               break;
            case 103:
               msg = "    你的正義和能力及時幫助了梅森，這才是魔法真正的意義，你和你的拉姆已經做到了魔法師精神。我宣布，" + this.nowPet_arr[0].petNick + "順利畢業！";
               break;
            case 104:
               msg = "    你用你的魔法幫助了兔兔，這才是魔法真正的意義，你和你的拉姆已經做到了魔法師精神。恭喜你，順利畢業。";
         }
         var myAlt:* = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"iknow",true,false,"SMCUI");
         BC.addEvent(this,myAlt,Alert.CLICK_ + "1",this.overClassFun,false,0,true);
      }
      
      private function overClassFun(evt:Event = null) : void
      {
         if(!GV.JobLogics.havePetFollow())
         {
            if(this.now_IP == 101)
            {
               this.showTipEFun("    你沒有帶著超級拉姆哦！");
            }
            else
            {
               this.showTipEFun("    你沒有帶著拉姆哦！");
            }
            return;
         }
         BC.addEvent(this,PetClassLogic.getPetClassLogics(),PetClassLogic.SUBMIT_PETCLASS,this.submitClassBack);
         PetClassLogic.getPetClassLogics().submitPetClass(GV.MyInfo_PetObj.SpriteID,this.now_IP,3);
      }
      
      private function submitClassBack(evt:EventTaomee = null) : void
      {
         petLogic.setPetMagicOK();
         BC.removeEvent(this,PetClassLogic.getPetClassLogics(),PetClassLogic.SUBMIT_PETCLASS,this.submitClassBack);
         var url:String = "";
         var msg:String = "";
         switch(this.now_IP)
         {
            case 101:
               url = "resource/pethonor/icon/1210016.swf";
               msg = "    你的拉姆獲得了魔法變身勳章！";
               break;
            case 102:
               url = "resource/pethonor/icon/1210014.swf";
               msg = "    你的拉姆獲得了魔法力量勳章！";
               break;
            case 103:
               url = "resource/pethonor/icon/1210013.swf";
               msg = "    你的拉姆獲得了魔法守護勳章！";
               break;
            case 104:
               url = "resource/pethonor/icon/1210015.swf";
               msg = "    你的拉姆獲得了魔法感應勳章！";
         }
         var myAlert:* = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
         BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.showNextItem);
      }
      
      private function showNextItem(evt:Event = null) : void
      {
         var url:String = "";
         var msg:String = "";
         switch(this.now_IP)
         {
            case 101:
               url = "resource/petcloth/icon/1200025.swf";
               msg = "    百變假面已放入你的拉姆背包中！";
               break;
            case 102:
               url = "resource/petcloth/icon/1200023.swf";
               msg = "    火紋面具已放入你的拉姆背包中！";
               break;
            case 103:
               url = "resource/petcloth/icon/1200024.swf";
               msg = "    星辰盾已放入你的拉姆背包中！";
               break;
            case 104:
               url = "resource/petcloth/icon/1200022.swf";
               msg = "    先知眼鏡已放入你的拉姆背包中！";
         }
         var myAlert:* = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
      }
      
      private function flagAddGame() : void
      {
         var myAlt:* = undefined;
         var url:String = "resource/allJob/AlertPic/petMagicClass/" + this.now_IP + "_" + this.now_flag + ".swf";
         var obj:Object = this.msg_arr[this.now_IP - 101];
         var msg:String = obj["msg" + this.now_flag];
         if(this.now_flag < 4)
         {
            myAlt = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"nextClass,notgo",true,false,"SMCUI");
            BC.addEvent(this,myAlt,Alert.CLICK_ + "1",this.tipAddGame);
         }
         else
         {
            myAlt = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"iknow",true,false,"SMCUI");
         }
      }
      
      private function tipAddGame(eve:Event) : void
      {
         if(!GV.JobLogics.havePetFollow())
         {
            if(this.now_IP == 101)
            {
               this.showTipEFun("    你沒有帶著超級拉姆哦！");
            }
            else
            {
               this.showTipEFun("    你沒有帶著拉姆哦！");
            }
            return;
         }
         var flags:uint = 0;
         if(Boolean(this.now_flag / 2 as uint))
         {
            flags = this.now_flag + 1;
         }
         else
         {
            flags = this.now_flag;
         }
         this.AddGame(this.now_IP,flags);
      }
      
      private function AddGame(IP:uint, Flag:uint) : void
      {
         if(Boolean(MainManager.getGameLevel().getChildByName("panle")))
         {
            return;
         }
         GameframeLogic.stopMousicHandler();
         SoundControlModule.getInstance().initSound();
         var url:String = "module/external/JobUI/";
         var msg:String = "正在加載";
         switch(IP)
         {
            case 101:
               if(Flag == 1)
               {
                  url = url.concat("magicWords.swf");
                  msg = msg.concat("超拉打字變身");
                  this.Game_name = "contact";
               }
               if(Flag == 3)
               {
                  url = url.concat("magicWordsB.swf");
                  msg = msg.concat("超拉魔法變身");
                  this.Game_name = "contact";
               }
               if(Flag == 5)
               {
                  url = url.concat("");
                  msg = msg.concat("");
                  this.Game_name = "";
               }
               break;
            case 102:
               if(Flag == 1)
               {
                  url = url.concat("PowerClass.swf");
                  msg = msg.concat("運動問答");
                  this.Game_name = "power";
               }
               if(Flag == 3)
               {
                  url = url.concat("KnockNail.swf");
                  msg = msg.concat("敲釘子練習");
                  this.Game_name = "power";
               }
               if(Flag == 5)
               {
                  url = url.concat("");
                  msg = msg.concat("");
                  this.Game_name = "";
               }
               break;
            case 103:
               if(Flag == 1)
               {
                  url = url.concat("Contact.swf");
                  msg = msg.concat("星星連線");
                  this.Game_name = "contact";
               }
               if(Flag == 3)
               {
                  url = url.concat("Contact2.swf");
                  msg = msg.concat("星辰守護");
                  this.Game_name = "contact";
               }
               if(Flag == 5)
               {
                  url = url.concat("");
                  msg = msg.concat("");
                  this.Game_name = "";
               }
               break;
            case 104:
               if(Flag == 1)
               {
                  url = url.concat("inductionCourse.swf");
                  msg = msg.concat("眼力遊戲");
                  this.Game_name = "contact";
               }
               if(Flag == 3)
               {
                  url = url.concat("inductionCourseC.swf");
                  msg = msg.concat("魔法感應能量課");
                  this.Game_name = "contact";
                  SoundControlModule.getInstance().stopSund();
               }
               if(Flag == 5)
               {
                  url = url.concat("");
                  msg = msg.concat("");
                  this.Game_name = "";
               }
         }
         GV.onlineSocket.addEventListener(this.Game_name + "_close",this.overAddGame);
         var loadGame:LoadGame = new LoadGame(url,msg,MainManager.getGameLevel());
         loadGame = null;
         MapManager.clearMap();
      }
      
      private function overAddGame(eve:EventTaomee) : void
      {
         var temp:* = undefined;
         GV.onlineSocket.removeEventListener(this.Game_name + "_close",this.overAddGame);
         if(Boolean(MainManager.getGameLevel().getChildByName("panle")))
         {
            temp = MainManager.getGameLevel().getChildByName("panle");
            MainManager.getGameLevel().removeChildAt(temp);
            temp = null;
         }
         GameframeLogic.playMousicHandler();
         SoundControlModule.getInstance().stopSund();
         GV.map_ManagerChange.refreshMap();
         if(Boolean(eve.EventObj.bln))
         {
            BC.addEvent(this,PetClassLogic.getPetClassLogics(),PetClassLogic.SUBMIT_PETCLASS,this.showPassGameTip);
            PetClassLogic.getPetClassLogics().submitPetClass(GV.MyInfo_PetObj.SpriteID,this.now_IP,uint(this.now_flag + 1) / 2);
         }
      }
      
      private function showPassGameTip(eve:EventTaomee) : void
      {
         BC.removeEvent(this,PetClassLogic.getPetClassLogics(),PetClassLogic.SUBMIT_PETCLASS,this.showPassGameTip);
         if(this.now_flag == 3)
         {
            this.MouseMC();
         }
      }
      
      private function showTipSMCFun(url:String = "", msg:String = "") : void
      {
         Alert.showAlert(MainManager.getAppLevel(),"resource/allJob/AlertPic/petMagicClass/" + url,msg,Alert.CHANG_ALERT,"iknow",true,false,"SMCUI");
      }
      
      private function showTipEFun(msg:String = "") : void
      {
         Alert.showAlert(MainManager.getAppLevel(),msg,"",Alert.CHANG_ALERT,"iknow",true,false,"E");
      }
      
      private function removeEvent(eve:Event = null) : void
      {
         BC.removeEvent(this);
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeEvent);
      }
   }
}

