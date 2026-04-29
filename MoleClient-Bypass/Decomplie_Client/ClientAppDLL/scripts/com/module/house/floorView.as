package com.module.house
{
   import com.event.EventTaomee;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class floorView extends MovieClip
   {
      
      public var houseMap:Array;
      
      private var floorMC:MovieClip;
      
      private var lineMC:MovieClip;
      
      private var floorBGMC:MovieClip;
      
      private var posArr:Array = [];
      
      private var workMode:Boolean = false;
      
      private var workMap:Boolean = false;
      
      private var editMode:Boolean;
      
      private var angle_x1:Class;
      
      private var angle_x2:Class;
      
      private var angle_x3:Class;
      
      private var angle_x4:Class;
      
      private var line1:Class;
      
      private var line2:Class;
      
      private var line3:Class;
      
      private var line4:Class;
      
      private var line5:Class;
      
      private var line6:Class;
      
      private var line7:Class;
      
      private var line8:Class;
      
      private var noside1:Class;
      
      private var noside2:Class;
      
      private var noside3:Class;
      
      private var noside4:Class;
      
      private var ball:Class;
      
      private var ARR:Array = [-1,-1,-1,0,-1,1,0,-1,0,1,1,-1,1,0,1,1];
      
      public function floorView(loadObj:Loader, arr:Array, floormc:MovieClip, linemc:MovieClip, floorbg:MovieClip)
      {
         super();
         this.angle_x1 = loadObj.contentLoaderInfo.applicationDomain.getDefinition("angle_x1") as Class;
         this.angle_x2 = loadObj.contentLoaderInfo.applicationDomain.getDefinition("angle_x2") as Class;
         this.angle_x3 = loadObj.contentLoaderInfo.applicationDomain.getDefinition("angle_x3") as Class;
         this.angle_x4 = loadObj.contentLoaderInfo.applicationDomain.getDefinition("angle_x4") as Class;
         this.line1 = loadObj.contentLoaderInfo.applicationDomain.getDefinition("line1") as Class;
         this.line2 = loadObj.contentLoaderInfo.applicationDomain.getDefinition("line2") as Class;
         this.line3 = loadObj.contentLoaderInfo.applicationDomain.getDefinition("line3") as Class;
         this.line4 = loadObj.contentLoaderInfo.applicationDomain.getDefinition("line4") as Class;
         this.line5 = loadObj.contentLoaderInfo.applicationDomain.getDefinition("line5") as Class;
         this.line6 = loadObj.contentLoaderInfo.applicationDomain.getDefinition("line6") as Class;
         this.line7 = loadObj.contentLoaderInfo.applicationDomain.getDefinition("line7") as Class;
         this.line8 = loadObj.contentLoaderInfo.applicationDomain.getDefinition("line8") as Class;
         this.noside1 = loadObj.contentLoaderInfo.applicationDomain.getDefinition("noside1") as Class;
         this.noside2 = loadObj.contentLoaderInfo.applicationDomain.getDefinition("noside2") as Class;
         this.noside3 = loadObj.contentLoaderInfo.applicationDomain.getDefinition("noside3") as Class;
         this.noside4 = loadObj.contentLoaderInfo.applicationDomain.getDefinition("noside4") as Class;
         this.ball = loadObj.contentLoaderInfo.applicationDomain.getDefinition("ball") as Class;
         this.houseMap = arr;
         this.floorMC = floormc;
         this.lineMC = linemc;
         this.floorBGMC = floorbg;
         this.init();
      }
      
      public function init() : void
      {
         this.showHouseMap();
         addEventListener("dispatchWork",this.changeWork);
         addEventListener("dispatchEditMode",this.changeEditMode);
         addEventListener("dispatchEditMap",this.changeEditMap);
         this.floorMC.parent.stage.addEventListener(MouseEvent.CLICK,this.getXY);
      }
      
      public function showHouseMap() : void
      {
         this.getHouseMap();
      }
      
      private function getXY(e:Event) : void
      {
         var j:int = 0;
         var i:int = 0;
         if(this.workMap)
         {
            j = int((e.target.stage.mouseX - 30.5) / 50);
            i = int((e.target.stage.mouseY - 121.5) / 50);
            this.changeMapArr(i,j);
         }
      }
      
      private function changeWork(e:EventTaomee) : void
      {
         this.workMode = e.EventObj.workmode;
      }
      
      private function changeEditMap(e:Event) : void
      {
         this.workMap = !this.workMap;
      }
      
      private function changeEditMode(e:EventTaomee) : void
      {
         this.editMode = e.EventObj.editmode;
         if(this.editMode)
         {
            this.floorMC.parent.stage.addEventListener(MouseEvent.CLICK,this.getXY);
         }
         else
         {
            this.floorMC.parent.stage.removeEventListener(MouseEvent.CLICK,this.getXY);
         }
      }
      
      private function changeMapArr(i:int, j:int) : void
      {
         if(this.workMode)
         {
         }
         if(i >= 0 && i < 8 && j >= 0 && j < 17)
         {
            if(!this.houseMap[i][j])
            {
               if(this.workMode)
               {
                  this.houseMap[i][j] = 1;
                  this.reLoadMap(i,j);
               }
            }
            else if(!this.workMode)
            {
               this.houseMap[i][j] = 0;
               this.reLoadMap(i,j);
            }
         }
      }
      
      private function reLoadMap(i:int, j:int) : void
      {
         while(Boolean(this.floorMC.numChildren))
         {
            this.floorMC.removeChildAt(0);
         }
         while(Boolean(this.lineMC.numChildren))
         {
            this.lineMC.removeChildAt(0);
         }
         this.getHouseMap();
      }
      
      private function getHouseMap() : void
      {
         var j:uint = 0;
         var temp:* = undefined;
         for(var i:uint = 0; i < 8; i++)
         {
            for(j = 0; j < 17; j++)
            {
               if(this.houseMap[i][j] == 1)
               {
                  temp = new this.ball();
                  this.floorMC.addChild(temp);
                  temp.x = j * 50;
                  temp.y = i * 50;
                  this.dir(i,j);
                  this.whichAngle(i,j);
               }
               else
               {
                  this.dir(i,j);
                  if(Boolean(this.posArr[1] & this.posArr[3]))
                  {
                     temp = new this.noside1();
                     this.addBall(temp,i,j);
                     temp = new this.angle_x1();
                     this.addoutLine(temp,i,j);
                  }
                  if(Boolean(this.posArr[1] & this.posArr[4]))
                  {
                     temp = new this.noside2();
                     this.addBall(temp,i,j);
                     temp = new this.angle_x2();
                     this.addoutLine(temp,i,j);
                  }
                  if(Boolean(this.posArr[3] & this.posArr[6]))
                  {
                     temp = new this.noside3();
                     this.addBall(temp,i,j);
                     temp = new this.angle_x3();
                     this.addoutLine(temp,i,j);
                  }
                  if(Boolean(this.posArr[4] & this.posArr[6]))
                  {
                     temp = new this.noside4();
                     this.addBall(temp,i,j);
                     temp = new this.angle_x4();
                     this.addoutLine(temp,i,j);
                  }
               }
            }
         }
         this.floorBGMC.mask = this.floorMC;
      }
      
      private function addBall(temp:DisplayObject, i:int, j:int) : void
      {
         this.floorMC.addChild(temp);
         temp.x = j * 50;
         temp.y = i * 50;
      }
      
      private function addoutLine(temp:DisplayObject, i:int, j:int) : void
      {
         this.lineMC.addChild(temp);
         temp.x = j * 50;
         temp.y = i * 50;
      }
      
      private function whichAngle(i:int, j:int) : void
      {
         var temp:* = undefined;
         if(Boolean(this.posArr[0]))
         {
            temp = new this.noside1();
            this.addBall(temp,i,j);
         }
         else if(Boolean(this.posArr[1]) && !this.posArr[3])
         {
            temp = new this.noside1();
            this.addBall(temp,i,j);
            temp = new this.line5();
            this.addoutLine(temp,i,j);
         }
         else if(!this.posArr[1] && Boolean(this.posArr[3]))
         {
            temp = new this.noside1();
            this.addBall(temp,i,j);
            temp = new this.line1();
            this.addoutLine(temp,i,j);
         }
         else if(Boolean(this.posArr[1]) && Boolean(this.posArr[3]))
         {
            temp = new this.noside1();
            this.addBall(temp,i,j);
         }
         else
         {
            temp = new this.angle_x1();
            this.addoutLine(temp,i,j);
         }
         if(Boolean(this.posArr[2]))
         {
            temp = new this.noside2();
            this.addBall(temp,i,j);
         }
         else if(Boolean(this.posArr[1]) && !this.posArr[4])
         {
            temp = new this.noside2();
            this.addBall(temp,i,j);
            temp = new this.line6();
            this.addoutLine(temp,i,j);
         }
         else if(!this.posArr[1] && Boolean(this.posArr[4]))
         {
            temp = new this.noside2();
            this.addBall(temp,i,j);
            temp = new this.line2();
            this.addoutLine(temp,i,j);
         }
         else if(Boolean(this.posArr[1]) && Boolean(this.posArr[4]))
         {
            temp = new this.noside2();
            this.addBall(temp,i,j);
         }
         else
         {
            temp = new this.angle_x2();
            this.addoutLine(temp,i,j);
         }
         if(Boolean(this.posArr[5]))
         {
            temp = new this.noside3();
            this.addBall(temp,i,j);
         }
         else if(Boolean(this.posArr[3]) && !this.posArr[6])
         {
            temp = new this.noside3();
            this.addBall(temp,i,j);
            temp = new this.line3();
            this.addoutLine(temp,i,j);
         }
         else if(!this.posArr[3] && Boolean(this.posArr[6]))
         {
            temp = new this.noside3();
            this.addBall(temp,i,j);
            temp = new this.line7();
            this.addoutLine(temp,i,j);
         }
         else if(Boolean(this.posArr[3]) && Boolean(this.posArr[6]))
         {
            temp = new this.noside3();
            this.addBall(temp,i,j);
         }
         else
         {
            temp = new this.angle_x3();
            this.addoutLine(temp,i,j);
         }
         if(Boolean(this.posArr[7]))
         {
            temp = new this.noside4();
            this.addBall(temp,i,j);
         }
         else if(Boolean(this.posArr[4]) && !this.posArr[6])
         {
            temp = new this.noside4();
            this.addBall(temp,i,j);
            temp = new this.line4();
            this.addoutLine(temp,i,j);
         }
         else if(!this.posArr[4] && Boolean(this.posArr[6]))
         {
            temp = new this.noside4();
            this.addBall(temp,i,j);
            temp = new this.line8();
            this.addoutLine(temp,i,j);
         }
         else if(Boolean(this.posArr[4]) && Boolean(this.posArr[6]))
         {
            temp = new this.noside4();
            this.addBall(temp,i,j);
         }
         else
         {
            temp = new this.angle_x4();
            this.addoutLine(temp,i,j);
         }
      }
      
      private function dir(a:int, b:int) : void
      {
         var i:uint;
         var j:int = 0;
         j = 0;
         for(i = 0; i < this.ARR.length; i += 2)
         {
            try
            {
               this.posArr[j] = this.houseMap[a + this.ARR[i]][b + this.ARR[i + 1]];
            }
            catch(err:Error)
            {
               posArr[j] = null;
            }
            j++;
         }
      }
   }
}

