SK = function(){};

SK.Snake = function(parent) {
	this.velocity = {x: 0, y: -1};
	this.parent = parent;
	this.length = 1;
	
	this.head = this.tail = new PFPlay.Sprite('img/snake.png', 'piece' + this.length);
	this.head.move(400, 300);
	this.parent.addObject(this.head);
	
	this.addPiece = function() {
		this.length++;
		var newTail = new PFPlay.Sprite('img/snake.png', 'piece' + this.length);
		newTail.prev = this.tail;
		this.tail.next = newTail;
		this.tail = newTail;
		this.parent.addObject(newTail);
	};
	
	this.destroySnake = function () {
		var node = this.tail;
		while(node.prev) {
			this.parent.removeObject(node);
		}
	};
	
	this.checkCollisionWithSelf = function() {
		var node = this.head.next;
		while(node) {
			if(node.position.x == this.head.position.x && 
				 node.position.y == this.head.position.y) {
				return true;
			}
			node = node.next;
		}
		return false;
	};
	
	this.checkCollisionWithRect = function(rect) {
		var pos = this.head.position;
		if(pos.x <= rect.x || pos.x >= rect.x + rect.width ||
			 pos.y <= rect.y || pos.y >= rect.y + rect.height) {
			 return true;
		}
		return false;
	};
	
	this.canEatApple = function(position) {
		if(position.x == this.head.position.x && 
			 position.y == this.head.position.y) {
			return true;
		}
		return false;
	};
	
	this.checkPositionInSnake = function(position) {
		var node = this.head;
		while(node) {
			if(node.position.x == position.x && 
				 node.position.y == position.y) {
				return true;
			}
			node = node.next;
		}
		return false;
	};
	
	this.update = function() {
		var node = this.tail;
		var diff = {};
		while(node.prev) {
			diff = {x: node.prev.position.x - node.position.x, y: node.prev.position.y - node.position.y};
			node.move(diff.x, diff.y);
			node = node.prev
		}
		this.head.move(this.velocity.x * 10, this.velocity.y * 10);
	};
}

function onload() {
	var c = document.getElementById("visible-screen");
	ctx = c.getContext("2d");
	
	var scoreLabel = document.getElementById("score");

	var world = new PFPlay.Layer(800, 600, 0, 0);
	
	var snake = new SK.Snake(world);
	snake.addPiece();
	snake.addPiece();
	
	var apple = new PFPlay.Sprite('img/apple.png', 'apple');
	
	var bgimg = new Image();
	bgimg.src = 'img/background.png';
	
	var time = (new Date()).getTime();
	
	var tickCurrent = 0;
	var ticklength = 100;
	var currentscore = 0;
	
  world.addObject(apple);
  
  apple.move(10, 10);
  apple.moveapple = function () {
  	var pos = {x: Math.floor(Math.random()*76) * 10 + 20, y: Math.floor(Math.random()*56) * 10 + 20};
  	while(snake.checkPositionInSnake(pos)) {
  		pos = {x: Math.floor(Math.random()*76) * 10 + 20, y: Math.floor(Math.random()*56) * 10 + 20};
  	}
  	var diff = {x: pos.x - this.position.x, y: pos.y - this.position.y};
  	apple.move(diff.x, diff.y);
  };
  
  apple.moveapple();
  
  PFPlay.tick = 33;
  
  var gamestate = "intro";
  
  setInterval(function loop() {
  	
  	dt = (new Date()).getTime() - time;
  	if(dt >= ticklength && gamestate == "playing") {
  		snake.update();
  		var collision = snake.checkCollisionWithSelf();
  		if(!collision) {
  			collision = snake.checkCollisionWithRect({x: 10, y: 10, width: 770, height: 570});
  		}
  		if(collision) {
  			gamestate = "gameover";
  		}
  		if(snake.canEatApple(apple.position)) {
  			currentscore += 42;
  			scoreLabel.innerHTML = "Score: " + currentscore;
  			snake.addPiece();
  			apple.moveapple();
  		}
  		
			time = (new Date()).getTime();
		}
  	
		world.update();
		
		ctx.drawImage(bgimg, 0, 0);
		ctx.drawImage(world.getCanvas(), 0, 0);
			
	}, PFPlay.tick);
	
	var body = document.getElementById("thebody");
	body.onkeydown = function(e)
	{
		e = e || window.event;
		if(e.keyCode == 13 /* enter key */) {
			if(gamestate == "intro" || gamestate == "paused") {
				gamestate = "playing";
			} else if(gamestate == "playing") {
				gamestate = "paused";
			}
		}
		
		if(e.keyCode == 37 /* left arrow */) {
			if(snake.velocity.x != 1 && snake.velocity.x != -1) {
				snake.velocity = {x: -1, y: 0};
			}
		} else if(e.keyCode == 38 /* up arrow */) {
			if(snake.velocity.y != 1 && snake.velocity.y != -1) {
				snake.velocity = {x: 0, y: -1};
			}
		} else if(e.keyCode == 39 /* right arrow */) {
			if(snake.velocity.x != 1 && snake.velocity.x != -1) {
				snake.velocity = {x: 1, y: 0};
			}
		} else if(e.keyCode == 40 /* down arrow */) {
			if(snake.velocity.y != 1 && snake.velocity.y != -1) {
				snake.velocity = {x: 0, y: 1};
			}
		}
	}
}

