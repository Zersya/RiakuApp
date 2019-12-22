enum ScreenType {
  SMALL, // <= 500
  MEDIUM, // > 500 <= 800
  LARGE, // > 800 <= 1280
  WEB // > 1280
}

class ScreenSize {
  static ScreenType getTypeScreen(double width) {
    if(width <= 320){
      return ScreenType.SMALL;
    }else if(width > 320 && width <= 800){
      return ScreenType.MEDIUM;
    }else if(width > 800 && width <= 1280){
      return ScreenType.LARGE;
    }else{
      return ScreenType.WEB;
    }
  }
}
