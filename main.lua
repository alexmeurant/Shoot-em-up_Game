-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end

-------------------------------------------------------------------------------------

local updateJeu = require("updateJeu")
local newGame = require("demarreJeu")

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
          {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,3,1,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,4,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,5,1,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,4,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,4,1,1,1,1,1,1,1,1,1,1,3,1,1},
          {1,1,1,5,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,1,3,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,1,1,5,4,1,1},
          {1,1,1,1,1,1,1,5,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
          {3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,5,1,1,4,1,1,1,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1},
          {1,1,4,1,5,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,3,1,1,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,1},
          {1,1,1,4,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,1,1,5,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,3,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,5,1,1,1,1,1,1},
          {1,1,1,1,1,4,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,1,1,1,1,5,1},
          {1,1,1,1,1,1,1,1,3,1,1,1,1,1,1,1},
          {4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,5,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,4,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3},
          {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,1,5,1,1,1,1,5,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,4,1,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,1,1,1,5,1,1,1,1,1,1,1},
          {3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,1,4,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4},
          {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,5,1,1,1,1,1,1,1,1,1,1,1,1,5},
          {1,1,1,1,1,1,4,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,1,3,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,4,5,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,4,1,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,1,3,1,1,1,1,1,5,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,5,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,1,3,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,1,1,4,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,4,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,1,3,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,5,1,1,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,1},
          {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
          {4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,2,1,1,1,1,1,1,1,3,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,5,1,1,2,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,4,1,1,1,1,1,1,1,1,1,3,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,5,1,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,3,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,1,1,4,1,1,1,1,1,1,1,1},
          {1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,5,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,3,1,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,4,1,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,1,1,1,2,1,1},
          {1,1,1,1,1,5,1,1,1,1,1,1,1,1,1,1},
          {4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,3,1,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
          {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
            }

-- Images des tuiles
imgTuiles = {}
local n
for n=1, 5 do
  imgTuiles[n] = love.graphics.newImage("images/tuile_"..n..".png")
end

-- Images de l'explosion
imgExplosion = {}
local n
for n=1, 5 do
  imgExplosion[n] = love.graphics.newImage("images/explosion/explode_"..n..".png")
end

-- Caméra
camera = {}
camera.y = 0
camera.vitesse = 1

-- Ecran courant
ecran_courant = "menu"

timerVictoire = 0
timerGameOver = 0

-- Retourne l'angle entre 2 points
function math.angle(x1,y1, x2,y2) 

  return math.atan2(y2-y1, x2-x1) 
end

-- Création d'un alien
function createAlien(pType, pX, pY)
  
  local nomImage = ""
  
  if pType == 1 then
    nomImage = "enemy1"
    ombreImage = "enemy1_ombre"
  elseif pType == 2 then
    nomImage = "enemy2"
    ombreImage = "enemy2_ombre"
  elseif pType == 3 then
    nomImage = "tourelle"
  elseif pType == 4 then
    nomImage = "enemy3"
    ombreImage = "enemy3_ombre"
  end
  
  local alien = createSprite(nomImage, pX, pY)
  alien.endormi = true
  alien.chronoTir = 0
  alien.type = pType
  
  local direction = math.random(0,1) -- 0 ou 1 au hasard
   
  if pType == 1 then
    alien.vx = 0
    alien.vy = 2
    alien.energie = 1
    alien.alien_ombre = createSprite(ombreImage, pX + 30, pY + 30)
  elseif pType == 2 then
    if direction == 1 then
      alien.vx = 1
    else
      alien.vx = -1
    end
    alien.vy = 2
    alien.energie = 3
    alien.alien_ombre = createSprite(ombreImage, pX + 30, pY + 30)
  elseif pType == 3 then
    alien.vx = 0
    alien.vy = 1
    alien.energie = 5
  elseif pType == 4 then
    alien.vx = 2
    alien.vy = 2
    alien.energie = 30
    alien.alien_ombre = createSprite(ombreImage, pX + 50, pY + 50)
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
  
  sprite.frame = 1
  sprite.frames = {}
  sprite.maxFrame = 1
  
  -- On ajoute à notre liste chaque sprite créé
  table.insert(sprites, sprite)
  
  return sprite
end

-- Affichage de l'explosion
function createExplosion(pX, pY)
  local newExplosion = createSprite("explosion/explode_1", pX, pY)
  -- On modifie les valeurs par défaut d'un sprite
  newExplosion.frames = imgExplosion
  newExplosion.maxFrame = 5
end

-- Création d'un tir
function creerTir(pType, pNomImage, pX, pY, pVitesseX, pVitesseY)
    local tir = createSprite(pNomImage, pX, pY)
    table.insert(tirs,tir)
    tir.vx = pVitesseX
    tir.vy = pVitesseY
    tir.type = pType
    shootSound:play()
end

-- Gestion de la collision
function collide(a1, a2)
  local dx = a1.x - a2.x
  local dy = a1.y - a2.y
  
  if (a1==a2) then 
    return false
  end
  
  if (math.abs(dx) < a1.image:getWidth()/2+a2.image:getWidth()/2) then
    if (math.abs(dy) < a1.image:getHeight()/2+a2.image:getHeight()/2) then
      return true
    end
  end
  
  return false
end


function love.load()
  
  love.window.setMode(1024, 768)
  love.window.setTitle("Shoot'em Up")
  
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  
  menu = love.graphics.newImage("images/menu.jpg")
  gameover = love.graphics.newImage("images/gameover.jpg")
  victoire = love.graphics.newImage("images/victory.jpg")
  
  shootSound = love.audio.newSource("sounds/shoot.wav", "static")
  explosionSound = love.audio.newSource("sounds/explode_touch.wav", "static")
  shootSound:setVolume(0.3)
  
  gameSound = love.audio.newSource("sounds/gameSound.mp3", "stream")
  gameSound:setVolume(0.3)
  bossSound = love.audio.newSource("sounds/bossSound.mp3", "stream")
  
end


function love.update(dt)
  
  if ecran_courant == "jeu" then
    updateJeu.updateJeu()
  end
  
end

function drawJeu()
  -- On affiche la map
  local nbLignes = #niveau
  local x,y
  x=0
  y= (0-64) + camera.y -- On fait défiler la map en fonction de la caméra
  local l,c
  for l=nbLignes,1,-1 do
    for c=1, 16 do
      local tuile = niveau[l][c]
      if tuile > 0 then
        love.graphics.draw(imgTuiles[tuile],x,y,0,1,1)
      end
      x = x + 64
    end
    x = 0
    y = y - 64
  end
  
  -- On affiche chaque sprite présente dans la liste "sprites"
  local n
  for n=1,#sprites do
    local s = sprites[n]
    love.graphics.draw(s.image, s.x, s.y, 0, 1, 1, s.largeur/2, s.hauteur/2)
  end
  
  -- On affiche l'énergie et les vies du héro
  if heros.energie >= 0 then
    love.graphics.print("Energie : "..heros.energie, 10, hauteur - 20)
  end
  love.graphics.print("Score : "..heros.score, largeur - 100, hauteur - 20)
end

function drawMenu()
  love.graphics.draw(menu, 0, 0)
end

function drawGameOver()
  love.graphics.draw(gameover, 0, 0)
end

function drawVictoire()
  love.graphics.draw(victoire, 0, 0)
end

function love.draw()
  if ecran_courant == "jeu" then
    drawJeu()
  elseif ecran_courant == "menu" then
    drawMenu()
  elseif ecran_courant == "gameover" then
    drawGameOver()
  elseif ecran_courant == "victoire" then
    drawVictoire()
  end
end


function love.keypressed(key)
  
  if ecran_courant == "menu" then
    if key == "space" then
      ecran_courant = "jeu"
      newGame.demarreJeu()
    end
  elseif ecran_courant == "jeu" then
    -- Appel de la fonction pour créer un tir
    if key == "kp0" or key == "space" then
      creerTir("heros", "laser1", heros.x, heros.y - heros.hauteur/2, 0, -10)
    end
  elseif ecran_courant == "gameover" then
    if key == "space" or "esc" or "enter" then
      love.event.quit( "restart" )
    end
  elseif ecran_courant == "victoire" then
    if key == "space"  or "esc" or "enter" then
      love.event.quit( "restart" )
    end
  end
end