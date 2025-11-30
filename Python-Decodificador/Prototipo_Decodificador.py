#nota: Agregar importar y exportar a .txt
import tkinter as tk
from tkinter import ttk, filedialog, messagebox
import re

# Cada entrada define: tipo, opcode, funct, y función de parseo
def parse_r(rd, rs, rt, shamt=0):
    return {
        'rs': rs, 'rt': rt, 'rd': rd,
        'shamt': shamt, 'opcode': 0, 'funct': None
    }

INSTRUCTION_SET = {
    # R-TYPE
    "add":  {"type": "R", "opcode": 0x00, "funct": 0x20},
    "sub":  {"type": "R", "opcode": 0x00, "funct": 0x22},
    "and":  {"type": "R", "opcode": 0x00, "funct": 0x24},
    "or":   {"type": "R", "opcode": 0x00, "funct": 0x25},
    "slt":  {"type": "R", "opcode": 0x00, "funct": 0x2A},
    "sll":  {"type": "R", "opcode": 0x00, "funct": 0x00},
    "srl":  {"type": "R", "opcode": 0x00, "funct": 0x02},
    "jr":   {"type": "R", "opcode": 0x00, "funct": 0x08},
    
    # I-TYPE aritméticas
    "addi": {"type": "I", "opcode": 0x08},
    "andi": {"type": "I", "opcode": 0x0C},
    "ori":  {"type": "I", "opcode": 0x0D},
    "xori": {"type": "I", "opcode": 0x0E},
    "slti": {"type": "I", "opcode": 0x0A},

    # I-TYPE memoria
    "lw":   {"type": "I", "opcode": 0x23},
    "sw":   {"type": "I", "opcode": 0x2B},

    # I-TYPE control
    "beq":  {"type": "I", "opcode": 0x04},

    # J-TYPE
    "j":    {"type": "J", "opcode": 0x02},

}

#   REGISTROS
REGISTER_NAMES = {
    "zero":0,"at":1,"v0":2,"v1":3,"a0":4,"a1":5,"a2":6,"a3":7,
    "t0":8,"t1":9,"t2":10,"t3":11,"t4":12,"t5":13,"t6":14,"t7":15,
    "s0":16,"s1":17,"s2":18,"s3":19,"s4":20,"s5":21,"s6":22,"s7":23,
    "t8":24,"t9":25,"k0":26,"k1":27,"gp":28,"sp":29,"fp":30,"ra":31
}
for i in range(32):
    REGISTER_NAMES[str(i)] = i

def parse_register(token):
    token = token.replace('$', '').lower()
    if token in REGISTER_NAMES:
        return REGISTER_NAMES[token]
    raise ValueError(f"Registro desconocido: {token}")

#   FUNCIONES DE ENSAMBLAJE
def strip_comment(line):
    return re.split(r'#|//', line)[0].strip()

def parse_operands(operand_str):
    return [x.strip() for x in operand_str.split(',') if x.strip()]

def encode_r_type(opcode, funct, operands, line_no):
    """Codifica una instrucción tipo R"""
    rd = rs = rt = shamt = 0
    mnemonic = operands[0] if operands else None

    # Estructuras comunes
    if funct in (0x20, 0x22, 0x24, 0x25, 0x2A):  # ADD, SUB, AND, OR, SLT
        if len(operands) != 3:
            raise ValueError(f"Línea {line_no}: se esperaban 3 operandos")
        rd = parse_register(operands[0])
        rs = parse_register(operands[1])
        rt = parse_register(operands[2])

    elif funct in (0x00, 0x02):  # SLL, SRL
        if len(operands) != 3:
            raise ValueError(f"Línea {line_no}: se esperaban 3 operandos (rd, rt, shamt)")
        rd = parse_register(operands[0])
        rt = parse_register(operands[1])
        shamt = int(operands[2], 0)

    elif funct == 0x08:  # JR
        if len(operands) != 1:
            raise ValueError(f"Línea {line_no}: se esperaba 1 operando (rs)")
        rs = parse_register(operands[0])

    else:
        raise ValueError(f"Línea {line_no}: funct desconocido {funct:#x}")

    word = ((opcode & 0x3F) << 26) | ((rs & 0x1F) << 21) | \
           ((rt & 0x1F) << 16) | ((rd & 0x1F) << 11) | \
           ((shamt & 0x1F) << 6) | (funct & 0x3F)
    return word

