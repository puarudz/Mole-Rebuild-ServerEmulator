package com.logic.PeopleCountLogic
{
   import com.core.socketlogic.ClientOnLineSerSocket;
   import org.taomee.bean.BaseBean;
   
   public class dynamicUserLogic extends BaseBean
   {
      
      public var userArray:Array;
      
      public var userObj:Object;
      
      public function dynamicUserLogic()
      {
         super();
      }
      
      override public function start() : void
      {
         try
         {
            if(GV.onlineClass != null)
            {
               GV.onlineClass.removeEventListener(ClientOnLineSerSocket.SEND_DATA,this.getNewUserData);
            }
         }
         catch(E:*)
         {
         }
         GV.onlineClass.addEventListener(ClientOnLineSerSocket.SEND_DATA,this.getNewUserData);
         finish();
      }
      
      public function getNewUserData(evt:*) : void
      {
         this.userArray = new Array();
         this.userArray.push(evt.EventObj);
         this.userObj = {
            "data":this.userArray,
            "type":2
         };
         GV.PeopleCount.changeOnlinePeople(this.userObj);
      }
   }
}

