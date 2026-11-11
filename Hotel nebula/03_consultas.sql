-- Hotel Nebula - Consultas
USE hotel_nebula;

-- 1) Quartos disponíveis em um período (ex: 20/12/2026 a 25/12/2026)
-- Pega todos os quartos que NÃO têm reserva (não cancelada) batendo com o período.
SELECT numero, tipo, preco_diaria
FROM quartos
WHERE status <> 'Manutenção'
  AND id_quarto NOT IN (
      SELECT id_quarto
      FROM reservas
      WHERE status <> 'Cancelada'
        AND data_checkin  < '2026-12-25'
        AND data_checkout > '2026-12-20'
  );

-- 2) Hóspedes que mais fizeram reservas
SELECT h.nome, COUNT(*) AS total_reservas
FROM hospedes h
JOIN reservas r ON r.id_hospede = h.id_hospede
GROUP BY h.id_hospede, h.nome
ORDER BY total_reservas DESC;

-- 3) Faturamento por mês
SELECT DATE_FORMAT(data_pagamento, '%Y-%m') AS mes,
       SUM(valor) AS faturamento
FROM pagamentos
GROUP BY mes
ORDER BY mes;

-- 4) Serviços extras mais consumidos
SELECT s.nome, SUM(hs.quantidade) AS total_consumido
FROM servicos s
JOIN hospedagem_servicos hs ON hs.id_servico = s.id_servico
GROUP BY s.id_servico, s.nome
ORDER BY total_consumido DESC;

-- 5) Quartos com melhores avaliações
SELECT q.numero, q.tipo, AVG(f.nota) AS nota_media
FROM feedbacks f
JOIN hospedagens hg ON hg.id_hospedagem = f.id_hospedagem
JOIN reservas r     ON r.id_reserva = hg.id_reserva
JOIN quartos q      ON q.id_quarto = r.id_quarto
GROUP BY q.id_quarto, q.numero, q.tipo
ORDER BY nota_media DESC;

-- 6) Reservas canceladas
SELECT r.id_reserva, h.nome AS hospede, q.numero AS quarto,
       r.data_checkin, r.data_checkout
FROM reservas r
JOIN hospedes h ON h.id_hospede = r.id_hospede
JOIN quartos q  ON q.id_quarto = r.id_quarto
WHERE r.status = 'Cancelada';

-- 7) Quantas hospedagens cada profissional atendeu
SELECT f.nome, f.cargo, COUNT(hg.id_hospedagem) AS total_atendimentos
FROM funcionarios f
LEFT JOIN hospedagens hg ON hg.id_funcionario = f.id_funcionario
GROUP BY f.id_funcionario, f.nome, f.cargo
ORDER BY total_atendimentos DESC;
