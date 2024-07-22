import 'dart:io';

import 'package:fortune_gems/model/res/base_res.dart';
import 'package:fortune_gems/model/res/slot_game_res.dart';
import 'http_server.dart';



class HttpManager {


  Future<BaseRes?> reloadSlotGameData({
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    BaseRes? res = await HttpServer(
        onConnectSuccess: onConnectSuccess, onConnectFail: onConnectFail,
    ).post('https://gem-game-server.zeabur.app/bet/random');
    return (res == null) ? (null) : (res);
  }


  Future<void> reloadSlotGameDemoData({
    required Function(String,SlotGameRes) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {

    String errMsg = '';
    String code = '';

    BaseRes? res = await HttpServer(
      onConnectSuccess:(msg){
        code = msg;
      }, onConnectFail: (msg){
      errMsg = msg;
    },
    ).post('https://gem-game-server.zeabur.app/bet/random');

    if(res == null){
      onConnectFail.call(errMsg);
    }else{
      SlotGameRes slotGameRes = SlotGameRes.fromJson(res.resultMap);
      onConnectSuccess.call(code,slotGameRes);
    }

  }




}