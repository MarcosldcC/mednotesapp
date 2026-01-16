## API (Mednotes Backend)

### Base URL (dev)

- `http://127.0.0.1:3002`

### Headers comuns

- `Content-Type: application/json` (para requests `POST`)
- `Authorization: Bearer <access_token>` (para rotas protegidas)

---

## Health

### `GET /health`

**Descrição**: verifica se o backend está no ar.

**Resposta 200**

```json
{ "ok": true }
```

---

## Auth

### `POST /auth/signup`

**Descrição**: cria o usuário com e-mail e senha e dispara o envio do **código (OTP)** para confirmação de e-mail.

**Body**

```json
{
  "nome": "Miguel",
  "sobrenome": "Silva",
  "email": "miguel@exemplo.com",
  "senha": "12345678"
}
```

**Respostas**

- **201**

```json
{
  "user": { "id": "uuid", "email": "miguel@exemplo.com" },
  "message": "Cadastro criado. Enviamos um código de confirmação para o seu e-mail."
}
```

- **400**

```json
{ "error": "mensagem do erro" }
```

---

### `POST /auth/verify`

**Descrição**: confirma o e-mail usando o código (OTP) recebido.

**Body**

```json
{
  "email": "miguel@exemplo.com",
  "codigo": "123456"
}
```

**Respostas**

- **200**

```json
{
  "session": {
    "access_token": "jwt",
    "token_type": "bearer",
    "expires_in": 3600,
    "refresh_token": "..."
  },
  "user": { "id": "uuid", "email": "miguel@exemplo.com" }
}
```

- **400**

```json
{ "error": "mensagem do erro" }
```

---

### `POST /auth/login`

**Descrição**: autentica usando e-mail e senha (o usuário precisa estar confirmado).

**Body**

```json
{
  "email": "miguel@exemplo.com",
  "senha": "12345678"
}
```

**Respostas**

- **200**

```json
{
  "session": {
    "access_token": "jwt",
    "token_type": "bearer",
    "expires_in": 3600,
    "refresh_token": "..."
  },
  "user": { "id": "uuid", "email": "miguel@exemplo.com" }
}
```

- **401**

```json
{ "error": "Invalid login credentials" }
```

---

### `POST /auth/resend`

**Descrição**: reenvia o código (OTP) de confirmação de cadastro.

**Body**

```json
{ "email": "miguel@exemplo.com" }
```

**Respostas**

- **200**

```json
{
  "data": {},
  "message": "Código reenviado (verifique o Mailpit no ambiente local)."
}
```

- **400**

```json
{ "error": "mensagem do erro" }
```

---

## Usuário (protegido)

### `GET /me`

**Descrição**: retorna os dados do usuário autenticado.

**Headers**

- `Authorization: Bearer <access_token>`

**Respostas**

- **200**

```json
{
  "user": { "id": "uuid", "email": "miguel@exemplo.com" }
}
```

- **401** (sem token)

```json
{ "error": "Missing Bearer token" }
```

- **401** (token inválido)

```json
{ "error": "Invalid token" }
```

