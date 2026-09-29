#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import shutil
import subprocess
import sys
import tkinter as tk
from tkinter import ttk, filedialog, messagebox
from datetime import datetime

DEFAULT_INI = "/home/pi/MMDVMHost/MMDVMFUSION.ini"
DISPLAY_INI = "/root/Display-Driver/MMDVM-Display.ini"
FUSION_DIR = "/home/pi/A108"
FUSION_OPEN_SCRIPT = os.path.join(FUSION_DIR, "ejecutar_solofusion.sh")
FUSION_CLOSE_SCRIPT = os.path.join(FUSION_DIR, "cerrar_solofusion.sh")
DMRGATEWAY_OPEN_SCRIPT = os.path.join(FUSION_DIR, "ejecutar_dmrgateway.sh")
DMRGATEWAY_CLOSE_SCRIPT = os.path.join(FUSION_DIR, "cerrar_dmrgateway.sh")
AUTOARRANQUE_INI = "/home/pi/.local/autoarranque.ini"
AUTOARRANQUE_DESKTOP_SOURCE = "/home/pi/AUTOARRANQUE_A108/FUSIONSOLO.desktop"
AUTOARRANQUE_DIR = "/home/pi/.config/autostart"
AUTOARRANQUE_DESKTOP_DEST = os.path.join(AUTOARRANQUE_DIR, "FUSIONSOLO.desktop")


class IniDocument:
    """Editor INI simple que conserva comentarios, orden y lineas desconocidas."""

    def __init__(self, path):
        self.path = path
        self.lines = []
        self.items = []  # dicts: section, key, value, line_index
        self.load(path)

    def load(self, path=None):
        if path is not None:
            self.path = path
        with open(self.path, "r", encoding="utf-8", errors="replace") as f:
            self.lines = f.readlines()

        self.items = []
        section = "General"
        for idx, raw in enumerate(self.lines):
            s = raw.strip()
            if not s or s.startswith("#") or s.startswith(";"):
                continue
            if s.startswith("[") and s.endswith("]"):
                section = s[1:-1].strip()
                continue
            if "=" in raw:
                left, right = raw.split("=", 1)
                key = left.strip()
                if not key:
                    continue
                value = right.rstrip("\r\n").strip()
                self.items.append({
                    "section": section,
                    "key": key,
                    "value": value,
                    "line_index": idx,
                })

    def sections(self):
        result = []
        for item in self.items:
            if item["section"] not in result:
                result.append(item["section"])
        return result

    def items_in_section(self, section):
        return [x for x in self.items if x["section"] == section]

    def set_values(self, values):
        """values usa clave (section, key, line_index) para evitar colisiones."""
        for item in self.items:
            ident = (item["section"], item["key"], item["line_index"])
            if ident not in values:
                continue
            new_value = str(values[ident])
            idx = item["line_index"]
            raw = self.lines[idx]
            newline = "\n" if raw.endswith("\n") else ""
            prefix = raw.split("=", 1)[0]
            self.lines[idx] = f"{prefix}={new_value}{newline}"
            item["value"] = new_value

    def save(self, path=None, make_backup=True):
        if path is None:
            path = self.path

        if make_backup and os.path.exists(path):
            stamp = datetime.now().strftime("%Y%m%d-%H%M%S")
            backup = f"{path}.bak-{stamp}"
            shutil.copy2(path, backup)
        else:
            backup = None

        tmp = f"{path}.tmp"
        with open(tmp, "w", encoding="utf-8") as f:
            f.writelines(self.lines)
        os.replace(tmp, path)
        self.path = path
        return backup


class ScrollFrame(ttk.Frame):
    def __init__(self, master, *args, **kwargs):
        super().__init__(master, *args, **kwargs)
        self.canvas = tk.Canvas(self, highlightthickness=0, bg="#101010")
        self.scrollbar = ttk.Scrollbar(self, orient="vertical", command=self.canvas.yview)
        self.inner = ttk.Frame(self.canvas)
        self.window_id = self.canvas.create_window((0, 0), window=self.inner, anchor="nw")

        self.canvas.configure(yscrollcommand=self.scrollbar.set)
        self.canvas.pack(side="left", fill="both", expand=True)
        self.scrollbar.pack(side="right", fill="y")

        self.inner.bind("<Configure>", self._sync_scroll)
        self.canvas.bind("<Configure>", self._sync_width)
        self.canvas.bind_all("<MouseWheel>", self._wheel)
        self.canvas.bind_all("<Button-4>", self._wheel_linux)
        self.canvas.bind_all("<Button-5>", self._wheel_linux)

    def _sync_scroll(self, _event=None):
        self.canvas.configure(scrollregion=self.canvas.bbox("all"))

    def _sync_width(self, event):
        self.canvas.itemconfigure(self.window_id, width=event.width)

    def _wheel(self, event):
        self.canvas.yview_scroll(int(-1 * (event.delta / 120)), "units")

    def _wheel_linux(self, event):
        self.canvas.yview_scroll(-1 if event.num == 4 else 1, "units")


