import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'package:flame/image_composition.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/rendering.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';
import 'package:fortune_gems/widget/icon_button.dart';

class SettingMenuComponent extends SpriteComponent  with HasVisibility {
  SettingMenuComponent({super.position,super.size,required this.onTap}) : super();
  final void Function() onTap;


  late IconButton _spinButton;
  late IconButton _aboutButton;
  late IconButton _soundButton;

  bool _isMute = false;

  final String _soundIconPath  = 'icons/button_setting_sound.png';
  final String _muteIconPath  = 'icons/button_setting_mute.png';

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('images/setting_menu_background.png');
    super.onLoad();

    _initSpinSettingButton();
    _initAboutButton();
    _initSoundSettingButton();

  }

  void _initSpinSettingButton(){
    double buttonWidth = 100;
    double buttonHeight = 88;
    double positonX = localCenter.x - buttonWidth/2;
    double positonY = localCenter.y*0.4 - buttonHeight/2;
    _spinButton = IconButton(
      size: Vector2(buttonWidth, buttonHeight),
      position: Vector2(positonX, positonY),
      iconPath: 'icons/button_setting_spin.png',
      onTap: (){},
    );
    add(_spinButton);
  }
  void _initAboutButton(){
    double buttonWidth = 100;
    double buttonHeight =100;
    double positonX = localCenter.x - buttonWidth/2;
    double positonY = localCenter.y - buttonHeight/2;
    _aboutButton = IconButton(
      size: Vector2(buttonWidth, buttonHeight),
      position: Vector2(positonX, positonY),
      iconPath: 'icons/button_setting_about.png',
      onTap: (){},
    );
    add(_aboutButton);
  }
  void _initSoundSettingButton(){
    double buttonWidth = 80;
    double buttonHeight = 80;
    double positonX = localCenter.x - buttonWidth/2;
    double positonY = localCenter.y *1.6 - buttonHeight/2;
    _soundButton = IconButton(
      size: Vector2(buttonWidth, buttonHeight),
      position: Vector2(positonX, positonY),
      iconPath: _soundIconPath,
      onTap: (){

        if(_isMute){
          _isMute = false;
          _soundButton.updateIconPath(_soundIconPath);

        }else{
          _isMute = true;
          _soundButton.updateIconPath(_muteIconPath);
        }

      },
    );
    add(_soundButton);
  }




  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void render(Canvas canvas){
    super.render(canvas);


  }

}