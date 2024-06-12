import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';
import 'package:fortune_gems/model/wheel_item_model.dart';


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
  late SpriteComponent _wheel;
  late SpriteComponent _wheelFrame;
  late SpriteComponent _wheelSelectFrame;
  List<WheelItemModel> _wheelItemList = [];

  static const double _rotationLowSpeedAngle = 1 * 3.14 / 180;
  static const double _rotationHighSpeedAngle = 45 * 3.14 / 180;
  double _currentRollingSpeedAngle = _rotationHighSpeedAngle;

  bool _isBounceForward = false;
  double _bounceRangeStartAngle = 0;
  double _bounceRangeEndAngle = 0;

  late WheelItemModel _stopWheelItemModel;
  /// 測試暫時數據
  static const int _wheelItemTotal = 12;//轉盤格數
  static const int _stopItemSerial = 2;//停止轉盤格子編號

  Timer _waitUpdateTimer = Timer(1);

  Future<void> startLottery() async {
    _zoomEffect(
      onZoomOutComplete: () {
        priority = 4;
      },
      onZoomInComplete: () async {
        _showBackgroundComponent();
        // add(RectangleComponent(priority:0,size: size,position: localCenter, anchor: Anchor.center, paint: Paint()..color = Colors.black.withOpacity(0.5)));
        /// 測試暫時數據
        _stopWheelItemModel = _wheelItemList[_stopItemSerial];
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

  @override
  Future<void> onLoad() async {
    _loadWheelItemList();
    await _initWheel();
    await _initWheelFrame();
    await _initWheelSelectFrame();
    // _initWheelItem();
    super.onLoad();
  }

  void _loadWheelItemList(){
    //每個item 佔據的角度
    double itemAngle = 360/_wheelItemTotal;
    double spacingAngle = itemAngle/2 * 3.14 / 180;

    for(int i = 0 ;i <_wheelItemTotal;i++){
      double centerAngle = itemAngle * i * 3.14 / 180;
      double startAngle  = centerAngle - spacingAngle;
      double endAngle = centerAngle + spacingAngle;
      WheelItemModel model = WheelItemModel(serial:i,startAngle: startAngle,endAngle:endAngle,centerAngle:centerAngle);
      _wheelItemList.add(model);
    }
  }
  void initBasicComponent(){
    // _basicComponent = RectangleComponent(size: size,position: localCenter, anchor: Anchor.center, paint: Paint()..color = Colors.black.withOpacity(0.5),);
    // add();
  }

  Future<void> _initWheel() async {
    _wheel  = SpriteComponent(sprite: await Sprite.load('images/wheel.png'),size: Vector2(1020,1020),anchor: Anchor.center,position: localCenter,priority: 1);
    add(_wheel);
  }

  Future<void> _initWheelFrame() async {
    _wheelFrame  = SpriteComponent(sprite: await Sprite.load('images/wheel_frame.png'),size: Vector2(1020,1020),anchor: Anchor.center,position: localCenter,priority: 2);
    add(_wheelFrame);
  }

  Future<void> _initWheelSelectFrame() async {
    _wheelSelectFrame  = SpriteComponent(sprite: await Sprite.load('images/wheel_select_frame.png'),size: Vector2(382.5,685),position: Vector2(localCenter.x,localCenter.y-245),anchor: Anchor.center,priority: 3);
    add(_wheelSelectFrame);
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
    if(_wheel.angle >=360 * 3.14 / 180){
      _wheel.angle = 0;
      _wheelFrame.angle = 0;
    }else{
      _wheel.angle += angle;
      _wheelFrame.angle += angle;
    }
  }

  void _decelerateOffsetAngle({required double angle}){
    if(_wheel.angle >= _bounceRangeStartAngle && _wheel.angle <= _bounceRangeEndAngle){
      _rotateStatus  =  WheelRotateStatus.bounce;
      if(_wheel.angle >=_bounceRangeEndAngle){
        _isBounceForward = false;
      }else{
        _isBounceForward = true;
      }
    }else{
      _rotationOffsetAngle(angle: _currentRollingSpeedAngle);
    }
  }
  void _bounceForwardOffsetAngle({required double angle}){
    if(_wheel.angle >= _bounceRangeEndAngle){
      _bounceRangeStartAngle += 0.04;
      _bounceRangeEndAngle -= 0.04;
      _isBounceForward = false;
      if(_bounceRangeStartAngle>=_stopWheelItemModel.centerAngle ||
          _bounceRangeEndAngle<= _stopWheelItemModel.centerAngle){
        _rotateStatus  =  WheelRotateStatus.stopping;
      }
    }else{
      _wheel.angle += angle;
      _wheelFrame.angle += angle;

    }
  }

  void _bounceBackOffsetAngle({required double angle}){
    if(_wheel.angle <= _bounceRangeStartAngle){
      _bounceRangeStartAngle += 0.04;
      _bounceRangeEndAngle -= 0.04;
      _isBounceForward = true;
      if(_bounceRangeStartAngle>=_stopWheelItemModel.centerAngle ||
          _bounceRangeEndAngle<= _stopWheelItemModel.centerAngle){
        _rotateStatus  =  WheelRotateStatus.stopping;
      }
    }else{
      _wheel.angle -= angle;
      _wheelFrame.angle -= angle;

    }

  }

  Future<void> _stoppingOffsetAngle({required double dt})  async {
    _wheel.angle = _stopWheelItemModel.centerAngle;
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
}