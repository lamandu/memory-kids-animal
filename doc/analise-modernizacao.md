# Analise de Modernizacao - Memory Kids Animal

**Data:** 2026-03-21
**Projeto Legado:** memory-kids-animal-legacy (Cocos Creator JS)
**Objetivo:** Modernizar o jogo de memoria infantil com foco em Android (Google Play), avaliando tambem viabilidade para Steam.

---

## 1. Estado Atual do Projeto Legado

### 1.1 Tecnologia Utilizada

| Item | Valor |
|------|-------|
| Engine | Cocos Creator JS (Cocos2d-x Creator) |
| Linguagem | TypeScript / JavaScript (ES6) |
| Resolucao de Design | 640x960 (Portrait) |
| Package Name | `ricardosouza.site.MemoryKidsAnimal` |
| Plataformas Configuradas | Android, iOS, Web, WeChat, Baidu, QQ Play |

### 1.2 Estrutura do Jogo

O jogo possui 3 cenas:

1. **scene1.fire** - Tela splash com animacao de particulas (3 segundos)
2. **scene2.fire** - Tela de transicao / menu inicial com botao "Start"
3. **Game.fire** - Tela principal do jogo de memoria

### 1.3 Mecanica

- 11 animais unicos (bear, chick, cow, dog, elephant, giraffe, penguin, pig, rabbit, snake, whale)
- 22 cartas no total (11 pares)
- Embaralhamento via algoritmo Fisher-Yates
- Toque na carta revela o animal dinamicamente via `cc.loader.loadRes`
- Estado global centralizado em `Global.ts` (array `bichosHard`)

### 1.4 Assets

- **Sprites de animais:** 11 PNGs em `assets/resources/animals/`
- **UI:** background com nuvens (640x960), background do jogo (1536x2048), botoes com 3 estados (normal, hover, pressed)
- **Prefab Card:** 160x160 pixels
- **Sem audio** no projeto atual
- **Sem animacoes** nas cartas (flip, match, etc.)

### 1.5 Limitacoes Identificadas

- Apenas 1 nivel de dificuldade (22 cartas fixas)
- Sem sistema de pontuacao ou estrelas
- Sem efeitos sonoros ou musica
- Sem animacoes de flip de carta ou feedback visual de acerto/erro
- Sem tela de vitoria ou celebracao
- Sem sistema de progressao (fases, desbloqueio de conteudo)
- UI basica, sem polish visual para criancas
- Sem monetizacao implementada
- Sem analytics ou tracking
- Sem suporte a acessibilidade

---

## 2. Avaliacao de SDKs / Game Engines

### 2.1 Comparativo de Engines para Jogos 2D Infantis

| Criterio | Cocos Creator 3.x | Unity | Godot | Unreal Engine | Flutter (Flame) |
|----------|-------------------|-------|-------|---------------|-----------------|
| **Foco 2D** | Excelente | Muito Bom | Excelente | Fraco (foco 3D) | Bom |
| **Curva de Aprendizado** | Media | Media | Baixa | Alta | Baixa (se ja usa Flutter) |
| **Export Android** | Nativo | Nativo | Nativo | Nativo | Nativo |
| **Export Steam (Desktop)** | Sim | Sim | Sim | Sim | Sim (limitado) |
| **Tamanho do APK** | Pequeno (~15-30MB) | Medio (~40-80MB) | Pequeno (~20-40MB) | Grande (>100MB) | Medio (~30-50MB) |
| **Performance Mobile** | Otimo | Otimo | Bom | Overkill | Bom |
| **Comunidade/Suporte** | Media (maior na Asia) | Enorme | Grande e crescente | Enorme (mas foco 3D) | Grande |
| **Custo** | Gratuito | Gratis ate $200k receita | Gratuito (MIT) | Gratis ate $1M receita | Gratuito (BSD) |
| **Asset Store** | Limitada | Enorme | Crescendo | Enorme | Limitada |
| **Monetizacao (AdMob, IAP)** | Sim | Sim (nativo) | Plugins | Sim | Sim (plugins) |
| **Migracao do Legado** | Facil (mesmo ecossistema) | Media | Media | Dificil | Dificil |

### 2.2 Recomendacao

#### Opcao 1 (Recomendada): **Godot 4.x**

