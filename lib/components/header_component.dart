import 'package:flame/components.dart';

class HeaderComponent extends SpriteComponent {
  HeaderComponent() : super(size: Vector2(900, 1600),anchor: Anchor.bottomCenter);


  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('images/header_background_image.png');
    super.onLoad();

  }
  @override
  void update(double dt) {
    super.update(dt);
  }
}