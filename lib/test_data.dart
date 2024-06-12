import 'dart:math';

import 'package:fortune_gems/components/machine_roller_component.dart';
import 'package:fortune_gems/model/rolller_symbol_model.dart';
import 'package:fortune_gems/widget/machine_roller_symbol.dart';

class TestData{


  List<RollerSymbolModel> getRollerCommonSymbolList(){
    Random random = Random();
    List<RollerSymbolModel> symbolList = [];
    List<RollerSymbolModel> allSymbol = _getAllRollerSymbol(RollerType.common);
    int symbolTotal = 5;
    int winningTotle = 3;
    for (int i = 0 ;i< symbolTotal;i++) {
      bool isStopHeader = i == 0 ? true:false ;
      bool isWinningTarget = i < winningTotle ? true:false;
      RollerSymbolModel symbol = allSymbol[random.nextInt(allSymbol.length)];
      symbol.isWinningSymbol = isWinningTarget;
      symbolList.add(symbol);
    }
    return symbolList;
  }

  List<RollerSymbolModel> getRollerAdditionSymbolList(){
    Random random = Random();
    List<RollerSymbolModel> symbolList = [];
    List<RollerSymbolModel> allSymbol = _getAllRollerSymbol(RollerType.special);
    int symbolTotal = 5;
    for (int i = 0 ;i< symbolTotal;i++) {
      RollerSymbolModel symbol = allSymbol[random.nextInt(allSymbol.length)];
      symbolList.add(symbol);
    }
    return symbolList;
  }


  List<RollerSymbolModel> _getAllRollerSymbol(RollerType rollerType){
    List<RollerSymbolModel> list = [];
    if(rollerType == RollerType.common){
      list = [
        RollerSymbolModel(type:RollerSymbolType.common,isWinningSymbol:false,imageFilePath: 'icons/symbol_common_01.png',unselectImageFilePath: 'icons/symbol_common_unselect_01.png'),
        RollerSymbolModel(type:RollerSymbolType.common,isWinningSymbol:false,imageFilePath: 'icons/symbol_common_02.png',unselectImageFilePath: 'icons/symbol_common_unselect_02.png'),
        RollerSymbolModel(type:RollerSymbolType.common,isWinningSymbol:false,imageFilePath: 'icons/symbol_common_03.png',unselectImageFilePath: 'icons/symbol_common_unselect_03.png'),
        RollerSymbolModel(type:RollerSymbolType.common,isWinningSymbol:false,imageFilePath: 'icons/symbol_common_04.png',unselectImageFilePath: 'icons/symbol_common_unselect_04.png'),
        RollerSymbolModel(type:RollerSymbolType.common,isWinningSymbol:false,imageFilePath: 'icons/symbol_common_05.png',unselectImageFilePath: 'icons/symbol_common_unselect_05.png'),
        RollerSymbolModel(type:RollerSymbolType.common,isWinningSymbol:false,imageFilePath: 'icons/symbol_common_06.png',unselectImageFilePath: 'icons/symbol_common_unselect_06.png'),
        RollerSymbolModel(type:RollerSymbolType.common,isWinningSymbol:false,imageFilePath: 'icons/symbol_common_07.png',unselectImageFilePath: 'icons/symbol_common_unselect_07.png'),
        RollerSymbolModel(type:RollerSymbolType.wild,isWinningSymbol:false,imageFilePath: 'icons/symbol_common_08.png',unselectImageFilePath: 'icons/symbol_common_unselect_08.png'),
      ];

    }else{
      list = [
        RollerSymbolModel(type:RollerSymbolType.addition,isWinningSymbol:false,imageFilePath: 'icons/symbol_addition_01.png',unselectImageFilePath: 'icons/symbol_addition_unselect_01.png'),
        RollerSymbolModel(type:RollerSymbolType.addition,isWinningSymbol:false,imageFilePath: 'icons/symbol_addition_02.png',unselectImageFilePath: 'icons/symbol_addition_unselect_02.png'),
        RollerSymbolModel(type:RollerSymbolType.addition,isWinningSymbol:false,imageFilePath: 'icons/symbol_addition_03.png',unselectImageFilePath: 'icons/symbol_addition_unselect_03.png'),
        RollerSymbolModel(type:RollerSymbolType.addition,isWinningSymbol:false,imageFilePath: 'icons/symbol_addition_04.png',unselectImageFilePath: 'icons/symbol_addition_unselect_04.png'),
        RollerSymbolModel(type:RollerSymbolType.addition,isWinningSymbol:false,imageFilePath: 'icons/symbol_addition_05.png',unselectImageFilePath: 'icons/symbol_addition_unselect_05.png'),
        RollerSymbolModel(type:RollerSymbolType.addition,isWinningSymbol:false,imageFilePath: 'icons/symbol_addition_06.png',unselectImageFilePath: 'icons/symbol_addition_unselect_06.png'),
      ];
    }

    return list;
  }


}