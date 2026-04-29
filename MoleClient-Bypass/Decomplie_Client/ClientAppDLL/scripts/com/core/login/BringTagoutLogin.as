package com.core.login
{
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.ByteArray;
   
   public class BringTagoutLogin
   {
      
      public static var requestSessionByOnline:Function;
      
      public function BringTagoutLogin()
      {
         super();
      }
      
      public static function addEvent() : void
      {
         if(!ExternalInterface.available)
         {
            return;
         }
         ExternalInterface.addCallback("getSession",requestSessionByOnline);
      }
      
      public static function get_URL_Session() : ByteArray
      {
         if(!ExternalInterface.available)
         {
            return null;
         }
         var str:String = ExternalInterface.call("get_sid");
         if(Boolean(str))
         {
            return S2B(str);
         }
         return null;
      }
      
      public static function set_URL_Session(sid:ByteArray, canJump:Boolean) : void
      {
         if(!ExternalInterface.available)
         {
            return;
         }
         var str:String = B2S(sid);
         ExternalInterface.call("set_sid",str,canJump);
      }
      
      public static function set_game_URL_Session(sid:ByteArray) : void
      {
         var str:String = null;
         if(!ExternalInterface.available)
         {
            navigateToURL(new URLRequest("http://hero.61.com?sid=" + B2S(sid)),"_blank");
         }
         else
         {
            str = B2S(sid);
            ExternalInterface.call("showHero",str);
         }
      }
      
      public static function jump_To_Product(sid:ByteArray, productName:String = "mole") : void
      {
         var url:String = "http://" + productName + ".61.com?sid=" + B2S(sid);
         navigateToURL(new URLRequest(url),"_blank");
      }
      
      public static function jump_To_Xiaoba(userID:uint, sid:ByteArray, productName:String = "mole") : void
      {
         var url:String = "http://" + productName + ".61.com?userid=" + userID + "&gameid=9&session=" + B2S(sid);
         navigateToURL(new URLRequest(url),"_blank");
      }
      
      public static function jump_To_Recharge(userID:uint, sid:ByteArray, productName:String = "pay") : void
      {
         var url:String = "http://" + productName + ".61.com/buy/paytype?type=cardpay&userid=" + userID + "&gameid=1&session=" + B2S(sid);
         navigateToURL(new URLRequest(url),"_blank");
      }
      
      public static function jump_lamu_Recharge(userID:uint, sid:ByteArray, productName:String = "pay") : void
      {
         var url:String = "http://" + productName + ".61.com/lahm/lahmPay&userid=" + userID + "&gameid=1&session=" + B2S(sid);
         navigateToURL(new URLRequest(url),"_blank");
      }
      
      public static function jump_To_BusWeb(userID:uint, sendUserID:uint, sid:ByteArray, invitecode:uint) : void
      {
         var url:String = "http://bus.61.com/sign?type=reg&uid=" + userID + "&suid=" + sendUserID + "&session=" + B2S(sid) + "&invitecode=" + invitecode + "&game=mole";
         navigateToURL(new URLRequest(url),"_blank");
      }
      
      public static function jump_To_BusWebForEmail(userID:uint, sid:ByteArray) : void
      {
         var url:String = "http://bus.61.com/sign/common/?uid=" + userID + "&session=" + B2S(sid) + "&game=mole" + "&target_app=dou";
         navigateToURL(new URLRequest(url),"_blank");
      }
      
      public static function B2S(b:ByteArray) : String
      {
         var t:String = null;
         var s:String = "";
         var op:uint = b.position;
         b.position = 0;
         while(Boolean(b.bytesAvailable))
         {
            t = b.readUnsignedByte().toString(16);
            s += t.length == 1 ? "0" + t : t;
         }
         b.position = op;
         return s;
      }
      
      public static function S2B(s:String) : ByteArray
      {
         var b:ByteArray = new ByteArray();
         var l:uint = uint(s.length);
         if(l == 0 || Boolean(l % 2))
         {
            throw new Error("字符長度為" + String(l) + ",參數非偶數或為空!");
         }
         var i:uint = 0;
         while(i < l)
         {
            b.writeByte(parseInt(s.substr(i,2),16));
            i += 2;
         }
         b.position = 0;
         return b;
      }
   }
}

