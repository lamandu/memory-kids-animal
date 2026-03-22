# Setup, Teste Local e Publicacao

## 1. Primeiro Uso — Abrir o Projeto no Godot

O Godot 4.6.1 foi instalado. **Abra um novo terminal** (ou reinicie o VSCode) para que o PATH seja atualizado.

```bash
# Verificar se o godot esta no PATH (novo terminal)
godot --version

# Abrir o projeto diretamente
godot "d:/workspaces/workspacePortifolio/memory-kids-animal/project.godot"
```

Ao abrir pela primeira vez, o Godot vai:
1. Importar os assets (animais PNG, icon.svg)
2. Criar a pasta `.godot/` (gerada automaticamente, ja no .gitignore)
3. Mostrar o projeto pronto para rodar

**Para rodar no desktop:** pressione `F5` ou clique no botao ▶ Play no editor.

---

## 2. Estrutura do Projeto

```
memory-kids-animal/
├── project.godot          # Configuracao principal (viewport 720x1280, portrait)
├── assets/
│   ├── icon.svg           # Icone do app
│   └── animals/           # 11 PNGs copiados do projeto legado
├── scenes/
│   ├── Splash.tscn        # Tela de abertura (fade in/out)
│   ├── Menu.tscn          # Menu com selecao de dificuldade
│   ├── Game.tscn          # Jogo principal
│   ├── Victory.tscn       # Tela de vitoria com estrelas
│   └── components/
│       └── Card.tscn      # Prefab da carta (instanciado em Game.gd)
└── scripts/
    ├── Global.gd           # Autoload — estado global e configuracoes
    ├── Splash.gd           # Logica da tela splash
    ├── Menu.gd             # Menu e selecao de dificuldade
    ├── Game.gd             # Logica do jogo (grid, flip, match)
    ├── Card.gd             # Comportamento da carta (animacoes, input)
    └── Victory.gd          # Tela de vitoria e animacao de estrelas
```

---

## 3. Configurar Android Export

### 3.1 Pre-requisitos ja instalados

| Ferramenta | Status |
|------------|--------|
| Godot 4.6.1 | ✅ Instalado via winget |
| OpenJDK 17 | ✅ Instalado via winget |
| Android SDK | ❌ Precisa instalar |

### 3.2 Instalar Android SDK

**Opcao A (recomendada): Android Studio**
1. Baixe em developer.android.com/studio
2. Durante a instalacao, o Android SDK e instalado automaticamente
3. Caminho padrao: `C:\Users\%USERNAME%\AppData\Local\Android\Sdk`

**Opcao B: Command Line Tools apenas**
```bash
# Via winget
winget install Google.AndroidStudio
# Ou so as command line tools pelo site
```

### 3.3 Instalar Export Templates no Godot

1. Abra o Godot
2. Menu `Editor > Manage Export Templates`
3. Clique em `Download and Install`
4. Aguarde o download (~500MB)

### 3.4 Configurar JDK no Godot Editor

1. Menu `Editor > Editor Settings`
2. Busque por "java"
3. Em `Export > Android > Java SDK Path`, aponte para:
   `C:\Program Files\Microsoft\jdk-17.0.18.8-hotspot`

### 3.5 Configurar Android SDK no Godot

1. Menu `Editor > Editor Settings`
2. Busque por "android"
3. Em `Export > Android > Android SDK Path`, aponte para:
   `C:\Users\SEU_USUARIO\AppData\Local\Android\Sdk`

### 3.6 Criar Export Preset Android

1. Menu `Project > Export`
2. Clique em `Add...` > `Android`
3. Preencha:
   - **Package:** `com.ricardosouza.memorykidsanimal`
   - **Version Code:** `1`
   - **Version Name:** `1.0.0`
   - **Min SDK:** `21` (Android 5.0+)
   - **Target SDK:** `34` (Android 14)
4. Aba `Architectures`: marque `arm64-v8a` e `armeabi-v7a`

### 3.7 Criar Keystore de Assinatura

```bash
# Gerar keystore (necessario uma vez)
keytool -genkey -v \
  -keystore memory-kids-animal.keystore \
  -alias memorykids \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000
```

Guarde o keystore e a senha em local seguro. **Sem ele nao e possivel atualizar o app na Play Store.**

No Godot Export > Android:
- **Keystore (Release):** caminho do .keystore
- **Keystore User (Release):** `memorykids`
- **Keystore Password (Release):** sua senha

### 3.8 Gerar APK / AAB

```bash
# Via linha de comando (apos configurar tudo no editor)
godot --export-release "Android" memory-kids-animal.apk

# Para Google Play, gerar .aab (recomendado)
godot --export-release "Android" memory-kids-animal.aab
```

Ou pelo editor: `Project > Export > Export Project`

---

## 4. Testar no Dispositivo Android

### Conexao via USB (ADB)

