package com.view.mapView
{
   import com.core.manager.IndexManager;
   import com.mole.app.map.MapBase;
   import com.view.PeopleView.PeopleManageView;
   import com.view.mapView.activity.Task83.StatisticsClass;
   import com.view.mapView.activity.activity201308.EliseDiary20130830;
   import flash.display.MovieClip;
   
   public class Map252View extends MapBase
   {
      
      private var _peopleView:PeopleManageView;
      
      public function Map252View()
      {
         super();
         StatisticsClass.getInstance().init(67748942);
      }
      
      override protected function initView() : void
      {
      }
      
      override public function init() : void
      {
         super.init();
         this._peopleView = GV.MAN_PEOPLE;
         var MyMadel:MovieClip = IndexManager.getInstance().getMovieClip("amulet_mc");
         MyMadel.name = "amulet_mc";
         this._peopleView.avatarClass.defaultSpeed = 80;
         this._peopleView.avatarClass.speed = this._peopleView.avatarClass.defaultSpeed;
         this._peopleView.avatarMC.addChild(MyMadel);
         EliseDiary20130830.getInstance().serverInfo();
      }
      
      override public function destroy() : void
      {
         EliseDiary20130830.getInstance().destroy();
         super.destroy();
      }
   }
}

