import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:fortune_gems/components/wheel/wheel_item.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';
import 'package:fortune_gems/extension/string_extension.dart';
import 'package:fortune_gems/model/wheel_item_model.dart';
import 'package:fortune_gems/system/global.dart';

enum WheelRotateStatus {
  opening,
  starting,
  speedUp,
  decelerating,
  stopping,
  stopped,
  still,
}
class WheelComponent extends PositionComponent {
  WheelComponent({super.position,super.anchor }) : super(size: Vector2(1290, 2796));


  late Global _global;
  WheelRotateStatus _rotateStatus = WheelRotateStatus.starting;
  late RectangleComponent _backgroundComponent;
  late PositionComponent _basicWheel;
  late SpriteComponent _wheel;
  late SpriteComponent _wheelFrame;
  late SpriteComponent _wheelSelectFrame;
  late SpriteComponent _wheelCenterLogo;
  Function(double ratioAmount)? _onStopCallBack;
  // final List<WheelItemType> _wheelItemList = WheelItemType.values;
  List<WheelItem> _wheelItemList = [];

  static const double _rotationLowSpeedAngle = 0.15 * 3.14 / 180;
  static const double _rotationHighSpeedRatio = 25;
  static const double _rotationHighSpeedAngle = _rotationHighSpeedRatio * 3.14 / 180;
  double _rotationSpeedRatio= 0.1;
  double _currentRollingSpeedAngle = _rotationHighSpeedAngle;
  bool _isPassedDecelerateLine = false;
  late WheelItemType _stopWheelItemType;

  late WheelItemType _decelerateWheelItemType;

  double _stopRatioAmount = 0;


  Timer _waitUpdateTimer = Timer(1);

  Future<void> startLottery({required int stopRatio ,required Function(double ratioAmount) onCallBack}) async {
    _global.gameStatus = GameStatus.startWheel;
    _onStopCallBack = onCallBack;
    _rotateStatus = WheelRotateStatus.opening;

    _zoomEffect(
      onFadeOutComplete: () {
        priority = 5;
      },
      onFadeInComplete: () async {
        _showBackgroundComponent();
        _rotateStatus = WheelRotateStatus.starting;
        _stopWheelItemType =  stopRatio.toString().getWheelItemTypeFromRatio;
        _stopRatioAmount = _global.betAmount.toDouble()*_stopWheelItemType.ratio;
        int index = WheelItemType.values.indexOf(_stopWheelItemType);
        _decelerateWheelItemType = WheelItemType.values[(index+3)% WheelItemType.values.length];
        await Future.delayed(const Duration(milliseconds: 500));
        _rotateStatus = WheelRotateStatus.speedUp;
        await Future.delayed(const Duration(seconds: 5));
        _rotateStatus = WheelRotateStatus.decelerating;
        await Future.delayed(const Duration(seconds: 1));
      },
    );
  }

  Future<void> stopLottery() async {}

  void updateBetNumber(){
    double number = _global.betAmount.toDouble();
    for(WheelItem item in _wheelItemList){
      item.updateBetNumber(number);
    }
  }

  @override
  Future<void> onLoad() async {
    _global = Global();
    _initBasicWheel();
    await _initWheel();
    await _initWheelFrame();
    await _initWheelSelectFrame();
    await _initWheelCenterLogo();
    _initWheelItem();
    super.onLoad();
  }

  void _initBasicWheel(){
    _basicWheel = PositionComponent(size:Vector2(1142,1142),anchor: Anchor.center,position: localCenter,priority: 1);
    add(_basicWheel);
  }

  Future<void> _initWheel() async {
    _wheel  = SpriteComponent(sprite: await Sprite.load('images/wheel.png'),size: Vector2(1142,1142),priority: 1);
    _basicWheel.add(_wheel);
  }

  Future<void> _initWheelFrame() async {
    _wheelFrame  = SpriteComponent(sprite: await Sprite.load('images/wheel_frame.png'),size: Vector2(1142,1142),priority: 1);
    _basicWheel.add(_wheelFrame);
  }

  Future<void> _initWheelSelectFrame() async {
    _wheelSelectFrame  = SpriteComponent(sprite: await Sprite.load('images/wheel_select_frame.png'),size: Vector2(397.8,712.4),position: Vector2(localCenter.x,localCenter.y-290),anchor: Anchor.center,priority: 3);
    add(_wheelSelectFrame);
  }

  Future<void> _initWheelCenterLogo() async {
    _wheelCenterLogo  = SpriteComponent(sprite: await Sprite.load('images/wheel_center_logo.png'),size: Vector2(248,248),position: localCenter,anchor: Anchor.center,priority: 4);
    add(_wheelCenterLogo);
  }


