local newGame = {}

    function newGame.demarreJeu()
      
      gameSound:play()
      
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
      
      ligne = 8
      colonne = 5
      createAlien(1, (colonne * 64) - 32, - 32 - ((ligne-1) * 64))
      
      ligne = 9
      colonne = 8
      createAlien(2, (colonne * 64) - 32, - 32 - ((ligne-1) * 64))
      
      ligne = 10
      colonne = 4
      createAlien(3, (colonne * 64) - 32, - 32 - ((ligne-1) * 64))
      
      ligne = 13
      colonne = 6
      createAlien(1, (colonne * 64) - 32, - 32 - ((ligne-1) * 64))
      
      ligne = 16
      colonne = 5
      createAlien(2, (colonne * 64) - 32, - 32 - ((ligne-1) * 64))
      
      ligne = 19
      colonne = 9
      createAlien(3, (colonne * 64) - 32, - 32 - ((ligne-1) * 64))
      
      ligne = 22
      colonne = 3
      createAlien(3, (colonne * 64) - 32, - 32 - ((ligne-1) * 64))
      
      ligne = 23
      colonne = 5
      createAlien(1, (colonne * 64) - 32, - 32 - ((ligne-1) * 64))
      
      ligne = 27
      colonne = 8
      createAlien(2, (colonne * 64) - 32, - 32 - ((ligne-1) * 64))
      
      ligne = 29
      colonne = 9
      createAlien(3, (colonne * 64) - 32, - 32 - ((ligne-1) * 64))
      
      ligne = 35
      colonne = 4
      createAlien(3, (colonne * 64) - 32, - 32 - ((ligne-1) * 64))
      
      ligne = 35
      colonne = 8
      createAlien(3, (colonne * 64) - 32, - 32 - ((ligne-1) * 64))
      
      ligne = 35
      colonne = 12
      createAlien(3, (colonne * 64) - 32, - 32 - ((ligne-1) * 64))
      
      -- Création du Boss
      ligne = 40
      colonne = 8
      createAlien(4, (colonne * 64) - 32, - 32 - ((ligne-1) * 64))
      
      -- Réinitialisation de la caméra
      camera.y = hauteur
      
      -- Création du héros et de son ombre
      heros = createSprite("heros", largeur/2, hauteur/2)
      heros.y = hauteur - (heros.hauteur*2)
      heros.energie = 15
      heros.score = 0
      heros_ombre = createSprite("heros_ombre", heros.x + 30, heros.y + 30)
    end
    
return newGame