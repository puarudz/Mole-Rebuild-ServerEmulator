package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [ExcludeClass]
   public class _ce04b8df92ca854473f8cf2b9eb3541f751a3cc1bfb0355143e1ef134677922a_flash_display_Sprite extends Sprite
   {
      
      public function _ce04b8df92ca854473f8cf2b9eb3541f751a3cc1bfb0355143e1ef134677922a_flash_display_Sprite()
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

