import 'package:fortune_gems/model/rolller_symbol_model.dart';

extension StringExtension on String{

  RollerSymbolType get getRollerSymbolType{
    try{
      switch(this){
        case 'W': return RollerSymbolType.blockWild;
        case 'H1': return RollerSymbolType.blockRuby;
        case 'H2': return RollerSymbolType.blockSapphire;
        case 'H3': return RollerSymbolType.blockEmerald;
        case 'N1': return RollerSymbolType.blockA;
        case 'N2': return RollerSymbolType.blockK;
        case 'N3': return RollerSymbolType.blockQ;
        case 'N4': return RollerSymbolType.blockJ;
        case '0': return RollerSymbolType.wheel;
        case '1': return RollerSymbolType.ratio1x;
        case '2': return RollerSymbolType.ratio2x;
        case '3': return RollerSymbolType.ratio3x;
        case '5': return RollerSymbolType.ratio5x;
        case '10': return RollerSymbolType.ratio10x;
        case '15': return RollerSymbolType.ratio15x;
      }
      return RollerSymbolType.none;
    }catch(e){
      return RollerSymbolType.none;
    }

  }

}