package com.module.friendList.friendView
{
   import com.common.scrollBar.ScrollBar;
   import com.core.objectPool.ObjectPool;
   import com.view.userPanelView.userPanelView;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.text.*;
   
   public class OView extends MovieClip
   {
      
      public static var addEventListener:Function;
      
      public static var dispatchEvent:Function;
      
      public static var removeEventListener:Function;
      
      private static var MC:MovieClip;
      
      private static var Man:Class;
      
      private static var RootMC:MovieClip;
      
      private static var arrMC:Array;
      
      private static var len:uint;
      
      private static var myScrollBar:ScrollBar;
      
      private static var updateNum:Number;
      
      public static var myObj:Object = {
         0:0,
         1:1,
         2:2,
         3:3,
         4:4,
         5:5,
         6:6,
         7:7,
         8:8,
         9:9,
         "a":10,
         "b":11,
         "c":12,
         "d":13,
         "e":14,
         "f":15
      };
      
      public function OView()
      {
         super();
      }
      
      public static function addBG() : void
      {
         var temp:MovieClip = ObjectPool.getObject(Man);
         temp.home_btn.visible = false;
         temp.prev_pet.visible = true;
         temp.prev_mc.visible = true;
         temp.chat_btn.visible = false;
         temp.del_btn.visible = false;
         temp.userName.text = "";
         temp.prev_mc.visible = false;
         temp.prev_pet.visible = false;
         arrMC.push(temp);
         MC.manMC.addChild(temp);
      }
      
      public static function arrange(arr:Array) : void
      {
         for(var k:uint = 0; k < arr.length; k++)
         {
            arr[k].y = 32 * k;
            arr[k].visible = true;
         }
      }
      
      public static function getPrimitiveColors(colorStr:String) : Array
      {
         var tempStr:String = null;
         var A:String = null;
         var B:String = null;
         var a:String = colorStr;
         if(a.indexOf("#") > -1)
         {
            a = a.slice(1);
         }
         while(a.length < 6)
         {
            a = "0" + a;
         }
         a = a.toLocaleLowerCase();
         var tempArray:Array = [];
         for(var i:uint = 0; i < 6; i += 2)
         {
            tempStr = a.substr(i,2);
            A = tempStr.substr(0,1);
            B = tempStr.substr(1,1);
            tempArray.push(myObj[A] * 16 + myObj[B]);
         }
         return tempArray;
      }
      
      public static function hideLoading() : void
      {
         MC.loading.visible = false;
         MC.loading.gotoAndStop(1);
         if(Boolean(myScrollBar))
         {
            myScrollBar.doChange();
         }
      }
      
      public static function init(mc:MovieClip, man:Class) : void
      {
         var ed:EventDispatcher = new EventDispatcher();
         dispatchEvent = ed.dispatchEvent;
         addEventListener = ed.addEventListener;
         removeEventListener = ed.removeEventListener;
         Man = man;
         MC = mc;
         MC.manMC.y = 64;
         refresh();
      }
      
      public static function initMan(manInfo:Object, bool:*) : void
      {
         var temp:MovieClip = ObjectPool.getObject(Man);
         temp.home_btn.visible = false;
         temp.prev_pet.visible = true;
         temp.prev_mc.visible = true;
         temp.visible = false;
         temp.del_btn.visible = false;
         temp.chat_btn.visible = false;
         temp.id = manInfo.UserID;
         temp.name = "mc" + temp.id;
         temp.userName.text = manInfo.Nick;
         BC.addEvent(OView,temp.head_btn,MouseEvent.CLICK,showFriendPanel);
         BC.addEvent(OView,temp.head_btn,MouseEvent.MOUSE_OVER,goto2);
         BC.addEvent(OView,temp.head_btn,MouseEvent.MOUSE_OUT,goto1);
         temp.Color = Number(manInfo.Color);
         var colorObj:Array = getPrimitiveColors(temp.Color.toString(16));
         temp.prev_mc.pv_color.pv_color.transform.colorTransform = new ColorTransform(colorObj[0] / 256,colorObj[1] / 256,colorObj[2] / 256,1);
         arrMC.push(temp);
         showColor(temp);
         MC.manMC.addChild(temp);
      }
      
      public static function showColor(mc:Object) : void
      {
         mc.prev_pet.visible = true;
         mc.prev_mc.visible = true;
         mc.prev_mc.pv_color.visible = true;
         mc.prev_pet.pv_color.visible = true;
         var colorObj:Array = getPrimitiveColors(mc.Color.toString(16));
         if(FView.isVipbyId(mc.id))
         {
            mc.sortnum = 2;
            mc.prev_mc.visible = false;
            mc.prev_pet.pv_color.pv_color.transform.colorTransform = new ColorTransform(colorObj[0] / 256,colorObj[1] / 256,colorObj[2] / 256,1);
         }
         else
         {
            mc.sortnum = 4;
            mc.prev_pet.visible = false;
            mc.prev_mc.pv_color.pv_color.transform.colorTransform = new ColorTransform(colorObj[0] / 256,colorObj[1] / 256,colorObj[2] / 256,1);
         }
      }
      
      public static function initmyScrollBar() : void
      {
         var i:uint = 0;
         if(!myScrollBar)
         {
            myScrollBar = new ScrollBar(null,MC.manMC,{
               "length":32 * 7 + 6,
               "x":210,
               "y":MC.manMC.y
            },ScrollBar.ENABLE_ABATE,ScrollBar.DIRECTION_VERTICAL,36);
         }
         if(len > 7)
         {
            arrange(arrMC);
         }
         else
         {
            for(i = len; i < 7; i++)
            {
               addBG();
            }
            arrange(arrMC);
         }
         if(Boolean(myScrollBar))
         {
            myScrollBar.doChange();
         }
      }
      
      public static function isvip(info:Object) : Boolean
      {
         return Boolean(info.Vip >> 0 & 1);
      }
      
      public static function refresh() : void
      {
         MC.manMC.y = 64;
         MC.loading.visible = true;
         MC.loading.gotoAndPlay(2);
         arrMC = new Array();
         start();
         MC.manMC.y = 64;
         if(!myScrollBar)
         {
            myScrollBar = new ScrollBar(null,MC.manMC,{
               "length":32 * 7 + 6,
               "x":210,
               "y":MC.manMC.y
            },ScrollBar.ENABLE_ABATE,ScrollBar.DIRECTION_VERTICAL,36);
         }
         if(Boolean(myScrollBar))
         {
            myScrollBar.doChange();
         }
      }
      
      public static function removeMan() : void
      {
         var mc:* = undefined;
         for(var i:int = MC.manMC.numChildren - 1; i >= 0; i--)
         {
            mc = MC.manMC.getChildAt(i) as Man;
            ObjectPool.disposeObject(mc,Man,200);
            MC.manMC.removeChild(mc);
         }
      }
      
      public static function showNums() : void
      {
         MC.nums.text = "(" + GV.OnLineArray.length + ")";
      }
      
      public static function start() : void
      {
         var i:uint = 0;
         len = GV.OnLineArray.length;
         showNums();
         if(len > 0)
         {
            for(i = 0; i < len; i++)
            {
               initMan(GV.OnLineArray[i],true);
            }
         }
         hideLoading();
         initmyScrollBar();
         if(Boolean(myScrollBar))
         {
            myScrollBar.doChange();
         }
      }
      
      public static function un() : void
      {
         uninit();
      }
      
      public static function uninit() : void
      {
         arrMC = null;
         if(Boolean(myScrollBar))
         {
            myScrollBar.clearClass();
         }
         myScrollBar = null;
         BC.removeEvent(OView);
         removeMan();
      }
      
      private static function goto1(evt:MouseEvent) : void
      {
         evt.target.parent[evt.target.name + "_mc"].gotoAndStop(1);
         evt.target.parent.bgMC.gotoAndStop(1);
      }
      
      private static function goto2(evt:MouseEvent) : void
      {
         evt.target.parent[evt.target.name + "_mc"].gotoAndStop(2);
         evt.target.parent.bgMC.gotoAndStop(2);
      }
      
      private static function showFriendPanel(evt:MouseEvent) : void
      {
         userPanelView.showUserPanel(evt.target.parent.id);
      }
   }
}

