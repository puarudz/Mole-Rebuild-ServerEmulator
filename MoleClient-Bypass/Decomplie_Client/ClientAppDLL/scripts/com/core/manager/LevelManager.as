package com.core.manager
{
   import com.global.links.Links;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.geom.Rectangle;
   
   public class LevelManager
   {
      
      private static var _alertLevel:Sprite;
      
      private static var _gameLevel:Sprite;
      
      private static var _topLevel:Sprite;
      
      private static var _appLevel:Sprite;
      
      private static var _toolLevel:Sprite;
      
      private static var _mapLevel:Sprite;
      
      private static var _mapMovieLevel:Sprite;
      
      private static var _tipLevel:Sprite;
      
      private static var _debugLevel:Sprite;
      
      private static var _dialogLevel:Sprite;
      
      private static var _loadingLevel:Sprite;
      
      private static var _root:DisplayObjectContainer;
      
      public static const WIDTH:Number = 960;
      
      public static const HEIGHT:Number = 560;
      
      public function LevelManager()
      {
         super();
      }
      
      public static function setup(root:DisplayObjectContainer) : void
      {
         _root = root;
         Links.stageMC = stage;
         _debugLevel = new Sprite();
         _debugLevel.mouseChildren = _debugLevel.mouseEnabled = false;
         _topLevel = new Sprite();
         _topLevel.mouseEnabled = false;
         GV.MC_TopLever = _topLevel;
         _alertLevel = new Sprite();
         _alertLevel.mouseEnabled = false;
         _gameLevel = new Sprite();
         _gameLevel.mouseEnabled = false;
         _dialogLevel = new Sprite();
         _dialogLevel.mouseEnabled = false;
         _appLevel = new Sprite();
         _appLevel.mouseEnabled = false;
         _appLevel.name = "applevel";
         GV.MC_AppLever = _appLevel;
         _toolLevel = new Sprite();
         _toolLevel.scrollRect = new Rectangle(0,0,960,560);
         _toolLevel.mouseEnabled = false;
         _mapMovieLevel = new Sprite();
         _mapMovieLevel.mouseEnabled = false;
         _mapLevel = new Sprite();
         _mapLevel.scrollRect = new Rectangle(0,0,960,560);
         _mapLevel.mouseEnabled = false;
         _loadingLevel = new Sprite();
         _loadingLevel.mouseEnabled = false;
         _tipLevel = new Sprite();
         _tipLevel.mouseChildren = false;
         _tipLevel.mouseEnabled = false;
         _root.addChild(_mapLevel);
         _root.addChild(_mapMovieLevel);
         _root.addChild(_toolLevel);
         _root.addChild(_appLevel);
         _root.addChild(_gameLevel);
         _root.addChild(_topLevel);
         _root.addChild(_dialogLevel);
         _root.addChild(_alertLevel);
         _root.addChild(_tipLevel);
         _root.addChild(_debugLevel);
         _root.addChild(_loadingLevel);
         _root.mouseEnabled = true;
      }
      
      public static function get stageRect() : Rectangle
      {
         return new Rectangle(0,0,WIDTH,HEIGHT);
      }
      
      public static function get stage() : Stage
      {
         return _root.stage;
      }
      
      public static function drawBG(color:uint = 0, alpha:Number = 0.3, rect:Rectangle = null) : Sprite
      {
         if(rect == null)
         {
            rect = stageRect;
         }
         var bg:Sprite = new Sprite();
         bg.graphics.beginFill(color,alpha);
         bg.graphics.drawRect(0,0,rect.width,rect.height);
         bg.graphics.endFill();
         return bg;
      }
      
      public static function get root() : Sprite
      {
         return _root as Sprite;
      }
      
      public static function get alertLevel() : Sprite
      {
         return _alertLevel;
      }
      
      public static function get gameLevel() : Sprite
      {
         return _gameLevel;
      }
      
      public static function get topLevel() : Sprite
      {
         return _topLevel;
      }
      
      public static function get appLevel() : Sprite
      {
         return _appLevel;
      }
      
      public static function get toolLevel() : Sprite
      {
         return _toolLevel;
      }
      
      public static function get mapLevel() : Sprite
      {
         return _mapLevel;
      }
      
      public static function get tipLevel() : Sprite
      {
         return _tipLevel;
      }
      
      public static function get debugLevel() : Sprite
      {
         return _debugLevel;
      }
      
      public static function get mapMovieLevel() : Sprite
      {
         return _mapMovieLevel;
      }
      
      public static function get dialogLevel() : Sprite
      {
         return _dialogLevel;
      }
      
      public static function get loadingLevel() : Sprite
      {
         return _loadingLevel;
      }
   }
}

