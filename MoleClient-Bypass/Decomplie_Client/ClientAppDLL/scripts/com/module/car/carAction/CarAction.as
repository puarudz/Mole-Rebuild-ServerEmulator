package com.module.car.carAction
{
   import com.event.EventTaomee;
   import com.view.PeopleView.PeopleManageView;
   import flash.events.EventDispatcher;
   
   public class CarAction extends EventDispatcher
   {
      
      private static var instance:CarAction;
      
      public function CarAction()
      {
         super();
      }
      
      public static function getInstance() : CarAction
      {
         return instance = Boolean(instance) ? instance : new CarAction();
      }
      
      public function EventAggregation(type:String, p:PeopleManageView, data:Object) : void
      {
         this[type](p,data);
         dispatchEvent(new EventTaomee(type,{
            "p":p,
            "data":data
         }));
      }
      
      public function prop_1300005(p:PeopleManageView, data:Object) : void
      {
         if(Boolean(p) && Boolean(p.car) && Boolean(p.car_Info))
         {
            if(Boolean(p.car_Info.Item1))
            {
               data.mc.visible = true;
               data.mc.gotoAndStop("_" + p.car_Info.Item1);
            }
            else if(Boolean(p.car_Info.Item2))
            {
               data.mc.visible = true;
               data.mc.gotoAndStop("_" + p.car_Info.Item2);
            }
            else
            {
               data.mc.visible = false;
            }
         }
         else
         {
            GC.stopAllMC(data.mc);
         }
      }
      
      public function changeDirection(p:PeopleManageView, data:Object) : void
      {
         var dir:int = p.car["dirObj"][data.dir] + 2;
         data.mc.gotoAndStop(dir);
      }
   }
}

