package com.module.digTreasure.view
{
   import com.event.EventTaomee;
   import com.logic.socket.digTreasure.DigTreasureSocket;
   import com.module.AngelsAndDemons.AngelsAndDemonsCtl;
   import com.module.digTreasure.IDigTreasureItemCtl;
   import flash.events.MouseEvent;
   import flash.ui.Mouse;
   
   public class DigTreasureBossItem extends DigTreasureItem implements IDigTreasureItemCtl
   {
      
      private var _bossMap:int;
      
      private var _bossType:int;
      
      public function DigTreasureBossItem()
      {
         super();
         _ui.buttonMode = true;
      }
      
      override public function StartDig(tragger:IDigTreasureItemCtl = null) : void
      {
         if(!IsMoleHitItem())
         {
            return;
         }
         ClearMouseEvent();
         SendDigCmd();
      }
      
      override protected function DigCmdHandler(e:EventTaomee) : void
      {
         if(e.EventObj.index == index)
         {
            BC.removeEvent(this,GV.onlineSocket,"read_" + DigTreasureSocket.DigAreaCmd,this.DigCmdHandler);
            InitMouseEvent();
            AngelsAndDemonsCtl.instance.LoadBeginPanelFun(AngelsAndDemonsCtl.begin_url,this._bossMap,this._bossType);
         }
      }
      
      override public function SetConfig(config:XML, index:int) : void
      {
         super.SetConfig(config,index);
         this._bossMap = int(_config.BattleMap[0].@ID);
         this._bossType = int(_config.BattleMap[0].@type);
         var star:int = int(_config.BattleMap[0].@star);
         _tipMC.name_txt.text = _name;
         _tipMC.star_mc.gotoAndStop(star);
      }
      
      override protected function OnMouseOver(e:MouseEvent) : void
      {
         super.OnMouseOver(e);
         Mouse.show();
      }
      
      override public function get state() : int
      {
         return _digCount;
      }
   }
}

