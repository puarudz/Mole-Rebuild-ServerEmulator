package com.view.mapView
{
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.module.loadExtentPanel.LoadGame;
   import com.mole.app.map.MapBase;
   import flash.display.Loader;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   
   public class NifeiRestaurantView extends MapBase
   {
      
      public function NifeiRestaurantView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         BC.addEvent(this,_mapLevel.controlLevel["mc_" + 1340062],MouseEvent.CLICK,this.dishClickHandler);
         BC.addEvent(this,_mapLevel.controlLevel["mc_" + 1340063],MouseEvent.CLICK,this.dishClickHandler);
         BC.addEvent(this,_mapLevel.controlLevel["mc_" + 1340064],MouseEvent.CLICK,this.dishClickHandler);
         BC.addEvent(this,_mapLevel.controlLevel["mc_" + 1340065],MouseEvent.CLICK,this.dishClickHandler);
         BC.addEvent(this,_mapLevel.controlLevel["gam_btn"],MouseEvent.CLICK,this.gameBtnClickHandler);
      }
      
      private function gameBtnClickHandler(evt:MouseEvent) : void
      {
         BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.gameHandler);
         finishSomethingReq.sendReq(236);
      }
      
      private function gameHandler(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.gameHandler);
         var obj:Object = evt.EventObj;
         if(obj.Type == 236)
         {
            if(obj.Done >= 20)
            {
               mapSay(10);
            }
            else
            {
               new LoadGame("module/external/Hamburger.swf","正在打開......",MainManager.getAppLevel());
            }
         }
      }
      
      private function dishClickHandler(e:MouseEvent) : void
      {
         var id:String = e.currentTarget.name;
         var url:String = "module/order/Order.swf?id=" + id.substr(3,7);
         var l:Loader = new Loader();
         l.y = 0;
         l.load(new URLRequest(url));
         MainManager.getAlertLevel().addChild(l);
      }
   }
}

