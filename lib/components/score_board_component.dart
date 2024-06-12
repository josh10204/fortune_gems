import 'package:flame/components.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';

class ScoreBoardComponent extends PositionComponent {
  ScoreBoardComponent({super.position}) : super(size: Vector2(1290, 2796));
  // ScoreBoardComponent({super.position}) : super();


  late SpriteComponent _boardSpriteComponent;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _initBoardSpriteComponent();
  }

  Future<void> _initBoardSpriteComponent() async {
    double width =288 *2;
    double height = 105*2;
    double positionX = localCenter.x -width/2;
    double positionY = localCenter.y/2 - height;
    _boardSpriteComponent = SpriteComponent(
        sprite: await Sprite.load('images/score_board_background.png'),
    size: Vector2(width, height),
    position: Vector2(positionX,positionY),
    // anchor: Anchor.center,
    priority: 2);
    add(_boardSpriteComponent);
  }
}