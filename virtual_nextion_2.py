# -*- coding: utf-8 -*-
import tkinter as tk
import serial
import re
from colorama import Fore, Back, Style, init

# Inicializar colorama para colores en la consola
init()

# Configuración de puerto serie
SERIAL_PORT = "/dev/virtual20"  # Ajusta para que coincida con el puerto de socat
BAUD_RATE = 9600

# Configuración de la ventana de Tkinter
WINDOW_TITLE = "MMDVMHost Virtual Nextion"
WINDOW_SIZE = "494x268+763+367"  # Dimensiones fijas
WINDOW_BG_COLOR = "#152637"

# Crear ventana principal
root = tk.Tk()
root.title(WINDOW_TITLE)
root.geometry(WINDOW_SIZE)
root.configure(bg=WINDOW_BG_COLOR)
root.resizable(False, False)

# Agregar un borde azul de 3px alrededor de la ventana
root.config(
    highlightbackground="#1E90FF",  # Color del borde azul
    highlightthickness=4  # Grosor del borde
)

# Configuración de las columnas para que se distribuyan equitativamente
root.columnconfigure(0, weight=1, uniform="equal")
root.columnconfigure(1, weight=1, uniform="equal")

# Fijar la fila de la estación sin que se vea afectada por las otras filas
root.rowconfigure(0, weight=0)

# Diccionario de configuración de etiquetas
LABEL_CONFIGS = {
    "Frecuencia RX": {"fg": "#77DD77", "font": ("Arial", 11, "bold"), "row": 2, "column": 0},
    "Frecuencia TX": {"fg": "pink", "font": ("Arial", 11, "bold"), "row": 2, "column": 1},
    "IP": {"fg": "white", "font": ("Arial", 12, "bold"), "row": 3, "column": 0},
    "Estado": {"fg": "white", "font": ("Arial", 12, "bold"), "row": 3, "column": 1},
    "Ber": {"fg": "yellow", "font": ("Arial", 12, "bold"), "row": 4, "column": 0},
    "LH": {"fg": "orange", "font": ("Arial", 11, "bold"), "row": 0, "column": 0},
    "RSSI": {"fg": "yellow", "font": ("Arial", 12, "bold"), "row": 4, "column": 1},
    "Temp": {"fg": "#ff5722", "font": ("Arial", 10, "bold"), "row": 5, "column": 0},
    "TG": {"fg": "#00adb5", "font": ("Arial", 10, "bold"), "row": 5, "column": 1},
}

# Contenedor de etiquetas
labels = {}

# Agregar las etiquetas con bordes
for label_name, config in LABEL_CONFIGS.items():
    if label_name in ["Frecuencia RX", "Frecuencia TX"]:
        label = tk.Label(
            root, 
            text=f"{label_name}: N/A", 
            bg=WINDOW_BG_COLOR, 
            fg=config["fg"], 
            font=config["font"], 
            highlightbackground="white",  # Borde naranja
            highlightthickness=1          # Grosor del borde
        )
    elif label_name == "LH":
        label = tk.Label(
            root,
            text=f"{label_name}: N/A",
            bg=WINDOW_BG_COLOR,
            fg=config["fg"],
            font=config["font"],
            highlightbackground="orange",  # Borde blanco
            highlightthickness=2          # Grosor del borde
        )
    else:
        label = tk.Label(
            root, 
            text=f"{label_name}: N/A", 
            bg=WINDOW_BG_COLOR, 
            fg=config["fg"], 
            font=config["font"]
        )
    label.grid(row=config["row"], column=config["column"], padx=10, pady=5, sticky="nsew")
    labels[label_name] = label

# Crear la etiqueta "Estación" con un borde azul
estacion_label = tk.Label(
    root, 
    text="", 
    bg=WINDOW_BG_COLOR, 
    fg="#00adb5", 
    font=("Arial", 16, "bold"),
    highlightbackground="#1E90FF",  # Borde azul
    highlightthickness=2          # Grosor del borde
)
estacion_label.grid(row=0, column=1, columnspan=2, padx=10, pady=5, sticky="nsew")

