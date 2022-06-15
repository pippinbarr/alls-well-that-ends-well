package agents
{
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import org.flixel.*;
	
	public class Agent extends FlxSprite {
		
		private var DEAD_AVATAR_GROUP:int;

		// VARIABLES FOR MISSILE VERSION
		public var WIDTH:uint;
		public var HEIGHT:uint;
		public var MISSILE_VELOCITY:uint = 500;
		
		// MAIN BOX2D ELEMENTS
		public var _obj:b2Body;
		protected var _world:b2World;
		
		// DEFAULT PHYSICS PARAMETERS
		private var _friction:Number;
		private var _restitution:Number;
		private var _density:Number;
		
		// PHYSICS TYPE
		private var _type:uint;
		
		// SPRITE
		protected var _sprite:Class;
		
		// TRACKING IF THIS IS DEAD
		protected var _dead:Boolean = false;	
		protected var _setup:Boolean = false;
		
		public function Agent() {
			super();
		}
		
		public function setupAsAvatar(X:Number, Y:Number, world:b2World, dead:Boolean = false):void {
			
			x = X;
			y = Y;
			_dead = dead;
			
			_world = world;
			
			
			DEAD_AVATAR_GROUP = -1;
			
			_friction = 1;
			_restitution = 0.3;
			_density = 0.7;
			_type = b2Body.b2_dynamicBody;
			
			this.loadRotatedGraphic(_sprite,32,-1,true,true);
			//this.loadGraphic(_sprite,true,false,75,75);
			
			setupObject();
				
		}
		
		public function setupAsDeadMissile(X:Number, Y:Number, world:b2World):void {
			x = X;
			y = Y;
			
			_world = world;
			
			
			DEAD_AVATAR_GROUP = -1;
			
			_friction = 1;
			_restitution = 0.3;
			_density = 0.7;
			_type = b2Body.b2_dynamicBody;
			
			this.loadRotatedGraphic(_sprite,32,-1,true,true);
			
			setupObject();
		}
		
		
		public function setupAsMissile(X:Number, Y:Number):void {
			
			x = X;
			y = Y;
			
			if (!this._setup) {
				this.loadGraphic(_sprite);
				this._setup = true;
			}
		}
		
		protected function setupObject():void {
						
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.allowSleep = true;
			bodyDef.position.Set((x + (width/2)) / Globals.RATIO, (y + (height/2)) / Globals.RATIO);
			bodyDef.angle = 0;
			bodyDef.type = _type;
			
			_obj = _world.CreateBody(bodyDef);
			
			var bodyData:Object = new Object();
			bodyData.avatar = !_dead;
			bodyData.contact = false;
	
			_obj.SetUserData(bodyData);		
			
		}
		
		
		protected function addFixture(boxShape:b2Shape):void {
			var fixDef:b2FixtureDef = new b2FixtureDef();
			fixDef.density = _density;
			fixDef.restitution = _restitution;
			fixDef.friction = _friction;                        
			fixDef.shape = boxShape;
			fixDef.filter.groupIndex = DEAD_AVATAR_GROUP;
			
			_obj.CreateFixture(fixDef);
		}
		
		protected function setMass():void {
//			var massData:b2MassData = new b2MassData;
//			massData.mass = 0.5;
//			massData.I = 0.5;
//			_obj.SetMassData(massData);
		}
		
		public override function update():void {
			
			if (this._world != null) {
				x = (_obj.GetPosition().x * Globals.RATIO) - width/2 ;
				y = (_obj.GetPosition().y * Globals.RATIO) - height/2;
				angle = _obj.GetAngle() * (180 / Math.PI);				
			}
			
			if (this._world == null && this.x + this.width < 0) {
				this.kill();
			}
			
			super.update()
			
		}
		
		public function contact():Boolean {
			return _obj.GetUserData().contact;
		}
		
		public override function destroy():void {
			super.destroy();
		}
		
		public override function kill():void {
			if (this._obj != null) _world.DestroyBody(this._obj);
			this._obj = null;
			//_world.DestroyBody(_obj);
			//super.kill();
		}
		
	}
}