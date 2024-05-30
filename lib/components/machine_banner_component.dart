import 'package:flame/components.dart';

class MachineBannerComponent extends PositionComponent{
  MachineBannerComponent({super.priority}):super(size: Vector2(1290,164));


  late SpriteComponent _bannerFrame;

  @override
  void onLoad() async {
    _initBannerFrame();
    super.onLoad();
  }

  Future<void> _initBannerFrame() async {
    _bannerFrame  = SpriteComponent(sprite: await Sprite.load('images/machine_banner_background.png'),size: Vector2(1290,164));
    add(_bannerFrame);

  }

  Future<void> _initTitle() async {
    _bannerFrame  = SpriteComponent(sprite: await Sprite.load('images/machine_banner_background.png'),size: Vector2(1290,164));
    add(_bannerFrame);

  }

}