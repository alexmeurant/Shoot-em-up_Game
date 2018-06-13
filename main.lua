-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end

-------------------------------------------------------------------------------------


-- On crée un héros
heros = {}
-- On crée une liste qui contiendra nos sprites
sprites = {}
-- On créé une liste de tirs
tirs = {}

-- Création d'un sprite
function createSprite(pNomImage, pX, pY)
  
  sprite = {}
  sprite.x = pX
  sprite.y = pY
  sprite.image = love.graphics.newImage("images/"..pNomImage..".png")
  sprite.largeur = sprite.image:getWidth()
  sprite.hauteur = sprite.image:getHeight()
  sprite.supprime = false
  
  -- On ajoute à notre liste chaque sprite créé
  table.insert(sprites, sprite)
  
  return sprite
end

function love.load()
  
  love.window.setMode(1024, 768)
  love.window.setTitle("Shoot'em Up")
  
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  
  heros = createSprite("heros", largeur/2, hauteur/2)
  heros.y = hauteur - (heros.hauteur*2)
  
  shootSound = love.audio.newSource("sounds/shoot.wav", "static")
end

function love.update(dt)
  
  -- Gestion du mouvement du vaisseau et des collisions avec la fenêtre
  if love.keyboard.isDown("up") and heros.y > heros.hauteur then
    heros.y = heros.y - 5
  elseif love.keyboard.isDown("down") and heros.y < hauteur - heros.hauteur then
    heros.y = heros.y + 5
  elseif love.keyboard.isDown("left") and heros.x > heros.largeur then
    heros.x = heros.x - 5
  elseif love.keyboard.isDown("right") and heros.x < largeur - heros.largeur then
    heros.x = heros.x + 5
  end
  
  -- Gestion du tir et purge des listes
  local n
  for n=#tirs,1,-1 do
    local tir = tirs[n]
    tir.y = tir.y + tir.vitesse
    -- Vérifier si un tir est sorti de l'écran
    if tir.y < -10 or tir.y > hauteur then
      tir.supprime = true
      table.remove(tirs, n)
    end
  end
  
  for n=#sprites,1,-1 do
    if sprites[n].supprime == true then
      table.remove(sprites, n)
    end
  end
  
  
  
end

function love.draw()
  
  -- On affiche chaque sprite présente dans la liste "sprites"
  local n
  for n=1,#sprites do
    local s = sprites[n]
    love.graphics.draw(s.image, s.x, s.y, 0, 2, 2, s.largeur/2, s.hauteur/2)
  end
    
end

function love.mousepressed(x,y,button)
  -- Création d'un tir
  if button == 1 then
    local tir = createSprite("laser1", heros.x, heros.y - heros.hauteur)
    table.insert(tirs,tir)
    tir.vitesse = -10
    shootSound:play()
  end

  print(button)
  
end