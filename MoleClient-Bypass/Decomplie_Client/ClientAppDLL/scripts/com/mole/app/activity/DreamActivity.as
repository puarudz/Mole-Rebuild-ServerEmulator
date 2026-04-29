package com.mole.app.activity
{
   import com.common.Alert.Alert;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.superlamuParty.superlamuPartySocket;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.NPCDialogManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.module.AppModuleControl;
   import com.mole.app.module.ModuleEvent;
   import com.mole.app.utils.PlayMovie;
   import com.mole.app.utils.Tool;
   import com.view.MapManageView.MapManageView;
   
   public class DreamActivity
   {
      
      private static var _inst:DreamActivity;
      
      private var _movie:PlayMovie;
      
      private var _prizeCntArr:Array = [25,12,8,5,3];
      
      private var _dayType:int = 30082;
      
      private var _type:int = 106;
      
      private var _dream0Step:int = 0;
      
      private var _dream0Score:int = 0;
      
      private var _dream1Step:int = 0;
      
      private var _dream1Score:int = 0;
      
      private var _msgArr:Array = ["開掛了吧？這運氣不去買彩票就太浪費了！","鮮花？美女？掌聲？想來什麼來什麼！","出門撿摩爾豆應該還湊合，其他的就別想了","低調又平凡，你今天注定是個路人甲……","你就是個茶几，上面放滿了杯具……"];
      
      private var _dream0MsgArr:Array = ["你勇氣非凡，是一個當警察的好人選，保衛莊園是你的職責！","你責任心強，做一名消防員最適合你了，守護莊園少不了你們！","喜歡自然，熱愛小動物，小獵人你當之無愧！","具有良好方向感的你，做駕駛員一定是不會錯的！","你有著超強的好奇心，當記者就是你的未來！","你熱於助人，相信成為小嚮導之後一定會幫助更多的小摩爾!","擁有藝術氣息，注重美感的你，建設摩爾莊園就需要你這樣的摩爾！","擁有藝術氣息，注重美感的你，建設摩爾莊園就需要你這樣的摩爾！","你具有良好的管理能力，飯店管理師非你莫屬！","你具有良好的管理能力，飯店管理師非你莫屬！"];
      
      private var _dream1MsgArr:Array = ["RK般的神秘派\n你擁有脫離凡俗的神秘氣質,可以說是一個神秘的人","丫麗般的元氣派\n你很喜歡說話,很積極,活力十足,是個太陽般的小摩爾","麼麼公主般的療傷派\n你可安慰他人的疲憊心情，是像聖母瑪利亞般的少女","摩樂樂般的認真派\n你會逐漸吸引大家接受你的意見  ，是一個領導人物"];
      
      public function DreamActivity()
      {
         super();
      }
      
      public static function get inst() : DreamActivity
      {
         if(_inst == null)
         {
            _inst = new DreamActivity();
         }
         return _inst;
      }
      
      public function init() : void
      {
         if(LocalUserInfo.getMapID() == 319)
         {
            this.addEvents();
         }
      }
      
      private function addEvents() : void
      {
         SystemEventManager.addEventListener("dailyDivine",this.dailyDivine);
         SystemEventManager.addEventListener("dream0Divine",this.dream0Divine);
         SystemEventManager.addEventListener("dream1Divine",this.dream1Divine);
         SystemEventManager.addEventListener("dream0Event1",this.dream0Event1);
         SystemEventManager.addEventListener("dream0Event3",this.dream0Event3);
         SystemEventManager.addEventListener("dream0Event0",this.dream0Event0);
         SystemEventManager.addEventListener("dream0Abandon",this.dream0Abandon);
         SystemEventManager.addEventListener("dream1Event1",this.dream1Event1);
         SystemEventManager.addEventListener("dream1Event0",this.dream1Event0);
         SystemEventManager.addEventListener("dream1Abandon",this.dream1Abandon);
      }
      
      private function playOver0() : void
      {
         GV.MC_mapFrame["depth_mc"].npc_10129.visible = true;
         this._movie.destroy();
         this._movie = null;
         NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(3));
      }
      
      private function playOver1() : void
      {
         GV.MC_mapFrame["depth_mc"].npc_10129.visible = true;
         this._movie.destroy();
         this._movie = null;
         NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(6));
      }
      
      private function dream0Divine(e:SystemEvent) : void
      {
         Tool.finishSomething(30083,function(doneTimes:int):void
         {
            if(doneTimes == 0)
            {
               _movie = PlayMovie.play("resource/movie/divineMovie.swf",null,null,playOver0);
               GV.MC_mapFrame["depth_mc"].npc_10129.visible = false;
            }
            else
            {
               Alert.smileAlart("    今天你已經占卜過運勢了哦，明天再來吧！");
            }
         });
      }
      
      private function dream1Divine(e:SystemEvent) : void
      {
         Tool.finishSomething(30084,function(doneTimes:int):void
         {
            if(doneTimes == 0)
            {
               _movie = PlayMovie.play("resource/movie/divineMovie.swf",null,null,playOver1);
               GV.MC_mapFrame["depth_mc"].npc_10129.visible = false;
            }
            else
            {
               Alert.smileAlart("    今天你已經占卜過運勢了哦，明天再來吧！");
            }
         });
      }
      
      private function dream1Event0(e:SystemEvent) : void
      {
         this.dream1Handler();
      }
      
      private function dream1Event1(e:SystemEvent) : void
      {
         this._dream1Score += 1;
         this.dream1Handler();
      }
      
      private function dream1Handler() : void
      {
         ++this._dream1Step;
         if(this._dream1Step < 3)
         {
            NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(6 + this._dream1Step));
         }
         else
         {
            NPCDialogManager.destroyDialog();
            BC.addEvent(this,GV.onlineSocket,"read_1242",this.getDream1PrizeOver);
            superlamuPartySocket.treasurebowl(108);
         }
      }
      
      private function getDream1PrizeOver(e:EventTaomee) : void
      {
         var itemID:int = 0;
         var count:int = 0;
         var appModule:AppModuleControl = null;
         BC.removeEvent(this,GV.onlineSocket,"read_1242",this.getDream1PrizeOver);
         itemID = int(e.EventObj.itemId);
         count = int(e.EventObj.count);
         var _temp_2:* = appModule;
         var _temp_1:* = ModuleEvent.DESTROY;
         with({})
         {
            _temp_2.addEventListener(_temp_1,function onModuleDestroy(e:ModuleEvent):void
            {
               appModule.removeEventListener(ModuleEvent.DESTROY,onModuleDestroy);
               Tool.alert(itemID,count);
            });
            this._dream1Score = 0;
            this._dream1Step = 0;
         }
         
         private function dream1Abandon(e:SystemEvent) : void
         {
            NPCDialogManager.destroyDialog();
            this._dream1Score = 0;
            this._dream1Step = 0;
         }
         
         private function dream0Abandon(e:SystemEvent) : void
         {
            NPCDialogManager.destroyDialog();
            this._dream0Score = 0;
            this._dream0Step = 0;
         }
         
         private function dream0Event1(e:SystemEvent) : void
         {
            this._dream0Score += 1;
            this.dream0Handler();
         }
         
         private function dream0Event3(e:SystemEvent) : void
         {
            this._dream0Score += 3;
            this.dream0Handler();
         }
         
         private function dream0Event0(e:SystemEvent) : void
         {
            this.dream0Handler();
         }
         
         private function dream0Handler() : void
         {
            ++this._dream0Step;
            if(this._dream0Step < 3)
            {
               NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(3 + this._dream0Step));
            }
            else
            {
               NPCDialogManager.destroyDialog();
               BC.addEvent(this,GV.onlineSocket,"read_1242",this.getDream0PrizeOver);
               superlamuPartySocket.treasurebowl(107);
            }
         }
         
         private function getDream0PrizeOver(e:EventTaomee) : void
         {
            var itemID:int = 0;
            var count:int = 0;
            var appModule:AppModuleControl = null;
            BC.removeEvent(this,GV.onlineSocket,"read_1242",this.getDream0PrizeOver);
            itemID = int(e.EventObj.itemId);
            count = int(e.EventObj.count);
            var _temp_2:* = appModule;
            var _temp_1:* = ModuleEvent.DESTROY;
            with({})
            {
               _temp_2.addEventListener(_temp_1,function onModuleDestroy(e:ModuleEvent):void
               {
                  appModule.removeEventListener(ModuleEvent.DESTROY,onModuleDestroy);
                  Tool.alert(itemID,count);
               });
               this._dream0Score = 0;
               this._dream0Step = 0;
            }
            
            private function dailyDivine(e:SystemEvent) : void
            {
               Tool.finishSomething(this._dayType,function(doneTimes:int):void
               {
                  if(doneTimes == 0)
                  {
                     _movie = PlayMovie.play("resource/movie/divineMovie.swf",null,null,playOver);
                     GV.MC_mapFrame["depth_mc"].npc_10129.visible = false;
                  }
                  else
                  {
                     Alert.smileAlart("    今天你已經占卜過運勢了哦，明天再來吧！");
                  }
               });
            }
            
            private function playOver() : void
            {
               GV.MC_mapFrame["depth_mc"].npc_10129.visible = true;
               this._movie.destroy();
               this._movie = null;
               BC.addEvent(this,GV.onlineSocket,"read_1242",this.getPrizeOver);
               superlamuPartySocket.treasurebowl(this._type);
            }
            
            private function getPrizeOver(e:EventTaomee) : void
            {
               var index:int;
               var itemID:int = 0;
               var count:int = 0;
               var appModule:AppModuleControl = null;
               BC.removeEvent(this,GV.onlineSocket,"read_1242",this.getPrizeOver);
               itemID = int(e.EventObj.itemId);
               count = int(e.EventObj.count);
               index = this._prizeCntArr.indexOf(count);
               var _temp_2:* = appModule;
               var _temp_1:* = ModuleEvent.DESTROY;
               with({})
               {
                  _temp_2.addEventListener(_temp_1,function onModuleDestroy(e:ModuleEvent):void
                  {
                     appModule.removeEventListener(ModuleEvent.DESTROY,onModuleDestroy);
                     Tool.alert(itemID,count);
                  });
               }
               
               public function destroy() : void
               {
                  BC.removeEvent(this);
               }
            }
         }
         
         