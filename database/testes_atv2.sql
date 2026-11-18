-- 1
SELECT fn_conta_atividades_espaco(1);
-- 2
SELECT fn_total_participantes(1);
-- 3
SELECT fn_verifica_coordenador(5, 1);
-- 4
CALL prc_insere_ocorrencia_lote(1, '2026-11-20', 'Rega manual realizada no período da tarde.');
SELECT * FROM ocorrencias_rega ORDER BY id DESC LIMIT 1;
-- 5 
CALL prc_desativar_rotina_rega(1);
SELECT id, ativa FROM rotinas_rega WHERE id = 1;
-- 6 
CALL prc_desativar_rotina_rega(1);
SELECT id, ativa FROM rotinas_rega WHERE id = 1;
-- 7
UPDATE espacos_verdes SET coordenador_id = 9999 WHERE id = 1;
-- 8
UPDATE atividades_pontuais SET situacao = 'Aceita' WHERE id = 2;
-- 9
INSERT INTO rotinas_rega (espaco_id, dias_semana, horario_turno, orientacoes, ativa) 
VALUES (1, 'Segunda e Quarta', 'manhã', 'Regar as mudas com cuidado', TRUE);
SELECT * FROM ocorrencias_rega ORDER BY id DESC LIMIT 1;
