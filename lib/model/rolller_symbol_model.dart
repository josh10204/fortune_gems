
// enum RollerSymbolType{
//   common,
//   addition,
//   wild,
//   wheel,
// }

enum RollerSymbolType{
  none(imagePath: '',unselectImagePath:''),
  blockWild(imagePath: 'icons/symbol/block/block_wild.png',unselectImagePath:  'icons/symbol/block/block_unselect_wild.png'),
  blockRuby(imagePath: 'icons/symbol/block/block_ruby.png',unselectImagePath:  'icons/symbol/block/block_unselect_ruby.png'),
  blockSapphire(imagePath: 'icons/symbol/block/block_sapphire.png',unselectImagePath:  'icons/symbol/block/block_unselect_sapphire.png'),
  blockEmerald(imagePath: 'icons/symbol/block/block_emerald.png',unselectImagePath:  'icons/symbol/block/block_unselect_emerald.png'),
  blockA(imagePath: 'icons/symbol/block/block_A.png',unselectImagePath:  'icons/symbol/block/block_unselect_A.png'),
  blockK(imagePath: 'icons/symbol/block/block_K.png',unselectImagePath:  'icons/symbol/block/block_unselect_K.png'),
  blockQ(imagePath: 'icons/symbol/block/block_Q.png',unselectImagePath:  'icons/symbol/block/block_unselect_Q.png'),
  blockJ(imagePath: 'icons/symbol/block/block_J.png',unselectImagePath:  'icons/symbol/block/block_unselect_J.png'),
  ratio1x(imagePath: 'icons/symbol/ratio/ratio_1x.png',unselectImagePath:  'icons/symbol/ratio/ratio_unselect_1x.png'),
  ratio2x(imagePath: 'icons/symbol/ratio/ratio_2x.png',unselectImagePath:  'icons/symbol/ratio/ratio_unselect_2x.png'),
  ratio3x(imagePath: 'icons/symbol/ratio/ratio_3x.png',unselectImagePath:  'icons/symbol/ratio/ratio_unselect_3x.png'),
  ratio5x(imagePath: 'icons/symbol/ratio/ratio_5x.png',unselectImagePath:  'icons/symbol/ratio/ratio_unselect_5x.png'),
  ratio10x(imagePath: 'icons/symbol/ratio/ratio_10x.png',unselectImagePath:  'icons/symbol/ratio/ratio_unselect_10x.png'),
  ratio15x(imagePath: 'icons/symbol/ratio/ratio_15x.png',unselectImagePath:  'icons/symbol/ratio/ratio_unselect_15x.png'),
  wheel(imagePath: 'icons/symbol/wheel/wheel.png',unselectImagePath:  'icons/symbol/wheel/wheel_unselect.png'),
  wheelEX(imagePath: 'icons/symbol/wheel/wheel_ex.png',unselectImagePath:  'icons/symbol/wheel/wheel_ex_unselect.png');

  final String imagePath;
  final String unselectImagePath;
  const RollerSymbolType({required this.imagePath, required this.unselectImagePath});
}

enum RollerPayLineType{
  none(firstRollerItemIndexList: [],secondRollerItemIndexList: [],thirdIRollerItemIndexList: []),
  centerLine(firstRollerItemIndexList: [1],secondRollerItemIndexList: [1],thirdIRollerItemIndexList: [1]),
  topLine(firstRollerItemIndexList: [0],secondRollerItemIndexList: [0],thirdIRollerItemIndexList: [0]),
  bottomLine(firstRollerItemIndexList: [2],secondRollerItemIndexList: [2],thirdIRollerItemIndexList: [2]),
  leftSlashLine(firstRollerItemIndexList: [0],secondRollerItemIndexList: [1],thirdIRollerItemIndexList: [2]),
  rightSlashLine(firstRollerItemIndexList: [2],secondRollerItemIndexList: [1],thirdIRollerItemIndexList: [0]);
  final List<int> firstRollerItemIndexList;
  final List<int> secondRollerItemIndexList;
  final List<int> thirdIRollerItemIndexList;
  const RollerPayLineType({required this.firstRollerItemIndexList, required this.secondRollerItemIndexList, required this.thirdIRollerItemIndexList});

}

class RollerSymbolModel{

  RollerSymbolModel({
    required this.type,
  });
  RollerSymbolType type;
}
