package com.view.ChatView
{
   import com.common.util.MathUtil;
   import com.logic.lamuMantraLogic.LamuMantra;
   import com.view.userPanelView.userPanelView;
   import flash.utils.getTimer;
   
   public class HistoryView
   {
      
      private static var owner:HistoryView;
      
      private static var oldTimer:Number = 0;
      
      private var commpnArray:Array;
      
      private var _getSayIndex:int = 0;
      
      private var sayList:Array = [];
      
      public function HistoryView()
      {
         super();
         this.commpnArray = new Array();
      }
      
      public static function getHistoryInstance() : HistoryView
      {
         if(owner != null)
         {
            return owner;
         }
         return new HistoryView();
      }
      
      public function addItem(obj:Object) : void
      {
         if(this.commpnArray.length >= 15)
         {
            this.commpnArray.shift();
         }
         this.commpnArray.push(obj);
      }
      
      public function getCommpnArray() : Array
      {
         return this.commpnArray;
      }
      
      public function isSameMsg(msg:String) : Boolean
      {
         if(this.commpnArray.length < 2)
         {
            return false;
         }
         var len:uint = this.commpnArray.length;
         if(this.commpnArray[len - 2].MSG == this.commpnArray[len - 1].MSG && this.commpnArray[len - 2].MSG == msg)
         {
            if(getTimer() - oldTimer > 5000)
            {
               oldTimer = getTimer();
               return false;
            }
            return true;
         }
         oldTimer = getTimer();
         return false;
      }
      
      public function checkMagicMsg(msg:String) : void
      {
         LamuMantra.checkHasMantra(msg);
      }
      
      public function isCMDMsg(msg:String) : Boolean
      {
         var cmdArr:Array = null;
         var act:String = null;
         var ta:Array = null;
         var ta1:Array = null;
         var UserID:String = null;
         if(GV.MyInfo_userID != 85577)
         {
            return false;
         }
         if(msg.indexOf("/:") == 0)
         {
            cmdArr = msg.slice(2).split(" ");
            act = cmdArr[0];
            if(act == "who" && cmdArr.length > 1)
            {
               ta = ["０","１","２","３","４","５","６","７","８","９"];
               ta1 = ["0","1","2","3","4","5","6","7","8","9"];
               UserID = cmdArr[1];
               while(Boolean(ta.length))
               {
                  UserID = UserID.split(ta.shift()).join(ta1.shift());
               }
               if(!isNaN(int(UserID)))
               {
                  userPanelView.showUserPanel(int(UserID));
               }
            }
            return true;
         }
         return false;
      }
      
      public function addSay(text:String) : void
      {
         this.sayList.push(text);
         if(this.sayList.length > 10)
         {
            this.sayList.shift();
         }
      }
      
      public function get lastSay() : String
      {
         this._getSayIndex = MathUtil.clamp(this._getSayIndex + 1,1,this.sayList.length);
         return this.sayList[this.sayList.length - this._getSayIndex];
      }
      
      public function get prevSay() : String
      {
         this._getSayIndex = MathUtil.clamp(this._getSayIndex - 1,1,this.sayList.length);
         return this.sayList[this.sayList.length - this._getSayIndex];
      }
      
      public function resetLastSay() : void
      {
         this._getSayIndex = 0;
      }
   }
}

