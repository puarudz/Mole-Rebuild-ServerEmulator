package com.module.specialTool
{
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.manager.UIManager;
   import com.event.EventTaomee;
   import com.logic.socket.lookBag.LookBagReq;
   import com.logic.socket.lookBag.LookBagRes;
   import com.module.activityModule.checkCloth;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class specialLogic extends Sprite
   {
      
      private var target_mc:MovieClip;
      
      public var mainObj:*;
      
      private var specialViewClass:specialView;
      
      public var lookBagClass:LookBagReq;
      
      public function specialLogic(obj:*)
      {
         var UIClass:* = undefined;
         super();
         this.mainObj = obj;
         this.lookBagClass = new LookBagReq();
         if(this.target_mc == null)
         {
            UIClass = UIManager.getClass("specialTool_mc");
            this.target_mc = new UIClass();
            this.target_mc.name = "special_mc";
            MainManager.getToolLevel().addChild(this.target_mc);
            this.target_mc.x = 1500;
            this.target_mc.y = 315;
            this.init();
         }
      }
      
      public function init() : void
      {
         this.specialViewClass = new specialView(this.target_mc);
      }
      
      public function HaveRemoveMagicTool() : Boolean
      {
         return checkCloth.doAction(12336);
      }
      
      public function getSpecial(e:EventTaomee) : void
      {
         var mc:MovieClip = null;
         GV.SpecialArr = e.EventObj.obj.arr;
         GV.onlineSocket.removeEventListener(LookBagRes.BAG_OVER,this.getSpecial);
         GV.SpecialArr.unshift({
            "id":150001,
            "itemCount":100
         });
         GV.SpecialArr.unshift({
            "id":150018,
            "itemCount":100
         });
         GV.SpecialArr.unshift({
            "id":150012,
            "itemCount":100
         });
         for(var ppd:int = 0; ppd < GV.SpecialArr.length; ppd++)
         {
            if(GV.SpecialArr[ppd].id == 17009)
            {
               GV.SpecialArr.splice(ppd,1);
            }
         }
         if(this.HaveRemoveMagicTool())
         {
            GV.SpecialArr.splice(1,0,{
               "id":17009,
               "itemCount":100
            });
         }
         if(GV.SpecialArr.length > 0)
         {
            mc = MainManager.getToolLevel().getChildByName("special_mc") as MovieClip;
            mc.x = 522;
            mc.addEventListener(MouseEvent.ROLL_OUT,this.onOverHandler);
            this.specialViewClass.binding();
         }
      }
      
      private function onOverHandler(e:MouseEvent) : void
      {
         e.currentTarget.x = 1500;
      }
      
      public function showSpecialPanel() : void
      {
         this.lookBagClass.lookBag(LocalUserInfo.getUserID(),8 | 4,0);
         GV.onlineSocket.addEventListener(LookBagRes.BAG_OVER,this.getSpecial);
      }
   }
}