def encode_i_type(opcode, operands, line_no):
    if opcode in (0x08, 0x0C, 0x0D, 0x0E, 0x0A):  # ADDI, ANDI, ORI, XORI, SLTI
        if len(operands) != 3:
            raise ValueError(f"Línea {line_no}: se esperaban 3 operandos (rt, rs, imm)")
        rt = parse_register(operands[0])
        rs = parse_register(operands[1])
        imm = int(operands[2], 0) & 0xFFFF

    elif opcode in (0x23, 0x2B):  # LW, SW
        if len(operands) != 2:
            raise ValueError(f"Línea {line_no}: sintaxis esperada: lw $rt, offset($rs)")
        rt = parse_register(operands[0])
        match = re.match(r'(-?\d+)\((\$?\w+)\)', operands[1])
        if not match:
            raise ValueError(f"Línea {line_no}: formato inválido, usar offset(reg)")
        imm = int(match.group(1)) & 0xFFFF
        rs = parse_register(match.group(2))

    elif opcode == 0x04:  # BEQ
        if len(operands) != 3:
            raise ValueError(f"Línea {line_no}: se esperaban 3 operandos (rs, rt, label/offset)")
        rs = parse_register(operands[0])
        rt = parse_register(operands[1])
        imm = int(operands[2], 0) & 0xFFFF  # offset inmediato

    else:
        raise ValueError(f"Línea {line_no}: opcode I-type no implementado {opcode:#x}")

    word = ((opcode & 0x3F) << 26) | ((rs & 0x1F) << 21) | \
           ((rt & 0x1F) << 16) | (imm & 0xFFFF)

    return word

def encode_j_type(opcode, operands, line_no):
    if len(operands) != 1:
        raise ValueError(f"Línea {line_no}: J requiere 1 operando (target)")
    addr = int(operands[0], 0) & 0x03FFFFFF
    word = ((opcode & 0x3F) << 26) | addr
    return word

def assemble_line(line, line_no):
    line = line.strip()

    # Ignorar comentarios y líneas vacías
    if not line or line.startswith("#"):
        return None

    parts = re.split(r'\s+', line, 1)
    mnemonic = parts[0].lower()
    operands_str = parts[1] if len(parts) > 1 else ""
    operands = parse_operands(operands_str)

    if mnemonic not in INSTRUCTION_SET:
        raise ValueError(f"Línea {line_no}: instrucción desconocida '{mnemonic}'")

    meta = INSTRUCTION_SET[mnemonic]

    inst_type = meta["type"]

    if inst_type == "R":
        return encode_r_type(meta["opcode"], meta["funct"], operands, line_no)
    elif inst_type == "I":
        return encode_i_type(meta["opcode"], operands, line_no)
    elif inst_type == "J":
        return encode_j_type(meta["opcode"], operands, line_no)
    else:
        raise ValueError(f"Línea {line_no}: tipo no reconocido '{inst_type}'")


def assemble_lines(lines):
    assembled = []
    for i, raw in enumerate(lines, 1):
        line = strip_comment(raw)
        if not line:
            continue
        if ':' in line:
            _, after = line.split(':', 1)
            line = after.strip()
            if not line:
                continue
        word = assemble_line(line, i)
        assembled.append((i, line, word))
    return assembled

