-- ==========================================
-- NÍVEL 1: Conhecendo a Base de Dados
-- ==========================================

-- 1.1 Quantos registros existem na tabela de indicados ao Oscar?
SELECT COUNT(*) FROM indicados_ao_oscar;

-- 1.2.1 Quais são as diferentes categorias de premiação que existem no banco de dados? Liste todas as categorias únicas.
SELECT DISTINCT categoria FROM indicados_ao_oscar;

-- 1.2.2 Quantas categorias únicas existem?
SELECT COUNT(DISTINCT categoria) FROM indicados_ao_oscar;

-- 1.3 Qual foi o primeiro ano de cerimônia do Oscar registrado na base?
SELECT MIN(ano_cerimonia) FROM indicados_ao_oscar;

-- 1.4 Qual foi o último ano de cerimônia registrado na base?
SELECT MAX(ano_cerimonia) FROM indicados_ao_oscar;

-- 1.5 Quantas cerimônias do Oscar estão registradas no total?
SELECT COUNT(DISTINCT ano_cerimonia) FROM indicados_ao_oscar;

-- 1.6 Atualize os registros da tabela com os dados do Oscar 2025 e 2026 (pesquise os vencedores e adicione-os).
-- (Nota: Exemplo de sintaxe. O Oscar 2026 ainda não ocorreu.)
INSERT INTO indicados_ao_oscar (ano_cerimonia, categoria, nome_indicado, nome_filme, vencedor)
VALUES 
(2025, 'BEST PICTURE', 'Nome do Filme Vencedor', 'Nome do Filme Vencedor', true),
(2025, 'ACTOR IN A LEADING ROLE', 'Nome do Ator Indicado', 'Nome do Filme', false);


-- ==========================================
-- NÍVEL 2: Explorando Categorias
-- ==========================================

-- 2.1 Quantas indicações existem para cada categoria? Agrupe por categoria e ordene da mais frequente para a menos frequente.
SELECT categoria, COUNT(*) AS total_indicacoes 
FROM indicados_ao_oscar 
GROUP BY categoria 
ORDER BY total_indicacoes DESC;

-- 2.2 Qual categoria teve mais indicações ao longo da história do Oscar?
SELECT categoria, COUNT(*) AS total_indicacoes 
FROM indicados_ao_oscar 
GROUP BY categoria 
ORDER BY total_indicacoes DESC 
LIMIT 1;

-- 2.3 Qual categoria teve menos indicações ao longo da história?
SELECT categoria, COUNT(*) AS total_indicacoes 
FROM indicados_ao_oscar 
GROUP BY categoria 
ORDER BY total_indicacoes ASC 
LIMIT 1;

-- 2.4 A partir de que ano a categoria "ACTRESS" deixou de existir?
SELECT MAX(ano_cerimonia) AS ultimo_ano_actress 
FROM indicados_ao_oscar 
WHERE categoria = 'ACTRESS';

-- 2.5 Quais categorias existiam na primeira cerimônia (1928) e não existem mais hoje?
SELECT DISTINCT categoria 
FROM indicados_ao_oscar 
WHERE ano_cerimonia = (SELECT MIN(ano_cerimonia) FROM indicados_ao_oscar)
AND categoria NOT IN (
    SELECT DISTINCT categoria 
    FROM indicados_ao_oscar 
    WHERE ano_cerimonia = (SELECT MAX(ano_cerimonia) FROM indicados_ao_oscar)
);

-- 2.6 Liste todas as categorias que contêm a palavra "DIRECTING" no nome.
SELECT DISTINCT categoria 
FROM indicados_ao_oscar 
WHERE categoria LIKE '%DIRECTING%';


-- ==========================================
-- NÍVEL 3: Atores e Atrizes Famosos
-- ==========================================

-- 3.1 Quantas vezes Natalie Portman foi indicada ao Oscar?
SELECT COUNT(*) 
FROM indicados_ao_oscar 
WHERE nome_indicado = 'Natalie Portman';

