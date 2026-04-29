package com.module.home.special
{
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MoveTo;
   import com.module.home.HomeEditView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   
   public class HomeGoodsLogic
   {
      
      private static var instance:HomeGoodsLogic;
      
      private static var canotNew:Boolean = true;
      
      public var goodsMC:MovieClip;
      
      public var mc:MovieClip;
      
      public var userGoodsSign:Boolean;
      
      private var usingGoodS:MovieClip;
      
      public function HomeGoodsLogic()
      {
         super();
         if(canotNew)
         {
            throw new Error("HomeGoodsLogic不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : HomeGoodsLogic
      {
         if(!instance)
         {
            canotNew = false;
            instance = new HomeGoodsLogic();
            canotNew = true;
         }
         return instance;
      }
      
      public function init(mc:MovieClip) : void
      {
         this.goodsMC = mc;
         this.goodsMC.btn.addEventListener(MouseEvent.CLICK,this.changeStatus);
         this.goodsMC.btn.addEventListener(MouseEvent.MOUSE_OVER,this.CanMove);
         this.goodsMC.btn.addEventListener(MouseEvent.MOUSE_OUT,this.CantMove);
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
      }
      
      public function changeStatus(e:MouseEvent) : void
      {
         this.mc = e.target.parent.mc2.getChildAt(0);
         if(this.usingGoodS == null)
         {
            this.usingGoodS = this.mc;
         }
         else if(this.usingGoodS != this.mc)
         {
            if(this.usingGoodS.currentFrame != this.usingGoodS.totalFrames)
            {
               this.usingGoodS = this.mc;
            }
         }
         if(!HomeEditView.Editable)
         {
            if(this.usingGoodS is MovieClip)
            {
               if(this.usingGoodS.currentFrame == this.usingGoodS.totalFrames)
               {
                  GV.onlineSocket.removeEventListener("iskaddish",this.kaddishEndHandler1);
                  this.usingGoodS.gotoAndStop(1);
                  GV.MAN_PEOPLE.visible = true;
               }
               else
               {
                  GV.onlineSocket.addEventListener("iskaddish",this.kaddishEndHandler1);
                  GV.onlineSocket.addEventListener("show",this.onShow);
                  this.usingGoodS.nextFrame();
               }
            }
         }
      }
      
      public function CanMove(e:MouseEvent) : void
      {
         if(!HomeEditView.Editable && e.target.parent.mc2.getChildAt(0) is MovieClip)
         {
            MoveTo.CanMove = false;
         }
      }
      
      public function CantMove(e:MouseEvent) : void
      {
         if(!HomeEditView.Editable)
         {
            MoveTo.CanMove = true;
         }
      }
      
      private function onShow(evt:Event) : void
      {
         GV.onlineSocket.removeEventListener("show",this.onShow);
         GV.onlineSocket.addEventListener("iskaddish",this.kaddishEndHandler1);
         GV.MAN_PEOPLE.visible = false;
         this.changMcColor(MovieClip(this.usingGoodS.getChildAt(0)).mole);
      }
      
      private function kaddishEndHandler1(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("iskaddish",this.kaddishEndHandler1);
         this.usingGoodS.gotoAndStop(1);
         GV.MAN_PEOPLE.visible = true;
      }
      
      private function changMcColor(tempMc:MovieClip) : void
      {
         var myColor:Object = null;
         if(Boolean(tempMc))
         {
            myColor = GV.myInfo_Color;
            tempMc.transform.colorTransform = new ColorTransform(myColor.red / 256,myColor.green / 256,myColor.blue / 256,1);
         }
      }
      
      private function removeEventHandler(E:Event) : void
      {
         GV.onlineSocket.removeEventListener("show",this.onShow);
         this.goodsMC.btn.removeEventListener(MouseEvent.CLICK,this.changeStatus);
         this.goodsMC.btn.removeEventListener(MouseEvent.MOUSE_OVER,this.CanMove);
         this.goodsMC.btn.removeEventListener(MouseEvent.MOUSE_OUT,this.CantMove);
         BC.removeEvent(this);
      }
   }
}

