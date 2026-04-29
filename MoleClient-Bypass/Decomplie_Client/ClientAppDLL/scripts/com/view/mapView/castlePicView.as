package com.view.mapView
{
   import com.common.util.DisplayUtil;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.greensock.TweenLite;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.PeopleCountLogic.PeopleCountLogic;
   import com.logic.socket.NewGetLimitStatus;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.NewStatisticsManager;
   import com.mole.app.manager.SimpleIntrPanelManager;
   import com.mole.app.map.MapBase;
   import com.mole.net.events.SocketEvent;
   import com.view.PeopleView.PeopleManageView;
   import com.view.mapView.activity.map16.SixYearTollyActivity;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import org.taomee.net.SocketEvent;
   
   public class castlePicView extends MapBase
   {
      
      private var _dictionary:Dictionary;
      
      private var _sixYearTolly:SixYearTollyActivity;
      
      private var effects:Array = [];
      
      private var _flower1:int;
      
      private var _flower2:int;
      
      private var myflower:MovieClip;
      
      public function castlePicView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         controlLevel.room_btn.buttonMode = true;
         controlLevel.room_btn.addEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
         controlLevel.room_btn.addEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
         ModuleManager.openPanel("WorshipNPCPanel");
         this._dictionary = new Dictionary();
         GV.onlineSocket.addEventListener(PeopleCountLogic.ONPEOPLEINIT,this.onPeopleInit);
         GV.onlineSocket.addEventListener(PeopleCountLogic.ONPEOPLEINMAP,this.onPeopleInMap);
         GV.onlineSocket.addEventListener(PeopleCountLogic.ONPEOPLEOUTMAP,this.onPeopleOutMap);
         GV.onlineSocket.addCmdListener(CommandID.CLI_PROTO_PRINCESS_FLOWER_RING_GIVE,this.flowerHandle);
         this.requestInfo();
      }
      
      private function flowerHandle(e:org.taomee.net.SocketEvent) : void
      {
         var uid:int = 0;
         var num:int = 0;
         var byte:ByteArray = e.data as ByteArray;
         if(byte != null)
         {
            uid = int(byte.readUnsignedInt());
            num = int(byte.readUnsignedInt());
            if(uid == LocalUserInfo.getUserID())
            {
               this.addEffect(1,1,uid);
            }
            else
            {
               this.addEffect(num,2,uid);
            }
            this.requestInfo();
         }
      }
      
      private function addEffect(num:int, type:int, uid:int) : void
      {
         var a:MovieClip = null;
         var a2:MovieClip = null;
         var a3:MovieClip = null;
         var p:Point = null;
         var tmp1:MovieClip = null;
         var cla:Class = _mapLibrary.getClass("addeff");
         var cla2:Class = _mapLibrary.getClass("redeff");
         if(Boolean(this._dictionary))
         {
            tmp1 = this._dictionary[uid];
            if(Boolean(tmp1))
            {
               a = new cla();
               a.gotoAndStop(1);
               p = topLevel.globalToLocal(tmp1.localToGlobal(new Point(tmp1.x,tmp1.y)));
               a.x = p.x;
               a.y = p.y + 20;
               topLevel.addChild(a);
               TweenLite.to(a,0.5,{
                  "y":a.y - 50,
                  "onComplete":this.clearEffect,
                  "onCompleteParams":[a]
               });
               this.effects.push(a);
            }
            if(type == 2)
            {
               tmp1 = this._dictionary[LocalUserInfo.getUserID()];
               if(Boolean(tmp1))
               {
                  a2 = new cla2();
                  p = topLevel.globalToLocal(tmp1.localToGlobal(new Point(tmp1.x,tmp1.y)));
                  a2.x = p.x + 20;
                  a2.y = p.y + 20;
                  topLevel.addChild(a2);
                  TweenLite.to(a2,0.5,{
                     "y":a2.y - 50,
                     "onComplete":this.clearEffect,
                     "onCompleteParams":[a2]
                  });
                  this.effects.push(a2);
                  a3 = new cla();
                  a3.gotoAndStop(num);
                  p = topLevel.globalToLocal(tmp1.localToGlobal(new Point(tmp1.x,tmp1.y)));
                  a3.x = p.x - 20;
                  a3.y = p.y + 20;
                  topLevel.addChild(a3);
                  TweenLite.to(a3,0.5,{
                     "y":a3.y - 50,
                     "onComplete":this.clearEffect,
                     "onCompleteParams":[a3]
                  });
                  this.effects.push(a3);
               }
            }
         }
      }
      
      private function clearEffect(a:DisplayObject = null) : void
      {
         var obj:DisplayObject = null;
         var idx:int = 0;
         var i:int = 0;
         if(Boolean(this.effects))
         {
            if(a != null)
            {
               TweenLite.killTweensOf(a);
               if(Boolean(a.parent))
               {
                  a.parent.removeChild(a);
               }
               idx = this.effects.indexOf(a);
               if(idx != -1)
               {
                  this.effects.splice(idx,1);
               }
               a = null;
            }
            else
            {
               for(i = 0; i < this.effects.length; i++)
               {
                  obj = this.effects[i] as DisplayObject;
                  TweenLite.killTweensOf(obj);
                  if(Boolean(obj.parent))
                  {
                     obj.parent.removeChild(obj);
                  }
                  obj = null;
               }
               this.effects = null;
            }
         }
      }
      
      private function onPeopleInit(evt:EventTaomee) : void
      {
         var p:Object = null;
         var peopleList:Array = PeopleCountLogic.peopleList;
         for each(p in peopleList)
         {
            this.showPaoPao(p.Instance);
         }
      }
      
      private function requestInfo(e:* = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"SocketEvent_Data" + CommandID.FOR_CLI_REQUET,this.onGetNum);
         BC.addEvent(this,GV.onlineSocket,"SocketEvent_Data" + CommandID.FOR_CLI_REQUET,this.onGetNum);
         NewGetLimitStatus.send([11075,11076,11077]);
      }
      
      private function onGetNum(e:com.mole.net.events.SocketEvent) : void
      {
         var flag:uint = 0;
         BC.removeEvent(this,GV.onlineSocket,"SocketEvent_Data" + CommandID.FOR_CLI_REQUET,this.onGetNum);
         var arr:Array = e.bodyInfo.getInfo as Array;
         this._flower1 = arr[0].value;
         this._flower2 = arr[1].value;
         if(LocalUserInfo.isVIP())
         {
            this._flower2 = 13 - this._flower2;
         }
         else
         {
            this._flower2 = 10 - this._flower2;
         }
         this.checkMyflower();
      }
      
      private function checkMyflower() : void
      {
         if(Boolean(this.myflower))
         {
            this.myflower["f1"].text = this._flower1;
            this.myflower["f2"].text = this._flower2;
         }
      }
      
      private function onPeopleInMap(evt:EventTaomee) : void
      {
         this.showPaoPao(evt.EventObj as PeopleManageView);
      }
      
      private function onPeopleOutMap(e:EventTaomee) : void
      {
         if(this._dictionary[e.EventObj] != null)
         {
            DisplayUtil.removeFromParent(this._dictionary[e.EventObj]);
         }
      }
      
      private function showPaoPao(mc:PeopleManageView) : void
      {
         var MyMadel:MovieClip = null;
         var cla:Class = null;
         if(mc.id != LocalUserInfo.getUserID())
         {
            cla = _mapLibrary.getClass("flower");
         }
         else
         {
            cla = _mapLibrary.getClass("flower1");
         }
         MyMadel = new cla();
         this._dictionary[mc.id] = MyMadel;
         MyMadel.name = "typeIcon";
         MyMadel.y = -60;
         MyMadel.useid = mc.id;
         MyMadel.buttonMode = true;
         mc.headTopBtn.addChild(MyMadel);
         mc.headTopBtn.showTarget();
         MyMadel.addEventListener(MouseEvent.MOUSE_DOWN,this.onCLiclPK);
         MyMadel.addEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
         MyMadel.addEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         if(mc.id == LocalUserInfo.getUserID())
         {
            this.myflower = MyMadel;
         }
         this.checkMyflower();
      }
      
      private function onCLiclPK(e:MouseEvent) : void
      {
         var curMc:MovieClip = e.currentTarget as MovieClip;
         if(curMc != null && curMc.useid != LocalUserInfo.getUserID())
         {
            GF.sendSocket(CommandID.CLI_PROTO_PRINCESS_FLOWER_RING_GIVE,curMc.useid);
         }
      }
      
      private function onMouseOver(e:MouseEvent) : void
      {
         e.updateAfterEvent();
         MoveTo.CanMove = false;
      }
      
      private function onMouseOut(e:MouseEvent) : void
      {
         e.updateAfterEvent();
         MoveTo.CanMove = true;
      }
      
      private function overHandler(evt:MouseEvent) : void
      {
         controlLevel.room_2.gotoAndStop(2);
      }
      
      private function outHandler(evt:MouseEvent) : void
      {
         controlLevel.room_2.gotoAndStop(1);
      }
      
      private function onOpenTolly(e:MouseEvent) : void
      {
         NewStatisticsManager.send(147);
         SimpleIntrPanelManager.show("sixYearTolly");
      }
      
      override public function destroy() : void
      {
         var v:DisplayObject = null;
         this.clearEffect();
         GV.onlineSocket.removeCmdListener(CommandID.CLI_PROTO_PRINCESS_FLOWER_RING_GIVE,this.flowerHandle);
         BC.removeEvent(this,GV.onlineSocket,"SocketEvent_Data" + CommandID.FOR_CLI_REQUET,this.onGetNum);
         GV.onlineSocket.removeEventListener(PeopleCountLogic.ONPEOPLEINIT,this.onPeopleInit);
         GV.onlineSocket.removeEventListener(PeopleCountLogic.ONPEOPLEINMAP,this.onPeopleInMap);
         GV.onlineSocket.removeEventListener(PeopleCountLogic.ONPEOPLEOUTMAP,this.onPeopleOutMap);
         for each(v in this._dictionary)
         {
            DisplayUtil.removeFromParent(v);
         }
         this._dictionary = null;
         this.myflower = null;
         controlLevel.room_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
         controlLevel.room_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
         super.destroy();
      }
   }
}

