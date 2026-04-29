package com.mole.app.map
{
   import com.common.data.UILibrary;
   import com.mole.app.manager.NPCDialogManager;
   import com.mole.app.utils.SceneInteraction;
   import com.mole.app.utils.SceneOuteraction;
   import com.view.MapManageView.MapManageView;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   
   public class MapMaterialBase extends MovieClip
   {
      
      protected var _material:MovieClip;
      
      protected var _uiLibrary:UILibrary;
      
      protected var _interactiveList:Array;
      
      protected var _outeractiveList:Array;
      
      public function MapMaterialBase(material:MovieClip)
      {
         super();
         this._material = material;
         this._uiLibrary = new UILibrary(this.loaderInfo.applicationDomain);
         this.initView();
         this._interactiveList = new Array();
         this._outeractiveList = new Array();
         if(Boolean(this._material))
         {
            this.recursionInteractive(this._material);
         }
      }
      
      protected function mapSay(id:uint) : void
      {
         NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(id));
      }
      
      private function recursionInteractive(mc:DisplayObjectContainer) : void
      {
         var sub_mc:DisplayObjectContainer = null;
         var paramList:Array = null;
         for(var i:uint = 0; i < mc.numChildren; i++)
         {
            sub_mc = mc.getChildAt(i) as DisplayObjectContainer;
            if(Boolean(sub_mc))
            {
               paramList = sub_mc.name.split("_");
               if(paramList[0] == "interactive")
               {
                  this._interactiveList.push(new SceneInteraction(MovieClip(sub_mc),uint(paramList[1]) == 1));
               }
               else if(paramList[0] == "outeractive")
               {
                  MovieClip(sub_mc).gotoAndStop(1);
                  this._outeractiveList.push(new SceneOuteraction(MovieClip(sub_mc),uint(paramList[1]) == 1));
               }
               else
               {
                  this.recursionInteractive(sub_mc);
               }
            }
         }
      }
      
      protected function initView() : void
      {
      }
      
      public function initPeople() : void
      {
      }
      
      public function destroy() : void
      {
         var interaction:SceneInteraction = null;
         for each(interaction in this._interactiveList)
         {
            interaction.destroy();
         }
         this._interactiveList = null;
         this._material = null;
         BC.removeEvent(this);
      }
      
      public function get topLevel() : MovieClip
      {
         return this._material["top_mc"];
      }
      
      public function get typeLevel() : MovieClip
      {
         return this._material["type_mc"];
      }
      
      public function get depthLevel() : MovieClip
      {
         return this._material["depth_mc"];
      }
      
      public function get bgLevel() : MovieClip
      {
         return this._material["bg_mc"];
      }
      
      public function get spaceLevel() : MovieClip
      {
         return this._material["space_mc"];
      }
      
      public function get controlLevel() : MovieClip
      {
         return this._material["control_mc"];
      }
      
      public function get buttonLevel() : MovieClip
      {
         return this._material["button_mc"];
      }
      
      public function get map_mc() : MovieClip
      {
         return this._material;
      }
   }
}

