# Projet Processeur 16 bits

## Description
Ce projet consiste en la **conception et l’implémentation d’un microprocesseur 16 bits** complet, réalisé en **VHDL** et testé avec **ModelSim**.  
Le processeur inclut : compteur de programme (PC), unité arithmétique et logique (ALU), registre, mémoire, pipeline d’instruction et machine d’état pour le contrôle des opérations.

## Fonctionnalités
- Exécution des instructions arithmétiques et logiques  
- Gestion des transferts de données entre registres et mémoire  
- Contrôle du flux d’instructions via une machine d’état  
- Testbench complet pour la simulation et vérification  

## Contenu du dépôt
- `src/` : fichiers VHDL du processeur et des composants (ALU, PC, registre, etc.)  
- `README.md` : ce fichier  

## Diagramme de la machine d’état
<img width="936" height="1165" alt="machine_etat_digramme (3)" src="https://github.com/user-attachments/assets/3ba3d897-3cf1-46a4-8f5b-186151dd8b0d" />

## Outils et technologies
- **VHDL** pour la conception matérielle  
- **ModelSim** pour la simulation et le test  
- FPGA pour l’implémentation  
- RTL design et optimisation temporelle  

## Instructions pour la simulation
1. Ouvrir ModelSim  
2. Compiler tous les fichiers VHDL dans l’ordre (ALU → Registre → Mémoire → CPU → Testbench)  
3. Observer les signaux et vérifier le comportement attendu  

- Filière : Ingénierie en Systèmes Embarqués (ENICarthage)  
- Projet académique réalisé en VHDL
