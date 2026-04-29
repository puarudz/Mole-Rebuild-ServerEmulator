package com.module.pig.view
{
   import com.common.Alert.Alert;
   import com.common.Alert.type.AlertType;
   import com.common.Tween.TweenLite;
   import com.common.data.HashMap;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.socket.pig.PigSocket;
   import com.module.pig.PigConfig;
   import com.module.pig.PigDragCtl;
   import com.module.pig.PigEvent;
   import com.module.pig.PigHouseEntrance;
   import com.module.pig.PigHouseUI;
   import com.module.pig.data.PigHouseData;
   import com.module.pig.view.pig.Pig;
   import com.module.popupMsg.PopupMsgCtl;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.utils.Delegate;
   
   public class PigsCtl
   {
      
      private static var _instance:PigsCtl;
      
      private var _pigs:HashMap;
      
      private var _flyBugMC:Sprite;
      
      private var _teamMsgMC:MovieClip;
      
      private var _teamTween:TweenLite;
      
      private var _teamTime:int = 0;
      
      public function PigsCtl()
      {
         super();
      }
      
      public static function get instance() : PigsCtl
      {
         if(_instance == null)
         {
            _instance = new PigsCtl();
         }
         return _instance;
      }
      
      public function get pigs() : HashMap
      {
         return this._pigs;
      }
      
      public function get pigCount() : int
      {
         if(this._pigs == null)
         {
            return 0;
         }
         return this._pigs.length;
      }
      
      public function isCanAddBaby(pig:Pig) : Boolean
      {
         var count:int = this.pigCountWithBaby;
         if(pig.pigData.isHasTwoBaby)
         {
            return count <= PigHouseData.instance.maxPigCount + 4;
         }
         return count <= PigHouseData.instance.maxPigCount + 5;
      }
      
      public function get pigCountWithBaby() : int
      {
         var pigs:Array = null;
         var pig:Pig = null;
         var count:int = this.pigCount;
         if(Boolean(this._pigs))
         {
            pigs = this._pigs.values;
            for each(pig in pigs)
            {
               if(pig.pigData.isHasBaby)
               {
                  if(pig.pigData.isHasTwoBaby)
                  {
                     count += 2;
                  }
                  else
                  {
                     count += 1;
                  }
               }
            }
         }
         return count;
      }
      
      public function Init(e:Event = null) : void
      {
         var pigs:Array = null;
         var pig:Pig = null;
         var i:int = 0;
         this._pigs = new HashMap();
         BC.addEvent(this,PigEvent.instance,PigEvent.Get_PigHouse_Data_OK,this.UpdatePigData);
         this.UpdatePigData();
         if(PigHouseData.instance.team > 0)
         {
            this.ShowTeam(PigHouseData.instance.team,PigHouseData.instance.teamMsg,false);
            setTimeout(this.HideTeam,10 * 1000);
         }
         else
         {
            pigs = this._pigs.values;
            for(i = 0; i < pigs.length; i++)
            {
               pig = pigs[i];
               pig.PlayHappy();
            }
         }
         if(PigHouseData.instance.batheTime == 0)
         {
            this.InitFlyBug();
         }
      }
      
      private function InitFlyBug() : void
      {
         this._flyBugMC = new Sprite();
         var loader:Loader = new Loader();
         loader.load(VL.getURLRequest("resource/pig/movie/flyBug.swf"));
         this._flyBugMC.addChild(loader);
         MovieClip(GV.MC_mapFrame.depth_mc).addChildAt(this._flyBugMC,0);
      }
      
      public function Clear() : void
      {
         var pigs:Array = null;
         var pigCount:int = 0;
         var i:int = 0;
         var pig:Pig = null;
         clearTimeout(this._teamTime);
         if(Boolean(this._pigs))
         {
            pigs = this._pigs.values;
            pigCount = int(pigs.length);
            for(i = 0; i < pigCount; i++)
            {
               pig = pigs[i];
               pig.Clear();
            }
         }
         BC.removeEvent(this);
         _instance = null;
      }
      
      public function AddPigSeedToHouse(pigItemId:int) : void
      {
         var _temp_4:* = BC;
         var _temp_3:* = this;
         var _temp_2:* = GV.onlineSocket;
         var _temp_1:* = "read_" + PigSocket.AddPigCmd;
         with({})
         {
            _temp_4.addOnceEvent(_temp_3,_temp_2,_temp_1,function h(e:EventTaomee):void
            {
               var pigs:Array = null;
               var data:HashMap = e.EventObj as HashMap;
               if(Boolean(data.getValue("isOk")))
               {
                  PigEvent.instance.DeleteBagItem(pigItemId);
                  pigs = PigHouseData.instance.pigs;
                  pigs.push(AddPig(data));
               }
               else
               {
                  PopupMsgCtl.PopupMsg("已經放不下更多的豬豬了！");
               }
            });
            PigSocket.AddPig(pigItemId);
         }
         
         private function AddPig(data:HashMap) : Pig
         {
            var pig:Pig = new Pig(data);
            this._pigs.add(pig.pigData.id,pig);
            var randomPoint:Point = MoveTo.getRandomFloorPoint();
            pig.pigView.x = randomPoint.x;
            pig.pigView.y = randomPoint.y;
            PigEvent.instance.dispatchEvent(new Event(PigEvent.Update_Pig_Count));
            return pig;
         }
         
         public function UpdatePigData(e:Event = null) : void
         {
            var pig:Pig = null;
            var pigs:Array = null;
            var data:HashMap = null;
            var pigId:int = 0;
            var oldPig:Pig = null;
            var currentPigs:Array = this._pigs.values;
            for each(pig in currentPigs)
            {
               if(PigHouseData.instance.pigsHashMap.containsKey(pig.pigData.id) == false)
               {
                  this._pigs.remove(pig.pigData.id);
                  pig.Clear();
               }
            }
            pigs = PigHouseData.instance.pigs;
            for each(data in pigs)
            {
               pigId = data.getValue("id");
               if(this._pigs.containsKey(pigId))
               {
                  oldPig = this._pigs.getValue(pigId);
                  oldPig.UpdateData(data);
               }
               else
               {
                  this.AddPig(data);
               }
            }
         }
         
         public function AddFood(itemId:int) : void
         {
            var name:String = null;
            var maxCount:int = 5;
            var feedCount:int = PigHouseData.instance.feedCnt;
            feedCount &= 65535;
            if(itemId == 1613102 && feedCount >= maxCount)
            {
               var _temp_3:* = Alert;
               var _temp_2:* = "今天餵食" + name + "已經超過" + maxCount + "次，不會再額外增加體重哦。";
               with({})
               {
                  
                  _temp_3.smileAlart(_temp_2,function h(e:*):void
                  {
                     DoAddFood(itemId);
                  },AlertType.SURE);
               }
               else
               {
                  this.DoAddFood(itemId);
               }
            }
            
            private function DoAddFood(itemId:int) : void
            {
               BC.addOnceEvent(this,GV.onlineSocket,"read_" + PigSocket.AddFoodCmd,Delegate.create(this.AddFoodHandler,itemId));
               PigSocket.AddFood(PigHouseEntrance.instance.userId,itemId);
            }
            
            private function AddFoodHandler(e:EventTaomee, itemId:int) : void
            {
               /*
                * Decompilation error
                * Code may be obfuscated
                * Tip: You can try enabling "Deobfuscate code" option in Settings
                * Error type: IndexOutOfBoundsException (Index -1 out of bounds for length 0)
                */
               throw new flash.errors.IllegalOperationError("Not decompiled due to error");
            }
            
            public function Bathe(e:Event = null) : void
            {
               if(PigsCtl.instance.pigCount == 0)
               {
                  PopupMsgCtl.PopupMsg("還沒有豬豬哦！");
                  return;
               }
               BC.addOnceEvent(this,GV.onlineSocket,"read_" + PigSocket.BatheCmd,this.BatheHandler);
               PigSocket.Bathe(PigHouseEntrance.instance.userId);
            }
            
            private function BatheHandler(e:EventTaomee) : void
            {
               var time:int = 0;
               var hour:int = 0;
               var minute:int = 0;
               var str:String = null;
               if(e.EventObj.isOk == 1)
               {
                  PigHouseData.instance.GetPigHouseData();
                  PopupMsgCtl.PopupMsg("    恭喜你獲得2點經驗值！");
                  var _temp_1:* = GC;
                  with({})
                  {
                     
                     _temp_1.setGTimeout(function h():void
                     {
                        GC.clearAll(_flyBugMC);
                     },2000);
                  }
                  else
                  {
                     time = int(e.EventObj.time);
                     hour = int(time / 60);
                     minute = time % 60;
                     str = "";
                     if(hour > 0)
                     {
                        str += hour + "小時";
                     }
                     if(minute > 0)
                     {
                        str += minute + "分鐘";
                     }
                     PopupMsgCtl.PopupMsg("還需要" + str + "才能洗澡哦。");
                  }
               }
               
               public function ShowTeam(teamId:int, msg:String = null, runto:Boolean = true) : void
               {
                  var pigs:Array;
                  var i:int;
                  var teamPos:Array = null;
                  var pig:Pig = null;
                  var pos:Point = null;
                  if(teamId == 0)
                  {
                     return;
                  }
                  pigs = this._pigs.values;
                  if(teamId > 1)
                  {
                     teamPos = PigConfig.Teams[teamId + "_" + pigs.length];
                     if(teamPos == null)
                     {
                        this.ShowTeam(1,msg,runto);
                        return;
                     }
                  }
                  else if(teamId == 1)
                  {
                     teamPos = PigConfig.Teams["1"];
                  }
                  for(i = 0; i < pigs.length; i++)
                  {
                     pig = pigs[i];
                     pos = teamPos[i];
                     if(runto)
                     {
                        pig.StopTo(pos.x,pos.y);
                     }
                     else
                     {
                        pig.pigView.x = pos.x;
                        pig.pigView.y = pos.y;
                        pig.PlayHappy(false);
                     }
                  }
                  if(Boolean(msg))
                  {
                     if(Boolean(this._teamMsgMC))
                     {
                        GC.clearAll(this._teamMsgMC);
                     }
                     var _temp_3:* = this;
                     with({})
                     {
                        
                        _temp_3._teamTime = setTimeout(function showTip():void
                        {
                           if(Boolean(_teamMsgMC))
                           {
                              try
                              {
                                 _teamMsgMC.msg_txt.text = msg;
                                 _teamMsgMC.x = 503;
                                 _teamMsgMC.y = 160;
                                 _teamMsgMC.scaleX = _teamMsgMC.scaleY = 0.1;
                                 GV.MC_mapTop.addChild(_teamMsgMC);
                                 _teamTween = TweenLite.to(_teamMsgMC,0.5,{
                                    "scaleX":1,
                                    "scaleY":1
                                 });
                              }
                              catch(e:Error)
                              {
                              }
                           }
                        },2 * 1000);
                     }
                  }
                  
                  public function canShowTeam(teamId:int) : Boolean
                  {
                     var teamPos:Array = null;
                     if(teamId <= 0)
                     {
                        return false;
                     }
                     if(teamId > 1)
                     {
                        teamPos = PigConfig.Teams[teamId + "_" + this.pigCount];
                        if(teamPos == null)
                        {
                           return false;
                        }
                        return true;
                     }
                     return true;
                  }
                  
                  public function HideTeam(e:Event = null) : void
                  {
                     /*
                      * Decompilation error
                      * Code may be obfuscated
                      * Tip: You can try enabling "Deobfuscate code" option in Settings
                      * Error type: IndexOutOfBoundsException (Index -1 out of bounds for length 0)
                      */
                     throw new flash.errors.IllegalOperationError("Not decompiled due to error");
                  }
                  
                  private function UndatePigView(e:Event = null) : void
                  {
                     var pig:Pig = null;
                     var pigs:Array = this._pigs.values;
                     for each(pig in pigs)
                     {
                        pig.pigView.Update();
                     }
                  }
                  
                  private function Reset() : void
                  {
                     this.HideTeam();
                     this.UndatePigView();
                  }
                  
                  public function get trainTypes() : HashMap
                  {
                     var pig:Pig = null;
                     var types:HashMap = new HashMap();
                     var pigs:Array = this._pigs.values;
                     for each(pig in pigs)
                     {
                        if(pig.pigView.waitTrainType == 1)
                        {
                           types.add("train_" + pig.pigData.breed + "1",true);
                        }
                        if(pig.pigView.waitTrainType == 2)
                        {
                           types.add("train_" + pig.pigData.breed + "2",true);
                        }
                     }
                     return types;
                  }
                  
                  public function StartTrain() : void
                  {
                     var pig:Pig = null;
                     PeopleManageView(GV.MAN_PEOPLE).stopToHere();
                     var pigs:Array = this._pigs.values;
                     for each(pig in pigs)
                     {
                        if(pig.pigView.hitTestObject(PigDragCtl.dragUI))
                        {
                           pig.Train(PigDragCtl.dragId);
                        }
                     }
                     PigDragCtl.StopDrag();
                  }
               }
            }
            
            