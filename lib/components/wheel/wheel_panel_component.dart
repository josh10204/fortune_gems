import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:fortune_gems/components/wheel/wheel_component.dart';
import 'package:fortune_gems/components/wheel/wheel_item_component.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';
import 'package:fortune_gems/extension/string_extension.dart';
import 'package:fortune_gems/model/rolller_symbol_model.dart';
import 'package:fortune_gems/model/wheel_item_model.dart';
import 'package:fortune_gems/system/global.dart';


class WheelPanelComponent extends PositionComponent {

  WheelPanelComponent({
    super.size,
    super.position,
    super.anchor,
  });


  void Function(double ratioAmount)? _onStopCallBack;


  late Global _global;
  late SpriteComponent _wheelPanel;
  late SpriteComponent _wheelFrame;
  late WheelItemType _stopWheelItemType;
  late WheelItemType _decelerateWheelItemType;

  WheelRotateStatus _rotateStatus = WheelRotateStatus.standby;

  List<WheelItemComponent> _wheelItemList = [];
  static const double _rotationLowSpeedAngle = 0.15 * 3.14 / 180;
  static const double _rotationHighSpeedRatio = 25;
  static const double _rotationHighSpeedAngle = _rotationHighSpeedRatio * 3.14 / 180;
  double _rotationSpeedRatio= 0.1;
  double _currentRollingSpeedAngle = _rotationHighSpeedAngle;
  bool _isPassedDecelerateLine = false;
  double _stopRatioAmount = 0;
  Timer _waitUpdateTimer = Timer(1);

  void startFadeOut({required double duration,required Function() onComplete}){
    _rotateStatus = WheelRotateStatus.opening;
    for(WheelItemComponent item in _wheelItemList){item.closeEffect();}
    ScaleEffect scaleDownEffect = ScaleEffect.to(Vector2(0,0), EffectController(duration:duration), onComplete: (){});
    add(scaleDownEffect);

  }
  void startFadeIn({required double duration,required Function() onComplete}){
    _rotateStatus = WheelRotateStatus.wait;
    for(WheelItemComponent item in _wheelItemList){item.openEffect();}
    ScaleEffect scaleUpEffect = ScaleEffect.to(
        Vector2(1.5,1.5),
        EffectController(duration:duration*0.6,curve: Curves.easeInOut,)
    );

    ScaleEffect scaleBackEffect = ScaleEffect.to(
      Vector2(1,1),
      EffectController(duration:duration*0.4,curve: Curves.easeInOut,),
    );
    SequenceEffect effectSequence = SequenceEffect([
      scaleUpEffect,
      scaleBackEffect
    ]);

    RotateEffect rotateEffect = RotateEffect.to(
      120 * 3.14 / 180,
      EffectController(duration: duration),
      onComplete: onComplete,
    );
    add(effectSequence);
    add(rotateEffect);


  }
  void closeFadeOut({required double duration,required Function() onComplete}){}
  void closeFadeIn({required double duration,required Function() onComplete}){}

  Future<void> openExtraEffect({required double duration,required WheelItemType stopWheelItemType,required WheelAdditionType additionType,required Function() onComplete}) async {

    if(_global.isEnableExtraBet == false){
      onComplete.call();
    }else{

      // 將要停止的Item 先放入 顯示 Ex 效果列表
      List<WheelItemComponent> itemComponent = _wheelItemList.where((item)=> item.type == stopWheelItemType ).toList();
      int stopIndex = _wheelItemList.indexOf(itemComponent[0]);
      Set<int> exIndexSet = {};
      exIndexSet.add(stopIndex);
      //隨機取出 6 個 Item，放入顯示 Ex 效果列表
      Random random = Random();
      while (exIndexSet.length < 7) {
        exIndexSet.add(random.nextInt(_wheelItemList.length));
      }

      // 依序顯示 Ex 效果動畫
      List<int> exItemIndexList = exIndexSet.toList();
      for(int index in exItemIndexList ){
        WheelAdditionType? type = index == stopIndex ? additionType : null;
        await _wheelItemExtraEffect(type,index);
      }
      onComplete.call();
    }
  }

