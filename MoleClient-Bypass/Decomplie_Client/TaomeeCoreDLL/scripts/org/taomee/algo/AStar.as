package org.taomee.algo
{
   import flash.geom.Point;
   
   public class AStar
   {
      
      private static var _instance:AStar;
      
      public static const arounds:Array = [new Point(1,0),new Point(0,1),new Point(-1,0),new Point(0,-1),new Point(1,1),new Point(-1,1),new Point(-1,-1),new Point(1,-1)];
      
      private static const COST_STRAIGHT:int = 10;
      
      private static const COST_DIAGONAL:int = 14;
      
      public var maxTry:int = 1000;
      
      private const NOTE_ID:int = 0;
      
      private const NOTE_OPEN:int = 1;
      
      private const NOTE_CLOSED:int = 2;
      
      private var _mapModel:IMapModel;
      
      private var _openList:Array;
      
      private var _openCount:int;
      
      private var _openId:int;
      
      private var _nodeList:Array;
      
      private var _pathScoreList:Array;
      
      private var _movementCostList:Array;
      
      private var _fatherList:Array;
      
      private var _noteMap:Array;
      
      private var _isOptimize:Boolean = true;
      
      public function AStar()
      {
         super();
      }
      
      public static function get instance() : AStar
      {
         if(_instance == null)
         {
            _instance = new AStar();
         }
         return _instance;
      }
      
      public function init(mapModel:IMapModel) : void
      {
         this._mapModel = mapModel;
      }
      
      public function find(p_start:Point, p_end:Point, isOptimize:Boolean = true) : Array
      {
         var currId:int = 0;
         var currNoteP:Point = null;
         var checkingId:int = 0;
         var cost:int = 0;
         var score:int = 0;
         var aroundNotes:Array = null;
         var note:Point = null;
         if(this._mapModel == null)
         {
            return null;
         }
         var startPos:Point = this.transPoint(p_start.clone());
         var endPos:Point = this.transPoint(p_end.clone());
         if(!this.isArrive(endPos))
         {
            return null;
         }
         if(this.isThrough(startPos,endPos))
         {
            return [p_start.clone(),p_end.clone()];
         }
         this._isOptimize = isOptimize;
         this.initLists();
         this._openCount = 0;
         this._openId = -1;
         this.openNote(startPos,0,0,0);
         var currTry:int = 0;
         while(this._openCount > 0)
         {
            if(++currTry > this.maxTry)
            {
               this.destroyLists();
               return null;
            }
            currId = int(this._openList[0]);
            this.closeNote(currId);
            currNoteP = this._nodeList[currId];
            if(endPos.equals(currNoteP))
            {
               return this.getPath(startPos,currId);
            }
            aroundNotes = this.getArounds(currNoteP);
            for each(note in aroundNotes)
            {
               cost = this._movementCostList[currId] + (note.x == currNoteP.x || note.y == currNoteP.y ? COST_STRAIGHT : COST_DIAGONAL);
               score = cost + (Math.abs(endPos.x - note.x) + Math.abs(endPos.y - note.y)) * COST_STRAIGHT;
               if(this.isOpen(note))
               {
                  checkingId = int(this._noteMap[note.y][note.x][this.NOTE_ID]);
                  if(cost < this._movementCostList[checkingId])
                  {
                     this._movementCostList[checkingId] = cost;
                     this._pathScoreList[checkingId] = score;
                     this._fatherList[checkingId] = currId;
                     this.aheadNote(this._openList.indexOf(checkingId) + 1);
                  }
               }
               else
               {
                  this.openNote(note,score,cost,currId);
               }
            }
         }
         this.destroyLists();
         return null;
      }
      
      private function openNote(p:Point, score:int, cost:int, fatherId:int) : void
      {
         ++this._openCount;
         ++this._openId;
         if(this._noteMap[p.y] == null)
         {
            this._noteMap[p.y] = [];
         }
         this._noteMap[p.y][p.x] = [];
         this._noteMap[p.y][p.x][this.NOTE_OPEN] = true;
         this._noteMap[p.y][p.x][this.NOTE_ID] = this._openId;
         this._nodeList.push(p);
         this._pathScoreList.push(score);
         this._movementCostList.push(cost);
         this._fatherList.push(fatherId);
         this._openList.push(this._openId);
         this.aheadNote(this._openCount);
      }
      
      private function closeNote(id:int) : void
      {
         --this._openCount;
         var noteP:Point = this._nodeList[id];
         this._noteMap[noteP.y][noteP.x][this.NOTE_OPEN] = false;
         this._noteMap[noteP.y][noteP.x][this.NOTE_CLOSED] = true;
         if(this._openCount <= 0)
         {
            this._openCount = 0;
            this._openList.length = 0;
            return;
         }
         this._openList[0] = this._openList.pop();
         this.backNote();
      }
      
      private function aheadNote(index:int) : void
      {
         var father:int = 0;
         var change:int = 0;
         while(index > 1)
         {
            father = int(index / 2);
            if(this.getScore(index) >= this.getScore(father))
            {
               break;
            }
            change = int(this._openList[index - 1]);
            this._openList[index - 1] = this._openList[father - 1];
            this._openList[father - 1] = change;
            index = father;
         }
      }
      
      private function backNote() : void
      {
         var tmp:int = 0;
         var change:int = 0;
         var checkIndex:int = 1;
         while(true)
         {
            tmp = checkIndex;
            if(2 * tmp <= this._openCount)
            {
               if(this.getScore(checkIndex) > this.getScore(2 * tmp))
               {
                  checkIndex = 2 * tmp;
               }
               if(2 * tmp + 1 <= this._openCount)
               {
                  if(this.getScore(checkIndex) > this.getScore(2 * tmp + 1))
                  {
                     checkIndex = 2 * tmp + 1;
                  }
               }
            }
            if(tmp == checkIndex)
            {
               break;
            }
            change = int(this._openList[tmp - 1]);
            this._openList[tmp - 1] = this._openList[checkIndex - 1];
            this._openList[checkIndex - 1] = change;
         }
      }
      
      private function isOpen(p:Point) : Boolean
      {
         if(this._noteMap[p.y] == null)
         {
            return false;
         }
         if(this._noteMap[p.y][p.x] == null)
         {
            return false;
         }
         return this._noteMap[p.y][p.x][this.NOTE_OPEN];
      }
      
      private function isClosed(p:Point) : Boolean
      {
         if(this._noteMap[p.y] == null)
         {
            return false;
         }
         if(this._noteMap[p.y][p.x] == null)
         {
            return false;
         }
         return this._noteMap[p.y][p.x][this.NOTE_CLOSED];
      }
      
      private function getArounds(p:Point) : Array
      {
         var checkP:Point = null;
         var canDiagonal:Boolean = false;
         var arr:Array = [];
         var i:int = 0;
         checkP = p.add(arounds[i]);
         i++;
         var canRight:Boolean = this.isArrive(checkP);
         if(canRight && !this.isClosed(checkP))
         {
            arr.push(checkP);
         }
         checkP = p.add(arounds[i]);
         i++;
         var canDown:Boolean = this.isArrive(checkP);
         if(canDown && !this.isClosed(checkP))
         {
            arr.push(checkP);
         }
         checkP = p.add(arounds[i]);
         i++;
         var canLeft:Boolean = this.isArrive(checkP);
         if(canLeft && !this.isClosed(checkP))
         {
            arr.push(checkP);
         }
         checkP = p.add(arounds[i]);
         i++;
         var canUp:Boolean = this.isArrive(checkP);
         if(canUp && !this.isClosed(checkP))
         {
            arr.push(checkP);
         }
         checkP = p.add(arounds[i]);
         i++;
         canDiagonal = this.isArrive(checkP);
         if(canDiagonal && canRight && canDown && !this.isClosed(checkP))
         {
            arr.push(checkP);
         }
         checkP = p.add(arounds[i]);
         i++;
         canDiagonal = this.isArrive(checkP);
         if(canDiagonal && canLeft && canDown && !this.isClosed(checkP))
         {
            arr.push(checkP);
         }
         checkP = p.add(arounds[i]);
         i++;
         canDiagonal = this.isArrive(checkP);
         if(canDiagonal && canLeft && canUp && !this.isClosed(checkP))
         {
            arr.push(checkP);
         }
         checkP = p.add(arounds[i]);
         i++;
         canDiagonal = this.isArrive(checkP);
         if(canDiagonal && canRight && canUp && !this.isClosed(checkP))
         {
            arr.push(checkP);
         }
         return arr;
      }
      
      private function getPath(p_start:Point, id:int) : Array
      {
         var arr:Array = [];
         var noteP:Point = this._nodeList[id];
         while(!p_start.equals(noteP))
         {
            arr.push(noteP);
            id = int(this._fatherList[id]);
            noteP = this._nodeList[id];
         }
         arr.push(p_start);
         this.destroyLists();
         arr.reverse();
         if(this._isOptimize)
         {
            this.optimize(arr);
         }
         arr.forEach(this.eachArray);
         return arr;
      }
      
      private function eachArray(element:Point, index:int, arr:Array) : void
      {
         element.x *= this._mapModel.gridSize;
         element.y *= this._mapModel.gridSize;
      }
      
      private function getScore(index:int) : int
      {
         return this._pathScoreList[this._openList[index - 1]];
      }
      
      private function isArrive(p:Point) : Boolean
      {
         if(p.x < 0 || p.x >= this._mapModel.gridX || p.y < 0 || p.y >= this._mapModel.gridY)
         {
            return false;
         }
         return this._mapModel.data[p.x][p.y];
      }
      
      private function transPoint(p:Point) : Point
      {
         p.x = int(p.x / this._mapModel.gridSize);
         p.y = int(p.y / this._mapModel.gridSize);
         return p;
      }
      
      private function initLists() : void
      {
         this._openList = [];
         this._nodeList = [];
         this._pathScoreList = [];
         this._movementCostList = [];
         this._fatherList = [];
         this._noteMap = [];
      }
      
      private function destroyLists() : void
      {
         this._openList = null;
         this._nodeList = null;
         this._pathScoreList = null;
         this._movementCostList = null;
         this._fatherList = null;
         this._noteMap = null;
      }
      
      private function optimize(arr:Array, index:int = 0) : void
      {
         var p2:Point = null;
         var dis:int = 0;
         var angle:Number = NaN;
         var c:int = 0;
         var w:int = 0;
         var checkP:Point = null;
         if(arr == null)
         {
            return;
         }
         var _nLen:int = arr.length - 1;
         if(_nLen < 2)
         {
            return;
         }
         var p1:Point = arr[index];
         var newArr:Array = [];
         for(var i:int = _nLen; i > index; i--)
         {
            p2 = arr[i];
            dis = Point.distance(p1,p2);
            angle = Math.atan2(p2.y - p1.y,p2.x - p1.x);
            for(c = 1; c < dis; c++)
            {
               checkP = p1.add(Point.polar(c,angle));
               checkP.x = int(checkP.x);
               checkP.y = int(checkP.y);
               if(!Boolean(this._mapModel.data[checkP.x][checkP.y]))
               {
                  newArr.length = 0;
                  break;
               }
               newArr.push(checkP);
            }
            w = int(newArr.length);
            if(w > 0)
            {
               arr.splice(index + 1,i - index - 1);
               index += w - 1;
               break;
            }
         }
         if(index < _nLen)
         {
            this.optimize(arr,++index);
         }
      }
      
      private function isThrough(p1:Point, p2:Point) : Boolean
      {
         var checkP:Point = null;
         var dis:int = Point.distance(p1,p2);
         var angle:Number = Math.atan2(p2.y - p1.y,p2.x - p1.x);
         for(var i:int = 1; i < dis; i++)
         {
            checkP = p1.add(Point.polar(i,angle));
            checkP.x = int(checkP.x);
            checkP.y = int(checkP.y);
            if(this._mapModel.data[checkP.x][checkP.y] == false)
            {
               return false;
            }
         }
         return true;
      }
   }
}