  void _initWheelItem(){

    for(WheelItemType itemType in WheelItemType.values){
      WheelItem item = WheelItem(type: itemType,betAmount:_global.betAmount  ,basicCenter: _basicWheel.localCenter);
      item.priority = 2;
      _wheelItemList.add(item);
      _basicWheel.add(item);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    switch(_rotateStatus){
      case WheelRotateStatus.opening:
        _basicWheel.angle = 0;
        _rotateStatus = WheelRotateStatus.still;
        break;
      case WheelRotateStatus.starting:
        _rotationOffsetAngle(angle: _rotationLowSpeedAngle);
        break;
      case WheelRotateStatus.speedUp:

        _currentRollingSpeedAngle = _rotationSpeedRatio * 3.14 / 180;
        if(_currentRollingSpeedAngle < _rotationHighSpeedAngle){
          _rotationSpeedRatio += 0.1;
          _rotationOffsetAngle(angle: _currentRollingSpeedAngle);
        }else{
          _currentRollingSpeedAngle = _rotationHighSpeedAngle;
          _rotationOffsetAngle(angle:_rotationHighSpeedAngle);
        }
        break;
      case WheelRotateStatus.decelerating:
        if(_currentRollingSpeedAngle >0.2){
          _rotationSpeedRatio -= 0.1;
          _currentRollingSpeedAngle = _rotationSpeedRatio * 3.14 / 180;
          _rotationOffsetAngle(angle: _currentRollingSpeedAngle);
        }else{
          _decelerateOffsetAngle(angle: _currentRollingSpeedAngle);
        }
        break;
      case WheelRotateStatus.stopping:
        _stoppingOffsetAngle(dt: dt);
        break;
      case WheelRotateStatus.stopped:
        _stopped();
        break;
      case WheelRotateStatus.still:
        break;
    }
  }

  void _rotationOffsetAngle({required double angle}){
    if(_basicWheel.angle >=360 * 3.14 / 180){
      _basicWheel.angle = 0;
    }else{
      _basicWheel.angle += angle;
    }
  }

  void _decelerateOffsetAngle({required double angle}){
    if (_isPassedDecelerateLine == false) {

      if (_basicWheel.angle > _decelerateWheelItemType.centerAngle && _basicWheel.angle <= _decelerateWheelItemType.endAngle) {
        _isPassedDecelerateLine = true;
      }
      _rotationOffsetAngle(angle: _currentRollingSpeedAngle);
    } else {
      if (_basicWheel.angle < _stopWheelItemType.centerAngle+0.02 && _basicWheel.angle >= _stopWheelItemType.centerAngle -0.02) {
        _rotateStatus = WheelRotateStatus.stopping;
      } else {
        if (_currentRollingSpeedAngle > 0.1) {
          _currentRollingSpeedAngle -= 0.005;
        }else if(_currentRollingSpeedAngle > 0.03 && _currentRollingSpeedAngle < 0.1){
          _currentRollingSpeedAngle -= 0.0015;
        }else{
          _currentRollingSpeedAngle = 0.03;
        }
        _rotationOffsetAngle(angle: _currentRollingSpeedAngle);
      }
    }
  }

  Future<void> _stoppingOffsetAngle({required double dt})  async {
    _basicWheel.angle = _stopWheelItemType.centerAngle;
    _waitUpdateTimer.update(dt);
    if (_waitUpdateTimer.finished) {
      _rotateStatus  =  WheelRotateStatus.stopped;
      _waitUpdateTimer = Timer(1);
    }
  }

  void _stopped()  {
    _rotateStatus = WheelRotateStatus.starting;
    _currentRollingSpeedAngle = _rotationHighSpeedAngle;
    _isPassedDecelerateLine = false;
    _hideBackgroundComponent();
    _zoomEffect(
      onFadeOutComplete: () {
        priority = 1;
      },
      onFadeInComplete: () {
        _global.gameStatus = GameStatus.stopWheel;
        _onStopCallBack?.call(_stopRatioAmount);
      },
    );
    // _hideBackgroundComponent();

  }


  Future<void> _zoomEffect({required Function() onFadeOutComplete,required Function() onFadeInComplete}) async {

    _fadeOutEffect(oComplete: onFadeOutComplete);
    await Future.delayed(const Duration(milliseconds: 400));
    _fadeInEffect(oComplete: onFadeInComplete);

  }
  Future<void> _fadeOutEffect({required Function() oComplete}) async {
    for(WheelItem item in _wheelItemList){
      item.closeEffect();
    }
    ScaleEffect scaleDownEffect = ScaleEffect.to(
        Vector2(0,0),
        EffectController(duration:0.4,curve: Curves.easeInOut),
        onComplete: (){
          oComplete.call();
        }
    );
    add(scaleDownEffect);
  }

  Future<void> _fadeInEffect({required Function() oComplete}) async {
    for(WheelItem item in _wheelItemList){
      item.openEffect();
    }
    // RotateEffect rotateEffect = RotateEffect.to(
    //   180 * 3.14 / 180,
    //   EffectController(duration: 0.8),
    // );
    // _basicWheel.add(rotateEffect);

    ScaleEffect scaleUpEffect = ScaleEffect.to(
        Vector2(1.5,1.5),
        EffectController(duration:0.5,curve: Curves.easeInOut,),
        onComplete: (){
        }
    );

    ScaleEffect scaleBackEffect = ScaleEffect.to(
        Vector2(1,1),
        EffectController(duration:0.5,curve: Curves.easeInOut,),
        onComplete: (){
          oComplete.call();
        }
    );
    SequenceEffect effectSequence = SequenceEffect([
      scaleUpEffect,
      scaleBackEffect
    ]);
    add(effectSequence);
  }

  void _showBackgroundComponent() {
    _backgroundComponent = RectangleComponent(size: size,position: localCenter, anchor: Anchor.center, paint: Paint()..color = Colors.black.withOpacity(0.5),);
    add(_backgroundComponent);
  }
  void _hideBackgroundComponent() {
    remove(_backgroundComponent);
  }

}
