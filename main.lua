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

-- Ecran courant
ecran_courant = "menu"

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
    alien.energie = 1
  elseif pType == 2 then
    if direction == 1 then
      alien.vx = 1
    else
      alien.vx = -1
    end
    alien.vy = 2
    alien.energie = 3
  elseif pType == 3 then
    alien.vx = 0
    alien.vy = 1
    alien.energie = 5
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
  
  if (math.abs(dx) < a1.image:getWidth()+a2.image:getWidth()) then
    if (math.abs(dy) < a1.image:getHeight()+a2.image:getHeight()) then
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
  
  shootSound = love.audio.newSource("sounds/shoot.wav", "static")
  explosionSound = love.audio.newSource("sounds/explode_touch.wav", "static")
  shootSound:setVolume(0.3)
  
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
  heros.energie = 5
  heros.score = 0
end

-- Update quand on est sur l'écran de jeu
function updateJeu()
  
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
    
      -- Gestion du tir et des cibles touchées
      for n=#tirs,1,-1 do
        local tir = tirs[n]
        tir.x = tir.x + tir.vx
        tir.y = tir.y + tir.vy
        
        -- Vérifie si un tir d'alien touche le héro
        if tir.type == "alien" then
          if collide(tir,heros) then
            tir.supprime = true
            table.remove(tirs, n)
            heros.energie = heros.energie - 1
            if heros.energie <= 0 then
              explosionSound:play()
              ecran_courant = "gameover"
            end
          end
        end
      
      -- Vérifie si le tir du héro touche un alien
      if tir.type == "heros" then
        local nAlien
        for nAlien=#aliens,1,-1 do
          local alien = aliens[nAlien]
          if collide(tir,alien) then
            tir.supprime = true
            table.remove(tirs, n)
            alien.energie = alien.energie -1
            if alien.energie <= 0 then
              -- Supression de l'alien abattu
              explosionSound:play()
              alien.supprime = true
              table.remove(aliens, nAlien)
              
              -- Maj du score du héro en fonction de l'alien abattu
              if alien.type == 1 then
                heros.score = heros.score + 10
              elseif alien.type == 2 then
                heros.score = heros.score + 30
              elseif alien.type == 3 then
                heros.score = heros.score + 50
              end
            end
          end
        end
      end
      
      -- Vérifier si un tir est sorti de l'écran
      if (tir.y < -10 or tir.y > hauteur) and tir.supprime == false then -- Hero ou Alien shoot
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
            creerTir("alien", "laser2", alien.x, alien.y + alien.hauteur, 0, 10)
          end
        elseif alien.type == 3 then
          alien.chronoTir = alien.chronoTir - 1
          if alien.chronoTir < 0 then
            alien.chronoTir = math.random(20,30) -- Cet alien tire 3 fois par seconde
            local vx,vy
            local angle = math.angle(alien.x, alien.y, heros.x, heros.y)
            vx = 10 * math.cos(angle)
            vy= 10 * math.sin(angle)
            creerTir("alien", "laser2", alien.x, alien.y + alien.hauteur, vx, vy)
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





function love.update(dt)
  
  if ecran_courant == "jeu" then
    updateJeu()
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
  
  -- On affiche l'énergie et les vies du héro
  love.graphics.print("Energie : "..heros.energie, 10, hauteur - 20)
  love.graphics.print("Score : "..heros.score, largeur - 100, hauteur - 20)
end

function drawMenu()
  love.graphics.draw(menu, 0, 0)
end

function drawGameOver()
  love.graphics.draw(gameover, 0, 0)
end

function love.draw()
  if ecran_courant == "jeu" then
    drawJeu()
  elseif ecran_courant == "menu" then
    drawMenu()
  elseif ecran_courant == "gameover" then
    drawGameOver()
  end
end

function love.mousepressed(x,y,button)
  if ecran_courant == "jeu" then
    -- Appel de la fonction pour créer un tir
    if button == 1 then
      creerTir("heros", "laser1", heros.x, heros.y - heros.hauteur, 0, -10)
    end
  end
end

function love.keypressed(key)
  if ecran_courant == "menu" then
    if key == "space" then
      ecran_courant = "jeu"
      demarreJeu()
    end
  elseif ecran_courant == "gameover" then
    if key == "space" then
      love.event.quit( "restart" )
    end
  end
end