  void closeExtraEffect(){
    for(WheelItemComponent itemComponent in _wheelItemList){
      itemComponent.closeExtraEffect();
    }

  }
  void updateBetNumber(){
    double number = _global.betAmount.toDouble();
    for(WheelItemComponent item in _wheelItemList){
      item.updateBetNumber(number);
    }
  }

  Future<void> startLottery({required int stopRatio ,required Function(double ratioAmount) onStopCallBack}) async {
    _onStopCallBack = onStopCallBack;
    _rotateStatus = WheelRotateStatus.wait;
    _stopWheelItemType =  stopRatio.toString().getWheelItemTypeFromRatio;
    _stopRatioAmount = _global.betAmount.toDouble()*_stopWheelItemType.ratio;
    int index = WheelItemType.values.indexOf(_stopWheelItemType);
    _decelerateWheelItemType = WheelItemType.values[(index+2)% WheelItemType.values.length];
    await Future.delayed(const Duration(milliseconds: 500));
    _rotateStatus = WheelRotateStatus.speedUp;
    await Future.delayed(const Duration(seconds: 5));
    _rotateStatus = WheelRotateStatus.decelerating;

  }

  void standby(){
    _currentRollingSpeedAngle = _rotationHighSpeedAngle;
    _isPassedDecelerateLine = false;
    _rotateStatus = WheelRotateStatus.standby;
  }

  @override
  void onLoad() async {
    super.onLoad();
    _global = Global();
    _initWheel();
    _initWheelFrame();
    _initWheelItem();

  }

  Future<void> _initWheel() async {
    _wheelPanel = SpriteComponent(sprite: await Sprite.load('images/wheel.png'),size: size,priority: 0);
    add(_wheelPanel);
  }

  Future<void> _initWheelFrame() async {
    _wheelFrame  = SpriteComponent(sprite: await Sprite.load('images/wheel_frame.png'),size: size,priority: 1);
    add(_wheelFrame);
  }

  Future<void> _initWheelItem() async{

    for(WheelItemType itemType in WheelItemType.values){
      WheelItemComponent item = WheelItemComponent(type: itemType,betAmount:_global.betAmount  ,basicCenter: localCenter);
      item.priority = 2;
      _wheelItemList.add(item);
      add(item);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    switch(_rotateStatus){
      case WheelRotateStatus.standby:
        _rotationOffsetAngle(angle: _rotationLowSpeedAngle);
        break;

      case WheelRotateStatus.opening:
        break;

      case WheelRotateStatus.wait:
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
          _decelerateOffsetAngle();
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
    if(this.angle >=360 * 3.14 / 180){
      this.angle = 0;
    }else{
      this.angle += angle;
    }
  }

  void _decelerateOffsetAngle(){
    if (_isPassedDecelerateLine == false) {
      if (angle > _decelerateWheelItemType.centerAngle && angle <= _decelerateWheelItemType.endAngle) {
        _isPassedDecelerateLine = true;
      }
      _rotationOffsetAngle(angle: _currentRollingSpeedAngle);
    } else {
      if (angle < _stopWheelItemType.centerAngle+0.02 && angle >= _stopWheelItemType.centerAngle -0.02) {
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
    angle = _stopWheelItemType.centerAngle;
    _waitUpdateTimer.update(dt);
    if (_waitUpdateTimer.finished) {
      _rotateStatus  =  WheelRotateStatus.stopped;
      _waitUpdateTimer = Timer(1);
    }
  }

  void _stopped()  {
    _onStopCallBack?.call(_stopRatioAmount);
    _rotateStatus  =  WheelRotateStatus.wait;
  }

  Future<void> _wheelItemExtraEffect( WheelAdditionType? additionType ,int exIndex) {
    final completer = Completer<void>();
    WheelItemComponent item = _wheelItemList[exIndex];
    item.openExtraEffect(
        additionType: additionType ,
        onComplete: () {
          completer.complete();
        });
    return completer.future;
  }


}
