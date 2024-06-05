import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:fortune_gems/widget/machine_cntroller_button.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';
import 'package:fortune_gems/widget/machine_extra_menu.dart';
import 'package:fortune_gems/widget/machine_raise_menu.dart';
import 'package:fortune_gems/widget/machine_setting_menu.dart';

class MachineControllerComponent extends PositionComponent {
  MachineControllerComponent({
    super.anchor,
    super.position,
    required this.onTapSpinButton,
    required this.onTapAutoButton,
    required this.onTapSpeedButton,
    required this.onTapRaiseButton,
    required this.onTapSettingButton
  }) : super(size: Vector2(1290, 2796));
  final void Function() onTapSpinButton;
  final void Function() onTapAutoButton;
  final void Function() onTapSpeedButton;
  final void Function() onTapRaiseButton;
  final void Function() onTapSettingButton;



  final double _bottomControllerCenterY = 2796 - 250;
  late MachineControllerButton _extraButton;
  late MachineControllerButton _spinButton;
  late MachineControllerButton _speedButton;
  late MachineControllerButton _autoButton;
  late MachineControllerButton _raiseButton;
  late MachineControllerButton _settingButton;
  late MachineExtraMenu _extraMenu;
  late MachineRaiseMenu _raiseMenu;
  late MachineSettingMenu _settingMenu;


