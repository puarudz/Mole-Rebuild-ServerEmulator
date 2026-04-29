package com.module.treasureHouse.view
{
   import com.event.EventTaomee;
   import com.logic.socket.treasureHouse.TreasureHouseSocket;
   import com.module.treasureHouse.TreasureHouseViewCtl;
   import flash.display.MovieClip;
   
   public class TreasureHouseTreasurAreaCtl
   {
      
      public static const MAX_ANGEL_COUNT:int = 24;
      
      private var _booths:Array;
      
      private var _ui:MovieClip;
      
      public function TreasureHouseTreasurAreaCtl(ui:MovieClip)
      {
         var booth:TreasureHouseBoothCtl = null;
         super();
         this._ui = ui;
         this._booths = new Array();
         for(var i:int = 0; i < MAX_ANGEL_COUNT; i++)
         {
            ui = this._ui["booth_" + i];
            booth = new TreasureHouseBoothCtl(ui,i);
            this._booths.push(booth);
         }
         this.UpdateBooths();
         BC.addEvent(this,GV.onlineSocket,"read_" + TreasureHouseSocket.GetTreasureHouseInfoCmd,this.GetTreasureInfoHandler);
      }
      
      private function GetTreasureInfoHandler(e:EventTaomee) : void
      {
         TreasureHouseViewCtl.instance.boothDatas = e.EventObj.booths;
         this.UpdateBooths();
      }
      
      public function Clear() : void
      {
         var booth:TreasureHouseBoothCtl = null;
         BC.removeEvent(this);
         for each(booth in this._booths)
         {
            booth.Clear();
         }
         this._booths = null;
      }
      
      public function get ui() : MovieClip
      {
         return this._ui;
      }
      
      public function UpdateBooths() : void
      {
         var booth:TreasureHouseBoothCtl = null;
         for(var i:int = 0; i < MAX_ANGEL_COUNT; i++)
         {
            booth = this._booths[i];
            booth.UpdateData();
         }
      }
   }
}

