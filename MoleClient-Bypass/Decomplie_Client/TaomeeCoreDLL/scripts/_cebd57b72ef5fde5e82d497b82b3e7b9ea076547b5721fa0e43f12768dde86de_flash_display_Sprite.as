package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [ExcludeClass]
   public class _cebd57b72ef5fde5e82d497b82b3e7b9ea076547b5721fa0e43f12768dde86de_flash_display_Sprite extends Sprite
   {
      
      public function _cebd57b72ef5fde5e82d497b82b3e7b9ea076547b5721fa0e43f12768dde86de_flash_display_Sprite()
      {
         super();
      }
      
      public function allowDomainInRSL(... rest) : void
      {
         Security.allowDomain(rest);
      }
      
      public function allowInsecureDomainInRSL(... rest) : void
      {
         Security.allowInsecureDomain(rest);
      }
   }
}

