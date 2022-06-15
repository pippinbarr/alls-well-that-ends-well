package
{
	
	// BOX2D LIBRARY
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import agents.*;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;
	import flash.ui.Mouse;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxCollision;	
	
	
	// GameState
	//
	// Ah, the game state. It handles the game state. Which means:
	//
	//   * Introductory text
	//   * The actual gameplay (terrain, avatar, missiles) and victory conditions
	//   * Results text and transition to next level
	
	public class GameState extends FlxState {

		[Embed(source="assets/sounds/Explosion.mp3")]
		private const EXPLOSION_SOUND:Class;
		private var _explosionSound:FlxSound;
		
		[Embed(source="assets/sounds/Respawn.mp3")]
		private const RESPAWN_SOUND:Class;
		private var _respawnSound:FlxSound;
		
		[Embed(source="assets/sounds/Success.mp3")]
		private const SUCCESS_SOUND:Class;
		private var _successSound:FlxSound;
		
		// CONSTANTS FOR STATE TRACKING
		private const FOCUS:int = -1;
		private const INSTRUCTIONS:int = 0;
		private const PLAYING:int = 1;
		private const RESULTS:int = 2;
		
		
		// CONSTANTS FOR GROUP SIZES
		private const MAX_DEAD_AVATARS:uint = 25;
		private const MAX_MISSILES:uint = 100;

		// WORLD FOR PHYSICS
		public var _world:b2World;
		
		// MAIN ELEMENTS OF GAME STATE
		private var _avatar:Agent; // The avatar
		private var _deadAvatars:FlxGroup; // The collection of dead avatars
		private var _missiles:FlxGroup; // The collection of missiles
		private var _deadMissiles:FlxGroup;
		private var _explosionEmitter:FlxEmitter;
		private var _landscape:Landscape; // The landscape/ground
		private var _text:Text; // The text displayer
		
		private var _missile:Agent; // A single instance of the current missile class
		
		// REFERENCES FOR GETDEFINITIONBYNAME
		private var asteroidClass:Asteroid;
		private var bandaidClass:Bandaid;
		private var briefcaseClass:Briefcase;
		private var broccoliClass:Broccoli;
		private var carClass:Car;
		private var chairClass:Chair;
		private var forkClass:Fork;
		private var ghostClass:Ghost;
		private var gulagClass:Gulag;
		private var logClass:WoodLog;
		private var loveClass:Love;
		private var minifigClass:Minifig;
		private var missileClass:Missile;
		private var mobyDickClass:MobyDick;
		private var pearClass:Pear;
		private var planeClass:Plane;
		private var scrabbleTileClass:ScrabbleTile;
		private var skullClass:Skull;
		private var xWingClass:XWing;
		private var zardozHeadClass:ZardozHead;
		
		private const AGENTS:Array = new Array(
			"agents.Asteroid", "agents.Bandaid", "agents.Briefcase", "agents.Broccoli", "agents.Car", "agents.Chair",
			"agents.Fork", "agents.Ghost", "agents.Gulag", "agents.WoodLog", "agents.Love", "agents.Minifig", "agents.Missile",
			"agents.MobyDick", "agents.Pear", "agents.Plane", "agents.ScrabbleTile", "agents.Skull", "agents.XWing",
			"agents.ZardozHead"
		);
				
		// TIMERS
		private var _timer:FlxTimer;
		private var _pressSpaceTimer:Boolean = false; // Tracks whether timer to show press space has started
		private var _missileTimer:FlxTimer;		
						
		// TEMP VARIABLES TO KEEP DOWN MEMORY USE AND newING
		private var _tempVector:b2Vec2;
		private var _tempMassData:b2MassData;
		
		// TRACKING KEY PRESSES
		private const LEFT:uint = 0;
		private const RIGHT:uint = 1;
		private const UP:uint = 2;
		private const DOWN:uint = 3;
		private var _keys:Array = new Array( false, false, false, false );
				
		// STORING THE CURRENT GAMESTATE'S AVATAR AND MISSILE CLASS NAMES
		private var _currentAvatarClass:String = "agents.Asteroid";
		private var _currentMissileClass:String = "agents.Asteroid";
		
		// STATE TRACKING BOOLEANS
		private var _currentState:int = INSTRUCTIONS;
		
		
		public function GameState() {
			
			super();
			
		}
		
		
		public override function create():void {
						
			super.create();
			
			FlxG.bgColor = 0xFFFFFFFF;
			
			FlxG.mouse.hide();
			flash.ui.Mouse.hide();
			Mouse.hide();
			
			// KEYBOARD EVENT LISTENERS
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			FlxG.stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
			
			_explosionSound = new FlxSound();
			_explosionSound.loadEmbedded(EXPLOSION_SOUND);
			
			_respawnSound = new FlxSound();
			_respawnSound.loadEmbedded(RESPAWN_SOUND);
			
			_successSound = new FlxSound();
			_successSound.loadEmbedded(SUCCESS_SOUND);
			
			// WORK OUT THE AVATAR AND MISSILE
			if (Globals.LEVEL == -1) {
				// Nothing - DEBUG mode
				_currentAvatarClass = "agents.Asteroid";
				_currentMissileClass = "agents.Asteroid";
			}
			else if (Globals.LEVEL == 0) {
				_currentAvatarClass = "agents.Plane";
				_currentMissileClass = "agents.Missile";
				_currentState = INSTRUCTIONS; // WAS FOCUS TO GET CLICK
				Globals.LEVEL = 1;
			}
			else if (Globals.LEVEL == 1) {
				_currentAvatarClass = "agents.XWing";
				_currentMissileClass = "agents.Asteroid";
				Globals.LEVEL = 2;
			}
			else {
				_currentAvatarClass = AGENTS[Math.floor(Math.random() * AGENTS.length)];
				_currentMissileClass = AGENTS[Math.floor(Math.random() * AGENTS.length)];
			}
			
			// GENERATE THE INSTRUCTIONS TEXT
			var AvatarClass:Class = getDefinitionByName(_currentAvatarClass) as Class;
			var MissileClass:Class = getDefinitionByName(_currentMissileClass) as Class;
			_text = new Text(AvatarClass.NAME_SINGULAR,MissileClass.NAME_PLURAL);

			if (_currentState == FOCUS) {
				FlxG.stage.addEventListener(MouseEvent.CLICK,onMouseClick);
				_text.showGetFocus();
			}
			else {
				startGame();
			}
		}
		
		private function startGame():void {
						
			_text.showInstructions();
			
			setupWorld();
			
			_currentState = INSTRUCTIONS;
						
		}
		
		
		private function onMouseClick(e:MouseEvent):void {
			FlxG.stage.removeEventListener(MouseEvent.CLICK,onMouseClick);
			_text.hideGetFocus();
			_currentState = INSTRUCTIONS;
			FlxG.stage.focus = null;
			startGame();
		}
		
		
		private function setupWorld():void {			
			
			// TEMPORARY VARIABLES TO AVOID newING
			_tempVector = new b2Vec2(0,0);
			_tempMassData = new b2MassData();
			
			// SET UP THE TIMERS
			_timer = new FlxTimer();
			_missileTimer = new FlxTimer();

			// SET UP THE PHYSICS WORLD
			setupB2DWorld();
			setupB2DWorldDebug();
			
			// LISTEN FOR CONTACT ON THE AVATAR (TO DETECT COLLISION WITH LANDSCAPE)
			var avatarContactListener:AvatarContactListener = new AvatarContactListener();
			_world.SetContactListener(avatarContactListener);
			
			// SETUP THE AVATAR
			var AvatarClass:Class = getDefinitionByName(_currentAvatarClass) as Class;
			_avatar = new AvatarClass;
			_avatar.setupAsAvatar(0 + _avatar.WIDTH/2,FlxG.height/2 - 100,_world,false);
			
			// ADD THE GROUND
			_landscape = new Landscape(_world);
					
			// ADD THE MISSILES SO THEY ALREADY COVER THE SCREEN ON STARTUP
			_missiles = new FlxGroup(MAX_MISSILES);
			add(_missiles);
			
			// MAKE ONE INSTANCE OF A MISSILE FOR CHECKING WIDTH ETC
			var MissileClass:Class = getDefinitionByName(_currentMissileClass) as Class;
			_missile = new MissileClass;
			
			if (!Globals.NO_MISSILES_DEBUG) addMissiles(null);
			
		}
		
		
		private function startPlay():void {
			
			// ADD THE LANDSCAPE
			FlxG.stage.addChild(_landscape);
			
			// ADD THE AVATAR
			add(_avatar);
			_avatar.flicker(Globals.AVATAR_INVULNERABILITY_TIME);
			zeroAvatarVelocity();
			
			// ADD THE DEAD AVATARS GROUP
			_deadAvatars = new FlxGroup(MAX_DEAD_AVATARS);
			add(_deadAvatars);
			
			// ADD THE DEAD MISSILES GROUP
			_deadMissiles = new FlxGroup(MAX_DEAD_AVATARS);
			add(_deadMissiles);
			
			_currentState = PLAYING;
		}
		
		
		private function setupB2DWorldDebug():void {

			// CREATE THE DEBUG DRAW OBJECT AND ASSSIGN IT THE SPRITE ETC.
			var dbgDraw:b2DebugDraw = new b2DebugDraw();
			dbgDraw.SetSprite(Globals.DEBUG_SPRITE);
			dbgDraw.SetDrawScale(30);
			dbgDraw.SetFlags(b2DebugDraw.e_shapeBit|b2DebugDraw.e_jointBit|b2DebugDraw.e_aabbBit|b2DebugDraw.e_pairBit|b2DebugDraw.e_centerOfMassBit);
			_world.SetDebugDraw(dbgDraw);
			
		}
		
		
		private function setupB2DWorld():void {
			
			// GRAVITY!
			var gravity:b2Vec2 = new b2Vec2(0,0);
			
			// WORLD!
			_world = new b2World(gravity,true);
			
			// BOOM!
			
		}
		
		
		public override function update():void {
						
			trace("currentState is " + _currentState);
						
			if (FlxG.keys.ESCAPE)
			{
				Globals.LEVEL = 0;
				FlxG.switchState(new GameState);
			}
			
			// MEMORY CHECKS
			if (Globals.LOOP_MEM_DEBUG) trace("update() start: " + (System.totalMemory / 1024 / 1024) + " MB");
			if (Globals.MEM_DEBUG) trace("update() start: " + (System.totalMemory / 1024 / 1024) + " MB");
			
			if (_currentState == FOCUS) {
				super.update();
				return;
			}
			
			// DON'T UPDATE IF IN RESULTS
			if (_currentState == RESULTS) {
				_world.Step(FlxG.elapsed, 10, 10);	
				super.update();
				return;
			}
			
			// DON'T UPDATE IF NOT IN GAMEPLAY
			if (_currentState == INSTRUCTIONS) {
				super.update();
				if (!_pressSpaceTimer) {
					_pressSpaceTimer = true;
					_timer.start(1,1,showPressSpace);
				}
				return;
			}
			
			// OTHERWISE CURRENT STATE IS 'PLAYING'
			
			// CHECK FOR VICTORY CONDITION (AVATAR GETS TO RIGHT SIDE)
			if (_avatar.x > FlxG.width && _currentState != RESULTS) {
				_successSound.play();
				_currentState = RESULTS;
				_timer.start(1,1,_text.showResult);
				return;
			}
			// CHECK FOR AVATAR GOING TOO LEFT
			else if (_avatar._obj.GetPosition().x < 0) {
				_avatar._obj.SetPosition(new b2Vec2(0,_avatar._obj.GetPosition().y));
			}
			// CHECK FOR AVATAR GOING TOO HIGH
			if (_avatar._obj.GetPosition().y < 0) {
				_avatar._obj.SetPosition(new b2Vec2(_avatar._obj.GetPosition().x,0));
			}
			
			// MOVE THE AVATAR
			moveAvatar();
						
			// STEP THE PHYSICS
			_world.Step(FlxG.elapsed, 10, 10);	
			
			if (Globals.MEM_DEBUG) trace("post _world.Step(): " + (System.totalMemory / 1024 / 1024) + " MB");
			
			// CHECK COLLISIONS
			checkCollisions();
			
			if (Globals.MEM_DEBUG) trace("post checkCollisions(): " + (System.totalMemory / 1024 / 1024) + " MB");
			
			// MAKE ANY SLEEPING OBJECTS STATIC
			checkSleepers();
			
			if (Globals.MEM_DEBUG) trace("post checkSleepers(): " + (System.totalMemory / 1024 / 1024) + " MB");
			
			// DRAW DEBUG INFORMATION
			if (Globals.PHYSICS_DEBUG) _world.DrawDebugData();
			
			super.update();
			
			if (Globals.MEM_DEBUG) trace("post super.update(): " + (System.totalMemory / 1024 / 1024) + " MB");
			
			
		}
		
		
		// checkSleepers
		//
		// Runs through all the physics bodies and checks on whether they're awake,
		// if not (they have come to rest on the ground), set them to have no mass
		// which is the equivalent of making them "static" and thus not included
		// in collision detection.
		
		private function checkSleepers():void {
			
			for (var bb:b2Body=_world.GetBodyList(); bb; bb=bb.GetNext()) {
				if (!bb.IsAwake()) {
					_tempMassData.mass = 0.0;
					_tempMassData.I = 0.0;
					bb.SetMassData(_tempMassData);
				}
			}
		}
		
		
		// check Collisions
		//
		// Run through all the missiles and check whether they are colliding with
		// the avatar. If so, kill the avatar and the missile.
		//
		// Also check whether the avatar has made contact with the ground and, if so,
		// kill the avatar.
		
		private function checkCollisions():void {
					
			// If the avatar is flickering or not visible it is invulnerable
			if (_avatar.flickering || !_avatar.visible) {
				return;
			}
			
			// Check collisions against all the missiles on the screen right now
			for (var i:uint = 0; i < _missiles.members.length; i++) {
				if (_missiles.members[i] != null && _missiles.members[i].x > 0) {
					if (_missiles.members[i].exists && FlxCollision.pixelPerfectCheck(_avatar,_missiles.members[i])) {
						killAvatar(_missiles.members[i].x,_missiles.members[i].y);
						_missiles.members[i].kill();
						_missiles.members[i].reset(FlxG.width,0);
						break;
					}
				}
			}	
			
			// Check if the avatar has hit the ground
			if (_avatar.contact()) {
				
				// Reset the contact variable and reset the avatar's position to be above where it was
				// and kill the avatar off, then start the timer for when it comes back to life
				_avatar._obj.GetUserData().contact = false;

				if (!_avatar.flickering) {
					_tempVector.x = _avatar._obj.GetPosition().x; 
					_tempVector.y = _avatar._obj.GetPosition().y - Globals.AVATAR_RESPAWN_EXTRA_HEIGHT/Globals.RATIO;
					_avatar._obj.SetPosition(_tempVector);
					killAvatar(-1,-1);				
					_timer.start(Globals.AVATAR_RESPAWN_DELAY,1,respawnAvatar);
				}
				
			}
		}
		
		
		
		// addMissiles
		//
		// Called to generate each "column" of missiles coming across the screen such that
		// the avatar won't be able to fly between the missiles.
		// Varies the X and Y of missiles to make slightly more irregular, and recalls itself
		// on a timer to bring the next wave such that the avatar cannot pass through it verically.
		
		private function addMissiles(t:FlxTimer):void {
						
			var MissileClass:Class = getDefinitionByName(_currentMissileClass) as Class;
			var missile:Agent;
			
			// Starting from a random percentage of the avatar's height/4
			// Keep generating new missiles at heights calculated to prevent the avatar
			// flying between them
			
			var missileX:Number;
			var missileY:Number;
			for (missileY = Math.random() * _avatar.HEIGHT/2;
				 missileY < _landscape.MAX_HEIGHT + 100; 
				 missileY += getNextMissileYGap()) {
				
				missile = _missiles.recycle(MissileClass) as Agent;
				missileX = FlxG.width + getNextMissileXGap();
				missile.setupAsMissile(missileX,missileY);
				missile.velocity.x = -missile.MISSILE_VELOCITY;
				
			}
		
			// Calculate when the next wave needs to come so that it won't have a big enough gap
			// for the avatar to fly up through
			var missileWaveDelay:Number = (_missile.WIDTH + _avatar.WIDTH) / _missile.MISSILE_VELOCITY;
			_missileTimer.start(missileWaveDelay,1,addMissiles);
			
			if (Globals.MEM_DEBUG) trace("post addMissiles(): " + (System.totalMemory / 1024 / 1024) + " MB");
			
		}
		
		
		// getNextMissileXGap
		//
		// Calculate the distance needed to make sure the avatar can't fly through a horizontal space between missiles
		
		private function getNextMissileXGap():Number {
			return (_missile.WIDTH + _avatar.WIDTH - Math.random()*_avatar.WIDTH/2);
		}
		
		
		// getNextMissileYGap
		//
		// Calculate the distance needed to make sure the avatar can't fly through a vertical space between missiles
		
		private function getNextMissileYGap():Number {
			return (_missile.HEIGHT + _avatar.HEIGHT - Math.random()*_avatar.HEIGHT/2);
		}
		
		
		
		// killAvatar
		//
		// Called when the avatar gets hit or flies into the ground. Makes the "real" avatar invisible,
		// and makes a new avatar object which can fall to the ground with physics etc., then calls
		// a timer to respawn the avatar
		
		private function killAvatar(X:int, Y:int):void {
			
			_explosionSound.play();
			
			// CREATE THE REPLACEMENT "DEAD" AVATAR AND LET IT FALL
			var AvatarClass:Class = getDefinitionByName(_currentAvatarClass) as Class;
			var deadAvatar:Agent = _deadAvatars.recycle(AvatarClass) as Agent;	
			deadAvatar.kill();
			deadAvatar.setupAsAvatar(_avatar.x, _avatar.y, _world, true);
			_tempVector.x = 0; _tempVector.y = 20 * deadAvatar._obj.GetMass();
			deadAvatar._obj.ApplyForce(_tempVector, deadAvatar._obj.GetPosition());
			deadAvatar.alpha = 1.0;
			
			// MAKE THE DEAD AVATAR "BOUNCE" APPROPRIATELY OFF THE CONTACT
			if (X == -1) {
				// IF IT HIT THE GROUND THEN REVERSE WHATEVER VELOCITY THE AVATAR HAD
				deadAvatar._obj.SetLinearVelocity(new b2Vec2(-_avatar._obj.GetLinearVelocity().x,-_avatar._obj.GetLinearVelocity().y));
			}
			else {
				// IF IT HIT A MISSILE, THEN JUST GO BACKWARDS
				deadAvatar._obj.SetLinearVelocity(new b2Vec2(-2,0));
			}
			
			if (X != -1) {
				// CREATE THE REPLACEMENT "DEAD" MISSILE AND LET IT FALL
				var MissileClass:Class = getDefinitionByName(_currentMissileClass) as Class;
				var deadMissile:Agent = _deadMissiles.recycle(MissileClass) as Agent;	
				deadMissile.kill();
				deadMissile.setupAsDeadMissile(X, Y, _world);
				_tempVector.x = 0; _tempVector.y = 20 * deadMissile._obj.GetMass();
				deadMissile._obj.ApplyForce(_tempVector, deadMissile._obj.GetPosition());
				deadMissile.alpha = 1.0;
				deadMissile._obj.SetLinearVelocity(new b2Vec2(2,0));
			}
			
			FlxG.flash(0xFF000000,0.2);
			
			// HIDE THE REAL AVATAR AND STOP IT MOVING, THEN SET TIMER FOR RESPAWN
			_avatar.visible = false;
			zeroAvatarVelocity();
			
			_timer.start(Globals.AVATAR_RESPAWN_DELAY,1,respawnAvatar);
			
			if (Globals.MEM_DEBUG) trace("post killAvatar(): " + (System.totalMemory / 1024 / 1024) + " MB");
			
		}
		
		
		
		// respawnAvatar
		//
		// Respawns the avatar by making it visible and making it flicker for its
		// "invulnerable" period
		
		private function respawnAvatar(t:FlxTimer):void {
			
			_respawnSound.play();
			_avatar.visible = true;
			_avatar.flicker(Globals.AVATAR_INVULNERABILITY_TIME);
			
		}
		
		
		// nextLevel
		//
		// Just starts a new game state for another (random) level
		
		private function nextLevel():void {
			
			FlxG.switchState(new GameState);
			
		}
		
		
		private function showPressSpace(t:FlxTimer):void {
			_text.showPressSpace(null);
		}
		
		// onKeyDown
		//
		// Just handle the arrow keys and space bar for moving through instructions
		
		private function onKeyDown(e:KeyboardEvent):void {
			
//			if (e.keyCode == Keyboard.Q) {
//				Globals.PHYSICS_DEBUG = !Globals.PHYSICS_DEBUG;
//			}
			
			if (_currentState == INSTRUCTIONS) {
				if (e.keyCode == Keyboard.SPACE && _text.pressSpaceVisible()) {
					_text.hideInstructions();
					_text.hidePressSpace();
					_pressSpaceTimer = false;
					startPlay();
				}
				return;
			}
			
			if (_currentState == RESULTS) {
				if (e.keyCode == Keyboard.SPACE && _text.pressSpaceVisible()) {
					nextLevel();
				}
			}
			
			if (e.keyCode == Keyboard.RIGHT || e.keyCode == Keyboard.D) {
				_keys[RIGHT] = true;
			}
			if (e.keyCode == Keyboard.LEFT || e.keyCode == Keyboard.A) {
				_keys[LEFT] = true;
			}
			if (e.keyCode == Keyboard.UP || e.keyCode == Keyboard.W) {
				_keys[UP] = true;
			}
			if (e.keyCode == Keyboard.DOWN || e.keyCode == Keyboard.S) {
				_keys[DOWN] = true;
			}
			
		}
		
		
		// onKeyUp
		//
		// Handles release of arrow keys (stops avatar moving)
 		
		private function onKeyUp(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.RIGHT || e.keyCode == Keyboard.D) {
				_keys[RIGHT] = false;
				zeroAvatarVelocity();
			}
			if (e.keyCode == Keyboard.LEFT || e.keyCode == Keyboard.A) {
				_keys[LEFT] = false;
				zeroAvatarVelocity();
			}
			if (e.keyCode == Keyboard.UP || e.keyCode == Keyboard.W) {
				_keys[UP] = false;
				zeroAvatarVelocity();
			}
			if (e.keyCode == Keyboard.DOWN || e.keyCode == Keyboard.S) {
				_keys[DOWN] = false;
				zeroAvatarVelocity();
			}
		}
		
		
		// moveAvatar
		//
		// Handle actually moving the avatar when keys are held down, only works when the avatar
		// is actually visible, and just uses physics stuff (an Impulse) to set the avatar
		// in motion.
		
		private function moveAvatar():void {
			
			if (_avatar.visible) {
				
				if (_keys[RIGHT]) {
					if (_avatar._obj.GetLinearVelocity().x != Globals.AVATAR_VELOCITY_X/Globals.RATIO) {
						zeroAvatarVelocity();
						_tempVector.x = Globals.AVATAR_VELOCITY_X/Globals.RATIO; _tempVector.y = 0;
						_avatar._obj.ApplyImpulse(_tempVector,_avatar._obj.GetLocalCenter());
						_avatar._obj.SetLinearVelocity(_tempVector);
						_avatar._obj.SetAngularVelocity(0);
					}
				}
				if (_keys[LEFT]) {
					if (_avatar._obj.GetLinearVelocity().x != -Globals.AVATAR_VELOCITY_X/Globals.RATIO) {
						zeroAvatarVelocity();
						_tempVector.x = -Globals.AVATAR_VELOCITY_X/Globals.RATIO; _tempVector.y = 0;
						_avatar._obj.ApplyImpulse(_tempVector,_avatar._obj.GetLocalCenter());
						_avatar._obj.SetLinearVelocity(_tempVector);
						_avatar._obj.SetAngularVelocity(0);
					}
				}
				if (_keys[UP]) {
					if (_avatar._obj.GetLinearVelocity().y != -Globals.AVATAR_VELOCITY_Y/Globals.RATIO) {
						zeroAvatarVelocity();
						_tempVector.x = 0; _tempVector.y = -Globals.AVATAR_VELOCITY_Y/Globals.RATIO;
						_avatar._obj.ApplyImpulse(_tempVector,_avatar._obj.GetLocalCenter());
						_avatar._obj.SetLinearVelocity(_tempVector);
						_avatar._obj.SetAngularVelocity(0);
					}
				}
				if (_keys[DOWN]) {
					if (_avatar._obj.GetLinearVelocity().y != Globals.AVATAR_VELOCITY_Y/Globals.RATIO) {
						zeroAvatarVelocity();
						_tempVector.x = 0; _tempVector.y = Globals.AVATAR_VELOCITY_Y/Globals.RATIO;
						_avatar._obj.ApplyImpulse(_tempVector,_avatar._obj.GetLocalCenter());
						_avatar._obj.SetLinearVelocity(_tempVector);
						_avatar._obj.SetAngularVelocity(0);
					}
				}
			}
			
		}
		
		
		// zeroAvatarVelocity
		//
		// Sets the avatar's linear velocity to zero
		
		private function zeroAvatarVelocity():void {
			_tempVector.x = 0; _tempVector.y = 0;
			_avatar._obj.SetLinearVelocity(_tempVector);
			_avatar._obj.SetAngularVelocity(0);
			_avatar._obj.SetAngle(0);
		}
		
		
		// destroy
		//
		// Should... destroy everything
		
		public override function destroy():void {
			
			if (_text) _text.destroy();
			if (_deadAvatars) _deadAvatars.destroy();
			if (_missiles) _missiles.destroy();
			if (_missile) _missile.destroy();
			if (_avatar) _avatar.destroy();
			
			if (_landscape && FlxG.stage.contains(_landscape)) FlxG.stage.removeChild(_landscape);
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			
			
			
			super.destroy();
			
		}
	}
}