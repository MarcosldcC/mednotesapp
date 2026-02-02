# MedNotes — Telas e funcionalidades

Documentação de cada tela do app: propósito, funcionalidades principais e navegação. Útil para onboarding, testes e alinhamento com o backend.

---

## Índice por fluxo

1. [Inicial e autenticação](#1-inicial-e-autenticação)
2. [Dashboard e navegação principal](#2-dashboard-e-navegação-principal)
3. [Perfil e conta](#3-perfil-e-conta)
4. [Algoritmos clínicos](#4-algoritmos-clínicos)
5. [Modo plantão (simulação)](#5-modo-plantão-simulação)
6. [Marketplace e produtos](#6-marketplace-e-produtos)
7. [Planos e pagamento](#7-planos-e-pagamento)
8. [Progresso e carreira](#8-progresso-e-carreira)
9. [Notificações, chat e suporte](#9-notificações-chat-e-suporte)
10. [Configurações e conteúdo institucional](#10-configurações-e-conteúdo-institucional)

---

## 1. Inicial e autenticação

### Splash Screen
- **Arquivo:** `splash_screen.dart`
- **Propósito:** Tela inicial ao abrir o app; exibe logo e prepara o contexto.
- **Funcionalidade:** Exibe imagem do logo (logomednotes.png), aguarda ~2 segundos e navega para a **Welcome Screen**.
- **Navegação:** Sempre → Welcome Screen.

### Welcome Screen
- **Arquivo:** `welcome_screen.dart`
- **Propósito:** Primeira tela de interação; convida a entrar ou criar conta.
- **Funcionalidade:** Layout com fundo verde, ilustração (medica.png), card inferior com botões "Entrar" e "Criar conta". Suporte a arraste do card (animação).
- **Navegação:** "Entrar" → Login Screen; "Criar conta" → Register Screen.

### Login Screen
- **Arquivo:** `login_screen.dart`
- **Propósito:** Autenticação por e-mail e senha.
- **Funcionalidade:** Formulário com e-mail e senha; link "Esqueci minha senha"; link para Registrar. Validação de campos. Ao submeter (sem backend) navega para Dashboard.
- **Navegação:** Sucesso → Dashboard; "Criar conta" → Register Screen; "Esqueci minha senha" → fluxo de recuperação (telas existentes).

### Register Screen
- **Arquivo:** `register_screen.dart`
- **Propósito:** Cadastro de novo usuário.
- **Funcionalidade:** Campos: nome, sobrenome, e-mail, senha, confirmar senha; checkbox de aceite dos termos. Regras de senha (mínimo 8 caracteres, maiúscula, minúscula, número, caractere especial). Validação em tempo real. Botão "Cadastrar".
- **Navegação:** Sucesso → Verify Account Screen; link "Já tenho conta" → Login Screen.

### Verify Account Screen
- **Arquivo:** `verify_account_screen.dart`
- **Propósito:** Verificação de e-mail após cadastro (código enviado por e-mail).
- **Funcionalidade:** Campo para código de verificação; botão reenviar código; botão confirmar.
- **Navegação:** Sucesso → Choose Plan Screen (ou Login/Dashboard conforme fluxo de negócio).

### Verify Code Screen
- **Arquivo:** `verify_code_screen.dart`
- **Propósito:** Inserir código recebido (ex.: recuperação de senha ou confirmação).
- **Funcionalidade:** Campos para código; confirmação.
- **Navegação:** Sucesso → tela de destino conforme contexto (ex.: Change Password ou Dashboard).

### Change Password Screen
- **Arquivo:** `change_password_screen.dart`
- **Propósito:** Alterar senha (logado) ou definir nova senha após recuperação.
- **Funcionalidade:** Campos: senha atual (se logado), nova senha, confirmar nova senha. Mesmas regras de senha do registro.
- **Navegação:** Sucesso → volta ou View Account / Dashboard.

---

## 2. Dashboard e navegação principal

### Dashboard Screen
- **Arquivo:** `dashboard_screen.dart`
- **Propósito:** Tela principal após login; resumo do usuário e atalhos.
- **Funcionalidade:**
  - Header com avatar, logo e ícone de notificações (abre Notifications Screen).
  - Card de **nível de performance** (tier, pontos) com botão "Ver Mais" → Progress Screen.
  - Saudação "Olá [nome]!" e subtítulo.
  - Barra de busca (placeholder para buscar sintoma/protocolo).
  - **Ações rápidas:** cards para Algoritmos Clínicos, Modo Plantão, Marketplace (e opcional Modo Eco).
  - Seção **Modo Eco** (se ativo): card informativo com link para Eco Mode Screen.
  - Seção **Protocolos Recentes:** lista dos algoritmos salvos (até 5); toque abre Algorithm Detail. Se vazio, mostra "Nenhum protocolo recente".
  - Drawer (menu lateral) = Profile Menu Screen.
  - Bottom bar e FAB de chat (abrem respectivamente telas da navegação principal e Chat Screen).
- **Navegação:** Algoritmos → Clinical Algorithms; Modo Plantão → On Call Mode; Marketplace → Marketplace Screen; Progresso → Progress Screen; Notificações → Notifications Screen; Chat (FAB) → Chat Screen; drawer → Profile Menu.

### Profile Menu Screen (Drawer)
- **Arquivo:** `profile_menu_screen.dart`
- **Propósito:** Menu lateral acessível em várias telas (drawer).
- **Funcionalidade:** Lista de opções:
  - **Sua conta:** Visualizar Conta → View Account; Ver Progresso → Progress Screen.
  - **Notificações:** switches para Alertas Epidemiológicos e Notificações Push (SettingsService).
  - **Acessibilidade:** Tamanho do Texto (dialog com slider), Alto Contraste, Modo Eco (switches).
  - **Suporte e Informações:** Política e Privacidade → Privacy Policy; Central de Ajuda → Help Center; Termos de Uso → Terms of Use.
  - **Sair da Conta:** diálogo de confirmação; ao confirmar → Login Screen (limpa stack).
- **Navegação:** Cada item leva à tela indicada; drawer fecha ao escolher.

---

## 3. Perfil e conta

### View Account Screen
- **Arquivo:** `view_account_screen.dart`
- **Propósito:** Visualizar dados da conta e acessar ações.
- **Funcionalidade:** Exibe nome, e-mail, foto (medica.png placeholder); botões/links para Editar Perfil, Alterar Senha, Gerenciar Assinatura, Central de Ajuda.
- **Navegação:** Editar Perfil → Edit Profile; Alterar Senha → Change Password; Gerenciar Assinatura → Subscription Management; Central de Ajuda → Help Center.

### Edit Profile Screen
- **Arquivo:** `edit_profile_screen.dart`
- **Propósito:** Editar dados pessoais e foto.
- **Funcionalidade:** Foto de perfil (avatar) com botão de edição; campos: Nome, Telefone, E-mail, UF (dropdown). Botão Salvar; detecta alterações para habilitar salvar. Valores iniciais vêm de AppConstants (sem backend).
- **Navegação:** Salvar → volta; Cancelar/Voltar → volta.

### Customize Profile Screen
- **Arquivo:** `customize_profile_screen.dart`
- **Propósito:** Personalizar perfil (ex.: áreas de interesse, preferências de estudo).
- **Funcionalidade:** Conteúdo de customização; ao concluir pode redirecionar para Dashboard.
- **Navegação:** Concluir → Dashboard (pushAndRemoveUntil).

### Profile Selection Screen
- **Arquivo:** `profile_selection_screen.dart`
- **Propósito:** Escolher tipo de perfil (ex.: médico residente, especialista) no fluxo pós-pagamento.
- **Funcionalidade:** Cards ou opções de perfil; seleção e continuação do fluxo.
- **Navegação:** Próximo → Location Selection Screen.

### Location Selection Screen
- **Arquivo:** `location_selection_screen.dart`
- **Propósito:** Seleção de localização (estado/região).
- **Funcionalidade:** Lista ou mapa para escolher UF/região.
- **Navegação:** Próximo → Interest Areas Screen.

### Interest Areas Screen
- **Arquivo:** `interest_areas_screen.dart`
- **Propósito:** Escolher áreas de interesse (ex.: cardiologia, emergência).
- **Funcionalidade:** Lista de áreas com seleção múltipla.
- **Navegação:** Próximo → Study Preferences Screen.

### Study Preferences Screen
- **Arquivo:** `study_preferences_screen.dart`
- **Propósito:** Definir preferências de estudo.
- **Funcionalidade:** Opções de preferência; botão concluir.
- **Navegação:** Concluir → Dashboard (replace).

---

## 4. Algoritmos clínicos

### Clinical Algorithms Screen
- **Arquivo:** `clinical_algorithms_screen.dart`
- **Propósito:** Listar algoritmos/protocolos clínicos para busca e acesso.
- **Funcionalidade:** Título "Algoritmos Clínicos"; barra de busca; botão de filtro (ícone tune); chips de categoria (Todos, Dor torácica, Hipertensão). Lista de cards com título, subtítulo e "timeAgo". Toque no card abre o detalhe.
- **Navegação:** Card → Algorithm Detail Screen (com algorithmTitle); Voltar → tela anterior.

### Algorithm Detail Screen
- **Arquivo:** `algorithm_detail_screen.dart`
- **Propósito:** Exibir detalhes do algoritmo: fluxograma e flashcards.
- **Funcionalidade:** Título do algoritmo; botões **Exportar PDF** (mensagem "em desenvolvimento"), **Salvar** (adiciona ao RecentProtocolsProvider e aparece em Protocolos Recentes no Dashboard), **Simular Caso** (→ Simulation Case Selection). Fluxograma de decisão (passos e ramos). Lista de flashcards (pergunta/resposta). Bottom bar e FAB de chat.
- **Navegação:** Salvar → atualiza dashboard; Simular Caso → Simulation Case Selection Screen; Voltar → volta.

---

## 5. Modo plantão (simulação)

### On Call Mode Screen
- **Arquivo:** `on_call_mode_screen.dart`
- **Propósito:** Entrada do modo simulação de plantão; explicação e início.
- **Funcionalidade:** Apresentação do modo plantão; botão para iniciar simulação. Ao iniciar, navega para On Call Simulation Screen.
- **Navegação:** Iniciar → On Call Simulation Screen.

### On Call Simulation Screen
- **Arquivo:** `on_call_simulation_screen.dart`
- **Propósito:** Simulação cronometrada com múltiplas etapas (telas 2 a 6).
- **Funcionalidade:** Cronômetro; barra de progresso; conteúdo por etapa (RCP, ritmo, via aérea, reavaliação, causas reversíveis) com pergunta e opções; feedback correto/erro; vidas (3). Ao concluir ou esgotar tempo/vidas → On Call Simulation Completed Screen. Bottom bar com confirmação ao sair.
- **Navegação:** Concluir/Perder → On Call Simulation Completed Screen; Sair (confirmado) → On Call Mode Screen ou Dashboard.

### On Call Simulation Completed Screen
- **Arquivo:** `on_call_simulation_completed_screen.dart`
- **Propósito:** Tela de conclusão da simulação com pontuação.
- **Funcionalidade:** Mensagem de conclusão; pontos concedidos (pointsAwarded, ex.: 10); atualiza UserCareerProvider (addPoints). Botões para "Modo Plantão" novamente ou "Início" (Dashboard).
- **Navegação:** Modo Plantão → On Call Mode Screen; Início → Dashboard (pushAndRemoveUntil).

### Simulation Case Selection Screen
- **Arquivo:** `simulation_case_selection_screen.dart`
- **Propósito:** Escolher paciente/caso para simulação de atendimento (fluxo alternativo ao modo plantão).
- **Funcionalidade:** Lista de casos mock (nome, idade, sintoma, histórico, medicação). Toque no card inicia o fluxo de simulação (triagem, etc.).
- **Navegação:** Card do paciente → Simulation Triage Screen (ou primeira tela do fluxo do caso).

### Simulation Triage Screen
- **Arquivo:** `simulation_triage_screen.dart`
- **Propósito:** Etapa de triagem do caso selecionado.
- **Funcionalidade:** Informações do paciente; perguntas/opções de triagem; navegação para próximas etapas ou saída (com confirmação).
- **Navegação:** Próximo → telas seguintes do fluxo (ex.: Blood Pressure, Classification, etc.); Sair → Simulation Case Selection ou Dashboard.

### Simulation Blood Pressure Screen
- **Arquivo:** `simulation_blood_pressure_screen.dart`
- **Propósito:** Etapa de decisão sobre pressão arterial no caso.
- **Funcionalidade:** Conteúdo clínico; múltipla escolha; feedback; próxima etapa ou conclusão.
- **Navegação:** Próximo/Sair → conforme fluxo (outras simulações ou Case Selection).

### Simulation Cardiovascular Risk Screen
- **Arquivo:** `simulation_cardiovascular_risk_screen.dart`
- **Propósito:** Etapa de avaliação de risco cardiovascular.
- **Funcionalidade:** Perguntas e opções; feedback correto/erro.
- **Navegação:** Próximo/Sair → próximo passo ou Case Selection.

### Simulation Classification Screen
- **Arquivo:** `simulation_classification_screen.dart`
- **Propósito:** Etapa de classificação clínica.
- **Funcionalidade:** Perguntas e opções; feedback.
- **Navegação:** Próximo/Sair → próximo passo ou Case Selection.

### Simulation Medication Choice Screen
- **Arquivo:** `simulation_medication_choice_screen.dart`
- **Propósito:** Etapa de escolha de medicação.
- **Funcionalidade:** Opções de medicação; feedback.
- **Navegação:** Próximo/Sair → próximo passo ou Case Selection.

### Simulation Therapeutic Decision Screen
- **Arquivo:** `simulation_therapeutic_decision_screen.dart`
- **Propósito:** Etapa de decisão terapêutica.
- **Funcionalidade:** Perguntas e opções; feedback.
- **Navegação:** Próximo/Sair → próximo passo ou Case Selection.

### Simulation Non Pharmacological Screen
- **Arquivo:** `simulation_non_pharmacological_screen.dart`
- **Propósito:** Etapa de medidas não farmacológicas.
- **Funcionalidade:** Conteúdo e opções; botão "Prosseguir" que leva à tela de conclusão da simulação.
- **Navegação:** Prosseguir → On Call Simulation Completed Screen; Sair → Case Selection ou Dashboard.

---

## 6. Marketplace e produtos

### Marketplace Screen
- **Arquivo:** `marketplace_screen.dart`
- **Propósito:** Listar e filtrar produtos (cursos, livros, itens).
- **Funcionalidade:** Título e subtítulo; barra de busca; filtro (categoria, preço) via dialog. Categorias em cards (Livros, Cursos, Itens) → Category Products Screen. Seção "Em destaque" com "Ver todos" → Category Products (category: Todas). Lista de produtos em destaque (até 3); toque no produto → Product Detail. Drawer e bottom bar.
- **Navegação:** Categoria → Category Products Screen; Ver todos → Category Products (Todas); Produto → Product Detail Screen.

### Category Products Screen
- **Arquivo:** `category_products_screen.dart`
- **Propósito:** Listar produtos por categoria ou "Todos os produtos".
- **Funcionalidade:** Recebe parâmetro `category` (Livros, Cursos, Itens ou Todas). Título dinâmico ("Todos os produtos" se Todas). Busca e filtro de preço. Lista de produtos; toque → Product Detail.
- **Navegação:** Produto → Product Detail Screen; Voltar → volta.

### Product Detail Screen
- **Arquivo:** `product_detail_screen.dart`
- **Propósito:** Detalhes do produto e ação de adquirir.
- **Funcionalidade:** Exibe título, descrição, preço, avaliação, categoria; botão/comportamento de aquisição (sem backend). Drawer.
- **Navegação:** Voltar → volta; Adquirir → fluxo de pagamento (quando houver backend).

---

## 7. Planos e pagamento

### Choose Plan Screen
- **Arquivo:** `choose_plan_screen.dart`
- **Propósito:** Escolher plano de assinatura (mensal/anual) e iniciar pagamento.
- **Funcionalidade:** Toggle mensal/anual; cards de planos (ex.: Premium, Institucional) com preço e benefícios; imagens (premium.png, institucional.png). Botão para continuar → Payment Method Registration ou Dashboard (conforme fluxo).
- **Navegação:** Continuar com plano → Payment Method Registration Screen ou fluxo de pagamento; pode ir para Dashboard após sucesso.

### Payment Method Registration Screen
- **Arquivo:** `payment_method_registration_screen.dart`
- **Propósito:** Cadastrar método de pagamento (cartão).
- **Funcionalidade:** Campos para dados do cartão; opção "Adicionar cartão" que abre Add Card Registration Screen. Lista de cartões salvos (se houver).
- **Navegação:** Adicionar cartão → Add Card Registration Screen; Concluir → Payment Success ou próximo passo.

### Add Card Registration Screen
- **Arquivo:** `add_card_registration_screen.dart`
- **Propósito:** Formulário para cadastrar novo cartão (usuário não logado ou primeiro cartão).
- **Funcionalidade:** Campos de cartão (número, validade, CVV, nome); validação; salvar (mock/local).
- **Navegação:** Salvar/Voltar → volta (ex.: Payment Method Registration).

### Add Card Logged Screen
- **Arquivo:** `add_card_logged_screen.dart`
- **Propósito:** Adicionar cartão quando o usuário já está logado (ex.: Gerenciar Assinatura).
- **Funcionalidade:** Formulário de cartão; salvar.
- **Navegação:** Salvar/Voltar → volta (ex.: Subscription Management).

### Payment Success Screen
- **Arquivo:** `payment_success_screen.dart`
- **Propósito:** Confirmação visual de pagamento concluído.
- **Funcionalidade:** Mensagem de sucesso; botão para continuar → Profile Selection Screen (fluxo pós-pagamento).
- **Navegação:** Continuar → Profile Selection Screen.

### Review Data Screen
- **Arquivo:** `review_data_screen.dart`
- **Propósito:** Revisar dados antes de confirmar compra/assinatura.
- **Funcionalidade:** Resumo dos dados; botão confirmar → Payment Success.
- **Navegação:** Confirmar → Payment Success Screen.

### Subscription Management Screen
- **Arquivo:** `subscription_management_screen.dart`
- **Propósito:** Gerenciar assinatura e cartões.
- **Funcionalidade:** Ver plano atual; gerenciar pagamento; adicionar cartão → Add Card Logged Screen; alterar plano ou cancelar (conforme UI).
- **Navegação:** Adicionar cartão → Add Card Logged Screen; outros links conforme opções.

---

## 8. Progresso e carreira

### Progress Screen
- **Arquivo:** `progress_screen.dart`
- **Propósito:** Ver progresso da carreira (nível, pontos) e conquistas.
- **Funcionalidade:** Abas (ex.: Conquistas, Detalhes). Exibe nível atual (CareerLevel), pontos no tier (0–100), barra de progresso. Ranking por tier; toque no ranking → Rank Detail Screen. Conquistas em carrossel. Dados do UserCareerProvider e CareerProgressService.
- **Navegação:** Ranking → Rank Detail Screen; Voltar → volta.

### Rank Detail Screen
- **Arquivo:** `rank_detail_screen.dart`
- **Propósito:** Detalhe do ranking do tier (lista de usuários com posição e pontos).
- **Funcionalidade:** Título/subtítulo do ranking; lista de RankEntry (nome, pontos, posição); destaque para o usuário atual (isUser). Suporta ranking por tier (levelIndex + points) ou legado (exp).
- **Navegação:** Voltar → Progress Screen.

---

## 9. Notificações, chat e suporte

### Notifications Screen
- **Arquivo:** `notifications_screen.dart`
- **Propósito:** Listar notificações do usuário.
- **Funcionalidade:** Lista de itens com título, mensagem, data/hora e estado "lido/não lido". Placeholder com 3 itens mock. Bottom bar com navegação (Dashboard, etc.).
- **Navegação:** Voltar/Home → Dashboard (pushAndRemoveUntil).

### Chat Screen
- **Arquivo:** `chat_screen.dart`
- **Propósito:** Hub de chat (lista de conversas ou abas).
- **Funcionalidade:** Três abas/páginas (ex.: conversas diferentes); gesto de arraste para trocar; header com logo (logomednotes.png). Toque em conversa → Chat Conversation Screen.
- **Navegação:** Conversa → Chat Conversation Screen; Drawer → Profile Menu.

### Chat Conversation Screen
- **Arquivo:** `chat_conversation_screen.dart`
- **Propósito:** Conversa com suporte/assistência (mensagens).
- **Funcionalidade:** Lista de mensagens (vazia ou mock); campo para digitar e enviar; scroll automático. Header com voltar e título.
- **Navegação:** Voltar → Chat Screen; enviar mensagem → (backend) adiciona mensagem na lista.

### Help Center Screen
- **Arquivo:** `help_center_screen.dart`
- **Propósito:** Central de ajuda com FAQ e envio de dúvida.
- **Funcionalidade:** Busca e filtro por categoria (Todos, Conta, Plano, Suporte). Lista de FAQs (pergunta, resposta). Campo para enviar mensagem/dúvida ao suporte.
- **Navegação:** Voltar → volta (View Account ou Profile Menu).

### Privacy Policy Screen
- **Arquivo:** `privacy_policy_screen.dart`
- **Propósito:** Exibir política de privacidade (conteúdo institucional).
- **Funcionalidade:** Título "Política e Privacidade"; texto em scroll (conteúdo fixo ou carregado).
- **Navegação:** Voltar → volta.

### Terms of Use Screen
- **Arquivo:** `terms_of_use_screen.dart`
- **Propósito:** Exibir termos de uso (conteúdo institucional).
- **Funcionalidade:** Título "Termos de Uso"; texto em scroll.
- **Navegação:** Voltar → volta.

---

## 10. Configurações e conteúdo institucional

### Eco Mode Screen
- **Arquivo:** `eco_mode_screen.dart`
- **Propósito:** Explicar e gerenciar o Modo Eco (redução de animações e consumo).
- **Funcionalidade:** Descrição do modo; toggle ou link para ativar/desativar (SettingsService.ecoModeEnabled).
- **Navegação:** Voltar → Dashboard ou tela de origem.

### Real Time Health Screen
- **Arquivo:** `real_time_health_screen.dart`
- **Propósito:** Módulo "Saúde em tempo real" (acessível pelo ícone de coração na bottom bar).
- **Funcionalidade:** Conteúdo informativo ou funcionalidade de saúde; link para Trending News Screen.
- **Navegação:** Notícias/trending → Trending News Screen; Voltar → volta.

### Trending News Screen
- **Arquivo:** `trending_news_screen.dart`
- **Propósito:** Notícias ou conteúdos em destaque (ex.: saúde, atualizações).
- **Funcionalidade:** Lista de notícias ou cards; conteúdo mock ou vindo do backend.
- **Navegação:** Voltar → Real Time Health Screen.

---

## Navegação global

- **Bottom Navigation Bar:** presente em várias telas; ícones: Algoritmos, Modo Plantão, Home (Dashboard), Marketplace, Saúde em tempo real. Cada um navega para a tela correspondente (Dashboard como "Home").
- **Floating Action Button (Chat):** abre Chat Screen.
- **Drawer (menu lateral):** Profile Menu Screen; disponível em Dashboard, Marketplace, Notifications, Chat, Progress, e outras telas principais.
- **Header:** botão voltar; ícone de notificações (em algumas telas); avatar (em Dashboard).

Este documento deve ser atualizado quando novas telas forem criadas ou fluxos alterados.