**Justificativa:**
- Engine open-source, gratuita e sem royalties (MIT License)
- Excelente suporte a jogos 2D - e considerada a melhor engine 2D open-source
- GDScript e intuitivo e acessivel; tambem suporta C# para quem prefere
- APK pequeno ideal para jogos casuais infantis
- Export nativo para Android, Windows, Linux, macOS (Steam viavel)
- Comunidade em crescimento acelerado e muita documentacao
- Leve e rapido para iterar - ideal para projetos pequenos/medios
- Sistema de nodos intuitivo para organizar cenas
- Suporte a plugins para AdMob, Firebase Analytics, etc.

#### Opcao 2: **Cocos Creator 3.x**

**Justificativa:**
- Migracao mais facil vindo do Cocos Creator legado
- Conhecimento previo da engine reduz tempo de ramp-up
- Bom suporte 2D e APK pequeno
- **Porem:** comunidade menor fora da Asia e menos plugins disponiveis para monetizacao ocidental

#### Opcao 3: **Unity**

**Justificativa:**
- Maior ecossistema, maior asset store, mais tutoriais
- Excelente suporte para monetizacao (AdMob, Unity Ads, IAP)
- Suporte Steam robusto com Steamworks SDK nativo
- **Porem:** APK maior, runtime fee controverso (embora jogos pequenos estejam isentos), mais pesado para um jogo simples 2D

#### Nao Recomendado para este Projeto

- **Unreal Engine:** Overkill para jogos 2D casuais. Foco em 3D/AAA. APK enorme. Sem vantagem.
- **Flutter/Flame:** Bom para apps, mas o ecossistema de jogos ainda e imaturo. Limitado para efeitos visuais e animacoes elaboradas de jogo.

---

## 3. Plano de Modernizacao - Funcionalidades

### 3.1 Core Gameplay (MVP)

| Feature | Descricao | Prioridade |
|---------|-----------|------------|
| Niveis de dificuldade | Facil (6 cartas), Medio (12 cartas), Dificil (20 cartas) | Alta |
| Animacao de flip | Carta vira com animacao 3D-like ao ser tocada | Alta |
| Feedback visual | Efeito de brilho/particulas ao acertar par | Alta |
| Feedback de erro | Cartas tremem e voltam ao virar ao errar | Alta |
| Tela de vitoria | Animacao celebrativa com estrelas e confete ao completar | Alta |
| Sistema de estrelas | 1-3 estrelas baseado em tentativas/tempo | Alta |
| Timer visual | Cronometro amigavel (ex: ampulheta animada) | Media |
| Contador de tentativas | Mostra quantas jogadas o jogador fez | Media |

### 3.2 Progressao e Conteudo

| Feature | Descricao | Prioridade |
|---------|-----------|------------|
| Mapa de fases | Mapa visual com fases desbloqueaveis (estilo Candy Crush) | Alta |
| Temas de animais | Fazenda, Selva, Oceano, Artico - cada tema com animais proprios | Alta |
| Desbloqueio gradual | Novos temas e dificuldades desbloqueiam com progresso | Media |
| Album de figurinhas | Colecao de animais descobertos | Media |
| Recompensas diarias | Incentivo para o jogador voltar todo dia | Baixa |

### 3.3 Audio

| Feature | Descricao | Prioridade |
|---------|-----------|------------|
| Musica de fundo | Trilha sonora alegre e suave para cada tema | Alta |
| Som de flip | Efeito sonoro ao virar carta | Alta |
| Som de acerto | Efeito sonoro celebrativo ao encontrar par | Alta |
| Som de erro | Efeito sonoro suave (nao punitivo) ao errar | Alta |
| Nome do animal | Audio falando o nome do animal ao acertar o par (educativo) | Media |
| Opcao mudo | Botao para silenciar facilmente | Alta |

### 3.4 Monetizacao (Google Play)

| Estrategia | Descricao | Recomendacao |
|------------|-----------|--------------|
| Gratuito com anuncios | Anuncio intersticial entre fases (a cada 3-4 fases) | Recomendado |
| Compra para remover anuncios | IAP unico para versao sem anuncios | Recomendado |
| Pacotes de temas | Temas adicionais como IAP (~R$2,99-4,99) | Opcional |
| Versao Premium | Versao paga separada sem anuncios | Alternativa |

> **Importante:** Por se tratar de jogo infantil, seguir rigorosamente as politicas do Google Play para criancas (Designed for Families) e COPPA. Sem coleta de dados pessoais, sem anuncios direcionados, sem links externos diretos.

### 3.5 Tecnico

| Feature | Descricao | Prioridade |
|---------|-----------|------------|
| Save local | Salvar progresso localmente (SharedPreferences / arquivo) | Alta |
| Analytics | Firebase Analytics (eventos anonimos, COPPA compliant) | Media |
| Crash reporting | Firebase Crashlytics | Media |
| Responsividade | Suporte a diferentes resolucoes e aspect ratios | Alta |
| Acessibilidade | Fontes grandes, contraste alto, suporte a daltonismo | Media |
| Localizacao | Portugues (BR), Ingles, Espanhol como minimo | Media |

