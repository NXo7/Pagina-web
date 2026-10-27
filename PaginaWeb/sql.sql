-- 01_tabela_unica.sql
-- PostgreSQL 16 | Dados fictícios
-- A planilha da papelaria como uma única tabela (1FN, mas com redundância).

DROP TABLE IF EXISTS planilha;

CREATE TABLE planilha (
  id_pedido    INT,
  id_produto   TEXT,
  nome_produto TEXT,
  preco        NUMERIC(8,2),
  qtd          INT,
  id_cliente   TEXT,
  nome_cliente TEXT,
  cidade       TEXT,
  PRIMARY KEY (id_pedido, id_produto)
);

INSERT INTO planilha VALUES
  (1001, 'P01', 'Caderno 96f', 18.00,  2, 'C01', 'Ana Souza',  'Suzano'),
  (1001, 'P02', 'Caneta azul',  3.50, 10, 'C01', 'Ana Souza',  'Suzano'),
  (1002, 'P01', 'Caderno 96f', 18.00,  1, 'C02', 'Bruno Lima', 'Mogi'),
  (1003, 'P02', 'Caneta azul',  3.50,  5, 'C01', 'Ana Souza',  'Suzano');

-- Conferindo o resultado
SELECT * FROM planilha ORDER BY id_pedido, id_produto;



-- 02_anomalias.sql
-- PostgreSQL 16 | Dados fictícios
-- Reproduz as três anomalias da tabela única.
-- Rode em um banco limpo. O erro da anomalia de inserção é esperado.

-- Preparação: recria a tabela do zero
DROP TABLE IF EXISTS planilha;

CREATE TABLE planilha (
  id_pedido    INT,
  id_produto   TEXT,
  nome_produto TEXT,
  preco        NUMERIC(8,2),
  qtd          INT,
  id_cliente   TEXT,
  nome_cliente TEXT,
  cidade       TEXT,
  PRIMARY KEY (id_pedido, id_produto)
);

INSERT INTO planilha VALUES
  (1001, 'P01', 'Caderno 96f', 18.00,  2, 'C01', 'Ana Souza',  'Suzano'),
  (1001, 'P02', 'Caneta azul',  3.50, 10, 'C01', 'Ana Souza',  'Suzano'),
  (1002, 'P01', 'Caderno 96f', 18.00,  1, 'C02', 'Bruno Lima', 'Mogi'),
  (1003, 'P02', 'Caneta azul',  3.50,  5, 'C01', 'Ana Souza',  'Suzano');

-- 1) Anomalia de atualização
-- Corrigimos o preço do caderno só em uma linha (esquecemos o pedido 1002).
UPDATE planilha SET preco = 19.00
WHERE id_produto = 'P01' AND id_pedido = 1001;

SELECT DISTINCT id_produto, preco FROM planilha WHERE id_produto = 'P01';
-- Retorna 18.00 e 19.00: dois preços para o mesmo produto.

-- 2) Anomalia de inserção
-- Produto novo, ainda sem vendas: não há onde cadastrá-lo.
INSERT INTO planilha (id_produto, nome_produto, preco)
VALUES ('P03', 'Lápis HB', 1.20);
-- ERRO esperado: id_pedido faz parte da chave primária e não pode ser nulo.

-- 3) Anomalia de exclusão
-- Cancelar o pedido 1002 apaga também o cadastro do cliente C02.
DELETE FROM planilha WHERE id_pedido = 1002;

SELECT * FROM planilha WHERE id_cliente = 'C02';
-- 0 linhas: perdemos os dados do Bruno Lima.



-- 03_normalizado.sql
-- PostgreSQL 16 | Dados fictícios
-- Modelo na 3FN: clientes, produtos, pedidos e itens_pedido.

-- Preparação: remove as tabelas, se existirem (ordem das dependências)
DROP TABLE IF EXISTS itens_pedido;
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS produtos;
DROP TABLE IF EXISTS clientes;

CREATE TABLE clientes (
  id_cliente TEXT PRIMARY KEY,
  nome       TEXT NOT NULL,
  cidade     TEXT NOT NULL
);

CREATE TABLE produtos (
  id_produto TEXT PRIMARY KEY,
  nome       TEXT NOT NULL,
  preco      NUMERIC(8,2) NOT NULL
);

CREATE TABLE pedidos (
  id_pedido  INT PRIMARY KEY,
  id_cliente TEXT NOT NULL REFERENCES clientes
);

CREATE TABLE itens_pedido (
  id_pedido  INT  REFERENCES pedidos,
  id_produto TEXT REFERENCES produtos,
  qtd        INT  NOT NULL,
  PRIMARY KEY (id_pedido, id_produto)
);

INSERT INTO clientes VALUES
  ('C01', 'Ana Souza',  'Suzano'),
  ('C02', 'Bruno Lima', 'Mogi');

INSERT INTO produtos VALUES
  ('P01', 'Caderno 96f', 18.00),
  ('P02', 'Caneta azul',  3.50),
  ('P03', 'Lápis HB',     1.20);   -- produto sem vendas: agora pode existir

INSERT INTO pedidos VALUES
  (1001, 'C01'),
  (1002, 'C02'),
  (1003, 'C01');

INSERT INTO itens_pedido VALUES
  (1001, 'P01',  2),
  (1001, 'P02', 10),
  (1002, 'P01',  1),
  (1003, 'P02',  5);

-- Reconstrói a planilha original com JOIN
SELECT p.id_pedido, pr.id_produto, pr.nome AS nome_produto, pr.preco,
       i.qtd, c.id_cliente, c.nome AS nome_cliente, c.cidade
FROM itens_pedido i
JOIN pedidos  p  ON p.id_pedido   = i.id_pedido
JOIN produtos pr ON pr.id_produto = i.id_produto
JOIN clientes c  ON c.id_cliente  = p.id_cliente
ORDER BY p.id_pedido, pr.id_produto;

-- As anomalias somem:
-- Atualização: o preço muda em uma única linha.
UPDATE produtos SET preco = 19.00 WHERE id_produto = 'P01';

-- Exclusão: cancelar o pedido 1002 não apaga o cliente C02.
DELETE FROM itens_pedido WHERE id_pedido = 1002;
DELETE FROM pedidos      WHERE id_pedido = 1002;
SELECT * FROM clientes WHERE id_cliente = 'C02';   -- o Bruno continua lá
