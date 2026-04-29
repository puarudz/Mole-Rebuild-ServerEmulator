package com.module.house
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.clearTimeout;
   import flash.utils.getDefinitionByName;
   import flash.utils.setTimeout;
   
   public class floorViewStatic extends MovieClip
   {
      
      public static var dispatchEvent:Function;
      
      public static var addEventListener:Function;
      
      public static var removeEventListener:Function;
      
      public static var map:Array;
      
      public static var w:Number;
      
      public static var h:Number;
      
      public static var way:Shape;
      
      public static var s:Shape;
      
      public static var l:Shape;
      
      public static var b:Shape;
      
      public static var t:Shape;
      
      public static var o:Shape;
      
      public static var q1:Class;
      
      public static var q2:Class;
      
      public static var q3:Class;
      
      public static var q4:Class;
      
      public static var q5:Class;
      
      public static var s1:Class;
      
      public static var s2:Class;
      
      public static var s3:Class;
      
      public static var s4:Class;
      
      public static var s5:Class;
      
      public static var floorMC:DisplayObjectContainer;
      
      public static var lineMC:DisplayObjectContainer;
      
      public static var BGMC:DisplayObjectContainer;
      
      public static var hitMC:DisplayObjectContainer;
      
      public static var RootMC:*;
      
      public static var wallLineMC:DisplayObjectContainer;
      
      public static var topMC:DisplayObjectContainer;
      
      public static var wallMC:DisplayObjectContainer;
      
      public static var wallShape:DisplayObjectContainer;
      
      public static var wallArr:Array;
      
      public static var wallShapeArr:Array;
      
      public static var myTimeout:*;
      
      public static var kk:int = 50;
      
      public static var k:int = 25;
      
      public static var anglePointArr:Array = [];
      
      public static var arr8:Array = [];
      
      public static var arrAngle:Array = [];
      
      public static var num:Number = 0;
      
      public static var X:Number = 0;
      
      public static var Y:Number = 0;
      
      public static var posarri:Array = [-1,-1,0,1,1,1,0,-1];
      
      public static var posarrj:Array = [0,1,1,1,0,-1,-1,-1];
      
      public static var p0:Point = new Point();
      
      public static var p1:Point = new Point();
      
      public static var p2:Point = new Point();
      
      public static var p3:Point = new Point();
      
      public static var p4:Point = new Point();
      
      public static var p5:Point = new Point();
      
      public static var p6:Point = new Point();
      
      public static var p7:Point = new Point();
      
      public static var p8:Point = new Point();
      
      public static var Mode:int = 0;
      
      public static var m:int = 0;
      
      public function floorViewStatic()
      {
         super();
      }
      
      public static function removeFloorListener() : void
      {
         try
         {
            floorMC.stage.removeEventListener(MouseEvent.CLICK,addFloorTime);
            floorMC.stage.removeEventListener(MouseEvent.MOUSE_MOVE,changeMouseIcon);
            floorMC.stage.removeEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
         }
         catch(e:Error)
         {
         }
      }
      
      public static function changeWorkMode(i:int) : void
      {
         Mode = i;
         RootMC.wa_tool.btn.addEventListener(MouseEvent.CLICK,addFloorTime);
         RootMC.bu_tool.btn.addEventListener(MouseEvent.CLICK,addFloorTime);
         floorMC.stage.addEventListener(MouseEvent.MOUSE_MOVE,changeMouseIcon);
         floorMC.stage.addEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
      }
      
      public static function keyUpHandler(event:KeyboardEvent) : void
      {
         if(event.keyCode == Keyboard.LEFT)
         {
            RootMC.wa_autotool.x -= 40;
            X = RootMC.wa_autotool.x;
            Y = RootMC.wa_autotool.y;
            addFloor();
         }
         if(event.keyCode == Keyboard.RIGHT)
         {
            RootMC.wa_autotool.x += 40;
            X = RootMC.wa_autotool.x;
            Y = RootMC.wa_autotool.y;
            addFloor();
         }
         if(event.keyCode == Keyboard.UP)
         {
            RootMC.wa_autotool.y -= 40;
            X = RootMC.wa_autotool.x;
            Y = RootMC.wa_autotool.y;
            addFloor();
         }
         if(event.keyCode == Keyboard.DOWN)
         {
            RootMC.wa_autotool.y += 40;
            X = RootMC.wa_autotool.x;
            Y = RootMC.wa_autotool.y;
            addFloor();
         }
      }
      
      public static function addFloorTime(e:MouseEvent) : void
      {
         if(myTimeout != null)
         {
            clearTimeout(myTimeout);
         }
         floorMC.stage.removeEventListener(MouseEvent.MOUSE_MOVE,changeMouseIcon);
         e.target.parent.tool.gotoAndPlay(2);
         X = RootMC.mouseX;
         Y = RootMC.mouseY;
         myTimeout = setTimeout(addFloor,500);
      }
      
      public static function gogogo(loadObj:*, rootmc:MovieClip, arr:Array) : void
      {
         wallArr = new Array();
         q1 = GV.Lib_Map.getClass("q1");
         q2 = GV.Lib_Map.getClass("q2");
         q3 = GV.Lib_Map.getClass("q3");
         q4 = GV.Lib_Map.getClass("q4");
         q5 = GV.Lib_Map.getClass("q5");
         s1 = GV.Lib_Map.getClass("s1");
         s2 = GV.Lib_Map.getClass("s2");
         s3 = GV.Lib_Map.getClass("s3");
         s4 = GV.Lib_Map.getClass("s4");
         s5 = GV.Lib_Map.getClass("s5");
         wallArr = [q1,q2,q3,q4,q5];
         wallShapeArr = [s1,s2,s3,s4,s5];
         RootMC = rootmc;
         var ed:EventDispatcher = new EventDispatcher();
         dispatchEvent = ed.dispatchEvent;
         addEventListener = ed.addEventListener;
         removeEventListener = ed.removeEventListener;
         s = new Shape();
         l = new Shape();
         b = new Shape();
         o = new Shape();
         t = new Shape();
         way = new Shape();
         var bottomShape:Shape = new Shape();
         floorMC = rootmc.floorMC;
         lineMC = rootmc.lineMC;
         hitMC = rootmc.hitTestMC;
         BGMC = rootmc.floorBg;
         topMC = rootmc.topMC;
         wallMC = rootmc.wallMC;
         wallLineMC = rootmc.wallLineMC;
         wallShape = rootmc.wallShape;
         lineMC.mouseEnabled = false;
         topMC.mouseEnabled = false;
         wallMC.mouseEnabled = false;
         wallLineMC.mouseEnabled = false;
         bottomShape.graphics.beginFill(8866577,1);
         initLineStyle();
         topMC.addChild(t);
         topMC.y = -50;
         hitMC.addChild(o);
         floorMC.addChild(s);
         lineMC.addChild(l);
         wallLineMC.addChild(b);
         topMC.addChild(bottomShape);
         wallLineMC.y = -50;
         RootMC.type_mc.addChild(way);
         RootMC.bg_up_floor.mask = topMC;
         RootMC.WALL.mask = wallMC;
         RootMC.bg_up_floor.mouseEnabled = false;
         BGMC.mask = s;
         w = 17;
         h = 8;
         map = arr;
         drawBottomShape(bottomShape);
         drawMap();
      }
      
      public static function initLineStyle() : void
      {
         l.graphics.lineStyle(2,8866577);
         b.graphics.lineStyle(2,4140568);
         s.graphics.beginFill(16711680);
         o.graphics.beginFill(16711680);
         t.graphics.beginFill(8866577,1);
         way.graphics.beginFill(16711680);
      }
      
      public static function drawBottomShape(bottomShape:Shape) : void
      {
         bottomShape.graphics.moveTo(22,50 * 8 + 122);
         bottomShape.graphics.lineTo(17 * 50 + 25,50 * 8 + 122);
         bottomShape.graphics.lineTo(17 * 50 + 25,50 * 9 + 122);
         bottomShape.graphics.lineTo(22,50 * 9 + 122);
         bottomShape.graphics.lineTo(22,50 * 8 + 122);
      }
      
      public static function changeMouseIcon(e:Event) : void
      {
         var mc:* = undefined;
         try
         {
            mc = RootMC;
            if(mc.mouseX < 880)
            {
               if(Mode == 1)
               {
                  RootMC.wa_tool.x = mc.mouseX;
                  RootMC.wa_tool.y = mc.mouseY;
               }
               else
               {
                  RootMC.bu_tool.x = mc.mouseX;
                  RootMC.bu_tool.y = mc.mouseY;
               }
            }
            else
            {
               RootMC.wa_tool.x = 1000;
               RootMC.bu_tool.x = 1000;
            }
         }
         catch(err:Error)
         {
         }
      }
      
      public static function addFloor() : void
      {
         try
         {
            if(Mode == 1 || Mode == 2)
            {
               floorMC.stage.addEventListener(MouseEvent.MOUSE_MOVE,changeMouseIcon);
               if(X < kk * 17 + 23 && X > 0 && Y < kk * 8 + 122 && Y > 0)
               {
                  X = int((X - 23) / kk);
                  Y = int((Y - 122) / kk);
                  if(!(X < 0 || X > 16 || Y < 1 || Y > 7))
                  {
                     if(Mode == 1)
                     {
                        if(map[Y][X] != 1)
                        {
                           removeWall();
                           map[Y][X] = 1;
                           reDraw();
                        }
                     }
                     else if(Mode == 2)
                     {
                        if(map[Y][X] != 0)
                        {
                           removeWall();
                           map[Y][X] = 0;
                           reDraw();
                        }
                     }
                     dispatchEvent(new Event("changeFloorMap"));
                  }
               }
            }
         }
         catch(err:Error)
         {
         }
      }
      
      public static function removeWall() : void
      {
         for(var i:int = wallMC.numChildren - 1; i >= 0; i--)
         {
            wallMC.removeChildAt(i);
         }
         for(var j:int = wallShape.numChildren - 1; j >= 0; j--)
         {
            wallShape.removeChildAt(j);
         }
      }
      
      public static function reDraw() : void
      {
         way.graphics.clear();
         s.graphics.clear();
         o.graphics.clear();
         l.graphics.clear();
         t.graphics.clear();
         b.graphics.clear();
         initLineStyle();
         drawMap();
      }
      
      public static function drawMap() : void
      {
         var j:uint = 0;
         for(var i:uint = 0; i < h; i++)
         {
            for(j = 0; j < w; j++)
            {
               if(Boolean(map[i][j]))
               {
                  dodraw(i,j);
               }
               else
               {
                  dodrawOut(i,j);
               }
            }
         }
      }
      
      public static function dodrawOut(i:int, j:int) : void
      {
         getPoint9(i,j);
         getOutAngle(i,j);
         for(var k:uint = 0; k < 4; k++)
         {
            drawAngleOut(k,arrAngle[k],i);
         }
      }
      
      public static function dodraw(i:int, j:int) : void
      {
         getPoint9(i,j);
         getInAngle(i,j);
         for(var k:uint = 0; k < 4; k++)
         {
            drawAngle(k,arrAngle[k]);
         }
      }
      
      public static function drawAngleOut(k:int, bool:Boolean, i:int) : void
      {
         var wall:DisplayObject = null;
         var wallshape:DisplayObject = null;
         if(bool)
         {
            s.graphics.moveTo(anglePointArr[k][0].x,anglePointArr[k][0].y);
            s.graphics.lineTo(anglePointArr[k][1].x,anglePointArr[k][1].y);
            s.graphics.lineTo(anglePointArr[k][2].x,anglePointArr[k][2].y);
            s.graphics.curveTo(anglePointArr[k][1].x,anglePointArr[k][1].y,anglePointArr[k][0].x,anglePointArr[k][0].y);
            l.graphics.moveTo(anglePointArr[k][0].x,anglePointArr[k][0].y);
            l.graphics.curveTo(anglePointArr[k][1].x,anglePointArr[k][1].y,anglePointArr[k][2].x,anglePointArr[k][2].y);
            b.graphics.moveTo(anglePointArr[k][0].x,anglePointArr[k][0].y);
            b.graphics.curveTo(anglePointArr[k][1].x,anglePointArr[k][1].y,anglePointArr[k][2].x,anglePointArr[k][2].y);
            if(k == 2)
            {
               wall = new wallArr[k]();
               wallMC.addChild(wall);
               wallshape = new wallShapeArr[k]();
               wallShape.addChild(wallshape);
               wall.x = p0.x;
               wall.y = p0.y;
               wallshape.x = p0.x;
               wallshape.y = p0.y;
            }
            else if(k == 1)
            {
               wall = new wallArr[k]();
               wallshape = new wallShapeArr[k]();
               wallMC.addChild(wall);
               wallShape.addChild(wallshape);
               wall.x = p1.x;
               wall.y = p1.y;
               wallshape.x = p1.x;
               wallshape.y = p1.y;
            }
            wall = null;
            way.graphics.moveTo(anglePointArr[k][0].x,anglePointArr[k][0].y);
            way.graphics.curveTo(anglePointArr[k][1].x,anglePointArr[k][1].y,anglePointArr[k][2].x,anglePointArr[k][2].y);
            way.graphics.lineTo(p4.x,p4.y);
            way.graphics.lineTo(anglePointArr[k][0].x,anglePointArr[k][0].y);
            o.graphics.moveTo(anglePointArr[k][0].x,anglePointArr[k][0].y);
            o.graphics.curveTo(anglePointArr[k][1].x,anglePointArr[k][1].y,anglePointArr[k][2].x,anglePointArr[k][2].y);
            o.graphics.lineTo(p4.x,p4.y);
            o.graphics.lineTo(anglePointArr[k][0].x,anglePointArr[k][0].y);
            if(i != 0)
            {
               t.graphics.moveTo(anglePointArr[k][0].x,anglePointArr[k][0].y);
               t.graphics.curveTo(anglePointArr[k][1].x,anglePointArr[k][1].y,anglePointArr[k][2].x,anglePointArr[k][2].y);
               t.graphics.lineTo(p4.x,p4.y);
               t.graphics.lineTo(anglePointArr[k][0].x,anglePointArr[k][0].y);
            }
         }
         else
         {
            way.graphics.moveTo(anglePointArr[k][0].x,anglePointArr[k][0].y);
            way.graphics.lineTo(anglePointArr[k][1].x,anglePointArr[k][1].y);
            way.graphics.lineTo(anglePointArr[k][2].x,anglePointArr[k][2].y);
            way.graphics.lineTo(p4.x,p4.y);
            way.graphics.lineTo(anglePointArr[k][0].x,anglePointArr[k][0].y);
            o.graphics.moveTo(anglePointArr[k][0].x,anglePointArr[k][0].y);
            o.graphics.lineTo(anglePointArr[k][1].x,anglePointArr[k][1].y);
            o.graphics.lineTo(anglePointArr[k][2].x,anglePointArr[k][2].y);
            o.graphics.lineTo(p4.x,p4.y);
            o.graphics.lineTo(anglePointArr[k][0].x,anglePointArr[k][0].y);
            if(i != 0)
            {
               t.graphics.moveTo(anglePointArr[k][0].x,anglePointArr[k][0].y);
               t.graphics.lineTo(anglePointArr[k][1].x,anglePointArr[k][1].y);
               t.graphics.lineTo(anglePointArr[k][2].x,anglePointArr[k][2].y);
               t.graphics.lineTo(p4.x,p4.y);
               t.graphics.lineTo(anglePointArr[k][0].x,anglePointArr[k][0].y);
            }
         }
      }
      
      public static function drawAngle(k:int, bool:Boolean) : void
      {
         var wall:DisplayObject = null;
         var wallshape:DisplayObject = null;
         if(bool)
         {
            s.graphics.moveTo(anglePointArr[k][0].x,anglePointArr[k][0].y);
            s.graphics.lineTo(anglePointArr[k][1].x,anglePointArr[k][1].y);
            s.graphics.lineTo(anglePointArr[k][2].x,anglePointArr[k][2].y);
            s.graphics.lineTo(p4.x,p4.y);
            s.graphics.lineTo(anglePointArr[k][0].x,anglePointArr[k][0].y);
         }
         else
         {
            s.graphics.moveTo(anglePointArr[k][0].x,anglePointArr[k][0].y);
            s.graphics.curveTo(anglePointArr[k][1].x,anglePointArr[k][1].y,anglePointArr[k][2].x,anglePointArr[k][2].y);
            s.graphics.lineTo(p4.x,p4.y);
            s.graphics.lineTo(anglePointArr[k][0].x,anglePointArr[k][0].y);
            way.graphics.moveTo(anglePointArr[k][0].x,anglePointArr[k][0].y);
            way.graphics.lineTo(anglePointArr[k][1].x,anglePointArr[k][1].y);
            way.graphics.lineTo(anglePointArr[k][2].x,anglePointArr[k][2].y);
            way.graphics.curveTo(anglePointArr[k][1].x,anglePointArr[k][1].y,anglePointArr[k][0].x,anglePointArr[k][0].y);
            o.graphics.moveTo(anglePointArr[k][0].x,anglePointArr[k][0].y);
            o.graphics.lineTo(anglePointArr[k][1].x,anglePointArr[k][1].y);
            o.graphics.lineTo(anglePointArr[k][2].x,anglePointArr[k][2].y);
            o.graphics.curveTo(anglePointArr[k][1].x,anglePointArr[k][1].y,anglePointArr[k][0].x,anglePointArr[k][0].y);
            if(k == 0)
            {
               wall = new wallArr[k]();
               wallMC.addChild(wall);
               wall.x = p1.x;
               wall.y = p1.y - kk;
               wallshape = new wallShapeArr[k]();
               wallShape.addChild(wallshape);
               wallshape.x = p1.x;
               wallshape.y = p1.y - kk;
            }
            else if(k == 3)
            {
               wall = new wallArr[k]();
               wallMC.addChild(wall);
               wall.x = p0.x;
               wall.y = p0.y - kk;
               wallshape = new wallShapeArr[k]();
               wallShape.addChild(wallshape);
               wallshape.x = p0.x;
               wallshape.y = p0.y - kk;
            }
            t.graphics.moveTo(anglePointArr[k][0].x,anglePointArr[k][0].y);
            t.graphics.lineTo(anglePointArr[k][1].x,anglePointArr[k][1].y);
            t.graphics.lineTo(anglePointArr[k][2].x,anglePointArr[k][2].y);
            t.graphics.curveTo(anglePointArr[k][1].x,anglePointArr[k][1].y,anglePointArr[k][0].x,anglePointArr[k][0].y);
            l.graphics.moveTo(anglePointArr[k][0].x,anglePointArr[k][0].y);
            l.graphics.curveTo(anglePointArr[k][1].x,anglePointArr[k][1].y,anglePointArr[k][2].x,anglePointArr[k][2].y);
            b.graphics.moveTo(anglePointArr[k][0].x,anglePointArr[k][0].y);
            b.graphics.curveTo(anglePointArr[k][1].x,anglePointArr[k][1].y,anglePointArr[k][2].x,anglePointArr[k][2].y);
         }
         if(arr8[2] - arr8[1] - arr8[0] == 1)
         {
            l.graphics.moveTo(p1.x,p1.y);
            l.graphics.lineTo(p2.x,p2.y);
            b.graphics.moveTo(p1.x,p1.y);
            b.graphics.lineTo(p2.x,p2.y);
            wall = new wallArr[4]();
            wallMC.addChild(wall);
            wall.x = p1.x;
            wall.y = p1.y;
         }
         if(arr8[0] - arr8[1] - arr8[2] == 1)
         {
            l.graphics.moveTo(p2.x,p2.y);
            l.graphics.lineTo(p5.x,p5.y);
            b.graphics.moveTo(p2.x,p2.y);
            b.graphics.lineTo(p5.x,p5.y);
         }
         if(arr8[4] - arr8[3] - arr8[2] == 1)
         {
            l.graphics.moveTo(p5.x,p5.y);
            l.graphics.lineTo(p8.x,p8.y);
            b.graphics.moveTo(p5.x,p5.y);
            b.graphics.lineTo(p8.x,p8.y);
         }
         if(arr8[2] - arr8[3] - arr8[4] == 1)
         {
            l.graphics.moveTo(p8.x,p8.y);
            l.graphics.lineTo(p7.x,p7.y);
            b.graphics.moveTo(p8.x,p8.y);
            b.graphics.lineTo(p7.x,p7.y);
         }
         if(arr8[6] - arr8[5] - arr8[4] == 1)
         {
            l.graphics.moveTo(p7.x,p7.y);
            l.graphics.lineTo(p6.x,p6.y);
            b.graphics.moveTo(p7.x,p7.y);
            b.graphics.lineTo(p6.x,p6.y);
         }
         if(arr8[4] - arr8[5] - arr8[6] == 1)
         {
            l.graphics.moveTo(p6.x,p6.y);
            l.graphics.lineTo(p3.x,p3.y);
            b.graphics.moveTo(p6.x,p6.y);
            b.graphics.lineTo(p3.x,p3.y);
         }
         if(arr8[0] - arr8[7] - arr8[6] == 1)
         {
            l.graphics.moveTo(p3.x,p3.y);
            l.graphics.lineTo(p0.x,p0.y);
            b.graphics.moveTo(p3.x,p3.y);
            b.graphics.lineTo(p0.x,p0.y);
         }
         if(arr8[6] - arr8[7] - arr8[0] == 1)
         {
            l.graphics.moveTo(p0.x,p0.y);
            l.graphics.lineTo(p1.x,p1.y);
            b.graphics.moveTo(p0.x,p0.y);
            b.graphics.lineTo(p1.x,p1.y);
            wall = new wallArr[4]();
            wallMC.addChild(wall);
            wall.x = p0.x;
            wall.y = p0.y;
         }
         wall = null;
      }
      
      public static function getPoint9(i:int, j:int) : void
      {
         p0.x = kk * j + 23;
         p0.y = kk * i + 122;
         p1.x = kk * j + k + 23;
         p1.y = kk * i + 122;
         p2.x = kk * j + kk + 23;
         p2.y = kk * i + 122;
         p3.x = kk * j + 23;
         p3.y = kk * i + k + 122;
         p4.x = kk * j + k + 23;
         p4.y = kk * i + k + 122;
         p5.x = kk * j + kk + 23;
         p5.y = kk * i + k + 122;
         p6.x = kk * j + 23;
         p6.y = kk * i + kk + 122;
         p7.x = kk * j + k + 23;
         p7.y = kk * i + kk + 122;
         p8.x = kk * j + kk + 23;
         p8.y = kk * i + kk + 122;
         anglePointArr = [[p1,p2,p5],[p5,p8,p7],[p7,p6,p3],[p3,p0,p1]];
      }
      
      public static function getArr8(i:int, j:int) : void
      {
         var a:uint = 0;
         for(a = 0; a < 8; a++)
         {
            try
            {
               arr8[a] = map[i + posarri[a]][j + posarrj[a]];
            }
            catch(err:Error)
            {
               arr8[a] = null;
            }
            if(arr8[a] == undefined)
            {
               arr8[a] = null;
            }
         }
      }
      
      public static function getInAngle(i:int, j:int) : void
      {
         getArr8(i,j);
         arrAngle[0] = arr8[0] | arr8[1] | arr8[2];
         arrAngle[1] = arr8[3] | arr8[4] | arr8[2];
         arrAngle[2] = arr8[4] | arr8[5] | arr8[6];
         arrAngle[3] = arr8[0] | arr8[6] | arr8[7];
      }
      
      public static function getOutAngle(i:int, j:int) : void
      {
         getArr8(i,j);
         arrAngle[0] = arr8[0] & arr8[2];
         arrAngle[1] = arr8[4] & arr8[2];
         arrAngle[2] = arr8[4] & arr8[6];
         arrAngle[3] = arr8[0] & arr8[6];
      }
      
      public static function get256Arr() : void
      {
         var str:String = null;
         for(var i:uint = 0; i < 256; i++)
         {
            str = i.toString(2);
            while(str.length < 8)
            {
               str = "0" + str;
            }
         }
      }
      
      public static function randomMap() : void
      {
         var j:uint = 0;
         for(var i:uint = 0; i < h; i++)
         {
            map[i] = (Math.random() * Math.pow(2,17)).toString(2).split("");
            while(map[i].length < w)
            {
               map[i].unshift(0);
            }
            for(j = 0; j < w; j++)
            {
               map[i][j] = Number(map[i][j]);
            }
         }
      }
   }
}

