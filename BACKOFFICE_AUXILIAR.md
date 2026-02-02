# MedNotes — Guia auxiliar para o sistema de backoffice

Este documento descreve **o que o backoffice precisa gerenciar** para alimentar o app MedNotes: entidades, operações (CRUD), fluxos e boas práticas. Serve como base para o desenho do painel administrativo.

---

## 1. Visão geral

O backoffice deve permitir que administradores:

- Cadastrem e editem **conteúdos** que o app consome (produtos, algoritmos, casos de simulação, notícias, etc.).
- Gerenciem **usuários** (consulta, suporte, bloqueio).
- Configurem **planos e preços**.
- Enviem **notificações** e acompanhem **chat/suporte**.
- Publiquem **textos institucionais** (termos, política de privacidade, FAQ).

O app consome esses dados via API; o backoffice alimenta o backend (banco de dados e serviços).

---

## 2. Módulos do backoffice

Sugestão de módulos e entidades a administrar:

| Módulo | Objetivo | Quem usa no app |
|--------|----------|------------------|
| **Usuários** | Consultar, bloquear, suporte | Login, perfil, progresso |
| **Produtos (Marketplace)** | CRUD de produtos e categorias | Marketplace, Category Products, Product Detail |
| **Algoritmos / Protocolos** | CRUD de algoritmos, fluxogramas, flashcards, PDF | Clinical Algorithms, Algorithm Detail |
| **Simulações** | Casos (pacientes) e passos (perguntas/respostas) | Modo Plantão, Simulation Case Selection, telas de etapa |
| **Planos e preços** | Planos, ciclos, preços | Choose Plan, Subscription |
| **Notificações** | Criar e enviar notificações | Notifications Screen |
| **Chat / Suporte** | Responder conversas e ver FAQs | Chat, Help Center |
| **Conteúdo institucional** | Termos, política, FAQ, notícias | Terms, Privacy, Help Center, Trending News |
| **Carreira / Ranking** | Regras de pontos, níveis (opcional) | Progress, Rank Detail |
| **Configurações globais** | Feature flags, textos do app (opcional) | Diversas telas |

---

## 3. Entidades e operações por módulo

### 3.1 Usuários

**Objetivo:** Consultar usuários, bloquear/desbloquear, suporte.

| Operação | Descrição |
|----------|-----------|
| Listar | Filtros: e-mail, nome, data de cadastro, plano, status (ativo/bloqueado). Paginação. |
| Visualizar | Ver perfil completo: nome, e-mail, telefone, UF, foto, plano, nível de carreira, última atividade. |
| Bloquear / Desbloquear | Impedir ou liberar login. |
| Histórico (opcional) | Ver ações recentes, assinaturas, aquisições. |

**Campos úteis (referência do app):** nome, sobrenome, e-mail, telefone, UF, foto (URL), data de cadastro, email_verificado, plano_id, status.

Não é obrigatório editar dados do usuário pelo backoffice (o usuário edita no app); o foco é consulta e moderação.

---

### 3.2 Produtos (Marketplace)

**Objetivo:** Cadastrar e editar produtos que aparecem no Marketplace e nas categorias.

| Operação | Descrição |
|----------|-----------|
| Criar | Título, descrição, preço, categoria, imagem (upload ou URL), rating e acquiredCount (ou calcular). |
| Editar | Mesmos campos; ativo/inativo para publicar ou ocultar. |
| Listar | Filtros: categoria, faixa de preço, busca por título; ordenação por data, preço, nome. |
| Excluir / Arquivar | Excluir ou marcar como inativo (não exibir no app). |
| Categorias | Manter lista de categorias (ex.: Cursos, Livros, Itens). CRUD de categorias se o app filtrar por elas. |

**Campos sugeridos (alinhado ao app):**

- id (UUID ou string)
- title, description
- price (decimal)
- category (FK ou string: Cursos, Livros, Itens)
- imageUrl (ou upload → URL)
- rating (decimal, opcional)
- acquiredCount (inteiro, opcional)
- active (boolean)
- createdAt, updatedAt

