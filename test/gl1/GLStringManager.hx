// Example implementation of the abstract class StringManager 
// Uses two languages, EN and RO
// To add a new language:
// * add the language package(s) in the data.xml as binary
// * add the language package(s) in the Data.hx file as ByteData
// * add in the Language enum the language needed
// * init the new language package(s) in the SetLang method of GLStringManager class

// as3.0

// app
import gamelib.stringmanager.StringManager;
import gamelib.sentry.SentrySprite;
import Data;

enum Language
{
  Language_EN;
  Language_RO;
}

class GLStringManager extends StringManager
{
  public var Lang(GetLang, SetLang) : Language;

  public function new()
  {
    super();

    Lang = Language_EN;
  }

  private function GetLang() : Language
  {
    return Lang;
  }

  private function SetLang(v : Language) : Language
  {
    trace("setting lang " + v + "/" + Lang);

    if (v != Lang)
    {
      Lang = v;

      StringPackages = new Array();

      switch(Lang)
      {
        case Language_EN:
        {

          StringPackages.push(new StringPackage(new LangData_EN()));
        }

        case Language_RO:
        {
          StringPackages.push(new StringPackage(new LangData_RO()));
        }
      }
    }

    return Lang;
  }
}