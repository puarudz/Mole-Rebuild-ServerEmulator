package com.logic.active
{
   import com.common.util.MovieClipUtil;
   import com.core.info.LocalUserInfo;
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import com.logic.mapEvent.MapEvent;
   import com.module.throwThing.throwHitTest;
   import com.mole.app.utils.Tool;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.MouseEvent;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class TimeTravelActy
   {
      
      private static var _inst:TimeTravelActy;
      
      private var _s:Shape = new Shape();
      
      private var wood:MovieClip;
      
      private var woodState:int = 0;
      
      private var rattan:MovieClip;
      
      private var fly:MovieClip;
      
      private var torch:MovieClip;
      
      private var flower:MovieClip;
      
      private var bird:MovieClip;
      
      private var tempTimer:int;
      
      private var moss:MovieClip;
      
      private var mossState:int = 0;
      
      private var treeState:int = 0;
      
      private var leafState:int = 0;
      
      private var mapArr:Array = [351,352,353];
      
      private var tree:MovieClip;
      
      private var leaf:MovieClip;
      
      private var dogGrass:MovieClip;
      
      private var owl:MovieClip;
      
      private var bArr:Array;
      
      public function TimeTravelActy()
      {
         super();
      }
      
      public static function get inst() : TimeTravelActy
      {
         if(_inst == null)
         {
            _inst = new TimeTravelActy();
         }
         return _inst;
      }
      
      public function init() : void
      {
         BC.addEvent(this._s,GV.onlineSocket,MapEvent.CHANGE_MAP_COMPLETE,this.onEnterMap);
         BC.addEvent(this._s,GV.onlineSocket,MapEvent.READY_CHANGE_MAP,this.onLeaveMap);
      }
      
      private function onLeaveMap(e:EventTaomee) : void
      {
         this.destroy();
      }
      
      private function onEnterMap(e:EventTaomee) : void
      {
         this.bArr = [false,false,false,false,false];
         var mid:int = LocalUserInfo.getMapID();
         if(mid == 351)
         {
            this.initMap351();
         }
         else if(mid == 352)
         {
            this.initMap352();
         }
         else if(mid == 353)
         {
            this.initMap353();
         }
      }
      
      private function initMap353() : void
      {
         this.woodState = 0;
         this.wood = GV.MC_mapFrame["control_mc"].wood;
         this.rattan = GV.MC_mapFrame["control_mc"].rattan;
         this.wood.buttonMode = true;
         this.rattan.buttonMode = true;
         BC.addEvent(this,this.wood,MouseEvent.CLICK,this.clickWood);
         BC.addEvent(this,this.rattan,MouseEvent.CLICK,this.clickRattan);
      }
      
      private function clickRattan(e:MouseEvent) : void
      {
         BC.removeEvent(this,this.rattan,MouseEvent.CLICK,this.clickRattan);
         Tool.finishSomething(2100000368,function(doneTimes:int):void
         {
            if(doneTimes == 0)
            {
               rattan.gotoAndStop(2);
            }
            else
            {
               rattan.gotoAndStop(3);
               bArr[7] = true;
            }
            rattan.addEventListener(MouseEvent.CLICK,clickRattanPrize);
         });
      }
      
      private function clickRattanPrize(e:MouseEvent) : void
      {
         this.rattan.visible = false;
         this.rattan.removeEventListener(MouseEvent.CLICK,this.clickRattanPrize);
         if(Boolean(this.bArr[7]))
         {
            Tool.exchangeGoods(2973);
         }
         else
         {
            Tool.exchangeGoods(2972);
         }
      }
      
      private function clickWood(e:MouseEvent) : void
      {
         if(this.woodState == 0)
         {
            this.wood.gotoAndStop(2);
         }
         else if(this.woodState == 1)
         {
            this.wood.gotoAndStop(3);
         }
         else if(this.woodState == 3)
         {
            BC.removeEvent(this,this.wood,MouseEvent.CLICK,this.clickWood);
            Tool.finishSomething(2100000367,function(doneTimes:int):void
            {
               if(doneTimes == 0)
               {
                  wood.gotoAndStop(4);
               }
               else
               {
                  wood.gotoAndStop(5);
                  bArr[6] = true;
               }
               wood.addEventListener(MouseEvent.CLICK,clickWoodPrize);
            });
         }
         ++this.woodState;
      }
      
      private function clickWoodPrize(e:MouseEvent) : void
      {
         this.wood.gotoAndStop(1);
         this.wood.removeEventListener(MouseEvent.CLICK,this.clickWoodPrize);
         if(Boolean(this.bArr[6]))
         {
            Tool.exchangeGoods(2971);
         }
         else
         {
            Tool.exchangeGoods(2970);
         }
      }
      
      private function initMap352() : void
      {
         this.fly = GV.MC_mapFrame["control_mc"].fly;
         this.torch = GV.MC_mapFrame["control_mc"].torch;
         this.moss = GV.MC_mapFrame["control_mc"].moss;
         this.flower = GV.MC_mapFrame["depth_mc"].flower;
         this.bird = GV.MC_mapFrame["control_mc"].bird;
         this.torch.buttonMode = true;
         this.flower.buttonMode = true;
         BC.addEvent(this,this.torch,MouseEvent.MOUSE_DOWN,this.onTorchMouseDown);
         this.moss.buttonMode = true;
         this.moss.prize.visible = false;
         BC.addEvent(this,this.moss,MouseEvent.CLICK,this.onMossClick);
      }
      
      private function onMossClick(e:MouseEvent) : void
      {
         if(this.mossState < 3)
         {
            this.moss.gotoAndStop(this.mossState + 1);
            ++this.mossState;
         }
         if(this.mossState == 3)
         {
            this.moss.prize.visible = true;
            Tool.finishSomething(2100000366,function(doneTimes:int):void
            {
               if(doneTimes != 0)
               {
                  bArr[5] = true;
               }
               if(doneTimes == 1)
               {
                  moss.prize.gotoAndStop(2);
               }
               moss.addEventListener(MouseEvent.CLICK,clickMoss);
            });
         }
      }
      
      private function clickMoss(e:MouseEvent) : void
      {
         this.moss.prize.visible = false;
         this.moss.removeEventListener(MouseEvent.CLICK,this.clickMoss);
         if(Boolean(this.bArr[5]))
         {
            Tool.exchangeGoods(2969);
         }
         else
         {
            Tool.exchangeGoods(2968);
         }
      }
      
      private function onTorchMouseDown(e:MouseEvent) : void
      {
         GV.MC_mapFrame["depth_mc"].addChild(this.torch);
         BC.removeEvent(this,this.torch,MouseEvent.MOUSE_DOWN,this.onTorchMouseDown);
         BC.addEvent(this,LevelManager.stage,MouseEvent.MOUSE_MOVE,this.onTorchMove);
      }
      
      private function onTorchMove(e:MouseEvent) : void
      {
         this.torch.x = e.stageX;
         this.torch.y = e.stageY;
         if(Boolean(this.fly.hit) && Boolean(this.torch.hit.hitTestObject(this.fly.hit)))
         {
            this.torch.x = 442;
            this.torch.y = 377;
            BC.removeEvent(this,LevelManager.stage,MouseEvent.MOUSE_MOVE,this.onTorchMove);
            Tool.finishSomething(2100000364,function(doneTimes:int):void
            {
               if(doneTimes != 0)
               {
                  bArr[3] = true;
               }
               fly.gotoAndPlay(2);
               MovieClipUtil.addRegisterFrameEventFunc(fly,101,function():void
               {
                  var prize:MovieClip = fly.prize;
                  if(Boolean(prize))
                  {
                     if(doneTimes == 1)
                     {
                        prize.gotoAndStop(2);
                     }
                  }
               });
               fly.buttonMode = true;
               fly.addEventListener(MouseEvent.CLICK,clickFly);
            });
         }
         else if(Boolean(this.torch.hit.hitTestObject(this.flower.hit)))
         {
            this.torch.x = 442;
            this.torch.y = 377;
            GV.MC_mapFrame["control_mc"].addChild(this.torch);
            BC.addEvent(this,this.torch,MouseEvent.MOUSE_DOWN,this.onTorchMouseDown);
            BC.removeEvent(this,LevelManager.stage,MouseEvent.MOUSE_MOVE,this.onTorchMove);
            this.flower.gotoAndPlay(2);
            MovieClipUtil.playEndAndFunc(this.flower,function():void
            {
               flower.stop();
               bird.gotoAndStop(3);
               clearTimeout(tempTimer);
               tempTimer = setTimeout(tick,5000);
            });
         }
      }
      
      private function tick() : void
      {
         clearTimeout(this.tempTimer);
         Tool.finishSomething(2100000365,function(doneTimes:int):void
         {
            if(doneTimes != 0)
            {
               bArr[4] = true;
            }
            MovieClipUtil.playAppointFrameAndFunc(bird,4,function():void
            {
               var b:MovieClip = null;
               b = bird.bird;
               MovieClipUtil.addRegisterFrameEventFunc(b,37,function():void
               {
                  var prize:MovieClip = b.prize;
                  if(Boolean(prize))
                  {
                     if(doneTimes == 1)
                     {
                        prize.gotoAndStop(2);
                     }
                  }
               });
            });
            bird.buttonMode = true;
            bird.addEventListener(MouseEvent.CLICK,clickBiard);
         });
      }
      
      private function clickBiard(e:MouseEvent) : void
      {
         this.bird.visible = false;
         this.bird.removeEventListener(MouseEvent.CLICK,this.clickBiard);
         if(Boolean(this.bArr[4]))
         {
            Tool.exchangeGoods(2967);
         }
         else
         {
            Tool.exchangeGoods(2966);
         }
         GV.MC_mapFrame["control_mc"].addChild(this.torch);
         if(!this.bArr[3])
         {
            BC.addEvent(this,this.torch,MouseEvent.MOUSE_DOWN,this.onTorchMouseDown);
         }
      }
      
      private function clickFly(e:MouseEvent) : void
      {
         var prize:MovieClip = this.fly.prize;
         prize.visible = false;
         this.fly.removeEventListener(MouseEvent.CLICK,this.clickFly);
         if(Boolean(this.bArr[3]))
         {
            Tool.exchangeGoods(2965);
         }
         else
         {
            Tool.exchangeGoods(2964);
         }
         GV.MC_mapFrame["control_mc"].addChild(this.torch);
         if(!this.bArr[4])
         {
            BC.addEvent(this,this.torch,MouseEvent.MOUSE_DOWN,this.onTorchMouseDown);
         }
      }
      
      private function initMap351() : void
      {
         this.tree = GV.MC_mapFrame["control_mc"].tree;
         this.leaf = GV.MC_mapFrame["control_mc"].leaf;
         this.dogGrass = GV.MC_mapFrame["control_mc"].dogGrass;
         this.owl = GV.MC_mapFrame["top_mc"].owl;
         this.leaf.buttonMode = true;
         BC.addEvent(this,this.leaf,MouseEvent.CLICK,this.clickLeaf);
         this.dogGrass.mouseChildren = false;
         this.dogGrass.buttonMode = true;
         BC.addEvent(this,this.dogGrass,MouseEvent.MOUSE_DOWN,this.onMouseDown);
      }
      
      private function clickOwl(e:MouseEvent) : void
      {
         this.owl.removeEventListener(MouseEvent.CLICK,this.clickOwl);
         this.owl.visible = false;
         if(Boolean(this.bArr[2]))
         {
            Tool.exchangeGoods(2963);
         }
         else
         {
            Tool.exchangeGoods(2962);
         }
      }
      
      private function onMouseDown(e:MouseEvent) : void
      {
         BC.addEvent(this,LevelManager.stage,MouseEvent.MOUSE_MOVE,this.onStageMove);
      }
      
      private function onStageMove(e:MouseEvent) : void
      {
         this.dogGrass.x = e.stageX;
         this.dogGrass.y = e.stageY;
         if(this.dogGrass.hitTestObject(this.owl.hit))
         {
            this.dogGrass.x = 802;
            this.dogGrass.y = 251;
            BC.removeEvent(this,this.dogGrass,MouseEvent.MOUSE_DOWN,this.onMouseDown);
            BC.removeEvent(this,LevelManager.stage,MouseEvent.MOUSE_MOVE,this.onStageMove);
            Tool.finishSomething(2100000363,function(doneTimes:int):void
            {
               if(doneTimes == 0)
               {
                  owl.gotoAndStop(2);
               }
               else
               {
                  bArr[2] = true;
                  owl.gotoAndStop(3);
               }
               owl.buttonMode = true;
               owl.addEventListener(MouseEvent.CLICK,clickOwl);
            });
         }
      }
      
      private function clickLeaf(e:MouseEvent) : void
      {
         if(this.leafState < 10)
         {
            ++this.leafState;
            this.leaf.gotoAndStop(2);
         }
         if(this.leafState == 10)
         {
            BC.removeEvent(this,this.leaf,MouseEvent.CLICK,this.clickLeaf);
            Tool.finishSomething(2100000362,function(doneTimes:int):void
            {
               if(doneTimes == 0)
               {
                  leaf.gotoAndStop(3);
               }
               else
               {
                  bArr[1] = true;
                  leaf.gotoAndStop(4);
               }
               leaf.addEventListener(MouseEvent.CLICK,clickLeafPrize);
            });
         }
      }
      
      private function clickLeafPrize(e:MouseEvent) : void
      {
         this.leaf.removeEventListener(MouseEvent.CLICK,this.clickLeafPrize);
         this.leaf.gotoAndStop(1);
         this.leafState = 0;
         if(Boolean(this.bArr[1]))
         {
            Tool.exchangeGoods(2961);
         }
         else
         {
            Tool.exchangeGoods(2960);
         }
      }
      
      private function getHitTestInfo(e:EventTaomee) : void
      {
         if(e.EventObj.mc.userID == LocalUserInfo.getUserID())
         {
            if(this.treeState < 2)
            {
               ++this.treeState;
               this.tree.gotoAndStop(2);
            }
            if(this.treeState == 2)
            {
               BC.removeEvent(this,GV.onlineSocket,throwHitTest.HITTEST_SUC_FIRE,this.getHitTestInfo);
               Tool.finishSomething(2100000361,function(doneTimes:int):void
               {
                  if(doneTimes == 0)
                  {
                     tree.gotoAndStop(3);
                  }
                  else
                  {
                     bArr[0] = true;
                     tree.gotoAndStop(4);
                  }
                  tree.buttonMode = true;
                  tree.addEventListener(MouseEvent.CLICK,clickTree);
               });
            }
         }
      }
      
      private function clickTree(e:MouseEvent) : void
      {
         this.tree.buttonMode = false;
         this.tree.removeEventListener(MouseEvent.CLICK,this.clickTree);
         this.tree.gotoAndStop(5);
         this.treeState = 0;
         if(Boolean(this.bArr[0]))
         {
            Tool.exchangeGoods(2959);
         }
         else
         {
            Tool.exchangeGoods(2958);
         }
      }
      
      private function destroy() : void
      {
         this.treeState = 0;
         this.leafState = 0;
         this.woodState = 0;
         clearTimeout(this.tempTimer);
         BC.removeEvent(this);
      }
   }
}