---

## 4. Melhorias de Design para Criancas

### 4.1 Faixa Etaria Alvo

Jogos de memoria sao mais populares entre criancas de **3 a 8 anos**. O design deve ser segmentado:

- **3-5 anos:** Modo facil com cartas grandes, poucos pares, cores vibrantes, feedback generoso
- **6-8 anos:** Modo medio/dificil, mais pares, timer opcional, sistema de estrelas motivacional

### 4.2 Paleta de Cores

| Elemento | Recomendacao |
|----------|-------------|
| Background | Gradientes suaves em tons pasteis (azul claro, verde menta, rosa suave) |
| Cartas (verso) | Cores vibrantes e saturadas com padrao divertido (estrelas, bolinhas) |
| Cartas (frente) | Fundo branco/claro para destacar o animal |
| Botoes | Grandes, arredondados, com cores primarias (amarelo, verde, azul) |
| Textos | Fonte arredondada/infantil (ex: Fredoka One, Baloo, Bubblegum Sans) |

### 4.3 Estilo Visual dos Animais

- **Estilo:** Cartoon arredondado, olhos grandes e expressivos, proporcoes "fofinhas" (cabeca grande, corpo pequeno)
- **Expressoes:** Todos os animais devem estar sorrindo ou com expressao amigavel
- **Consistencia:** Mesmo estilo artistico para todos os animais (contratar ilustrador ou usar pack consistente)
- **Resolucao:** Minimo 512x512 por animal para suportar telas de alta densidade (xxxhdpi)

### 4.4 Animacoes e Juice

| Animacao | Descricao |
|----------|-----------|
| Flip de carta | Rotacao 3D suave com ease-in-out (~0.3s) |
| Match encontrado | Cartas brilham, pulam e particulas coloridas explodem |
| Match errado | Cartas tremem suavemente e voltam com fade |
| Idle das cartas | Leve pulsacao/brilho nas cartas nao viradas (convida a clicar) |
| Tela de vitoria | Confete caindo, estrelas girando, animal(s) dancando |
| Transicao de tela | Slide suave ou fade com elemento tematico |
| Botoes | Escala ao pressionar (shrink to 90%, volta a 100%) |
| Estrelas | Aparecem uma a uma com efeito de brilho |

### 4.5 UX para Criancas

- **Botoes grandes** (minimo 48dp, ideal 64dp+ para criancas pequenas)
- **Sem texto obrigatorio** - usar icones e imagens para navegacao
- **Feedback imediato** - toda acao deve ter resposta visual/sonora
- **Sem punicao** - erros sao suaves, sem "game over" assustador
- **Mascote guia** - um animal amigavel que guia a crianca pelo jogo (ex: um macaquinho ou corujinha)
- **Area dos pais** - configuracoes atras de "gate" simples (ex: segurar botao por 3s ou resolver conta matematica) para evitar compras acidentais
- **Sem contagem regressiva estressante** - timer deve ser opcional e visual (ampulheta, nao numeros)

### 4.6 Novos Temas Sugeridos de Animais

| Tema | Animais | Cores do Tema |
|------|---------|---------------|
| **Fazenda** | Vaca, Porco, Galinha, Cavalo, Ovelha, Gato, Cachorro, Pato | Verde, Amarelo, Marrom |
| **Selva** | Leao, Macaco, Elefante, Girafa, Zebra, Tucano, Cobra, Hipopotamo | Verde escuro, Laranja |
| **Oceano** | Baleia, Golfinho, Polvo, Tartaruga, Peixe-palhaco, Cavalo-marinho, Estrela-do-mar, Caranguejo | Azul, Turquesa |
| **Artico** | Pinguim, Urso Polar, Foca, Morsa, Coruja-das-neves, Raposa Artica, Alce, Rena | Branco, Azul claro |
| **Insetos** | Borboleta, Joaninha, Abelha, Formiga, Libelula, Grilo, Caracol, Lagarta | Verde claro, Rosa |
| **Dinossauros** | T-Rex, Triceratops, Braquiossauro, Estegossauro, Pterodatilo, Anquilossauro | Laranja, Roxo |

---

## 5. Avaliacao - Versao Steam

### 5.1 Viabilidade

