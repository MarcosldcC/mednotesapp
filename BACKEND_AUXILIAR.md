# MedNotes — Guia auxiliar para desenvolvimento do backend

Este documento descreve o app MedNotes do ponto de vista do front-end (Flutter) e serve como **referência para o programador backend** definir arquitetura, modelos de dados, APIs e integrações. Não substitui o desenho técnico do backend; apenas consolida o que o app espera e usa hoje.

---

## 1. Visão geral do app

- **Nome:** MedNotes  
- **Propósito:** App para profissionais de saúde (médicos em formação e em atividade) com foco em:
  - Protocolos e algoritmos clínicos
  - Simulações de atendimento (modo plantão)
  - Progresso de carreira (níveis/tiers)
  - Marketplace de conteúdos (cursos, livros, itens)
  - Chat (suporte/assistência)
  - Notificações
  - Perfil, assinaturas e pagamentos

O app hoje funciona **sem backend**: dados mock, SharedPreferences e constantes. O backend precisará fornecer autenticação, persistência de usuário, catálogos, progresso, notificações e chat.

---

## 2. Fluxos principais (para desenho de APIs)

| Fluxo | Descrição resumida | Pontos de integração |
|-------|--------------------|----------------------|
| **Auth** | Splash → Welcome → Login ou Register → (Verify Account) → Choose Plan → Dashboard | Login, registro, verificação de conta, token/sessão |
| **Perfil** | Menu (drawer) → Visualizar Conta, Editar Perfil, Central de Ajuda, Termos, Política, Sair | CRUD perfil, preferências, logout |
| **Carreira / Progresso** | Dashboard, Progress, Rank por tier, pontos por simulação | Pontos, nível, ranking por tier |
| **Algoritmos / Protocolos** | Listagem → Detalhe (fluxograma + flashcards) → Salvar / Exportar PDF / Simular Caso | Catálogo, detalhe, favoritos/recentes, PDF |
| **Simulação (Modo Plantão)** | Seleção de paciente → Triagem → passos clínicos → conclusão → pontos | Casos, passos, respostas, pontuação, tempo |
| **Marketplace** | Listagem, filtros, categoria, produto, “adquirir” | Catálogo produtos, categorias, aquisições |
| **Assinatura / Pagamento** | Escolha de plano (mensal/anual), método de pagamento, sucesso | Planos, métodos de pagamento, confirmação |
| **Notificações** | Lista de notificações (título, mensagem, data, lida) | Listar, marcar como lida |
| **Chat** | Lista de conversas, tela de conversa com mensagens | Conversas, mensagens, envio/recebimento |

---

## 3. Modelos de dados (referência do app)

Os nomes e campos abaixo são os usados no Flutter; o backend pode normalizar (IDs, datas em UTC, etc.) como preferir.

### 3.1 Usuário / Perfil (implícito no app)

- **Nome** (exibição)
- **E-mail**
- **Telefone**
- **UF** (estado, opcional)
- **Foto** (URL ou base64; no app hoje é asset local)
- **Preferências:** tamanho do texto, alto contraste, modo eco, notificações push, alertas epidemiológicos (podem ficar só no app ou sincronizar)

### 3.2 Autenticação (esperado pelo app)

- **Login:** e-mail + senha → token (ex.: JWT) e dados básicos do usuário.
- **Registro:** nome, sobrenome, e-mail, senha, aceite de termos → conta criada; fluxo de verificação de e-mail se houver.
- **Senha:** regras no app — mínimo 8 caracteres, maiúscula, minúscula, número, caractere especial.
- **Recuperação / troca de senha:** telas existentes (Verify Code, Change Password); backend precisa de endpoints para código e reset.

### 3.3 Produto (Marketplace)

```text
id: string
title: string
description: string
price: number
rating: number
acquiredCount: number
category: string   // ex.: "Cursos" | "Livros" | "Itens"
imageUrl?: string
```

- Filtros usados no app: categoria, faixa de preço, busca por texto.

### 3.4 Algoritmo / Protocolo

- **Listagem:** título, subtítulo, “timeAgo” (ex.: “Há dois dias”) — pode ser data de atualização.
- **Detalhe:** título + fluxograma (passos/branches) + lista de **flashcards** (pergunta, resposta).
- **Salvar / recentes:** o app envia apenas o **título** do algoritmo salvo; no backend pode ser um ID e metadados (usuário, algoritmo_id, data).
- **Exportar PDF:** o app hoje só mostra mensagem “em desenvolvimento”; o backend pode gerar o PDF a partir do algoritmo e devolver URL ou binário.

### 3.5 Carreira / Progresso

- **Níveis:** 15 níveis fixos (Internato I–III, Residente I–III, Staff I–III, Especialista I–III, Mentor I–III).
- **Pontos:** 0–100 por tier; ao atingir 100 sobe um nível e zera pontos no tier.
- Por usuário o app persiste: `levelIndex` (0–14), `pointsInTier` (0–100).
- **Ranking:** por tier (levelIndex), lista de entradas com nome, pontos no tier, posição (rank); usuário atual destacado.

