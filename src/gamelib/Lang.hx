package gamelib;

enum Language
{
  //Language_EN;
  Language_EN_US;
  Language_EN_UK;
  Language_AR;
  Language_BR;
  Language_CN;
  Language_FR;
  Language_DE;
  Language_IN;
  Language_ID;
  Language_IT;
  Language_JP;
  Language_MY;
  Language_MX;
  Language_NL;
  Language_PH;
  Language_PL;
  Language_PT;
  Language_RU;
  Language_SA;
  Language_ES;
  Language_SE;
  Language_TR;
  Language_RO;
}

class Lang
{
  private static var langCode : Hash<Language>;
  private static var codeLang : Hash<String>;

  public static function __init__()
  {
    langCode = new Hash();

    langCode.set("EN_US", Language_EN_US);
    langCode.set("EN_UK", Language_EN_UK);
    langCode.set("AR", Language_AR);
    langCode.set("BR", Language_BR);
    langCode.set("CN", Language_CN);
    langCode.set("FR", Language_FR);
    langCode.set("DE", Language_DE);
    langCode.set("IN", Language_IN);
    langCode.set("ID", Language_ID);
    langCode.set("IT", Language_IT);
    langCode.set("JP", Language_JP);
    langCode.set("MY", Language_MY);
    langCode.set("MX", Language_MX);
    langCode.set("NL", Language_NL);
    langCode.set("PH", Language_PH);
    langCode.set("PL", Language_PL);
    langCode.set("PT", Language_PT);
    langCode.set("RU", Language_RU);
    langCode.set("SA", Language_SA);
    langCode.set("ES", Language_ES);
    langCode.set("SE", Language_SE);
    langCode.set("TR", Language_TR);    
    langCode.set("RO", Language_RO);    

    // hash to get the LANG CODE from a Language enum
    codeLang = new Hash();

    codeLang.set("" + Language_EN_US, "EN_US");
    codeLang.set("" + Language_EN_UK, "EN_UK");
    codeLang.set("" + Language_AR, "AR");
    codeLang.set("" + Language_BR, "BR");
    codeLang.set("" + Language_CN, "CN");
    codeLang.set("" + Language_FR, "FR");
    codeLang.set("" + Language_DE, "DE");
    codeLang.set("" + Language_IN, "IN");
    codeLang.set("" + Language_ID, "ID");
    codeLang.set("" + Language_IT, "IT");
    codeLang.set("" + Language_JP, "JP");
    codeLang.set("" + Language_MY, "MY");
    codeLang.set("" + Language_MX, "MX");
    codeLang.set("" + Language_NL, "NL");
    codeLang.set("" + Language_PH, "PH");
    codeLang.set("" + Language_PL, "PL");
    codeLang.set("" + Language_PT, "PT");
    codeLang.set("" + Language_RU, "RU");
    codeLang.set("" + Language_SA, "SA");
    codeLang.set("" + Language_ES, "ES");
    codeLang.set("" + Language_SE, "SE");
    codeLang.set("" + Language_TR, "TR");
    codeLang.set("" + Language_RO, "RO");
  }

  public static function langFromCode(str : String) : Language
  {
    var tmp = langCode.get(str);

    return (tmp != null) ? tmp : Language_EN_US;
  }

  public static function langToCode(lang : Language) : String
  {
    var tmp = codeLang.get("" + lang);

    return (tmp != null) ? tmp : "US";
  }

  // TODO: modify to take into account a language
  public static function sepColon(lang : Language) : String
  {
    switch(lang)
    {
      case Language_FR:
        return " : ";      

      case Language_CN:
        return "：";

      default:
        return ": ";
    }
    
    return ": ";
  }

  // TODO: modify to take into account a language
  public static function sepComma(lang : Language) : String
  {
    switch(lang)
    {
      case Language_JP:
        return "、";

      case Language_CN:
        return "、";

      default:
        return ", ";
    }
    
    return ", ";
  }

  // TODO: modify to take into account a language
  public static function sepSemiColon(lang : Language) : String
  {
    switch(lang)
    {
      case Language_FR:
        return " ; ";

      case Language_CN:
        return "；";

      default:
        return "; ";
    }
    
    return "; ";
  }

  // interword spacing; JP and CN don't usually use interword spacing
  // TODO: add more languages;
  public static function sepWordSpacing(lang : Language) : String
  {
    switch(lang)
    {
      case Language_JP:
        return "";

      case Language_CN:
        return "";

      default:
        return " ";
    }
    
    return " ";
  }
}

