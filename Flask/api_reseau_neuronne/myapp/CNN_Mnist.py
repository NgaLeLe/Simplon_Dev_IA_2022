from tensorflow.keras.layers import Conv2D, Dense, Flatten
from tensorflow.keras import Sequential
from tensorflow.keras.datasets.mnist import load_data

data = load_data(path="mnist.npz")
X_train = data[0][0]
X_test = data[1][0]

y_train = data[0][1]
y_test = data[1][1]

# On converti nos valeurs en float
X_train = X_train.reshape(-1, 28, 28, 1).astype('float64')
X_test = X_test.reshape(-1, 28, 28, 1).astype('float64')

 # normalizer les images: pixel entre 0-225 par 0-1
 # soit utiliser MinMaxScale()
 # soit diviser par 255
X_train = X_train / 255
X_test = X_test / 255
#profondeur
model = Sequential()

#ajouter des couches dans le reseau
model.add(Conv2D(32, kernel_size=(3, 3), activation="relu", input_shape=(28,28,1)))  
#couche intermediare, on utilise activation "relu"
#pour la couche intermédiare Conv2D suivant a nb de neuronne plus élevé (augmenté) que la précédente, 
model.add(Conv2D(64, kernel_size=(3, 3), activation="relu")) 

# d’aplatir la matrice. C’est à dire la transformer en vecteur.
model.add(Flatten())

model.add(Dense(400, activation="relu"))
model.add(Dense(10, activation="softmax"))
# derniere couche va prendre la tache à faire:
# si la régression -> activation="linear"
# si classification -> activation="softmax" et nb de neuronne est nb de classe
model.compile(optimizer='sgd', loss='sparse_categorical_crossentropy', metrics=['accuracy'])   

#epochs: nombre de répétition pour laquelle model va être trainer
model.fit(X_train, y_train, epochs=3, validation_data=(X_test, y_test))
# model.fit(idem)  #-> faire la même chose

model.save('cnn_minst.h5')