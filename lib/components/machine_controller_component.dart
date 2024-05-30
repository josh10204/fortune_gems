import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:fortune_gems/widget/machine_cntroller_button.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';

// class MachineControllerComponent extends PositionComponent {
//
//   MachineControllerComponent() : super(anchor: Anchor.center, size: Vector2(154, 147),position: Vector2(100, 0));
//
//   late MachineControllerButton _startButton;
//
//   @override
//   Future<void> onLoad() async {
//     super.onLoad();
//
//     _initStartButton();
//   }
//
//   void _initStartButton(){
//     _startButton = MachineControllerButton(onTap: (){
//
//
//     });
//     add(_startButton);
//
//   }
//
//
// }

class MachineControllerComponent extends RectangleComponent {

  MachineControllerComponent({super.anchor, super.position}) : super( size: Vector2(720, 720),paint: Paint()..color = Colors.white);

  late MachineControllerButton _startButton;

  @override
  Future<void> onLoad() async {


    final scaleEffect = ScaleEffect.to(
      Vector2(1.05,1.05),
      EffectController(duration: 1, reverseDuration: 2,infinite: true,curve: Curves.easeInOut),
    );
    //     final scaleEffect =GlowEffect(
    //       10.0,
    //       EffectController(duration: 1, reverseDuration: 2,infinite: true,curve: Curves.easeInOut),
    //     );
    add(scaleEffect);
    super.onLoad();

  }


}