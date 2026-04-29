package com.common.tip
{
   import com.core.manager.IndexManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class NpcDialogBox
   {
      
      public static var ARROW_LEFT:int = 0;
      
      public static var ARROW_RIGHT:int = 1;
      
      private var boxMC:MovieClip;
      
      private var boxBG:MovieClip;
      
      private var txt:TextField;
      
      private var arrow:MovieClip;
      
      private var owner:DisplayObjectContainer;
      
      private var box_X:Number;
      
      private var box_Y:Number;
      
      private var arrowDir:int;
      
      private var boxBGOldX:Number;
      
      public function NpcDialogBox(owner:DisplayObjectContainer, x:Number = 0, y:Number = 0, arrowDirection:int = 0)
      {
         super();
         this.owner = owner;
         this.arrowDir = arrowDirection;
         this.box_X = x;
         this.box_Y = y;
         this.boxMC = IndexManager.getInstance().getMovieClip("dialog_box");
         this.boxBG = this.boxMC["BG"];
         this.txt = this.boxMC["showMSG_txt"];
         this.arrow = this.boxMC["msgjt_mc"];
         this.txt.autoSize = TextFieldAutoSize.LEFT;
         this.txt.wordWrap = true;
         this.boxBGOldX = this.boxBG.x;
      }
      
      public function show(msg:String) : void
      {
         this.txt.text = msg;
         if(this.txt.textWidth > this.arrow.width)
         {
            this.boxBG.width = this.txt.textWidth + 14;
         }
         else
         {
            this.boxBG.width = this.arrow.width + 28;
         }
         this.boxBG.height = this.txt.textHeight + 12;
         this.boxBG.y = this.arrow.y - this.boxBG.height + 1;
         this.txt.y = this.boxBG.y + 4;
         if(this.arrowDir == ARROW_RIGHT)
         {
            this.arrow.scaleX = -1;
         }
         else
         {
            this.arrow.scaleX = 1;
         }
         this.boxBG.x = this.boxBGOldX;
         this.txt.x = this.boxBG.x + 6;
         this.boxMC.x = this.box_X;
         this.boxMC.y = this.box_Y;
         this.owner.addChild(this.boxMC);
      }
      
      public function hide() : void
      {
         this.owner.removeChild(this.boxMC);
      }
      
      public function destroy() : void
      {
         if(Boolean(this.boxMC.parent))
         {
            this.boxMC.parent.removeChild(this.boxMC);
         }
         this.arrow = null;
         this.owner = null;
         this.boxBG = null;
         this.boxMC = null;
         this.txt = null;
      }
      
      public function setArrowDir(i:int) : void
      {
         this.arrowDir = i;
      }
      
      public function setXY(x:Number, y:Number) : void
      {
         this.box_X = x;
         this.box_Y = y;
      }
      
      public function setOwner(i:DisplayObjectContainer) : void
      {
         this.owner = i;
      }
      
      public function getBoxBG() : MovieClip
      {
         return this.boxBG;
      }
      
      public function getTextField() : TextField
      {
         return this.txt;
      }
      
      public function getArrow() : MovieClip
      {
         return this.arrow;
      }
   }
}

