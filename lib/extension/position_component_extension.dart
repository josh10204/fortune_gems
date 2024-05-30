
import 'package:flame/components.dart';

extension PositionComponentExtension on PositionComponent {
  /// Return the local coordinate of a PositionComponent.
  Vector2 get localTopLeft => Vector2.zero();
  Vector2 get localTop => Vector2(size.x / 2, 0);
  Vector2 get localTopRight => Vector2(size.x, 0);

  Vector2 get localLeft => Vector2(0, size.y / 2);
  Vector2 get localCenter => size / 2;
  Vector2 get localRight => Vector2(size.x, size.y / 2);

  Vector2 get localBottomLeft => Vector2(0, size.y);
  Vector2 get localBottom => Vector2(size.x / 2, size.y);
  Vector2 get localBottomRight => size;
}
