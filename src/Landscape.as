package
{
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import org.flixel.*;
	
	public class Landscape extends Sprite
	{				
		
		// BOX2D ELEMENTS
		public var _fixDef:b2FixtureDef;
		public var _bodyDef:b2BodyDef;
		public var _obj:b2Body;
		
		private var _world:b2World;
		
		//Physics params default value
		public var _friction:Number = 0.8;
		public var _restitution:Number = 0.3;
		public var _density:Number = 0.7;
		
		//Default angle
		public var _angle:Number = 0;
		
		//Default body type
		public var _type:uint = b2Body.b2_staticBody;
		
		// Landscape drawing variables
		private var _perlinNoise:BitmapData;
		private var SLICE_WIDTH:Number = 10;
		public var MAX_HEIGHT:Number = FlxG.height/2;
		
		
		public function Landscape(w:b2World):void {
			
			super();
			
			_world = w;
						
			this.createPerlinBitmap();
			this.drawLandscape();
			this.createBody();		
			
		}
		
		// createPerlinBitmap
		//
		// Creates a 1D array of bitmap data storing Perlin values
		
		private function createPerlinBitmap():void {
			
			_perlinNoise = new BitmapData((FlxG.width / SLICE_WIDTH) + 1, 1);
			_perlinNoise.perlinNoise ( 20, 1, 4, Math.random()*100, true, true ); 

		}
		
		
		// drawLandscape
		//
		// Uses flash drawing API to draw a landscape according to Perlin noise
		
		private function drawLandscape():void {
						
			// DRAW THE MOUNTAINS
			
			var currentSliceX:uint = 0;
			var startY:uint = FlxG.height - getPerlinHeight(0);
				
			graphics.lineStyle(1);
			graphics.beginFill(0x000000);
			graphics.moveTo(currentSliceX,startY);

			for (var i:uint = 1; i < _perlinNoise.width; i++) {
				currentSliceX += SLICE_WIDTH;
				graphics.lineTo(currentSliceX,FlxG.height - getPerlinHeight(i));
			}
			
			graphics.lineTo(currentSliceX,FlxG.height);
			graphics.lineTo(0,FlxG.height);
			graphics.endFill();
			
			// DRAW THE SHADING
			graphics.lineStyle(1,0xFFFFFF);
			
			currentSliceX = 0;
			var currentSliceY:Number;
			var nextSliceY:Number;
			var currentY:Number = 0;
			var currentX:Number = 0;
			
			for (i = 0; i < _perlinNoise.width; i++) {
				
				currentSliceY = FlxG.height - getPerlinHeight(i);
				nextSliceY = FlxG.height - getPerlinHeight(i+1);
				
				if (currentSliceY - nextSliceY < 0) {
					currentSliceX += SLICE_WIDTH;
					continue;
				}
				
				for (var j:uint = 0; j < SLICE_WIDTH; j += 2) {
					currentX = currentSliceX + j;
					currentY = nextSliceY + ((currentSliceY - nextSliceY) / (j + 1))
					graphics.moveTo(currentX,currentY);
					var random:Number = Math.random();
					graphics.lineTo(currentX + random * 5 + 2, currentY + random * 5 + 2);
				}
				
				currentSliceX += SLICE_WIDTH;
			}
			
		}
		
		
		// createBody
		//
		// Generates a physics body matching the drawn Perlin landscape for collisions
		
		public function createBody():void {
			
			// GENERATE PERLIN NOISE PHYSICS OBJECT WITH MULTIPLE FIXTURES
			
			// Body definition
			_bodyDef = new b2BodyDef();
			_bodyDef.position.Set(0,FlxG.height/Globals.RATIO);
			_bodyDef.angle = _angle * (Math.PI / 180);
			_bodyDef.type = _type;
			
			// Create the object
			_obj = _world.CreateBody(_bodyDef);
			
			// Generate the multiple fixtures for the slices
			var boxShape:b2PolygonShape;
			var currentX:Number = 0;
			var currentYDisplacement:Number = getPerlinHeight(0);
			var value:uint;

			for (var j:uint = 1; j < _perlinNoise.width; j++) {
				value = _perlinNoise.getPixel(j,0);
				boxShape = new b2PolygonShape();
				boxShape.SetAsArray(new Array(
					new b2Vec2(currentX/Globals.RATIO,-currentYDisplacement/Globals.RATIO),
					new b2Vec2((currentX + SLICE_WIDTH)/Globals.RATIO,-getPerlinHeight(j)/Globals.RATIO),
					new b2Vec2((currentX + SLICE_WIDTH)/Globals.RATIO,0),
					new b2Vec2(currentX/Globals.RATIO,0)),0);

				_fixDef = new b2FixtureDef();
				_fixDef.density = _density;
				_fixDef.restitution = _restitution;
				_fixDef.friction = _friction;                        
				_fixDef.shape = boxShape;
				_fixDef.filter.groupIndex = 0;
				
				_obj.CreateFixture(_fixDef);
				
				currentX += SLICE_WIDTH;
				currentYDisplacement = getPerlinHeight(j);
			}
						
			var bodyData:Object = new Object();
			bodyData.contact = false;
			bodyData.avatar = false;
			_obj.SetUserData(bodyData);	

			
		}
		
		private function getPerlinHeight(slice:uint):Number {
			return (_perlinNoise.getPixel(slice,0)/0xFFFFFF) * MAX_HEIGHT;
		}
				
		private function destroy():void {
			
		}
		
	}
}