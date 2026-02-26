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
