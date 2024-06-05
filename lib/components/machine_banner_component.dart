import 'package:flame/components.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';
import 'package:fortune_gems/model/image_marquee_model.dart';
import 'package:fortune_gems/widget/image_marquee.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';

class MachineBannerComponent extends PositionComponent{
  MachineBannerComponent({super.priority}):super(size: Vector2(1290,164));


  late SpriteComponent _bannerFrame;
  late ImageMarquee _marquee;


  @override
  void onLoad() async {
    _initBannerFrame();
    _initMarquee();
    super.onLoad();
  }

  Future<void> _initBannerFrame() async {
    _bannerFrame  = SpriteComponent(sprite: await Sprite.load('images/machine_banner_background.png'),size: Vector2(1290,164));
    add(_bannerFrame);

  }

  Future<void> _initMarquee() async {
    double width = 900;
    double height = 70;
    double positonX = 50;
    double positonY = localCenter.y-height/2;
    List<ImageMarqueeModel> modelList = [];
    ImageMarqueeModel model01= ImageMarqueeModel(imageFilePath: 'images/marquee_image01.png',imageWidth: 1211,imageHeight: 50);
    ImageMarqueeModel model02= ImageMarqueeModel(imageFilePath: 'images/marquee_image02.png',imageWidth: 765,imageHeight: 50);
    ImageMarqueeModel model03= ImageMarqueeModel(imageFilePath: 'images/marquee_image03.png',imageWidth: 879,imageHeight: 50);
    ImageMarqueeModel model04= ImageMarqueeModel(imageFilePath: 'images/marquee_image04.png',imageWidth: 560,imageHeight: 50);
    modelList.add(model01);
    modelList.add(model02);
    modelList.add(model03);
    modelList.add(model04);
    _marquee  = ImageMarquee(position: Vector2(positonX,positonY),size:Vector2(width,height),imageMarqueeModelList: modelList);
    _marquee.priority =1;
    add(_marquee);
  }

}