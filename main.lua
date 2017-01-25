function love.load()
	enemyTimer = 0
	bulletTimer = 0

	window = {
		height = love.graphics.getHeight(),
		width = love.graphics.getWidth()
	}	

	Direction = {
		RIGHT = 0,
		LEFT = 1,
		UP = 2,
		DOWN = 4
	}

	mouse = {
		x = 0,
		y = 0
	}

    player = {
    	x = window.width/2 - 10,
    	y = window.height/2 - 10,
    	bullets = {
    		count = 0,
    		list = {}
    	},
    	fire = function()
			bullet = {}
			by_x = (mouse.x - player.x)
			by_y = (mouse.y - player.y)

			if (math.abs(by_x) > math.abs(by_y)) then
				bullet.directionx = (1/(by_x))*(by_x)
				bullet.directiony = (mouse.y - player.y)/math.abs(by_x)
			else
				bullet.directiony = (1/(by_y)) *(by_y)
				bullet.directionx = (mouse.x - player.x)/math.abs(by_y)
			end

			if(mouse.x < player.x and bullet.directionx > 0) then
				bullet.directionx = bullet.directionx * -1
			end
			if(mouse.y < player.y and bullet.directiony > 0) then
				bullet.directiony = bullet.directiony * -1
			end

			bullet.x = player.x + 8
			bullet.y = player.y + 8

			print(bullet.directionx)
			print(bullet.directiony)

			player.bullets.count = player.bullets.count + 1
			table.insert(player.bullets.list, bullet) 
		end
	}

	enemies = {
		count = 0,
		list = {},
		add = function ()
			enemy = {}
			enemy.hp = 5
			enemy.x = love.math.random( 50, window.width - 50 )
			enemy.y = love.math.random( 50, window.height - 50 )
			table.insert(enemies.list, enemy)
		end
	}
	
end

function love.keyreleased(key, u)
	
end

function love.keypressed(key, u)
    
end

function isMovementValid(direction) 
end

function love.update(dt)
	enemyTimer = enemyTimer + dt
	bulletTimer = bulletTimer + dt

	if ((love.keyboard.isDown("down") or love.keyboard.isDown("s")) and (player.y < window.height - 20)) then
		player.y = player.y + 5
	elseif ((love.keyboard.isDown("up") or love.keyboard.isDown("w")) and (player.y > 0)) then
		player.y = player.y - 5
	end

	if ((love.keyboard.isDown("right") or love.keyboard.isDown("d")) and (player.x < window.width - 20)) then
		player.x = player.x + 5
	elseif ((love.keyboard.isDown("left") or love.keyboard.isDown("a")) and (player.x > 0)) then
		player.x = player.x - 5
	end


	mouse.x = love.mouse.getX()
	mouse.y = love.mouse.getY()

	if love.mouse.isDown(1) and (bulletTimer > 0.1 or player.bullets.count == 0) then
		player.fire();
		bulletTimer = 0
	end

	if (enemyTimer > 5) then
		enemies.add()
		enemyTimer = 0
	end

	for bk,bv in pairs(player.bullets.list) do
		bv.x = bv.x + (bv.directionx*3)
		bv.y = bv.y + (bv.directiony*3)
		if ( (bv.x < -10 or bv.x > window.width + 10) or ( bv.y < -10 or bv.y > window.height + 10 ) ) then
			table.remove(player.bullets.list, bk) 
			player.bullets.count = player.bullets.count - 1
		end

		for ek,ev in pairs(enemies.list) do
			if ( (bv.x >= ev.x and bv.x <= (ev.x+10) or ( (bv.x+4)>= ev.x and (bv.x+4) <= (ev.x+10) ) ) and 
				  (bv.y >= ev.y and bv.y <= (ev.y+10) or ( (bv.y+4) >= ev.y and (bv.y+4) <= (ev.y+10) ) ) )then
				table.remove(player.bullets.list, bk) 
				player.bullets.count = player.bullets.count - 1
			end
		end
	end
end

function love.draw()
	love.graphics.print("Player X: " .. player.x, 10, 0)
	love.graphics.print("Player Y: " .. player.y, 10, 20)
	love.graphics.print("mouse.x: " .. mouse.x, 10, 60)
	love.graphics.print("mouse.y: " .. mouse.y, 10, 80)
	love.graphics.print("Bullets: " .. player.bullets.count, 10, 100)
	love.graphics.print("Enemies: " .. enemies.count, 10, 120)
	love.graphics.rectangle("fill", player.x, player.y, 20, 20)

	for k,v in pairs(player.bullets.list) do
		love.graphics.rectangle("fill", v.x, v.y, 4, 4)
	end
	for k,v in pairs(enemies.list) do
		love.graphics.rectangle("fill", v.x, v.y, 15, 15)
	end
end