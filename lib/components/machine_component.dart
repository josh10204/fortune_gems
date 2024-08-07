
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/image_composition.dart';
import 'package:flame/particles.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fortune_gems/components/machine_banner_component.dart';
import 'package:fortune_gems/components/machine_roller/machine_roller_component.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';
import 'package:fortune_gems/extension/string_extension.dart';
import 'package:fortune_gems/model/res/slot_game_res.dart';
import 'package:fortune_gems/model/rolller_symbol_model.dart';
import 'package:fortune_gems/system/global.dart';
import 'package:fortune_gems/system/http/http_manager.dart';
import 'package:fortune_gems/system/mode_event.dart';



class MachineComponent extends PositionComponent with TapCallbacks{
  MachineComponent({super.anchor , super.position ,required this.onStartCallBack,required this.onStopCallBack}) : super(size: Vector2(900, 1600));
  final void Function() onStartCallBack;
  final void Function(int ratio, int luckyRatio, int exLuckyRatio,double resultAmount) onStopCallBack;

  late Global _global;
  late ModeEvent _modeEvent;

  late SpriteComponent _machineBackground;
  late MachineBannerComponent _machineBanner;
  late MachineRollerComponent _firstMachineRollerComponent;
  late MachineRollerComponent _secondMachineRollerComponent;
  late MachineRollerComponent _thirdMachineRollerComponent;
  late MachineRollerComponent _ratioMachineRollerComponent;

  final List<MachineRollerComponent> _rollers = [];
  // bool _isStartRolling = false;
  // bool _isEnableRolling = true;

  /// 全部中獎賠付線類型
  List<RollerPayLineType> _allPayLineTypeList = [];
  /// 判斷此局是否有中獎
  bool _isHasWinning = false;
  /// 中獎倍率
  int _ratio = 0;
  /// 幸運輪盤中獎倍率
  int _luckyRatio = 1;
  /// 幸運輪盤EX中獎倍率
  int _exLuckyRatio = 0;
  /// 單局全部中獎分數（不含中獎倍率，除非幸運輪盤）
  double _playResultAmount = 0;


  /// demo資料順序
  // int _currentDemoIndex = 1;
  void startRollingMachine(){
    if(_global.gameStatus == GameStatus.idle){
      _global.gameStatus = GameStatus.startSpin;
      onStartCallBack.call();
      _startRolling();
    }
  }

  Future<void> _startRolling() async {
    for(MachineRollerComponent machineRollerComponent in _rollers){
      machineRollerComponent.startRolling();
    }
    _reloadRollerSymbol();
  }

  Future<void> _reloadRollerSymbol() async {
    HttpManager().reloadSlotGameDemoData(
      onConnectSuccess: (code, slotGameResultMap) async {
        _updateRollerSymbol(slotGameResultMap);
      },
      onConnectFail: (msg) {
        print(msg);

      },
    );

  }

  Future<void> _updateRollerSymbol(SlotGameRes slotGameResultMap) async {
      /// 顯示盤面處理
      List<SlotGameDetail> detailList = slotGameResultMap.detail??[];
      SlotGameDetail detail = detailList[0];
      _ratio = detail.ratio ?? 0;
      _luckyRatio = detail.luckyRatio ?? 1;
      _exLuckyRatio = detail.exLuckyRatio ?? 0;
      String ratio = _ratio.toString();
      List<String> panelList =detail.panel??[];
      List<String> firstList = [];
      List<String> secondList = [];
      List<String> thirdList = [];
      List<String> ratioList = [ratio];
      // 分別取出第 0、3、6 跟 1、4、7 以及 2、5、8
      for (int i = 0; i < panelList.length; i++) {
        if (i % 3 == 0) {
          firstList.add(panelList[i]);
        } else if (i % 3 == 1) {
          secondList.add(panelList[i]);
        } else if (i % 3 == 2) {
          thirdList.add(panelList[i]);
        }
      }

      /// 中獎結果處理
      List<SlotGameResult> resultList =detail.result??[];
      // 是否有中獎
      _isHasWinning = resultList.isNotEmpty;
      // 全部中獎線
      _allPayLineTypeList = [];
      _playResultAmount = 0;
      for (SlotGameResult result in resultList) {
        _allPayLineTypeList.add(result.line.toString().getRollerPayLineType);
        _playResultAmount += result.playResult ??0;
      }
      if(_ratio !=0 ){
        _playResultAmount = _playResultAmount/_ratio;
      }

      /// 資料轉換成RollerSymbolModel
      List<RollerSymbolModel> firstModelList = _getRollerSymbolModelList(symbolList: firstList,allResultList:resultList);
      List<RollerSymbolModel> secondModelList = _getRollerSymbolModelList(symbolList: secondList,allResultList:resultList);
      List<RollerSymbolModel> thirdModelList = _getRollerSymbolModelList(symbolList: thirdList,allResultList:resultList);
      List<RollerSymbolModel> ratioModelList = _getRollerSymbolModelList(symbolList: ratioList,allResultList:[]);


      /// 更新資料
      _firstMachineRollerComponent.updateRollerSymbolList(modelList:firstModelList);
      _secondMachineRollerComponent.updateRollerSymbolList(modelList:secondModelList);
      _thirdMachineRollerComponent.updateRollerSymbolList(modelList:thirdModelList);
      _ratioMachineRollerComponent.updateRollerSymbolList(modelList: ratioModelList);

      ///Demo 順序往下，超過後重複
      // _currentDemoIndex +=1;
      // _currentDemoIndex  =  _currentDemoIndex >= detailList.length ? 0 : _currentDemoIndex;
      /// 模擬跟後端取得完資料停止 delay 時間
      // await Future.delayed(const Duration(milliseconds: 500));
      _stopRolling();
  }

