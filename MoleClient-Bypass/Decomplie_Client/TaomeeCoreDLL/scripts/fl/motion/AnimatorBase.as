package fl.motion
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   [Event(name="timeChange",type="fl.motion.MotionEvent")]
   [Event(name="motionUpdate",type="fl.motion.MotionEvent")]
   [Event(name="motionStart",type="fl.motion.MotionEvent")]
   [Event(name="motionEnd",type="fl.motion.MotionEvent")]
   [DefaultProperty("motion")]
   public class AnimatorBase extends EventDispatcher
   {
      
      private static var enterFrameBeacon:MovieClip = new MovieClip();
      
      private var _motion:MotionBase;
      
      private var _motionArray:Array;
      
      protected var _lastMotionUsed:MotionBase;
      
      protected var _lastColorTransformApplied:ColorTransform;
      
      protected var _filtersApplied:Boolean;
      
      protected var _lastBlendModeApplied:String;
      
      protected var _cacheAsBitmapHasBeenApplied:Boolean;
      
      protected var _lastCacheAsBitmapApplied:Boolean;
      
      protected var _lastMatrixApplied:Matrix;
      
      protected var _lastMatrix3DApplied:Object;
      
      protected var _toRemove:Array;
      
      protected var _lastFrameHandled:int;
      
      protected var _lastSceneHandled:String;
      
      protected var _registeredParent:Boolean;
      
      public var orientToPath:Boolean = false;
      
      public var transformationPoint:Point;
      
      public var transformationPointZ:int;
      
      public var autoRewind:Boolean = false;
      
      public var positionMatrix:Matrix;
      
      public var repeatCount:int = 1;
      
      private var _isPlaying:Boolean = false;
      
      protected var _target:DisplayObject;
      
      protected var _lastTarget:DisplayObject;
      
      private var _lastRenderedTime:int = -1;
      
      private var _lastRenderedMotion:MotionBase = null;
      
      private var _time:int = -1;
      
      private var _targetParent:DisplayObjectContainer = null;
      
      private var _targetParentBtn:SimpleButton = null;
      
      private var _targetName:String = "";
      
      private var targetStateOriginal:Object = null;
      
      private var _placeholderName:String = null;
      
      private var _instanceFactoryClass:Class = null;
      
      private var instanceFactory:Object = null;
      
      private var _useCurrentFrame:Boolean = false;
      
      private var _spanStart:int = -1;
      
      private var _spanEnd:int = -1;
      
      private var _sceneName:String = "";
      
      private var _frameEvent:String = "enterFrame";
      
      private var _targetState3D:Array = null;
      
      protected var _isAnimator3D:Boolean;
      
      private var playCount:int = 0;
      
      protected var targetState:Object;
      
      public function AnimatorBase(xml:XML = null, target:DisplayObject = null)
      {
         super();
         this.target = target;
         this._isAnimator3D = false;
         this.transformationPoint = new Point(0.5,0.5);
         this.transformationPointZ = 0;
         this._sceneName = "";
         this._toRemove = new Array();
         this._lastFrameHandled = -1;
         this._lastSceneHandled = null;
         this._registeredParent = false;
      }
      
      protected static function colorTransformsEqual(a:ColorTransform, b:ColorTransform) : Boolean
      {
         return a.alphaMultiplier == b.alphaMultiplier && a.alphaOffset == b.alphaOffset && a.blueMultiplier == b.blueMultiplier && a.blueOffset == b.blueOffset && a.greenMultiplier == b.greenMultiplier && a.greenOffset == b.greenOffset && a.redMultiplier == b.redMultiplier && a.redOffset == b.redOffset;
      }
      
      public static function registerParentFrameHandler(parent:MovieClip, anim:AnimatorBase, spanStart:int, repeatCount:int = 0, useCurrentFrame:Boolean = false) : void
      {
         anim._registeredParent = true;
         if(spanStart == -1)
         {
            spanStart = parent.currentFrame - 1;
         }
         if(useCurrentFrame)
         {
            anim.useCurrentFrame(true,spanStart);
         }
         else
         {
            anim.repeatCount = repeatCount;
         }
      }
      
      public static function processCurrentFrame(parent:MovieClip, anim:AnimatorBase, startEnterFrame:Boolean, playOnly:Boolean = false) : void
      {
         var curFrame:int = 0;
         var curRelativeFrame:int = 0;
         if(Boolean(anim) && Boolean(parent))
         {
            if(anim.usingCurrentFrame)
            {
               curFrame = parent.currentFrame - 1;
               if(parent.scenes.length > 1)
               {
                  if(parent.currentScene.name != anim.sceneName)
                  {
                     curFrame = -1;
                  }
               }
               if(curFrame >= anim.spanStart && curFrame <= anim.spanEnd)
               {
                  curRelativeFrame = Boolean(anim.motionArray) ? curFrame : int(curFrame - anim.spanStart);
                  if(!anim.isPlaying)
                  {
                     anim.play(curRelativeFrame,startEnterFrame);
                  }
                  else if(!playOnly)
                  {
                     if(curFrame == anim.spanEnd)
                     {
                        anim.handleLastFrame(true,false);
                     }
                     else
                     {
                        anim.time = curRelativeFrame;
                     }
                  }
               }
               else if(anim.isPlaying && !playOnly)
               {
                  anim.end(true,false,true);
               }
               else if(!anim.isPlaying && playOnly)
               {
                  anim.startFrameEvents();
               }
            }
            else if(Boolean(anim.targetParent) && (anim.targetParent.hasOwnProperty(anim.targetName) && anim.targetParent[anim.targetName] == null || anim.targetParent.getChildByName(anim.targetName) == null))
            {
               if(anim.isPlaying)
               {
                  anim.end(true,false);
               }
               else if(playOnly)
               {
                  anim.startFrameEvents();
               }
            }
            else if(!anim.isPlaying)
            {
               if(playOnly)
               {
                  anim.play(0,startEnterFrame);
               }
            }
            else if(!playOnly)
            {
               anim.nextFrame(false,false);
            }
         }
      }
      
      public static function registerButtonState(targetParentBtn:SimpleButton, anim:AnimatorBase, stateFrame:int, zIndex:int = -1, targetName:String = null, placeholderName:String = null, instanceFactoryClass:Class = null) : void
      {
         var newTarget:DisplayObject = null;
         var container:DisplayObjectContainer = null;
         var target:DisplayObject = targetParentBtn.upState;
         switch(stateFrame)
         {
            case 1:
               target = targetParentBtn.overState;
               break;
            case 2:
               target = targetParentBtn.downState;
               break;
            case 3:
               target = targetParentBtn.hitTestState;
         }
         if(!target)
         {
            return;
         }
         if(zIndex >= 0)
         {
            try
            {
               container = DisplayObjectContainer(target);
               newTarget = container.getChildAt(zIndex);
            }
            catch(e:Error)
            {
               newTarget = null;
            }
            if(newTarget != null)
            {
               target = newTarget;
            }
         }
         anim.target = target;
         if(placeholderName != null && instanceFactoryClass != null)
         {
            anim.targetParentButton = targetParentBtn;
            anim.targetName = targetName;
            anim.instanceFactoryClass = instanceFactoryClass;
            anim.useCurrentFrame(true,stateFrame);
            anim.target.addEventListener(anim.frameEvent,anim.placeholderButtonEnterFrameHandler,false,0,true);
            anim.placeholderButtonEnterFrameHandler(null);
         }
         else
         {
            anim.time = 0;
         }
      }
      
      public static function registerSpriteParent(targetParentSprite:Sprite, anim:AnimatorBase, targetName:String, placeholderName:String = null, instanceFactoryClass:Class = null) : void
      {
         var newTarget:DisplayObject = null;
         if(targetParentSprite == null || anim == null || targetName == null)
         {
            return;
         }
         if(placeholderName != null && instanceFactoryClass != null)
         {
            newTarget = targetParentSprite[placeholderName];
            if(newTarget == null)
            {
               newTarget = targetParentSprite.getChildByName(placeholderName);
            }
            anim.target = newTarget;
            anim.targetParent = targetParentSprite;
            anim.targetName = targetName;
            anim.placeholderName = placeholderName;
            anim.instanceFactoryClass = instanceFactoryClass;
            anim.useCurrentFrame(true,0);
            anim.target.addEventListener(anim.frameEvent,anim.placeholderSpriteEnterFrameHandler,false,0,true);
            anim.placeholderSpriteEnterFrameHandler(null);
         }
         else
         {
            newTarget = targetParentSprite[targetName];
            if(newTarget == null)
            {
               newTarget = targetParentSprite.getChildByName(targetName);
            }
            anim.target = newTarget;
            anim.time = 0;
         }
      }
      
      public function get motion() : MotionBase
      {
         return this._motion;
      }
      
      public function set motion(value:MotionBase) : void
      {
         this._motion = value;
         if(Boolean(value))
         {
            if(Boolean(this.motionArray))
            {
               this._spanStart = this._spanEnd = -1;
            }
            this.motionArray = null;
         }
      }
      
      public function get motionArray() : Array
      {
         return this._motionArray;
      }
      
      public function set motionArray(value:Array) : void
      {
         var i:int = 0;
         this._motionArray = Boolean(value) && value.length > 0 ? value : null;
         if(Boolean(this._motionArray))
         {
            this.motion = null;
            this._spanStart = this._motionArray[0].motion_internal::spanStart;
            this._spanEnd = this._spanStart - 1;
            for(i = 0; i < this._motionArray.length; i++)
            {
               this._spanEnd += this._motionArray[i].duration;
            }
         }
      }
      
      public function get isPlaying() : Boolean
      {
         return this._isPlaying;
      }
      
      public function get target() : DisplayObject
      {
         return this._target;
      }
      
      public function set target(value:DisplayObject) : void
      {
         if(!value)
         {
            return;
         }
         this._target = value;
         if(value != this._lastTarget)
         {
            this._lastColorTransformApplied = null;
            this._filtersApplied = false;
            this._lastBlendModeApplied = null;
            this._cacheAsBitmapHasBeenApplied = false;
            this._lastMatrixApplied = null;
            this._lastMatrix3DApplied = null;
            this._toRemove = new Array();
         }
         this._lastTarget = value;
         var setTargetStateOriginal:Boolean = false;
         if(Boolean(this.targetParent) && this.targetName != "")
         {
            if(Boolean(this.targetStateOriginal))
            {
               this.targetState = this.targetStateOriginal;
               return;
            }
            setTargetStateOriginal = true;
         }
         this.targetState = {};
         this.setTargetState();
         if(setTargetStateOriginal)
         {
            this.targetStateOriginal = this.targetState;
         }
      }
      
      protected function setTargetState() : void
      {
      }
      
      public function set initialPosition(initPos:Array) : void
      {
      }
      
      public function get time() : int
      {
         return this._time;
      }
      
      public function set time(newTime:int) : void
      {
         var thisMotionArray:Array = null;
         var placeHolder:DisplayObject = null;
         var i:int = 0;
         var colorTransform:ColorTransform = null;
         var filters:Array = null;
         if(newTime == this._time)
         {
            return;
         }
         if(Boolean(this._placeholderName))
         {
            placeHolder = this._targetParent[this._placeholderName];
            if(!placeHolder)
            {
               placeHolder = this._targetParent.getChildByName(this._placeholderName);
            }
            if(Boolean(placeHolder) && Boolean(placeHolder.parent == this._targetParent) && this._target.parent == this._targetParent)
            {
               this._targetParent.addChildAt(this._target,this._targetParent.getChildIndex(placeHolder) + 1);
            }
         }
         var thisMotion:MotionBase = this.motion;
         if(Boolean(thisMotion))
         {
            if(newTime > thisMotion.duration - 1)
            {
               newTime = thisMotion.duration - 1;
            }
            else if(newTime < 0)
            {
               newTime = 0;
            }
            this._time = newTime;
         }
         else
         {
            thisMotionArray = this.motionArray;
            if(newTime <= this._spanStart)
            {
               thisMotion = thisMotionArray[0];
               newTime = this._spanStart;
            }
            else if(newTime >= this._spanEnd)
            {
               thisMotion = thisMotionArray[thisMotionArray.length - 1];
               newTime = this._spanEnd;
            }
            else
            {
               for(i = 0; i < thisMotionArray.length; i++)
               {
                  thisMotion = thisMotionArray[i];
                  if(newTime <= thisMotion.motion_internal::spanStart + thisMotion.duration - 1)
                  {
                     break;
                  }
               }
            }
            this._time = newTime;
            newTime -= thisMotion.motion_internal::spanStart;
         }
         this.dispatchEvent(new MotionEvent(MotionEvent.TIME_CHANGE));
         var curKeyframe:KeyframeBase = thisMotion.getCurrentKeyframe(newTime);
         var isHoldKeyframe:Boolean = curKeyframe.index == this._lastRenderedTime && (!thisMotionArray || this._lastRenderedMotion == thisMotion) && !curKeyframe.tweensLength;
         if(isHoldKeyframe)
         {
            return;
         }
         if(curKeyframe.blank)
         {
            this._target.visible = false;
         }
         else
         {
            if(this._isAnimator3D)
            {
               this._lastMatrixApplied = null;
               this.setTime3D(newTime,thisMotion);
            }
            else
            {
               this._lastMatrix3DApplied = null;
               this.setTimeClassic(newTime,thisMotion,curKeyframe);
            }
            colorTransform = thisMotion.getColorTransform(newTime);
            if(Boolean(thisMotionArray))
            {
               if(!colorTransform && Boolean(this._lastColorTransformApplied))
               {
                  colorTransform = new ColorTransform();
               }
               if(Boolean(colorTransform) && (!this._lastColorTransformApplied || !colorTransformsEqual(colorTransform,this._lastColorTransformApplied)))
               {
                  this._target.transform.colorTransform = colorTransform;
                  this._lastColorTransformApplied = colorTransform;
               }
            }
            else if(Boolean(colorTransform))
            {
               this._target.transform.colorTransform = colorTransform;
            }
            filters = thisMotion.getFilters(newTime);
            if(Boolean(thisMotionArray) && Boolean(!filters) && this._filtersApplied)
            {
               this._target.filters = null;
               this._filtersApplied = false;
            }
            else if(Boolean(filters))
            {
               this._target.filters = filters;
               this._filtersApplied = true;
            }
            if(!thisMotionArray || this._lastBlendModeApplied != curKeyframe.blendMode)
            {
               this._target.blendMode = curKeyframe.blendMode;
               this._lastBlendModeApplied = curKeyframe.blendMode;
            }
         }
         this._lastRenderedTime = newTime;
         this._lastRenderedMotion = thisMotion;
         this.dispatchEvent(new MotionEvent(MotionEvent.MOTION_UPDATE));
      }
      
      protected function setTime3D(newTime:int, thisMotion:MotionBase) : Boolean
      {
         return false;
      }
      
      protected function setTimeClassic(newTime:int, thisMotion:MotionBase, curKeyframe:KeyframeBase) : Boolean
      {
         return false;
      }
      
      public function get targetParent() : DisplayObjectContainer
      {
         return this._targetParent;
      }
      
      public function set targetParent(p:DisplayObjectContainer) : void
      {
         this._targetParent = p;
      }
      
      public function get targetParentButton() : SimpleButton
      {
         return this._targetParentBtn;
      }
      
      public function set targetParentButton(p:SimpleButton) : void
      {
         this._targetParentBtn = p;
      }
      
      public function get targetName() : String
      {
         return this._targetName;
      }
      
      public function set targetName(n:String) : void
      {
         this._targetName = n;
      }
      
      public function get placeholderName() : String
      {
         return this._placeholderName;
      }
      
      public function set placeholderName(n:String) : void
      {
         this._placeholderName = n;
      }
      
      public function get instanceFactoryClass() : Class
      {
         return this._instanceFactoryClass;
      }
      
      public function set instanceFactoryClass(f:Class) : void
      {
         if(f == this._instanceFactoryClass)
         {
            return;
         }
         this._instanceFactoryClass = f;
         try
         {
            this.instanceFactory = this._instanceFactoryClass["getSingleton"]();
         }
         catch(e:Error)
         {
            instanceFactory = null;
         }
      }
      
      public function useCurrentFrame(enable:Boolean, spanStart:int) : void
      {
         this._useCurrentFrame = enable;
         if(!this.motionArray)
         {
            this._spanStart = spanStart;
         }
      }
      
      public function get usingCurrentFrame() : Boolean
      {
         return this._useCurrentFrame;
      }
      
      public function get spanStart() : int
      {
         return this._spanStart;
      }
      
      public function get spanEnd() : int
      {
         if(this._spanEnd >= 0)
         {
            return this._spanEnd;
         }
         if(Boolean(this._motion) && this._motion.duration > 0)
         {
            return this._spanStart + this._motion.duration - 1;
         }
         return this._spanStart;
      }
      
      public function get sceneName() : String
      {
         return this._sceneName;
      }
      
      public function set sceneName(name:String) : void
      {
         this._sceneName = name;
      }
      
      private function handleEnterFrame(evt:Event) : void
      {
         var parent:MovieClip = null;
         if(this._registeredParent)
         {
            parent = this._targetParent as MovieClip;
            if(parent == null)
            {
               return;
            }
            if(!this.usingCurrentFrame || parent.currentFrame != this._lastFrameHandled || parent.currentScene.name != this._lastSceneHandled || this.target == null && this.instanceFactoryClass != null)
            {
               processCurrentFrame(parent,this,false);
            }
            this.removeChildren();
            this._lastFrameHandled = parent.currentFrame;
            this._lastSceneHandled = parent.currentScene.name;
         }
         else
         {
            this.nextFrame();
         }
      }
      
      private function removeChildren() : void
      {
         var obj:Object = null;
         var mc:MovieClip = null;
         var i:int = 0;
         while(i < this._toRemove.length)
         {
            obj = this._toRemove[i];
            if(obj.target == this._target || obj.target.parent != this._targetParent)
            {
               this._toRemove.splice(i,1);
            }
            else
            {
               mc = MovieClip(this._targetParent);
               if(obj.currentFrame == mc.currentFrame && (mc.scenes.length <= 1 || obj.currentSceneName == mc.currentScene.name))
               {
                  i++;
               }
               else
               {
                  this.removeChildTarget(mc,obj.target,obj.target.name);
                  this._toRemove.splice(i,1);
               }
            }
         }
      }
      
      protected function removeChildTarget(parent:MovieClip, child:DisplayObject, childName:String) : void
      {
         parent.removeChild(child);
         if(parent.hasOwnProperty(childName) && parent[childName] == child)
         {
            parent[childName] = null;
         }
         this._lastColorTransformApplied = null;
         this._filtersApplied = false;
         this._lastBlendModeApplied = null;
         this._cacheAsBitmapHasBeenApplied = false;
         this._lastMatrixApplied = null;
         this._lastMatrix3DApplied = null;
      }
      
      public function get frameEvent() : String
      {
         return this._frameEvent;
      }
      
      public function set frameEvent(evt:String) : void
      {
         this._frameEvent = evt;
      }
      
      public function get targetState3D() : Array
      {
         return this._targetState3D;
      }
      
      public function set targetState3D(state:Array) : void
      {
         this._targetState3D = state;
      }
      
      public function nextFrame(reset:Boolean = false, stopEnterFrame:Boolean = true) : void
      {
         if(Boolean(this.motionArray) && Boolean(this.time >= this.spanEnd) || !this.motionArray && this.time >= this.motion.duration - 1)
         {
            this.handleLastFrame(reset,stopEnterFrame);
         }
         else
         {
            ++this.time;
         }
      }
      
      public function play(startTime:int = -1, startEnterFrame:Boolean = true) : void
      {
         var newTarget:DisplayObject = null;
         var newInstance:DisplayObject = null;
         var placeHolder:DisplayObject = null;
         if(!this._isPlaying)
         {
            if(Boolean(this._target == null) && Boolean(this._targetParent) && this._targetName != "")
            {
               newTarget = this._targetParent.hasOwnProperty(this._targetName) ? this._targetParent[this._targetName] : this._targetParent.getChildByName(this._targetName);
               if(this.instanceFactory == null || Boolean(this.instanceFactory["isTargetForFrame"](newTarget,startTime,this.sceneName)))
               {
                  this.target = newTarget;
               }
               if(!this.target)
               {
                  newTarget = this._targetParent.getChildByName(this._targetName);
                  if(this.instanceFactory == null || Boolean(this.instanceFactory["isTargetForFrame"](newTarget,startTime,this.sceneName)))
                  {
                     this.target = newTarget;
                  }
                  if(Boolean(!this.target) && Boolean(this._placeholderName) && Boolean(this.instanceFactory))
                  {
                     newInstance = this.instanceFactory["getInstance"](this._targetParent,this._targetName,startTime,this.sceneName);
                     if(Boolean(newInstance))
                     {
                        newInstance.name = this._targetName;
                        this._targetParent[this._targetName] = newInstance;
                        placeHolder = this._targetParent[this._placeholderName];
                        if(!placeHolder)
                        {
                           placeHolder = this._targetParent.getChildByName(this._placeholderName);
                        }
                        if(Boolean(placeHolder))
                        {
                           this._targetParent.addChildAt(newInstance,this._targetParent.getChildIndex(placeHolder) + 1);
                        }
                        else
                        {
                           this._targetParent.addChild(newInstance);
                        }
                        this.target = newInstance;
                     }
                  }
               }
            }
            if(startEnterFrame)
            {
               enterFrameBeacon.addEventListener(this.frameEvent,this.handleEnterFrame,false,0,true);
            }
            if(!this.target)
            {
               return;
            }
            this._isPlaying = true;
         }
         this.playCount = 0;
         if(startTime > -1)
         {
            this.time = startTime;
         }
         else
         {
            this.rewind();
         }
         this.dispatchEvent(new MotionEvent(MotionEvent.MOTION_START));
      }
      
      public function end(reset:Boolean = false, stopEnterFrame:Boolean = true, pastLastFrame:Boolean = false) : void
      {
         var mc:MovieClip = null;
         if(stopEnterFrame)
         {
            enterFrameBeacon.removeEventListener(this.frameEvent,this.handleEnterFrame);
         }
         this._isPlaying = false;
         this.playCount = 0;
         if(this.autoRewind)
         {
            this.rewind();
         }
         else if(Boolean(this.motion) && this.time != this.motion.duration - 1)
         {
            this.time = this.motion.duration - 1;
         }
         else if(Boolean(this.motionArray) && this.time != this._spanEnd)
         {
            this.time = this._spanEnd;
         }
         if(reset)
         {
            if(Boolean(this._targetParent) && this._targetName != "")
            {
               if(Boolean(this._target && this.instanceFactory) && Boolean(this._targetParent is MovieClip) && this._targetParent == this._target.parent)
               {
                  if(pastLastFrame)
                  {
                     this.removeChildTarget(MovieClip(this._targetParent),this._target,this._targetName);
                  }
                  else
                  {
                     mc = MovieClip(this._targetParent);
                     this._toRemove.push({
                        "target":this._target,
                        "currentFrame":mc.currentFrame,
                        "currentSceneName":mc.currentScene.name
                     });
                  }
               }
               this._target = null;
            }
            this._lastRenderedTime = -1;
            this._time = -1;
         }
         this.dispatchEvent(new MotionEvent(MotionEvent.MOTION_END));
      }
      
      public function stop() : void
      {
         enterFrameBeacon.removeEventListener(this.frameEvent,this.handleEnterFrame);
         this._isPlaying = false;
         this.playCount = 0;
         this.rewind();
         this.dispatchEvent(new MotionEvent(MotionEvent.MOTION_END));
      }
      
      public function pause() : void
      {
         enterFrameBeacon.removeEventListener(this.frameEvent,this.handleEnterFrame);
         this._isPlaying = false;
      }
      
      public function resume() : void
      {
         enterFrameBeacon.addEventListener(this.frameEvent,this.handleEnterFrame,false,0,true);
         this._isPlaying = true;
      }
      
      public function startFrameEvents() : void
      {
         enterFrameBeacon.addEventListener(this.frameEvent,this.handleEnterFrame,false,0,true);
      }
      
      public function rewind() : void
      {
         this.time = Boolean(this.motionArray) ? this._spanStart : 0;
      }
      
      private function placeholderButtonEnterFrameHandler(e:Event) : void
      {
         var theParent:DisplayObjectContainer = null;
         if(this._targetParentBtn == null || this.instanceFactory == null)
         {
            this._target.removeEventListener(this.frameEvent,this.placeholderButtonEnterFrameHandler);
            return;
         }
         var realTarget:DisplayObject = this.instanceFactory["getInstance"](this._targetParentBtn,this._targetName,this._spanStart);
         if(realTarget == null)
         {
            return;
         }
         this._target.removeEventListener(this.frameEvent,this.placeholderButtonEnterFrameHandler);
         if(this._target.parent == null || DisplayObject(this._target.parent) == this._targetParentBtn)
         {
            switch(this._spanStart)
            {
               case 1:
                  this._targetParentBtn.overState = realTarget;
                  break;
               case 2:
                  this._targetParentBtn.downState = realTarget;
                  break;
               case 3:
                  this._targetParentBtn.hitTestState = realTarget;
                  break;
               default:
                  this._targetParentBtn.upState = realTarget;
            }
         }
         else
         {
            theParent = this._target.parent as DisplayObjectContainer;
            if(theParent != null)
            {
               theParent.addChildAt(realTarget,theParent.getChildIndex(this._target) + 1);
               theParent.removeChild(this._target);
            }
         }
         this.target = realTarget;
         this.time = 0;
      }
      
      private function placeholderSpriteEnterFrameHandler(e:Event) : void
      {
         if(this._targetParent == null || this.instanceFactory == null)
         {
            this._target.removeEventListener(this.frameEvent,this.placeholderSpriteEnterFrameHandler);
            return;
         }
         var realTarget:DisplayObject = this.instanceFactory["getInstance"](this._targetParent,this._targetName,0);
         if(realTarget == null)
         {
            return;
         }
         realTarget.name = this._targetName;
         this._targetParent[this._targetName] = realTarget;
         this._target.removeEventListener(this.frameEvent,this.placeholderSpriteEnterFrameHandler);
         this._targetParent[this._placeholderName] = null;
         this._targetParent.addChildAt(realTarget,this._targetParent.getChildIndex(this._target) + 1);
         this._targetParent.removeChild(this._target);
         this.target = realTarget;
         this.time = 0;
      }
      
      private function handleLastFrame(reset:Boolean = false, stopEnterFrame:Boolean = true) : void
      {
         ++this.playCount;
         if(this.repeatCount == 0 || this.playCount < this.repeatCount)
         {
            this.rewind();
         }
         else
         {
            this.end(reset,stopEnterFrame,false);
         }
      }
   }
}

