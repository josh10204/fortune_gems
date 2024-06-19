import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:fortune_gems/components/wheel/wheel_item.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';

enum WheelRotateStatus {
  starting,
  speedUp,
  decelerating,
  bounce,
  stopping,
  stopped,

}
class WheelComponent extends PositionComponent {
  WheelComponent({super.position,super.anchor ,required this.onCallBack}) : super(size: Vector2(1290, 2796));
  final void Function() onCallBack;


  WheelRotateStatus _rotateStatus = WheelRotateStatus.starting;
  late RectangleComponent _backgroundComponent;
  late PositionComponent _basicWheel;
  late SpriteComponent _wheel;
  late SpriteComponent _wheelFrame;
  late SpriteComponent _wheelSelectFrame;
  // final List<WheelItemType> _wheelItemList = WheelItemType.values;
  List<WheelItem> _wheelItemList = [];

  static const double _rotationLowSpeedAngle = 0.3 * 3.14 / 180;
  static const double _rotationHighSpeedAngle = 45 * 3.14 / 180;
  double _currentRollingSpeedAngle = _rotationHighSpeedAngle;

  bool _isBounceForward = false;
  double _bounceRangeStartAngle = 0;
  double _bounceRangeEndAngle = 0;

  late WheelItemType _stopWheelItemModel;

  /// 測試暫時數據
  static const int _stopItemSerial = 2;//停止轉盤格子編號

  Timer _waitUpdateTimer = Timer(1);

  Future<void> startLottery() async {
    _zoomEffect(
      onZoomOutComplete: () {
        priority = 4;
      },
      onZoomInComplete: () async {
        _showBackgroundComponent();
        /// 測試暫時數據
        _stopWheelItemModel =  WheelItemType.values[_stopItemSerial];
        _bounceRangeStartAngle = _stopWheelItemModel.startAngle;
        _bounceRangeEndAngle = _stopWheelItemModel.endAngle;
        await Future.delayed(const Duration(milliseconds: 500));
        _rotateStatus = WheelRotateStatus.speedUp;
        await Future.delayed(const Duration(seconds: 1));
        _rotateStatus = WheelRotateStatus.decelerating;
        await Future.delayed(const Duration(seconds: 1));
      },
    );
  }

  Future<void> stopLottery() async {

  }

  void updateBetNumber(double number){
    for(WheelItem item in _wheelItemList){
      item.updateBetNumber(number);
    }
  }

  @override
  Future<void> onLoad() async {
    _initBasicWheel();
    await _initWheel();
    await _initWheelFrame();
    await _initWheelSelectFrame();
    _initWheelItem();
    super.onLoad();
  }

  void _initBasicWheel(){
    _basicWheel = PositionComponent(size:Vector2(1020,1020),anchor: Anchor.center,position: localCenter,priority: 1);
    add(_basicWheel);
  }

  Future<void> _initWheel() async {
    _wheel  = SpriteComponent(sprite: await Sprite.load('images/wheel.png'),size: Vector2(1020,1020),priority: 1);
    _basicWheel.add(_wheel);
  }

  Future<void> _initWheelFrame() async {
    _wheelFrame  = SpriteComponent(sprite: await Sprite.load('images/wheel_frame.png'),size: Vector2(1020,1020),priority: 1);
    _basicWheel.add(_wheelFrame);
  }

  Future<void> _initWheelSelectFrame() async {
    _wheelSelectFrame  = SpriteComponent(sprite: await Sprite.load('images/wheel_select_frame.png'),size: Vector2(382.5,685),position: Vector2(localCenter.x,localCenter.y-245),anchor: Anchor.center,priority: 3);
    add(_wheelSelectFrame);
  }


