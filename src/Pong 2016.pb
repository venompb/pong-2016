; ///////////////////////////////////////////////
; //      Autor :         Venom                //
; //      Project name :  Pong 2016            //
; //      Version :       V 1.0                //
; //      Compilator :    PureBasic V5.41      //
; //      Date :          22/03/2016           //
; //      OS :            Windows 10           //
; ///////////////////////////////////////////////


;- Window Constants
Enumeration
  #Window_0
EndEnumeration


;- Gadgets Constants
Enumeration
  #Fond
  #Ball
  #Raquette1H
  #Raquette1B
  #Raquette2H
  #Raquette2B
  #BarreH
  #BarreB
  #BlocCentral
  
  #Alphabet
  #Alphabet32
  
  #SonCollision
  #SonCollisionRaquette
  #SonOver
EndEnumeration


;- Activation des supports png etc...
UsePNGImageDecoder()


;- Chemin vers les differants fichiers
Cheminimages$ = "gfx\"
Cheminisons$ = "sfx\"

     
;-  On déclare les procedures
Declare AfficheText(ID, PosX, PosY, Text$, Hauteur, Transparence)


;- Initialisation environnement sprite
  If InitSprite() = 0
    MessageRequester("Erreur", "Impossible d'ouvrir l'écran & l'environnement nécessaire aux sprites !", 0)
    End
  EndIf
  
  
;- Initialisation environnement clavier
  If InitKeyboard() = 0
    MessageRequester("Erreur", "Impossible d'initialisé le clavier !", 0)
    End
  EndIf
  
  
;- Initialisation environnement son
  If InitSound() = 0
    MessageRequester("Erreur", "Impossible d'initialisé le son", 0)
    End
  EndIf


;- on initialise les differantes tailles / positions de la fenetre et des sprites
  LargeurFenetre = 800
  HauteurFenetre = 450
  
  PosXRaquette1 = LargeurFenetre-40
  PosYRaquette1 = HauteurFenetre/2-50 
  
  PosXRaquette2 = 20
  PosYRaquette2 = HauteurFenetre/2-50
  
  PosXBall = LargeurFenetre/2-10
  PosYBall = 20
  
  VitesseBall = 7
  DirectionX = VitesseBall
  DirectionY = VitesseBall
  
  ScoreGaucheDemarrage = 0
  ScoreDroiteDemarrage = 0
  