# Crear la etiqueta "Fecha y Hora" (TX/RX)
txrx_label = tk.Label(
    root, 
    text="", 
    bg=WINDOW_BG_COLOR, 
    fg="white", 
    font=("Arial", 33, "bold"), 
    highlightbackground="white",  # Borde blanco
    highlightthickness=2          # Grosor del borde
)
txrx_label.grid(row=1, column=0, columnspan=2, padx=10, pady=5, sticky="nsew")

# Abre el puerto serie una vez
try:
    ser = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=1)
except serial.SerialException as e:
    print(Fore.RED + Back.BLACK + f"Error al conectar con el puerto: {e}" + Style.RESET_ALL)
    ser = None

def update_label(field, value):
    if field in labels and labels[field].cget("text") != f"{field}: {value}":
        labels[field].config(text=f"{field}: {value}")

def update_estacion(value):
    if estacion_label.cget("text") != f"{value}":
        estacion_label.config(text=f"{value}")

def update_txrx(value):
    if txrx_label.cget("text") != f"{value}":
        txrx_label.config(text=f"{value}")

def clear_screen():
    txrx_label.config(text="")
    labels["Ber"].config(text="Ber: N/A")
    labels["RSSI"].config(text="RSSI: N/A")
    labels["TG"].config(text="TG: N/A")

def read_data():
    if ser and ser.in_waiting > 0:
        try:
            data = ser.read(ser.in_waiting)
            data_str = data.decode('utf-8', errors='ignore')
            print(Fore.WHITE + Back.BLACK + f"Trafico del puerto serie: {data_str.strip()}" + Style.RESET_ALL)
        except UnicodeDecodeError as e:
            print(Fore.RED + f"Error de decodificación: {e}" + Style.RESET_ALL)
            return
        
        parsed_data = parse_data(data_str)
        print_formatted_data(parsed_data)
        
        if "Fecha y Hora" in parsed_data:
            clear_screen()
            update_txrx(parsed_data["Fecha y Hora"])

        for key, value in parsed_data.items():
            if key == "Estación":
                update_estacion(value)
            elif key == "TX/RX":
                update_txrx(value)
            else:
                update_label(key, value)
    
    root.after(100, read_data)

def parse_data(data_str):
    result = {}
    match_patterns = {
        "Fecha y Hora": r't2.txt="([^"]+)"',
        "Estación": r'20t0.txt="([^"]+)"',
        "TX/RX": r'50t[02]\.txt="([^"]+)"',
        "Frecuencia RX": r'\b1t30.txt="([^"]+)"\b',
        "Frecuencia TX": r'\b1t32.txt="([^"]+)"\b',
        "IP": r'\b1t3.txt="([^"]+)"\b',
        "Estado": r'\b1t0.txt="([^"]+)"\b',
        "Ber": r't[47]\.txt="([^"]+)"',
        "LH": r'50t[02]\.txt="([^"]+)"',
        "RSSI": r't[35]\.txt="([^"]+)"',
        "Temp": r'\b1t20.txt="([^"]+)"\b',
        "TG": r'\b1t[13]\.txt="([^"]+)"\b',
    }

    for key, pattern in match_patterns.items():
        match = re.search(pattern, data_str)
        if match:
            value = match.group(1)
            if key == "RSSI" and '-' not in value:
                continue
            if key == "IP" and ':' not in value:
                continue
            if key == "Ber" and '%' not in value:
                continue
            if key == "Fecha y Hora" and ':' not in value:
                continue
            result[key] = value

    return result

def print_formatted_data(parsed_data):
    print(Fore.WHITE + Back.BLACK + "Datos recibidos:" + Style.RESET_ALL)
    print(f"{'Campo':<15} {'Valor'}")
    print("-" * 30)
    for key, value in parsed_data.items():
        print(f"{key:<15}: {value}")

# Iniciar la lectura de datos
read_data()

# Ejecutar la interfaz gráfica de Tkinter
root.mainloop()