#   INTERFAZ GRÁFICA (Tkinter)
class MIPSAssemblerGUI:
    def __init__(self, root):
        self.root = root
        root.title("MIPS32 R-type Assembler")
        root.geometry("850x600")
        self._build_ui()

    def _build_ui(self):
        root = self.root
        root.columnconfigure(0, weight=1)
        root.rowconfigure(0, weight=1)

        main = ttk.Frame(root, padding=8)
        main.grid(sticky="nsew")
        main.columnconfigure(0, weight=1)
        main.columnconfigure(1, weight=0)
        main.rowconfigure(1, weight=1)
        main.rowconfigure(3, weight=1)
        
        # Codificador de ensamblador
        lbl = ttk.Label(main, text="Consola de ensamblado:")
        lbl.grid(row=0, column=0, sticky="w")

        self.txt = tk.Text(main, bg="#111", fg="#fff", insertbackground="#fff",
                           font=("Consolas", 12), width=80, height=20, wrap="none")
        self.txt.grid(row=1, column=0, sticky="nsew", padx=(0,8))

        # Panel lateral
        side = ttk.Frame(main)
        side.grid(row=1, column=1, sticky="ns")
        ttk.Button(side, text="Cargar ejemplo", command=self._load_sample, width=25).pack(pady=5)
        ttk.Button(side, text="Ensamblar y previsualizar", command=self.assemble_preview, width=25).pack(pady=5)
        ttk.Button(side, text="Guardar como .bin", command=self.assemble_save, width=25).pack(pady=5)
        ttk.Button(side, text="Salir", command=root.destroy, width=25).pack(pady=5)
        
        # Salida a binario
        lbl2 = ttk.Label(main, text="Vista previa (Binario):")
        lbl2.grid(row=2, column=0, sticky="w", pady=(10,0))
        self.preview = tk.Text(main, bg="#ffffff", fg="#000", insertbackground="#000",
                               font=("Consolas", 11), height=12, wrap="none", state="disabled")
        self.preview.grid(row=3, column=0, sticky="nsew", padx=(0,8))

    def _load_sample(self):
        example = (
            "# Ejemplo MIPS R-type\n"
            "ADD $t0, $t1, $t2\n"
            "SUB $s0, $s1, $s2\n"
            "AND $a0, $a1, $a2\n"
            "OR $t3, $t4, $t5\n"
            "SLL $t6, $t7, 3\n"
            "SRL $t8, $t9, 2\n"
            "SLT $s3, $s4, $s5\n"
            "JR $ra\n"
        )
        self.txt.delete("1.0", "end")
        self.txt.insert("1.0", example)

    def assemble_preview(self):
        lines = self.txt.get("1.0", "end").splitlines()
        try:
            assembled = assemble_lines(lines)
        except ValueError as e:
            messagebox.showerror("Error", str(e))
            return

        text = ""
        for i, line, word in assembled:
            bytes_be = word.to_bytes(4, 'big')
            text += f"{i:3d}: {line:<20} -> {word:032b}  [{', '.join(f'{b:02X}' for b in bytes_be)}]\n"

        self.preview.config(state="normal")
        self.preview.delete("1.0", "end")
        self.preview.insert("1.0", text)
        self.preview.config(state="disabled")

    def assemble_save(self):
        lines = self.txt.get("1.0", "end").splitlines()
        try:
            assembled = assemble_lines(lines)
        except ValueError as e:
            messagebox.showerror("Error", str(e))
            return
        if not assembled:
            messagebox.showwarning("Nada que guardar", "No se detectaron instrucciones.")
            return

        file = filedialog.asksaveasfilename(defaultextension=".bin", filetypes=[("Binario MIPS", "*.bin")])
        if not file:
            return
        with open(file, "wb") as f:
            for _, _, word in assembled:
                f.write(word.to_bytes(4, 'big'))
        messagebox.showinfo("Guardado", f"Archivo '{file}' generado correctamente.\n"
                                        f"{len(assembled)} instrucciones (4 bytes cada una).")

#   EJECUCIÓN
if __name__ == "__main__":
    root = tk.Tk()
    app = MIPSAssemblerGUI(root)
    root.mainloop()