  bool _isShowSettingMenu = false;
  bool _isShowRaiseMenu = false;
  bool _isShowExtraMenu = false;




  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _initBottomBackground();
    _initExtraButton();
    _initSpinButton();
    _initAutoButton();
    _initSpeedButton();
    _initRaiseButton();
    _initSettingButton();
    _initExtraMenu();
    _initRaiseMenu();
    _initSettingMenu();
  }
  Future<void> _initBottomBackground() async {
    double buttonWidth = 340;
    double buttonHeight = 471;
    double positonX = localLeft.x;
    double positonY = localBottomLeft.y-buttonHeight;
    for(int i = 0 ; i<5;i++){
      SpriteComponent bottomBackground = SpriteComponent(
        sprite: await Sprite.load('images/basic_bottom_background.png'),
        size: Vector2(buttonWidth+buttonWidth*i, buttonHeight),
        position: Vector2(positonX, positonY),
      );
      add(bottomBackground);
    }
  }

  void _initExtraButton(){
    double buttonWidth = 174;
    double buttonHeight = 132;
    double positonX = 0;
    double positonY = localCenter.y-buttonHeight;
    _extraButton = MachineControllerButton(
      size: Vector2(buttonWidth, buttonHeight),
      position: Vector2(positonX, positonY),
      iconPath: 'icons/button_extra.png',
      onTap: () {

        if(_isShowExtraMenu){
          _isShowExtraMenu = false;
          _extraMenu.closeExtraMenu();
        }else{
          _isShowExtraMenu = true;
          _extraMenu.showExtraMenu();
        }
      },
    );
    _extraButton.priority = 1;
    add(_extraButton);
  }

  void _initSpinButton(){
    double buttonWidth = 288;
    double buttonHeight = 296;
    double positonX = localCenter.x-buttonWidth/2;
    double positonY = _bottomControllerCenterY-buttonHeight/2;
    _spinButton = MachineControllerButton(
      size: Vector2(buttonWidth, buttonHeight),
      position: Vector2(positonX, positonY),
      iconPath: 'icons/button_spin.png',
      onTap: () => onTapSpinButton.call(),
    );
    add(_spinButton);
  }

  void _initAutoButton(){
    double buttonWidth = 120;
    double buttonHeight = 120;
    double positonX = localCenter.x *1.4-buttonWidth/2;
    double positonY = _bottomControllerCenterY-buttonHeight/2;
    _autoButton = MachineControllerButton(
      size: Vector2(buttonWidth, buttonHeight),
      position: Vector2(positonX, positonY),
      iconPath: 'icons/button_auto.png',
      onTap: () => onTapAutoButton.call(),
    );
    add(_autoButton);
  }

  void _initSpeedButton(){
    double buttonWidth = 120;
    double buttonHeight = 120;
    double positonX = localCenter.x *1.65-buttonWidth/2;
    double positonY = _bottomControllerCenterY-buttonHeight/2;
    _speedButton = MachineControllerButton(
      size: Vector2(buttonWidth, buttonHeight),
      position: Vector2(positonX, positonY),
      iconPath: 'icons/button_speed_disable.png',
      onTap: () => onTapSpeedButton.call(),
    );
    add(_speedButton);
  }

  void _initRaiseButton(){
    double buttonWidth = 120;
    double buttonHeight = 120;
    double positonX = localCenter.x *0.6-buttonWidth/2;
    double positonY = _bottomControllerCenterY-buttonHeight/2;
    _raiseButton = MachineControllerButton(
      size: Vector2(buttonWidth, buttonHeight),
      position: Vector2(positonX, positonY),
      iconPath: 'icons/button_raise.png',
      onTap: () {
        if(_isShowRaiseMenu){
          _isShowRaiseMenu = false;
          _raiseMenu.isVisible = _isShowRaiseMenu;
          _raiseMenu.priority = 0;
        }else{
          _isShowRaiseMenu = true;
          _isShowSettingMenu = false;
          _raiseMenu.isVisible = _isShowRaiseMenu;
          _raiseMenu.priority = 1;
          _settingMenu.isVisible = _isShowSettingMenu;
          _settingMenu.priority = 0;

        }

        onTapRaiseButton.call();
      },
    );
    add(_raiseButton);
  }

  void _initSettingButton(){
    double buttonWidth = 120;
    double buttonHeight = 120;
    double positonX = localCenter.x *0.2-buttonWidth/2;
    double positonY = _bottomControllerCenterY-buttonHeight/2;
    _settingButton = MachineControllerButton(
      size: Vector2(buttonWidth, buttonHeight),
      position: Vector2(positonX, positonY),
      iconPath: 'icons/button_setting.png',
      onTap: (){
        if(_isShowSettingMenu){
          _isShowSettingMenu = false;
          _settingMenu.isVisible = _isShowSettingMenu;
          _settingMenu.priority = 0;
        }else{
          _isShowSettingMenu = true;
          _isShowRaiseMenu = false;
          _settingMenu.isVisible = _isShowSettingMenu;
          _settingMenu.priority = 1;
          _raiseMenu.isVisible = _isShowRaiseMenu;
          _raiseMenu.priority = 0;
        }
        onTapSettingButton.call();
      },
    );
    add(_settingButton);
  }

  void _initExtraMenu(){
    double buttonWidth = 500;
    double buttonHeight = 100;
    double positonX = _extraButton.size.x*0.7;
    double positonY = localCenter.y-buttonHeight;
    _extraMenu = MachineExtraMenu(
      size: Vector2(buttonWidth, buttonHeight),
      position: Vector2(positonX,positonY),
      onTap: () {},
    );
    add(_extraMenu);
  }

  void _initSettingMenu(){
    double buttonWidth = 138;
    double buttonHeight = 404;
    double positonX = _settingButton.position.x + _settingButton.size.x/2 - buttonWidth/2;
    double positonY = _settingButton.y - buttonHeight -30;
    _settingMenu = MachineSettingMenu(
      size: Vector2(buttonWidth, buttonHeight),
      position: Vector2(positonX, positonY),
      onTap: () {},
    );
    _settingMenu.isVisible = _isShowSettingMenu;
    add(_settingMenu);
  }

  void _initRaiseMenu(){
    double buttonWidth = 632;
    double buttonHeight = 595;
    double positonX = _raiseButton.position.x + _raiseButton.size.x/2 - buttonWidth/2;
    double positonY = _raiseButton.y - buttonHeight - 30;
    _raiseMenu = MachineRaiseMenu(
      size: Vector2(buttonWidth, buttonHeight),
      position: Vector2(positonX, positonY),
      onTap: () {},
    );
    _raiseMenu.isVisible = _isShowRaiseMenu;
    add(_raiseMenu);
  }

}
