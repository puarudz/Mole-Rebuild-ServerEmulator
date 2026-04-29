package com.mole.app.activity
{
   import com.common.Alert.Alert;
   import com.common.Alert.type.AlertType;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.module.activityModule.Presented;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.BufferManager;
   import com.mole.app.manager.PeopleManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapManager;
   import com.mole.app.utils.PlayMovie;
   import com.taomee.mole.cache.CacheManager;
   import com.view.MapManageView.MapManageView;
   import com.view.PeopleView.PeopleManageView;
   import com.view.player.MultiEquipPlayer;
   import com.view.player.PlayerActionConstant;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.loader.ContentInfo;
   import org.taomee.utils.Tick;
   
   public class FireVulCanCup
   {
      
      private static var _inst:FireVulCanCup;
      
      private var arr:Array = [{
         "ItemID":15071,
         "layer":45
      },{
         "ItemID":15072,
         "layer":15
      },{
         "ItemID":15073,
         "layer":5
      },{
         "ItemID":15074,
         "layer":55
      }];
      
      private var TASKSTEP:uint = 6;
      
      private var _culCanStep:uint;
      
      private var _mapIndex:uint;
      
      public var isFollowed:Boolean;
      
      private var _needMapVec:Vector.<uint> = new <uint>[342,142,330,2,80,344,99999];
      
      private var _preMapID:uint;
      
      private var _mapPointVec:Array = [[765,440],[157,297],[668,469],[321,378],[674,467]];
      
      public var currentDirectionNum:uint;
      
      private var clickMc:MovieClip;
      
      private var followPlayer:MultiEquipPlayer;
      
      private var peopleView:PeopleManageView;
      
      private var seaContent:DisplayObject;
      
      public var isShowNpc:Boolean;
      
      private var _npcTipMc:MovieClip;
      
      public function FireVulCanCup()
      {
         super();
      }
      
      public static function getInst() : FireVulCanCup
      {
         if(!_inst)
         {
            _inst = new FireVulCanCup();
         }
         return _inst;
      }
      
      public function getIn() : void
      {
         var mc:MovieClip = null;
         GV.onlineSocket.addEventListener("removeMapEvent",this.onChangeMap);
         SystemEventManager.addEventListener("fireCup0",this.curCanHandle);
         if(FireCupStep.inst.fireStep == 0)
         {
            return;
         }
         if(FireCupStep.inst.fireStep == 6)
         {
            this.checkFired();
         }
         if(this.isShowNpc == false)
         {
            return;
         }
         trace("lucas火神盃的任務步驟" + FireCupStep.inst.fireStep);
         GV.onlineSocket.addEventListener("clickMap",this.ClickMapHandle);
         if(MapManager.curMapID == this._needMapVec[FireCupStep.inst.fireStep])
         {
            this.isFollowed = true;
            GV.onlineSocket.addEventListener("removeMapEvent",this.onChangeMap);
            this._culCanStep = FireCupStep.inst.fireStep;
            if(this._culCanStep > 0)
            {
               mc = MapManageView.inst.mapLevel.depthLevel["fireCup" + this._culCanStep + "_mc"];
               MapManageView.inst.mapLevel.depthLevel.mouseChildren = true;
               MapManageView.inst.mapLevel.depthLevel.mouseEnabled = true;
               mc.mouseChildren = true;
               mc.mouseEnabled = true;
               mc.buttonMode = true;
               if(mc.currentFrame != 2)
               {
                  BC.addEvent(this,mc,MouseEvent.CLICK,this.onClickMc);
               }
            }
         }
         else
         {
            this.isFollowed = false;
            this.checkFired();
         }
         this.addSource();
      }
      
      private function addSource() : void
      {
         this.followPlayer = new MultiEquipPlayer({
            "red":0,
            "green":0,
            "blue":0
         });
         this.followPlayer.updateEquip(this.arr);
         if(MapManager.curMapID == 28)
         {
            MapManageView.inst.mapLevel.topLevel.addChild(this.followPlayer);
         }
         else
         {
            MapManageView.inst.mapLevel.depthLevel.addChild(this.followPlayer);
            MapManageView.inst.mapLevel.depthLevel.setChildIndex(this.followPlayer,MapManageView.inst.mapLevel.depthLevel.numChildren - 1);
         }
         CacheManager.getPhasorContent("resource/lucas/20130809/npcTips.swf","LU_NPCSearchTip",this.loadComplete);
         Tick.instance.addRender(this.renderHandler);
         this.peopleView = PeopleManager.getPeopleView(LocalUserInfo.getUserID());
         BC.addEvent(this,this.peopleView,PeopleManageView.ON_CHANGE_DIRECTION,this.changeAnimalDir);
         BC.addEvent(this,this.peopleView,PeopleManageView.ON_GO_OVER,this.stopMoveFun);
      }
      
      private function ClickMapHandle(e:EventTaomee) : void
      {
         trace("222222");
         if(FireCupStep.inst.fireStep > 0)
         {
            Alert.angryAlart("  跳轉地圖的話跟隨的NPC會消失哦！小摩爾確實要跳轉麼?",function(e:Event):void
            {
               _culCanStep = 0;
               MovieClip(MapManageView.inst.mapLevel.topLevel).removeChild(seaContent);
               if(MapManager.curMapID == 28)
               {
                  MapManageView.inst.mapLevel.topLevel.removeChild(followPlayer);
               }
               else
               {
                  MapManageView.inst.mapLevel.depthLevel.removeChild(followPlayer);
               }
               BufferManager.setBuffer(BufferManager.FIRE_VULCAN_CUP,0);
               FireCupStep.inst.getStep();
               isShowNpc = false;
            },AlertType.SURE + "," + AlertType.CANCEL);
         }
      }
      
      private function loadComplete(contentInfo:ContentInfo) : void
      {
         this.seaContent = contentInfo.content;
         if(Boolean(MapManageView.inst.mapLevel.controlLevel))
         {
            MovieClip(MapManageView.inst.mapLevel.topLevel).addChild(this.seaContent);
            this._npcTipMc = MovieClip(this.seaContent);
            this._npcTipMc.gotoAndStop(FireCupStep.inst.fireStep);
         }
      }
      
      private function checkFired() : void
      {
         for(var i:uint = 0; i < this._needMapVec.length; i++)
         {
            if(i <= FireCupStep.inst.fireStep && i > 1)
            {
               if(MapManager.curMapID == this._needMapVec[i - 1])
               {
                  MapManageView.inst.mapLevel.depthLevel["fireCup" + (i - 1) + "_mc"].gotoAndStop(2);
                  break;
               }
            }
         }
      }
      
      private function stopMoveFun(E:*) : void
      {
         this.followPlayer.doAction(PlayerActionConstant.ACTION_STAND,this.currentDirectionNum);
         this.followPlayer.stop();
      }
      
      private function changeAnimalDir(E:EventTaomee) : void
      {
         this.currentDirectionNum = E.currentTarget.avatarClass.DirectionNum;
         this.followPlayer.doAction(PlayerActionConstant.ACTION_RUN,this.currentDirectionNum);
      }
      
      protected function renderHandler(... ret) : void
      {
         this.followPlayer.x = this.peopleView.x - 50;
         this.followPlayer.y = this.peopleView.y - 10;
         this.followPlayer.globalToLocal(new Point(this.followPlayer.x,this.followPlayer.y));
         if(Boolean(this.seaContent))
         {
            this.seaContent.x = this.followPlayer.x + 70;
            this.seaContent.y = this.followPlayer.y - 60;
         }
      }
      
      private function onClickMc(e:Event) : void
      {
         var mcc:MovieClip = e.target as MovieClip;
         this.clickMc = mcc;
         BC.addEvent(this,this.peopleView,PeopleManageView.ON_GO_OVER,this.bodyGoToPosMC);
         this.peopleView.moveTo(this._mapPointVec[this._culCanStep - 1][0],this._mapPointVec[this._culCanStep - 1][1]);
      }
      
      private function bodyGoToPosMC(e:Event) : void
      {
         var movie:PlayMovie = null;
         BC.removeEvent(this,this.peopleView,PeopleManageView.ON_GO_OVER,this.bodyGoToPosMC);
         if(this.peopleView.x == this._mapPointVec[this._culCanStep - 1][0] && this.peopleView.y == this._mapPointVec[this._culCanStep - 1][1])
         {
            this.followPlayer.visible = false;
            this._npcTipMc.visible = false;
            movie = PlayMovie.play("resource/lucas/20130809/fireCup" + this._culCanStep + ".swf",null,null,function():void
            {
               clickMc.mouseChildren = false;
               clickMc.mouseEnabled = false;
               _npcTipMc.visible = true;
               followPlayer.visible = true;
               movie.destroy();
               clickMc.gotoAndStop(2);
               curCanHandle();
            });
         }
      }
      
      private function curCanHandle(e:SystemEvent = null) : void
      {
         if(FireCupStep.inst.fireStep == 6)
         {
            Alert.smileAlart("  小摩爾已經完成任務了哦");
            return;
         }
         GV.onlineSocket.addEventListener("clickMap",this.ClickMapHandle);
         if(this._culCanStep == 0)
         {
            this.addSource();
         }
         this.isShowNpc = true;
         ++this._culCanStep;
         BufferManager.setBuffer(BufferManager.FIRE_VULCAN_CUP,this._culCanStep);
         FireCupStep.inst.getStep();
         if(this._culCanStep > 1)
         {
            this._npcTipMc.gotoAndStop(this._culCanStep);
         }
         this.getPrize();
      }
      
      private function getPrize() : void
      {
         if(this._culCanStep >= this.TASKSTEP)
         {
            Presented.getInstance().celebrate1225(2742);
            MovieClip(MapManageView.inst.mapLevel.topLevel).removeChild(this.seaContent);
            if(MapManager.curMapID == 28)
            {
               MapManageView.inst.mapLevel.topLevel.removeChild(this.followPlayer);
            }
            else
            {
               MapManageView.inst.mapLevel.depthLevel.removeChild(this.followPlayer);
            }
            this.isShowNpc = false;
         }
      }
      
      private function onChangeMap(e:*) : void
      {
         GV.onlineSocket.removeEventListener("clickMap",this.ClickMapHandle);
         BC.removeEvent(this,this.peopleView,PeopleManageView.ON_GO_OVER,this.bodyGoToPosMC);
         GV.onlineSocket.removeEventListener("removeMapEvent",this.onChangeMap);
         SystemEventManager.removeEventListener("fireCup" + this._culCanStep,this.curCanHandle);
         Tick.instance.removeRender(this.renderHandler);
         if(MapManager.curMapID != this._needMapVec[this._preMapID])
         {
            this._culCanStep = 0;
         }
      }
   }
}

