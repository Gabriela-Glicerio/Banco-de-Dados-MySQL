   -- ==========================================
-- PARTE 1: VIEWS (Ref: 1_Views.sql)
-- ==========================================
CREATE OR REPLACE VIEW dados_funcionarios AS
SELECT f.funcionario_id, CONCAT(f.primeiro_nome, ' ', f.sobrenome) AS funcionario_nome,
       f.telefone, f.email, f.data_contratacao, sf.nome AS situacao, f.salario, f.moeda_salario,
       c.cargo_nome AS cargo, c.min_salario, c.max_salario,
       d.departamento_nome AS departamento, e.escritorio_nome AS escritorio, e.endereco,
       p.pais_nome AS pais, r.regiao_nome AS regiao
FROM funcionarios f
JOIN cargos c ON c.cargo_id = f.cargo_id
JOIN departamentos d ON d.departamento_id = f.departamento_id
JOIN escritorios e ON e.escritorio_id = d.escritorio_id
JOIN paises p ON p.pais_id = e.pais_id
JOIN regioes r ON r.regiao_id = p.regiao_id
JOIN status_funcionario sf ON sf.status_funcionario_id = f.status_funcionario_id;

CREATE OR REPLACE VIEW dados_dependentes AS
SELECT d.dependente_id, CONCAT(d.primeiro_nome, ' ', d.sobrenome) AS dependente_nome,
       d.relacionamento, f.funcionario_id,
       CONCAT(f.primeiro_nome, ' ', f.sobrenome) AS funcionario_nome
FROM dependentes d JOIN funcionarios f ON f.funcionario_id = d.funcionario_id;

CREATE OR REPLACE VIEW custos_escritorios AS
SELECT e.escritorio_id, e.escritorio_nome, s.suprimento_id, s.referencia_compra,
       s.suprimento_nome, s.quantidade_estoque, s.custo_unitario, s.moeda, s.data_compra,
       s.quantidade_estoque * s.custo_unitario AS custo_total_item
FROM suprimentos s JOIN escritorios e ON e.escritorio_id = s.escritorio_id;

CREATE OR REPLACE VIEW relatorio_auditoria AS
SELECT a.log_id, a.log_acao AS acao, a.log_ts AS momento, ma.nome AS modulo,
       sa.nome AS status, a.log_origem AS origem, a.log_detalhes AS detalhes,
       a.funcionario_id, CONCAT(f.primeiro_nome, ' ', f.sobrenome) AS funcionario_nome
FROM audit_log a
JOIN modulos_auditoria ma ON ma.modulo_auditoria_id = a.modulo_auditoria_id
JOIN status_auditoria sa ON sa.status_auditoria_id = a.status_auditoria_id
LEFT JOIN funcionarios f ON f.funcionario_id = a.funcionario_id;

CREATE OR REPLACE VIEW relatorio_vendas AS
SELECT v.venda_id AS ticket, v.referencia_origem, v.data_venda, cv.nome AS canal, sv.nome AS status_venda,
       i.numero_item, i.quantidade, i.preco_unitario, i.moeda,
       i.quantidade * i.preco_unitario AS receita_item,
       p.produto_id, p.sku, p.produto_nome AS produto, f.funcionario_id,
       CONCAT(f.primeiro_nome, ' ', f.sobrenome) AS funcionario_nome
FROM vendas v
JOIN itens_venda i ON i.venda_id = v.venda_id
JOIN produtos p ON p.produto_id = i.produto_id
JOIN funcionarios f ON f.funcionario_id = v.funcionario_id
JOIN canais_venda cv ON cv.canal_venda_id = v.canal_venda_id
JOIN status_venda sv ON sv.status_venda_id = v.status_venda_id;

CREATE OR REPLACE VIEW vendas_funcionario_performance AS
SELECT f.funcionario_id, CONCAT(f.primeiro_nome, ' ', f.sobrenome) AS funcionario_nome,
       COUNT(DISTINCT v.venda_id) AS total_vendas, COALESCE(SUM(i.quantidade), 0) AS unidades_vendidas,
       COALESCE(SUM(i.quantidade * i.preco_unitario), 0) AS receita_total
FROM funcionarios f
LEFT JOIN vendas v ON v.funcionario_id = f.funcionario_id
LEFT JOIN itens_venda i ON i.venda_id = v.venda_id
GROUP BY f.funcionario_id, f.primeiro_nome, f.sobrenome;

