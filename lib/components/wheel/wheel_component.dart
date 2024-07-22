import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:fortune_gems/components/wheel/wheel_background_component.dart';
import 'package:fortune_gems/components/wheel/wheel_center_logo_component.dart';
import 'package:fortune_gems/components/wheel/wheel_item_component.dart';
import 'package:fortune_gems/components/wheel/wheel_panel_component.dart';
import 'package:fortune_gems/components/wheel/wheel_pointer_component.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';
import 'package:fortune_gems/extension/string_extension.dart';
import 'package:fortune_gems/model/wheel_item_model.dart';
import 'package:fortune_gems/system/global.dart';

enum WheelRotateStatus {
  standby,
  opening,
  wait,
  speedUp,
  decelerating,
  stopping,
  stopped,
}
class WheelComponent extends PositionComponent {
  WheelComponent({super.position,super.anchor }) : super(size: Vector2(900, 1600));


  late Global _global;
  late RectangleComponent _backgroundComponent;
  late WheelBackgroundComponent _wheelBackgroundComponent;
  late WheelPanelComponent _wheelPanelComponent;
  late WheelPointerComponent _wheelPointerComponent;
  late WheelCenterLogoComponent _wheelCenterLogoComponent;
  void Function(double ratioAmount)? _onStopCallBack;
  WheelItemType? _stopWheelItemType;
  WheelAdditionType? _stopWheelAdditionType;


  Future<void> startLottery({required int stopRatio,required int stopExLuckyRatio ,required Function(double ratioAmount) onCallBack}) async {
    _global.gameStatus = GameStatus.startWheel;
    _onStopCallBack = onCallBack;
    _stopWheelItemType = stopRatio.toString().getWheelItemTypeFromRatio;
    _stopWheelAdditionType = stopExLuckyRatio.toString().getWheelAdditionType;
    _startLotteryEffect(
      onFadeOutComplete: () {
        priority = 5;
      },
      onFadeInComplete: () async {
        _showBackgroundComponent();
        _wheelPointerComponent.startLottery(duration: 0.8, onComplete: (){
          _wheelPanelComponent.startLottery(
              stopRatio: stopRatio,
              onStopCallBack: (amount) {
                closeLottery(ratioAmount:amount);
              });
        });

      },
    );
  }
  Future<void> closeLottery({required double ratioAmount}) async {

    _closeLotteryEffect(
      onFadeOutComplete: () {
        priority = 1;
      },
      onFadeInComplete: () {
        _global.gameStatus = GameStatus.stopWheel;
        _onStopCallBack?.call(ratioAmount);
        _wheelPanelComponent.standby();
      },
    );
  }

  void updateBetNumber(){
    _wheelPanelComponent.updateBetNumber();
  }

  void closeExtraEffect(){
    _wheelPanelComponent.closeExtraEffect();
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _global = Global();
    await _initWheelBackgroundComponent();
    await _initWheelPanelComponent();
    await _initWheelPointerComponent();
    await _initWheelCenterLogoComponent();
  }

  Future<void> _initWheelBackgroundComponent() async {
    _wheelBackgroundComponent  = WheelBackgroundComponent(size: Vector2(900,900),position: Vector2(localCenter.x,localCenter.y-180),anchor: Anchor.center);
    _wheelBackgroundComponent.priority = 1;
    add(_wheelBackgroundComponent);
  }

  Future<void> _initWheelPanelComponent() async{
    _wheelPanelComponent = WheelPanelComponent(
        size: Vector2(900, 900),
        anchor: Anchor.center,
        position: Vector2(localCenter.x, localCenter.y - 180));
    _wheelPanelComponent.priority = 1;
    add(_wheelPanelComponent);
  }

  Future<void> _initWheelPointerComponent() async {
    _wheelPointerComponent  = WheelPointerComponent(size: Vector2(280,490),position: Vector2(localCenter.x,localCenter.y-380),anchor: Anchor.center);
    _wheelPointerComponent.priority = 3;
    add(_wheelPointerComponent);
  }

  Future<void> _initWheelCenterLogoComponent() async {
    _wheelCenterLogoComponent  = WheelCenterLogoComponent(size: Vector2(180,180),position: Vector2(localCenter.x,localCenter.y- 180),anchor: Anchor.center);
    _wheelCenterLogoComponent.priority = 4;
    add(_wheelCenterLogoComponent);
  }

  void _showBackgroundComponent() {
    _backgroundComponent = RectangleComponent(size: size,position: localCenter, anchor: Anchor.center, paint: Paint()..color = Colors.black.withOpacity(0.5),);
    add(_backgroundComponent);
  }
  void _hideBackgroundComponent() {
    remove(_backgroundComponent);
  }


  Future<void> _startLotteryEffect({required Function() onFadeOutComplete,required Function() onFadeInComplete}) async {

    _startFadeOutEffect(oComplete: (){
      onFadeOutComplete.call();
      _startFadeInEffect(onComplete: onFadeInComplete);
    });
  }
  Future<void> _startFadeOutEffect({required Function() oComplete}) async {

    add(ScaleEffect.to(Vector2(0,0), EffectController(duration:0.5), onComplete: (){}));
    _wheelPanelComponent.startFadeOut(duration: 0.5, onComplete: (){});
    _wheelBackgroundComponent.startFadeOut(duration: 0.5, onComplete: (){});
    _wheelCenterLogoComponent.startFadeOut(duration: 0.5, onComplete: (){});
    _wheelPointerComponent.startFadeOut(duration: 0.5, onComplete: oComplete);
  }

  Future<void> _startFadeInEffect({required Function() onComplete}) async {

    add(ScaleEffect.to(Vector2(1,1), EffectController(duration:0.01), onComplete: (){}));
    _wheelCenterLogoComponent.startFadeIn(duration: 1.5, onComplete: (){});
    await Future.delayed(const Duration(milliseconds: 600));
    _wheelBackgroundComponent.startFadeIn(duration: 0.8, onComplete: (){});
    _wheelPanelComponent.startFadeIn(duration: 0.8, onComplete:(){});
    _wheelPointerComponent.startFadeIn(duration: 0.8, onComplete:(){
      _wheelPanelComponent.openExtraEffect(duration: 0.8, stopWheelItemType:_stopWheelItemType??WheelItemType.item1x ,additionType:_stopWheelAdditionType?? WheelAdditionType.addition1x, onComplete: onComplete);
    });


  }


  Future<void> _closeLotteryEffect({required Function() onFadeOutComplete,required Function() onFadeInComplete}) async {

    _closeFadeOutEffect(oComplete: () async {
      onFadeOutComplete.call();
      _closeFadeInEffect(oComplete: onFadeInComplete);
    });
  }

  Future<void> _closeFadeOutEffect({required Function() oComplete}) async {

    _wheelPointerComponent.closeFadeOut(duration: 0.8, onComplete:()  {
      _wheelCenterLogoComponent.closeFadeOut(duration: 0.5, onComplete: () async {
        _hideBackgroundComponent();
        await Future.delayed(const Duration(milliseconds: 500));
        add(ScaleEffect.to(Vector2(0,0), EffectController(duration:0.5), onComplete: oComplete));
      });
    });
  }

  Future<void> _closeFadeInEffect({required Function() oComplete}) async {

    add(ScaleEffect.to(Vector2(1,1), EffectController(duration:1.2,curve: Curves.elasticInOut), onComplete: oComplete));
  }
}
