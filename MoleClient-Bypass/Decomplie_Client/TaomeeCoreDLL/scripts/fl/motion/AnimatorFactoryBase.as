package fl.motion
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   
   public class AnimatorFactoryBase
   {
      
      private var _motion:MotionBase;
      
      private var _motionArray:Array;
      
      private var _animators:Dictionary;
      
      protected var _transformationPoint:Point;
      
      protected var _transformationPointZ:int;
      
      protected var _is3D:Boolean;
      
      protected var _sceneName:String;
      
      public function AnimatorFactoryBase(motion:MotionBase, motionArray:Array = null)
      {
         super();
         this._motion = motion;
         this._motionArray = motionArray;
         this._animators = new Dictionary(true);
         this._transformationPoint = new Point(0.5,0.5);
         this._transformationPointZ = 0;
         this._is3D = false;
         this._sceneName = "";
      }
      
      public function get motion() : MotionBase
      {
         return this._motion;
      }
      
      public function addTarget(target:DisplayObject, repeatCount:int = 0, autoPlay:Boolean = true, startFrame:int = -1, useCurrentFrame:Boolean = false) : AnimatorBase
      {
         if(Boolean(target))
         {
            return this.addTargetInfo(target.parent,target.name,repeatCount,autoPlay,startFrame,useCurrentFrame);
         }
         return null;
      }
      
      protected function getNewAnimator() : AnimatorBase
      {
         return null;
      }
      
      public function addTargetInfo(targetParent:DisplayObject, targetName:String, repeatCount:int = 0, autoPlay:Boolean = true, startFrame:int = -1, useCurrentFrame:Boolean = false, initialPosition:Array = null, zIndex:int = -1, placeholderName:String = null, instanceFactoryClass:Class = null) : AnimatorBase
      {
         var eventClass:Class = null;
         if(!(targetParent is DisplayObjectContainer) && !(targetParent is SimpleButton))
         {
            return null;
         }
         var parentDictionary:Dictionary = this._animators[targetParent];
         if(!parentDictionary)
         {
            parentDictionary = new Dictionary();
            this._animators[targetParent] = parentDictionary;
         }
         var animator:AnimatorBase = parentDictionary[targetName];
         var createdAnim:Boolean = false;
         if(!animator)
         {
            animator = this.getNewAnimator();
            eventClass = getDefinitionByName("flash.events.Event") as Class;
            if(eventClass.hasOwnProperty("FRAME_CONSTRUCTED"))
            {
               animator.frameEvent = "frameConstructed";
            }
            parentDictionary[targetName] = animator;
            createdAnim = true;
         }
         animator.motion = this._motion;
         animator.motionArray = this._motionArray;
         animator.transformationPoint = this._transformationPoint;
         animator.transformationPointZ = this._transformationPointZ;
         animator.sceneName = this._sceneName;
         if(createdAnim)
         {
            if(targetParent is MovieClip)
            {
               AnimatorBase.registerParentFrameHandler(targetParent as MovieClip,animator,startFrame,repeatCount,useCurrentFrame);
            }
         }
         if(targetParent is MovieClip)
         {
            animator.targetParent = MovieClip(targetParent);
            animator.targetName = targetName;
            animator.placeholderName = placeholderName;
            animator.instanceFactoryClass = instanceFactoryClass;
         }
         else if(targetParent is SimpleButton)
         {
            AnimatorBase.registerButtonState(targetParent as SimpleButton,animator,startFrame,zIndex,targetName,placeholderName,instanceFactoryClass);
         }
         else if(targetParent is Sprite)
         {
            AnimatorBase.registerSpriteParent(targetParent as Sprite,animator,targetName,placeholderName,instanceFactoryClass);
         }
         if(Boolean(initialPosition))
         {
            animator.initialPosition = initialPosition;
         }
         if(autoPlay)
         {
            AnimatorBase.processCurrentFrame(targetParent as MovieClip,animator,true,true);
         }
         return animator;
      }
      
      public function set transformationPoint(p:Point) : void
      {
         this._transformationPoint = p;
      }
      
      public function set transformationPointZ(z:int) : void
      {
         this._transformationPointZ = z;
      }
      
      public function set sceneName(name:String) : void
      {
         this._sceneName = name;
      }
   }
}