CREATE OR REPLACE VIEW equipes_multiverso AS
SELECT f.funcionario_id, CONCAT(f.primeiro_nome, ' ', f.sobrenome) AS funcionario_nome,
       c.cargo_nome AS cargo, d.departamento_nome AS departamento, g.funcionario_id AS gerente_id,
       CONCAT(g.primeiro_nome, ' ', g.sobrenome) AS gerente_nome
FROM funcionarios f JOIN cargos c ON c.cargo_id = f.cargo_id
JOIN departamentos d ON d.departamento_id = f.departamento_id
LEFT JOIN funcionarios g ON g.funcionario_id = f.gerente_id;

CREATE OR REPLACE VIEW folha_departamentos AS
SELECT d.departamento_id, d.departamento_nome, COUNT(f.funcionario_id) AS total_funcionarios,
       COALESCE(SUM(f.salario), 0) AS folha_salarial, ROUND(AVG(f.salario), 2) AS salario_medio,
       MIN(f.salario) AS menor_salario, MAX(f.salario) AS maior_salario
FROM departamentos d LEFT JOIN funcionarios f ON f.departamento_id = d.departamento_id
GROUP BY d.departamento_id, d.departamento_nome;

CREATE OR REPLACE VIEW radar_salarial AS
SELECT f.funcionario_id, CONCAT(f.primeiro_nome, ' ', f.sobrenome) AS funcionario_nome,
       c.cargo_nome AS cargo, f.salario, f.moeda_salario, c.min_salario, c.max_salario,
       CASE WHEN f.moeda_salario <> 'USD' THEN 'Moeda diferente da faixa'
            WHEN f.salario < c.min_salario THEN 'Abaixo da faixa'
            WHEN f.salario > c.max_salario THEN 'Acima da faixa'
            ELSE 'Dentro da faixa' END AS situacao_salarial
FROM funcionarios f JOIN cargos c ON c.cargo_id = f.cargo_id;

CREATE OR REPLACE VIEW arsenal_mais_vendido AS
SELECT p.produto_id, p.sku, p.produto_nome, p.preco_catalogo, p.moeda,
       COUNT(DISTINCT v.venda_id) AS total_vendas, COALESCE(SUM(i.quantidade), 0) AS unidades_vendidas,
       COALESCE(SUM(i.quantidade * i.preco_unitario), 0) AS receita_total
FROM produtos p LEFT JOIN itens_venda i ON i.produto_id = p.produto_id
LEFT JOIN vendas v ON v.venda_id = i.venda_id
GROUP BY p.produto_id, p.sku, p.produto_nome, p.preco_catalogo, p.moeda;

CREATE OR REPLACE VIEW vendas_mensais AS
SELECT YEAR(v.data_venda) AS ano, MONTH(v.data_venda) AS mes,
       COUNT(DISTINCT v.venda_id) AS total_vendas, SUM(i.quantidade) AS unidades_vendidas,
       COUNT(DISTINCT v.funcionario_id) AS vendedores_ativos,
       SUM(i.quantidade * i.preco_unitario) AS receita_total,
       ROUND(SUM(i.quantidade * i.preco_unitario) / COUNT(DISTINCT v.venda_id), 2) AS ticket_medio
FROM vendas v JOIN itens_venda i ON i.venda_id = v.venda_id
GROUP BY YEAR(v.data_venda), MONTH(v.data_venda);

CREATE OR REPLACE VIEW impacto_educacional AS
SELECT c.curso_id, c.curso_nome, t.turma_id, t.codigo AS turma,
       CONCAT(f.primeiro_nome, ' ', f.sobrenome) AS professor,
       COUNT(m.matricula_id) AS matriculas,
       SUM(sm.nome = 'CONCLUIDA') AS concluintes,
       SUM(m.certificado_emitido) AS certificados_emitidos,
       ROUND(AVG(m.nota_final), 2) AS nota_media,
       COUNT(DISTINCT vt.aluno_id) AS talentos_vinculados
FROM cursos c
JOIN turmas t ON t.curso_id = c.curso_id
JOIN funcionarios f ON f.funcionario_id = t.professor_funcionario_id
LEFT JOIN matriculas m ON m.turma_id = t.turma_id
LEFT JOIN status_matricula sm ON sm.status_matricula_id = m.status_matricula_id
LEFT JOIN vinculos_talentos vt ON vt.aluno_id = m.aluno_id
GROUP BY c.curso_id, c.curso_nome, t.turma_id, t.codigo, f.funcionario_id, f.primeiro_nome, f.sobrenome;

