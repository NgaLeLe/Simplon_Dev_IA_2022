import cv2
def dectect():
    name = 'Your name'
    #charger le fichier cascade de visage pré-définit dans face_cascade
    face_cascade = cv2.CascadeClassifier('haarcascade_frontalface_alt.xml')

    #capturer un frame du webcasm
    capture = cv2.VideoCapture(0)

    #prendre un video sortie du webcam
    while 1:
        #ret stores the continuous video feed
        #arg 'ret': un nom de fenêtre qui est une chaîne
        ret, img = capture.read()
        #convertir image en mode gray
        img_gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        
        # Detecter des visages dont ses tailles sont différents 
        #scaleFactor: 
        faces = face_cascade.detectMultiScale(
            img_gray,
            scaleFactor=1.1,
            minNeighbors=5,
            minSize=(30, 30),
            flags = cv2.CASCADE_SCALE_IMAGE
        ) 
        
        # Tracer un box rectangle autour de visage détecté 
        for (x,y,w,h) in faces:
            #(x,y): coordonnee du point départ
            #(x+w,y+h): coordonnee du point terminé de rectangle
            cv2.rectangle(img,(x,y), (x+w,y+h), (255,255,0), 3)
            
            # afficher son nom s/visage capturé
            cv2.putText(
                img, name.upper(), 
                (x - 1, y - 1), 
                cv2.FONT_HERSHEY_PLAIN,2,(150, 255, 0))
        
        #afficher une image dans une autre fenêtre
        cv2.imshow('img', img)
        #boucle va être arreté par l'appuie character 'q'
        if cv2.waitKey(1) == ord('q'):
            break

    # lebérer le camera
    capture.release() 

    # Détruire/fermer toutes les fenêtres ouvertes 
    cv2.destroyAllWindows()

if __name__ == '__main__':
    dectect()