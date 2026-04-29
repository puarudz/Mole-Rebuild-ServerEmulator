package com.logic.MapControlLogic
{
   import com.common.Alert.Alert;
   import com.common.soundControl.soundControl;
   import com.common.util.MovieClipUtil;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.info.MapInfo;
   import com.core.login.BringTagoutLogin;
   import com.core.manager.AssetsManage;
   import com.core.music.TopicMusicManager;
   import com.core.newloader.LoaderList;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.global.staticData.MapsConfig;
   import com.global.staticData.XMLInfo;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.PeopleCountLogic.PeopleCountLogic;
   import com.logic.mapEvent.MapEvent;
   import com.logic.socket.ParseSocketErrorCode;
   import com.logic.socket.session.BringTagoutLoginSocket;
   import com.module.ListSMC.ExNPC;
   import com.module.activityModule.checkItem;
   import com.module.car.CarManage;
   import com.module.dragon.DragonManage;
   import com.module.npc.NPC;
   import com.module.pet.petInMapLogic;
   import com.module.sceneSoundModule.sceneSoundModule;
   import com.module.specialGoods.MyCardsLogic;
   import com.module.superPetModule.petItemModule;
   import com.module.throwThing.throwHitTest;
   import com.mole.app.manager.MapActivityManager;
   import com.mole.app.map.MapManager;
   import com.view.FightWorld.FightWorld;
   import com.view.LamuWorld.LamuWorld;
   import com.view.PeopleView.PeopleManageView;
   import com.view.toolView.toolView;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   
   public class MapControlLogic extends BaseBean
   {
      
      public static var taskGQ_mc:MovieClip;
      
      private var ExNPCs:ExNPC;
      
      private var mycard:MyCardsLogic;
      
      public function MapControlLogic()
      {
         super();
         GV.soundAssets = new AssetsManage(true);
         GV.soundCon = new soundControl();
         GV.soundAssets.IncludeLib("SoundLib","resource/soundLib/lib1.swf","",false,LoaderList.getPRI_Obj(LoaderList.LOW,true));
         BC.addEvent(this,GV.soundAssets,AssetsManage.ON_COMPLETE,this.loadLibcomplete);
         GV.xd_msg = XMLInfo.xd_msg;
         CarManage.getInstance().init();
         DragonManage.getInstance().init();
      }
      
      private function loadLibcomplete(E:Event) : void
      {
         GV.soundCon.setLib(GV.soundAssets.getLoader());
         BC.removeEvent(this,GV.soundAssets,AssetsManage.ON_COMPLETE,this.loadLibcomplete);
      }
      
      override public function start() : void
      {
         this.init();
         finish();
      }
      
      public function requestSessionByOnline(canJump:Boolean = false) : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + 2010,function(e:EventTaomee):void
         {
            var byte:ByteArray = new ByteArray();
            ByteArray(e.EventObj).position = 0;
            byte.writeUnsignedInt(LocalUserInfo.getUserID());
            ByteArray(e.EventObj).readBytes(byte,4);
            byte.position = 0;
            BringTagoutLogin.set_URL_Session(byte,canJump);
         });
         BringTagoutLoginSocket.getSID();
      }
      
      public function init() : void
      {
         var mySoundLib:soundControl;
         var mapID:uint;
         var urls:String;
         var mapinfo:MapInfo;
         var flag:Boolean = false;
         var toolBar_mc:MovieClip = MainManager.getToolLevel().getChildByName("tool_mc") as MovieClip;
         if(Boolean(toolBar_mc))
         {
            toolBar_mc.visible = true;
         }
         mySoundLib = GV.soundCon as soundControl;
         if(Boolean(mySoundLib))
         {
            mySoundLib.destroy();
         }
         throwHitTest.HitTestPeople();
         MoveTo.CanAutoFind = true;
         mapID = LocalUserInfo.getMapID();
         if(mapID < 50000)
         {
            TopicMusicManager.instance.playSound(mapID);
         }
         petItemModule.setPetEffectHandler();
         urls = "resource/xml/NPC/NPCJoblist" + mapID + ".xml";
         this.ExNPCs = new ExNPC(urls);
         this.ExNPCs.addEventListener(ExNPC.ALLDATE,this.getExNPC,false,0,false);
         this.changeHandler();
         GV.onlineSocket.dispatchEvent(new EventTaomee("wordMapChang_over"));
         sceneSoundModule.addEventSound();
         this.cavalierBookEvent();
         NPC.addNPCInMap();
         mapinfo = MapInfo.getMapInfo(mapID,LocalUserInfo.getMapType());
         if(Boolean(mapinfo.isHSL))
         {
            if(Boolean(GV.MC_ToolView))
            {
               GV.MC_ToolView.map_btn.gotoAndStop(2);
            }
         }
         else if(Boolean(mapinfo.isMLSL))
         {
            if(Boolean(GV.MC_ToolView))
            {
               GV.MC_ToolView.map_btn.gotoAndStop(5);
            }
         }
         else if(Boolean(mapinfo.isAngel))
         {
            if(Boolean(GV.MC_ToolView))
            {
               GV.MC_ToolView.map_btn.gotoAndStop(3);
            }
         }
         else if(mapID == 184)
         {
            if(Boolean(GV.MC_ToolView))
            {
               GV.MC_ToolView.map_btn.gotoAndStop(4);
            }
         }
         else if(mapID == 242 || mapID == 243 || mapID == 244 || mapID == 245 || mapID == 246 || mapID == 247 || mapID == 248 || mapID == 249 || mapID == 250)
         {
            GV.MC_ToolView.map_btn.gotoAndStop(6);
         }
         else if(Boolean(mapinfo.isDXSL))
         {
            if(Boolean(GV.MC_ToolView))
            {
               GV.MC_ToolView.map_btn.gotoAndStop(16);
            }
         }
         else if(Boolean(GV.MC_ToolView))
         {
            MovieClipUtil.gotoAndStop(GV.MC_ToolView.map_btn,1);
         }
         if(!MapsConfig.MapsInfo[mapID])
         {
            flag = false;
         }
         else
         {
            flag = Boolean(MapsConfig.MapsInfo[mapID].isLamuWorld);
         }
         if(flag)
         {
            this.intoLamuWorld(mapID);
            PeopleCountLogic.peopleList.every(function(obj:Object, index:int, arr:Array):Boolean
            {
               var pd:PeopleManageView = obj.Instance as PeopleManageView;
               if(pd.hasLamu)
               {
                  pd.lamuMode = true;
               }
               return true;
            });
            toolView.setToolBtns(1,1,0,0,0,1,1,1,1);
            BC.addEvent(this,PeopleCountLogic.owner,PeopleCountLogic.ONPEOPLEINMAP,this.inmap);
         }
         else
         {
            if(Boolean(mapinfo) && Boolean(mapinfo.isFightWorld))
            {
               this.intoFightWorld(mapID);
            }
            if(Boolean(LamuWorld.instance))
            {
               LamuWorld.instance.clean();
            }
         }
         if(ParseSocketErrorCode.isError)
         {
            MapManager.enterMap(1);
            ParseSocketErrorCode.isError = false;
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(MapEvent.CHANGE_MAP_COMPLETE));
         MapActivityManager.setup();
      }
      
      private function offLineBoxHandler(evt:MCLoadEvent) : void
      {
         var msg:String = "  恭喜你獲得2個拉姆愛吃的拉姆能量星、5個新上市的青瓜種子，快去看看吧！";
         Alert.showAlert(MainManager.getAppLevel(),msg,"",6,"E");
         LocalUserInfo.CanGetGoodyBag = false;
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:Loader = evt.getLoader();
         mainMC.addChild(childMC);
         MCLoader(evt.target).removeEventListener(MCLoadEvent.ON_SUCCESS,this.offLineBoxHandler);
         MCLoader(evt.target).clear();
      }
      
      private function removeoffline(e:Event) : void
      {
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeoffline);
         var mc:Sprite = MainManager.getTopLevel().getChildByName("offLineBox") as Sprite;
         if(Boolean(mc))
         {
            MainManager.getTopLevel().removeChild(mc);
         }
      }
      
      private function inmap(e:EventTaomee) : void
      {
         var pd:PeopleManageView = e.EventObj as PeopleManageView;
         if(pd.hasLamu)
         {
            pd.lamuMode = true;
         }
      }
      
      private function getExNPC(e:*) : void
      {
         this.ExNPCs.removeEventListener(ExNPC.ALLDATE,this.getExNPC);
         ExNPC.ExNPC_arr = e.EventObj.NPC_arr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("NPCwordMapChang_over"));
      }
      
      private function changeHandler() : void
      {
         GV.isChangeMap = false;
         petInMapLogic.getPetNumInMap();
      }
      
      private function cavalierBookEvent() : void
      {
         var mapID:int = LocalUserInfo.getMapID();
         if(mapID > 60 && mapID < 65 || mapID == 151 || mapID == 152)
         {
            GV.onlineSocket.addEventListener("removeMapEvent",this.removeMapEvent);
            GV.MC_mapFrame["top_mc"].bossBtn.addEventListener(MouseEvent.CLICK,this.showBookEvent);
         }
         else if(mapID > 124)
         {
            GV.onlineSocket.addEventListener("removeMapEvent",this.removeLamuWorld);
         }
      }
      
      private function showBookEvent(evt:MouseEvent) : void
      {
         GV.onlineSocket.addEventListener(checkItem.chekItem_suc,this.chekItemHandler);
         checkItem.checkItemHandler(160191);
      }
      
      private function chekItemHandler(evt:EventTaomee) : void
      {
         var explain:String = null;
         var url:String = null;
         var alert:* = undefined;
         var thisobj:* = undefined;
         GV.onlineSocket.removeEventListener(checkItem.chekItem_suc,this.chekItemHandler);
         if(evt.EventObj.num == 1)
         {
            if(!this.mycard)
            {
               this.mycard = new MyCardsLogic();
            }
            else
            {
               GV.onlineSocket.dispatchEvent(new EventTaomee("reshow_card"));
            }
         }
         else if(LocalUserInfo.getMapID() != 62)
         {
            explain = "    你沒有任何騎士卡牌，馬上去騎士訓練營領取騎士卡牌冊吧！";
            url = "module/gameUI/icon/002.swf";
            alert = Alert.showAlert(MainManager.getGameLevel(),url,explain,Alert.CHANG_ALERT,"go,ok",true,false,"EMP_BUY");
            thisobj = this;
            BC.addEvent(thisobj,alert,Alert.CLICK_ + 1,function(... e):void
            {
               BC.removeEvent(thisobj,alert);
               GF.switchMap(62,true);
            });
         }
         else
         {
            Alert.smileAlart("    趕快領取騎士卡牌冊吧！");
         }
      }
      
      private function removeMapEvent(evt:EventTaomee) : void
      {
         this.mycard = null;
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeMapEvent);
         GV.MC_mapFrame["top_mc"].bossBtn.removeEventListener(MouseEvent.CLICK,this.showBookEvent);
         BC.removeEvent(this,PeopleCountLogic.owner,PeopleCountLogic.ONPEOPLEINMAP,this.inmap);
      }
      
      private function removeLamuWorld(evt:EventTaomee) : void
      {
         if(Boolean(LamuWorld.instance))
         {
            GV.lamuLive = LamuWorld.instance.lives;
            LamuWorld.instance.clean();
         }
         LamuWorld.getInstance().removed();
         GV.onlineSocket.removeEventListener("lamuComplete",this.lamuComplete);
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeMapEvent);
      }
      
      private function intoLamuWorld(mapID:int) : void
      {
         if(GV.MAN_PEOPLE.Petlevel < 2)
         {
            return;
         }
         if(!LamuWorld.getInstance().isComplete)
         {
            GV.onlineSocket.addEventListener("lamuComplete",this.lamuComplete);
            LamuWorld.getInstance().loadUI();
         }
         else
         {
            this.lamuComplete();
         }
      }
      
      private function intoFightWorld(mapID:int) : void
      {
         if(!FightWorld.getInstance().isComplete)
         {
            GV.onlineSocket.addEventListener("fightComplete",this.fightComplete);
            FightWorld.getInstance().loadUI();
         }
         else
         {
            this.fightComplete();
         }
      }
      
      private function fightComplete(e:Event = null) : void
      {
         GV.onlineSocket.removeEventListener("fightComplete",this.fightComplete);
         FightWorld.getInstance().init();
         FightWorld.getInstance().mapinit();
         FightWorld.getInstance().addLamuEvents();
      }
      
      private function lamuComplete(e:Event = null) : void
      {
         GV.onlineSocket.removeEventListener("lamuComplete",this.lamuComplete);
         LamuWorld.getInstance().init();
         LamuWorld.getInstance().mapinit();
         LamuWorld.getInstance().addLamuEvents();
      }
   }
}

