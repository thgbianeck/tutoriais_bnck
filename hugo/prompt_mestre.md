# PASSO 1: O MAPA DA MINA (REVISADO)
## Prompt Mestre v1.1 — Tutor Sênior

---

## Perfil do Ambiente

- **Sistema Operacional:** Windows 11
- **IDE:** VS Code
- **Framework:** Hugo Extended — versão mais recente (v0.158.0+)
- **Tema do Projeto:** Site de tutoriais de programação

---

## Nome do Projeto Prático Incremental

**"DevDocs Hub"** — Um site completo de tutoriais de programação, construído do zero com Hugo, usando um tema pronto e publicado na web. O foco total está em entender o Hugo, criar e organizar conteúdo, e colocar o site no ar.

---

## Objetivo Geral do Curso

Ao final deste curso, você será capaz de: instalar e configurar o Hugo no Windows 11; entender como um gerador de sites estáticos funciona; aplicar um tema pronto sem precisar criá-lo; criar e organizar páginas e tutoriais em Markdown; estruturar categorias, tags e navegação; e publicar o site gratuitamente na web.

---

## Divisão em Módulos

### MÓDULO 1 — ESSENCIAL (Fundamentos e Ambiente)
*Objetivo: Entender o Hugo e ter o ambiente pronto com um site rodando localmente.*

- **Aula 01:** O que é Hugo e como ele funciona — Conceitos de SSG, a diferença para WordPress/CMS e a filosofia do Hugo.
- **Aula 02:** Instalando o ambiente no Windows 11 — Git, Hugo Extended, VS Code e extensões essenciais.
- **Aula 03:** Criando o projeto DevDocs Hub — hugo new site, estrutura de pastas e primeiros comandos CLI.
- **Aula 04:** Aplicando um tema pronto — Como escolher, instalar e ativar um tema via Git Submodule, usando o tema PaperMod.
- **Aula 05:** Configuração básica do site — hugo.toml, título, descrição, idioma, menus e parâmetros do tema.

### MÓDULO 2 — PROFICIENTE (Conteúdo e Organização)
*Objetivo: Criar conteúdo real, organizado e navegável.*

- **Aula 06:** Markdown e Front Matter — A linguagem do conteúdo Hugo: campos essenciais, datas, rascunhos e metadados.
- **Aula 07:** Criando páginas e tutoriais — hugo new, archetypes e a diferença entre pages e posts.
- **Aula 08:** Organizando com seções, categorias e tags — Taxonomias no Hugo e como elas geram páginas automaticamente.
- **Aula 09:** Menus de navegação e páginas especiais — Página Sobre, página de Arquivo e links no menu principal.
- **Aula 10:** Imagens e arquivos no conteúdo — Como adicionar imagens, covers e arquivos aos tutoriais.

### MÓDULO 3 — PUBLICAÇÃO (Deploy e Manutenção)
*Objetivo: Colocar o site no ar e manter o fluxo de publicação.*

- **Aula 11:** Gerando o site para produção — hugo build, a pasta public e como o Hugo compila tudo.
- **Aula 12:** Deploy gratuito com GitHub Pages — Repositório, configuração e publicação automática.
- **Aula 13:** Fluxo de publicação de novos tutoriais — Como criar, revisar e publicar novos conteúdos no dia a dia.

---

## Estrutura de Progressão

~~~mermaid
graph TD
    A[Aula 01: Conceitos SSG] --> B[Aula 02: Ambiente Windows 11]
    B --> C[Aula 03: Criando o Projeto]
    C --> D[Aula 04: Aplicando Tema Pronto]
    D --> E[Aula 05: Configuração do Site]
    E --> F[Aula 06: Markdown e Front Matter]
    F --> G[Aula 07: Páginas e Tutoriais]
    G --> H[Aula 08: Seções, Categorias e Tags]
    H --> I[Aula 09: Menus e Páginas Especiais]
    I --> J[Aula 10: Imagens e Arquivos]
    J --> K[Aula 11: Build para Produção]
    K --> L[Aula 12: Deploy GitHub Pages]
    L --> M[Aula 13: Fluxo de Publicação]
~~~

---

## Estrutura do Repositório GitHub

~~~text
devdocs-hub/
├── README.md
├── plano_mestre.txt
├── log_estado_projeto.md
├── .gitignore
├── archetypes/
│   └── default.md
├── content/
│   ├── _index.md
│   ├── about/
│   │   └── index.md
│   └── tutorials/
│       ├── _index.md
│       ├── aula-01/
│       └── aula-02/
├── static/
│   └── images/
├── themes/
│   └── PaperMod/     ← tema pronto via git submodule
└── hugo.toml
~~~

---

## Tempo Estimado

| Módulo | Aulas | Leitura | Com Prática |
|---|---|---|---|
| Módulo 1 — Essencial | 5 aulas | ~2h30 | ~5h |
| Módulo 2 — Proficiente | 5 aulas | ~2h30 | ~5h |
| Módulo 3 — Publicação | 3 aulas | ~1h30 | ~3h |
| **Total** | **13 aulas** | **~6h30** | **~13h** |

---

## Ação Obrigatória — Salve este Plano

Salve o conteúdo deste bloco como `plano_mestre.txt` no seu computador. Nas próximas sessões, anexe esse arquivo ao chat para que eu mantenha o contexto completo do curso sem perder nenhum detalhe do que já foi planejado e executado.

---

Dúvidas sobre o novo planejamento? Se estiver satisfeito, é só dizer **"Pode começar"** e partimos para a Aula 01!