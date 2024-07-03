import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';

import 'package:flame/image_composition.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/rendering.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';
import 'package:fortune_gems/system/global.dart';
import 'package:fortune_gems/widget/icon_button.dart';

class ExtraMenuComponent extends PositionComponent  with HasVisibility{
  ExtraMenuComponent({super.position,super.size,required this.onTapSwitch}) : super();
  final void Function(bool isEnable) onTapSwitch;

  late Global _global;

  late PositionComponent _basicView;
  late SpriteComponent _menuBar;
  late TextComponent _titleText;
  late IconButton _switchButton;
  late IconButton _aboutButton;

  final MoveToEffect _showExtraMenuEffect = MoveToEffect(Vector2(0,0), EffectController(duration: 0.2),);
  final MoveToEffect _closeExtraMenuEffect = MoveToEffect(Vector2(-350,0), EffectController(duration: 0.2),);
  bool _isOnExtra = false;
  final String _offIconPath  = 'icons/button_extra_off.png';
  final String _onIconPath  = 'icons/button_extra_on.png';


  void showExtraMenu(){
    print('showExtraMenu');
    _closeExtraMenuEffect.resetToEnd();
    _basicView.add(_showExtraMenuEffect);
    _showExtraMenuEffect.reset();
  }
  void closeExtraMenu() {
    print('closeExtraMenu');
    _showExtraMenuEffect.resetToEnd();
    _basicView.add(_closeExtraMenuEffect);
    _closeExtraMenuEffect.reset();
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _global = Global();

    _initBasic();
    _initMenuBar();
    _initTitleText();
    _initSwitchButton();
    _initAboutButton();
  }
  Future<void> _initBasic() async {
    _basicView = PositionComponent(size: size,position: Vector2(-350,0));
    add(_basicView);
    add(ClipComponent.rectangle(size: size, children: [_basicView],));
  }


  Future<void> _initMenuBar() async {
    _menuBar = SpriteComponent(
      sprite: await Sprite.load('images/extra_menu_background.png'),
      size: Vector2(390, 100),
      position: Vector2.zero(),
    );
    _basicView.add(_menuBar);
  }
  void _initTitleText(){
    double fontSize = 32.0;
    double positonX = 60;
    double positonY = localCenter.y - fontSize*0.7;
    final regular = TextPaint(
      style: TextStyle(
        fontSize: fontSize,
        color: BasicPalette.white.color,
      ),
    );
    _titleText = TextComponent(
      text: 'Extra Bet',
      textRenderer: regular,
      position: Vector2(positonX, positonY),
    );
    add(_titleText);
    _titleText.priority = 1;
    _basicView.add(_titleText);

  }

  Future<void> _initSwitchButton() async {
    double buttonWidth = 184;
    double buttonHeight = 78.4;
    double positonX = 190;
    double positonY = localCenter.y-buttonHeight/2;
    _switchButton = IconButton(
      size: Vector2(buttonWidth, buttonHeight),
      position: Vector2(positonX, positonY),
      iconPath: _offIconPath,
      onTap: (){
        if(_global.gameStatus !=GameStatus.idle){
          return;
        }
        if(_isOnExtra){
          _isOnExtra = false;
          _switchButton.updateIconPath(_offIconPath);
        }else{
          _isOnExtra = true;
          _switchButton.updateIconPath(_onIconPath);
        }

        onTapSwitch.call(_isOnExtra);
      },
    );
    _switchButton.priority = 1;
    _basicView.add(_switchButton);
  }

  Future<void> _initAboutButton() async {
    double buttonWidth = 100;
    double buttonHeight = 100;
    double positonX = 390;
    double positonY = localCenter.y-buttonHeight/2;
    _aboutButton = IconButton(
      size: Vector2(buttonWidth, buttonHeight),
      position: Vector2(positonX, positonY),
      iconPath: 'icons/button_extra_about.png',
      onTap: (){}
    );
    _basicView.add(_aboutButton);
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