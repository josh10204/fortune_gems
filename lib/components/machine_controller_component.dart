import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flame/particles.dart';
import 'package:flame/text.dart';
import 'package:fortune_gems/test_particle_component.dart';
import 'package:fortune_gems/widget/machine_cntroller_button.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';
import 'package:fortune_gems/widget/machine_extra_menu.dart';
import 'package:fortune_gems/widget/machine_bet_menu.dart';
import 'package:fortune_gems/widget/machine_setting_menu.dart';

class MachineControllerComponent extends PositionComponent {
  MachineControllerComponent({
    super.anchor,
    super.position,
    required this.onTapSpinButton,
    required this.onTapAutoButton,
    required this.onTapSpeedButton,
    required this.onTapBetButton,
    required this.onTapSettingButton
  }) : super(size: Vector2(1290, 2796));
  final void Function() onTapSpinButton;
  final void Function() onTapAutoButton;
  final void Function() onTapSpeedButton;
  final void Function() onTapBetButton;
  final void Function() onTapSettingButton;



  final double _bottomControllerCenterY = 2796 - 250;
  final Color _textTitleColor = const Color.fromRGBO(248, 215, 97, 1);
  final Color _textSubTitleColor = const Color.fromRGBO(255, 255, 255, 1);

  double _balanceAmount = 2000;
  double _winAmount = 0.00;
  double _betAmount = 1000;


  late TextComponent _balanceTitleText;
  late TextComponent _balanceAmountText;
  late TextComponent _winTitleText;
  late TextComponent _winAmountText;
  late TextComponent _betTitleText;
  late TextComponent _betAmountText;
  late MachineControllerButton _extraButton;
  late MachineControllerButton _spinButton;
  late MachineControllerButton _speedButton;
  late MachineControllerButton _autoButton;
  late MachineControllerButton _betButton;
  late MachineControllerButton _settingButton;
  late MachineExtraMenu _extraMenu;
  late MachineBetMenu _betMenu;
  late MachineSettingMenu _settingMenu;


  bool _isShowSettingMenu = false;
  bool _isShowBetMenu = false;
  bool _isShowExtraMenu = false;



  void showBetMenu(){
    _isShowBetMenu = true;
    _initBetMenu();
  }

  void hideBetMenu(){
    _isShowBetMenu = false;
    remove(_betMenu);
  }

  void showSettingMenu(){
    _isShowSettingMenu = true;
    _initSettingMenu();
  }

  void hideSettingMenu(){
    _isShowSettingMenu = false;
    remove(_settingMenu);
  }


  @override
  Future<void> onLoad() async {
    super.onLoad();

    await _initBottomBackground();
    _initExtraButton();
    _initSpinButton();
    _initAutoButton();
    _initSpeedButton();
    _initBetButton();
    _initSettingButton();
    _initBalanceTitleText();
    _initBalanceAmountText();
    _initWinTitleText();
    _initWinAmountText();
    _initBetAmountTitleText();
    _initBetAmountText();
    _initExtraMenu();
    // _initBetMenu();
    // _initSettingMenu();
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
      onTap: (){
        onTapAutoButton.call();
      }
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

  void _initBetButton(){
    double buttonWidth = 120;
    double buttonHeight = 120;
    double positonX = localCenter.x *0.6-buttonWidth/2;
    double positonY = _bottomControllerCenterY-buttonHeight/2;
    _betButton = MachineControllerButton(
      size: Vector2(buttonWidth, buttonHeight),
      position: Vector2(positonX, positonY),
      iconPath: 'icons/button_bet.png',
      onTap: () {

        if(_isShowBetMenu){
          hideBetMenu();
        }else{
          showBetMenu();
        }
        if(_isShowSettingMenu){
          hideSettingMenu();
        }
        onTapBetButton.call();
      },
    );
    add(_betButton);
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
          hideSettingMenu();
        }else{
          showSettingMenu();
        }
        if(_isShowBetMenu){
          hideBetMenu();
        }
        onTapSettingButton.call();
      },
    );
    add(_settingButton);
  }

  void _initBalanceTitleText(){

    double fontSize = 60;
    double positonX = localCenter.x - 300;
    double positonY = localBottom.y - fontSize *1.4;
    _balanceTitleText = TextComponent(
      text:'Balance',
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: fontSize,
          color: _textTitleColor,
        ),
      ),
      // angle: Anchor.center,
      position: Vector2(positonX,positonY),
    );
    add(_balanceTitleText);

  }

  void _initBalanceAmountText(){
    double fontSize = 60;
    double positonX = localCenter.x - 50;
    double positonY = localBottom.y - fontSize *1.4;
    _balanceAmountText = TextComponent(
      text:_balanceAmount.toStringAsFixed(2),
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: fontSize,
          fontWeight:FontWeight.bold,
          color: _textSubTitleColor,
        ),
      ),
      // angle: Anchor.center,
      position: Vector2(positonX,positonY),
    );
    add(_balanceAmountText);

  }

  void _initWinTitleText(){

    double fontSize = 60;
    double positonX = localCenter.x - 300;
    double positonY = _bottomControllerCenterY - 250 ;
    _winTitleText = TextComponent(
      text:'WIN',
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: fontSize,
          color: _textTitleColor,
        ),
      ),
      // angle: Anchor.center,
      position: Vector2(positonX,positonY),
    );
    add(_winTitleText);
  }

  void _initWinAmountText(){
    double fontSize = 60;
    double positonX = localCenter.x - 50;
    double positonY = _bottomControllerCenterY - 250 ;
    _winAmountText = TextComponent(
      text:_winAmount.toStringAsFixed(2),
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: fontSize,
          fontWeight:FontWeight.bold,
          color: _textSubTitleColor,
        ),
      ),
      // angle: Anchor.center,
      position: Vector2(positonX,positonY),
    );
    add(_winAmountText);
  }

  void _initBetAmountTitleText(){

    double fontSize = 40;
    double positonX = _betButton.position.x;
    double positonY = _betButton.position.y + _betButton.size.y ;
    _betTitleText = TextComponent(
      text:'Bet',
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: fontSize,
          color: _textSubTitleColor,
        ),
      ),
      // angle: Anchor.center,
      position: Vector2(positonX,positonY),
    );
    add(_betTitleText);
  }

  void _initBetAmountText(){
    double fontSize = 40;
    double positonX = _betButton.position.x + 80;
    double positonY = _betButton.position.y + _betButton.size.y ;
    _betAmountText = TextComponent(
      text:_betAmount.toString(),
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: fontSize,
          color: _textSubTitleColor,
        ),
      ),
      // angle: Anchor.center,
      position: Vector2(positonX,positonY),
    );
    add(_betAmountText);
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
    // _settingMenu.isVisible = _isShowSettingMenu;
    add(_settingMenu);
  }

  void _initBetMenu(){
    double buttonWidth = 632;
    double buttonHeight = 595;
    double positonX = _betButton.position.x + _betButton.size.x/2 - buttonWidth/2;
    double positonY = _betButton.y - buttonHeight - 30;
    _betMenu = MachineBetMenu(
      size: Vector2(buttonWidth, buttonHeight),
      position: Vector2(positonX, positonY),
      onSelectCallBack: (amount) {
        _betAmount = amount;
        _betAmountText.text = amount.toString();
      },
    );
    // _betMenu.isVisible = _isShowBetMenu;
    add(_betMenu);
  }

}

