package com.view.mapView
{
   import com.core.MainManager;
   import com.core.newloader.MCLoader;
   import com.event.MCLoadEvent;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.utils.PlayMovie;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class MomoSecrectRoomView extends MapBase
   {
      
      private var momoDiaryMC:MovieClip;
      
      private var teethPhotoMC:MovieClip;
      
      public function MomoSecrectRoomView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         BC.addEvent(this,controlLevel.momoDiary_btn,MouseEvent.CLICK,this.momoDiaryLoadHandler);
         SystemEventManager.addEventListener("boFangPaoPao",this.paoPaoHandle);
      }
      
      private function paoPaoHandle(e:*) : void
      {
         var movie:PlayMovie = null;
         movie = PlayMovie.play("resource/newTask/task626/movie/task_movie_626_2.swf",null,null,function():void
         {
            movie.destroy();
            ModuleManager.openPanel("ReviewGalleryPanel",3);
         });
      }
      
      private function momoDiaryLoadHandler(evt:MouseEvent) : void
      {
         var tempMC:MCLoader = null;
         if(!MainManager.getGameLevel().getChildByName("momoDiaryMC"))
         {
            this.momoDiaryMC = new MovieClip();
            this.momoDiaryMC.name = "momoDiaryMC";
            MainManager.getGameLevel().addChild(this.momoDiaryMC);
            tempMC = new MCLoader("module/external/BooksUI/MomoDiary.swf",this.momoDiaryMC,1,"正在打開麼麼公主日記");
            BC.addEvent(this,tempMC,MCLoadEvent.ON_SUCCESS,this.momoDiaryLoadOver);
            tempMC.doLoad();
         }
      }
      
      private function momoDiaryLoadOver(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:* = evt.getLoader();
         mainMC.addChild(childMC);
         BC.addEvent(this,GV.onlineSocket,"monthlyCloseEvent",this.closeMomoDiaryBook);
         var mcloader:MCLoader = evt.target as MCLoader;
         BC.removeEvent(this,mcloader,MCLoadEvent.ON_SUCCESS,this.momoDiaryLoadOver);
         mcloader.clear();
      }
      
      private function closeMomoDiaryBook(evt:Event = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"monthlyCloseEvent",this.closeMomoDiaryBook);
         GC.stopAllMC(this.momoDiaryMC);
         GC.clearChildren(this.momoDiaryMC);
         this.momoDiaryMC.parent.removeChild(this.momoDiaryMC);
         this.momoDiaryMC = null;
      }
      
      override public function destroy() : void
      {
         SystemEventManager.removeEventListener("boFangPaoPao",this.paoPaoHandle);
         super.destroy();
      }
   }
}

