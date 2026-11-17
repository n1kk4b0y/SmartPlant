-- S1 (Operador IN): Usuários que possuem vínculo ativo como 'bolsista' em algum espaço
SELECT id, nome, campus, identificador
FROM usuarios
WHERE id IN (
    SELECT usuario_id
    FROM participacoes_espaco
    WHERE papel = 'bolsista' AND situacao = 'ativa'
);

-- S2 (Operador EXISTS): Espaços verdes que possuem pelo menos uma ocorrência de rega 'Atrasada' ou 'Pendente'
SELECT e.id, e.nome, e.categoria, e.localizacao
FROM espacos_verdes e
WHERE EXISTS (
    SELECT 1
    FROM rotinas_rega r
    INNER JOIN ocorrencias_rega o ON o.rotina_id = r.id
    WHERE r.espaco_id = e.id
      AND o.situacao IN ('Atrasada', 'Pendente')
);

-- S3 (Operador ALL): Espaços verdes cuja área é maior que a área de TODOS os espaços da categoria 'jardim'
SELECT id, nome, categoria, area_m2
FROM espacos_verdes
WHERE area_m2 > ALL (
    SELECT area_m2
    FROM espacos_verdes
    WHERE categoria = 'jardim' AND area_m2 IS NOT NULL
);