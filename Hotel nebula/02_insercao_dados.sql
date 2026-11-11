-- Hotel Nebula - Dados de teste
USE hotel_nebula;

INSERT INTO hospedes (nome, email, cpf, telefone, data_nascimento, cidade) VALUES
('Ana Souza',       'ana@email.com',     '111.111.111-11', '(11) 91111-1111', '1990-03-15', 'São Paulo'),
('Carlos Mendes',   'carlos@email.com',  '222.222.222-22', '(21) 92222-2222', '1985-07-22', 'Rio de Janeiro'),
('Beatriz Lima',    'bia@email.com',     '333.333.333-33', '(31) 93333-3333', '1992-11-02', 'Belo Horizonte'),
('Daniel Ferreira', 'daniel@email.com',  '444.444.444-44', '(41) 94444-4444', '1978-01-30', 'Curitiba'),
('Elisa Rocha',     'elisa@email.com',   '555.555.555-55', '(51) 95555-5555', '1995-09-09', 'Porto Alegre');

INSERT INTO quartos (numero, tipo, capacidade, preco_diaria, status) VALUES
('101', 'Standard', 2, 180.00, 'Disponível'),
('102', 'Standard', 2, 180.00, 'Disponível'),
('201', 'Luxo',     3, 320.00, 'Disponível'),
('301', 'Suíte',    4, 550.00, 'Ocupado'),
('302', 'Suíte Presidencial', 4, 900.00, 'Manutenção');

INSERT INTO funcionarios (nome, cargo, telefone) VALUES
('Carla Nunes',    'Recepcionista', '(11) 90001-0001'),
('Bruno Alves',    'Recepcionista', '(11) 90002-0002'),
('Ricardo Barros', 'Gerente',       '(11) 90003-0003');

INSERT INTO servicos (nome, descricao, preco) VALUES
('Café da manhã',      'Buffet completo',            45.00),
('Lavanderia',         'Lavagem de roupas',          60.00),
('Massagem',           'Massagem relaxante no spa', 220.00),
('Transfer aeroporto', 'Traslado de ida ou volta',  150.00),
('Room service',       'Refeição no quarto',         85.00);

INSERT INTO reservas (id_hospede, id_quarto, data_checkin, data_checkout, status) VALUES
(1, 1, '2026-08-01', '2026-08-04', 'Concluída'),   -- 1
(2, 3, '2026-08-05', '2026-08-10', 'Concluída'),   -- 2
(3, 4, '2026-09-10', '2026-09-12', 'Concluída'),   -- 3
(1, 2, '2026-10-03', '2026-10-06', 'Concluída'),   -- 4
(4, 1, '2026-10-12', '2026-10-14', 'Cancelada'),   -- 5
(1, 3, '2026-11-05', '2026-11-08', 'Concluída'),   -- 6
(5, 4, '2026-11-10', '2026-11-15', 'Confirmada'),  -- 7 (hospedado agora)
(2, 2, '2026-12-20', '2026-12-23', 'Confirmada'),  -- 8 (futura)
(3, 1, '2026-11-01', '2026-11-03', 'Cancelada');   -- 9

INSERT INTO hospedagens (id_reserva, id_funcionario, checkin_real, checkout_real) VALUES
(1, 1, '2026-08-01 14:00:00', '2026-08-04 11:00:00'),
(2, 2, '2026-08-05 15:00:00', '2026-08-10 10:30:00'),
(3, 1, '2026-09-10 14:30:00', '2026-09-12 11:00:00'),
(4, 2, '2026-10-03 16:00:00', '2026-10-06 10:45:00'),
(6, 1, '2026-11-05 14:00:00', '2026-11-08 11:30:00'),
(7, 1, '2026-11-10 15:00:00', NULL);

INSERT INTO hospedagem_servicos (id_hospedagem, id_servico, quantidade, data_consumo) VALUES
(1, 1, 3, '2026-08-02'),
(2, 3, 2, '2026-08-07'),
(2, 1, 5, '2026-08-06'),
(3, 5, 2, '2026-09-11'),
(4, 2, 1, '2026-10-04'),
(5, 4, 1, '2026-11-08'),
(5, 1, 3, '2026-11-06'),
(6, 1, 1, '2026-11-11');

INSERT INTO pagamentos (id_hospedagem, valor, metodo, data_pagamento) VALUES
(1,  675.00, 'Pix',               '2026-08-04'),
(2, 2265.00, 'Cartão de Crédito', '2026-08-10'),
(3, 1270.00, 'Cartão de Crédito', '2026-09-12'),
(4,  600.00, 'Dinheiro',          '2026-10-06'),
(5, 1245.00, 'Pix',               '2026-11-08'),
(6,  500.00, 'Pix',               '2026-11-10');

INSERT INTO feedbacks (id_hospedagem, nota, comentario, data_avaliacao) VALUES
(1, 5, 'Atendimento excelente!',            '2026-08-05'),
(2, 4, 'Ótima estadia, adorei a massagem.', '2026-08-11'),
(3, 5, 'Suíte impecável.',                  '2026-09-13'),
(4, 4, 'Bom custo-benefício.',              '2026-10-07'),
(5, 3, 'Quarto bom, mas barulhento.',       '2026-11-09');
