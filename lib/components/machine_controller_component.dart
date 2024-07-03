import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flame/particles.dart';
import 'package:flame/text.dart';
import 'package:fortune_gems/extension/string_extension.dart';
import 'package:fortune_gems/system/global.dart';
import 'package:fortune_gems/widget/icon_button.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';
import 'package:fortune_gems/components/extra_menu_component.dart';
import 'package:fortune_gems/components/grid_menu/grid_menu_component.dart';
import 'package:fortune_gems/components/setting_menu_component.dart';

class MachineControllerComponent extends PositionComponent {
  MachineControllerComponent({
    super.anchor,
    super.position,
    required this.onTapSpinButton,
    required this.onTapBetButton,
    required this.onTapSettingButton,
    required this.onTapAutoButton,
    required this.onTapSpeedButton,
    required this.onTapExtraBetSwitch,
  }) : super(size: Vector2(1290, 2796));
  final void Function() onTapSpinButton;
  final void Function() onTapBetButton;
  final void Function() onTapSettingButton;
  final void Function(bool isEnable) onTapAutoButton;
  final void Function(bool isEnable) onTapSpeedButton;
  final void Function(bool isEnable) onTapExtraBetSwitch;



  final double _bottomControllerCenterY = 2796 - 250;
  final Color _textTitleColor = const Color.fromRGBO(248, 215, 97, 1);
  final Color _textSubTitleColor = const Color.fromRGBO(255, 255, 255, 1);

  late Global _global;
  final double _winAmount = 0;
  double _balanceAmount = 0;
  GridItems _currentBetGridItems = GridItems.item15;
  double _betAmount = 1;

  final String _autoStartIconPath = 'icons/buttons/button_auto_start.png';
  final String _autoStopIconPath = 'icons/buttons/button_auto_stop.png';

  late TextComponent _balanceTitleText;
  late TextComponent _balanceAmountText;
  late TextComponent _winTitleText;
  late TextComponent _winAmountText;
  late TextComponent _betTitleText;
  late TextComponent _betAmountText;
  late IconButton _extraButton;
  late IconButton _spinButton;
  late IconButton _speedButton;
  late IconButton _autoButton;
  late IconButton _betButton;
  late IconButton _settingButton;
  late ExtraMenuComponent _extraMenu;
  late GridTextMenuComponent _betMenu;
  late SettingMenuComponent _settingMenu;


  final _defaultAutoCount = 9;
  bool _isShowSettingMenu = false;
  bool _isShowBetMenu = false;
  bool _isShowExtraMenu = false;
  bool _isEnableAuto = false;
  bool _isEnableSpeed = false;

  void showBetMenu(){
    if(_global.gameStatus != GameStatus.idle) return;
    _isShowBetMenu = true;
    _initBetMenu();
  }

  void hideBetMenu(){
    if(_isShowBetMenu == false) return;
    _isShowBetMenu = false;
    remove(_betMenu);
  }

  void showSettingMenu(){
    if(_global.gameStatus != GameStatus.idle) return;
    _isShowSettingMenu = true;
    _initSettingMenu();
  }

  void hideSettingMenu(){
    if(_isShowSettingMenu == false) return;

    _isShowSettingMenu = false;
    remove(_settingMenu);
  }

  void updateWinAmount(double winAmount){
    _winAmountText.text = winAmount.toStringAsFixed(2);
    if(winAmount>0){
      _balanceAmount += winAmount;
      _balanceAmountText.text = _balanceAmount.toStringAsFixed(2);
    }
  }

