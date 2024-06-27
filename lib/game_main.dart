
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/particles.dart';
import 'package:fortune_gems/components/header_component.dart';
import 'package:fortune_gems/components/machine_component.dart';
import 'package:fortune_gems/components/machine_controller_component.dart';
import 'package:fortune_gems/components/score_board_component.dart';
import 'package:fortune_gems/components/wheel/wheel_component.dart';
import 'package:fortune_gems/components/winning_component.dart';
import 'package:fortune_gems/extension/string_extension.dart';
import 'package:fortune_gems/system/global.dart';





class GameMain extends FlameGame{

  late Global _global;
  late HeaderComponent _headerComponent;
  late MachineComponent _machineComponent;
  late WheelComponent _wheelComponent;
  late MachineControllerComponent _machineControllerComponent;
  late WinningComponent _winningComponent;
  late ScoreBoardComponent _scoreBoardComponent;


  GameMain() : super(camera: CameraComponent.withFixedResolution(width: 1290, height:2796)) {
    // pauseWhenBackgrounded = false;
    // debugMode = true;

  }

  void _showScoreBoardComponent({required int ratio, required int luckyRatio, required double resultAmount})  {
    ScoreBoardType type = ratio == 0 ?ScoreBoardType.wheel:ScoreBoardType.common;
    double positionX = 0;
    double positionY = size.y * 0.13;
    _scoreBoardComponent = ScoreBoardComponent(
        anchor: Anchor.topCenter,
        position: Vector2(positionX,positionY),
        type: type,
        ratio: ratio,
        luckyRatio: luckyRatio,
        scoreAmount: 100,
        onCallBack: (totalScoreAmount,winningType){
          if(_global.gameStatus == GameStatus.stopScoreBoard){
            _global.gameStatus = GameStatus.idle;
            world.remove(_scoreBoardComponent);
          }
          if(_global.gameStatus == GameStatus.openWheel){
            _showWheelComponent(luckyRatio: luckyRatio);
          }
          if(_global.gameStatus == GameStatus.openBigWinning){
            _showWinningEffectComponent();
            world.remove(_scoreBoardComponent);
          }
        });
    _scoreBoardComponent.priority = 3;
    world.add(_scoreBoardComponent);
  }


  void _showWheelComponent({required int luckyRatio}){
    _wheelComponent.startLottery(stopRatio: luckyRatio, onCallBack: (){
      ///TODO：判斷是否有中大獎
      if(_global.gameStatus == GameStatus.openBigWinning){
        _showWinningEffectComponent();
        world.remove(_scoreBoardComponent);
      }else{
        _global.gameStatus = GameStatus.idle;
        _scoreBoardComponent.updateAdditionAmount(luckyRatio.toDouble());
      }
    });
  }
  void _showWinningEffectComponent() {
    _winningComponent = WinningComponent(
        anchor: Anchor.center,
        position: Vector2.zero(),
        onCallBack: (){
          _global.gameStatus = GameStatus.idle;
          _winningComponent.priority = 0;
          world.remove(_winningComponent);
        }
    );
    _winningComponent.priority = 3;
    world.add(_winningComponent);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _global = Global();
    _initHeaderComponents();
    _initWheelComponent();
    _initMachineComponent();
    _intiMachineControllerComponent();
  }

  void _initHeaderComponents(){

    _headerComponent = HeaderComponent();
    _headerComponent.priority = 0;
    world.add(_headerComponent);

  }

  void _initWheelComponent(){
    _wheelComponent = WheelComponent(
        anchor: Anchor.center,
        position: Vector2.zero(),);
    _wheelComponent.priority = 1;
    world.add(_wheelComponent);
  }


  void _initMachineComponent()  {

    _machineComponent  = MachineComponent(onCallBack: (ratio,luckyRatio,resultAmount){
      _showScoreBoardComponent(ratio:ratio,luckyRatio: luckyRatio,resultAmount: resultAmount);
    });
    _machineComponent.priority = 2;
    world.add(_machineComponent);
  }

  void _intiMachineControllerComponent(){
    _machineControllerComponent = MachineControllerComponent(
      anchor: Anchor.center,
      position: Vector2.zero(),
      onTapSpinButton: (){
        _machineComponent.startRollingMachine();
      },
      onTapAutoButton: (){},
      onTapSpeedButton: (){},
      onTapBetButton: (bet){
        _wheelComponent.updateBetNumber(bet);
      },
      onTapSettingButton: (){},
    );
    _machineControllerComponent.priority = 3;
    world.add(_machineControllerComponent);
  }



}

