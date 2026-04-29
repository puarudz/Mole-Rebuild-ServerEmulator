package com.logic.expressionLogic
{
   import com.core.MainManager;
   import com.core.manager.UIManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class expressionLogic
   {
      
      public var targetMC:*;
      
      public function expressionLogic()
      {
         super();
      }
      
      public function showExpressionBorder(mc:MovieClip) : void
      {
         var tempMC1:* = MainManager.getAppLevel().getChildByName("expression_mc");
         if(tempMC1 != null)
         {
            BC.removeEvent(tempMC1.Myclass);
            GC.clearAll(tempMC1);
         }
         var myPoint:Point = new Point(mc.x,mc.y);
         myPoint = mc.parent.localToGlobal(myPoint);
         var tempMC:MovieClip = UIManager.getMovieClip("expression_border");
         GC.stopAllMC(tempMC);
         tempMC.Myclass = this;
         tempMC.name = "expression_mc";
         tempMC.x = myPoint.x;
         tempMC.y = myPoint.y;
         this.targetMC = tempMC;
         BC.addEvent(this,tempMC.bg,MouseEvent.MOUSE_OVER,this.closeBorder);
         MainManager.getAppLevel().addChild(tempMC);
         var i:uint = 1;
         while(tempMC["b" + i] != null)
         {
            BC.addEvent(this,tempMC["b" + i],MouseEvent.CLICK,this.showExpression);
            BC.addEvent(this,tempMC["b" + i],MouseEvent.MOUSE_OVER,this.playAction);
            BC.addEvent(this,tempMC["b" + i],MouseEvent.MOUSE_OUT,this.stopAction);
            tempMC["e" + i].mouseEnabled = false;
            i++;
         }
      }
      
      private function closeBorder(E:MouseEvent = null) : void
      {
         var tempMC:* = E.target.parent;
         BC.removeEvent(this);
         tempMC.Myclass = null;
         E.target.parent.parent.removeChild(E.target.parent);
         GC.stopAllMC(tempMC);
      }
      
      private function playAction(E:MouseEvent) : void
      {
         var tempString:String = E.target.name.substr(1,E.target.name.length - 1);
         E.target.parent["e" + tempString].play();
      }
      
      private function stopAction(E:MouseEvent) : void
      {
         var tempString:String = E.target.name.substr(1,E.target.name.length - 1);
         E.target.parent["e" + tempString].gotoAndStop(1);
      }
      
      private function showExpression(E:MouseEvent) : void
      {
         var tempString:String = E.target.name.substr(1,E.target.name.length - 1);
         GV.MAN_PEOPLE.showWordBoxMSG({"EventObj":{"msg":"/" + GV.expressionArray[Number(tempString) - 1]}});
         GV.onlineClass.chating(0,"/" + GV.expressionArray[Number(tempString) - 1]);
         this.closeBorder(E);
      }
   }
}

