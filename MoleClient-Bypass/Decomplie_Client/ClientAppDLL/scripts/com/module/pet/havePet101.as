package com.module.pet
{
   import com.event.EventTaomee;
   import com.logic.socket.home.homeSocket;
   
   public class havePet101
   {
      
      private var havaPet101:Boolean;
      
      public function havePet101(userID:int)
      {
         super();
         BC.addEvent(this,GV.onlineSocket,"read_" + 240,this.onHavePet101);
         homeSocket.queryHaveSuperLamu(userID);
      }
      
      private function onHavePet101(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 240,this.onHavePet101);
         this.checkPel101(evt.EventObj.arr);
      }
      
      private function checkPel101(tempArr:Array) : void
      {
         for(var i:int = 0; i < tempArr.length; i++)
         {
            if(tempArr[i].Level == 101)
            {
               this.havaPet101 = true;
               break;
            }
         }
      }
      
      public function getHavaPet101() : Boolean
      {
         return this.havaPet101;
      }
   }
}