```bash
# Ativar USB Debugging no celular: Configuracoes > Dev Options > USB Debugging

# Verificar conexao
adb devices

# Instalar APK no dispositivo
adb install memory-kids-animal.apk

# Ver logs em tempo real
adb logcat -s "Godot"
```

### Wireless ADB (Android 11+)

1. Celular: Configuracoes > Dev Options > Wireless Debugging
2. `adb pair IP:porta` → digitar o codigo
3. `adb connect IP:porta`

---

## 5. Publicar na Google Play

### 5.1 Criar Conta de Desenvolvedor

- Acesse play.google.com/console
- Taxa unica: **USD 25**

### 5.2 Criar o App

1. Play Console > `Criar app`
2. Preencher informacoes basicas, categoria (Educacao/Criancas)
3. Marcar como **app para criancas** (Designed for Families)

### 5.3 Compliance COPPA / Designed for Families

Para app infantil na Play Store, obrigatorio:
- [ ] Sem anuncios direcionados por dados
- [ ] Se usar AdMob: configurar `COPPA Tag for Children`
- [ ] Sem coleta de dados pessoais identificaveis
- [ ] Sem links externos visiveis para criancas
- [ ] Formulario de privacidade obrigatorio

### 5.4 Preparar Assets da Loja

| Asset | Tamanho | Obrigatorio |
|-------|---------|-------------|
| Icone | 512x512 PNG | Sim |
| Feature Graphic | 1024x500 PNG | Sim |
| Screenshots (phone) | min 2, 320-3840px | Sim |
| Screenshots (tablet 7") | min 1 | Recomendado |
| Descricao curta | max 80 chars | Sim |
| Descricao longa | max 4000 chars | Sim |
| Video promocional | YouTube URL | Opcional |

### 5.5 Upload e Review

```
.aab → Play Console → Testes internos → Testes abertos → Producao
```

O processo de revisao leva de 1-7 dias (apps infantis podem levar mais).

---

## 6. Publicar na Steam (pos-Android)

### 6.1 Pre-requisitos

- Conta Steam com `Steamworks` ativo
- Taxa: **USD 100 por jogo**
- `godot-steam` plugin ou `GodotSteam` addon

### 6.2 Adaptar o Projeto para Desktop

No [project.godot](../project.godot), adicionar preset desktop:

```ini
[display]
window/size/viewport_width=720
window/size/viewport_height=1280
window/stretch/mode="canvas_items"
window/stretch/aspect="keep"

# Para Steam, janela redimensionavel
window/size/resizable=true
window/size/min_width=360
window/size/min_height=640
```

### 6.3 Adicionar GodotSteam

```bash
# Baixar GodotSteam (versao compativel com Godot 4.6)
# github.com/GodotSteam/GodotSteam

# Ou usar como addon (sem necessidade de recompilar Godot)
# Colocar em: addons/godotsteam/
```

### 6.4 Export Presets para Steam

1. Windows: `Project > Export > Add > Windows Desktop`
2. Linux: `Project > Export > Add > Linux/X11`
3. macOS: `Project > Export > Add > macOS`

```bash
# Build para Windows
godot --export-release "Windows Desktop" "builds/memory-kids-steam-win64.exe"

# Build para Linux
godot --export-release "Linux/X11" "builds/memory-kids-steam-linux.x86_64"
```

---

## 7. Automacao com Fastlane (opcional, pos-MVP)

Para deploy automatico na Google Play:

```bash
# Instalar fastlane
gem install fastlane

# Na pasta do projeto Android build:
fastlane init

# Fastfile de exemplo:
# lane :deploy do
#   upload_to_play_store(
#     track: 'internal',
#     aab: 'memory-kids-animal.aab',
#     json_key: 'play-store-key.json'
#   )
# end
```

---

## 8. Proximos Passos do Desenvolvimento

### Fase 1 (MVP atual - implementado)
- [x] Tela splash com fade
- [x] Menu com selecao de dificuldade (Facil/Medio/Dificil)
- [x] Jogo de memoria com grid responsivo
- [x] Animacao de flip das cartas
- [x] Feedback de acerto (verde + escala)
- [x] Feedback de erro (tremida)
- [x] Sistema de estrelas (1-3 baseado em tentativas)
- [x] Tela de vitoria com animacao de estrelas

### Fase 2 (Lancamento)
- [ ] Adicionar efeitos sonoros (flip, acerto, erro, vitoria)
- [ ] Adicionar musica de fundo
- [ ] Botao mudo
- [ ] Arte nova dos animais (estilo cartoon kids)
- [ ] Temas de fundo por dificuldade
- [ ] Integracao AdMob (ads entre partidas)
- [ ] IAP — remover anuncios

### Fase 3 (Expansao)
- [ ] Novos temas (Selva, Oceano, Dinossauros)
- [ ] Mapa de fases
- [ ] Album de animais descobertos
- [ ] Localizacao EN/ES
- [ ] Firebase Analytics (COPPA compliant)
