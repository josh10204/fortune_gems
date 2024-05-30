
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flutter/animation.dart';
import 'package:fortune_gems/components/header_component.dart';
import 'package:fortune_gems/components/machine_component.dart';
import 'package:fortune_gems/components/turntable_component.dart';


class GameMain extends FlameGame{

  late HeaderComponent _headerComponent;
  late MachineComponent _machineComponent;
  late TurntableComponent _turntableComponent;

  // late SlotMachineStartButton startButton;

  GameMain() : super(camera: CameraComponent.withFixedResolution(width: 1290, height:2796)) {
    // pauseWhenBackgrounded = false;
    // debugMode = true;

  }


  void _presentTurntable(){
    _turntableComponent.startLottery();
    _machineComponent.updateEnableRoller(false);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // camera.viewport.anchor = Anchor.center;
    // world.add(RectangleComponent(
    //     size: Vector2(1280,720), anchor: Anchor.center, paint: Paint()..color = Colors.white.withOpacity(0)));
    // initStartButton();

    _initHeaderComponents();
    _initTurntableComponent();
    _initMachine();


  }

  void _initHeaderComponents(){

    _headerComponent = HeaderComponent();
    _headerComponent.priority = 0;
    world.add(_headerComponent);

  }
  void _initMachine()  {
    _machineComponent  = MachineComponent(onCallBack: (){
      _presentTurntable();
    });
    _machineComponent.priority = 2;

    world.add(_machineComponent);
  }

  void _initTurntableComponent(){
    _turntableComponent = TurntableComponent(anchor: Anchor.center,position: Vector2.zero(),onCallBack: (){

      _machineComponent.updateEnableRoller(true);

    });
    _turntableComponent.priority = 1;

    world.add(_turntableComponent);
    // _turntableComponent.priority= 1;
  }

  void _initStartButton()  {
    // startButton = SlotMachineStartButton(onTap: (){
    //   print('點擊!');
    //   slotMachine.startRolling();
    // });
    // world.add(startButton);
  }

}