---

### 3.3 Algoritmos / Protocolos clínicos

**Objetivo:** Cadastrar algoritmos que aparecem na listagem e no detalhe (fluxograma + flashcards + PDF).

| Operação | Descrição |
|----------|-----------|
| Criar | Título, subtítulo, categoria (ex.: Dor torácica, Hipertensão), data de publicação/atualização. |
| Editar | Mesmos campos; publicar/despublicar. |
| Listar | Filtros: busca, categoria; ordenação por data. |
| Fluxograma | Definir passos e ramos (estrutura usada no Algorithm Detail). Ex.: passos numerados, títulos, itens de lista; ramos com título e itens. Pode ser JSON ou tabelas relacionadas (steps, branches). |
| Flashcards | Lista de pares pergunta/resposta. CRUD por algoritmo (ordem, edição, exclusão). |
| PDF | Upload de PDF ou “gerar a partir do algoritmo”. O app chama endpoint que retorna URL ou arquivo. |
| Excluir / Arquivar | Excluir ou ocultar do app. |

**Campos sugeridos (algoritmo):**

- id, title, subtitle, category (ou tag)
- publishedAt, updatedAt
- active (boolean)
- flowchart (JSON ou relação steps/branches)
- pdfUrl (opcional)

**Flashcards:** algorithmId, order, question, answer.

O backoffice deve permitir editar flowchart e flashcards de forma intuitiva (formulários ou editor visual).

---

### 3.4 Simulações (Modo Plantão e casos)

O app tem dois fluxos de simulação:

1. **Modo Plantão (On Call):** sequência fixa de 5 passos (RCP, ritmo, via aérea, reavaliação, causas reversíveis). Conteúdo hoje em código (OnCallSimulationSteps).
2. **Simulação por caso:** seleção de paciente → triagem → várias telas (pressão, risco cardiovascular, classificação, medicação, decisão terapêutica, não farmacológica).

**Objetivo do backoffice:** alimentar casos (pacientes) e, se possível, passos configuráveis.

#### 3.4.1 Casos (pacientes)

| Operação | Descrição |
|----------|-----------|
| Criar | Nome, idade, sintoma, histórico prévio, medicação usual, imagem (opcional). |
| Editar / Listar / Excluir | Padrão CRUD. Ordenação e filtro por nome, sintoma. |
| Ordem | Definir ordem de exibição no app (ex.: drag-and-drop). |

**Campos sugeridos:** id, name, age, symptom, previousHistory, usualMedication, imageUrl, order, active, createdAt, updatedAt.

#### 3.4.2 Passos da simulação

- **Modo Plantão:** hoje fixo no app; o backend pode apenas expor o mesmo conteúdo. Opcional: mover para banco (tabela `simulation_steps` com type=on_call e order).
- **Simulação por caso:** passos podem ser por caso ou globais (por “tipo de etapa”). Cada passo: cardTitle, cardContent, question, options (lista), correctIndex, feedbackCorrect, feedbackError.

| Operação | Descrição |
|----------|-----------|
| Criar passo | Vincular a um caso (ou tipo de etapa); preencher pergunta, opções, resposta correta, feedbacks. |
| Editar / Ordenar / Excluir | Reordenar sequência; editar textos; excluir passo. |
| Listar | Por caso ou por tipo (triagem, pressão, risco, etc.). |

**Campos sugeridos (passo):** id, caseId (ou stepType), order, cardTitle, cardContent, question, options (JSON array), correctIndex, feedbackCorrect, feedbackError, active.

O backoffice deve ter uma tela “Casos” e, dentro de cada caso (ou em “Passos”), a lista de passos com ordem editável.

---

### 3.5 Planos e preços

**Objetivo:** Definir planos (Free, Premium, Institucional, etc.), ciclos (mensal/anual) e preços.