  void _initWheelItem(){

    for(WheelItemType itemType in WheelItemType.values){
      WheelItem item = WheelItem(type: itemType,betNumber: 1 );
      double theta = itemType.numberPositionAngle; // 將角度轉為弧度
      double radius = min(_wheel.localCenter.x, _wheel.localCenter.y);
      double positionX = _wheel.localCenter.x + radius * 0.7 * cos(theta); // 調整0.7以確保數字在扇區內
      double positionY = _wheel.localCenter.y + radius * 0.7 * sin(theta);
      item.position = Vector2(positionX,positionY);
      item.angle = itemType.numberAngle;
      item.priority = 2;
      _wheelItemList.add(item);
      _basicWheel.add(item);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    switch(_rotateStatus){
      case WheelRotateStatus.starting:
        _rotationOffsetAngle(angle: _rotationLowSpeedAngle);
        break;
      case WheelRotateStatus.speedUp:
        _rotationOffsetAngle(angle: _rotationHighSpeedAngle);
        break;
      case WheelRotateStatus.decelerating:
        if(_currentRollingSpeedAngle > 0.3){
          _currentRollingSpeedAngle -=0.06;
          _rotationOffsetAngle(angle: _currentRollingSpeedAngle);
        }else{
          _decelerateOffsetAngle(angle: _currentRollingSpeedAngle);
        }
        break;
      case WheelRotateStatus.bounce:
        double bounceOffset = (_bounceRangeEndAngle-_bounceRangeStartAngle) *0.4;
        if (_isBounceForward) {
          _bounceForwardOffsetAngle(angle: bounceOffset);
        } else {
          _bounceBackOffsetAngle(angle: bounceOffset);
        }
        break;
      case WheelRotateStatus.stopping:
        _stoppingOffsetAngle(dt: dt);
        break;
      case WheelRotateStatus.stopped:
        _stopped();
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
    if(_basicWheel.angle >= _bounceRangeStartAngle && _basicWheel.angle <= _bounceRangeEndAngle){
      _rotateStatus  =  WheelRotateStatus.bounce;
      if(_basicWheel.angle >=_bounceRangeEndAngle){
        _isBounceForward = false;
      }else{
        _isBounceForward = true;
      }
    }else{
      _rotationOffsetAngle(angle: _currentRollingSpeedAngle);
    }
  }
  void _bounceForwardOffsetAngle({required double angle}){
    if(_basicWheel.angle >= _bounceRangeEndAngle){
      _bounceRangeStartAngle += 0.04;
      _bounceRangeEndAngle -= 0.04;
      _isBounceForward = false;
      if(_bounceRangeStartAngle>=_stopWheelItemModel.centerAngle ||
          _bounceRangeEndAngle<= _stopWheelItemModel.centerAngle){
        _rotateStatus  =  WheelRotateStatus.stopping;
      }
    }else{
      _basicWheel.angle += angle;

    }
  }

  void _bounceBackOffsetAngle({required double angle}){
    if(_basicWheel.angle <= _bounceRangeStartAngle){
      _bounceRangeStartAngle += 0.04;
      _bounceRangeEndAngle -= 0.04;
      _isBounceForward = true;
      if(_bounceRangeStartAngle>=_stopWheelItemModel.centerAngle ||
          _bounceRangeEndAngle<= _stopWheelItemModel.centerAngle){
        _rotateStatus  =  WheelRotateStatus.stopping;
      }
    }else{
      _basicWheel.angle -= angle;

    }

  }

  Future<void> _stoppingOffsetAngle({required double dt})  async {
    _basicWheel.angle = _stopWheelItemModel.centerAngle;
    _waitUpdateTimer.update(dt);
    if (_waitUpdateTimer.finished) {
      _rotateStatus  =  WheelRotateStatus.stopped;
      _waitUpdateTimer = Timer(1);
    }
  }

  void _stopped()  {
    _rotateStatus = WheelRotateStatus.starting;
    _currentRollingSpeedAngle = _rotationHighSpeedAngle;
    _isBounceForward = true;
    _hideBackgroundComponent();
    _zoomEffect(
      onZoomOutComplete: () {
        priority = 1;
      },
      onZoomInComplete: () {
        onCallBack.call();
      },
    );
    // _hideBackgroundComponent();

  }


  void _zoomEffect({required Function() onZoomOutComplete,required Function() onZoomInComplete}){
    ScaleEffect scaleDownEffect = ScaleEffect.to(
        Vector2(0,0),
        EffectController(duration:0.4,curve: Curves.easeInOut),
        onComplete: (){
          onZoomOutComplete.call();
        }
    );
    ScaleEffect scaleUpEffect = ScaleEffect.to(
        Vector2(1,1),
        EffectController(duration:0.1,curve: Curves.easeInOut,),
        onComplete: (){
          onZoomInComplete.call();
        }
    );

    SequenceEffect effectSequence = SequenceEffect([
      scaleDownEffect,
      scaleUpEffect
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
