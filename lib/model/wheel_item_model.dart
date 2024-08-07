
enum WheelItemType{
  item100x(serial: 0,ratio:100,centerAngle: 0 ,startAngle: -15 * 3.14 / 180,endAngle: 15 * 3.14 / 180,itemAngle: 0 * 3.14 /180),
  item8x(serial: 1,ratio:8,centerAngle: 330 * 3.14 / 180 ,startAngle: 315 * 3.14 / 180,endAngle: 345 * 3.14 / 180,itemAngle: 30 * 3.14 /180),
  item1x(serial: 2,ratio:1,centerAngle: 300 * 3.14 / 180 ,startAngle: 285 * 3.14 / 180,endAngle: 315 * 3.14 / 180,itemAngle: 60 * 3.14 /180),
  item20x(serial: 3,ratio:20,centerAngle: 270 * 3.14 / 180 ,startAngle: 255 * 3.14 / 180,endAngle: 285 * 3.14 / 180,itemAngle: 90 * 3.14 /180),
  item3x(serial: 4,ratio:3,centerAngle: 240 * 3.14 / 180,startAngle: 225 * 3.14 / 180,endAngle: 255 * 3.14 / 180,itemAngle: 120 * 3.14 /180),

  item30x(serial: 5,ratio:30,centerAngle: 210 * 3.14 / 180,startAngle: 195 * 3.14 / 180,endAngle: 225 * 3.14 / 180,itemAngle: 150 * 3.14 /180),
  item200x(serial: 6,ratio:200,centerAngle: 180 * 3.14 / 180,startAngle: 165 * 3.14 / 180,endAngle: 195 * 3.14 / 180,itemAngle: 180 * 3.14 /180),
  item10x(serial: 7,ratio:10,centerAngle: 150 * 3.14 / 180,startAngle: 135 * 3.14 / 180,endAngle: 165 * 3.14 / 180,itemAngle: 210 * 3.14 /180),
  item1000x(serial: 8,ratio:1000,centerAngle: 120 * 3.14 / 180,startAngle: 105 * 3.14 / 180,endAngle: 135 * 3.14 / 180,itemAngle: 240 * 3.14 /180),

  item5x(serial: 9,ratio:5,centerAngle: 90 * 3.14 / 180,startAngle: 75 * 3.14 / 180,endAngle: 105 * 3.14 / 180,itemAngle: 270 * 3.14 /180),
  item50x(serial: 10,ratio:50,centerAngle: 60 * 3.14 / 180,startAngle: 45 * 3.14 / 180,endAngle: 75 * 3.14 / 180,itemAngle: 300 * 3.14 /180),
  item15x(serial: 11,ratio:15,centerAngle: 30 * 3.14 / 180,startAngle: 15 * 3.14 / 180,endAngle: 45 * 3.14 / 180,itemAngle: 330 * 3.14 /180);

  final int serial;
  final int ratio;//倍數
  final double centerAngle;
  final double startAngle;
  final double endAngle;
  final double itemAngle;


  const WheelItemType(
      {required this.serial,
        required this.ratio,
        required this.centerAngle,
        required this.startAngle,
        required this.endAngle,
        required this.itemAngle,
      });
}


enum WheelAdditionType{

  addition1x(imagePath:'icons/additions/addition_1x.png',width: 100,height: 40),
  addition2x(imagePath:'icons/additions/addition_2x.png',width: 100,height: 40),
  addition3x(imagePath:'icons/additions/addition_3x.png',width: 100,height: 40),
  addition5x(imagePath:'icons/additions/addition_5x.png',width: 100,height: 40),
  addition10x(imagePath:'icons/additions/addition_10x.png',width: 100,height: 40),
  addition15x(imagePath:'icons/additions/addition_15x.png',width: 100,height: 40);

  final String imagePath;
  final double width;
  final double height;

  const WheelAdditionType({required this.imagePath, required this.width,required this.height});
}