import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';

class TestParticleComponent extends ParticleSystemComponent{
  TestParticleComponent({super.position}) : super();
  @override
  Future<void> onLoad() async {
    super.onLoad();

    // final image = await Flame.images.load('animation/coin/coin_01.png',);
    // Particle particle = MovingParticle(
    //   lifespan: 3,
    //   curve: Curves.easeIn,
    //   from: Vector2.zero(),
    //   to: Vector2(1000,0),
    //   child: ImageParticle(
    //     size: Vector2.all(150),
    //     image: image,
    //   ),
    // );
    //


    // final sprite = await Sprite.load('animation/coin/coin_01.png');
    // final spriteParticle = SpriteParticle(
    //   sprite: sprite,
    //   size: Vector2.all(200.0),
    // );
    // final circularParticle = Particle.generate(
    //   count: 1, // Only one particle
    //   lifespan: 10, // Infinite lifespan
    //   generator: (i) => MovingParticle(
    //     from: Vector2.zero(),
    //     to: Vector2.zero(),
    //     child: CircularMotionParticle(
    //       spriteParticle: spriteParticle,
    //       radius: 100, // Radius of the circular path
    //       speed: 10, // Speed of rotation (radians per second)
    //     ),
    //   ),
    // );




    List<Sprite> sprites = [];
    for(int i=1;i<11;i++){
      sprites.add(await Sprite.load('animation/coin/coin_0$i.png'),);
    }

    final animation = SpriteAnimation.spriteList(
      sprites,
      stepTime: 0.05,
      loop: true,
    );

    Particle particle3 = Particle.generate(
      count: 200,
      lifespan: 20,
      generator: (i) => AcceleratedParticle(
        child: SpriteAnimationParticle(
          // lifespan: sprites.length * 0.1,
          alignAnimationTime: false,
          animation: animation,
          size: Vector2.all(120),
        ),
        acceleration: Vector2(0, 800),  // Simulate gravity
        speed: Vector2(
          1000 * (Random().nextDouble() - 0.5),  // Random horizontal speed
          -1000 * (Random().nextDouble() + 0.5), // Random initial upward speed
        ),
      ),
    );


    Particle particle4 = Particle.generate(
      count: 100,
      lifespan: 5,
      generator: (i) => AcceleratedParticle(
          child: SpriteAnimationParticle(
            // lifespan: sprites.length * 0.1,
            alignAnimationTime: false,
            animation: animation,
            size: Vector2.all(100),
          ),
          // acceleration: randomVector(),
          acceleration: Vector2(0, 0),  // Simulate gravity
          speed:randomVector(),
          position: localCenter),
    );

    particle = particle4;

  }

  // Vector2 randomVector() {
  //   final Random _random = Random();
  //   Vector2 base = Vector2.random(_random); //  (0, 0) ~ (1, 1)
  //   Vector2 fix = Vector2(-0.5,-0.5);
  //   base = base + fix; //  (-0.5, -0.5) ~ (0.5, 0.5)
  //   return base * 2000;
  // }

  Vector2 randomVector() {
    final random = Random();
    // 生成一个随机方向的速度向量，速度大小为 100 到 200 之间
    final angle = random.nextDouble() * 2 * pi;  // 0 到 2π 之间的随机角度
    final speed = 500 + random.nextDouble() * 1500;  // 100 到 200 之间的随机速度
    return Vector2(cos(angle), sin(angle)) * speed;
  }
}





class CircularMotionParticle extends Particle {
  final SpriteParticle spriteParticle;
  final double radius;
  final double speed;
  double angle = 0;

  CircularMotionParticle({
    required this.spriteParticle,
    required this.radius,
    required this.speed,
  });

  @override
  void update(double dt) {
    super.update(dt);
    angle += speed * dt; // Update the angle based on the speed and delta time
    if (angle > 2 * pi) {
      angle -= 2 * pi;
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    // Calculate the new position based on the current angle
    final x = radius * cos(angle);
    final y = radius * sin(angle);
    canvas.translate(x, y);
    spriteParticle.render(canvas);
    canvas.restore();
  }
}