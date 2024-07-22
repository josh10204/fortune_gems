import 'package:fortune_gems/components/grid_menu/grid_menu_component.dart';
import 'package:fortune_gems/model/rolller_symbol_model.dart';
import 'package:fortune_gems/model/wheel_item_model.dart';
import 'package:fortune_gems/system/global.dart';

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
        case '1': return RollerSymbolType.ratio1x;
        case '2': return RollerSymbolType.ratio2x;
        case '3': return RollerSymbolType.ratio3x;
        case '5': return RollerSymbolType.ratio5x;
        case '10': return RollerSymbolType.ratio10x;
        case '15': return RollerSymbolType.ratio15x;
        case '0':
          if(Global().isEnableExtraBet){
            return  RollerSymbolType.wheelEX;
          }else{
            return RollerSymbolType.wheel;
          }
      }
      return RollerSymbolType.none;
    }catch(e){
      return RollerSymbolType.none;
    }
  }

  RollerPayLineType get getRollerPayLineType{
    try{
      switch(this){
        case '1': return RollerPayLineType.centerLine;
        case '2': return RollerPayLineType.topLine;
        case '3': return RollerPayLineType.bottomLine;
        case '4': return RollerPayLineType.leftSlashLine;
        case '5': return RollerPayLineType.rightSlashLine;
      }
      return RollerPayLineType.none;
    }catch(e){
      return RollerPayLineType.none;
    }
  }

  GridItems get getGridItems{
    try{
      switch(this){
        case '1': return GridItems.item15;
        case '2': return GridItems.item14;
        case '3': return GridItems.item13;
        case '5': return GridItems.item12;
        case '8': return GridItems.item11;
        case '10': return GridItems.item10;
        case '20': return GridItems.item9;
        case '50': return GridItems.item8;
        case '100': return GridItems.item7;
        case '200': return GridItems.item6;
        case '300': return GridItems.item5;
        case '400': return GridItems.item4;
        case '500': return GridItems.item3;
        case '700': return GridItems.item2;
        case '1000': return GridItems.item1;
      }
      return GridItems.item15;
    }catch(e){
      return GridItems.item15;
    }
  }

  WheelItemType get getWheelItemTypeFromRatio{
    try{
      switch(this){
        case '1': return WheelItemType.item1x;
        case '3': return WheelItemType.item3x;
        case '5': return WheelItemType.item5x;
        case '8': return WheelItemType.item8x;
        case '10': return WheelItemType.item10x;
        case '15': return WheelItemType.item15x;
        case '20': return WheelItemType.item20x;
        case '30': return WheelItemType.item30x;
        case '50': return WheelItemType.item50x;
        case '100': return WheelItemType.item100x;
        case '200': return WheelItemType.item200x;
        case '1000': return WheelItemType.item1000x;
      }
      return WheelItemType.item1x;
    }catch(e){
      return WheelItemType.item1x;
    }
  }

  WheelAdditionType get getWheelAdditionType{
    try{
      switch(this){
        case '1': return WheelAdditionType.addition1x;
        case '2': return WheelAdditionType.addition2x;
        case '3': return WheelAdditionType.addition3x;
        case '5': return WheelAdditionType.addition5x;
        case '10': return WheelAdditionType.addition10x;
        case '15': return WheelAdditionType.addition15x;
      }
      return WheelAdditionType.addition1x;
    }catch(e){
      return WheelAdditionType.addition1x;
    }
  }

}