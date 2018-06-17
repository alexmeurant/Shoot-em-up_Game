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
          {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
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
          {3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3},
          {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
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
          {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
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

-- Caméra
camera = {}
camera.y = 0
camera.vitesse = 1

-- Retourne l'angle entre 2 points
function math.angle(x1,y1, x2,y2) 

  return math.atan2(y2-y1, x2-x1) 
end

-- Création d'un alien
function createAlien(pType, pX, pY)
  
  local nomImage = ""
  
  if pType == 1 then
    nomImage = "enemy1"
  elseif pType == 2 then
    nomImage = "enemy2"
  elseif pType == 3 then
    nomImage = "tourelle"
  elseif pType == 4 then
    nomImage = "enemy4"
  end
  
  local alien = createSprite(nomImage, pX, pY)
  alien.endormi = true
  alien.chronoTir = 0
  alien.type = pType
  
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
    alien.vx = 0
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

-- Création d'un tir
function creerTir(pNomImage, pX, pY, pVitesseX, pVitesseY)
    local tir = createSprite(pNomImage, pX, pY)
    table.insert(tirs,tir)
    tir.vx = pVitesseX
    tir.vy = pVitesseY
    shootSound:play()
end

function love.load()
  
  love.window.setMode(1024, 768)
  love.window.setTitle("Shoot'em Up")
  
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  
  shootSound = love.audio.newSource("sounds/shoot.wav", "static")
  
  demarreJeu()
end

function demarreJeu()
  
  -- Création des aliens
  local ligne = 2
  local colonne = 8
  createAlien(1, (colonne * 64) - 32, - 32 - ((ligne-1) * 64))
  
  ligne = 3
  colonne = 12
  createAlien(2, (colonne * 64) - 32, - 32 - ((ligne-1) * 64))
  
  ligne = 6
  colonne = 10
  createAlien(3, (colonne * 64) - 32, - 32 - ((ligne-1) * 64))
  
  ligne = 10
  colonne = 4
  createAlien(3, (colonne * 64) - 32, - 32 - ((ligne-1) * 64))
  
  ligne = 19
  colonne = 9
  createAlien(3, (colonne * 64) - 32, - 32 - ((ligne-1) * 64))
  
  -- Réinitialisation de la caméra
  camera.y = 0
  
  -- Création du héros
  heros = createSprite("heros", largeur/2, hauteur/2)
  heros.y = hauteur - (heros.hauteur*2)
end

function love.update(dt)
  
  -- Défilement de la caméra
  camera.y = camera.y + camera.vitesse
  
  local n
  
  -- Gestion du mouvement du vaisseau et des collisions avec la fenêtre
  if love.keyboard.isDown("up") and heros.y > heros.hauteur then
    heros.y = heros.y - 6
  elseif love.keyboard.isDown("down") and heros.y < hauteur - heros.hauteur then
    heros.y = heros.y + 6
  elseif love.keyboard.isDown("left") and heros.x > heros.largeur then
    heros.x = heros.x - 6
  elseif love.keyboard.isDown("right") and heros.x < largeur - heros.largeur then
    heros.x = heros.x + 6
  end
  
  -- Gestion du tir
  for n=#tirs,1,-1 do
    local tir = tirs[n]
    tir.x = tir.x + tir.vx
    tir.y = tir.y + tir.vy
    -- Vérifier si un tir est sorti de l'écran
    if tir.y < -10 or tir.y > hauteur then -- Hero ou Alien shoot
      tir.supprime = true
      table.remove(tirs, n)
    end
  end
  
  -- Gestion des aliens
  for n=#aliens,1,-1 do
    local alien = aliens[n]
    -- On réveille les aliens si visibles à l'écran
    if alien.y > 0 and alien.y <= hauteur then
      alien.endormi = false
    end
    
    -- Déplacement des aliens
    if alien.endormi == false then
      alien.x = alien.x + alien.vx
      alien.y = alien.y + alien.vy
      
      -- Gestion du tir des aliens
      if alien.type == 1 or alien.type == 2 then
        alien.chronoTir = alien.chronoTir - 1
        if alien.chronoTir < 0 then 
          alien.chronoTir = math.random(60,100) -- Les aliens tire toutes les secondes
          creerTir("laser2", alien.x, alien.y + alien.hauteur, 0, 10)
        end
      elseif alien.type == 3 then
        alien.chronoTir = alien.chronoTir - 1
        if alien.chronoTir < 0 then
          alien.chronoTir = math.random(20,30) -- Cet alien tire 3 fois par seconde
          local vx,vy
          local angle = math.angle(alien.x, alien.y, heros.x, heros.y)
          vx = 10 * math.cos(angle)
          vy= 10 * math.sin(angle)
          creerTir("laser2", alien.x, alien.y + alien.hauteur, vx, vy)
        end
      end
    
    else
      alien.y = alien.y + camera.vitesse
    end
    
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
  y= (0-64) + camera.y -- On fait défiler la map en fonction de la caméra
  local l,c
  for l=nbLignes,1,-1 do
    for c=1, 16 do
      local tuile = niveau[l][c]
      if tuile > 0 then
        love.graphics.draw(imgTuiles[tuile],x,y,0,2,2)
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
    love.graphics.draw(s.image, s.x, s.y, 0, 2, 2, s.largeur/2, s.hauteur/2)
  end
    
end

function love.mousepressed(x,y,button)
  -- Appel de la fonction pour créer un tir
  if button == 1 then
    creerTir("laser1", heros.x, heros.y - heros.hauteur, 0, -10)
  end

  print(button)
  
end