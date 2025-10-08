import json
import os
from datetime import datetime, timedelta
import random

def criar_calendario_completo_fpb():
    """Criar calendário completo com todas as categorias FPB"""
    print("🏀 Criando calendário COMPLETO FPB...")
    
    # EQUIPAS POR CATEGORIA
    equipas_seniores_masculino = [
        "SL Benfica", "FC Porto", "Sporting CP", "UD Oliveirense", "Ovarense Gavex",
        "Imortal DC", "CAB Madeira", "Vitória SC", "Esgueira", "Maia Basket", 
        "Lusitânia", "Galitos"
    ]
    
    equipas_seniores_feminino = [
        "SL Benfica", "Sporting CP", "Quinta dos Lombos", "GDESSA", "CAB Madeira",
        "União Sportiva", "Algés", "Vólei da Mealhada", "Nacional", "Olivais"
    ]
    
    equipas_sub18_masculino = [
        "SL Benfica U18", "FC Porto U18", "Sporting CP U18", "Ovarense U18",
        "Imortal U18", "CAB U18", "Vitória SC U18", "Esgueira U18"
    ]
    
    equipas_sub18_feminino = [
        "SL Benfica U18F", "Sporting CP U18F", "Quinta Lombos U18F", 
        "GDESSA U18F", "CAB U18F", "União Sportiva U18F"
    ]
    
    equipas_sub16_masculino = [
        "SL Benfica U16", "FC Porto U16", "Sporting CP U16", "Ovarense U16",
        "Imortal U16", "CAB U16", "Vitória SC U16"
    ]
    
    equipas_sub16_feminino = [
        "SL Benfica U16F", "Sporting CP U16F", "Quinta Lombos U16F",
        "GDESSA U16F", "CAB U16F"
    ]
    
    equipas_sub14_masculino = [
        "SL Benfica U14", "FC Porto U14", "Sporting CP U14", "Ovarense U14",
        "CAB U14", "Vitória SC U14"
    ]
    
    equipas_sub14_feminino = [
        "SL Benfica U14F", "Sporting CP U14F", "Quinta Lombos U14F",
        "GDESSA U14F"
    ]

    # COMPETIÇÕES POR CATEGORIA
    competicoes = {
        'seniores_m': 'Liga Betclic',
        'seniores_f': 'Liga Feminina',
        'sub18_m': 'Campeonato Nacional U18 Masculino',
        'sub18_f': 'Campeonato Nacional U18 Feminino', 
        'sub16_m': 'Campeonato Nacional U16 Masculino',
        'sub16_f': 'Campeonato Nacional U16 Feminino',
        'sub14_m': 'Campeonato Nacional U14 Masculino',
        'sub14_f': 'Campeonato Nacional U14 Feminino'
    }

    # LOCAIS
    locais = [
        "Pavilhão Fidelidade", "Pavilhão João Rocha", "Dragão Arena",
        "Pavilhão Dr. Salvador Machado", "Arena de Angra", "Pavilhão do Imortal",
        "Pavilhão do CAB", "Pavilhão do Esgueira", "Pavilhão do Maia",
        "Pavilhão dos Lombos", "Pavilhão do GDESSA", "Pavilhão de Algés"
    ]

    jogos = []
    data_base = datetime.now() + timedelta(days=1)
    jogo_id = 1

    # FUNÇÃO PARA CRIAR JOGOS POR CATEGORIA
    def criar_jogos_categoria(equipas, categoria, competicao, num_jornadas=8):
        nonlocal jogo_id
        jogos_categoria = []
        
        for jornada in range(1, num_jornadas + 1):
            data_jornada = data_base + timedelta(weeks=jornada-1)
            
            # Emparelhar equipas
            for i in range(0, len(equipas), 2):
                if i+1 < len(equipas):
                    data_jogo = data_jornada + timedelta(days=(i//2))
                    hora_jogo = random.choice(["10:00", "12:00", "15:00", "18:00", "20:30"])
                    
                    jogo = {
                        'id': jogo_id,
                        'data': data_jogo.strftime('%Y-%m-%d'),
                        'hora': hora_jogo,
                        'jornada': jornada,
                        'categoria': categoria,
                        'competicao': competicao,
                        'equipa_casa': equipas[i],
                        'equipa_fora': equipas[i+1],
                        'local': random.choice(locais),
                        'fonte': 'calendario_completo',
                        'estado': 'agendado'
                    }
                    jogos_categoria.append(jogo)
                    jogo_id += 1
        
        return jogos_categoria

    # CRIAR JOGOS PARA TODAS AS CATEGORIAS
    print("📋 Gerando jogos por categoria...")
    
    # Seniores
    jogos.extend(criar_jogos_categoria(equipas_seniores_masculino, 'seniores_masculino', competicoes['seniores_m']))
    jogos.extend(criar_jogos_categoria(equipas_seniores_feminino, 'seniores_feminino', competicoes['seniores_f']))
    
    # Sub-18
    jogos.extend(criar_jogos_categoria(equipas_sub18_masculino, 'sub18_masculino', competicoes['sub18_m'], 6))
    jogos.extend(criar_jogos_categoria(equipas_sub18_feminino, 'sub18_feminino', competicoes['sub18_f'], 6))
    
    # Sub-16  
    jogos.extend(criar_jogos_categoria(equipas_sub16_masculino, 'sub16_masculino', competicoes['sub16_m'], 5))
    jogos.extend(criar_jogos_categoria(equipas_sub16_feminino, 'sub16_feminino', competicoes['sub16_f'], 5))
    
    # Sub-14
    jogos.extend(criar_jogos_categoria(equipas_sub14_masculino, 'sub14_masculino', competicoes['sub14_m'], 4))
    jogos.extend(criar_jogos_categoria(equipas_sub14_feminino, 'sub14_feminino', competicoes['sub14_f'], 4))

    return jogos

def main():
    print("🏀 CALENDÁRIO FPB COMPLETO - TODAS AS CATEGORIAS")
    
    # Criar calendário completo
    jogos = criar_calendario_completo_fpb()
    
    # Organizar por categoria
    categorias = {}
    for jogo in jogos:
        categoria = jogo['categoria']
        if categoria not in categorias:
            categorias[categoria] = []
        categorias[categoria].append(jogo)
    
    # Salvar resultados
    os.makedirs('data', exist_ok=True)
    
    resultado_final = {
        'metadata': {
            'total_jogos': len(jogos),
            'categorias_disponiveis': list(categorias.keys()),
            'jogos_por_categoria': {cat: len(jogos) for cat, jogos in categorias.items()},
            'update_time': str(datetime.now()),
            'versao': '2.0 - Completo'
        },
        'categorias': categorias,
        'jogos': jogos
    }
    
    with open('data/calendario_fpb_completo.json', 'w', encoding='utf-8') as f:
        json.dump(resultado_final, f, ensure_ascii=False, indent=2)
    
    print(f"\n🎯 CALENDÁRIO COMPLETO CRIADO!")
    print(f"   📊 Total de jogos: {len(jogos)}")
    print(f"   📁 Ficheiro: data/calendario_fpb_completo.json")
    
    # Estatísticas por categoria
    print(f"\n📈 ESTATÍSTICAS POR CATEGORIA:")
    for categoria, jogos_cat in categorias.items():
        print(f"   • {categoria}: {len(jogos_cat)} jogos")
    
    # Mostrar exemplo de cada categoria
    print(f"\n📅 EXEMPLOS POR CATEGORIA:")
    for categoria, jogos_cat in categorias.items():
        if jogos_cat:
            jogo = jogos_cat[0]
            print(f"   🏀 {categoria}: {jogo['equipa_casa']} vs {jogo['equipa_fora']}")

if __name__ == "__main__":
    main()