class FusionEditor(tk.Tk):
    def __init__(self, path):
        super().__init__()
        self.title("EDITOR FUSION - MMDVMFUSION.ini")
        self.geometry("1330x940")
        self.minsize(920, 620)
        self.geometry("+0+0")
        self.configure(bg="#101010")

        self.doc = None
        self.vars = {}
        self.widgets = {}
        self.section_frames = {}
        self.changed = False
        self.fusion_open = False
        self.dmrgateway_open = False
        self.autoarranque_fusion = False
        self.display_temp_path = None

        self._style()
        self._build_shell()
        self._refresh_autoarranque_state()
        self.open_file(path, quiet=True)

    def _style(self):
        style = ttk.Style(self)
        try:
            style.theme_use("clam")
        except tk.TclError:
            pass

        style.configure("TFrame", background="#101010")
        style.configure("Card.TFrame", background="#1a1a1a")
        style.configure("TLabel", background="#101010", foreground="#d7d7d7", font=("DejaVu Sans", 11))
        style.configure("Header.TLabel", background="#333333", foreground="white", font=("DejaVu Sans", 25, "bold"), padding=16)
        style.configure("Section.TLabel", background="#202020", foreground="white", font=("DejaVu Sans", 13, "bold"), padding=8)
        style.configure("Info.TLabel", background="#101010", foreground="#aaaaaa", font=("DejaVu Sans", 9))
        style.configure("TNotebook", background="#101010", borderwidth=0)
        # Ocultamos las pestañas nativas del ttk.Notebook. Tk las comprime cuando
        # hay muchas y acaba cortando los nombres. Usamos una barra propia
        # horizontal con flechas para que cada nombre se vea completo.
        style.configure("Hidden.TNotebook", background="#101010", borderwidth=0)
        style.layout("Hidden.TNotebook.Tab", [])
        style.configure("TButton", font=("DejaVu Sans", 10, "bold"), padding=(12, 7))
        style.configure("Top.TButton", font=("DejaVu Sans", 8, "bold"), padding=(8, 7))

    def _build_shell(self):
        ttk.Label(self, text="EDITOR FUSION", style="Header.TLabel", anchor="center").pack(fill="x", padx=16, pady=(16, 8))

        top = ttk.Frame(self)
        top.pack(fill="x", padx=16, pady=(2, 8))

        self.path_var = tk.StringVar()

        # Contenedor centrado para toda la fila de botones superiores.
        top_buttons = ttk.Frame(top)
        top_buttons.pack(anchor="center")
        tk.Button(
            top_buttons,
            text="Abrir fichero MMDVMFUSION.ini",
            command=lambda: self.open_in_geany(DEFAULT_INI),
            bg="#f2b632",
            fg="#111111",
            activebackground="#f2b632",
            activeforeground="#111111",
            relief="flat",
            bd=0,
            font=("DejaVu Sans", 8, "bold"),
            cursor="hand2",
        ).pack(side="left", padx=3, ipady=4)

        self.menu_principal_button = tk.Button(
            top_buttons,
            text="MENÚ PRINCIPAL",
            command=self.menu_principal,
            bg="#444444",
            fg="white",
            activebackground="#555555",
            activeforeground="white",
            relief="flat",
            bd=0,
            font=("DejaVu Sans", 8, "bold"),
            cursor="hand2",
        )
        self.menu_principal_button.pack(side="left", padx=3, ipady=4)

        self.menu_display_button = tk.Button(
            top_buttons,
            text="MENÚ DISPLAY",
            command=self.menu_display,
            bg="#16821c",
            fg="white",
            activebackground="#1b9b22",
            activeforeground="white",
            relief="flat",
            bd=0,
            font=("DejaVu Sans", 8, "bold"),
            cursor="hand2",
        )
        self.menu_display_button.pack(side="left", padx=3, ipady=4)

        ttk.Button(top_buttons, text="Recargar", command=self.reload, style="Top.TButton").pack(side="left", padx=3)
        ttk.Button(top_buttons, text="Guardar", command=self.save, style="Top.TButton").pack(side="left", padx=3)

        self.fusion_button = tk.Button(
            top_buttons,
            text="ABRIR FUSION",
            command=self.toggle_fusion,
            relief="flat",
            bd=0,
            width=16,
            font=("DejaVu Sans", 8, "bold"),
            cursor="hand2",
        )
        self.fusion_button.pack(side="left", padx=(12, 3), ipady=4)
        self._paint_fusion_button()

        self.autoarranque_button = tk.Button(
            top_buttons,
            text="AUTOARRANQUE FUSION",
            command=self.toggle_autoarranque_fusion,
            relief="flat",
            bd=0,
            width=20,
            font=("DejaVu Sans", 8, "bold"),
            cursor="hand2",
        )
        self.autoarranque_button.pack(side="left", padx=(8, 3), ipady=4)
        self._paint_autoarranque_button()

        self.salir_button = tk.Button(
            top_buttons,
            text="SALIR",
            command=self.destroy,
            relief="flat",
            bd=0,
            width=8,
            font=("DejaVu Sans", 8, "bold"),
            bg="#c62828",
            fg="white",
            activebackground="#e53935",
            activeforeground="white",
            cursor="hand2",
        )
        self.salir_button.pack(side="left", padx=(8, 3), ipady=4)

        searchrow = ttk.Frame(self)
        searchrow.pack(fill="x", padx=16, pady=(0, 8))
        ttk.Label(searchrow, text="Buscar parámetro:").pack(side="left")
        self.search_var = tk.StringVar()
        self.search_var.trace_add("write", lambda *_: self.apply_filter())
        search = tk.Entry(searchrow, textvariable=self.search_var, bg="#202020", fg="#ffffff", insertbackground="white", relief="flat", font=("DejaVu Sans", 10))
        search.pack(side="left", fill="x", expand=True, padx=(8, 0), ipady=5)

        # Barra de pestañas desplazable. Los nombres nunca se recortan.
        tabs_nav = tk.Frame(self, bg="#101010")
        tabs_nav.pack(fill="x", padx=16, pady=(0, 4))

        self.tabs_left = tk.Button(
            tabs_nav, text="◀", command=lambda: self._scroll_tabs(-1),
            bg="#252525", fg="white", activebackground="#454545",
            activeforeground="white", relief="flat", width=3,
            font=("DejaVu Sans", 11, "bold"), cursor="hand2"
        )
        self.tabs_left.pack(side="left", fill="y")

        self.tabs_canvas = tk.Canvas(
            tabs_nav, height=42, bg="#101010", highlightthickness=0, bd=0
        )
        self.tabs_canvas.pack(side="left", fill="x", expand=True, padx=4)

        self.tabs_inner = tk.Frame(self.tabs_canvas, bg="#101010")
        self.tabs_window = self.tabs_canvas.create_window(
            (0, 0), window=self.tabs_inner, anchor="nw"
        )
        self.tabs_inner.bind("<Configure>", self._update_tabs_scrollregion)
        self.tabs_canvas.bind("<Configure>", self._update_tabs_scrollregion)

        self.tabs_right = tk.Button(
            tabs_nav, text="▶", command=lambda: self._scroll_tabs(1),
            bg="#252525", fg="white", activebackground="#454545",
            activeforeground="white", relief="flat", width=3,
            font=("DejaVu Sans", 11, "bold"), cursor="hand2"
        )
        self.tabs_right.pack(side="right", fill="y")

        self.tab_buttons = {}

        self.notebook = ttk.Notebook(self, style="Hidden.TNotebook")
        self.notebook.pack(fill="both", expand=True, padx=16, pady=(0, 8))
        self.notebook.bind("<<NotebookTabChanged>>", self._sync_tab_buttons)

        image_update_row = tk.Frame(self, bg="#101010")
        image_update_row.pack(fill="x", padx=16, pady=(0, 6))

        self.update_image_button = tk.Button(
            image_update_row,
            text="ACTUALIZAR IMAGEN",
            command=self.actualizar_imagen,
            relief="flat",
            bd=0,
            width=18,
            font=("DejaVu Sans", 10, "bold"),
            cursor="hand2",
            bg="#16821c",
            fg="white",
            activebackground="#1b9b22",
            activeforeground="white",
        )
        self.update_image_button.pack(side="left", ipady=4)

        self.reboot_button = tk.Button(
            image_update_row,
            text="REINICIAR IMAGEN",
            command=self.reiniciar_imagen,
            relief="flat",
            bd=0,
            width=16,
            font=("DejaVu Sans", 10, "bold"),
            cursor="hand2",
            bg="#dc3545",
            fg="white",
            activebackground="#bb2d3b",
            activeforeground="white",
        )
        self.reboot_button.pack(side="left", padx=(10, 4), ipady=4)

        self.editar_ysfgateway_button = tk.Button(
            image_update_row,
            text="Editar YSFGateway",
            command=self.editar_ysfgateway,
            relief="flat",
            bd=0,
            width=18,
            font=("DejaVu Sans", 9, "bold"),
            cursor="hand2",
            bg="#337ab7",
            fg="white",
            activebackground="#286090",
            activeforeground="white",
        )
        self.editar_ysfgateway_button.pack(side="left", padx=(10, 4), ipady=4)

        self.actualizar_reflectores_button = tk.Button(
            image_update_row,
            text="ACTUALIZAR REFLECTORES",
            command=self.actualizar_reflectores,
            relief="flat",
            bd=0,
            width=22,
            font=("DejaVu Sans", 9, "bold"),
            cursor="hand2",
            bg="#d98200",
            fg="white",
            activebackground="#f09a18",
            activeforeground="white",
        )
        self.actualizar_reflectores_button.pack(side="left", padx=(4, 4), ipady=4)

        self.cambiar_dmrgateway_button = tk.Button(
            image_update_row,
            text="CAMBIAR A DMRGATEWAY",
            command=self.cambiar_a_dmrgateway,
            relief="flat",
            bd=0,
            width=22,
            font=("DejaVu Sans", 9, "bold"),
            cursor="hand2",
            bg="#337ab7",
            fg="white",
            activebackground="#286090",
            activeforeground="white",
        )
        self.cambiar_dmrgateway_button.pack(side="right", ipady=4)

        self.status_var = tk.StringVar(value="Preparado")
        status = ttk.Label(self, textvariable=self.status_var, style="Info.TLabel", anchor="w")
        status.pack(fill="x", padx=18, pady=(0, 4))

        footer = tk.Label(
            self,
            text="Edita los valores y pulsa GUARDAR. Antes de guardar se crea una copia .bak con fecha y hora.",
            bg="#f2b632", fg="#111111", font=("DejaVu Sans", 11, "bold"), anchor="center", pady=8,
        )
        footer.pack(fill="x", padx=16, pady=(0, 14))

        self.protocol("WM_DELETE_WINDOW", self.on_close)

    def _marcar_menu_activo(self, path=None):
        """Marca el menu activo con un halo rojo fosforescente animado."""
        path = (path or self.path_var.get() or "").strip()

        botones = (
            (getattr(self, "menu_principal_button", None), DEFAULT_INI),
            (getattr(self, "menu_display_button", None), DISPLAY_INI),
            (getattr(self, "editar_ysfgateway_button", None), "/home/pi/YSFClients/YSFGateway/YSFGateway.ini"),
        )

        self._boton_menu_activo = None
        for boton, ruta in botones:
            if boton is None:
                continue
            activo = os.path.abspath(path) == os.path.abspath(ruta)
            boton.configure(
                highlightthickness=7 if activo else 1,
                highlightbackground="#ff1a1a" if activo else "#555555",
                highlightcolor="#ff1a1a" if activo else "#555555",
                bd=2 if activo else 0,
                relief="flat",
            )
            if activo:
                self._boton_menu_activo = boton

        # Inicia una pulsacion suave del halo. El cambio de grosor y de tonos
        # rojos simula un resplandor fosforescente en Tkinter clasico.
        if not getattr(self, "_glow_animando", False):
            self._glow_animando = True
            self._glow_paso = 0
            self.after(120, self._animar_glow_menu)

        self.update_idletasks()

    def _animar_glow_menu(self):
        boton = getattr(self, "_boton_menu_activo", None)
        if boton is None or not boton.winfo_exists():
            self._glow_animando = False
            return

        tonos = ("#ff0000", "#ff1a1a", "#ff3b3b", "#ff6666", "#ff3b3b", "#ff1a1a")
        grosores = (6, 7, 8, 9, 8, 7)
        i = getattr(self, "_glow_paso", 0) % len(tonos)

        try:
            boton.configure(
                highlightthickness=grosores[i],
                highlightbackground=tonos[i],
                highlightcolor=tonos[i],
            )
        except tk.TclError:
            self._glow_animando = False
            return

        self._glow_paso = i + 1
        self.after(140, self._animar_glow_menu)

    def _set_menu_buttons_loading(self, loading):
        """Bloquea los tres botones de menú mientras se está cargando un INI."""
        state = tk.DISABLED if loading else tk.NORMAL
        for name in (
            "menu_principal_button",
            "menu_display_button",
            "editar_ysfgateway_button",
        ):
            button = getattr(self, name, None)
            if button is not None:
                button.configure(state=state)
        self.update_idletasks()


    def _mostrar_popup_cargando(self, texto="CARGANDO..."):
        """Muestra un aviso centrado sobre el editor mientras se carga un fichero."""
        popup = tk.Toplevel(self)
        popup.title("")
        popup.transient(self)
        popup.resizable(False, False)
        popup.configure(bg="#222222")
        popup.protocol("WM_DELETE_WINDOW", lambda: None)

        tk.Label(
            popup, text=texto, bg="#222222", fg="white",
            font=("DejaVu Sans", 18, "bold"), padx=42, pady=14,
        ).pack()
        tk.Label(
            popup, text="Espere un momento...", bg="#222222", fg="#f2b632",
            font=("DejaVu Sans", 11, "bold"), padx=42, pady=0,
        ).pack(pady=(0, 16))

        popup.update_idletasks()
        x = self.winfo_rootx() + (self.winfo_width() - popup.winfo_width()) // 2
        y = self.winfo_rooty() + (self.winfo_height() - popup.winfo_height()) // 2
        popup.geometry(f"+{max(x, 0)}+{max(y, 0)}")
        # No usamos grab_set(): si durante la carga aparece un messagebox
        # (por ejemplo por un error de permisos), el popup no puede bloquearlo.
        popup.lift()
        popup.update_idletasks()
        return popup

    def _cerrar_popup_cargando(self, popup):
        if popup is not None and popup.winfo_exists():
            popup.destroy()
        self.update_idletasks()

    def menu_principal(self):
        """Vuelve a mostrar MMDVMFUSION.ini en las pestañas del editor principal."""
        if self.changed:
            if not messagebox.askyesno(
                "MENÚ PRINCIPAL",
                "Hay cambios sin guardar en el fichero actual.\n\n"
                "¿Quieres descartarlos y volver al menú principal?",
            ):
                return

        self._set_menu_buttons_loading(True)
        popup = self._mostrar_popup_cargando("CARGANDO MENÚ PRINCIPAL...")
        try:
            self.open_file(DEFAULT_INI)
        finally:
            self._cerrar_popup_cargando(popup)
            self._set_menu_buttons_loading(False)

    def menu_display(self):
        """Carga MMDVM-Display.ini en el editor usando sudo para acceder a /root."""
        if self.changed:
            if not messagebox.askyesno(
                "MENÚ DISPLAY",
                "Hay cambios sin guardar en el fichero actual.\n\n"
                "¿Quieres descartarlos y abrir MMDVM-Display.ini?",
            ):
                return

        self._set_menu_buttons_loading(True)
        popup = self._mostrar_popup_cargando("CARGANDO MENÚ DISPLAY...")
        try:
            result = subprocess.run(
                ["sudo", "-n", "cat", DISPLAY_INI],
                check=True,
                capture_output=True,
                text=True,
                timeout=5,
            )
        except subprocess.CalledProcessError as e:
            detalle = (e.stderr or e.stdout or str(e)).strip()
            self._cerrar_popup_cargando(popup)
            self._set_menu_buttons_loading(False)
            messagebox.showerror(
                "MENÚ DISPLAY",
                f"No se puede leer el fichero:\n\n{DISPLAY_INI}\n\n"
                f"Detalle: {detalle}\n\n"
                "Comprueba que el usuario pi puede ejecutar sudo sin contraseña para este acceso.",
            )
            return
        except subprocess.TimeoutExpired:
            self._cerrar_popup_cargando(popup)
            self._set_menu_buttons_loading(False)
            messagebox.showerror(
                "MENÚ DISPLAY",
                "La lectura de MMDVM-Display.ini ha tardado demasiado.\n\n"
                "Comprueba la configuración de sudo para el usuario pi.",
            )
            return
        except Exception as e:
            self._cerrar_popup_cargando(popup)
            self._set_menu_buttons_loading(False)
            messagebox.showerror(
                "MENÚ DISPLAY",
                f"No se pudo abrir {DISPLAY_INI}:\n\n{e}",
            )
            return

        try:
            temp_path = f"/tmp/MMDVM-Display-{os.getpid()}.ini"
            with open(temp_path, "w", encoding="utf-8") as f:
                f.write(result.stdout)
            self.display_temp_path = temp_path
            self.doc = IniDocument(temp_path)
        except Exception as e:
            self._cerrar_popup_cargando(popup)
            self._set_menu_buttons_loading(False)
            messagebox.showerror(
                "MENÚ DISPLAY",
                f"No se pudo preparar el fichero para editarlo:\n\n{e}",
            )
            return

        self.path_var.set(DISPLAY_INI)
        self.changed = False
        self._populate()
        self.status_var.set(
            f"Cargado: {DISPLAY_INI}  ·  {len(self.doc.items)} parámetros activos"
        )
        self._marcar_menu_activo(DISPLAY_INI)
        self._cerrar_popup_cargando(popup)
        self._set_menu_buttons_loading(False)

    def editar_ysfgateway(self):
        """Carga YSFGateway.ini en el propio editor Tkinter, organizado por pestañas."""
        path = "/home/pi/YSFClients/YSFGateway/YSFGateway.ini"

        if not os.path.isfile(path):
            messagebox.showerror(
                "Editar YSFGateway",
                f"No se encuentra el fichero:\n\n{path}",
            )
            return

        # Evita perder modificaciones pendientes del fichero que se esta editando.
        if self.changed:
            if not messagebox.askyesno(
                "Editar YSFGateway",
                "Hay cambios sin guardar en el fichero actual.\n\n"
                "¿Quieres descartarlos y abrir YSFGateway.ini?",
            ):
                return

        self._set_menu_buttons_loading(True)
        popup = self._mostrar_popup_cargando("CARGANDO YSFGateway...")
        try:
            self.open_file(path)
        finally:
            self._cerrar_popup_cargando(popup)
            self._set_menu_buttons_loading(False)

    def actualizar_reflectores(self):
        """Ejecuta el actualizador de reflectores YSF en una consola xterm."""
        script = "/home/pi/A108/actualizar_REFLECTORES_YSF_new.sh"

        if not os.path.isfile(script):
            messagebox.showerror(
                "ACTUALIZAR REFLECTORES",
                f"No se encuentra el script:\n\n{script}",
            )
            return

        try:
            self.status_var.set("Actualizando reflectores YSF...")
            self.update_idletasks()
            subprocess.Popen(
                [
                    "xterm",
                    "-geometry", "80x13+1340+10",
                    "-bg", "black",
                    "-fg", "orange",
                    "-fa", "mono",
                    "-fs", "9",
                    "-T", "ACTUALIZANDO REFLECTORES YSF",
                    "-e", "/bin/bash", script,
                ],
                cwd="/home/pi/A108",
                start_new_session=True,
            )
        except Exception as e:
            messagebox.showerror(
                "ACTUALIZAR REFLECTORES",
                f"No se pudo ejecutar la actualizacion de reflectores:\n\n{e}",
            )

    def cambiar_a_dmrgateway(self):
        """Cierra Fusion, abre editor_dmrgateway.py y cierra este editor."""
        cerrar_fusion = "/home/pi/A108/cerrar_solofusion.sh"
        editor_dmrgateway = "/home/pi/MMDVMHost/editor_dmrgateway.py"

        if not os.path.isfile(editor_dmrgateway):
            messagebox.showerror(
                "CAMBIAR A DMRGATEWAY",
                f"No se encuentra el fichero:\n\n{editor_dmrgateway}",
            )
            return

        try:
            if os.path.isfile(cerrar_fusion):
                subprocess.run(["/bin/bash", cerrar_fusion], check=False)

            subprocess.Popen(["python3", editor_dmrgateway])
            self.destroy()

        except Exception as e:
            messagebox.showerror(
                "CAMBIAR A DMRGATEWAY",
                f"No se pudo cambiar a DMRGateway:\n\n{e}",
            )

    def _update_tabs_scrollregion(self, _event=None):
        self.tabs_canvas.configure(scrollregion=self.tabs_canvas.bbox("all"))
        self.after_idle(self._update_tab_arrows)

    def _scroll_tabs(self, direction):
        # Desplaza aproximadamente una pestaña cada vez.
        self.tabs_canvas.xview_scroll(direction * 4, "units")
        self._update_tab_arrows()

    def _update_tab_arrows(self):
        try:
            first, last = self.tabs_canvas.xview()
        except tk.TclError:
            return
        self.tabs_left.configure(state="normal" if first > 0.001 else "disabled")
        self.tabs_right.configure(state="normal" if last < 0.999 else "disabled")

    def _select_tab(self, section):
        frame = self.section_frames.get(section)
        if frame is not None:
            self.notebook.select(frame)
            self._sync_tab_buttons()
            self._ensure_tab_visible(section)

    def _sync_tab_buttons(self, _event=None):
        if not self.notebook.tabs():
            return
        selected = self.notebook.select()
        for section, btn in self.tab_buttons.items():
            frame = self.section_frames.get(section)
            active = frame is not None and str(frame) == selected
            btn.configure(
                bg="#454545" if active else "#252525",
                fg="white" if active else "#dddddd",
                activebackground="#555555" if active else "#3a3a3a",
                activeforeground="white",
            )

    def _ensure_tab_visible(self, section):
        btn = self.tab_buttons.get(section)
        if btn is None:
            return
        self.update_idletasks()
        total = max(1, self.tabs_inner.winfo_reqwidth())
        view_w = max(1, self.tabs_canvas.winfo_width())
        x = btn.winfo_x()
        w = btn.winfo_width()
        first, _last = self.tabs_canvas.xview()
        left_px = first * total
        right_px = left_px + view_w
        if x < left_px:
            self.tabs_canvas.xview_moveto(max(0, x / total))
        elif x + w > right_px:
            target = max(0, min(1, (x + w - view_w) / total))
            self.tabs_canvas.xview_moveto(target)
        self._update_tab_arrows()

    def _paint_fusion_button(self):
        if not hasattr(self, "fusion_button"):
            return
        if self.fusion_open:
            self.fusion_button.configure(
                text="CERRAR FUSION",
                bg="#16821c",
                fg="white",
                activebackground="#1b9b22",
                activeforeground="white",
            )
        else:
            self.fusion_button.configure(
                text="ABRIR FUSION",
                bg="#c71f13",
                fg="white",
                activebackground="#e12b1d",
                activeforeground="white",
            )

    def _paint_dmrgateway_button(self):
        if not hasattr(self, "dmrgateway_button"):
            return
        if self.dmrgateway_open:
            self.dmrgateway_button.configure(
                text="CERRAR DMRGATEWAY",
                bg="#16821c",
                fg="white",
                activebackground="#1b9b22",
                activeforeground="white",
            )
        else:
            self.dmrgateway_button.configure(
                text="ABRIR DMRGATEWAY",
                bg="#c71f13",
                fg="white",
                activebackground="#e12b1d",
                activeforeground="white",
            )

    def toggle_dmrgateway(self):
        script = DMRGATEWAY_CLOSE_SCRIPT if self.dmrgateway_open else DMRGATEWAY_OPEN_SCRIPT
        action = "cerrar" if self.dmrgateway_open else "abrir"

        if not os.path.isfile(script):
            messagebox.showerror(
                "DMRGATEWAY",
                f"No se encuentra el script para {action} DMRGATEWAY:\n\n{script}",
            )
            return

        try:
            subprocess.Popen(
                ["/bin/bash", script],
                cwd=FUSION_DIR,
                start_new_session=True,
            )
        except Exception as e:
            messagebox.showerror("DMRGATEWAY", f"Error al ejecutar {script}:\n\n{e}")
            return

        self.dmrgateway_open = not self.dmrgateway_open
        self._paint_dmrgateway_button()
        self.status_var.set(
            "DMRGATEWAY abierto" if self.dmrgateway_open else "DMRGATEWAY cerrado"
        )

    def _refresh_autoarranque_state(self):
        """Detecta si el autoarranque FUSION esta realmente activado."""
        enabled_in_ini = False
        try:
            with open(AUTOARRANQUE_INI, "r", encoding="utf-8", errors="replace") as f:
                lines = f.readlines()
            if len(lines) >= 11:
                enabled_in_ini = lines[10].strip() == "SOLO_FUSION=ON"
            else:
                enabled_in_ini = any(
                    line.strip() == "SOLO_FUSION=ON" for line in lines
                )
        except OSError:
            enabled_in_ini = False

        # El estado inicial del boton ABRIR/CERRAR FUSION se toma exactamente
        # de la linea 11 de autoarranque.ini, tal como se usa en la imagen.
        # SOLO_FUSION=ON  -> boton verde CERRAR FUSION
        # cualquier otro valor -> boton rojo ABRIR FUSION
        self.fusion_open = enabled_in_ini
        self._paint_fusion_button()

        self.autoarranque_fusion = (
            enabled_in_ini and os.path.isfile(AUTOARRANQUE_DESKTOP_DEST)
        )
        self._paint_autoarranque_button()

    def _paint_autoarranque_button(self):
        if not hasattr(self, "autoarranque_button"):
            return

        if self.autoarranque_fusion:
            self.autoarranque_button.configure(
                text="QUITAR AUTOARRANQUE",
                bg="#16821c",
                fg="white",
                activebackground="#1b9b22",
                activeforeground="white",
            )
        else:
            self.autoarranque_button.configure(
                text="AUTOARRANQUE FUSION",
                bg="white",
                fg="#111111",
                activebackground="#e7e7e7",
                activeforeground="#111111",
            )

    def toggle_autoarranque_fusion(self):
        # Al activar AUTOARRANQUE, sobrescribir la linea 7 de editor_py.desktop.
        if not self.autoarranque_fusion:
            editor_desktop = "/home/pi/.config/autostart/editor_py.desktop"
            if not os.path.isfile(editor_desktop):
                messagebox.showerror(
                    "AUTOARRANQUE",
                    f"No se encuentra el fichero:\n\n{editor_desktop}",
                )
                return
            try:
                subprocess.run(
                    [
                        "sed", "-i",
                        "7c Exec=sh -c 'python3 /home/pi/MMDVMHost/editor_fusion.py'",
                        editor_desktop,
                    ],
                    check=True,
                )
                dmrgateway_desktop = "/home/pi/.config/autostart/DMRGateway.desktop"
                if os.path.isfile(dmrgateway_desktop):
                    os.remove(dmrgateway_desktop)
            except Exception as e:
                messagebox.showerror(
                    "AUTOARRANQUE",
                    f"No se pudo actualizar editor_py.desktop:\n\n{e}",
                )
                return

        if self.autoarranque_fusion:
            try:
                # Desactivar SOLO FUSION. Se usa la misma linea 11 y el mismo
                # fichero .desktop de FUSION, evitando tocar la configuracion D-STAR.
                subprocess.run(
                    ["sed", "-i", "11c SOLO_FUSION=OFF", AUTOARRANQUE_INI],
                    check=True,
                )
                if os.path.exists(AUTOARRANQUE_DESKTOP_DEST):
                    os.remove(AUTOARRANQUE_DESKTOP_DEST)
            except Exception as e:
                messagebox.showerror(
                    "AUTOARRANQUE FUSION",
                    f"No se pudo quitar el autoarranque FUSION:\n\n{e}",
                )
                self._refresh_autoarranque_state()
                return

            self._refresh_autoarranque_state()
            self.status_var.set("Autoarranque FUSION desactivado")
            return

        if not os.path.isfile(AUTOARRANQUE_INI):
            messagebox.showerror(
                "AUTOARRANQUE FUSION",
                f"No se encuentra el fichero:\n\n{AUTOARRANQUE_INI}",
            )
            return

        if not os.path.isfile(AUTOARRANQUE_DESKTOP_SOURCE):
            messagebox.showerror(
                "AUTOARRANQUE FUSION",
                f"No se encuentra el lanzador:\n\n{AUTOARRANQUE_DESKTOP_SOURCE}",
            )
            return

        try:
            subprocess.run(
                ["sed", "-i", "11c SOLO_FUSION=ON", AUTOARRANQUE_INI],
                check=True,
            )
            os.makedirs(AUTOARRANQUE_DIR, exist_ok=True)
            shutil.copy2(AUTOARRANQUE_DESKTOP_SOURCE, AUTOARRANQUE_DESKTOP_DEST)
        except Exception as e:
            messagebox.showerror(
                "AUTOARRANQUE FUSION",
                f"No se pudo activar el autoarranque FUSION:\n\n{e}",
            )
            self._refresh_autoarranque_state()
            return

        self._refresh_autoarranque_state()
        self.status_var.set("Autoarranque FUSION activado")

    def actualizar_imagen(self):
        script = "/home/pi/A108/actualiza_imagen.sh"

        if not os.path.isfile(script):
            messagebox.showerror(
                "ACTUALIZAR IMAGEN",
                f"No se encuentra el script:\n\n{script}",
            )
            return

        try:
            self.status_var.set("Actualizando imagen...")
            self.update_idletasks()
            subprocess.Popen(
                [
                    "xterm",
                    "-geometry", "80x13+1340+10",
                    "-bg", "black",
                    "-fg", "white",
                    "-fa", "mono",
                    "-fs", "9",
                    "-T", "ACTUALIZANDO",
                    "-e", "/bin/bash", script,
                ],
                cwd="/home/pi/A108",
                start_new_session=True,
            )
        except Exception as e:
            messagebox.showerror(
                "ACTUALIZAR IMAGEN",
                f"No se pudo ejecutar la actualizacion de imagen:\n\n{e}",
            )

    def reiniciar_imagen(self):
        if not messagebox.askyesno(
            "REINICIAR IMAGEN",
            "Se reiniciara completamente la Raspberry Pi.\n\n¿Quieres continuar?",
        ):
            return

        try:
            self.status_var.set("Reiniciando imagen...")
            self.update_idletasks()
            subprocess.Popen(
                ["sudo", "reboot"],
                start_new_session=True,
            )
        except Exception as e:
            messagebox.showerror(
                "REINICIAR IMAGEN",
                f"No se pudo reiniciar la imagen:\n\n{e}",
            )

    def toggle_fusion(self):
        script = FUSION_CLOSE_SCRIPT if self.fusion_open else FUSION_OPEN_SCRIPT
        action = "cerrar" if self.fusion_open else "abrir"

        if not os.path.isfile(script):
            messagebox.showerror(
                "FUSION",
                f"No se encuentra el script para {action} FUSION:\n\n{script}",
            )
            return

        try:
            # Estos scripts pueden dejar MMDVMFUSION/YSFGateway ejecutándose
            # en primer plano. No debemos esperar a que terminen, porque eso
            # provocaba el falso error de timeout aunque FUSION ya estuviera
            # funcionando correctamente.
            subprocess.Popen(
                ["/bin/bash", script],
                cwd=FUSION_DIR,
                start_new_session=True,
            )
        except Exception as e:
            messagebox.showerror("FUSION", f"Error al ejecutar {script}:\n\n{e}")
            return

        # Si el script pudo lanzarse, actualizamos inmediatamente el estado
        # del botón. El proceso queda funcionando de forma independiente.
        self.fusion_open = not self.fusion_open
        self._paint_fusion_button()
        self.status_var.set(
            "FUSION abierto" if self.fusion_open else "FUSION cerrado"
        )

    def open_file(self, path, quiet=False):
        if not path:
            return
        try:
            self.doc = IniDocument(path)
        except Exception as e:
            if not quiet:
                messagebox.showerror("Error", f"No se puede abrir:\n{path}\n\n{e}")
            else:
                self.status_var.set(f"No se pudo abrir {path}: {e}")
            return

        self.path_var.set(path)
        self.changed = False
        self._populate()
        self.status_var.set(f"Cargado: {path}  ·  {len(self.doc.items)} parámetros activos")
        self._marcar_menu_activo(path)

    def open_in_geany(self, path=None):
        path = (path or self.path_var.get()).strip()
        if not path:
            messagebox.showwarning("Abrir", "No hay ningún fichero seleccionado.")
            return
        if not os.path.isfile(path):
            messagebox.showerror("Abrir", f"No existe el fichero:\n{path}")
            return
        try:
            subprocess.Popen(["geany", path], start_new_session=True)
            self.status_var.set(f"Abierto con Geany: {path}")
        except FileNotFoundError:
            messagebox.showerror("Abrir", "No se encuentra Geany. Instálalo con: sudo apt install geany")
        except Exception as e:
            messagebox.showerror("Abrir", f"No se pudo abrir el fichero con Geany:\n\n{e}")

    def choose_file(self):
        path = filedialog.askopenfilename(
            title="Seleccionar fichero INI",
            initialdir=os.path.dirname(self.path_var.get()) or "/home/pi/MMDVMHost",
            filetypes=[("Ficheros INI", "*.ini"), ("Todos los ficheros", "*")],
        )
        if path:
            self.open_file(path)

    def reload(self):
        path = self.path_var.get().strip()
        if not path:
            return
        if self.changed and not messagebox.askyesno("Recargar", "Hay cambios sin guardar. ¿Descartarlos y recargar el fichero?"):
            return
        self.open_file(path)

    def _populate(self):
        for tab in self.notebook.tabs():
            self.notebook.forget(tab)
        self.vars.clear()
        self.widgets.clear()
        self.section_frames.clear()
        for child in self.tabs_inner.winfo_children():
            child.destroy()
        self.tab_buttons.clear()
        self.tabs_canvas.xview_moveto(0)

        if not self.doc:
            return

        # Secciones avanzadas que no queremos mostrar como pestañas.
        # Siguen conservandose intactas en el fichero INI al guardar.
        hidden_sections = {
            "MQTT",
            "DMR Id Lookup",
            "NXDN Id Lookup",
            "Transparent Data",
            "DMR Trunking",
            "Lock File",
            "Remote Control",
        }

        for section in self.doc.sections():
            if section in hidden_sections:
                continue

            sf = ScrollFrame(self.notebook)
            self.notebook.add(sf, text=section)
            self.section_frames[section] = sf

            # Botón con el nombre COMPLETO de la sección. No se fuerza anchura,
            # por lo que Tk calcula el tamaño necesario para mostrar todo el texto.
            tab_btn = tk.Button(
                self.tabs_inner, text=section,
                command=lambda section=section: self._select_tab(section),
                bg="#252525", fg="#dddddd",
                activebackground="#3a3a3a", activeforeground="white",
                relief="solid", bd=1, padx=14, pady=8,
                font=("DejaVu Sans", 10, "bold"), cursor="hand2"
            )
            tab_btn.pack(side="left", padx=(0, 2), pady=1)
            self.tab_buttons[section] = tab_btn

            ttk.Label(sf.inner, text=f"[{section}]", style="Section.TLabel", anchor="w").pack(fill="x", padx=8, pady=(8, 6))

            for item in self.doc.items_in_section(section):
                row = ttk.Frame(sf.inner, style="Card.TFrame")
                row.pack(fill="x", padx=8, pady=3)

                label = tk.Label(row, text=item["key"], bg="#1a1a1a", fg="#cfcfcf", font=("DejaVu Sans", 11), width=25, anchor="w")
                label.pack(side="left", padx=(10, 6), pady=7)

                ident = (item["section"], item["key"], item["line_index"])
                var = tk.StringVar(value=item["value"])
                var.trace_add("write", lambda *_args, ident=ident: self._mark_changed(ident))
                self.vars[ident] = var

                if item["key"] == "Enable" and item["value"] in ("0", "1"):
                    holder = tk.Frame(row, bg="#1a1a1a")
                    holder.pack(side="left", fill="x", expand=True, padx=(0, 10), pady=4)
                    btn = tk.Button(holder, relief="flat", width=10, font=("DejaVu Sans", 10, "bold"), command=lambda ident=ident: self.toggle_enable(ident))
                    btn.pack(side="left")
                    self.widgets[ident] = (row, label, btn)
                    self._paint_toggle(ident)
                else:
                    ent = tk.Entry(row, textvariable=var, bg="#282828", fg="#e8e8e8", insertbackground="white", relief="flat", font=("DejaVu Sans Mono", 11))
                    ent.pack(side="left", fill="x", expand=True, padx=(0, 10), pady=5, ipady=5)
                    self.widgets[ident] = (row, label, ent)

        self.after_idle(self._finish_tabs_layout)

    def _finish_tabs_layout(self):
        self._update_tabs_scrollregion()
        self._sync_tab_buttons()
        self._update_tab_arrows()

    def _mark_changed(self, ident):
        self.changed = True
        self.status_var.set("Cambios pendientes de guardar")
        if ident in self.widgets and self.doc:
            section, key, _ = ident
            if key == "Enable":
                self._paint_toggle(ident)

    def _paint_toggle(self, ident):
        widget_tuple = self.widgets.get(ident)
        if not widget_tuple:
            return
        btn = widget_tuple[2]
        on = self.vars[ident].get().strip() == "1"
        btn.configure(
            text="ON" if on else "OFF",
            bg="#16821c" if on else "#c71f13",
            fg="white",
            activebackground="#1b9b22" if on else "#e12b1d",
            activeforeground="white",
        )

    def toggle_enable(self, ident):
        self.vars[ident].set("0" if self.vars[ident].get().strip() == "1" else "1")

    def apply_filter(self):
        term = self.search_var.get().strip().lower()
        for ident, (row, _label, _widget) in self.widgets.items():
            section, key, _ = ident
            value = self.vars[ident].get().lower()
            visible = not term or term in key.lower() or term in value or term in section.lower()
            if visible:
                if not row.winfo_manager():
                    row.pack(fill="x", padx=8, pady=3)
            else:
                row.pack_forget()

    def save(self):
        if not self.doc:
            return

        path = self.path_var.get().strip()
        if not path:
            messagebox.showwarning("Guardar", "No hay fichero seleccionado.")
            return

        values = {ident: var.get() for ident, var in self.vars.items()}
        self.doc.set_values(values)

        # MMDVM-Display.ini esta dentro de /root. Se guarda con sudo y,
        # solamente si el guardado termina bien, se reinicia displaydriver.
        if path == DISPLAY_INI:
            try:
                stamp = datetime.now().strftime("%Y%m%d-%H%M%S")
                backup = f"{DISPLAY_INI}.bak-{stamp}"

                subprocess.run(
                    ["sudo", "-n", "cp", "-p", DISPLAY_INI, backup],
                    check=True,
                    capture_output=True,
                    text=True,
                )

                contenido = "".join(self.doc.lines)
                subprocess.run(
                    ["sudo", "-n", "tee", DISPLAY_INI],
                    input=contenido,
                    check=True,
                    capture_output=True,
                    text=True,
                )

                subprocess.run(
                    ["sudo", "-n", "systemctl", "restart", "displaydriver"],
                    check=True,
                    capture_output=True,
                    text=True,
                )
            except subprocess.CalledProcessError as e:
                detalle = (e.stderr or e.stdout or str(e)).strip()
                messagebox.showerror(
                    "Error al guardar DISPLAY",
                    f"No se pudo guardar o reiniciar displaydriver.\n\n{detalle}",
                )
                return
            except Exception as e:
                messagebox.showerror("Error al guardar DISPLAY", str(e))
                return

            self.changed = False
            self.status_var.set(
                "MMDVM-Display.ini guardado y displaydriver reiniciado correctamente"
            )
            messagebox.showinfo(
                "Guardado",
                "MMDVM-Display.ini guardado correctamente.\n\n"
                f"Copia de seguridad:\n{backup}\n\n"
                "Servicio displaydriver reiniciado.",
            )
            return

        try:
            backup = self.doc.save(path, make_backup=True)
        except PermissionError:
            messagebox.showerror(
                "Permiso denegado",
                "No tengo permiso para escribir el fichero.\n\n"
                "Ejecuta el editor con un usuario que pueda modificar MMDVMFUSION.ini "
                "o ajusta los permisos del fichero.",
            )
            return
        except Exception as e:
            messagebox.showerror("Error al guardar", str(e))
            return

        self.changed = False
        self.status_var.set(f"Guardado correctamente. Copia: {backup or 'no creada'}")
        messagebox.showinfo("Guardado", f"MMDVMFUSION.ini guardado correctamente.\n\nCopia de seguridad:\n{backup}")

    def on_close(self):
        if self.changed:
            ans = messagebox.askyesnocancel("Salir", "Hay cambios sin guardar. ¿Quieres guardarlos antes de salir?")
            if ans is None:
                return
            if ans:
                self.save()
                if self.changed:
                    return
        if self.display_temp_path:
            try:
                os.remove(self.display_temp_path)
            except OSError:
                pass
        self.destroy()


def main():
    path = sys.argv[1] if len(sys.argv) > 1 else DEFAULT_INI
    app = FusionEditor(path)
    app.mainloop()


if __name__ == "__main__":
    main()
