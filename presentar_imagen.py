import tkinter as tk
from tkinter import filedialog, messagebox, Toplevel
from PIL import Image, ImageTk
import os

directorio_origen = "/var/www/html/upload/files/"

def redimensionar_con_aspect_ratio(imagen, max_width, max_height):
    ancho_original, alto_original = imagen.size
    ratio = min(max_width / ancho_original, max_height / alto_original)
    nuevo_ancho = int(ancho_original * ratio)
    nuevo_alto = int(alto_original * ratio)
    return imagen.resize((nuevo_ancho, nuevo_alto), Image.Resampling.LANCZOS)

def mostrar_imagen_en_ventana_nueva(ruta_imagen):
    ventana_imagen = Toplevel()
    ventana_imagen.title(f"Imagen: {os.path.basename(ruta_imagen)}")
    
    try:
        img = Image.open(ruta_imagen)
        img = redimensionar_con_aspect_ratio(img, 600, 400)
        foto = ImageTk.PhotoImage(img)

        etiqueta = tk.Label(ventana_imagen, image=foto)
        etiqueta.image = foto
        etiqueta.pack(padx=10, pady=10)

        btn_cerrar = tk.Button(ventana_imagen, text="Cerrar", command=ventana_imagen.destroy)
        btn_cerrar.pack(pady=(0,10))

        ventana_imagen.geometry(f"{img.width + 40}x{img.height + 80}")
    except Exception as e:
        messagebox.showerror("Error", f"No se pudo mostrar la imagen:\n{e}")
        ventana_imagen.destroy()

def elegir_imagen():
    archivo = filedialog.askopenfilename(
        title="Selecciona una imagen",
        initialdir=directorio_origen,
        filetypes=[
            ("Archivos de imagen", "*.jpg *.jpeg *.png *.gif *.bmp *.tiff"),
            ("Todos los archivos", "*.*")
        ]
    )
    if archivo:
        mostrar_imagen_en_ventana_nueva(archivo)
        root.withdraw()  # Oculta la ventana principal sin cerrarla

def cancelar():
    root.destroy()  # Cierra completamente la aplicación

root = tk.Tk()
root.title("Selector de imágenes")
root.geometry("300x150")

# Frame horizontal para los botones
frame_botones = tk.Frame(root)
frame_botones.pack(expand=True)

btn_elegir = tk.Button(frame_botones, text="Elegir imagen", command=elegir_imagen)
btn_elegir.pack(side="left", padx=10, pady=20)

btn_cancelar = tk.Button(frame_botones, text="Cancelar", command=cancelar, bg="red", fg="white")
btn_cancelar.pack(side="left", padx=10, pady=20)

root.mainloop()

