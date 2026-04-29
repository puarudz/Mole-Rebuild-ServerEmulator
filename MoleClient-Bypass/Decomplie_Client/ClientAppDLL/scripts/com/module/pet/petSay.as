package com.module.pet
{
   import flash.display.MovieClip;
   import flash.utils.*;
   
   public class petSay
   {
      
      private var PETMC:MovieClip;
      
      private var PETINFO:Object;
      
      private var Interval:uint = 0;
      
      private var statusArr:Array = new Array();
      
      private var firstBool:Boolean = true;
      
      private var saying:Boolean;
      
      public var sayBox:*;
      
      public var sayTip:*;
      
      public function petSay(mc:MovieClip, username:String, userID:int, Nick:String)
      {
         super();
         this.PETMC = mc;
         if(Math.random() > 0.5)
         {
            this.PETMC.say("你可以加" + username + "(" + userID + ")" + "為好友讓他來接我哦！");
         }
         else
         {
            this.PETMC.say("我是" + username + "(" + userID + ")" + "的拉姆" + Nick);
         }
      }
   }
}