-- 3.2 Quantos Oscars Natalie Portman ganhou?
SELECT COUNT(*) 
FROM indicados_ao_oscar 
WHERE nome_indicado = 'Natalie Portman' AND vencedor = true;

-- 3.3 Em quais anos e por quais filmes Natalie Portman foi indicada?
SELECT ano_cerimonia, nome_filme 
FROM indicados_ao_oscar 
WHERE nome_indicado = 'Natalie Portman';

-- 3.4 Liste todas as indicações de Natalie Portman mostrando: ano, categoria, filme e se venceu.
SELECT ano_cerimonia, categoria, nome_filme, vencedor 
FROM indicados_ao_oscar 
WHERE nome_indicado = 'Natalie Portman';

-- 3.5 Quantas vezes Viola Davis foi indicada ao Oscar?
SELECT COUNT(*) 
FROM indicados_ao_oscar 
WHERE nome_indicado LIKE '%Viola Davis%';

-- 3.6 Quantos Oscars Viola Davis ganhou?
SELECT COUNT(*) 
FROM indicados_ao_oscar 
WHERE nome_indicado LIKE '%Viola Davis%' AND vencedor = true;

-- 3.7 Por quais filmes Viola Davis foi indicada?
SELECT nome_filme 
FROM indicados_ao_oscar 
WHERE nome_indicado LIKE '%Viola Davis%';

-- 3.8 Amy Adams já ganhou algum Oscar?
SELECT COUNT(*) 
FROM indicados_ao_oscar 
WHERE nome_indicado = 'Amy Adams' AND vencedor = true; 

-- 3.9 Quantas vezes Amy Adams foi indicada sem ganhar?
SELECT COUNT(*) 
FROM indicados_ao_oscar 
WHERE nome_indicado = 'Amy Adams' AND vencedor = false;

-- 3.10 Denzel Washington já ganhou algum Oscar?
SELECT COUNT(*) 
FROM indicados_ao_oscar 
WHERE nome_indicado = 'Denzel Washington' AND vencedor = true;

-- 3.11 Quantas vezes Denzel Washington foi indicado ao Oscar?
SELECT COUNT(*) 
FROM indicados_ao_oscar 
WHERE nome_indicado = 'Denzel Washington';

-- 3.12 Liste todos os Oscars que Denzel Washington ganhou (ano, categoria, filme).
SELECT ano_cerimonia, categoria, nome_filme 
FROM indicados_ao_oscar 
WHERE nome_indicado = 'Denzel Washington' AND vencedor = true;


-- ==========================================
-- NÍVEL 4: Vencedores Históricos
-- ==========================================

-- 4.1 Quem ganhou o primeiro Oscar para Melhor Atriz (ACTRESS)? Em que ano e por qual filme?
SELECT nome_indicado, ano_cerimonia, nome_filme 
FROM indicados_ao_oscar 
WHERE categoria = 'ACTRESS' AND vencedor = true 
ORDER BY ano_cerimonia ASC 
LIMIT 1;

-- 4.2 Quem ganhou o primeiro Oscar para Melhor Ator (ACTOR)? Em que ano e por qual filme?
SELECT nome_indicado, ano_cerimonia, nome_filme 
FROM indicados_ao_oscar 
WHERE categoria = 'ACTOR' AND vencedor = true 
ORDER BY ano_cerimonia ASC 
LIMIT 1;

-- 4.3 Quantos vencedores existem ao todo na base de dados?
SELECT COUNT(*) 
FROM indicados_ao_oscar 
WHERE vencedor = true;

-- 4.4 Liste todos os filmes que ganharam o Oscar de Melhor Filme (categoria "OUTSTANDING PICTURE" ou "BEST PICTURE").
SELECT nome_filme 
FROM indicados_ao_oscar 
WHERE categoria IN ('OUTSTANDING PICTURE', 'BEST PICTURE') AND vencedor = true;

