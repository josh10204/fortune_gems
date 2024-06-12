
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/image_composition.dart';
import 'package:flame/particles.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fortune_gems/components/machine_banner_component.dart';
import 'package:fortune_gems/components/machine_roller_component.dart';
import 'package:fortune_gems/components/score_board_component.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';
import 'package:fortune_gems/system/global.dart';



class MachineComponent extends PositionComponent with TapCallbacks{
  MachineComponent({required this.onCallBack}) : super(size: Vector2(1290, 2796),anchor: Anchor.topCenter);
  final void Function() onCallBack;

  late Global _global;
  late SpriteComponent _machineFrame;
  late MachineBannerComponent _machineBanner;
  late MachineRollerComponent _firstMachineRollerComponent;
  late MachineRollerComponent _secondMachineRollerComponent;
  late MachineRollerComponent _thirdMachineRollerComponent;
  late MachineRollerComponent _specialMachineRollerComponent;
  late ScoreBoardComponent _scoreBoardComponent;

  final List<MachineRollerComponent> _rollers = [];
  // bool _isStartRolling = false;
  // bool _isEnableRolling = true;



  void startRollingMachine(){
    if(_global.gameStatus == GameStatus.idle){
      _startRolling();
    }
  }

  void autoRollingMachine(bool isEnable){}

  Future<void> _startRolling() async {
    _global.gameStatus = GameStatus.spinStopped;
    for(MachineRollerComponent machineRollerComponent in _rollers){
      machineRollerComponent.startRolling();
      await Future.delayed(const Duration(milliseconds: 400));
    }

    /// 模擬跟後端取得完資料停止 delay 時間
    await Future.delayed(const Duration(milliseconds: 200));
    _stopRolling();
  }

  Future<void> _stopRolling() async {
    _global.gameStatus = GameStatus.spinStopped;
    for(MachineRollerComponent machineRollerComponent in _rollers){
      machineRollerComponent.stopRolling();
      await Future.delayed(const Duration(milliseconds: 500));

    }
  }

  Future<void> _showAllWinningSymbol() async {
    _firstMachineRollerComponent.showWinningSymbol();
    _secondMachineRollerComponent.showWinningSymbol();
    _thirdMachineRollerComponent.showWinningSymbol();
    _specialMachineRollerComponent.showWinningSymbol();

    add(_scoreBoardComponent);
    await Future.delayed(const Duration(seconds: 3));
    remove(_scoreBoardComponent);
    onCallBack.call();
  }

  /// 是否當前滾輪都是停止狀態
  bool get isStopped {
    if (_rollers.isNotEmpty) {
      for (MachineRollerComponent roller in _rollers) {
        if (roller.currentState != RollerStatus.stopped) {
          return false;
        }
      }
      return true;
    }
    return false;
  }


  @override
  Future<void> onLoad() async {
    _global = Global();
    _machineFrame = SpriteComponent(sprite: await Sprite.load('images/machine_background.png'),size: Vector2(1614,1025),position:Vector2(-162,0));
    add(_machineFrame);
    _intiMachineRollerComponent();
    _initMachineBanner();
    _initScoreBoardComponent();
    super.onLoad();
  }


  void _intiMachineRollerComponent(){

    _firstMachineRollerComponent = MachineRollerComponent(rollerType:RollerType.common,position: Vector2(35,135),priority:0,onStopCallBack:(){} );
    _secondMachineRollerComponent = MachineRollerComponent(rollerType:RollerType.common,position: Vector2(332,135),priority:1,onStopCallBack:(){});
    _thirdMachineRollerComponent = MachineRollerComponent(rollerType:RollerType.common,position:  Vector2(635,135),priority:0,onStopCallBack:(){});
    _specialMachineRollerComponent = MachineRollerComponent(rollerType:RollerType.special,position: Vector2(930,135),priority:1,onStopCallBack:(){
      _showAllWinningSymbol();
    });
    _rollers.addAll([
      _firstMachineRollerComponent,
      _secondMachineRollerComponent,
      _thirdMachineRollerComponent,
      _specialMachineRollerComponent
    ]);
    addAll(_rollers);
  }

 void _initMachineBanner() {
    _machineBanner = MachineBannerComponent(priority: 2);
    add(_machineBanner);
  }

  void _initScoreBoardComponent(){
    _scoreBoardComponent = ScoreBoardComponent();
    _scoreBoardComponent.priority = 3;
    // add(_scoreBoardComponent);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void render(Canvas canvas){
    super.render(canvas);

  }

  @override
  void onTapDown(TapDownEvent event) {
    if(_global.gameStatus == GameStatus.idle){
      _startRolling();
    }
    super.onTapDown(event);

  }
}