```text
RankEntry (referência)
  name: string
  exp: number   // legado; pode ser ignorado se usar só points
  points?: number  // 0–100 no tier
  rank: number
  isUser: boolean
```

### 3.6 Simulação (Modo Plantão)

- **Paciente (caso):** nome, idade, sintoma, histórico prévio, medicação usual, imagePath opcional.
- **Passos:** sequência de telas com cardTitle, cardContent, pergunta, opções (lista de strings), índice da resposta correta, feedback (correto/erro).
- **Estado durante a simulação:** vidas (ex.: 3), cronômetro (segundos), caso em andamento; ao concluir ou abandonar, enviar resultado (sucesso/falha, tempo, pontos).
- **Pontos:** concedidos ao concluir (ex.: 10); o app soma ao `UserCareerProvider` (no backend: atualizar pontos/level do usuário).

### 3.7 Notificação

- **Listagem:** título, mensagem, data/hora (ou “timeAgo”), lida (boolean).
- Ações: listar por usuário, marcar como lida.

### 3.8 Chat

- **Conversas:** lista de conversas (identificador, título ou último preview, data).
- **Mensagens:** por conversa — remetente (usuário/sistema), texto, data; envio de nova mensagem.
- O app hoje não define se é chat com suporte único ou múltiplos canais; o backend pode definir (ex.: um canal “Suporte” por usuário).

### 3.9 Assinatura / Planos

- **Planos:** ex.: Free, Premium, Institucional; ciclo mensal/anual.
- **Escolha de plano:** tela “Choose Plan” envia plano + ciclo; depois fluxo de pagamento (método de pagamento, confirmação).
- **Estado da assinatura:** ativo, cancelado, trial — o app pode precisar de um endpoint “meu plano atual” para exibir conteúdo bloqueado/liberado.

### 3.10 Configurações (Settings)

- Alto contraste, notificações push, alertas epidemiológicos, tamanho do texto, modo eco.
- Hoje 100% local (SharedPreferences). Opcional: sincronizar com backend para “preferências do usuário”.

---

## 4. Sugestão de agrupamento de APIs (REST)

Agrupar por domínio ajuda o programador backend a desenhar controllers e rotas.

### 4.1 Auth

- `POST /auth/register` — corpo: nome, sobrenome, email, password, aceite termos.
- `POST /auth/login` — corpo: email, password → resposta: token + user (id, name, email, etc.).
- `POST /auth/logout` — invalidar token (se armazenado no servidor).
- `POST /auth/verify-account` — código de verificação (e-mail).
- `POST /auth/forgot-password` — solicitar código; `POST /auth/reset-password` — código + nova senha.
- `GET /auth/me` — perfil do usuário autenticado (token no header).

### 4.2 Usuário / Perfil

- `GET /users/me` — dados completos do perfil.
- `PATCH /users/me` — atualizar nome, telefone, email, UF, foto (conforme modelo escolhido).
- Opcional: `GET/PATCH /users/me/preferences` — preferências (tema, notificações, acessibilidade).

### 4.3 Produtos (Marketplace)

- `GET /products` — query: category, minPrice, maxPrice, search, limit, offset.
- `GET /products/:id` — detalhe do produto.
- `GET /products/categories` — lista de categorias (ex.: Cursos, Livros, Itens).
- Opcional: `POST /users/me/acquisitions` — registrar aquisição (productId, etc.).

### 4.4 Algoritmos / Protocolos

- `GET /algorithms` — listagem; query: search, category (se houver).
- `GET /algorithms/:id` — detalhe: título, fluxograma (estrutura definida no backend), flashcards (pergunta, resposta).
- `POST /users/me/recent-protocols` ou `POST /users/me/saved-algorithms` — salvar algoritmo (body: algorithmId ou title).
- `GET /users/me/recent-protocols` — lista de protocolos recentes/salvos (para o dashboard).
- `GET /algorithms/:id/pdf` ou `POST /algorithms/:id/export-pdf` — gerar/retornar PDF (URL ou stream).

### 4.5 Carreira / Progresso

- `GET /users/me/career` — levelIndex, pointsInTier, pontos totais (se houver).
- `POST /users/me/career/points` — body: delta (ex.: 10); servidor aplica regras de nível e retorna novo levelIndex e pointsInTier.
- `GET /rankings/tier/:levelIndex` — ranking do tier (lista de RankEntry com name, points, rank); indicar isUser para o usuário logado.

### 4.6 Simulações