CREATE OR REPLACE VIEW clientes_vendas AS
SELECT c.cliente_id, c.nome AS cliente, c.email,
       COUNT(v.venda_id) AS total_vendas,
       MAX(v.data_venda) AS ultima_venda,
       COALESCE(SUM(i.quantidade * i.preco_unitario), 0) AS receita_total
FROM clientes c
LEFT JOIN vendas v ON v.cliente_id = c.cliente_id
LEFT JOIN itens_venda i ON i.venda_id = v.venda_id
GROUP BY c.cliente_id, c.nome, c.email;

-- ==========================================
-- PARTE 2: SUBCONSULTAS (Ref: 2_SubQuery.sql)
-- ==========================================
SELECT funcionarios.primeiro_nome, funcionarios.sobrenome
FROM funcionarios 
WHERE cargo_id = 
    (SELECT cargo_id
     FROM cargos
     WHERE cargo_nome = 'Contador');

-- ==========================================
-- PARTE 3: RESOLUÇÕES DAS ATIVIDADES (Níveis 1 ao 12)
-- ==========================================

-- Nível 1: Conhecendo a Empresa
INSERT INTO funcionarios (
    funcionario_id, primeiro_nome, sobrenome, email, data_contratacao, 
    cargo_id, salario, moeda_salario, departamento_id, status_funcionario_id
) VALUES (
    999, 'SeuNome', 'SeuSobrenome', 'nome.sobrenome@momento.org', CURRENT_DATE, 
    20, 15000.00, 'USD', 6, 1
);
SELECT COUNT(*) AS total_funcionarios FROM funcionarios;
SELECT COUNT(f.funcionario_id) AS total_ti
FROM funcionarios f JOIN departamentos d ON f.departamento_id = d.departamento_id
WHERE d.departamento_nome = 'Tecnologia da Informação';
SELECT departamento_nome FROM departamentos;
SELECT COUNT(*) AS total_departamentos FROM departamentos;
SELECT COUNT(e.escritorio_id) AS total_escritorios, COUNT(DISTINCT e.pais_id) AS total_paises, GROUP_CONCAT(DISTINCT p.pais_nome) AS paises
FROM escritorios e JOIN paises p ON e.pais_id = p.pais_id;

-- Nível 2: Análise Financeira Básica
SELECT COUNT(f.funcionario_id) AS total_vendas
FROM funcionarios f JOIN departamentos d ON f.departamento_id = d.departamento_id
WHERE d.departamento_nome = 'Vendas';
SELECT SUM(f.salario) AS custo_salarios_vendas
FROM funcionarios f JOIN departamentos d ON f.departamento_id = d.departamento_id
WHERE d.departamento_nome = 'Vendas';
SELECT AVG(f.salario) AS media_salarial
FROM funcionarios f JOIN cargos c ON f.cargo_id = c.cargo_id
WHERE c.cargo_nome NOT IN ('CEO', 'CMO', 'CFO');
SELECT AVG(f.salario) AS media_ti
FROM funcionarios f JOIN departamentos d ON f.departamento_id = d.departamento_id
WHERE d.departamento_nome = 'Tecnologia da Informação';
SELECT d.departamento_nome, AVG(f.salario) AS media_salarial
FROM funcionarios f JOIN departamentos d ON f.departamento_id = d.departamento_id
GROUP BY d.departamento_nome ORDER BY media_salarial DESC LIMIT 1;
SELECT d.departamento_nome, COUNT(f.funcionario_id) AS total_funcionarios
FROM departamentos d LEFT JOIN funcionarios f ON d.departamento_id = f.departamento_id
GROUP BY d.departamento_nome ORDER BY total_funcionarios ASC LIMIT 1;

-- Nível 3: Recursos Humanos
SELECT COUNT(DISTINCT funcionario_id) AS funcionarios_com_conjuge FROM dependentes WHERE relacionamento = 'Cônjuge';
SELECT COUNT(DISTINCT funcionario_id) AS funcionarios_com_filhos FROM dependentes WHERE relacionamento = 'Filha(o)';
SELECT primeiro_nome, sobrenome, data_contratacao FROM funcionarios ORDER BY data_contratacao ASC LIMIT 1;
SELECT primeiro_nome, sobrenome, data_contratacao FROM funcionarios ORDER BY data_contratacao DESC LIMIT 1;
SELECT primeiro_nome, sobrenome, data_contratacao FROM funcionarios ORDER BY data_contratacao ASC LIMIT 5;
SELECT COUNT(*) AS contratacoes_anos_90 FROM funcionarios WHERE YEAR(data_contratacao) BETWEEN 1990 AND 1999;
SELECT YEAR(data_contratacao) AS ano_contratacao, AVG(salario) AS media_salarial
FROM funcionarios GROUP BY YEAR(data_contratacao) ORDER BY ano_contratacao;

