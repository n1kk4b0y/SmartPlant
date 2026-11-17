-- J1: Quantidade de participações ativas por espaço verde e categoria (filtrando espaços com pelo menos 2 participantes)
SELECT
    e.id AS espaco_id,
    e.nome AS espaco_nome,
    e.categoria,
    COUNT(p.id) AS total_participantes_ativos
FROM espacos_verdes e
INNER JOIN participacoes_espaco p ON p.espaco_id = e.id
WHERE p.situacao = 'ativa'
GROUP BY e.id, e.nome, e.categoria
HAVING COUNT(p.id) >= 2
ORDER BY total_participantes_ativos DESC, e.nome ASC;

-- J2: Total de atividades pontuais por espaço e tipo, filtrando grupos com ao menos 1 atividade
SELECT
    e.nome AS espaco_nome,
    u.nome AS coordenador_nome,
    a.tipo,
    COUNT(a.id) AS qtd_atividades
FROM atividades_pontuais a
INNER JOIN espacos_verdes e ON e.id = a.espaco_id
INNER JOIN usuarios u ON u.id = e.coordenador_id
GROUP BY e.id, e.nome, u.nome, a.tipo
HAVING COUNT(a.id) >= 1
ORDER BY qtd_atividades DESC, e.nome ASC;

-- J3: Contagem de ocorrências de rega por espaço e situação, filtrando espaços com 2 ou mais ocorrências registradas
SELECT
    e.nome AS espaco_nome,
    o.situacao,
    COUNT(o.id) AS total_ocorrencias
FROM ocorrencias_rega o
INNER JOIN rotinas_rega r ON r.id = o.rotina_id
INNER JOIN espacos_verdes e ON e.id = r.espaco_id
GROUP BY e.id, e.nome, o.situacao
HAVING COUNT(o.id) >= 2
ORDER BY total_ocorrencias DESC;