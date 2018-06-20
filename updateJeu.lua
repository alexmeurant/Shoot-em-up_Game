
local updateJeu = {}

    -- Update quand on est sur l'écran de jeu
    function updateJeu.updateJeu()
      
      -- Défilement de la caméra
        camera.y = camera.y + camera.vitesse
        
        local n
        
          -- Gestion du mouvement du vaisseau et des collisions avec la fenêtre
          if love.keyboard.isDown("up") and heros.y > heros.hauteur/2 then
              heros.y = heros.y - 6
            elseif love.keyboard.isDown("down") and heros.y < hauteur - heros.hauteur/2 then
              heros.y = heros.y + 6
            elseif love.keyboard.isDown("left") and heros.x > heros.largeur/2 then
              heros.x = heros.x - 6
            elseif love.keyboard.isDown("right") and heros.x < largeur - heros.largeur/2 then
              heros.x = heros.x + 6
          end
          heros_ombre.x = heros.x + 30
          heros_ombre.y = heros.y + 30
        
          -- Gestion du tir et des cibles touchées
          for n=#tirs,1,-1 do
            local tir = tirs[n]
            tir.x = tir.x + tir.vx
            tir.y = tir.y + tir.vy
            
            -- Vérifie si un tir d'alien touche le héro
            if tir.type == "alien" then
              if collide(tir,heros) then
                createExplosion(heros.x, heros.y - (heros.hauteur/2))
                tir.supprime = true
                table.remove(tirs, n)
                heros.energie = heros.energie - 1
                if heros.energie == 0 then
                  -- Suppression du héros et gameover
                  local n
                  for n=1,5 do
                    createExplosion(heros.x + math.random(-20,20), heros.y + math.random(-20,20))
                    explosionSound:play()
                    timerGameOver = 90
                    bossSound:setVolume(0)
                    gameSound: setVolume(0)
                  end
                  heros.supprime = true
                  heros_ombre.supprime = true
                end
              end
            end
          
            -- Vérifie si le tir du héro touche un alien
            if tir.type == "heros" then
              local nAlien
              for nAlien=#aliens,1,-1 do
                local alien = aliens[nAlien]
                if alien.endormi == false then
                  if collide(tir,alien) then
                    createExplosion(alien.x, alien.y + (alien.hauteur/2))
                    tir.supprime = true
                    table.remove(tirs, n)
                    -- createExplosion(alien.x, alien.y)
                    alien.energie = alien.energie -1
                    if alien.energie <= 0 then
                      -- Traitement de l'alien abattu
                      local n
                      for n=1,5 do
                        if alien.type == 4 then
                          createExplosion(alien.x + math.random(-50,50), alien.y + math.random(-50,50))
                          bossSound:setVolume(0)
                          timerVictoire = 120 -- 2 seconds delay between Boss explosion and victory screen display
                        else
                          createExplosion(alien.x + math.random(-20,20), alien.y + math.random(-20,20))
                        end
                      end
                      explosionSound:play()
                      -- Suppression de son ombre
                      if alien.type == 1 or alien.type == 2 or alien.type == 4 then
                        alien.alien_ombre.supprime = true
                      end
                      -- Suppression de l'alien dans la mémoire
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
          if alien.y > -alien.hauteur and alien.y <= hauteur then
            alien.endormi = false
          end
          
          -- Déplacement des aliens et de leur ombre
          if alien.endormi == false and (alien.type == 1 or alien.type == 2 or alien.type == 3) then
            alien.x = alien.x + alien.vx
            alien.y = alien.y + alien.vy
            if alien.type == 1 or alien.type == 2 then
              alien.alien_ombre.x = alien.x + 30
              alien.alien_ombre.y = alien.y + 30
            end
            
            -- Gestion du tir des aliens
            if alien.type == 1 or alien.type == 2 then
              alien.chronoTir = alien.chronoTir - 1
              if alien.chronoTir < 0 then 
                alien.chronoTir = math.random(60,120) -- Les aliens tire toutes les 1 à 2 secondes
                creerTir("alien", "laser2", alien.x, alien.y + alien.hauteur, 0, 10)
              end
            elseif alien.type == 3 then
              alien.chronoTir = alien.chronoTir - 1
              if alien.chronoTir < 0 then
                alien.chronoTir = math.random(30,40) -- Cet alien tire 3 fois par seconde environ
                local vx,vy
                local angle = math.angle(alien.x, alien.y, heros.x, heros.y)
                vx = 10 * math.cos(angle)
                vy= 10 * math.sin(angle)
                creerTir("alien", "laser3", alien.x, alien.y, vx, vy)
              end
            end
          else
            alien.y = alien.y + camera.vitesse
          end
          
          -- Traitement du Boss
          if alien.endormi == false and alien.type == 4 then
            
            -- Affichage de l'ombre
            alien.alien_ombre.x = alien.x + 30
            alien.alien_ombre.y = alien.y + 30
            
            -- Calcul de l'angle pour que le Boss se dirige et/ou tire vers le héros
            local vx,vy
            local angle = math.angle(alien.x, alien.y, heros.x, heros.y)
            
            -- Musique du Boss
            if alien.y >= - 50 then
              gameSound:setVolume(0)
              bossSound:play(0.5)
            end
            
            -- Gestion du tir du Boss
            alien.chronoTir = alien.chronoTir - 1
              if alien.chronoTir < 0 then
                alien.chronoTir = math.random(40,60)
                creerTir("alien", "laser2", alien.x + alien.largeur/2 - 25, alien.y + alien.hauteur/2, 0, 10)
                creerTir("alien", "laser2", alien.x, alien.y + alien.hauteur/2, 0, 10)
                creerTir("alien", "laser2", alien.x - alien.largeur/2 + 25, alien.y + alien.hauteur/2, 0, 10)
                if alien.energie < 10 then
                  vx = 10*math.cos(angle)
                  vy= 10*math.sin(angle)
                  creerTir("alien", "laser2", alien.x, alien.y + alien.hauteur/2, vx, vy)
                end
              end
              
            -- Gestion du déplacement
            alien.y = alien.y - camera.vitesse -- Annule le déplacement pendant la phase d'endormissement
            if alien.energie >= 10 then
              vx = 3*math.cos(angle)
              vy= 3*math.sin(angle)
            else
              vx = 5*math.cos(angle)
              vy= 5*math.sin(angle)
            end
            alien.x = alien.x + vx
            alien.y = alien.y + vy
            if alien.y >= (hauteur/2) then
              alien.y = alien.y - vy
            end
          end
          
          -- Suppression de l'alien si sortie d'écran
          if alien.y > hauteur then
            alien.supprime = true
            if alien.type ~= 3 then
              alien.alien_ombre.supprime = true
            end
            table.remove(aliens, n)
          end
          
        end
        
        -- Traitement et purge des sprites
        for n=#sprites,1,-1 do
          local sprite = sprites[n]
          -- Le sprite est-il animé ?
          if sprite.maxFrame > 1 then
            sprite.frame = sprite.frame + 0.2
            local nextFrame = math.floor(sprite.frame)
            if nextFrame > sprite.maxFrame then
              sprite.supprime = true
            else
              sprite.image = sprite.frames[nextFrame]
            end
          end
          -- Suppression d'un sprite à purger
          if sprite.supprime == true then
            table.remove(sprites, n)
          end
        end
        
        -- Delay between Boss explosion and victory screen display
        if timerVictoire > 0 then
          timerVictoire = timerVictoire - 1
          if timerVictoire == 0 then
            ecran_courant = "victoire"
          end
        end
        
        -- Delay between Hero explosion and gameover screen display
        if timerGameOver > 0 then
          timerGameOver = timerGameOver - 1
          if timerGameOver == 0 then
            ecran_courant = "gameover"
          end
        end
    end
    
  return updateJeu