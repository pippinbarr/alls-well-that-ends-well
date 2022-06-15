package
{
	import flash.display.Sprite;

	public class Globals {

		
		// DEBUGGING
		public static var PHYSICS_DEBUG:Boolean = false;
		public static var MEM_DEBUG:Boolean = false;
		public static var LOOP_MEM_DEBUG:Boolean = false;
		public static var NO_MISSILES_DEBUG:Boolean = false;
		public static var DEBUG_SPRITE:Sprite;

		// DISPLAY CONVERSION
		public static const ZOOM:uint = 1;
		public static const RATIO:Number = 30;
		
		// VELOCITIES
		public static const AVATAR_VELOCITY_X:uint = 400;
		public static const AVATAR_VELOCITY_Y:uint = 400;
		public static const MISSILE_VELOCITY_X:uint = 400;
		
		// RESPAWN CONSTANTS
		public static const AVATAR_RESPAWN_DELAY:Number = 2;
		public static const AVATAR_RESPAWN_EXTRA_HEIGHT:uint = 50;
		public static const AVATAR_INVULNERABILITY_TIME:Number = 0.5;
		
		// GAMESTATE TRACKER
		public static var LEVEL:int = 0; // -1 means debug


		
		public function Globals() {
		}
	}
}