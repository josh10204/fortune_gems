
enum RollerSymbolType{
  common,
  addition,
  special,
}

class RollerSymbolModel{

  RollerSymbolModel({
    required this.imageFilePath,
    required this.unselectImageFilePath,
    required this.type,
    required this.isWinningSymbol,
  });
  String imageFilePath;
  String unselectImageFilePath;
  bool isWinningSymbol;
  RollerSymbolType type;

}
