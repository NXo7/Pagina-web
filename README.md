<div align="center">

# 📒 Papelaria Normalizada

### Da planilha bagunçada ao banco de dados organizado

*Um artigo (bem) prático sobre 2FN e 3FN, com SQL que você pode rodar de verdade.*

![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=for-the-badge&logo=html5&logoColor=white)
![CSS3](https://img.shields.io/badge/CSS3-1572B6?style=for-the-badge&logo=css3&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL_16-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![License](https://img.shields.io/badge/imagens-CC_BY_4.0-lightgrey?style=for-the-badge)

</div>

---

## 🤔 Do que se trata?

Imagina uma papelaria pequena que anota **tudo numa tabela só**. Aí o dono sobe o preço do caderno de R$ 18 para R$ 19, corrige em algumas linhas, esquece de outras... e pronto: o mesmo caderno agora tem **dois preços**. 😬

Esse projeto é um artigo em formato de página web que mostra:

- por que isso acontece (spoiler: **redundância**);
- como reproduzir os problemas na prática;
- como a **2ª e a 3ª forma normal** resolvem tudo isso.

## 📚 O que tem no artigo

| # | Seção | Resumo |
|---|-------|--------|
| 1 | **O problema do dono da papelaria** | A planilha única e por que ela dá dor de cabeça |
| 2 | **Três anomalias** | Atualização, inserção e exclusão, todas reproduzíveis em SQL |
| 3 | **Conceitos** | Chave primária, dependência funcional, dependência parcial (2FN) e transitiva (3FN) |
| 4 | **A solução passo a passo** | Modelo na 3FN com diagrama ER e `JOIN` pra reconstruir a planilha |
| 5 | **Erros comuns e limitações** | Histórico de preços, chave artificial, quando *não* normalizar, BCNF |
| 6 | **Como começar na área** | Dicas pra praticar por conta própria |
| 7 | **Links e referências** | Pra quem quiser se aprofundar |

## 🗂️ Estrutura do projeto

```
Pagina-web/
├── 📄 README.md
└── 📁 PaginaWeb/
    ├── 🌐 index.html          → o artigo completo
    ├── 📁 css/
    │   └── 🎨 estilos.css     → visual da página
    ├── 📁 img/
    │   └── 🖼️ diagrama-er.png → diagrama das tabelas na 3FN
    └── 🗃️ sql                 → scripts SQL do artigo
```

## 🚀 Como ver a página

Não precisa instalar nada, é HTML e CSS puros:

1. Baixe ou clone o repositório
2. Abra o arquivo **`PaginaWeb/index.html`** no navegador
3. Pronto! 🎉

> 💡 As fontes (Bricolage Grotesque e Source Serif 4) vêm do Google Fonts. Sem internet a página funciona do mesmo jeito, só com fontes padrão.

## 🐘 Como rodar o SQL

Os scripts foram feitos no **PostgreSQL 16**. O arquivo `PaginaWeb/sql` tem três scripts, e a ordem importa pra acompanhar a história:

| Script | O que faz |
|--------|-----------|
| `01_tabela_unica.sql` | Cria a planilha da papelaria como uma tabela só (1FN, cheia de redundância) |
| `02_anomalias.sql` | Reproduz as 3 anomalias. ⚠️ O erro na inserção é **esperado**! |
| `03_normalizado.sql` | Monta o modelo na 3FN e mostra as anomalias sumindo |

Separe o conteúdo do arquivo `sql` em três arquivos `.sql` com esses nomes e rode:

```bash
psql -U seu_usuario -d seu_banco -f 01_tabela_unica.sql
psql -U seu_usuario -d seu_banco -f 02_anomalias.sql
psql -U seu_usuario -d seu_banco -f 03_normalizado.sql
```

Cada script apaga e recria as próprias tabelas, então dá pra rodar quantas vezes quiser sem medo. 😉

## 🧩 O modelo final (3FN)

```
clientes ──< pedidos ──< itens_pedido >── produtos
```

Um cliente faz **vários** pedidos, um pedido tem **vários** itens e um produto aparece em **vários** itens. Fim da redundância. ✨

## 👥 Quem fez

Trabalho feito pela galera do 2º semestre:

| Nome | Curso |
|------|-------|
| Henrick de Souza | Ciência da Computação |
| Cauã Diego Silva de Lima | Ciência da Computação |
| Raphael Faria Alves Bianco | ADS |
| Nicollas Andrew dos Santos Correa de Moraes | ADS |

## 📖 Referências

- CODD, E. F. *A relational model of data for large shared data banks.* Communications of the ACM, 1970.
- CODD, E. F. *Further normalization of the data base relational model.* Data Base Systems, 1972.
- BERNSTEIN, P. A. *Synthesizing third normal form relations from functional dependencies.* ACM TODS, 1976.
- [PostgreSQL 16: Constraints](https://www.postgresql.org/docs/16/ddl-constraints.html)
- [SQLite: Foreign Key Support](https://www.sqlite.org/foreignkeys.html)
- [Alura: normalização de banco de dados](https://www.alura.com.br/artigos/normalizacao-banco-de-dados-estrutura)
- [DataCamp: normalização em SGBDs](https://www.datacamp.com/pt/tutorial/normalization-in-dbms)

- *Link do artigo: https://paginaweb-one-eosin.vercel.app/*
---

<div align="center">

Feito com ☕ e muita planilha duplicada

</div>
