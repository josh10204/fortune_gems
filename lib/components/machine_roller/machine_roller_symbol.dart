import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:fortune_gems/model/rolller_symbol_model.dart';


enum MachineRollerSymbolStatus{
  general,
  mask,
  animation,
}

class MachineRollerSymbol extends SpriteComponent {

  MachineRollerSymbol({
    required this.rollerSymbolModel,
    required this.index,
    super.position,
    super.anchor
  });

  RollerSymbolModel rollerSymbolModel;
  int index;
  MachineRollerSymbolStatus rollerSymbolStatus = MachineRollerSymbolStatus.general;
  bool _isStopHeader = false;


  // late ScaleEffect _scaleEffect  ;
  final Vector2 generalSymbolSize = Vector2(200,160);
  final Vector2 specialSymbolSize = Vector2(210,200);

  //特殊方塊的中心位置Y軸
  final double specialSymbolCenterY = 200/2 - 160/2;

  bool _isAnimation = false;

  void updateRollerSymbolPositionY(double positionY){
    if(rollerSymbolModel.type == RollerSymbolType.blockWild){
      priority = 1;
      position.y = positionY - specialSymbolCenterY;
    }else{
      priority = 0;
      position.y = positionY;
    }
  }

  void stopRollerSymbol(int index){
    if(rollerSymbolModel.type == RollerSymbolType.blockWild){
      size = specialSymbolSize;
      priority = 1;
      double center = specialSymbolSize.y/2 - generalSymbolSize.y/2;
      double positionY = generalSymbolSize.y*index -center;
      position = Vector2(position.x,positionY);

    }else{
      size = generalSymbolSize;
      priority = 0;
      double positionY = generalSymbolSize.y * index;
      position = Vector2(position.x,positionY);

    }
  }

  Future<void> updateRollerSymbol({required RollerSymbolModel model ,required bool isStopHeader}) async {
    sprite = await Sprite.load(model.type.imagePath);
    rollerSymbolModel = model;
    _isStopHeader = isStopHeader;

    if(rollerSymbolModel.type == RollerSymbolType.blockWild){
      size = specialSymbolSize;
      priority = 1;
    }else{
      size = generalSymbolSize;
      priority = 0;
    }
  }

  bool get isStopHeader{
    return _isStopHeader;
  }

  Future<void> updateRollerSymbolStatus(MachineRollerSymbolStatus status) async {

    switch (status ){
      case MachineRollerSymbolStatus.general:
        sprite = await Sprite.load(rollerSymbolModel.type.imagePath);
        // _isAnimation = false;
        // _scaleEffect.pause();

        break;
      case MachineRollerSymbolStatus.mask:
        // sprite = await Sprite.load(rollerSymbolModel.type.unselectImagePath);
        // _scaleEffect.pause();
        break;
      case MachineRollerSymbolStatus.animation:
        sprite = await Sprite.load(rollerSymbolModel.type.imagePath);
        // priority = 2;
        // _isAnimation = true;
        // _scaleEffect.reset();
        break;

    }
  }

  @override
  void onLoad() async {
    //Set sprite on load.
    sprite = await Sprite.load(rollerSymbolModel.type.imagePath);
    if(rollerSymbolModel.type == RollerSymbolType.blockWild){
      size = specialSymbolSize;
      // double center = specialSymbolSize.y/2 - generalSymbolSize.y/2;
      priority = 1;
      // position = Vector2(baseCenter.x - specialSymbolSize.x/2, generalSymbolSize.y*index - specialSymbolCenterY);
      position = Vector2(position.x, generalSymbolSize.y*index - specialSymbolCenterY);
    }else{
      size = generalSymbolSize;
      priority = 0;
      // position = Vector2(baseCenter.x - generalSymbolSize.x/2, generalSymbolSize.y*index);
      position = Vector2(position.x, generalSymbolSize.y*index);

    }

    // _initScaleEffect();
    super.onLoad();

  }

  // void _initScaleEffect(){
  //   _scaleEffect = ScaleEffect.to(
  //     Vector2(1.05,1.05),
  //     EffectController(duration: 1, reverseDuration: 1,infinite: true,curve: Curves.easeInOut),
  //   );
  //   add(_scaleEffect);
  //   _scaleEffect.pause();
  // }

  @override
  void update(double dt) {

    super.update(dt);
  }

}
