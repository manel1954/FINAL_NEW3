import tkinter as tk
from tkinter import messagebox
import subprocess
import re
import os

RUTA_FICHERO = "/home/pi/.local/bluetooth.sh"

def leer_vinculados():
    if not os.path.exists(RUTA_FICHERO):
        return []
    with open(RUTA_FICHERO, "r") as f:
        lineas = f.readlines()
    vinculados = []
    for linea in lineas:
        linea = linea.strip()
        if linea.startswith("sudo rfcomm bind"):
            partes = linea.split()
            if len(partes) >= 5:
                puerto = partes[3].replace("/dev/", "")
                mac = partes[4]
                vinculados.append((puerto, mac))
    return vinculados

def escribir_vinculados(vinculados):
    lineas = []
    if os.path.exists(RUTA_FICHERO):
        with open(RUTA_FICHERO, "r") as f:
            todas = f.readlines()
        if todas:
            lineas.append(todas[0].rstrip('\n') + '\n')
    else:
        lineas.append("#!/bin/bash\n")

    for i, (_, mac) in enumerate(sorted(vinculados, key=lambda x: int(re.findall(r'\d+', x[0])[0]))):
        lineas.append(f"sudo rfcomm bind /dev/rfcomm{i} {mac}\n")

    with open(RUTA_FICHERO, "w") as f:
        f.writelines(lineas)

def esta_bind(puerto):
    return os.path.exists(f"/dev/{puerto}")

def ejecutar_bind(puerto, mac, boton_bind):
    try:
        subprocess.check_call(["sudo", "rfcomm", "bind", f"/dev/{puerto}", mac])
        messagebox.showinfo("Bind", f"{puerto} vinculado a {mac}")
        boton_bind.config(state="disabled", bg="#888888")
        refrescar_lista()
    except subprocess.CalledProcessError as e:
        messagebox.showerror("Error Bind", f"No se pudo vincular {puerto}:\n{e}")

def ejecutar_unbind(puerto):
    try:
        subprocess.check_call(["sudo", "rfcomm", "unbind", f"/dev/{puerto}"])
        messagebox.showinfo("Unbind", f"{puerto} desvinculado correctamente")
        refrescar_lista()
    except subprocess.CalledProcessError as e:
        messagebox.showerror("Error Unbind", f"No se pudo desvincular {puerto}:\n{e}")

def borrar_vinculado(puerto):
    vinculados = leer_vinculados()
    nuevos = [v for v in vinculados if v[0] != puerto]
    if len(nuevos) == len(vinculados):
        messagebox.showwarning("Borrar", f"No se encontró {puerto} en la lista")
        return
    escribir_vinculados(nuevos)
    messagebox.showinfo("Borrar", f"{puerto} eliminado de la lista")
    refrescar_lista()

def borrar_y_refrescar(puerto):
    borrar_vinculado(puerto)
    refrescar_lista()

def refrescar_lista():
    for widget in frame_resultados.winfo_children():
        widget.destroy()

    vinculados = leer_vinculados()
    if not vinculados:
        resultado_text.set("No hay dispositivos vinculados en el archivo.")
        return

    resultado_text.set(f"{len(vinculados)} dispositivo(s) en la lista:")
    for puerto, mac in vinculados:
        estado = "Activo" if esta_bind(puerto) else "Inactivo"
        color_estado = "green" if estado == "Activo" else "red"

        frame_disp = tk.Frame(frame_resultados, bg="#333", pady=2)
        frame_disp.pack(fill="x", padx=5, pady=2)

        label = tk.Label(frame_disp, text=f"{puerto} - {mac} [{estado}]",
                         fg=color_estado, bg="#333", font=("Arial", 10), anchor="w")
        label.pack(side="left", fill="x", expand=True, padx=5)

        frame_botones = tk.Frame(frame_disp, bg="#333")
        frame_botones.pack(side="right", padx=5)

        btn_bind = tk.Button(frame_botones, text="Bind",
                             bg="#28a745", fg="white", font=("Arial", 8),
                             bd=0, highlightthickness=0, relief="flat")
        btn_unbind = tk.Button(frame_botones, text="Unbind",
                               bg="#dc3545", fg="white", font=("Arial", 8),
                               bd=0, highlightthickness=0, relief="flat")
        btn_borrar = tk.Button(frame_botones, text="Borrar",
                               bg="#ffc107", fg="black", font=("Arial", 8),
                               bd=0, highlightthickness=0, relief="flat",
                               command=lambda p=puerto: borrar_y_refrescar(p))

        if estado == "Inactivo":
            btn_bind.config(state="normal",
                            command=lambda p=puerto, m=mac, b=btn_bind, ub=btn_unbind: (
                                b.config(state="disabled", bg="#888888"),
                                ub.config(state="normal", bg="#dc3545"),
                                ejecutar_bind(p, m, b)
                            ))
            btn_unbind.config(state="disabled", bg="#888888")
        else:
            btn_bind.config(state="disabled", bg="#888888")
            btn_unbind.config(state="normal",
                              command=lambda p=puerto, b=btn_bind, ub=btn_unbind: (
                                  ub.config(state="disabled", bg="#888888"),
                                  b.config(state="normal", bg="#28a745"),
                                  ejecutar_unbind(p)
                              ))

        btn_bind.pack(side="left", padx=2)
        btn_unbind.pack(side="left", padx=2)
        btn_borrar.pack(side="left", padx=2)

