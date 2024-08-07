
enum GameStatus{
  idle,                // 待機中
  startSpin,           // 滾動中
  stopSpin,            // 滾動停止
  openScoreBoard,      // 開啟分數版
  startScoreBoard,     // 分數顯示中
  stopScoreBoard,      // 分數顯示結束
  openWheel,           // 開啟幸運輪盤
  startWheel,          // 幸運輪盤滾動中
  stopWheel,           // 幸運輪盤停止
  openBigWinning,      // 開啟大獎特效
  startBigWinning,     // 大獎特效顯示中
  stopBigWinning,      // 大獎特效結束
}


class Global{

  static final Global _singleton = Global._init();
  factory Global() => _singleton;
  Global._init();

  GameStatus gameStatus = GameStatus.idle;
  double extraBetRatio = 1.5; // Ex模式 押注金額為原先的1.5倍
  double betAmount = 100; // 押注金額
  int autoSpinCount = 0; // 自動輪轉 0 代表關閉
  bool isEnableSpeedSpin = false; // 是否已開啟加速模式
  bool isEnableExtraBet = false; // 是否已開啟EX模式

// double balanceAmount = 0.00;//總分

}