  void updateAutoCount(){
    if(_global.autoSpinCount == 0){
      _isEnableAuto = false;
      _global.autoSpinCount = 0;
      _autoButton.updateIconPath(_autoStartIconPath);
      _autoButton.updateText('');
    }else{
      _global.autoSpinCount -= 1;
      String countString = _global.autoSpinCount.toString();
      _autoButton.updateText(countString);
    }
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _global = Global();
    _currentBetGridItems = _global.betAmount.toString().getGridItems;
    _betAmount = _global.betAmount.toDouble();
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
    _extraButton = IconButton(
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
    double buttonWidth = 280;
    double buttonHeight = 280;
    double positonX = localCenter.x-buttonWidth/2;
    double positonY = _bottomControllerCenterY-buttonHeight/2;
    _spinButton = IconButton(
      size: Vector2(buttonWidth, buttonHeight),
      position: Vector2(positonX, positonY),
      iconPath: 'icons/buttons/button_spin.png',
      backgroundImagePath: 'icons/buttons/button_spin_background.png',
      onTap: () {
        hideSettingMenu();
        hideBetMenu();
        _winAmountText.text = _winAmount.toStringAsFixed(2);
        onTapSpinButton.call();
      }
    );
    add(_spinButton);
  }

  void _initAutoButton(){

    double buttonWidth = 150;
    double buttonHeight = 150;
    double positonX = localCenter.x * 1.4 - buttonWidth / 2;
    double positonY = _bottomControllerCenterY - buttonHeight / 2;
    _autoButton = IconButton(
        size: Vector2(buttonWidth, buttonHeight),
        position: Vector2(positonX, positonY),
        iconPath: _autoStartIconPath,
        backgroundImagePath: 'icons/buttons/button_background.png',
        onTap: () {
          if(_global.gameStatus !=GameStatus.idle && _isEnableAuto == false){
            return;
          }
          if(_isEnableAuto){
            _isEnableAuto = false;
            _global.autoSpinCount = -1;
            _autoButton.updateIconPath(_autoStartIconPath);
            _autoButton.updateText('');
          }else{
            _isEnableAuto = true;
            _global.autoSpinCount = _defaultAutoCount;
            _autoButton.updateIconPath(_autoStopIconPath);
            _autoButton.updateText(_defaultAutoCount.toString());
          }
          onTapAutoButton.call(_isEnableAuto);

        });
    add(_autoButton);
  }

  void _initSpeedButton(){
    String disableIconPath = 'icons/buttons/button_speed_disable.png';
    String enableIconPath = 'icons/buttons/button_speed_enable.png';
    double buttonWidth = 150;
    double buttonHeight = 150;
    double positonX = localCenter.x *1.65-buttonWidth/2;
    double positonY = _bottomControllerCenterY-buttonHeight/2;
    _speedButton = IconButton(
      size: Vector2(buttonWidth, buttonHeight),
      position: Vector2(positonX, positonY),
      iconPath: disableIconPath,
      backgroundImagePath: 'icons/buttons/button_background.png',
      onTap: () {
        if(_isEnableSpeed){
          _isEnableSpeed = false;
          _global.isEnableSpeedSpin = false;
          _speedButton.updateIconPath(disableIconPath);
        }else{
          _isEnableSpeed = true;
          _global.isEnableSpeedSpin = true;
          _speedButton.updateIconPath(enableIconPath);
        }

        onTapSpeedButton.call(_isEnableSpeed);
      },
    );
    add(_speedButton);
  }

  void _initBetButton(){
    double buttonWidth = 150;
    double buttonHeight = 150;
    double positonX = localCenter.x *0.6-buttonWidth/2;
    double positonY = _bottomControllerCenterY-buttonHeight/2;
    _betButton = IconButton(
      size: Vector2(buttonWidth, buttonHeight),
      position: Vector2(positonX, positonY),
      iconPath: 'icons/buttons/button_bet.png',
      backgroundImagePath: 'icons/buttons/button_background.png',
      onTap: () {
        if(_isShowBetMenu){
          hideBetMenu();
        }else{
          showBetMenu();
        }
        if(_isShowSettingMenu){
          hideSettingMenu();
        }
      },
    );
    add(_betButton);
  }

  void _initSettingButton(){
    double buttonWidth = 150;
    double buttonHeight = 150;
    double positonX = localCenter.x *0.2-buttonWidth/2;
    double positonY = _bottomControllerCenterY-buttonHeight/2;
    _settingButton = IconButton(
      size: Vector2(buttonWidth, buttonHeight),
      position: Vector2(positonX, positonY),
      iconPath: 'icons/buttons/button_setting.png',
      backgroundImagePath: 'icons/buttons/button_background.png',
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
    _extraMenu = ExtraMenuComponent(
      size: Vector2(buttonWidth, buttonHeight),
      position: Vector2(positonX,positonY),
      onTapSwitch: (isEnable) {
        _global.isEnableExtraBet = isEnable;
        onTapExtraBetSwitch.call(isEnable);
      },
    );
    add(_extraMenu);
  }

  void _initSettingMenu(){
    double buttonWidth = 138;
    double buttonHeight = 404;
    double positonX = _settingButton.position.x + _settingButton.size.x/2 - buttonWidth/2;
    double positonY = _settingButton.y - buttonHeight -30;
    _settingMenu = SettingMenuComponent(
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
    _betMenu = GridTextMenuComponent(
      size: Vector2(buttonWidth, buttonHeight),
      position: Vector2(positonX, positonY),
      defaultGridItems: _currentBetGridItems,
      onSelectCallBack: (gridItems) {
        _currentBetGridItems = gridItems;
        _global.betAmount = int.parse(gridItems.text);
        _betAmount = _global.betAmount.toDouble();
        _betAmountText.text = gridItems.text;
        onTapBetButton.call();
      },
    );
    // _betMenu.isVisible = _isShowBetMenu;
    add(_betMenu);
  }

}

