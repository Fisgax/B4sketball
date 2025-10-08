import 'package:flutter/material.dart';
import 'resumo_total.dart';

// Tabela completa: nacionais (FPB) mantidos, distritais (ABA) atualizados 2025/26
final Map<String, Map<String, double>> premiosPorEscalao = {
  // ========================
  // Competições Nacionais FPB (mantidas como tinhas)
  // ========================
  "LPB - Fase Regular": {"Árbitro": 145.0, "Oficial de Mesa": 37.0},
  "LPB - Play-off 1/4": {"Árbitro": 173.0, "Oficial de Mesa": 46.0},
  "LPB - Play-off 1/2": {"Árbitro": 204.0, "Oficial de Mesa": 54.0},
  "LPB - Final": {"Árbitro": 228.0, "Oficial de Mesa": 60.0},
  "Proliga - Fase Regular": {"Árbitro": 73.0, "Oficial de Mesa": 30.0},
  "Proliga - 2ª Fase": {"Árbitro": 75.0, "Oficial de Mesa": 31.0},
  "Proliga - Play-off 1/4 e 1/2": {"Árbitro": 83.0, "Oficial de Mesa": 36.0},
  "Proliga - Final": {"Árbitro": 102.0, "Oficial de Mesa": 42.0},
  "CN1 - 1ª Fase": {"Árbitro": 44.0, "Oficial de Mesa": 24.0},
  "CN1 - 2ª Fase": {"Árbitro": 45.0, "Oficial de Mesa": 25.0},
  "CN1 - Playoff": {"Árbitro": 48.0, "Oficial de Mesa": 26.0},
  "CN2 - 1ª Fase": {"Árbitro": 34.0, "Oficial de Mesa": 23.0},
  "CN2 - 2ª Fase": {"Árbitro": 36.0, "Oficial de Mesa": 24.0},
  "CN2 - Final": {"Árbitro": 48.0, "Oficial de Mesa": 28.0},
  "Taça Nacional - Fase Regular": {"Árbitro": 30.0, "Oficial de Mesa": 22.0},
  "Taça Nacional - Final": {"Árbitro": 48.0, "Oficial de Mesa": 28.0},
  "Taça de Portugal - 1/32": {"Árbitro": 44.0, "Oficial de Mesa": 24.0},
  "Taça de Portugal - 1/16": {"Árbitro": 73.0, "Oficial de Mesa": 30.0},
  "Taça de Portugal - 1/8 e 1/4": {"Árbitro": 149.0, "Oficial de Mesa": 39.0},
  "Taça de Portugal - Final 4": {"Árbitro": 228.0, "Oficial de Mesa": 60.0},
  "Supertaça": {"Árbitro": 228.0, "Oficial de Mesa": 60.0},

  // ========================
  // Femininos Nacionais (mantidos)
  // ========================
  "Sub18 F - CN e TN": {"Árbitro": 22.0, "Oficial de Mesa": 16.0},
  "Sub18 F - Final 4 CN": {"Árbitro": 26.0, "Oficial de Mesa": 20.0},
  "Sub18 F - Final 4 TN": {"Árbitro": 24.0, "Oficial de Mesa": 19.0},
  "Sub16 F - CN e TN": {"Árbitro": 19.0, "Oficial de Mesa": 13.0},
  "Sub16 F - Final 4 CN": {"Árbitro": 24.0, "Oficial de Mesa": 19.0},
  "Sub16 F - Final 4 TN": {"Árbitro": 23.0, "Oficial de Mesa": 17.0},
  "Sub14 F - CN e TN": {"Árbitro": 17.0, "Oficial de Mesa": 13.0},
  "Sub14 F - Final 4 CN": {"Árbitro": 21.0, "Oficial de Mesa": 13.0},
  "Sub14 F - Final 4 TN": {"Árbitro": 19.0, "Oficial de Mesa": 12.0},

  // ========================
  // Distritais ABA 2025/26 (atualizados conforme comunicado)
  // ========================
  "Seniores": {"Árbitro": 27.0, "Oficial de Mesa": 19.0},
  "Sub21 M/F": {"Árbitro": 14.0, "Oficial de Mesa": 12.0},
  "Sub18 M/F": {"Árbitro": 13.0, "Oficial de Mesa": 10.0},
  "Fase Final Sub18": {"Árbitro": 17.0, "Oficial de Mesa": 12.0},
  "Sub16 M/F": {"Árbitro": 11.0, "Oficial de Mesa": 9.0},
  "Fase Final Sub16": {"Árbitro": 15.0, "Oficial de Mesa": 11.0},
  "Sub14 M/F": {"Árbitro": 10.0, "Oficial de Mesa": 8.0},
  "Fase Final Sub14 (jogo reduzido)": {"Árbitro": 11.0, "Oficial de Mesa": 9.0},
};
