package com.mole.app.activity
{
   import com.common.util.DisplayUtil;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.mapEvent.MapEvent;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.module.activityModule.Presented;
   import com.mole.app.manager.OnlineManager;
   import com.mole.app.map.MapManager;
   import com.mole.net.events.SocketEvent;
   import com.view.MapManageView.MapManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class SearchPainting
   {
      
      private static var _inst:SearchPainting;
      
      private var mapIDVec:Vector.<uint> = new <uint>[6,7,8,9,10,14,15,28,68];
      
      private var mapDayType:Vector.<uint> = new <uint>[31522,31523,31524,31525,31526,31527,31528,31529,31530];
      
      private var mapType:Vector.<uint> = new <uint>[2327,2328,2329,2330,2331,2332,2333,2334,2335];
      
      private var _curIndex:uint = 0;
      
      private const DAYTYPEMAX:uint = 9;
      
      private var _pic:MovieClip;
      
      private const RANLIMIT:Number = 100;
      
      private var _ranNum:Number;
      
      public function SearchPainting()
      {
         super();
      }
      
      public static function getInst() : SearchPainting
      {
         if(!_inst)
         {
            _inst = new SearchPainting();
         }
         return _inst;
      }
      
      public function setUp() : void
      {
         for(var i:uint = 0; i < this.mapIDVec.length; i++)
         {
            if(this.mapIDVec[i] == MapManager.curMapID)
            {
               this._ranNum = Math.random();
               this._curIndex = i;
               OnlineManager.addCmdListener(CommandID.FINISH_SOMETHING,this.dayTypeHandle);
               finishSomethingReq.sendReq(this.mapDayType[this._curIndex]);
               GV.onlineSocket.addEventListener(MapEvent.READY_CHANGE_MAP,this.clearAll);
            }
         }
      }
      
      private function dayTypeHandle(e:SocketEvent) : void
      {
         OnlineManager.removeCmdListener(CommandID.FINISH_SOMETHING,this.dayTypeHandle);
         var somethingPro:finishSomethingRes = e.bodyInfo;
         if(somethingPro.Type == this.mapDayType[this._curIndex])
         {
            if(somethingPro.Done <= this.DAYTYPEMAX && this._ranNum <= this.RANLIMIT)
            {
               this.addPainting();
            }
         }
      }
      
      private function addPainting() : void
      {
         var tempMC:Class = GV.Lib_Map.getClass("LUpicture") as Class;
         this._pic = new tempMC();
         this._pic.buttonMode = true;
         this._pic.x = 508 + 100 * Math.random();
         this._pic.y = 331 + 100 * Math.random();
         MapManageView.inst.mapLevel.topLevel.addChild(this._pic);
         this._pic.addEventListener(MouseEvent.CLICK,this.onClickPic,false,0,true);
      }
      
      private function onClickPic(e:Event) : void
      {
         trace("點到了");
         Presented.getInstance().celebrate1225(this.mapType[this._curIndex]);
         DisplayUtil.removeForParent(this._pic);
      }
      
      private function clearAll(e:EventTaomee) : void
      {
         this.destroy();
      }
      
      public function destroy() : void
      {
         BC.removeEvent(this);
         GV.onlineSocket.removeEventListener(MapEvent.READY_CHANGE_MAP,this.destroy);
         OnlineManager.removeCmdListener(CommandID.FINISH_SOMETHING,this.dayTypeHandle);
      }
   }
}