-- Nível 4: Operações e Escritórios
SELECT e.escritorio_nome, SUM(s.quantidade_estoque * s.custo_unitario) AS custo_total
FROM suprimentos s JOIN escritorios e ON s.escritorio_id = e.escritorio_id
GROUP BY e.escritorio_nome ORDER BY custo_total DESC;
SELECT e.escritorio_nome, COUNT(DISTINCT s.suprimento_nome) AS diversidade_suprimentos
FROM suprimentos s JOIN escritorios e ON s.escritorio_id = e.escritorio_id
GROUP BY e.escritorio_nome ORDER BY diversidade_suprimentos DESC LIMIT 1;
SELECT suprimento_nome, custo_unitario FROM suprimentos ORDER BY custo_unitario DESC LIMIT 1;
SELECT SUM(quantidade_estoque * custo_unitario) AS valor_inventario_total FROM suprimentos;

-- Nível 5: Produtos e Vendas
SELECT DISTINCT p.produto_nome FROM itens_venda i JOIN produtos p ON i.produto_id = p.produto_id;
SELECT p.produto_nome, SUM(i.quantidade) AS total_vendido
FROM itens_venda i JOIN produtos p ON i.produto_id = p.produto_id
GROUP BY p.produto_nome ORDER BY total_vendido DESC LIMIT 1;
SELECT p.produto_nome, SUM(i.quantidade) AS total_vendido
FROM itens_venda i JOIN produtos p ON i.produto_id = p.produto_id
GROUP BY p.produto_nome ORDER BY total_vendido ASC LIMIT 1;
SELECT p.produto_nome, SUM(i.quantidade * i.preco_unitario) AS receita_total
FROM itens_venda i JOIN produtos p ON i.produto_id = p.produto_id
GROUP BY p.produto_nome ORDER BY receita_total DESC LIMIT 1;
SELECT produto_nome, preco_catalogo FROM produtos ORDER BY preco_catalogo DESC LIMIT 1;
SELECT SUM(quantidade * preco_unitario) AS faturamento_global FROM itens_venda;
SELECT COUNT(*) AS vendas_junho_2023 FROM vendas WHERE data_venda BETWEEN '2023-06-01' AND '2023-06-30';
SELECT f.primeiro_nome, f.sobrenome, COUNT(v.venda_id) AS qtd_vendas
FROM vendas v JOIN funcionarios f ON v.funcionario_id = f.funcionario_id
GROUP BY f.funcionario_id ORDER BY qtd_vendas DESC LIMIT 1;
SELECT f.primeiro_nome, f.sobrenome, SUM(i.quantidade * i.preco_unitario) AS receita_gerada
FROM vendas v JOIN itens_venda i ON v.venda_id = i.venda_id JOIN funcionarios f ON v.funcionario_id = f.funcionario_id
GROUP BY f.funcionario_id ORDER BY receita_gerada DESC LIMIT 1;

-- Nível 6: Operações de Atualização
INSERT INTO departamentos (departamento_id, departamento_nome, educacional, escritorio_id)
VALUES (99, 'Inovações', 0, (SELECT escritorio_id FROM escritorios WHERE escritorio_nome = 'Wayne Offices'));
UPDATE funcionarios SET departamento_id = 99 
WHERE departamento_id = (SELECT departamento_id FROM departamentos WHERE departamento_nome = 'Tecnologia da Informação') LIMIT 2;
UPDATE funcionarios SET salario = salario * 1.10 
WHERE departamento_id = (SELECT departamento_id FROM departamentos WHERE departamento_nome = 'Tecnologia da Informação');
UPDATE funcionarios SET cargo_id = (SELECT cargo_id FROM cargos WHERE cargo_nome = 'Senior Web Developer'), salario = 5000.00 
WHERE primeiro_nome = 'Bruce' AND sobrenome = 'Ernst';
INSERT INTO suprimentos (suprimento_id, referencia_compra, suprimento_nome, quantidade_estoque, custo_unitario, moeda, data_compra, escritorio_id)
VALUES (999, 'PO-NOVO-1', 'Headsets', 15, 150.00, 'USD', CURRENT_DATE, (SELECT escritorio_id FROM escritorios WHERE escritorio_nome = 'Wayne Offices'));
UPDATE funcionarios SET status_funcionario_id = (SELECT status_funcionario_id FROM status_funcionario WHERE nome = 'INATIVO') 
WHERE YEAR(data_contratacao) < 1990;
