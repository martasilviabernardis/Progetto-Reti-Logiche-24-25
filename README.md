# Progetto-Reti-Logiche-24-25 - Filtro Digitale in VHDL

Questa repository contiene il progetto sviluppato per l’esame di Reti Logiche.
L’obiettivo è la realizzazione di un modulo hardware in VHDL capace di leggere una sequenza di dati da memoria, applicare un filtro FIR e scrivere il risultato nuovamente in RAM.

FPGA target: Xilinx (Vivado)

Realizzato da: Marta Silvia Bernardis e Stefano Bernardotto

Valutazione finale: 30/30

*** DESCRIZIONE DEL PROGETTO ***

Il componente implementa un filtro digitale di ordine 3 o 5, selezionato tramite un byte di controllo.
L’architettura è basata su una macchina a stati finiti (FSM) che gestisce:

  - Lettura dei parametri e dei dati da memoria,
  - Moltiplicazioni e somme sui campioni,
  - Normalizzazione tramite operazioni di shift (evitando divisioni non sintetizzabili),
  - Scrittura dell’output in memoria.

Il progetto è completamente sintetizzabile, simulabile e conforme alla specifica assegnata, è stato testato tramite simulazioni comportamentali, post-sintesi e post-implementazione.

*** CONTENUTO DELLA REPOSITORY **

  - Codice VHDL del modulo e dei sottoblocchi
  - Specifica del progetto
  - Test bench, inclusi quelli forniti dal docente e altri bench aggiuntivi sviluppati per verificare casi limite e scenari particolari

------------------------------------------------------------------------------------------------------------------
# Logic Networks Project 2024–2025 – Digital Filter in VHDL

This repository contains the project developed for the Logic Networks exam.
The goal of the project is the design and implementation of a VHDL hardware module capable of reading a data sequence from memory, applying a FIR filter, and writing the processed results back to RAM.

Target FPGA: Xilinx (Vivado)

Developed by: Marta Silvia Bernardis and Stefano Bernardotto

Final grade: 30/30

*** PROJECT DESCRIPTION ***

The component implements a 3rd- or 5th-order digital filter, selected via a control byte.
The architecture is based on a Finite State Machine (FSM) that manages:

Reading configuration parameters and input data from memory

Sample multiplication and accumulation

Output normalization through shift operations (avoiding non-synthesizable divisions)

Writing the output sequence back to memory

The project is fully synthesizable, simulable, and compliant with the assigned specification.
It has been validated through behavioral, post-synthesis, and post-implementation simulations.

*** REPOSITORY CONTENTS ***

VHDL source code of the main module and its submodules

Project specification

Test benches, including those provided by the instructor and additional benches developed to verify edge cases and corner scenarios
