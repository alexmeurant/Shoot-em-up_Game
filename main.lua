-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end

-------------------------------------------------------------------------------------

math.randomseed(os.time()) -- Permet d'obtenir un bon nombre aléatoire

-- On crée un héros
heros = {}
-- On crée une liste qui contiendra nos sprites
sprites = {}
-- On créé une liste de tirs
tirs = {}
-- On créé une liste d'aliens
aliens = {}

-- Niveau 16x12 car taille écran 1024x768
local niveau = {}
niveau = {
          {0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0},
          {0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0},
          {0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0},
          {0,2,2,2,2,0,0,0,0,0,0,0,0,0,0,0},
          {0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0},
          {0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0},
          {0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0},
          {0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0},
          {0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0},
          {0,0,0,0,0,0,2,2,2,2,2,2,2,2,0,0},
          {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          {3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3}
            }

-- Images des tuiles
imgTuiles = {}
local n
for n=1, 3 do
  imgTuiles[n] = love.graphics.newImage("images/tuile_"..n..".png")
end


-- Création d'un alien
function createAlien(pType, pX, pY)
  
  local nomImage = ""
  
  if pType == 1 then
    nomImage = "enemy1"
  elseif pType == 2 then
    nomImage = "enemy2"
  elseif pType == 3 then
    nomImage = "enemy3"
  elseif pType == 4 then
    nomImage = "enemy4"
  end
  
  local alien = createSprite(nomImage, pX, pY)
  
  local direction = math.random(0,1) -- 0 ou 1 au hasard
   
  if pType == 1 then
    alien.vx = 0
    alien.vy = 2
  elseif pType == 2 then
    if direction == 1 then
      alien.vx = 1
    else
      alien.vx = -1
    end
    alien.vy = 2
  elseif pType == 3 then
    alien.vx = 2
    alien.vy = 1
  elseif pType == 4 then
    alien.vx = 2
    alien.vy = 0
  end
  
  table.insert(aliens, alien)
end

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
  
  
  shootSound = love.audio.newSource("sounds/shoot.wav", "static")
  
  demarreJeu()
end

function demarreJeu()
  heros.y = hauteur - (heros.hauteur*2)
  
  -- Création des aliens
  createAlien(1, heros.x, 100)
  createAlien(2, heros.x, 50)
  
end

function love.update(dt)
  
  local n
  
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
  
  -- Gestion du tir
  for n=#tirs,1,-1 do
    local tir = tirs[n]
    tir.y = tir.y + tir.vitesse
    -- Vérifier si un tir est sorti de l'écran
    if tir.y < -10 or tir.y > hauteur then -- Hero shoot ou Alien shoot
      tir.supprime = true
      table.remove(tirs, n)
    end
  end
  
  -- Gestion des aliens
  for n=#aliens,1,-1 do
    local alien = aliens[n]
    
    -- Déplacement des aliens
    alien.x = alien.x + alien.vx
    alien.y = alien.y + alien.vy
    
    -- Suppression de l'alien si sortie d'écran
    if alien.y > hauteur then
      alien.supprime = true
      table.remove(aliens, n)
    end
    
  end
  
  -- Purge des sprites
  for n=#sprites,1,-1 do
    if sprites[n].supprime == true then
      table.remove(sprites, n)
    end
  end
  
end

function love.draw()
  
  love.graphics.print("Nombre de sprites : "..tostring(#sprites).." Nombre de tirs : "..tostring(#tirs).." Nombre d'aliens : "..tostring(#aliens), 1, 1)
  
  -- On affiche la map
  local nbLignes = #niveau
  local x,y
  x=0
  y=0
  local l,c
  for l=1,nbLignes do
    for c=1, 16 do
      local tuile = niveau[l][c]
      if tuile > 0 then
        love.graphics.draw(imgTuiles[tuile],x,y,0,2,2)
      end
      x = x + 64
    end
    x = 0
    y = y + 64
  end
  
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