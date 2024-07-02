
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

  int _autoCount = 10;

  int _ratio = 0;
  int _wheelRatio = 0;
  double _wheelRatioAmount = 0;
  double _scoreAmount = 0;
  WinningType _winningType = WinningType.none;

  GameMain() : super(camera: CameraComponent.withFixedResolution(width: 1290, height:2796)) {
    // pauseWhenBackgrounded = false;
    // debugMode = true;

  }

  void _gameStatusProcess(){
    switch(_global.gameStatus){
      case GameStatus.startSpin:
        _machineControllerComponent.updateWinAmount(0.00);
        _machineControllerComponent.hideBetMenu();
        _machineControllerComponent.hideSettingMenu();
        break;
      case GameStatus.openScoreBoard:
        _showScoreBoardComponent(ratio: _ratio,luckyRatio: _wheelRatio,resultAmount: _scoreAmount);
        break;
      case GameStatus.openWheel:
        _showWheelComponent(luckyRatio: _wheelRatio);
        break;
      case GameStatus.stopWheel:
        _scoreBoardComponent.updateAdditionAmount(_wheelRatioAmount);
        break;
      case GameStatus.openBigWinning:
        _showWinningEffectComponent(_winningType,_scoreAmount);
        world.remove(_scoreBoardComponent);
        break;

      case GameStatus.stopSpin:
        _global.gameStatus = GameStatus.idle;
        _resetRoundRatio();
        _checkAutoSpin();
        break;
      case GameStatus.stopBigWinning:
        _global.gameStatus = GameStatus.idle;
        _machineControllerComponent.updateWinAmount(_scoreAmount);
        world.remove(_winningComponent);
        _resetRoundRatio();
        _checkAutoSpin();
        break;
      case GameStatus.stopScoreBoard :
        _global.gameStatus = GameStatus.idle;
        _machineControllerComponent.updateWinAmount(_scoreAmount);
        world.remove(_scoreBoardComponent);
        _resetRoundRatio();
        _checkAutoSpin();
        break;
      default:
        break;
    }
  }

  void _resetRoundRatio(){
    _ratio = 0;
    _wheelRatio = 0;
    _wheelRatioAmount = 0;
    _scoreAmount = 0;
    _winningType = WinningType.none;
  }

  Future<void> _checkAutoSpin() async {
    await Future.delayed(const Duration(milliseconds: 500));

    if(_global.autoSpinCount > 0){
      _machineControllerComponent.updateAutoCount();
      _machineComponent.startRollingMachine();
    }else{
      _machineControllerComponent.updateAutoCount();
    }
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
        scoreAmount: resultAmount,
        onCallBack: (totalScoreAmount,winningType){
          _scoreAmount = totalScoreAmount;
          _winningType = winningType;
          _gameStatusProcess();
        });
    _scoreBoardComponent.priority = 3;
    world.add(_scoreBoardComponent);
  }

  void _showWheelComponent({required int luckyRatio}){
    _wheelComponent.startLottery(stopRatio: luckyRatio, onCallBack: (ratioAmount){
      _wheelRatioAmount = ratioAmount;
      _gameStatusProcess();
    });
  }
  void _showWinningEffectComponent(WinningType winningType,double scoreAmount,) {
    _winningComponent = WinningComponent(
        anchor: Anchor.center,
        position: Vector2.zero(),
        winningType: winningType,
        scoreAmount: scoreAmount,
        onCallBack: (){
          _gameStatusProcess();
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
    _machineComponent = MachineComponent(
        onStartCallBack: () {
          _gameStatusProcess();
        },
        onStopCallBack: (ratio, luckyRatio, resultAmount) {
          _ratio = ratio;
          _wheelRatio = luckyRatio;
          _scoreAmount = resultAmount;
          _gameStatusProcess();
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
      onTapAutoButton: (isEnable){
        _machineComponent.startRollingMachine();
      },
      onTapSpeedButton: (isEnable){},
      onTapBetButton: (){
        _wheelComponent.updateBetNumber();
      },
      onTapSettingButton: (){},
    );
    _machineControllerComponent.priority = 3;
    world.add(_machineControllerComponent);
  }



}