def escanear_bluetooth():
    resultado_text.set("Escaneando dispositivos Bluetooth...")
    try:
        resultado = subprocess.check_output(['hcitool', 'scan'], text=True)
        dispositivos = re.findall(r'((?:[0-9A-F]{2}:){5}[0-9A-F]{2})\s+(.+)', resultado, re.IGNORECASE)

        for widget in frame_escaneo.winfo_children():
            widget.destroy()

        if not dispositivos:
            resultado_text.set("No se encontraron dispositivos.")
            return

        resultado_text.set(f"{len(dispositivos)} dispositivo(s) encontrado(s):")
        vinculados = leer_vinculados()
        macs_existentes = {mac for _, mac in vinculados}

        for mac, nombre in dispositivos:
            if mac in macs_existentes:
                texto_btn = f"{nombre} ({mac}) - Ya vinculado"
                estado_btn = "disabled"
            else:
                texto_btn = f"{nombre} ({mac})"
                estado_btn = "normal"

            boton = tk.Button(
                frame_escaneo,
                text=texto_btn,
                bg="#28a745" if estado_btn=="normal" else "#6c757d",
                fg="white",
                activebackground="#218838",
                activeforeground="white",
                state=estado_btn,
                bd=0, highlightthickness=0, relief="flat",
                command=lambda m=mac: agregar_dispositivo(m)
            )
            boton.pack(fill="x", padx=10, pady=2)
    except subprocess.CalledProcessError as e:
        resultado_text.set("Error al escanear Bluetooth.")
        messagebox.showerror("Error", f"No se pudo escanear: {e}")
    except Exception as ex:
        resultado_text.set("Error inesperado.")
        messagebox.showerror("Error", str(ex))

def agregar_dispositivo(mac):
    vinculados = leer_vinculados()
    macs = {m for _, m in vinculados}
    if mac in macs:
        messagebox.showinfo("Agregar", f"El dispositivo {mac} ya está en la lista.")
        return

    puertos_usados = sorted([int(re.findall(r'\d+', p)[0]) for p, _ in vinculados])
    nuevo_num = 0
    while nuevo_num in puertos_usados:
        nuevo_num += 1
    nuevo_puerto = f"rfcomm{nuevo_num}"
    vinculados.append((nuevo_puerto, mac))
    escribir_vinculados(vinculados)
    messagebox.showinfo("Agregar", f"Dispositivo {mac} agregado como {nuevo_puerto}")
    refrescar_lista()
    escanear_bluetooth()

def ejecutar_script_completo():
    try:
        subprocess.check_call(["sudo", "sh", RUTA_FICHERO])
        messagebox.showinfo("Ejecutar script", "Script ejecutado correctamente.")
        refrescar_lista()
    except subprocess.CalledProcessError as e:
        messagebox.showerror("Error script", f"No se pudo ejecutar el script:\n{e}")

def abrir_formulario_importante():
    ventana = tk.Toplevel(root)
    ventana.title("descripcion")
    ventana.configure(bg="#0E0A5C")
    ventana.geometry("500x585+1448+69")

    texto = """\
          
          
          INFORMACION PARA EL USO DE RFCOMM:

  El Bluetooth interno está desactivado por defecto para permitir 
  el uso del puerto serial del GPIO puerto (AMA0).

  Si deseas activar el Bluetooth interno, el GPIO puerto (AMA0) 
  dejaría de funcionar.

  Puedes utilizar un dispositivo USB Bluetooth y no sería necesario 
  desactivar el GPIO (AMA0).

"""

    cuadro_texto = tk.Text(
        ventana, bg="#121212", fg="white", font=("Arial", 11),
        wrap="word", height=20, width=60, borderwidth=0
    )
    cuadro_texto.insert("1.0", texto)
    cuadro_texto.configure(state="disabled")  # Solo lectura
    cuadro_texto.pack(padx=10, pady=(10, 5), fill="both", expand=True)

    # boton_pdf = tk.Button(
    #     ventana, text="Ver PDF", command=lambda: subprocess.run(["xdg-open", "/home/pi/instrucciones_rfcom.pdf"]),
    #     bg="orange", fg="black", font=("Arial", 10, "bold"),
    #     bd=0, highlightthickness=0
    # )
    # boton_pdf.pack(pady=(0, 5))

    boton_cerrar = tk.Button(
        ventana, text="CERRAR", command=ventana.destroy,
        bg="#28a745", fg="white", font=("Arial", 10, "bold"),
        bd=0, highlightthickness=0
    )
    boton_cerrar.pack(pady=(0, 10))

