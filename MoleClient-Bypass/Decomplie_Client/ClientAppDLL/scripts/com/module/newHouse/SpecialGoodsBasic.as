package com.module.newHouse
{
   import com.event.EventTaomee;
   import com.logic.socket.SpecialGoodsSocket.SpecialGoodsReq;
   import com.logic.socket.SpecialGoodsSocket.SpecialGoodsRes;
   import com.logic.socket.SpecialGoodsSocket.lilypond.LilyPondRes;
   import com.module.pet.petLogic;
   import flash.display.Loader;
   import flash.display.MovieClip;
   
   public class SpecialGoodsBasic
   {
      
      public static var specialGoodsArr:Object;
      
      public static var RootMC:MovieClip;
      
      public static var specialGoodsNameArr:Array = [{
         "Name":"毛毛樹",
         "Visible":0,
         "Layer":1,
         "ID":160142,
         "Arr":[100,500,1000,1200,1400],
         "mc":new MovieClip()
      },{
         "Name":"福字",
         "Visible":0,
         "Layer":4,
         "ID":160185,
         "Arr":[50,200],
         "mc":new MovieClip()
      },{
         "Name":"池蓮",
         "Visible":0,
         "Layer":1,
         "ID":161102,
         "Arr":[100,200,300,300],
         "mc":new MovieClip()
      }];
      
      public function SpecialGoodsBasic()
      {
         super();
      }
      
      public static function init() : void
      {
         RootMC = newHouseView.getInstance().RootMC;
         specialGoodsArr = new Array();
         var req:SpecialGoodsReq = new SpecialGoodsReq();
         GV.onlineSocket.addEventListener(SpecialGoodsRes.GET_SPECIAL_GOODS_SUCC,getBasicInfo);
         GV.onlineSocket.addEventListener(LilyPondRes.GET_LILYPOND_SUCC,getLilyPondBasic);
         req.sendReq();
      }
      
      public static function getBasicInfo(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(SpecialGoodsRes.GET_SPECIAL_GOODS_SUCC,getBasicInfo);
         petLogic.init();
         specialGoodsArr = e.EventObj;
         for(var i:uint = 0; i < specialGoodsArr.count; i++)
         {
            showGoodsStatus(specialGoodsArr.Arr[i]);
         }
      }
      
      public static function getLilyPondBasic(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(LilyPondRes.GET_LILYPOND_SUCC,getLilyPondBasic);
         var TreeInfo:Object = e.EventObj;
         showGoodsStatus({
            "type":4,
            "v1":TreeInfo.water,
            "v2":0,
            "v3":0
         });
      }
      
      public static function showGoodsStatus(goodsInfo:Object) : void
      {
         switch(goodsInfo.type)
         {
            case 4:
               showLilyPond(goodsInfo);
               break;
            case 1:
               showMaoMaoTree(goodsInfo);
               break;
            case 3:
               showBlessing(goodsInfo);
         }
      }
      
      public static function showBlessing(goodsInfo:Object) : void
      {
         var status:uint = BlessingStatus(goodsInfo.v1);
         goodInLevel(status,specialGoodsNameArr[1],RootMC.wallMC);
      }
      
      public static function BlessingStatus(v:int) : uint
      {
         for(var i:uint = 0; i < specialGoodsNameArr[1].Arr.length; i++)
         {
            if(v < specialGoodsNameArr[1].Arr[i])
            {
               return i;
            }
         }
         return 2;
      }
      
      public static function TreeStatus(v1:int, v2:int) : uint
      {
         var i:uint = 0;
         var water:uint = 0;
         var status:uint = 0;
         var goodsbasic:Object = specialGoodsNameArr[0];
         var v3:int = v1 > v2 ? v2 : v1;
         if(v3 >= 1200)
         {
            return 4;
         }
         for(i = 0; i < goodsbasic.Arr.length; i++)
         {
            if(v3 < goodsbasic.Arr[i])
            {
               status = i;
               break;
            }
         }
         return status;
      }
      
      public static function lilyPondStatus(v1:int) : uint
      {
         var i:uint = 0;
         var water:uint = 0;
         var status:uint = 0;
         var goodsbasic:Object = specialGoodsNameArr[2];
         if(v1 >= 300)
         {
            return 3;
         }
         for(i = 0; i < goodsbasic.Arr.length; i++)
         {
            if(v1 < goodsbasic.Arr[i])
            {
               status = i;
               break;
            }
         }
         return status;
      }
      
      public static function showLilyPond(goodsInfo:Object) : void
      {
         var treeStatus:uint = lilyPondStatus(goodsInfo.v1);
         goodInLevel(treeStatus,specialGoodsNameArr[2],RootMC.depth_mc);
      }
      
      public static function showMaoMaoTree(goodsInfo:Object) : void
      {
         var treeStatus:uint = TreeStatus(goodsInfo.v1,goodsInfo.v2);
         goodInLevel(treeStatus,specialGoodsNameArr[0],RootMC.depth_mc);
      }
      
      public static function goodInLevel(Status:uint, goodsbasic:Object, levelmc:MovieClip) : void
      {
         var mc:* = undefined;
         var loader:Loader = null;
         var goodsMC:Object = null;
         var len:uint = uint(levelmc.numChildren);
         for(var k:uint = 0; k < len; k++)
         {
            mc = levelmc.getChildAt(k);
            trace("-----***********",mc.ID,goodsbasic.ID);
            if(mc.ID == goodsbasic.ID)
            {
               trace("------dfdsff",mc.numChildren);
               goodsbasic.mc = mc;
               mc.Visible = Status * 2 + 1;
               goodsbasic.Visible = Status * 2 + 1;
               try
               {
                  loader = mc.getChildAt(0);
                  goodsMC = loader.content;
                  MovieClip(goodsMC.mc2.getChildAt(0)).gotoAndStop(goodsbasic.Visible);
               }
               catch(e:Error)
               {
               }
            }
         }
      }
      
      public static function getSpecialGoodsStatus(id:uint) : uint
      {
         for(var i:uint = 0; i < specialGoodsNameArr.length; i++)
         {
            if(specialGoodsNameArr[i].ID == id)
            {
               return specialGoodsNameArr[i].Visible;
            }
         }
         return 0;
      }
   }
}

