import tkinter as tk
import subprocess

class ToolTip:
    def __init__(self, widget, get_text_callback):
        self.widget = widget
        self.get_text = get_text_callback
        self.tipwindow = None
        self.id = None
        widget.bind("<Enter>", self.enter)
        widget.bind("<Leave>", self.leave)

    def enter(self, event=None):
        self.schedule()

    def leave(self, event=None):
        self.unschedule()
        self.hidetip()

    def schedule(self):
        self.unschedule()
        self.id = self.widget.after(500, self.showtip)

    def unschedule(self):
        id_ = self.id
        self.id = None
        if id_:
            self.widget.after_cancel(id_)

    def showtip(self, event=None):
        if self.tipwindow or not self.get_text:
            return
        text = self.get_text()
        if not text:
            return
        x, y, cx, cy = self.widget.bbox("insert")
        x = x + self.widget.winfo_rootx() + 25
        y = y + cy + self.widget.winfo_rooty() + 25
        self.tipwindow = tw = tk.Toplevel(self.widget)
        tw.wm_overrideredirect(True)
        tw.wm_geometry("+%d+%d" % (x, y))
        label = tk.Label(tw, text=text, justify=tk.LEFT,
                         background="#ffffe0", relief=tk.SOLID, borderwidth=1,
                         font=("tahoma", "8", "normal"))
        label.pack(ipadx=4, ipady=2)

    def hidetip(self):
        tw = self.tipwindow
        self.tipwindow = None
        if tw:
            tw.destroy()

def toggle_minimize(event=None):
    if root.state() == "normal":
        root.iconify()
    else:
        root.deiconify()

def cerrar_qt():
    try:
        subprocess.run(['killall', 'qt_menu_superior'], check=True)
    except Exception as e:
        print(f"Error al cerrar qt_menu_superior: {e}")

def iniciar_qt():
    try:
        subprocess.Popen(['/home/pi/A108/qt/./qt_menu_superior'])
    except Exception as e:
        print(f"Error al iniciar qt_menu_superior: {e}")

dragging = False
click_threshold = 5
start_mouse_x = 0
start_mouse_y = 0
start_win_x = 0
start_win_y = 0

def on_left_button_press(event):
    global dragging, start_mouse_x, start_mouse_y, start_win_x, start_win_y
    dragging = False
    start_mouse_x = event.x_root
    start_mouse_y = event.y_root
    start_win_x = root.winfo_x()
    start_win_y = root.winfo_y()

def on_left_button_motion(event):
    global dragging
    dx = event.x_root - start_mouse_x
    dy = event.y_root - start_mouse_y
    if abs(dx) > click_threshold or abs(dy) > click_threshold:
        dragging = True
        new_x = start_win_x + dx
        new_y = start_win_y + dy
        root.geometry(f"+{new_x}+{new_y}")

def on_left_button_release(event):
    if not dragging:
        current_text = btn['text']
        if current_text == '-':
            cerrar_qt()
            btn.config(text='+')
        else:
            iniciar_qt()
            btn.config(text='-')
    # Ya no se guarda la posición

def get_tooltip_text():
    return "CERRAR PANELES" if btn['text'] == '-' else "ABRIR PANELES"

root = tk.Tk()
root.overrideredirect(True)
root.geometry("20x20+14+66")  # Fijar ventana en esquina superior izquierda
root.attributes("-topmost", True)
root.attributes("-alpha", 0.8)
root.configure(bg='black')

btn = tk.Label(root, text="-", font=("Arial", 12), fg="black", bg="orange", width=2, height=1, cursor="hand2")
btn.pack(expand=True, fill="both")

btn.bind("<ButtonPress-1>", on_left_button_press)
btn.bind("<B1-Motion>", on_left_button_motion)
btn.bind("<ButtonRelease-1>", on_left_button_release)
btn.bind("<Double-Button-1>", toggle_minimize)

ToolTip(btn, get_tooltip_text)

root.mainloop()
