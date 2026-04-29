package com.view.mapView.activity.petSkill5
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.ephemeral.ephemeralDataSocket;
   import com.logic.socket.petClass.ListItem.PetStep5ClassSocket;
   import com.mole.app.map.MapManager;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class LamuStep5ClassView extends Sprite
   {
      
      public static var nowPetID:uint = 0;
      
      private var target_mc:MovieClip;
      
      private var depth_mc:MovieClip;
      
      private var botton_mc:MovieClip;
      
      private var top_mc:MovieClip;
      
      private var jobTips_Array:Array = ["    其實每隻拉姆都有學會神力技能的潛質，如果你的拉姆能通過水、火、木三位酋長的信任，讓他們把絕學傳授給你，那我就讓它進入藏寶神殿進化為神力拉姆哦！","    為了守護這幾百年的秘密，拉姆們學會了縮小自己。rr    現在你就去森林入口尋找三尊神像，它們會把你縮小進入它們的世界！"];
      
      private var kingFilmMC:MovieClip;
      
      private var opendoor_mc:MovieClip;
      
      private var hasBeenUnclock:Boolean;
      
      private var hasBeenToTemple:Boolean = false;
      
      public function LamuStep5ClassView()
      {
         super();
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         this.top_mc = GV.MC_mapFrame["top_mc"];
         this.opendoor_mc = this.top_mc.opendoor_mc;
         GV.MC_TopLever.addChild(this.opendoor_mc);
      }
      
      public function init() : void
      {
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.showLamuKingFun);
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         BC.addEvent(this,this.botton_mc.king_btn,MouseEvent.CLICK,this.checkPetBy);
         setTimeout(this.enterTemple,1000);
      }
      
      private function showLamuKingFun(evt:EventTaomee = null) : void
      {
         if(evt.EventObj.type == 1)
         {
            if(GV.MAN_PEOPLE.Petlevel > 0)
            {
               BC.addEvent(this,GV.onlineSocket,"read_" + 1204,this.askonePetClassInfoBack);
               PetStep5ClassSocket.askPetStep5Class(GV.MyInfo_PetObj.SpriteID,1);
            }
            else
            {
               Alert.smileAlart("    帶著你的拉姆勇士來見我吧！");
            }
         }
      }
      
      private function askonePetClassInfoBack(evt:EventTaomee) : void
      {
         var p:PeopleManageView = null;
         var level:uint = 0;
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1204,this.askonePetClassInfoBack);
         var status:uint = uint(evt.EventObj.status);
         switch(status)
         {
            case 0:
               this.depth_mc.moveBall.gotoAndPlay(2);
               this.depth_mc.jia_mc.visible = false;
               break;
            case 1:
               p = PeopleManageView(GV.MAN_PEOPLE);
               level = uint(p.lamuinfo.Petlevel);
               if(!GV.MAN_PEOPLE.lamuinfo.hasSkill_Water() || !GV.MAN_PEOPLE.lamuinfo.hasSkill_Fire() || !GV.MAN_PEOPLE.lamuinfo.hasSkill_Wood())
               {
                  Alert.smileAlart("    你的拉姆還沒有找各系的酋長學會變身，學完水，木，火三種技能才能進入哦！");
               }
               else if(level < 4)
               {
                  Alert.smileAlart("    你的拉姆還很小，等它長大了再帶它進入神殿吧！");
               }
               else
               {
                  this.gotoTemple();
               }
               break;
            case 2:
               p = PeopleManageView(GV.MAN_PEOPLE);
               level = uint(p.lamuinfo.Petlevel);
               if(!GV.MAN_PEOPLE.lamuinfo.hasSkill_Water() || !GV.MAN_PEOPLE.lamuinfo.hasSkill_Fire() || !GV.MAN_PEOPLE.lamuinfo.hasSkill_Wood())
               {
                  Alert.smileAlart("    你的拉姆還沒有找各系的酋長學會變身，學完水，木，火三種技能才能進入哦！");
               }
               else if(level < 4)
               {
                  Alert.smileAlart("    你的拉姆還很小，等它長大了再帶它進入神殿吧！");
               }
               else
               {
                  this.gotoTemple();
               }
         }
      }
      
      private function gotoTemple() : void
      {
         if(!this.hasBeenUnclock)
         {
            this.opendoor_mc.start_mc.visible = true;
            this.opendoor_mc.start_mc.gotoAndStop(1);
            this.opendoor_mc.click_mc.visible = false;
            this.opendoor_mc.over_mc.visible = false;
            this.opendoor_mc.over_mc.gotoAndStop(1);
            this.opendoor_mc.x = 960 / 2;
            this.opendoor_mc.y = 560 / 2;
            BC.addEvent(this,this.opendoor_mc.start_mc,"startEompleteEvent",this.startEompleteEventHandler);
            BC.addEvent(this,this.opendoor_mc.click_mc,"openOKEvent",this.openOKEventHandler);
            BC.addEvent(this,this.opendoor_mc.over_mc,"overCompleteEvent",this.overCompleteEventHandler);
            this.opendoor_mc.start_mc.gotoAndPlay(1);
         }
         else
         {
            this.opendoor_mc.x = -500;
            MapManager.enterMap(136);
         }
      }
      
      private function openOKEventHandler(e:Event) : void
      {
         this.opendoor_mc.x = -500;
         if(!this.hasBeenUnclock)
         {
            ephemeralDataSocket.setData(9,1);
         }
         MapManager.enterMap(136);
      }
      
      private function overCompleteEventHandler(e:Event) : void
      {
         this.opendoor_mc.x = -500;
         Alert.smileAlart("    未能正確打開機關！");
      }
      
      private function startEompleteEventHandler(e:Event) : void
      {
         this.opendoor_mc.start_mc.visible = false;
         this.opendoor_mc.click_mc.visible = true;
         this.opendoor_mc.over_mc.visible = false;
      }
      
      private function enterTemple() : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_1215",this.read1215Handler);
         ephemeralDataSocket.getData(8);
         ephemeralDataSocket.getData(9);
      }
      
      private function read1215Handler(e:EventTaomee) : void
      {
         var date2:int = 0;
         var type:int = int(e.EventObj.type);
         if(type == 9)
         {
            date2 = int(e.EventObj.data);
            if(date2 == 1)
            {
               this.hasBeenUnclock = true;
            }
            else
            {
               this.hasBeenUnclock = false;
            }
         }
      }
      
      private function checkPetBy(evt:MouseEvent = null) : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + 1204,this.askPetClassInfoBack);
         PetStep5ClassSocket.askPetStep5Class(GV.MyInfo_PetObj.SpriteID,1);
      }
      
      private function askPetClassInfoBack(evt:EventTaomee = null) : void
      {
         var myAlert:* = undefined;
         var url:String = null;
         var p:PeopleManageView = null;
         var level:uint = 0;
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1204,this.askPetClassInfoBack);
         var status:uint = uint(evt.EventObj.status);
         var msg:String = "";
         switch(status)
         {
            case 0:
               url = "resource/allJob/AlertPic/103/103_01.swf";
               msg = this.jobTips_Array[0];
               myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"Job_begin,nextCome",true,false,"SMCUI");
               BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.sandJobFun,false,0,true);
               break;
            case 1:
               p = PeopleManageView(GV.MAN_PEOPLE);
               level = uint(p.lamuinfo.Petlevel);
               if(!GV.MAN_PEOPLE.lamuinfo.hasSkill_Water() || !GV.MAN_PEOPLE.lamuinfo.hasSkill_Fire() || !GV.MAN_PEOPLE.lamuinfo.hasSkill_Wood())
               {
                  Alert.smileAlart("    你的拉姆還沒有找各系的酋長學會變身，學完水，木，火三種技能才能進入哦！");
               }
               else if(level < 4)
               {
                  Alert.smileAlart("    你的拉姆還很小，等它長大了再帶它進入神殿吧！");
               }
               else
               {
                  this.gotoTemple();
               }
               break;
            case 2:
               p = PeopleManageView(GV.MAN_PEOPLE);
               level = uint(p.lamuinfo.Petlevel);
               if(!GV.MAN_PEOPLE.lamuinfo.hasSkill_Water() || !GV.MAN_PEOPLE.lamuinfo.hasSkill_Fire() || !GV.MAN_PEOPLE.lamuinfo.hasSkill_Wood())
               {
                  Alert.smileAlart("    你的拉姆還沒有找各系的酋長學會變身，學完水，木，火三種技能才能進入哦！");
               }
               else if(level < 4)
               {
                  Alert.smileAlart("    你的拉姆還很小，等它長大了再帶它進入神殿吧！");
               }
               else
               {
                  this.gotoTemple();
               }
         }
      }
      
      private function sandJobFun(evt:Event = null) : void
      {
         if(GV.MAN_PEOPLE.Petlevel == 4 || GV.MAN_PEOPLE.Petlevel > 100)
         {
            BC.addEvent(this,GV.onlineSocket,"read_" + 1205,this.acceptPetJobBack);
            nowPetID = GV.MyInfo_PetObj.SpriteID;
            PetStep5ClassSocket.setPetStep5Class(GV.MyInfo_PetObj.SpriteID,1,1);
         }
         else
         {
            Alert.smileAlart("    帶著你的拉姆勇士來見我吧！");
         }
      }
      
      private function acceptPetJobBack(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1205,this.acceptPetJobBack);
         LocalUserInfo.setPetSkill5_Flag(1);
         var msg:String = this.jobTips_Array[1];
         var url:String = "resource/allJob/AlertPic/103/103_02.swf";
         var alert:* = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
         BC.addEvent(this,alert,Alert.CLICK_ + "1",this.showJobUI);
      }
      
      private function showJobUI(evt:Event = null) : void
      {
         GV.JobViews.showJob(1006);
      }
      
      private function removeEventHandler(evt:EventTaomee = null) : void
      {
         if(Boolean(this.opendoor_mc))
         {
            GV.MC_TopLever.removeChild(this.opendoor_mc);
         }
         BC.removeEvent(this);
         this.target_mc = null;
         this.depth_mc = null;
         this.botton_mc = null;
      }
   }
}

