-- usuario 

SET ROLE usuario_comum;
DELETE FROM espacos_verdes WHERE id = 1;
RESET ROLE;


-- administrador
SET ROLE admin_horta;
SELECT * FROM usuarios;
RESET ROLE;
-- coordenador

INSERT INTO atividades_pontuais (espaco_id, tipo, titulo, descricao, data_hora, prioridade, situacao) 
VALUES (1, 'manutenção', 'Poda de Mudas', 'Realizar poda das folhas secas', '2026-11-20 09:00:00', 'alta', 'Pendente');;
RESET ROLE;
