import tensorflow as tf
import cv2

img = cv2.imread("data/sample3.png")
print('Image shape = ', img.shape)

#afficher image d'entree
cv2.imshow('image', img)
cv2.waitKey(0)

#resize image en (28,28)
img_resized = img.reshape(-1, 28, 28, 1).astype('float64')
print('Image_resized shape = ', img_resized.shape)

#charger model de predict
model = tf.keras.models.load_model('cnn_minst.h5')

#predire s/image d'entree
print("Resultat_predict =>>> ", model.predict(img_resized))