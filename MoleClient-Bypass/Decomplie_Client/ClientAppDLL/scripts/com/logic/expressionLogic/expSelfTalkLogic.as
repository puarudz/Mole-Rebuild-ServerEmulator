package com.logic.expressionLogic
{
   import com.core.manager.UIManager;
   import com.event.EventTaomee;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class expSelfTalkLogic
   {
      
      public var targetMC:MovieClip;
      
      public var IDs:uint = 0;
      
      public function expSelfTalkLogic()
      {
         super();
      }
      
      public function showExpressionBorder(mc:MovieClip, ID:uint) : void
      {
         this.IDs = ID;
         var tempMC1:* = GV.MC_AppLever.getChildByName("expression_private_mc");
         if(tempMC1 != null)
         {
            BC.removeEvent(tempMC1.Myclass);
            GC.clearAll(tempMC1);
         }
         var myClass:* = UIManager.getClass("expression_private");
         var tempMC:Object = new myClass();
         GC.stopAllMC(tempMC);
         tempMC.Myclass = this;
         tempMC.name = "expression_private_mc";
         tempMC.x = 0;
         tempMC.y = 0;
         this.targetMC = mc;
         BC.addEvent(this,tempMC.bg,MouseEvent.MOUSE_OVER,this.closeBorder);
         mc.addChild(tempMC as DisplayObject);
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
      
      public function closeBorder(E:MouseEvent = null) : void
      {
         var tempMC:* = undefined;
         if(E == null)
         {
            if(Boolean(this.targetMC.getChildByName("expression_private_mc")))
            {
               tempMC = this.targetMC.getChildByName("expression_private_mc");
            }
         }
         else if(Boolean(E.target.parent))
         {
            tempMC = E.target.parent;
         }
         BC.removeEvent(this);
         if(Boolean(tempMC))
         {
            tempMC.Myclass = null;
            this.targetMC.removeChild(tempMC);
            GC.stopAllMC(tempMC);
         }
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
         var str:String = "/" + GV.expressionArray[Number(tempString) - 1];
         var ID:uint = this.IDs;
         GV.onlineSocket.dispatchEvent(new EventTaomee("expression_private_close",{
            "str":str,
            "ID":ID
         }));
         this.closeBorder(E);
      }
   }
}