root = tk.Tk()
root.title("Gestión Bluetooth rfcomm")
root.geometry("612x485+1287+69")
root.configure(bg="#121212")

tk.Button(root, text="Click aqui para leer las instrucciones", command=abrir_formulario_importante,
          bg="#dc3545", fg="white", font=("Arial", 10, "bold"),
          bd=0, highlightthickness=0).pack(pady=5)

tk.Button(root, text="Refrescar lista vinculados", command=refrescar_lista,
          bg="#007bff", fg="white", font=("Arial", 10, "bold"),
          bd=0, highlightthickness=0).pack(pady=5)

frame_resultados = tk.Frame(root, bg="#222222")
frame_resultados.pack(fill="both", expand=True, padx=10, pady=5)

resultado_text = tk.StringVar()
tk.Label(root, textvariable=resultado_text, bg="#121212", fg="white",
         font=("Arial", 10)).pack()

tk.Button(root, text="Escanear Bluetooth", command=escanear_bluetooth,
          bg="#28a745", fg="white", font=("Arial", 10, "bold"),
          bd=0, highlightthickness=0).pack(pady=5)

frame_escaneo = tk.Frame(root, bg="#222222")
frame_escaneo.pack(fill="both", expand=True, padx=10, pady=5)

tk.Button(root, text="Ejecutar script completo", command=ejecutar_script_completo,
          bg="#ed8d07", fg="white", font=("Arial", 10, "bold"),
          bd=0, highlightthickness=0).pack(pady=5)





tk.Button(root, text="ESTADO DEL BLUETOOTH:",
          bg="#5007ed", fg="white", font=("Arial", 10, "bold"),
          bd=0, highlightthickness=0).pack(pady=5)









def estado_bluetooth():
    try:
        with open("/boot/config.txt", "r") as f:
            lineas = f.readlines()
        if len(lineas) >= 57:
            return lineas[56].strip().startswith("#")
        return False
    except:
        return False

def cambiar_estado_bluetooth(activar):
    estado_str = "activar" if activar else "desactivar"
    confirmacion = messagebox.askyesno(
        "Confirmar cambio",
        f"¿Deseas realmente {estado_str} el Bluetooth?"
    )

    if not confirmacion:
        return  # Cancelado por el usuario

    comando = (
        ["sudo", "sed", "-i", "57c #dtoverlay=pi3-disable-bt", "/boot/config.txt"]
        if activar else
        ["sudo", "sed", "-i", "57c dtoverlay=pi3-disable-bt", "/boot/config.txt"]
    )
    try:
        subprocess.check_call(comando)
        messagebox.showinfo("Bluetooth", f"Bluetooth {'activado' if activar else 'desactivado'} correctamente.\n\nReinicia la Raspberry para aplicar el cambio.")
        actualizar_botones_bluetooth()

    except subprocess.CalledProcessError as e:
        messagebox.showerror("Error", f"No se pudo cambiar el estado del Bluetooth:\n{e}")

def actualizar_botones_bluetooth():
    if estado_bluetooth():
        btn_bt_activado.config(state="disabled", bg="#dc3545")
        btn_bt_desactivado.config(state="normal", bg="green")
    else:
        btn_bt_activado.config(state="normal", bg="#dc3545")
        btn_bt_desactivado.config(state="disabled", bg="green")

frame_bluetooth = tk.Frame(root, bg="#121212")
frame_bluetooth.pack(pady=5)

btn_bt_activado = tk.Button(frame_bluetooth, text="DESACTIVADO Click para ACTIVARLO",
                            command=lambda: cambiar_estado_bluetooth(True),
                            font=("Arial", 7, "bold"),
                            fg="white", bg="#dc3545",
                            bd=0, highlightthickness=0)
btn_bt_activado.pack(side="left", padx=5)

btn_bt_desactivado = tk.Button(frame_bluetooth, text="ACTIVADO Click para DESACTIVARLO ",
                               command=lambda: cambiar_estado_bluetooth(False),
                               font=("Arial", 7, "bold"),
                               fg="white", bg="green",
                               bd=0, highlightthickness=0)
btn_bt_desactivado.pack(side="left", padx=5)

actualizar_botones_bluetooth()









refrescar_lista()
root.mainloop()

