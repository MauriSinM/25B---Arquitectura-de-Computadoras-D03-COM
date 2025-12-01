# Arquitectura MIPS en Verilog - Pipeline de 5 Etapas

Proyecto de implementación en Verilog de un procesador MIPS con pipeline de 5 etapas, desarrollado para simulación en ModelSim.

## 📋 Características

### 🏗️ Arquitectura del Pipeline
- **FETCH**: Obtención de instrucciones
- **DECODE**: Decodificación y lectura de registros  
- **EXECUTE**: Ejecución en ALU
- **MEMORY**: Acceso a memoria de datos
- **WRITEBACK**: Escritura en banco de registros

### 🔧 Módulos Implementados
- `_pc`: Program Counter
- `_percheron`: Memoria de instrucciones
- `_Modifiedregister_b`: Banco de registros
- `_DefinitiveAlu`: Unidad Aritmético-Lógica
- `_control_unit`: Unidad de control principal
- `_data_memory`: Memoria de datos
- Buffers de pipeline entre etapas

### 📝 Conjunto de Instrucciones Soportadas
- **Tipo R**: ADD, SUB, AND, OR, SLT
- **Tipo I**: ADDI, LW, SW, BEQ, BNE, SLTI
- **Tipo J**: J, JAL

## 🚀 Instalación y Uso

### Prerrequisitos
- ModelSim/QuestaSim
- Compilador Verilog

MIPS-Pipeline-Verilog/
├── Data/
│   └── Set.txt          # Memoria de programa/datos
├── top_pipelines.v      # Top module del pipeline
├── tb_top_pipelines.v   # Testbench básico
├── tb_mips_program.v    # Testbench con programa
└── Modulos/
    ├── _pc.v           # Program Counter
    ├── _percheron.v    # Memoria de instrucciones
    ├── _Modifiedregister_b.v # Banco de registros
    ├── _DefinitiveAlu.v # Unidad ALU
    ├── _control_unit.v # Unidad de control
    ├── _data_memory.v  # Memoria de datos
    ├── *_Mux*.v        # Multiplexores
    └── Buffers/
        ├── _CF_DE.v    # Fetch-Decode
        ├── _DE_EX.v    # Decode-Execute
        ├── _EX_MEM.v   # Execute-Memory
        └── _MEM_WB.v   # Memory-Writeback
