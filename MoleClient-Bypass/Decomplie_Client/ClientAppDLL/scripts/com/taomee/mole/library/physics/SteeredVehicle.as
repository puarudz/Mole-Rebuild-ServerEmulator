package com.taomee.mole.library.physics
{
   import com.common.util.DisplayUtil;
   
   public class SteeredVehicle extends Vehicle
   {
      
      protected var _maxForce:Number = 1;
      
      private var _steeringForce:Vector2D;
      
      private var _arrivalThreshold:Number = 100;
      
      private var _wanderAngle:Number = 0;
      
      private var _wanderDistance:Number = 10;
      
      private var _wanderRadius:Number = 5;
      
      private var _wanderRange:Number = 1;
      
      private var _avoidDistance:Number = 300;
      
      private var _avoidBuffer:Number = 20;
      
      private var _pathIndex:int = 0;
      
      private var _pathThreshold:Number = 20;
      
      private var _inSightDist:Number = 200;
      
      private var _tooCloseDist:Number = 60;
      
      public function SteeredVehicle()
      {
         super();
         this._steeringForce = new Vector2D();
      }
      
      public function set maxForce(value:Number) : void
      {
         this._maxForce = value;
      }
      
      public function get maxForce() : Number
      {
         return this._maxForce;
      }
      
      public function set arriveThreshold(value:Number) : void
      {
         this._arrivalThreshold = value;
      }
      
      public function get arriveThreshold() : Number
      {
         return this._arrivalThreshold;
      }
      
      override public function update() : void
      {
         this._steeringForce.truncate(this._maxForce);
         this._steeringForce = this._steeringForce.divide(_mass);
         _velocity = _velocity.add(this._steeringForce);
         this._steeringForce = new Vector2D();
         super.update();
      }
      
      public function seek(target:Vector2D) : void
      {
         var desiredVelocity:Vector2D = target.subtract(_position);
         desiredVelocity.normalize();
         desiredVelocity = desiredVelocity.multiply(_maxSpeed);
         var force:Vector2D = desiredVelocity.subtract(_velocity);
         this._steeringForce = this._steeringForce.add(force);
      }
      
      public function flee(target:Vector2D) : void
      {
         var desiredVelocity:Vector2D = target.subtract(_position);
         desiredVelocity.normalize();
         desiredVelocity = desiredVelocity.multiply(_maxSpeed);
         var force:Vector2D = desiredVelocity.subtract(_velocity);
         this._steeringForce = this._steeringForce.subtract(force);
      }
      
      public function arrive(target:Vector2D) : void
      {
         var desiredVelocity:Vector2D = target.subtract(_position);
         desiredVelocity.normalize();
         var dist:Number = _position.dist(target);
         if(dist > this._arrivalThreshold)
         {
            desiredVelocity = desiredVelocity.multiply(_maxSpeed);
         }
         else
         {
            desiredVelocity = desiredVelocity.multiply(_maxSpeed * dist / this._arrivalThreshold);
         }
         var force:Vector2D = desiredVelocity.subtract(_velocity);
         this._steeringForce = this._steeringForce.add(force);
      }
      
      public function chase(target:Vehicle) : void
      {
         var lookAheadTime:Number = position.dist(target.position) / _maxSpeed;
         var predictedTarget:Vector2D = target.position.add(target.velocity.multiply(lookAheadTime));
         this.seek(predictedTarget);
      }
      
      public function pursue(target:Vehicle) : void
      {
         var lookAheadTime:Number = position.dist(target.position) / _maxSpeed;
         var predictedTarget:Vector2D = target.position.add(target.velocity.multiply(lookAheadTime));
         this.flee(predictedTarget);
      }
      
      public function wander() : void
      {
         var center:Vector2D = _velocity.clone().normalize().multiply(this._wanderDistance);
         var offset:Vector2D = new Vector2D();
         offset.length = this._wanderRadius;
         offset.angle = this._wanderAngle;
         this._wanderAngle += Math.random() * this._wanderRange - this._wanderRange * 0.5;
         var force:Vector2D = center.add(offset);
         this._steeringForce = this._steeringForce.add(force);
      }
      
      public function set wanderDistance(value:Number) : void
      {
         this._wanderDistance = value;
      }
      
      public function get wanderDistance() : Number
      {
         return this._wanderDistance;
      }
      
      public function set wanderRadius(value:Number) : void
      {
         this._wanderRadius = value;
      }
      
      public function get wanderRadius() : Number
      {
         return this._wanderRadius;
      }
      
      public function set wanderRange(value:Number) : void
      {
         this._wanderRange = value;
      }
      
      public function get wanderRange() : Number
      {
         return this._wanderRange;
      }
      
      public function avoid(barrierList:Array) : void
      {
         var barrier:SteeredBarrier = null;
         var heading:Vector2D = null;
         var difference:Vector2D = null;
         var dotProd:Number = NaN;
         var feeler:Vector2D = null;
         var projection:Vector2D = null;
         var dist:Number = NaN;
         var force:Vector2D = null;
         for(var i:uint = 0; i < barrierList.length; i++)
         {
            barrier = barrierList[i] as SteeredBarrier;
            heading = _velocity.clone().normalize();
            difference = barrier.position.subtract(_position);
            dotProd = difference.dotProd(heading);
            if(dotProd > 0)
            {
               feeler = heading.multiply(this._avoidDistance);
               projection = heading.multiply(dotProd);
               dist = projection.subtract(difference).length;
               if(dist < barrier.radius + this._avoidBuffer && projection.length < feeler.length)
               {
                  force = heading.multiply(_maxSpeed);
                  force.angle += difference.sign(_velocity) * Math.PI / 2;
                  force = force.multiply(1 - projection.length / feeler.length);
                  this._steeringForce = this._steeringForce.add(force);
                  _velocity = _velocity.multiply(projection.length / feeler.length);
               }
            }
         }
      }
      
      public function set pathIndex(value:int) : void
      {
         this._pathIndex = value;
      }
      
      public function get pathIndex() : int
      {
         return this._pathIndex;
      }
      
      public function set pathThreshold(value:Number) : void
      {
         this._pathThreshold = value;
      }
      
      public function get pathThreshold() : Number
      {
         return this._pathThreshold;
      }
      
      public function followPath(path:Array, loop:Boolean = false) : void
      {
         var wayPoint:Vector2D = path[this._pathIndex];
         if(wayPoint == null)
         {
            return;
         }
         if(_position.dist(wayPoint) < this._pathThreshold)
         {
            if(this._pathIndex >= path.length - 1)
            {
               if(loop)
               {
                  this._pathIndex = 0;
               }
            }
            else
            {
               ++this._pathIndex;
            }
         }
         if(this._pathIndex >= path.length - 1 && !loop)
         {
            this.arrive(wayPoint);
         }
         else
         {
            this.seek(wayPoint);
         }
      }
      
      public function set inSightDist(value:Number) : void
      {
         this._inSightDist = value;
      }
      
      public function get inSightDist() : Number
      {
         return this._inSightDist;
      }
      
      public function set tooCloseDist(value:Number) : void
      {
         this._tooCloseDist = value;
      }
      
      public function get tooCloseDist() : Number
      {
         return this._tooCloseDist;
      }
      
      public function isSight(vehicle:Vehicle) : Boolean
      {
         if(_position.dist(vehicle.position) > this._inSightDist)
         {
            return false;
         }
         var heading:Vector2D = _velocity.clone().normalize();
         var difference:Vector2D = vehicle.position.subtract(_position);
         var dotProd:Number = difference.dotProd(heading);
         if(dotProd < 0)
         {
            return false;
         }
         return true;
      }
      
      public function tooClose(vehicle:Vehicle) : Boolean
      {
         return _position.dist(vehicle.position) < this._tooCloseDist;
      }
      
      public function flock(vehicles:Array) : void
      {
         var vehicle:Vehicle = null;
         var averageVelocity:Vector2D = _velocity.clone();
         var averagePosition:Vector2D = new Vector2D();
         var inSightCount:int = 0;
         for(var i:uint = 0; i < vehicles.length; i++)
         {
            vehicle = vehicles[i] as Vehicle;
            if(vehicle != this && this.isSight(vehicle))
            {
               averageVelocity = averageVelocity.add(vehicle.velocity);
               averagePosition = averagePosition.add(vehicle.position);
               if(this.tooClose(vehicle))
               {
                  this.flee(vehicle.position);
               }
               inSightCount++;
            }
         }
         if(inSightCount > 0)
         {
            averageVelocity = averageVelocity.divide(inSightCount);
            averagePosition = averagePosition.divide(inSightCount);
            this.seek(averagePosition);
            this._steeringForce.add(averageVelocity.subtract(_velocity));
         }
      }
      
      public function destroy() : void
      {
         DisplayUtil.removeForParent(this);
      }
   }
}

