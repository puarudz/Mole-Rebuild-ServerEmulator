package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [ExcludeClass]
   public class _142ad8c6e942e7fa153b018b41f0ae094040e9ac108dab06644f3601c1d0794f_flash_display_Sprite extends Sprite
   {
      
      public function _142ad8c6e942e7fa153b018b41f0ae094040e9ac108dab06644f3601c1d0794f_flash_display_Sprite()
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

