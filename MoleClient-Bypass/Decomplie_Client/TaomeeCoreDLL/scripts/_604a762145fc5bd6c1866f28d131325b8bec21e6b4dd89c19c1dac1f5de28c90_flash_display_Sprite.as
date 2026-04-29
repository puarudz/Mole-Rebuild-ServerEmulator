package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [ExcludeClass]
   public class _604a762145fc5bd6c1866f28d131325b8bec21e6b4dd89c19c1dac1f5de28c90_flash_display_Sprite extends Sprite
   {
      
      public function _604a762145fc5bd6c1866f28d131325b8bec21e6b4dd89c19c1dac1f5de28c90_flash_display_Sprite()
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

