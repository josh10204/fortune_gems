import 'dart:math';

import 'package:flame/components.dart';

import 'package:flame/image_composition.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';
import 'package:fortune_gems/model/image_marquee_model.dart';

enum ImageMarqueeStatus{
  starting,
  rolling,
  update,
  stopped,
}


class ImageMarquee extends PositionComponent{
  ImageMarquee({super.position,super.size,required this.imageMarqueeModelList}) : super();
  final List<ImageMarqueeModel> imageMarqueeModelList;


  ImageMarqueeStatus _marqueeState = ImageMarqueeStatus.starting;

  late PositionComponent _basicView;
  late SpriteComponent _marqueeImage;

  double _speed = 250;
  Timer _waitUpdateTimer = Timer(3);

  late Timer interval;
  Future<void> _updateMarqueeImage() async {
    Random random = Random();
    int randomIndex = random.nextInt(imageMarqueeModelList.length);
    ImageMarqueeModel model  = imageMarqueeModelList[randomIndex];
    _marqueeImage.sprite =  await Sprite.load(model.imageFilePath);
    _marqueeImage.size = Vector2(model.imageWidth, model.imageHeight);
    _marqueeImage.x = size.x;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _initBasic();
    _initMarqueeImage();
    interval = Timer(
      5,
      onTick: () { print('1111');},
      repeat: false,
    );
  }

  Future<void> _initBasic() async {
    _basicView = PositionComponent(size: size,position: Vector2(0,0));
    add(_basicView);
    add(ClipComponent.rectangle(size: size, children: [_basicView],));
  }

  Future<void> _initMarqueeImage() async {
    _marqueeImage  = SpriteComponent(sprite: await Sprite.load('images/marquee_image01.png'),size: Vector2(1211,50));
    _basicView.add(_marqueeImage);
  }

  @override
  void update(double dt) {
    super.update(dt);
    switch (_marqueeState) {
      case ImageMarqueeStatus.starting:
        _marqueeImage.x = size.x;
        _marqueeState = ImageMarqueeStatus.rolling;
        break;
      case ImageMarqueeStatus.rolling:
        _marqueeImage.x -= _speed * dt;
        if (_marqueeImage.x + _marqueeImage.width < 0) {
          _marqueeState = ImageMarqueeStatus.update;
        }
        break;
      case ImageMarqueeStatus.update:
        _marqueeState = ImageMarqueeStatus.stopped;
        _updateMarqueeImage();
        break;
      case ImageMarqueeStatus.stopped:
        _waitUpdateTimer.update(dt);
        if (_waitUpdateTimer.finished) {
          _marqueeState = ImageMarqueeStatus.starting;
          _waitUpdateTimer = Timer(3);
        }
        break;
    }
  }

  @override
  void render(Canvas canvas){
    super.render(canvas);

  }


}