# 🍳 Aplicativo de Receitas com Autenticação e Navegação por Categorias

Um aplicativo Flutter que combina **autenticação simples**, **formulários com validação** e **navegação por abas inferiores**.  
O usuário pode se **cadastrar**, **fazer login** e **gerenciar receitas** divididas em categorias: **Doces**, **Salgadas** e **Bebidas**.

---

## 📱 Funcionalidades

### 🔐 Tela de Login
- Campos:
    - E-mail
    - Senha
- ✅ **Validação:**
    - E-mail deve ter formato válido (`exemplo@dominio.com`).
    - Senha deve conter **pelo menos 6 caracteres**.
- Caso o usuário ainda não tenha cadastro, há um **link para a tela de cadastro**.

---

### 📝 Tela de Cadastro de Usuário
- Campos:
    - Nome
    - E-mail
    - Senha
- ✅ **Validação obrigatória** em todos os campos.
- Após o cadastro bem-sucedido, o usuário é **redirecionado automaticamente para a tela de login**.

---

### 🍽️ Tela Principal – Receitas por Categorias
- Interface organizada com **abas inferiores**:
    - **Doces**
    - **Salgadas**
    - **Bebidas**
- Cada aba mostra uma **lista de receitas** da categoria correspondente.
- Cada receita é exibida em um **Card**, contendo:
    - Nome da receita
    - Tempo de preparo (em minutos)
    - Botão de ação para visualizar mais detalhes

---

### ➕ Cadastro de Receita
- Um **botão flutuante (FloatingActionButton “+”)** abre o formulário para adicionar uma nova receita.
- Após o cadastro, a receita aparece automaticamente na aba correspondente.

---