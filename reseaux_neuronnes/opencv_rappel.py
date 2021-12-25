import cv2


img = cv2.imread("chat.png")
print("shape image = ",img.shape[:2])
(hau, lar) = img.shape[:2]
print(lar)
print(hau)
ratio = int(lar/hau)
target_height = 100/ratio

img_resized = img.resize(img,(100, int(100/ratio)))
wt_img = cv2.cvtColor(img, cv2.COLOR_RGB)
print(img_resized.shape)