package com.logic.FindPathLogic
{
   import com.logic.MapManageLogic.MapModelLogic;
   import flash.geom.Point;
   
   public dynamic class FindPathLogic
   {
      
      private var MapModel:MapModelLogic;
      
      private var MapWhidth:Number;
      
      private var MapHeight:Number;
      
      private var GridSize:uint = 10;
      
      private var GridX:uint;
      
      private var GridY:uint;
      
      private var GridTotal:uint;
      
      private var MapArray:Array;
      
      public var MapArrayBAK:Array;
      
      private var closeArray:Array;
      
      private var operArray:Array;
      
      private var PopArray:Array;
      
      private var pathArray:Array;
      
      private var currentNode:Object;
      
      private var startX:int;
      
      private var startY:int;
      
      private var endX:int;
      
      private var endY:int;
      
      private var isFindedPath:Boolean;
      
      private var isFinding:Boolean;
      
      private var directionObject:Object = new Object();
      
      private var crossDirectionObject:Object = new Object();
      
      private var nextNode:Object = new Object();
      
      public function FindPathLogic()
      {
         super();
      }
      
      public static function hashit(a:Point, b:Point) : Boolean
      {
         var __X:Number = NaN;
         var __Y:Number = NaN;
         var p:Point = null;
         var S_A:Number = Math.abs(a.x * MapModelLogic.GridSize - b.x * MapModelLogic.GridSize);
         var S_B:Number = Math.abs(a.y * MapModelLogic.GridSize - b.y * MapModelLogic.GridSize);
         var S_C:Number = Math.sqrt(Math.pow(S_A,2) + Math.pow(S_B,2));
         var Count:uint = uint(int(S_C / MapModelLogic.GridSize));
         var myAngle:Number = Number(GV.FindPath.getAngle(a.x - b.x,a.y - b.y));
         var X:Number = MapModelLogic.GridSize * Math.cos(myAngle * Math.PI / 180);
         var Y:Number = MapModelLogic.GridSize * Math.sin(myAngle * Math.PI / 180);
         for(var i:uint = 0; i < Count; i++)
         {
            __X = a.x * MapModelLogic.GridSize - X * i;
            __Y = a.y * MapModelLogic.GridSize - Y * i;
            if(MapModelLogic.mapFrame.y == 0)
            {
               if(MapModelLogic.TypeLever.hitTestPoint(__X,__Y,true))
               {
                  return true;
               }
            }
            else
            {
               p = MapModelLogic.TypeLever.localToGlobal(new Point(__X,__Y));
               if(MapModelLogic.TypeLever.hitTestPoint(p.x,p.y,true))
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public static function noHitLatelyPoint(s:Point, e:Point, sizeNum:int) : Point
      {
         return GV.FindPath.noHitLatelyPoint1(s,e,sizeNum);
      }
      
      public function createMapModel(model:*) : void
      {
         this.MapModel = model;
         this.directionObject.up = [0,-1,10];
         this.directionObject.down = [0,1,10];
         this.directionObject.left = [-1,0,10];
         this.directionObject.right = [1,0,10];
         this.crossDirectionObject.left_up = [-1,-1,14];
         this.crossDirectionObject.left_down = [-1,1,14];
         this.crossDirectionObject.right_up = [1,-1,14];
         this.crossDirectionObject.right_down = [1,1,14];
         this.MapWhidth = MapModelLogic.MapWhidth;
         this.MapHeight = MapModelLogic.MapHeight;
         this.GridSize = MapModelLogic.GridSize;
         this.GridX = MapModelLogic.GridX;
         this.GridY = MapModelLogic.GridY;
         this.GridTotal = MapModelLogic.GridTotal;
         this.MapArray = MapModelLogic.MapArray;
         this.MapArrayBAK = MapModelLogic.MapArrayBAK;
      }
      
      public function getPath(SX:Number, SY:Number, EX:Number, EY:Number) : Array
      {
         this.resetStatus();
         this.startX = int(SX / this.GridSize);
         this.startY = int(SY / this.GridSize);
         this.endX = int(EX / this.GridSize);
         this.endY = int(EY / this.GridSize);
         if(this.getPoints(this.endX,this.endY))
         {
            this.searchPath();
            this.PopArray.shift();
            this.PopArray.unshift({
               "X":this.startX,
               "Y":this.startY
            });
            this.reduce(this.PopArray);
            return this.pathArray;
         }
         return [];
      }
      
      private function resetStatus() : void
      {
         this.isFindedPath = false;
         this.isFinding = false;
         this.operArray = new Array();
         this.closeArray = new Array();
         this.PopArray = new Array();
         this.MapArray = new Array();
         this.pathArray = new Array();
         this.MapArray = this.MapArrayBAK.map(this.MapModel.clone);
      }
      
      private function getMapArray(X:int, Y:int) : Boolean
      {
         try
         {
            return this.MapArray[X][Y] != null;
         }
         catch(e:*)
         {
            return false;
         }
      }
      
      private function getPoints(EX:int, EY:int) : Boolean
      {
         return this.getMapArray(EX,EY) && this.MapArray[EX][EY] != 0 ? true : false;
      }
      
      private function searchPath() : void
      {
         this.isFinding = true;
         this.addElementInoperList(this.startX,this.startY,{
            "H":0,
            "F":0,
            "N":0
         },0);
         this.currentNode = this.operArray.pop();
         this.findNode();
         if(this.isFindedPath)
         {
            this.PopArray = this.popPath();
         }
      }
      
      private function findNode() : void
      {
         if(this.operArray.length + this.closeArray.length > this.GridTotal)
         {
            return;
         }
         if(Boolean(this.currentNode))
         {
            try
            {
               if(this.MapArray[this.currentNode.X][this.currentNode.Y] != null)
               {
                  if(this.currentNode.X == this.endX && this.currentNode.Y == this.endY)
                  {
                     this.addElementIncloseList(this.currentNode);
                     this.isFindedPath = true;
                     this.isFinding = false;
                  }
                  else
                  {
                     this.addElementIncloseList();
                     this.dilatationeOperList();
                     this.findNode();
                  }
               }
            }
            catch(e:Error)
            {
            }
            return;
         }
      }
      
      private function dilatationeOperList() : void
      {
         var element:Array = null;
         var CX:int = 0;
         var CY:int = 0;
         this.bypass(this.directionObject.left,0);
         this.bypass(this.directionObject.right,0);
         this.bypass(this.directionObject.up,1);
         this.bypass(this.directionObject.down,1);
         for each(element in this.crossDirectionObject)
         {
            CX = this.currentNode.X + element[0];
            CY = this.currentNode.Y + element[1];
            if(this.getMapArray(CX,CY))
            {
               if(this.MapArray[CX][CY] > 0)
               {
                  this.addElementInoperList(CX,CY,this.currentNode,element[2]);
               }
               else if(this.MapArray[CX][CY] < 0)
               {
                  this.MapArray[CX][CY] = this.MapArrayBAK[CX][CY];
               }
            }
         }
         this.operArray.sortOn("H",Array.NUMERIC);
         this.operArray.reverse();
         if(Boolean(this.operArray.length))
         {
            this.currentNode = this.operArray.pop();
         }
         else
         {
            this.currentNode = null;
         }
      }
      
      private function bypass(passArray:Array, passNum:int) : void
      {
         var CX:int = this.currentNode.X + passArray[0];
         var CY:int = this.currentNode.Y + passArray[1];
         if(this.getMapArray(CX,CY))
         {
            if(this.MapArray[CX][CY] > 0)
            {
               this.addElementInoperList(CX,CY,this.currentNode,passArray[2]);
            }
            else if(this.MapArrayBAK[CX][CY] <= 0)
            {
               if(this.crossDirectionObject.left_up[passNum] == passArray[passNum])
               {
                  CX = this.currentNode.X + this.crossDirectionObject.left_up[0];
                  CY = this.currentNode.Y + this.crossDirectionObject.left_up[1];
                  if(this.getMapArray(CX,CY) && this.MapArray[CX][CY] > 0)
                  {
                     this.MapArray[CX][CY] = -1;
                  }
               }
               if(this.crossDirectionObject.left_down[passNum] == passArray[passNum])
               {
                  CX = this.currentNode.X + this.crossDirectionObject.left_down[0];
                  CY = this.currentNode.Y + this.crossDirectionObject.left_down[1];
                  if(this.getMapArray(CX,CY) && this.MapArray[CX][CY] > 0)
                  {
                     this.MapArray[CX][CY] = -1;
                  }
               }
               if(this.crossDirectionObject.right_up[passNum] == passArray[passNum])
               {
                  CX = this.currentNode.X + this.crossDirectionObject.right_up[0];
                  CY = this.currentNode.Y + this.crossDirectionObject.right_up[1];
                  if(this.getMapArray(CX,CY) && this.MapArray[CX][CY] > 0)
                  {
                     this.MapArray[CX][CY] = -1;
                  }
               }
               if(this.crossDirectionObject.right_down[passNum] == passArray[passNum])
               {
                  CX = this.currentNode.X + this.crossDirectionObject.right_down[0];
                  CY = this.currentNode.Y + this.crossDirectionObject.right_down[1];
                  if(this.getMapArray(CX,CY) && this.MapArray[CX][CY] > 0)
                  {
                     this.MapArray[CX][CY] = -1;
                  }
               }
            }
         }
      }
      
      private function addElementInoperList(SX:int, SY:int, parentObj:Object, __H:uint) : void
      {
         this.MapArray[SX][SY] = 0;
         var F:uint = parentObj.F + __H;
         var G:uint = Math.abs(this.endX - SX) + Math.abs(this.endY - SY);
         var H:uint = G * 10 + F;
         this.operArray.push({
            "X":SX,
            "Y":SY,
            "H":H,
            "F":F,
            "P":parentObj,
            "G":G
         });
      }
      
      private function addElementIncloseList(element:Object = null) : void
      {
         this.closeArray.push(Boolean(element) ? element : this.currentNode);
      }
      
      private function getHNum(sx:int, sy:int, __H:uint) : uint
      {
         var F:uint = Math.abs(this.endX - sx) + Math.abs(this.endY - sy);
         var X:uint = Math.abs(this.startX - sx);
         var Y:uint = Math.abs(this.startY - sy);
         var C:uint = Math.min(X,Y);
         var G:uint = Math.abs(X - Y) * 10 + C * 14;
         return F * 10 + G;
      }
      
      private function popPath() : Array
      {
         var tempArray:Array = new Array();
         this.nextNode = this.closeArray[this.closeArray.length - 1];
         var temp:Array = new Array();
         while(Boolean(this.nextNode.P))
         {
            tempArray.unshift(this.nextNode);
            this.nextNode = this.nextNode.P;
         }
         tempArray.shift();
         return tempArray;
      }
      
      private function cleanCloseList(element:*, index:int, arr:Array) : Boolean
      {
         return element.H >= this.currentNode.H;
      }
      
      private function reduce(myArray:Array) : void
      {
         var i:int = 0;
         var endpoint:Point = null;
         var tempObj:Object = myArray.shift();
         this.pathArray.push(tempObj);
         var startpoint:Point = new Point(tempObj.X,tempObj.Y);
         if(myArray.length != 1)
         {
            for(i = myArray.length - 1; i > 0; i--)
            {
               endpoint = new Point(myArray[i].X,myArray[i].Y);
               if(!hashit(startpoint,endpoint))
               {
                  if(myArray[i] == myArray[myArray.length - 1])
                  {
                     this.pathArray.push(myArray[myArray.length - 1]);
                     break;
                  }
                  this.reduce(myArray.slice(i));
                  break;
               }
               if(i == 1)
               {
                  this.reduce(myArray.slice(i));
                  break;
               }
            }
         }
         else
         {
            this.pathArray.push(myArray[0]);
         }
      }
      
      public function noHitLatelyPoint1(a:Point, b:Point, sizeNum:int) : Point
      {
         var __X:Number = NaN;
         var __Y:Number = NaN;
         var b1:Boolean = this.getPoints(int(a.x / this.GridSize),int(a.y / this.GridSize));
         var p:Point = b;
         var S_A:Number = Math.abs(a.x - b.x);
         var S_B:Number = Math.abs(a.y - b.y);
         var S_C:Number = Math.sqrt(Math.pow(S_A,2) + Math.pow(S_B,2));
         var Count:uint = uint(int(S_C / MapModelLogic.GridSize));
         var myAngle:Number = this.getAngle(a.x - b.x,a.y - b.y);
         var X:Number = MapModelLogic.GridSize * Math.cos(myAngle * Math.PI / 180);
         var Y:Number = MapModelLogic.GridSize * Math.sin(myAngle * Math.PI / 180);
         for(var i:uint = 0; i < sizeNum; i++)
         {
            __X = a.x - X * i;
            __Y = a.y - Y * i;
            if(GV.MC_mapFrame.y == 0)
            {
               if(!(!MapModelLogic.TypeLever.hitTestPoint(__X,__Y,true) && this.getMapArray(__X / MapModelLogic.GridSize,__Y / MapModelLogic.GridSize)))
               {
                  break;
               }
               p = new Point(__X,__Y);
            }
            else
            {
               p = MapModelLogic.TypeLever.localToGlobal(new Point(__X,__Y));
               if(!(!MapModelLogic.TypeLever.hitTestPoint(p.x,p.y,true) && this.getMapArray(__X / MapModelLogic.GridSize,__Y / MapModelLogic.GridSize)))
               {
                  break;
               }
               p = new Point(__X,__Y);
            }
         }
         return p;
      }
      
      public function getAngle(X:Number, Y:Number) : Number
      {
         var myAngle:Number = Math.atan2(Y,X) / Math.PI * 180;
         if(myAngle < 0)
         {
            myAngle += 180 * 2;
         }
         return myAngle;
      }
   }
}

