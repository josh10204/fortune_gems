
enum GameStatus{
  idle,                // 待機中
  spinning,           // 滾動中
  spinStopped,        // 滾動停止
  wheelSpinning,      // 輪盤滾動中
  wheelStopped,       // 輪盤停止
  winningEffect,      // 中獎特效進行
  winningEffectEnd,   // 中獎特效結束
}


class Global{

  static final Global _singleton = Global._init();
  factory Global() => _singleton;
  Global._init();

  GameStatus gameStatus = GameStatus.idle;

}