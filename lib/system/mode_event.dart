typedef void EventCallback(arg);

enum ModeEventType {
  extraBet,
  autoSpin,
  speedSpin,
}

class ModeEvent {
  ModeEvent._internal();

  static ModeEvent _singleton = ModeEvent._internal();

  factory ModeEvent()=> _singleton;

  //保存事件订阅者队列，key:事件名(id)，value: 对应事件的订阅者队列
  final _emap = <ModeEventType, List<EventCallback>?>{};

  void add(ModeEventType evenType, EventCallback f) {
    _emap[evenType] ??=  <EventCallback>[];
    _emap[evenType]!.add(f);
  }

  void remove(ModeEventType evenType, [EventCallback? f]) {
    var list = _emap[evenType];
    if (evenType == null || list == null) return;
    if (f == null) {
      _emap[evenType] = null;
    } else {
      list.remove(f);
    }
  }

  //触发事件，事件触发后该事件所有订阅者会被调用
  void send(ModeEventType evenType, [arg]) {
    var list = _emap[evenType];
    if (list == null) return;
    int len = list.length - 1;
    for (var i = len; i > -1; --i) {
      list[i](arg);
    }
  }
}


var modeEvent = ModeEvent();