  List<RollerSymbolModel> _getRollerSymbolModelList({required List<String> symbolList,required List<SlotGameResult> allResultList}){

    List<RollerSymbolModel> modelList = [];
    for(String symbol in symbolList){
      RollerSymbolType type = symbol.getRollerSymbolType;
      RollerSymbolModel model = RollerSymbolModel(type: type);
      modelList.add(model);
    }
    return modelList;
  }


  Future<void> _stopRolling() async {
    _global.gameStatus = GameStatus.stopSpin;
    for(MachineRollerComponent roller in _rollers){
      roller.stopRolling();
      if(!_global.isEnableSpeedSpin){
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
  }

  Future<void> _stopResult() async {
    if(_isHasWinning){
      _global.gameStatus = GameStatus.openScoreBoard;
      _showRollerWinningSymbolAnimation();
      ///TODO:未來要在此加上動效，這邊先用delay方式代表動效部分
      await Future.delayed(const Duration(milliseconds: 1000));
      onStopCallBack(_ratio, _luckyRatio,_exLuckyRatio,_playResultAmount);
    }else{
      await Future.delayed(const Duration(milliseconds: 500));
      _global.gameStatus = GameStatus.stopSpin;
      onStopCallBack(0, 0,0,0);
    }
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
    _modeEvent = ModeEvent();
    _modeEvent.add(ModeEventType.extraBet, (arg){
      _enableExtraBetMode();
    });

    _initMachineBackground();
    _intiMachineRollerComponent();
    _initMachineBanner();
    super.onLoad();
  }

  Future<void> _initMachineBackground() async {
    double width = 1160;
    double height = 1100;
    double positionX = localCenter.x - width/2;
    double positionY = 0;
    _machineBackground = SpriteComponent(sprite: await Sprite.load('images/machine_background.png'),size: Vector2(width,height),position:Vector2(positionX,positionY));
    add(_machineBackground);
  }


  void _intiMachineRollerComponent(){

    _firstMachineRollerComponent = MachineRollerComponent(rollerType:RollerType.common,position: Vector2(30,190),priority:1,onStopCallBack:(){} );
    _secondMachineRollerComponent = MachineRollerComponent(rollerType:RollerType.common,position: Vector2(240,190),priority:1,onStopCallBack:(){});
    _thirdMachineRollerComponent = MachineRollerComponent(rollerType:RollerType.common,position:  Vector2(450,190),priority:1,onStopCallBack:(){});
    _ratioMachineRollerComponent = MachineRollerComponent(rollerType:RollerType.ratio,position: Vector2(660,190),priority:1,onStopCallBack:(){
      _stopResult();
    });
    _rollers.addAll([
      _firstMachineRollerComponent,
      _secondMachineRollerComponent,
      _thirdMachineRollerComponent,
      _ratioMachineRollerComponent
    ]);
    addAll(_rollers);
  }

  void _initMachineBanner() {
    _machineBanner = MachineBannerComponent(priority: 2);
    add(_machineBanner);
  }

  Future<void> _showRollerWinningSymbolAnimation() async {

    _ratioMachineRollerComponent.showWinningSymbol(indexList:[1]);
    bool isPlay = true;
    while(isPlay){
      isPlay =  _global.gameStatus == GameStatus.idle || _global.gameStatus == GameStatus.openScoreBoard || _global.gameStatus == GameStatus.startScoreBoard;
      if (!isPlay) break;
      for(RollerPayLineType payLineType in  _allPayLineTypeList){
        _firstMachineRollerComponent.showWinningSymbol(indexList: payLineType.firstRollerItemIndexList);
        _secondMachineRollerComponent.showWinningSymbol(indexList:payLineType.secondRollerItemIndexList);
        _thirdMachineRollerComponent.showWinningSymbol(indexList:payLineType.thirdIRollerItemIndexList);
        await Future.delayed(const Duration(milliseconds: 2000));
      }
    }
  }

  void _enableExtraBetMode(){

    /// 在切換ExtraBet，設定倍率的輪盤預設初始樣式
    List<String> ratioList = ['3','10','0'];
    if(_global.isEnableExtraBet){
      ratioList = ['10','15','0'];
    }
    List<RollerSymbolModel> ratioModelList = _getRollerSymbolModelList(symbolList: ratioList,allResultList:[]);
    _ratioMachineRollerComponent.updateRollerSymbolList(modelList: ratioModelList);
    _ratioMachineRollerComponent.updateExtraIcon(isShow: _global.isEnableExtraBet);

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
    startRollingMachine();
    super.onTapDown(event);

  }
}