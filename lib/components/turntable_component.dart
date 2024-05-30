import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';
import 'package:fortune_gems/model/turntable_item_model.dart';


enum TurntableRotateStatus {
  starting,
  speed_up,
  decelerating,
  bounce,
  stopping,
  stopped,

}

class TurntableComponent extends PositionComponent {
  TurntableComponent({super.position,super.anchor ,required this.onCallBack}) : super(size: Vector2(1290, 2796));
  final void Function() onCallBack;


  TurntableRotateStatus _rotateStatus = TurntableRotateStatus.starting;
  late RectangleComponent _backgroundComponent;
  late SpriteComponent _turntable;
  late SpriteComponent _turntableFrame;
  late SpriteComponent _turntableSelectFrame;
  List<TurntableItemModel> _turntableItemList = [];

  static const double _rotationLowSpeedAngle = 1 * 3.14 / 180;
  static const double _rotationHighSpeedAngle = 45 * 3.14 / 180;
  double _currentRollingSpeedAngle = _rotationHighSpeedAngle;

  bool _isBounceForward = false;
  double _bounceRangeStartAngle = 0;
  double _bounceRangeEndAngle = 0;

  late TurntableItemModel _stopTurntableItemModel;
  /// 測試暫時數據
  static const int _turntableItemTotal = 12;//轉盤格數
  static const int _stopItemSerial = 2;//停止轉盤格子編號

  double _waitingTime = 0;

