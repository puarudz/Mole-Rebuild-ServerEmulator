package com.logic.MapManageLogic
{
   import com.core.manager.LevelManager;
   import com.logic.PeopleCountLogic.PeopleCountLogic;
   import com.mole.app.map.MapLevel;
   import com.view.MapManageView.MapButtonView;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.text.TextField;
   
   public dynamic class MapModelLogic extends EventDispatcher
   {
      
      private static var _inst:MapModelLogic;
      
      public static const AIR_LAYER:String = "AirLayer";
      
      public static const FLOOR_LAYER:String = "FloorLayer";
      
      public static const OTHER_LAYER:String = "OtherLayer";
      
      private var _mapWidth:Number;
      
      private var _mapHeight:Number;
      
      private var _gridSize:uint;
      
      private var _gridX:uint;
      
      private var _gridY:uint;
      
      private var _gridTotal:uint;
      
      private var _mapArr:Array;
      
      private var _mapArrBack:Array;
      
      private var _mapLevel:MapLevel;
      
      public function MapModelLogic(mapMC:MovieClip, Size:uint = 8)
      {
         super();
         _inst = this;
         this._mapLevel = new MapLevel(mapMC);
         this._gridSize = Size;
         var actionButtonLever:MapButtonView = MapButtonView.getTarget();
         mapFrame.addChild(actionButtonLever);
         if(Boolean(this._mapLevel.bgLevel))
         {
            this._mapWidth = int(this._mapLevel.bgLevel.width);
            this._mapHeight = int(this._mapLevel.bgLevel.height);
         }
         else
         {
            this._mapWidth = LevelManager.WIDTH;
            this._mapHeight = LevelManager.HEIGHT;
         }
         this._gridX = int(this._mapWidth / this._gridSize);
         this._gridY = int(this._mapHeight / this._gridSize);
         this._gridTotal = this._gridX * this._gridX;
      }
      
      public static function changeLayer(InstanceMC:PeopleManageView, LayerObj:*) : String
      {
         var TempMC:MovieClip = null;
         var tempObj:Object = null;
         var i:uint = 0;
         var returnStr:String = OTHER_LAYER;
         var tempPList:Array = PeopleCountLogic[InstanceMC.layer + "PList"];
         if(Boolean(PeopleCountLogic[InstanceMC.layer + "PList"]))
         {
            for(i = 0; i < tempPList.length; i++)
            {
               if(tempPList[i].Instance == InstanceMC)
               {
                  tempObj = tempPList.splice(i,1)[0];
                  break;
               }
            }
         }
         if(LayerObj is MovieClip)
         {
            TempMC = LayerObj;
            if(TempMC == ManageLever)
            {
               returnStr = FLOOR_LAYER;
               ManageLever.addChild(InstanceMC);
            }
            else if(TempMC == TopLever)
            {
               returnStr = AIR_LAYER;
               TopLever.addChild(InstanceMC);
            }
            else
            {
               TempMC.addChild(InstanceMC);
            }
         }
         else if(LayerObj is String)
         {
            if(LayerObj == FLOOR_LAYER)
            {
               returnStr = FLOOR_LAYER;
               TempMC = ManageLever;
               if(Boolean(ManageLever) && Boolean(InstanceMC))
               {
                  ManageLever.addChild(InstanceMC);
               }
            }
            else
            {
               if(LayerObj != AIR_LAYER)
               {
                  throw new Error("參數錯誤:" + LayerObj);
               }
               returnStr = AIR_LAYER;
               TempMC = TopLever;
               TopLever.addChild(InstanceMC);
            }
         }
         InstanceMC.layer = returnStr;
         if(Boolean(PeopleCountLogic[InstanceMC.layer + "PList"]))
         {
            PeopleCountLogic[InstanceMC.layer + "PList"].push(tempObj);
         }
         MapDepthManageLogic.setPeopleDepth(InstanceMC);
         return returnStr;
      }
      
      public static function drawbox(obj:* = null, __x:uint = 0, __y:uint = 0, c:* = null, m:* = null, ___text:String = "") : void
      {
         var aa:TextField = null;
         with(obj.graphics)
         {
            lineStyle(1,7829367);
            beginFill(c,0.5);
            drawRect(__x,__y,GridSize,GridSize);
            endFill();
         }
         if(Boolean(m))
         {
            aa = new TextField();
            aa.text = ___text;
            aa.selectable = false;
            aa.x = __x;
            aa.y = __y;
            obj.addChild(aa);
         }
      }
      
      public static function get mapFrame() : MovieClip
      {
         return _inst.mapLevel.map_mc;
      }
      
      public static function get MapWhidth() : Number
      {
         return _inst.mapWidth;
      }
      
      public static function get MapHeight() : Number
      {
         return _inst.mapHeight;
      }
      
      public static function get GridSize() : uint
      {
         return _inst.gridSize;
      }
      
      public static function get GridX() : uint
      {
         return _inst.gridX;
      }
      
      public static function get GridY() : uint
      {
         return _inst.gridY;
      }
      
      public static function get GridTotal() : uint
      {
         return _inst.gridTotal;
      }
      
      public static function get MapArray() : Array
      {
         return _inst.mapArr;
      }
      
      public static function get MapArrayBAK() : Array
      {
         return _inst.mapArrBack;
      }
      
      public static function get ManageLever() : MovieClip
      {
         return _inst.depthLevel;
      }
      
      public static function get FrameLever() : MovieClip
      {
         return _inst.bgLevel;
      }
      
      public static function get TypeLever() : MovieClip
      {
         return _inst.typeLevel;
      }
      
      public static function get TopLever() : MovieClip
      {
         return _inst.topLevel;
      }
      
      public static function get owner() : MapModelLogic
      {
         return _inst;
      }
      
      public function clone(element:*, index:int, arr:Array) : Array
      {
         return element.slice();
      }
      
      public function makeMapArray(b:Boolean = false, height:int = 560) : void
      {
         var offsetSize:uint = 0;
         if(!b && height > 560)
         {
            dispatchEvent(new Event(Event.COMPLETE));
            return;
         }
         this._mapHeight = height;
         this._gridY = int(this._mapHeight / this._gridSize);
         var i:uint = 0;
         var j:uint = 0;
         this._mapArr = new Array(this._gridX);
         this._mapArrBack = new Array(this._gridX);
         offsetSize = uint(int(this._gridSize / 2));
         for(i = 0; i < this._gridX; i++)
         {
            this._mapArr[i] = new Array(this._gridY);
            this._mapArrBack[i] = new Array(this._gridY);
            for(j = 0; j < this._gridY; j++)
            {
               if(TypeLever.hitTestPoint(i * this._gridSize + offsetSize,j * this._gridSize + offsetSize,true))
               {
                  this._mapArr[i][j] = 0;
                  this._mapArrBack[i][j] = 0;
               }
               else
               {
                  this._mapArr[i][j] = 1;
                  this._mapArrBack[i][j] = 1;
               }
            }
         }
         if(!b)
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
         else
         {
            GV.FindPath.createMapModel(this);
         }
      }
      
      public function get mapWidth() : Number
      {
         return this._mapWidth;
      }
      
      public function get mapHeight() : Number
      {
         return this._mapHeight;
      }
      
      public function get gridSize() : uint
      {
         return this._gridSize;
      }
      
      public function get gridX() : uint
      {
         return this._gridX;
      }
      
      public function get gridY() : uint
      {
         return this._gridY;
      }
      
      public function get gridTotal() : uint
      {
         return this._gridTotal;
      }
      
      public function get mapArr() : Array
      {
         return this._mapArr;
      }
      
      public function get mapArrBack() : Array
      {
         return this._mapArrBack;
      }
      
      public function get depthLevel() : MovieClip
      {
         return this._mapLevel.depthLevel;
      }
      
      public function get bgLevel() : MovieClip
      {
         return this._mapLevel.bgLevel;
      }
      
      public function get typeLevel() : MovieClip
      {
         return this._mapLevel.moveLevel;
      }
      
      public function get topLevel() : MovieClip
      {
         return this._mapLevel.topLevel;
      }
      
      public function get mapLevel() : MapLevel
      {
         return this._mapLevel;
      }
      
      public function destroy() : void
      {
         this._mapLevel.destroy();
         _inst = null;
      }
   }
}

