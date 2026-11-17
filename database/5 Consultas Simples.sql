-- Q1: Usuários ativos do campus Maracanã ordenados por nome
SELECT id, nome, vinculo_ifrj, identificador, estado_conta
FROM usuarios
WHERE campus = 'Maracanã' AND estado_conta = 'ativa'
ORDER BY nome ASC;

-- Q2: Espaços verdes com área maior que 100 m²
SELECT id, nome, categoria, localizacao, area_m2
FROM espacos_verdes
WHERE area_m2 > 100.00
ORDER BY area_m2 DESC;

-- Q3: Atividades pontuais urgentes ou de alta prioridade que ainda não foram concluídas ou canceladas
SELECT id, espaco_id, tipo, titulo, data_hora, prioridade, situacao
FROM atividades_pontuais
WHERE prioridade IN ('alta', 'urgente')
  AND situacao NOT IN ('Concluída', 'Cancelada')
ORDER BY data_hora ASC;

-- Q4: Rotinas de rega ativas no turno da manhã
SELECT id, espaco_id, dias_semana, horario_turno, orientacoes
FROM rotinas_rega
WHERE ativa = TRUE AND horario_turno = 'manhã';

-- Q5: Ocorrências de rega pendentes ou atrasadas
SELECT id, rotina_id, data_prevista, situacao, observacao
FROM ocorrencias_rega
WHERE situacao IN ('Pendente', 'Atrasada')
ORDER BY data_prevista ASC;