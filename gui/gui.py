import tkinter as tk
import tkinter.scrolledtext as scrolledtext
from tkinter.filedialog import askopenfilename
from os import system

WINDOW_SIZE = (1080, 720)
FRAME_SIZE = (int(WINDOW_SIZE[0] * 0.90), int(WINDOW_SIZE[1] - 20))
QUADS_OR_ST = "Show Quadruples"
TITLE = "CLOWN"
BACKGROUND_COLOR = "#2b2d35"


def create_window():
    global window
    window = tk.Tk()
    window.title(TITLE)
    window.configure(background=BACKGROUND_COLOR)
    window.geometry(f"{WINDOW_SIZE[0]}x{WINDOW_SIZE[1]}")


def compile_code():
    global code_text_area, symbol_table_text_area, errors_text_area
    code = code_text_area.get("1.0", tk.END)

    with open("test.clown", "w") as file:
        file.write(code)

    system('make all && make run INPUT_FILE=test.clown')

    with open("outputs/symbol_table.txt", "r") as file:
        symbol_table = file.read()

    symbol_table_text_area.config(state='normal')
    symbol_table_text_area.delete("1.0", tk.END)
    symbol_table_text_area.insert("1.0", symbol_table)
    symbol_table_text_area.config(state='disabled')

    with open("outputs/errors.txt", "r") as file:
        errors = file.read()

    errors_text_area.config(state='normal')
    errors_text_area.delete("1.0", tk.END)
    errors_text_area.insert("1.0", errors)
    errors_text_area.config(state='disabled')


def select_file():
    global code_text_area
    file_name = askopenfilename(initialdir="/", title="Select file",
                                filetypes=(("all files", "*.*"), ("CLOWNs files", "*.clown")))

    with open(file_name, "r") as file:
        code_text_area.delete("1.0", tk.END)
        code_text_area.insert("1.0", file.read())


class LineNumbers(tk.Text):
    def __init__(self, master, text_widget, **kwargs):
        super().__init__(master, **kwargs)

        self.text_widget = text_widget
        self.text_widget.bind('<KeyPress>', self.on_key_press)
        self.text_widget.bind('<KeyRelease>', self.on_key_release)

        self.insert(1.0, '1')
        self.configure(state='disabled')

    def on_key_press(self, event=None):
        self.update_line_numbers()

    def on_key_release(self, event=None):
        self.update_line_numbers()

    def update_line_numbers(self):
        final_index = self.text_widget.index('end-1c')
        num_of_lines = int(final_index.split('.')[0])
        line_numbers_string = '\n'.join(str(i)
                                        for i in range(1, num_of_lines + 1))
        width = len(str(num_of_lines))

        self.configure(state='normal', width=width)
        self.delete(1.0, tk.END)
        self.insert(1.0, line_numbers_string)
        self.configure(state='disabled')


def toggle_content():
    global QUADS_OR_ST, flip_button, symbol_table_text_area

    symbol_table_text_area.config(state='normal')
    symbol_table_text_area.delete("1.0", tk.END)

    if QUADS_OR_ST == "Show Symbol Table":
        QUADS_OR_ST = "Show Quadruples"

        with open("outputs/symbol_table.txt", "r") as file:
            data = file.read()

    else:
        QUADS_OR_ST = "Show Symbol Table"

        with open("outputs/quads.txt", "r") as file:
            data = file.read()

    flip_button.config(text=QUADS_OR_ST)

    symbol_table_text_area.insert("1.0", data)
    symbol_table_text_area.config(state='disabled')


def create_widgets():
    global top_frame, code_text_area, symbol_table_text_area, bottom_frame, errors_text_area, compile_button, select_file_button, flip_button

    top_frame = tk.Frame(window, width=FRAME_SIZE[0], height=FRAME_SIZE[1],
                         bg=BACKGROUND_COLOR, borderwidth=5, relief="flat")

    code_text_area = tk.Text(top_frame, width=50, height=25,
                             borderwidth=3, relief="flat")

    symbol_table_text_area = scrolledtext.ScrolledText(
        top_frame, width=50, height=28, borderwidth=3, relief="flat", wrap="none")

    bottom_frame = tk.Frame(window, width=FRAME_SIZE[0], height=FRAME_SIZE[1],
                            bg=BACKGROUND_COLOR, borderwidth=5, relief="flat")

    errors_text_area = tk.Text(bottom_frame, width=80, height=18,
                               borderwidth=3, relief="ridge", fg='red')

    compile_button = tk.Button(bottom_frame, text="Compile", width=15, height=1, fg=BACKGROUND_COLOR, font=("Monospace", 12),
                               command=compile_code)

    select_file_button = tk.Button(bottom_frame, text="Select file", width=15, height=1, fg=BACKGROUND_COLOR, font=("Monospace", 12),
                                   command=select_file)

    flip_button = tk.Button(bottom_frame, text=QUADS_OR_ST, width=15, height=1, fg=BACKGROUND_COLOR, font=("Monospace", 12),
                            command=toggle_content)


def configure_widgets():
    global code_text_area_lines_numbers

    code_text_area_lines_numbers = LineNumbers(
        top_frame, code_text_area, width=3)
    symbol_table_text_area.configure(state='disabled')
    errors_text_area.configure(state='disabled')


def pack_widgets():
    top_frame.pack()
    code_text_area_lines_numbers.pack(side="left", pady=30, fill="y")
    code_text_area.pack(side="left", fill="y", pady=30)
    symbol_table_text_area.pack(side="right", padx=20, pady=30)

    bottom_frame.pack()
    errors_text_area.pack(side=tk.LEFT, padx=(20, 20), pady=(0, 30))
    select_file_button.pack(side=tk.TOP, pady=(0, 20))
    compile_button.pack(side=tk.TOP, pady=(0, 20))
    flip_button.pack(side=tk.TOP, pady=(0, 20))


def run_app():
    create_window()
    create_widgets()
    configure_widgets()
    pack_widgets()
    window.mainloop()


if __name__ == '__main__':
    run_app()