| Operação | Descrição |
|----------|-----------|
| Criar plano | Nome, descrição, benefícios (texto ou lista), imagem (ex.: premium.png, institucional.png). |
| Editar / Listar / Excluir | CRUD; ativo/inativo. |
| Preços | Por plano: preço mensal, preço anual; moeda; vigência (opcional). |
| Ciclos | Associar ciclos (mensal, anual) a cada plano. |

**Campos sugeridos (plano):** id, name, description, benefits (texto ou JSON), imageUrl, monthlyPrice, annualPrice, active, createdAt, updatedAt.

O app exibe planos na Choose Plan Screen; o backend retorna lista de planos com preços. O backoffice alimenta essa lista.

---

### 3.6 Notificações

**Objetivo:** Criar notificações que aparecem na tela Notifications do app.

| Operação | Descrição |
|----------|-----------|
| Criar | Título, mensagem, público-alvo (todos, por plano, por segmento). Agendar ou enviar na hora. |
| Listar | Histórico de notificações enviadas; filtros por data, título. |
| Marcar como lida | No app o usuário marca; no backoffice apenas consultar estatísticas (quantos leram). |

**Campos sugeridos:** id, title, message, targetAudience (enum ou JSON), sentAt, createdAt. No backend, tabela `user_notifications` com userId, notificationId, readAt.

O backoffice precisa de formulário: título, mensagem, seleção de público (todos / plano / filtro) e botão “Enviar” ou “Agendar”.

---

### 3.7 Chat / Suporte

**Objetivo:** Atender conversas iniciadas no app (Chat Conversation) e manter FAQs (Help Center).

| Operação | Descrição |
|----------|-----------|
| Listar conversas | Por usuário, data, status (aberta/fechada). |
| Ver mensagens | Timeline da conversa; mensagens do usuário e do atendente. |
| Responder | Campo de texto; enviar mensagem como “suporte” (salva no backend; app busca novas mensagens). |
| Fechar / Reabrir | Marcar conversa como resolvida ou reaberta. |
| FAQ (Central de Ajuda) | CRUD de perguntas e respostas; categoria (Conta, Plano, Suporte). Ordem de exibição. |

**Campos sugeridos (conversa):** id, userId, status, createdAt, updatedAt.  
**Mensagens:** id, conversationId, sender (user | support), text, createdAt.  
**FAQ:** id, question, answer, category, order, active.

O app exibe FAQs na Help Center Screen e mensagens na Chat Conversation Screen; o backoffice alimenta FAQs e responde conversas.

---

### 3.8 Conteúdo institucional

**Objetivo:** Textos legais e informativos exibidos no app (Termos, Política, FAQ já citado, Notícias).

| Conteúdo | Tela no app | Operação no backoffice |
|----------|-------------|--------------------------|
| Termos de Uso | Terms of Use Screen | Editor de texto (rich text ou Markdown); versão vigente; histórico (opcional). |
| Política de Privacidade | Privacy Policy Screen | Idem. |
| FAQ | Help Center Screen | Ver módulo Chat / Suporte (FAQ). |
| Notícias / Destaques | Trending News Screen | CRUD de notícias: título, resumo, link ou texto, imagem, data, ativo. |

**Campos sugeridos (notícia):** id, title, summary, bodyOrUrl, imageUrl, publishedAt, active, createdAt, updatedAt.

Recomendação: versão e data de última atualização para Termos e Política (ex.: “Versão 1.2 – 01/02/2025”).

---

### 3.9 Carreira / Ranking (opcional no backoffice)

O app usa 15 níveis fixos (Internato I–III até Mentor I–III) e 100 pontos por tier. O backend pode:

- Calcular nível e pontos ao receber `POST /users/me/career/points`.
- Expor ranking por tier (`GET /rankings/tier/:levelIndex`).

No backoffice, normalmente **não** é necessário editar regras de carreira (podem ficar fixas no backend). Opcional: tela de “Regras de carreira” para alterar pontos por tier, tempo limite de simulação por nível, etc., se no futuro forem configuráveis.

---

### 3.10 Configurações globais (opcional)

