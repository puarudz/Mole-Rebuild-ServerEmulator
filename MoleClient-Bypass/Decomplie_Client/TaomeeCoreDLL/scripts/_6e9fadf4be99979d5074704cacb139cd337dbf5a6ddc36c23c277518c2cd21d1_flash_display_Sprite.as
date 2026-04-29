package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [ExcludeClass]
   public class _6e9fadf4be99979d5074704cacb139cd337dbf5a6ddc36c23c277518c2cd21d1_flash_display_Sprite extends Sprite
   {
      
      public function _6e9fadf4be99979d5074704cacb139cd337dbf5a6ddc36c23c277518c2cd21d1_flash_display_Sprite()
      {
         super();
      }
      
      public function allowDomainInRSL(... rest) : void
      {
         Security.allowDomain.apply(null,rest);
      }
      
      public function allowInsecureDomainInRSL(... rest) : void
      {
         Security.allowInsecureDomain.apply(null,rest);
      }
   }
}