- `GET /simulation/cases` — lista de casos (pacientes) disponíveis; campos: id, name, age, symptom, previousHistory, usualMedication, imageUrl.
- `GET /simulation/steps` ou `/simulation/cases/:caseId/steps` — passos da simulação (cardTitle, cardContent, question, options, correctIndex, feedbackCorrect, feedbackError).
- `POST /simulation/sessions` — iniciar sessão (caseId) → retorna sessionId.
- `POST /simulation/sessions/:sessionId/complete` — body: success, elapsedSeconds, score; servidor pode calcular pontos e atualizar carreira (ou o app envia delta e chama `POST /users/me/career/points`).

### 4.7 Notificações

- `GET /notifications` — listagem (query: limit, offset, unreadOnly).
- `PATCH /notifications/:id/read` ou `POST /notifications/mark-read` — marcar como lida(s).

### 4.8 Chat

- `GET /chat/conversations` — lista de conversas do usuário.
- `GET /chat/conversations/:id/messages` — mensagens (query: limit, before).
- `POST /chat/conversations/:id/messages` — enviar mensagem (body: text).
- Opcional: WebSocket ou polling para novas mensagens.

### 4.9 Planos / Assinatura

- `GET /plans` — planos disponíveis (nome, preço mensal/anual, benefícios).
- `GET /users/me/subscription` — plano atual, status, próxima cobrança.
- `POST /subscriptions` — criar assinatura (planId, billingCycle, paymentMethodId).
- Integração com gateway de pagamento (Stripe, etc.) fica a cargo do backend; o app envia identificadores e recebe confirmação.

---

## 5. Autenticação e headers

- **Token:** Bearer JWT (ou outro esquema) no header `Authorization`.
- **Refresh:** se usar refresh token, definir endpoint (ex.: `POST /auth/refresh`) e política no app (renovação automática, logout em 401).
- Todas as rotas de “users/me”, “notifications”, “chat”, “career”, “recent-protocols” devem exigir usuário autenticado.

---

## 6. Dados atualmente locais no app (para migrar/sincronizar)

| Dado | Onde está no app | Sugestão backend |
|------|-------------------|------------------|
| Nome, email, telefone do usuário | AppConstants + EditProfile | Ler/gravar em `/users/me` |
| Carreira (levelIndex, pointsInTier) | UserCareerProvider + SharedPreferences | GET/POST em `/users/me/career` |
| Protocolos recentes (títulos) | RecentProtocolsProvider + SharedPreferences | GET/POST em `/users/me/recent-protocols` |
| Preferências (contraste, notificações, etc.) | SettingsService + SharedPreferences | Opcional: `/users/me/preferences` |
| Estado da simulação (vidas, tempo) | SimulationStateProvider (só em memória) | Opcional: sessão no backend com `sessions/:id` |
| Lista de produtos | mock_products.dart | Substituir por `GET /products` |
| Lista de algoritmos | Mock em ClinicalAlgorithmsScreen | Substituir por `GET /algorithms` |
| Casos de simulação | Mock em SimulationCaseSelectionScreen | Substituir por `GET /simulation/cases` |
| Passos da simulação | OnCallSimulationSteps (modelo fixo) | `GET /simulation/steps` ou por caso |
| Notificações | Lista fixa em NotificationsScreen | `GET /notifications` |
| Mensagens do chat | Lista vazia em ChatConversationScreen | `GET/POST /chat/...` |

---

## 7. Considerações técnicas rápidas

- **IDs:** usar UUID ou string opaca no backend; o app já usa `id` string em produtos e referências por título em algoritmos (podem virar IDs).
- **Datas:** ISO 8601 (UTC); “timeAgo” pode ser calculado no app a partir da data.
- **Paginação:** listagens (produtos, notificações, mensagens, ranking) com limit/offset ou cursor.
- **Imagens:** URLs públicas ou assinadas; upload de foto de perfil via `PATCH /users/me` (multipart ou URL após upload em outro serviço).
- **PDF:** gerar no backend a partir do algoritmo e retornar URL ou stream; o app apenas aciona o endpoint e exibe ou baixa.
- **Ambiente:** definir base URL por ambiente (dev/staging/prod); o app consumirá uma única base URL configurável.

---

## 8. Estrutura de pastas do app (referência)

Para o backend localizar onde cada conceito aparece no Flutter:

- **lib/constants/** — cores, textos, `app_constants.dart` (placeholders de usuário).
- **lib/models/** — Product, CareerLevel, RankEntry, Tier, OnCallSimulationStepData.
- **lib/providers/** — UserCareerProvider, SimulationStateProvider, RecentProtocolsProvider.
- **lib/services/** — SettingsService, CareerProgressService, TierService.
- **lib/data/** — mock_products.dart (lista de produtos).
- **lib/screens/** — todas as telas (auth, dashboard, profile, marketplace, algorithms, simulation, chat, notifications, etc.).

Este guia deve ser usado junto com reuniões de alinhamento e especificação da API (ex.: OpenAPI) para garantir contrato entre app e backend.