- **Feature flags:** ativar/desativar funcionalidades no app (ex.: Modo Eco, Marketplace, Chat).
- **Textos globais:** mensagens de manutenção, avisos na tela de login.
- **URLs:** link da política, link dos termos, URL do suporte.

Pode ser uma única tela “Configurações” com chave/valor ou formulário por seção.

---

## 4. Fluxos recomendados no backoffice

### 4.1 Publicação de conteúdo

- **Produto:** Criar → preencher campos → upload de imagem → Salvar → opção “Publicar” (active = true). O app lista só ativos.
- **Algoritmo:** Criar → preencher título/categoria → editar fluxograma → editar flashcards → (opcional) gerar/upload PDF → Publicar.
- **Notícia:** Criar → título, resumo, imagem, data → Publicar.

### 4.2 Moderação

- **Usuários:** Listar → filtrar → abrir detalhe → Bloquear/Desbloquear com motivo (opcional).
- **Conversas:** Listar conversas abertas → abrir → Responder → Fechar quando resolvido.

### 4.3 Envio em massa

- **Notificações:** Formulário “Nova notificação” → escolher público (todos, por plano) → Enviar. Backend dispara push/e-mail e grava em `user_notifications`.

---

## 5. Permissões e perfis (sugestão)

| Perfil | Acesso sugerido |
|--------|-------------------|
| **Super admin** | Tudo: usuários, conteúdo, planos, notificações, chat, configurações. |
| **Editor de conteúdo** | Produtos, algoritmos, casos e passos de simulação, notícias, termos e política. Sem usuários nem configurações globais. |
| **Suporte** | Chat (conversas e respostas), FAQ, consulta de usuários (sem bloquear). |
| **Marketing** | Notificações, notícias, planos (apenas consulta). |

Implementar controle por papel (role) e, se necessário, por recurso (permission).

---

## 6. Integração backoffice ↔ backend ↔ app

```
[Backoffice]  -->  API do Backend  -->  Banco de dados
                     ^
                     |
[App MedNotes]  -->  mesma API  -->  lê os mesmos dados
```

- O backoffice usa a **mesma API** do backend (ou uma API admin com autenticação forte) para criar/editar/excluir dados.
- O app consome a API **pública/autenticada** para listar produtos, algoritmos, notificações, chat, etc.
- Tudo que o backoffice “alimenta” (produtos, algoritmos, casos, notícias, FAQs, termos, política) deve ser exposto via endpoints documentados no **BACKEND_AUXILIAR.md**.

---

## 7. Checklist de funcionalidades do backoffice

Use como lista de verificação ao desenhar o sistema:

- [ ] **Login** do administrador (e recuperação de senha).
- [ ] **Dashboard** resumo (usuários ativos, notificações enviadas, conversas abertas).
- [ ] **Usuários:** listar, filtrar, ver detalhe, bloquear/desbloquear.
- [ ] **Produtos:** CRUD, categorias, upload de imagem, publicar/despublicar.
- [ ] **Algoritmos:** CRUD, editor de fluxograma, CRUD de flashcards, PDF (upload ou gerar).
- [ ] **Casos de simulação:** CRUD de casos (pacientes).
- [ ] **Passos de simulação:** CRUD de passos por caso (ou tipo), ordenação.
- [ ] **Planos:** CRUD, preços mensal/anual, imagens.
- [ ] **Notificações:** criar, definir público, enviar (e listar enviadas).
- [ ] **Chat:** listar conversas, ver mensagens, responder, fechar.
- [ ] **FAQ:** CRUD de perguntas/respostas, categorias, ordem.
- [ ] **Termos de Uso e Política de Privacidade:** editor e versão.
- [ ] **Notícias / Trending:** CRUD, publicar por data.
- [ ] **Permissões:** perfis (super admin, editor, suporte, marketing).
- [ ] **Auditoria (opcional):** log de alterações (quem alterou o quê e quando).

Este guia deve ser usado junto com **BACKEND_AUXILIAR.md** e **TELAS_E_FUNCIONALIDADES.md** para alinhar app, API e backoffice.
