import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import '../../systems/particle_system.dart';
import '../enemy_spawner.dart';
import '../floating_text.dart';

/// Animation states for slimes
enum SlimeAnimState { idle, jump, hurt, death }

/// Base class for all slime variants - uses sprite animations
abstract class SlimeBase extends Enemy {
  SlimeBase({
    required super.position,
    required super.maxHp,
    required super.speed,
    required super.contactDamage,
    required super.color,
    super.shootInterval,
    super.bulletDamage,
    this.spriteId = 'green',
    this.canvasSize = 16,
  }) : super(
         // Larger hitbox for big slimes
       );

  /// Sprite ID (matches filename: slime_[id]_idle.png etc.)
  final String spriteId;

  /// Canvas size of source sprite (16, 24, 48, or 60)
  final int canvasSize;

  /// Animation duration map
  static const _idleStepTime = 0.16;  // 6fps
  static const _jumpStepTime = 0.12;  // 8fps
  static const _hurtStepTime = 0.10;  // 10fps
  static const _deathStepTime = 0.10; // 10fps

  // Animation components
  SpriteAnimationComponent? _animComponent;
  SpriteAnimation? _idleAnim;
  SpriteAnimation? _jumpAnim;
  SpriteAnimation? _hurtAnim;
  SpriteAnimation? _deathAnim;

  SlimeAnimState _currentState = SlimeAnimState.idle;
  bool _isMoving = false;

  /// Display size (rendered larger than source for visibility)
  double get displayScale => 2.0;

  Vector2 get _displaySize => Vector2.all(canvasSize * displayScale);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Adjust component size based on canvas
    size = _displaySize;

    // Remove default body (color rectangle)
    if (children.whereType<RectangleComponent>().isNotEmpty) {
      removeAll(children.whereType<RectangleComponent>());
    }

    try {
      _idleAnim = await _loadAnimation('idle', _idleStepTime, true);
      _jumpAnim = await _loadAnimation('jump', _jumpStepTime, true);
      _hurtAnim = await _loadAnimation('hurt', _hurtStepTime, false);
      _deathAnim = await _loadAnimation('death', _deathStepTime, false);
    } catch (e) {
      // Sprite missing fallback - use color rectangle
      _addColorFallback();
      return;
    }

    _animComponent = SpriteAnimationComponent(
      animation: _idleAnim,
      size: _displaySize,
      anchor: Anchor.topLeft,
    );
    add(_animComponent!);

    // Re-add hitbox
    add(RectangleHitbox(size: _displaySize * 0.7,
        position: _displaySize * 0.15));
  }

  Future<SpriteAnimation> _loadAnimation(String state, double stepTime, bool loop) async {
    final image = await game.images.load('slimes/slime_${spriteId}_$state.png');
    final frameCount = image.width ~/ canvasSize;
    final spriteSheet = SpriteSheet(
      image: image,
      srcSize: Vector2.all(canvasSize.toDouble()),
    );
    return spriteSheet.createAnimation(
      row: 0,
      stepTime: stepTime,
      to: frameCount,
      loop: loop,
    );
  }

  void _addColorFallback() {
    // Fallback if sprites missing
    add(RectangleComponent(
      size: _displaySize * 0.8,
      position: _displaySize * 0.1,
      paint: Paint()..color = color,
    ));
    add(RectangleHitbox(size: _displaySize * 0.7, position: _displaySize * 0.15));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isDead) return;

    // Detect motion to switch animation
    final movingNow = moveDirection.length > 0;
    if (movingNow != _isMoving) {
      _isMoving = movingNow;
      _setState(_isMoving ? SlimeAnimState.jump : SlimeAnimState.idle);
    }
  }

  /// Track movement intent (set by enemy AI)
  Vector2 moveDirection = Vector2.zero();

  void _setState(SlimeAnimState state) {
    if (_currentState == state || _animComponent == null) return;
    _currentState = state;
    switch (state) {
      case SlimeAnimState.idle:
        if (_idleAnim != null) _animComponent!.animation = _idleAnim;
        break;
      case SlimeAnimState.jump:
        if (_jumpAnim != null) _animComponent!.animation = _jumpAnim;
        break;
      case SlimeAnimState.hurt:
        if (_hurtAnim != null) _animComponent!.animation = _hurtAnim;
        break;
      case SlimeAnimState.death:
        if (_deathAnim != null) _animComponent!.animation = _deathAnim;
        break;
    }
  }

  @override
  void takeDamage(double damage, {bool isCritical = false}) {
    if (isDead) return;
    hp -= damage;

    // Show floating damage number
    game.world.add(FloatingText.damage(
      position + Vector2(0, -8),
      damage,
      isCritical: isCritical,
    ));

    // Trigger hurt animation state
    if (hp > 0) {
      _setState(SlimeAnimState.hurt);
      Future.delayed(const Duration(milliseconds: 200), () {
        if (!isDead) _setState(_isMoving ? SlimeAnimState.jump : SlimeAnimState.idle);
      });
    } else {
      hp = 0;
      isDead = true;
      onDeath();
    }
  }
  /// Override for slime-specific death effects
  void onSlimeDeath() {}

  @override
  void onDeath() {
    // Stats
    game.gameState.enemiesKilled++;
    final goldDrop = 10 + (DateTime.now().millisecondsSinceEpoch % 10);
    game.gameState.gold += goldDrop;

    // Show gold pickup text
    game.world.add(FloatingText.gold(
      position + Vector2(0, 4),
      goldDrop,
    ));

    // Slime-specific death effects (subclasses override)
    onSlimeDeath();

    // Particles
    ParticleSystem.spawnDeathEffect(game.world, position, color);

    // Play death animation, then remove
    _setState(SlimeAnimState.death);
    Future.delayed(const Duration(milliseconds: 600), () {
      removeFromParent();
    });
  }
}

/// Helper to spawn particles
extension SlimeParticles on SlimeBase {
  void spawnSlimeDeathParticles({Color? customColor, int count = 12}) {
    ParticleSystem.spawnDeathEffect(
      game.world,
      position,
      customColor ?? color,
    );
  }
}