-- 4.5 Quantos filmes diferentes já ganharam o Oscar?
SELECT COUNT(DISTINCT nome_filme) 
FROM indicados_ao_oscar 
WHERE categoria IN ('OUTSTANDING PICTURE', 'BEST PICTURE') AND vencedor = true;


-- ==========================================
-- NÍVEL 5: Análise de Indicações
-- ==========================================

-- 5.1 Quais atores/atrizes foram indicados mais de uma vez? Liste o nome e o número de indicações.
SELECT nome_indicado, COUNT(*) AS numero_indicacoes 
FROM indicados_ao_oscar 
GROUP BY nome_indicado 
HAVING COUNT(*) > 1;

-- 5.2 Qual ator ou atriz tem o maior número de indicações na história do Oscar?
SELECT nome_indicado, COUNT(*) AS total_indicacoes 
FROM indicados_ao_oscar 
GROUP BY nome_indicado 
ORDER BY total_indicacoes DESC 
LIMIT 1;

-- 5.3 Quais atores foram indicados mais de 3 vezes, mas nunca ganharam?
SELECT nome_indicado 
FROM indicados_ao_oscar 
GROUP BY nome_indicado 
HAVING COUNT(*) > 3 
AND SUM(CASE WHEN vencedor = true THEN 1 ELSE 0 END) = 0;

-- 5.4 Encontre todos os artistas que foram indicados em categorias diferentes (ex: ator e diretor).
SELECT nome_indicado 
FROM indicados_ao_oscar 
GROUP BY nome_indicado 
HAVING COUNT(DISTINCT categoria) > 1;

-- 5.5 Quantos indicados têm exatamente 1 indicação na história?
SELECT COUNT(*) 
FROM (
    SELECT nome_indicado 
    FROM indicados_ao_oscar 
    GROUP BY nome_indicado 
    HAVING COUNT(*) = 1
) AS unicos;

-- 5.6 Qual o maior números de indicados em um único ano?
SELECT ano_cerimonia, COUNT(*) AS total_indicados 
FROM indicados_ao_oscar 
GROUP BY ano_cerimonia 
ORDER BY total_indicados DESC 
LIMIT 1;


-- ==========================================
-- NÍVEL 6: Análise de Filmes
-- ==========================================

-- 6.1 A série de filmes Toy Story ganhou Oscars em quais anos?
SELECT DISTINCT ano_cerimonia 
FROM indicados_ao_oscar 
WHERE nome_filme LIKE '%Toy Story%' AND vencedor = true;

-- 6.2 Quantas indicações a franquia Toy Story recebeu no total?
SELECT COUNT(*) 
FROM indicados_ao_oscar 
WHERE nome_filme LIKE '%Toy Story%';

-- 6.3 Em quais categorias os filmes Toy Story foram indicados?
SELECT DISTINCT categoria 
FROM indicados_ao_oscar 
WHERE nome_filme LIKE '%Toy Story%';

-- 6.4 Em qual edição do Oscar o filme "Crash" concorreu?
SELECT DISTINCT ano_cerimonia 
FROM indicados_ao_oscar 
WHERE nome_filme = 'Crash';

-- 6.5 Quantas indicações o filme "Crash" recebeu?
SELECT COUNT(*) 
FROM indicados_ao_oscar 
WHERE nome_filme = 'Crash';

-- 6.6 "Crash" ganhou o Oscar de Melhor Filme?
SELECT vencedor 
FROM indicados_ao_oscar 
WHERE nome_filme = 'Crash' AND categoria = 'BEST PICTURE';

-- 6.7 O filme "Central do Brasil" aparece no banco de dados?
SELECT CASE 
    WHEN COUNT(*) > 0 THEN 'Sim' 
    ELSE 'Não' 
END AS existe 
FROM indicados_ao_oscar 
WHERE nome_filme = 'Central do Brasil';

-- 6.8 Se sim, quantas indicações "Central do Brasil" recebeu?
SELECT COUNT(*) 
FROM indicados_ao_oscar 
WHERE nome_filme = 'Central do Brasil';
