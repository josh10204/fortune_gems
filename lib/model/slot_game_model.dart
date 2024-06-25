class SlotGameModel {
  String? uuid;
  int? betAmount;
  int? totalAmount;
  String? resultCode;
  int? status;
  int? exStatus;
  List<Detail>? detail;

  SlotGameModel(
      {this.uuid,
        this.betAmount,
        this.totalAmount,
        this.resultCode,
        this.status,
        this.exStatus,
        this.detail});

  SlotGameModel.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    betAmount = json['betAmount'];
    totalAmount = json['totalAmount'];
    resultCode = json['resultCode'];
    status = json['status'];
    exStatus = json['exStatus'];
    if (json['detail'] != null) {
      detail = <Detail>[];
      json['detail'].forEach((v) {
        detail!.add(new Detail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['betAmount'] = this.betAmount;
    data['totalAmount'] = this.totalAmount;
    data['resultCode'] = this.resultCode;
    data['status'] = this.status;
    data['exStatus'] = this.exStatus;
    if (this.detail != null) {
      data['detail'] = this.detail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Detail {
  List<String>? panel;
  int? ratio;
  int? luckyRatio;
  int? exLuckyRatio;
  int? luckyPlayResult;
  List<Result>? result;

  Detail(
      {this.panel,
        this.ratio,
        this.luckyRatio,
        this.exLuckyRatio,
        this.luckyPlayResult,
        this.result});

  Detail.fromJson(Map<String, dynamic> json) {
    panel = json['panel'].cast<String>();
    ratio = json['ratio'];
    luckyRatio = json['luckyRatio'];
    exLuckyRatio = json['exLuckyRatio'];
    luckyPlayResult = json['luckyPlayResult'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['panel'] = this.panel;
    data['ratio'] = this.ratio;
    data['luckyRatio'] = this.luckyRatio;
    data['exLuckyRatio'] = this.exLuckyRatio;
    data['luckyPlayResult'] = this.luckyPlayResult;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? item;
  int? playResult;
  int? line;
  int? linkCount;
  bool? isDirect;
  int? odd;

  Result(
      {this.item,
        this.playResult,
        this.line,
        this.linkCount,
        this.isDirect,
        this.odd});

  Result.fromJson(Map<String, dynamic> json) {
    item = json['item'];
    playResult = json['playResult'];
    line = json['line'];
    linkCount = json['linkCount'];
    isDirect = json['isDirect'];
    odd = json['odd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item'] = this.item;
    data['playResult'] = this.playResult;
    data['line'] = this.line;
    data['linkCount'] = this.linkCount;
    data['isDirect'] = this.isDirect;
    data['odd'] = this.odd;
    return data;
  }
}