  Future<void> startLottery() async {
    _zoomEffect(
      onZoomOutComplete: () {
        priority = 3;
      },
      onZoomInComplete: () async {
        _showBackgroundComponent();
        // add(RectangleComponent(priority:0,size: size,position: localCenter, anchor: Anchor.center, paint: Paint()..color = Colors.black.withOpacity(0.5)));
        /// 測試暫時數據
        _stopTurntableItemModel = _turntableItemList[_stopItemSerial];
        _bounceRangeStartAngle = _stopTurntableItemModel.startAngle;
        _bounceRangeEndAngle = _stopTurntableItemModel.endAngle;
        await Future.delayed(const Duration(milliseconds: 500));
        _rotateStatus = TurntableRotateStatus.speed_up;
        await Future.delayed(const Duration(seconds: 1));
        _rotateStatus = TurntableRotateStatus.decelerating;
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
    _loadTurntableItemList();
    await _initTurntable();
    await _initTurntableFrame();
    await _initTurntableSelectFrame();
    // _initTurntableItem();
    super.onLoad();
  }
  void _loadTurntableItemList(){

    //每個item 佔據的角度
    double itemAngle = 360/_turntableItemTotal;
    double spacingAngle = itemAngle/2 * 3.14 / 180;

    for(int i = 0 ;i <_turntableItemTotal;i++){
      double centerAngle = itemAngle * i * 3.14 / 180;
      double startAngle  = centerAngle - spacingAngle;
      double endAngle = centerAngle + spacingAngle;
      TurntableItemModel model = TurntableItemModel(serial:i,startAngle: startAngle,endAngle:endAngle,centerAngle:centerAngle);
      _turntableItemList.add(model);
    }
  }
  void initBasicComponent(){
    // _basicComponent = RectangleComponent(size: size,position: localCenter, anchor: Anchor.center, paint: Paint()..color = Colors.black.withOpacity(0.5),);
    // add();
  }

  Future<void> _initTurntable() async {
    _turntable  = SpriteComponent(sprite: await Sprite.load('images/turntable.png'),size: Vector2(1020,1020),anchor: Anchor.center,position: localCenter,priority: 1);
    add(_turntable);
  }

  Future<void> _initTurntableFrame() async {
    _turntableFrame  = SpriteComponent(sprite: await Sprite.load('images/turntable_frame.png'),size: Vector2(1020,1020),anchor: Anchor.center,position: localCenter,priority: 2);
    add(_turntableFrame);
  }

  Future<void> _initTurntableSelectFrame() async {
    _turntableSelectFrame  = SpriteComponent(sprite: await Sprite.load('images/turntable_select_frame.png'),size: Vector2(382.5,685),position: Vector2(localCenter.x,localCenter.y-245),anchor: Anchor.center,priority: 3);
    add(_turntableSelectFrame);
  }


  @override
  void update(double dt) {
    super.update(dt);
    switch(_rotateStatus){
      case TurntableRotateStatus.starting:
        _rotationOffsetAngle(angle: _rotationLowSpeedAngle);
        break;
      case TurntableRotateStatus.speed_up:
        _rotationOffsetAngle(angle: _rotationHighSpeedAngle);
        break;
      case TurntableRotateStatus.decelerating:
        if(_currentRollingSpeedAngle > 0.3){
          _currentRollingSpeedAngle -=0.06;
          _rotationOffsetAngle(angle: _currentRollingSpeedAngle);
        }else{
          _decelerateOffsetAngle(angle: _currentRollingSpeedAngle);
        }
        break;
      case TurntableRotateStatus.bounce:
        double bounceOffset = (_bounceRangeEndAngle-_bounceRangeStartAngle) *0.4;
        if (_isBounceForward) {
          _bounceForwardOffsetAngle(angle: bounceOffset);
        } else {
          _bounceBackOffsetAngle(angle: bounceOffset);
        }
        break;
      case TurntableRotateStatus.stopping:
        _stoppingOffsetAngle(dt: dt);
        break;
      case TurntableRotateStatus.stopped:
        _stopped();
        break;
    }
  }

  void _rotationOffsetAngle({required double angle}){
    if(_turntable.angle >=360 * 3.14 / 180){
      _turntable.angle = 0;
      _turntableFrame.angle = 0;
    }else{
      _turntable.angle += angle;
      _turntableFrame.angle += angle;
    }
  }

  void _decelerateOffsetAngle({required double angle}){
    if(_turntable.angle >= _bounceRangeStartAngle && _turntable.angle <= _bounceRangeEndAngle){
      _rotateStatus  =  TurntableRotateStatus.bounce;
      if(_turntable.angle >=_bounceRangeEndAngle){
        _isBounceForward = false;
      }else{
        _isBounceForward = true;
      }
    }else{
      _rotationOffsetAngle(angle: _currentRollingSpeedAngle);
    }
  }
  void _bounceForwardOffsetAngle({required double angle}){
    if(_turntable.angle >= _bounceRangeEndAngle){
      _bounceRangeStartAngle += 0.04;
      _bounceRangeEndAngle -= 0.04;
      _isBounceForward = false;
      if(_bounceRangeStartAngle>=_stopTurntableItemModel.centerAngle ||
          _bounceRangeEndAngle<= _stopTurntableItemModel.centerAngle){
        _rotateStatus  =  TurntableRotateStatus.stopping;
      }
    }else{
      _turntable.angle += angle;
      _turntableFrame.angle += angle;

    }
  }

  void _bounceBackOffsetAngle({required double angle}){
    if(_turntable.angle <= _bounceRangeStartAngle){
      _bounceRangeStartAngle += 0.04;
      _bounceRangeEndAngle -= 0.04;
      _isBounceForward = true;
      if(_bounceRangeStartAngle>=_stopTurntableItemModel.centerAngle ||
          _bounceRangeEndAngle<= _stopTurntableItemModel.centerAngle){
        _rotateStatus  =  TurntableRotateStatus.stopping;
      }
    }else{
      _turntable.angle -= angle;
      _turntableFrame.angle -= angle;

    }

  }

  Future<void> _stoppingOffsetAngle({required double dt})  async {
    _turntable.angle = _stopTurntableItemModel.centerAngle;
    _waitingTime += dt;
    if(_waitingTime >2){
      _rotateStatus  =  TurntableRotateStatus.stopped;
    }

  }

  void _stopped()  {
    _rotateStatus = TurntableRotateStatus.starting;
    _currentRollingSpeedAngle = _rotationHighSpeedAngle;
    _isBounceForward = true;
    _waitingTime = 0;
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