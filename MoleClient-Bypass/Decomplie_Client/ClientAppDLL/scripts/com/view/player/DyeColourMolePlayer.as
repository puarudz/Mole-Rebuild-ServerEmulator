package com.view.player
{
   import com.taomee.mole.player.SpritePlayer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   import org.taomee.ds.HashMap;
   import org.taomee.utils.Tick;
   
   public class DyeColourMolePlayer extends Sprite
   {
      
      public static const FRAME_COMPLETE:String = "FRAME_COMPLETE";
      
      protected var playerMap:HashMap;
      
      public function DyeColourMolePlayer(color:Object)
      {
         super();
         this.playerMap = new HashMap();
         var player:SpritePlayer = new SpritePlayer();
         player.resourceURL = VL.getURL("resource/temp/come_body.swf");
         addChild(player);
         this.playerMap.add(1,player);
         player.transform.colorTransform = new ColorTransform(color.red / 256,color.green / 256,color.blue / 256,1);
         player = new SpritePlayer();
         player.resourceURL = VL.getURL("resource/temp/come_face.swf");
         addChild(player);
         this.playerMap.add(2,player);
         Tick.instance.addRender(this.renderHandler);
         player.addFrameCompleteEvent(this.frameCompleteHandler);
      }
      
      private function frameCompleteHandler(evt:Event) : void
      {
         dispatchEvent(new Event(FRAME_COMPLETE));
      }
      
      public function doAction(action:uint) : void
      {
         this.playerMap.eachValue(function(player:SpritePlayer):void
         {
            player.setIndex(action);
         });
      }
      
      protected function renderHandler(... ret) : void
      {
         this.playerMap.eachValue(function(player:SpritePlayer):void
         {
            player.render();
         });
      }
      
      public function distroy() : void
      {
         SpritePlayer(this.playerMap.getValue(2)).removeFrameCompleteEvent(this.frameCompleteHandler);
         Tick.instance.removeRender(this.renderHandler);
         this.playerMap.clear();
      }
      
      public function changeColour(color:Object) : void
      {
         var player:SpritePlayer = this.playerMap.getValue(1);
         player.transform.colorTransform = new ColorTransform(color.red / 256,color.green / 256,color.blue / 256,1);
      }
   }
}

