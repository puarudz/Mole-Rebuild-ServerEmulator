package com.module.digTreasure
{
   import com.module.digTreasure.data.DigTreasureData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public interface IDigTreasureItemCtl
   {
      
      function SetConfig(param1:XML, param2:int) : void;
      
      function Init(param1:DigTreasureViewCtl, param2:DigTreasureData) : void;
      
      function get ui() : Sprite;
      
      function get itemUI() : MovieClip;
      
      function get id() : int;
      
      function get index() : int;
      
      function get name() : String;
      
      function get x() : Number;
      
      function get y() : Number;
      
      function get canWalkX() : Number;
      
      function get canWalkY() : Number;
      
      function get usedHP() : int;
      
      function get addedExp() : int;
      
      function get type() : int;
      
      function get state() : int;
      
      function get digCount() : int;
      
      function set StartDigFun(param1:Function) : void;
      
      function ClearMouseEvent() : void;
      
      function StartDig(param1:IDigTreasureItemCtl = null) : void;
      
      function SendDigCmd() : void;
      
      function UpdateData(param1:Object) : void;
      
      function UpdateState() : void;
      
      function Clear() : void;
   }
}