| Aspecto | Avaliacao |
|---------|-----------|
| **Mercado** | Jogos educativos infantis existem na Steam, mas o publico principal da Steam e adulto/adolescente |
| **Concorrencia** | Menor concorrencia que Google Play para este nicho |
| **Preco** | Jogos casuais infantis vendem entre $0.99 - $4.99 na Steam |
| **Custo de entrada** | Taxa unica de $100 USD para publicar na Steam |
| **Esforco adicional** | Baixo se a engine escolhida ja exporta para desktop (Godot, Unity) |
| **Adaptacoes** | Trocar touch por mouse/teclado, ajustar resolucao para landscape |

### 5.2 Conclusao sobre Steam

**Faz sentido como objetivo secundario**, desde que:

1. A engine escolhida ja suporte export desktop (Godot e Unity suportam nativamente)
2. O jogo tenha conteudo suficiente para justificar (minimo 4-5 temas, 30+ fases)
3. Seja vendido como versao premium (sem anuncios) por $1.99-$2.99
4. Adicione suporte a mouse/teclado e resolucoes widescreen (16:9)
5. Adicione conquistas Steam (Achievements) para engajamento
6. **Nao desvie foco do lancamento Android** - Steam deve ser feito apenas apos a versao Android estar estavel

### 5.3 Adaptacoes Necessarias para Steam

- Layout responsivo (portrait mobile -> landscape desktop, ou suporte a ambos)
- Controles: mouse click como input primario, atalhos de teclado opcionais
- Resolucao minima: 1280x720 (Steam requer)
- Integra cao com Steamworks SDK (achievements, cloud saves)
- Screenshots e trailer para pagina da loja Steam
- Suporte a controle (gamepad) e desejavel
- Trading cards do Steam sao um bonus para engajamento

---

## 6. Roadmap Sugerido

### Fase 1 - MVP Android (8-12 semanas)

- [ ] Setup do projeto na engine escolhida
- [ ] Tela inicial com menu e mascote
- [ ] Mecanica core: flip, match, embaralhamento
- [ ] 1 tema completo (Fazenda) com 8 animais novos em alta resolucao
- [ ] 3 niveis de dificuldade (Facil/Medio/Dificil)
- [ ] Animacoes de flip, match e erro
- [ ] Tela de vitoria com estrelas
- [ ] Efeitos sonoros e musica de fundo
- [ ] Save local do progresso
- [ ] Teste em multiplos dispositivos Android

### Fase 2 - Lancamento Google Play (4-6 semanas)

- [ ] Mapa de fases com progressao
- [ ] +2 temas (Selva, Oceano)
- [ ] Integracao AdMob (intersticiais entre fases)
- [ ] IAP para remover anuncios
- [ ] Firebase Analytics + Crashlytics (COPPA compliant)
- [ ] Localizacao PT-BR e EN
- [ ] Compliance com politicas "Designed for Families"
- [ ] Screenshots, icone, descricao para a loja
- [ ] Publicacao na Google Play

### Fase 3 - Expansao (4-6 semanas)

- [ ] +3 temas (Artico, Insetos, Dinossauros)
- [ ] Album de figurinhas / colecao
- [ ] Audio educativo (nome dos animais)
- [ ] Recompensas diarias
- [ ] Acessibilidade (modo daltonico, fontes grandes)
- [ ] Localizacao ES

### Fase 4 - Steam (4 semanas)

- [ ] Adaptacao de layout para landscape/desktop
- [ ] Controles mouse + teclado + gamepad
- [ ] Integracao Steamworks (achievements, cloud save)
- [ ] Build e teste Windows/Linux/macOS
- [ ] Pagina da loja, screenshots, trailer
- [ ] Publicacao na Steam

---

## 7. Resumo Executivo

O **Memory Kids Animal** legado e um prototipo funcional basico construido em Cocos Creator JS, com mecanica de jogo core implementada, mas carente de polish visual, audio, progressao e monetizacao. A modernizacao deve focar em transformar esse prototipo em um produto completo e polido para o publico infantil de 3-8 anos na Google Play.

**Engine recomendada:** Godot 4.x (gratuita, otima para 2D, APK pequeno, export multiplataforma)

**Diferenciais-chave para competir:**
1. Arte de alta qualidade com estilo cartoon fofo e consistente
2. Feedback visual e sonoro generoso (juice)
3. Progressao motivacional com temas desbloqueaveis
4. Componente educativo (nomes dos animais em audio)
5. UX cuidadosa para criancas (sem frustracoes, sem armadilhas de compra)

**Steam:** Viavel como objetivo secundario apos Android estar consolidado. Esforco incremental baixo se Godot ou Unity for a engine escolhida.
