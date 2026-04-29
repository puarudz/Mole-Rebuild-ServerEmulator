package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [ExcludeClass]
   public class _ca78debe56efab144b4a0d5f22f7b144079590935d41699257010630ce5908c7_flash_display_Sprite extends Sprite
   {
      
      public function _ca78debe56efab144b4a0d5f22f7b144079590935d41699257010630ce5908c7_flash_display_Sprite()
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

