package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.tile.FlxTilemap;
import flixel.group.FlxGroup;
import openfl.Assets;

class PlayState extends FlxState {

	private static var isDead:Bool = false;
	private var map:FlxTilemap;
	private var player:FlxSprite;
	private var score:FlxText;
	private var objects:FlxGroup;
	private var enemies:FlxGroup;
	private var text:FlxText;
	private var scoreNumber:Int = 0;
	private var level:Int = 1;
	private var X:Array<Int> = [1,4,10,18,22,30,37,5,9,20,27,31,10,34,1,4,13,31,35,2,6,21,25,27,7,16,31,1,6,11,14,18,22,30,38];
	private var Y:Array<Int> = [1,1,2,3,3,1,3,5,5,6,5,5,8,9,12,21,14,13,13,17,17,16,16,16,21,22,25,28,28,28,28,28,28,28,28];

	override public function create():Void {
		FlxG.cameras.bgColor = FlxColor.WHITE;
		FlxG.mouse.visible = false;
		super.create();

		//Player
		player = new FlxSprite(34 * 8, 25 * 8);
		player.makeGraphic(8, 8, FlxColor.RED);
		player.maxVelocity.set(80, 200);
		player.acceleration.y = 150;
		player.drag.x = player.maxVelocity.x * 2;
		add(player);

		//Text
		text = new FlxText(0, 80, FlxG.width, "Collect all coins!");
		text.setFormat(null, 16, FlxColor.BLACK, "center");
		add(text);

		//Score
		score = new FlxText(0, 96, FlxG.width, "0");
		score.setFormat(null, 20, FlxColor.BLACK, "center");
		add(score);

		//Map
		map = new FlxTilemap();
		map.loadMap(Assets.getText("assets/map2.csv"), "assets/tiles.png", 8, 8, FlxTilemap.OFF);
		add(map);

		//Coins
		objects = new FlxGroup();
		addCoin(1,1);
		add(objects);

		//Enemies
		enemies = new FlxGroup();
		//addEnemy(10,8,7);
		add(enemies);
	}
	
	override public function destroy():Void {
		super.destroy();
	}

	override public function update():Void {
		player.acceleration.x = 0;
		if(FlxG.keys.anyPressed(["LEFT","A"])){
			player.acceleration.x = -player.maxVelocity.x * 2;
		}
		if(FlxG.keys.anyPressed(["RIGHT","D"])){
			player.acceleration.x = player.maxVelocity.x * 2;
		}
		if(FlxG.keys.anyPressed(["SPACE","UP","W"])){
			player.velocity.y = -player.maxVelocity.y / 2;
		}
		if(player.y > FlxG.height){
			endGame();
		}

		super.update();
		updateCoins(level);
		FlxG.overlap(objects, player, getScore);
		FlxG.collide(map, player);
		FlxG.overlap(enemies, player, touchEnemy);
		
	}

	private function addCoin(X:Int, Y:Int):Void {
		var coin:FlxSprite = new FlxSprite(X * 8, Y * 8);
		coin.makeGraphic(8, 8, FlxColor.GREEN);
		objects.add(coin);
	}

	private function updateCoins(Level:Int):Void {
		if(objects.countLiving() == 0){
			var needToAdd:Int = 3 * Level;
			var randomNumber:Int;
			for(x in 0...needToAdd){
				randomNumber = Std.random(X.length);
				addCoin(X[randomNumber],Y[randomNumber]);
			} 
			trace("Coins added");
		}
	}

	private function getScore(Coin:FlxObject, Player:FlxObject):Void {
		Coin.kill();
		scoreNumber = scoreNumber + 1;
		trace(scoreNumber);
		score.text = "" + scoreNumber;
		if(objects.countLiving() == 0){
			level++;
		}
	}

	private function touchEnemy(Enemy:FlxObject, Player:FlxObject):Void {
		endGame();
	}

	private function endGame():Void {
		player.reset(34 * 8, 25 * 8);
		scoreNumber = 0;
		score.text = "0";
		trace(scoreNumber);
	}

	private function addEnemy(X:Int, Y:Int, Speed:Int){
		var enemy:FlxSprite = new FlxSprite(X * 8,Y * 8);
		enemy.loadRotatedGraphic("assets/enemy.png");
		enemy.antialiasing = true;
		enemy.angle = 45;
		enemies.add(enemy);
		enemy.x = enemy.x + 200;
	}
}