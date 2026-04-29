package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [ExcludeClass]
   public class _f1856842ff186f9e67adb208674487d1ab0b10f7078f4609724ddc4e3dc20d45_flash_display_Sprite extends Sprite
   {
      
      public function _f1856842ff186f9e67adb208674487d1ab0b10f7078f4609724ddc4e3dc20d45_flash_display_Sprite()
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