;- on ouvre la fenetre
If OpenWindow(#Window_0, 0, 0, LargeurFenetre, HauteurFenetre, "Pong 2016", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)

    If OpenWindowedScreen(WindowID(#Window_0), 0, 0, LargeurFenetre, HauteurFenetre)
;- on charge les images
      LoadSprite(#Fond, Cheminimages$+"fond.png", 0)
      LoadSprite(#Ball, Cheminimages$+"ball.png", #PB_Sprite_PixelCollision)
      LoadSprite(#Raquette1H, Cheminimages$+"raquette-1H.png", #PB_Sprite_PixelCollision)
      LoadSprite(#Raquette1B, Cheminimages$+"raquette-1B.png", #PB_Sprite_PixelCollision)
      LoadSprite(#Raquette2H, Cheminimages$+"raquette-1H.png", #PB_Sprite_PixelCollision)
      LoadSprite(#Raquette2B, Cheminimages$+"raquette-1B.png", #PB_Sprite_PixelCollision)
      LoadSprite(#BarreH, Cheminimages$+"barreH.png", 0)
      LoadSprite(#BarreB, Cheminimages$+"barreB.png", 0)
      LoadSprite(#BlocCentral, Cheminimages$+"bloc.png", 0)
      
      
;- on charge le sprite alphabetique 64
      LoadSprite(#Alphabet,Cheminimages$+"font x64 white.png", #PB_Sprite_AlphaBlending); on charge le sprite qui contient les caractères
      Global String$ = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"; on ecrit tout les caractères identique au sprite (sa va permettre de connaitre la position des lettres que l'on désire afficher)
      
      
;- on charge le sprite alphabetique 32
      LoadSprite(#Alphabet32,Cheminimages$+"font x32 white.png", #PB_Sprite_AlphaBlending); on charge le sprite qui contient les caractères
      Global String$ = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"; on ecrit tout les caractères identique au sprite (sa va permettre de connaitre la position des lettres que l'on désire afficher)
      
      
;- on charge les sons
      LoadSound(#SonCollision, Cheminisons$+"collision.wav")
      SoundVolume(#SonCollision, 10)
      LoadSound(#SonCollisionRaquette, Cheminisons$+"collision raquette.wav")
      SoundVolume(#SonCollisionRaquette, 10)
      LoadSound(#SonOver, Cheminisons$+"game over.wav")
      SoundVolume(#SonOver, 20)

   EndIf
   
EndIf 


  Repeat
    ; Il est très important de traiter tous les évènements restants dans la file d'attente à chaque tour
    Repeat
      Event = WindowEvent()
      
      Select Event 
        Case #PB_Event_Gadget
          If EventGadget() = 0
            End
          EndIf
        
        Case #PB_Event_CloseWindow
          End 
      EndSelect
    Until Event = 0
    
   
    ClearScreen(RGB(0, 0, 0))
    ExamineKeyboard()
    KeyboardMode(#PB_Keyboard_International)
    
    
;- on affiche le fond, les barres haute et basse bleu et les blocs central
    DisplaySprite(#Fond, 0, 0)
    DisplaySprite(#BarreH, 0, 0)
    DisplaySprite(#BarreB, 0, 430)
    
    For YBloc = 20 To 415 Step 30
     DisplaySprite(#BlocCentral, LargeurFenetre/2-10, YBloc)
    Next
    
    
;- on affiche la raquette 1 et 2 au démarrage
    DisplayTransparentSprite(#Raquette1H, PosXRaquette1, PosYRaquette1)
    DisplayTransparentSprite(#Raquette1B, PosXRaquette1, PosYRaquette1+50)
    DisplayTransparentSprite(#Raquette2H, PosXRaquette2, PosYRaquette2)
    DisplayTransparentSprite(#Raquette2B, PosXRaquette2, PosYRaquette2+50)
     

;- on appuie sur la touche du haut
    If KeyboardPushed(#PB_Key_Up)
      If PosYRaquette1 > 20
        PosYRaquette1 = PosYRaquette1-5
       ElseIf PosYRaquette1 = 0
        PosYRaquette1 = PosYRaquette1
      EndIf 
    EndIf
    
    
;- on appuie sur la touche du bas
    If KeyboardPushed(#PB_Key_Down)
      If PosYRaquette1 < HauteurFenetre-120
        PosYRaquette1 = PosYRaquette1+5
       ElseIf PosYRaquette1 = HauteurFenetre-100
        PosYRaquette1 = PosYRaquette1
      EndIf 
    EndIf
    
    
;- on appuie sur la touche Z
    If KeyboardPushed(#PB_Key_Z)
      If PosYRaquette2 > 20
        PosYRaquette2 = PosYRaquette2-5
       ElseIf PosYRaquette2 = 0
        PosYRaquette2 = PosYRaquette2
      EndIf 
    EndIf
    
    
;- on appuie sur la touche S
    If KeyboardPushed(#PB_Key_S)
      If PosYRaquette2 < HauteurFenetre-120
        PosYRaquette2 = PosYRaquette2+5
       ElseIf PosYRaquette2 = HauteurFenetre-100
        PosYRaquette2 = PosYRaquette2
      EndIf 
    EndIf
    
    
;- on affiche la balle au démarrage
    TransparentSpriteColor(#Ball, RGB(255, 0, 255))
    DisplayTransparentSprite(#Ball, PosXBall, PosYBall)
    

;- gestion des collisions de la balle dans la fenetre en Y  
    PosYBall + DirectionY
    If PosYBall > HauteurFenetre-30
      DirectionY = -VitesseBall
       PlaySound(#SonCollision, 0)
    EndIf
    If PosYBall < 10 
      DirectionY =  VitesseBall
       PlaySound(#SonCollision, 0)
    EndIf 
    
    
;- gestion des collisions de la balle dans la fenetre en X 
    PosXBall + DirectionX
    If PosXBall > LargeurFenetre-20
      DirectionX = -VitesseBall
       PlaySound(#SonOver, 0)
       ScoreGaucheDemarrage = ScoreGaucheDemarrage+1 ; ajoute 1 au score de gauche si la balle touche le mur de droite
    EndIf
    If PosXBall < 0 
      DirectionX =  VitesseBall
       PlaySound(#SonOver, 0)
        ScoreDroiteDemarrage = ScoreDroiteDemarrage+1 ; ajoute 1 au score de droite si la balle touche le mur de gauche
    EndIf
    
    
;- verifie si le score de gauche arrive a 10 pour terminé la manche
    If ScoreGaucheDemarrage = 10
      AfficheText(#Alphabet, LargeurFenetre/2-288, HauteurFenetre/2-32, "GAME OVER", 64, 255); on affiche game over
      AfficheText(#Alphabet32, LargeurFenetre/2-304, HauteurFenetre/2+50, "ESPACE POUR REJOUER", 32, 255); on affiche game over
      PosXBall = LargeurFenetre/2-10
      PosYBall = HauteurFenetre/2-10
      VitesseBall = 0
      PosYRaquette1 = HauteurFenetre/2-50 
      PosYRaquette2 = HauteurFenetre/2-50 
      EndOfGame = #True
    EndIf 
    
    
;- verifie si le score de droite arrive a 10 pour terminé la manche
    If ScoreDroiteDemarrage = 10
      AfficheText(#Alphabet, LargeurFenetre/2-288, HauteurFenetre/2-32, "GAME OVER", 64, 255); on affiche game over
      PosXBall = LargeurFenetre/2-10
      PosYBall = HauteurFenetre/2-10
      VitesseBall = 0
      PosYRaquette1 = HauteurFenetre/2-50 
      PosYRaquette2 = HauteurFenetre/2-50 
      EndOfGame = #True
    EndIf 
    
    
;- gestion de collision avec la raquette H1
    If SpriteCollision(#Ball, PosXBall, PosYBall, #Raquette1H, PosXRaquette1, PosYRaquette1)
      DirectionX = -VitesseBall
      DirectionY = -VitesseBall
      PlaySound(#SonCollisionRaquette, 0)
    EndIf 
;- gestion de collision avec la raquette B1
    If SpriteCollision(#Ball, PosXBall, PosYBall, #Raquette1B, PosXRaquette1, PosYRaquette1+50)
      DirectionX = -VitesseBall
      DirectionY = VitesseBall
      PlaySound(#SonCollisionRaquette, 0)
    EndIf 
    
    
;- gestion de collision avec la raquette H2
    If SpriteCollision(#Ball, PosXBall, PosYBall, #Raquette2H, PosXRaquette2, PosYRaquette2)
      DirectionX = VitesseBall
      DirectionY = -VitesseBall
      PlaySound(#SonCollisionRaquette, 0)
    EndIf 
;- gestion de collision avec la raquette B2
    If SpriteCollision(#Ball, PosXBall, PosYBall, #Raquette2B, PosXRaquette2, PosYRaquette2+50)
      DirectionX = VitesseBall
      DirectionY = VitesseBall
      PlaySound(#SonCollisionRaquette, 0)
    EndIf 
    
    
;- on affiche le score de gauche
    AfficheText(#Alphabet, LargeurFenetre/2-128, 15, Str(ScoreGaucheDemarrage), 64, 255); on appele la procedure avec les options voulu
    
    
;- on affiche le score de droite
    AfficheText(#Alphabet, LargeurFenetre/2+64, 15, Str(ScoreDroiteDemarrage), 64, 255); on appele la procedure avec les options voulu
    
    
;- Reset du jeu via la touche espace. Merci Falsam
    If KeyboardReleased(#PB_Key_Space)
      If EndOfGame = #True

        ScoreGaucheDemarrage = 0
        ScoreDroiteDemarrage = 0
 
        VitesseBall = 6
        
        DirectionX = VitesseBall
        DirectionY = VitesseBall 
        
        PosXBall = LargeurFenetre/2-10
        PosYBall = 0
        
        PosXRaquette1 = LargeurFenetre-40
        PosYRaquette1 = HauteurFenetre/2-50 
  
        PosXRaquette2 = 20
        PosYRaquette2 = HauteurFenetre/2-50

        EndOfGame = #False
      EndIf
    EndIf 

    FlipBuffers()


;- appuie sur la touche echap
  Until KeyboardPushed(#PB_Key_Escape)
  End





;- Procedure pour afficher un texte via le sprite Font  
Procedure AfficheText(ID, PosX, PosY, Text$, Hauteur, Transparence)
For i=1 To Len(Text$)               ; regarde chaque lettre de la chaine (ici PUREBASIC)
 For j=1 To Len(String$)            ; cherche la position de la lettre de la chaine dans le sprite
	If Mid(Text$, i, 1) = Mid(String$, j, 1) ; si on a trouvé,
	 ClipSprite(ID, (j-1)*Hauteur, 0, Hauteur, Hauteur)  ; on selectionne la lettre

	 DisplayTransparentSprite(ID, PosX+i*Hauteur-Hauteur, PosY, Transparence); affiche la lettre dans un sprite
	 j=Len(String$) ; on sort de la boucle de recherche de la lettre dans l'image
	EndIf 
 Next
Next
EndProcedure
; IDE Options = PureBasic 5.71 beta 1 LTS (Windows - x64)
; CursorPosition = 325
; FirstLine = 320
; Folding = -
; EnableXP
; UseIcon = ..\ICONS\pong.ico
; Executable = pong 2016 32 bits.exe
; Compiler = PureBasic 5.71 beta 1 LTS (Windows - x64)
; EnableUnicode