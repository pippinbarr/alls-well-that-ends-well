package
{
	
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.system.*;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxCollision;
	import agents.Agent;
	import agents.ZardozHead;
	
	public class PrototypeState extends FlxState {
		
		public var _world:b2World;
		
		private var _avatar:Agent;
		
		// Avatar class references for getDefinitionByName
		private var planeClass:Plane;
		private var zardozHeadClass:ZardozHead;
		private var bulletClass:Bullet;
		
		private var _deadAvatars:FlxGroup;
		private var _missiles:FlxGroup;
		private var _landscape:Landscape;
		
		private var _missileWaveTime:Number;
		private var _missileTimer:FlxTimer;
		
		private var _clicked:Boolean = false;
		
		private var _debugDrawSprite:Sprite;
		
		private var _timer:FlxTimer;		
		
		private var MISSILE_HEIGHT:Number = 5;
		private var MISSILE_WIDTH:Number = 10;
		
		private var MAX_DEAD_AVATARS:uint = 25;
		private var MAX_MISSILES:uint = 100;
		
		private var _tempVector:b2Vec2;
		private var _tempMassData:b2MassData;
		
		// TRACKING KEY PRESSES
		private const LEFT:uint = 0;
		private const RIGHT:uint = 1;
		private const UP:uint = 2;
		private const DOWN:uint = 3;
		private var _keys:Array = new Array( false, false, false, false );
		
		private var _currentAvatarClass:String = "Plane";
		private var _currentMissileClass:String = "Bullet";
		
		private var _text:Text;
		private var _showingResult:Boolean = false;
		
		private var _playing:Boolean = false;
		
		public function PrototypeState() {
			
			super();
			
		}
		
		
		public override function create():void {
			
			

			
			// EVENT LISTENERS
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			FlxG.stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
			
			
			var AvatarClass:Class = getDefinitionByName(_currentAvatarClass) as Class;
			var MissileClass:Class = getDefinitionByName(_currentMissileClass) as Class;

			_text = new Text(AvatarClass.NAME_SINGULAR,MissileClass.NAME_PLURAL);
			_text.showInstructions();
			
			super.create();
			
		}
		
		
		private function setupGame():void {
			
			_playing = true;
			
			_tempVector = new b2Vec2(0,0); // To store vectors as needed...
			
			setupB2DWorld();
			
			var avatarContactListener:AvatarContactListener = new AvatarContactListener();
			_world.SetContactListener(avatarContactListener);
			
			FlxG.bgColor = 0xFFFFFFFF;
			
			_timer = new FlxTimer();
			_missileTimer = new FlxTimer();
			
			// ADD THE GROUND
			_landscape = new Landscape(_world);
			FlxG.stage.addChild(_landscape);
			
			// ADD THE AVATAR
			var AvatarClass:Class = getDefinitionByName(_currentAvatarClass) as Class;
			_avatar = new AvatarClass;
			_avatar.setupAsAvatar(100,100,_world,false);
			add(_avatar);
			
			// SET UP DEBUG DRAWING
			var dbgDraw:b2DebugDraw = new b2DebugDraw();
			dbgDraw.SetSprite(Globals.DEBUG_SPRITE);
			dbgDraw.SetDrawScale(30);
			dbgDraw.SetFlags(b2DebugDraw.e_shapeBit|b2DebugDraw.e_jointBit|b2DebugDraw.e_aabbBit|b2DebugDraw.e_pairBit|b2DebugDraw.e_centerOfMassBit);
			_world.SetDebugDraw(dbgDraw);
			
			_missileWaveTime = (MISSILE_WIDTH + _avatar.width) / MISSILE_SPEED;
			trace("_missileWaveTime is " + _missileWaveTime);
			
			_missiles = new FlxGroup(MAX_MISSILES);
			add(_missiles);
			
			_deadAvatars = new FlxGroup(MAX_DEAD_AVATARS);
			add(_deadAvatars);
			
			addMissiles(null);
			
			
			_tempMassData = new b2MassData();
			
		}
		
		private function setupB2DWorld():void {
			
			//var gravity:b2Vec2 = new b2Vec2(0, 10);
			var gravity:b2Vec2 = new b2Vec2(0,0);
			
			_world = new b2World(gravity,true);
			
		}
		
		
		public override function update():void {
			
			if (!_playing) return;
			
			if (_avatar.x > FlxG.width && !_showingResult) {
				_text.showResult();
				_showingResult = true;
				_playing = false;
			}
			else if (_avatar._obj.GetPosition().x < 0) {
				_avatar._obj.SetPosition(new b2Vec2(0,_avatar._obj.GetPosition().y));
			}
			if (_avatar._obj.GetPosition().y < 0) {
				_avatar._obj.SetPosition(new b2Vec2(_avatar._obj.GetPosition().x,0));
			}
			
			if (Globals.LOOP_MEM_DEBUG) trace("update() start: " + (System.totalMemory / 1024 / 1024) + " MB");
			if (Globals.MEM_DEBUG) trace("update() start: " + (System.totalMemory / 1024 / 1024) + " MB");
			
			_world.Step(FlxG.elapsed, 10, 10);	
			
			moveAvatar();
			
			if (Globals.MEM_DEBUG) trace("post _world.Step(): " + (System.totalMemory / 1024 / 1024) + " MB");
			
			checkCollisions();
			
			if (Globals.MEM_DEBUG) trace("post checkCollisions(): " + (System.totalMemory / 1024 / 1024) + " MB");
			
			checkSleepers();
			
			if (Globals.MEM_DEBUG) trace("post checkSleepers(): " + (System.totalMemory / 1024 / 1024) + " MB");
			
			
			if (Globals.PHYSICS_DEBUG) _world.DrawDebugData();
			
			super.update();
			
			if (Globals.MEM_DEBUG) trace("post super.update(): " + (System.totalMemory / 1024 / 1024) + " MB");
			
			
		}
		
		private function checkSleepers():void {

			for (var bb:b2Body=_world.GetBodyList(); bb; bb=bb.GetNext()) {
				if (!bb.IsAwake()) {
					_tempMassData.mass = 0.0;
					_tempMassData.I = 0.0;
					bb.SetMassData(_tempMassData);

				}
			}
		}
		
		private function checkCollisions():void {
						
			//return;
			
			if (_avatar.flickering || !_avatar.visible) {
				return;
			}
			
			for (var i:uint = 0; i < _missiles.members.length; i++) {
				if (_missiles.members[i] != null) {
					if (_missiles.members[i].exists && FlxCollision.pixelPerfectCheck(_avatar,_missiles.members[i])) {
						killAvatar();
						_missiles.members[i].kill();
						_missiles.members[i].reset(FlxG.width,0);
					}
				}
			}	
			
			if (_avatar.contact()) {
				
				_avatar._obj.GetUserData().contact = false;
				_tempVector.x = _avatar._obj.GetPosition().x; _tempVector.y = _avatar._obj.GetPosition().y - 50/Globals.RATIO;
				_avatar._obj.SetPosition(_tempVector);
				killAvatar();				
				_timer.start(0.2,1,newLife);
				
			}
		}
		
		private function addMissiles(t:FlxTimer):void {
			
			for (var i:Number = Math.random()*_avatar.height/4; i < (FlxG.height); i += getNextMissileYGap()) {
				
				var MissileClass:Class = getDefinitionByName(_currentMissileClass) as Class;
				var missile:Agent = _missiles.recycle(MissileClass) as Agent;
				missile.setupAsMissile(FlxG.width + getNextMissileXGap(),i);
				missile.velocity.x = -MISSILE_SPEED;
			}
			
			_missileTimer.start(_missileWaveTime,1,addMissiles);
			
			if (Globals.MEM_DEBUG) trace("post addMissiles(): " + (System.totalMemory / 1024 / 1024) + " MB");
			
		}
		
		private function getNextMissileXGap():Number {
			return (MISSILE_WIDTH + _avatar.width - Math.random()*_avatar.width/2);
		}
		
		private function getNextMissileYGap():Number {
			return (MISSILE_HEIGHT + _avatar.height - Math.random()*_avatar.height/2);
		}
				
		private function killAvatar():void {
			
			var AvatarClass:Class = getDefinitionByName(_currentAvatarClass) as Class;
			var deadAvatar:Agent = _deadAvatars.recycle(AvatarClass) as Agent;	
			
			deadAvatar.kill();
			deadAvatar.setupAsAvatar(_avatar.x, _avatar.y, _world, true);
			_tempVector.x = 0; _tempVector.y = 20 * deadAvatar._obj.GetMass();
			deadAvatar._obj.ApplyForce(_tempVector, deadAvatar._obj.GetPosition());
			//deadAvatar._obj.SetLinearVelocity(new b2Vec2(0,10));
			
			//_deadAvatars.add(deadAvatar);
			
			// Set up the actual avatar to be "dead" and then to flicker back to life
			_avatar.visible = false;
			_tempVector.x = 0; _tempVector.y = 0;
			_avatar._obj.SetLinearVelocity(_tempVector);
			_avatar._obj.SetAngularVelocity(0);
			_avatar._obj.SetAngle(0);
			
			_timer.start(0.2,1,newLife);
			
			if (Globals.MEM_DEBUG) trace("post killAvatar(): " + (System.totalMemory / 1024 / 1024) + " MB");
			
		}
		
		private function newLife(t:FlxTimer):void {
			
			_avatar.visible = true;
			_avatar.flicker(1);
			
		}
		
		private function onKeyDown(e:KeyboardEvent):void {
			
			if (e.keyCode == Keyboard.D) {
				Globals.PHYSICS_DEBUG = !Globals.PHYSICS_DEBUG;
			}
			if (e.keyCode == Keyboard.SPACE) {
				_text.hideInstructions();
				setupGame();
			}
			
			if (e.keyCode == Keyboard.RIGHT) {
				_keys[RIGHT] = true;
			}
			if (e.keyCode == Keyboard.LEFT) {
				_keys[LEFT] = true;
			}
			if (e.keyCode == Keyboard.UP) {
				_keys[UP] = true;
			}
			if (e.keyCode == Keyboard.DOWN) {
				_keys[DOWN] = true;
			}
			
		}
		
		private function onKeyUp(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.RIGHT) {
				_keys[RIGHT] = false;
				_tempVector.x = 0; _tempVector.y = 0;
				_avatar._obj.SetLinearVelocity(_tempVector);
			}
			if (e.keyCode == Keyboard.LEFT) {
				_keys[LEFT] = false;
				_tempVector.x = 0; _tempVector.y = 0;
				_avatar._obj.SetLinearVelocity(_tempVector);
			}
			if (e.keyCode == Keyboard.UP) {
				_keys[UP] = false;
				_tempVector.x = 0; _tempVector.y = 0;
				_avatar._obj.SetLinearVelocity(_tempVector);
			}
			if (e.keyCode == Keyboard.DOWN) {
				_keys[DOWN] = false;
				_tempVector.x = 0; _tempVector.y = 0;
				_avatar._obj.SetLinearVelocity(_tempVector);
			}
		}
		
		
		private function moveAvatar():void {
			
			if (_avatar.visible) {
				
				if (_keys[RIGHT]) {
					if (_avatar._obj.GetLinearVelocity().x < PLANE_MAX_VELOCITY_Y/Globals.RATIO) {
						_tempVector.x = 0; _tempVector.y = 0;
						_avatar._obj.SetLinearVelocity(_tempVector);
						_tempVector.x = PLANE_MAX_VELOCITY_X/Globals.RATIO; _tempVector.y = 0;
						_avatar._obj.ApplyImpulse(_tempVector,_avatar._obj.GetLocalCenter());
						_avatar._obj.SetAngularVelocity(0);
					}
				}
				if (_keys[LEFT]) {
					if (_avatar._obj.GetLinearVelocity().x > -PLANE_MAX_VELOCITY_X/Globals.RATIO) {
						_tempVector.x = 0; _tempVector.y = 0;
						_avatar._obj.SetLinearVelocity(_tempVector);
						_tempVector.x = -PLANE_MAX_VELOCITY_X/Globals.RATIO; _tempVector.y = 0;
						_avatar._obj.ApplyImpulse(_tempVector,_avatar._obj.GetLocalCenter());
						_avatar._obj.SetAngularVelocity(0);
					}
				}
				if (_keys[UP]) {
					if (_avatar._obj.GetLinearVelocity().y > -PLANE_MAX_VELOCITY_Y/Globals.RATIO) {
						_tempVector.x = 0; _tempVector.y = 0;
						_avatar._obj.SetLinearVelocity(_tempVector);
						_tempVector.x = 0; _tempVector.y = -PLANE_MAX_VELOCITY_Y/Globals.RATIO;
						_avatar._obj.ApplyImpulse(_tempVector,_avatar._obj.GetLocalCenter());
						_avatar._obj.SetAngularVelocity(0);
					}
				}
				if (_keys[DOWN]) {
					if (_avatar._obj.GetLinearVelocity().y < PLANE_MAX_VELOCITY_Y/Globals.RATIO) {
						_tempVector.x = 0; _tempVector.y = 0;
						_avatar._obj.SetLinearVelocity(_tempVector);
						_tempVector.x = 0; _tempVector.y = PLANE_MAX_VELOCITY_Y/Globals.RATIO;
						_avatar._obj.ApplyImpulse(_tempVector,_avatar._obj.GetLocalCenter());
						_avatar._obj.SetAngularVelocity(0);
					}
				}
			}
			
		}
		
		
		public override function destroy():void {
			
			super.destroy();
			
		}
	}
}