package com.logic.expressionLogic
{
   import com.common.util.DisplayUtil;
   import com.core.manager.UIManager;
   import com.event.EventTaomee;
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   
   public class expGroupTalkLogic extends EventDispatcher
   {
      
      public static var GET_EXP:String = "get_Exp";
      
      public var targetMC:MovieClip;
      
      public var IDs:uint = 0;
      
      public function expGroupTalkLogic()
      {
         super();
      }
      
      public function showExpressionBorder(mc:MovieClip, ID:uint = 0) : void
      {
         this.IDs = ID;
         var tempMC1:* = mc.getChildByName("expression_private_mc1");
         if(tempMC1 != null)
         {
            BC.removeEvent(tempMC1.Myclass);
            tempMC1.Myclass = null;
            DisplayUtil.removeForParent(tempMC1);
         }
         var myClass:* = UIManager.getClass("expression_private");
         var tempMC:MovieClip = new myClass();
         GC.stopAllMC(tempMC);
         tempMC.Myclass = this;
         tempMC.name = "expression_private_mc1";
         tempMC.x = 0;
         tempMC.y = 0;
         this.targetMC = tempMC;
         BC.addEvent(this,tempMC.bg,MouseEvent.MOUSE_OVER,this.closeBorder);
         mc.addChild(tempMC);
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
            tempMC = this.targetMC;
         }
         else
         {
            tempMC = E.target.parent;
         }
         BC.removeEvent(this);
         tempMC.Myclass = null;
         tempMC.parent.removeChild(tempMC);
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
         var str:String = "/" + GV.expressionArray[Number(tempString) - 1];
         var ID:uint = this.IDs;
         dispatchEvent(new EventTaomee(GET_EXP,{
            "str":str,
            "ID":ID
         }));
         this.closeBorder(E);
      }
   }
}

