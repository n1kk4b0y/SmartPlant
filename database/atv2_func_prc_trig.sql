-- =========================================================================
-- APD2: PROGRAMAÇÃO PROCEDURAL (FUNCTIONS, PROCEDURES E TRIGGERS)
-- =========================================================================

-- -------------------------------------------------------------------------
-- 1. FUNCTIONS (Funções)
-- -------------------------------------------------------------------------

-- Função 1: Conta o total de atividades pontuais cadastradas em um espaço verde
CREATE OR REPLACE FUNCTION fn_conta_atividades_espaco(p_espaco_id INT)
RETURNS INT AS $$
DECLARE
    v_total INT;
BEGIN
    SELECT COUNT(*) INTO v_total
    FROM atividades_pontuais
    WHERE espaco_id = p_espaco_id;
    
    RETURN v_total;
END;
$$ LANGUAGE plpgsql;

-- Função 2: Conta quantos usuários estão associados ativamente a um determinado espaço
CREATE OR REPLACE FUNCTION fn_total_participantes(p_espaco_id INT)
RETURNS INT AS $$
DECLARE
    v_total INT;
BEGIN
    SELECT COUNT(*) INTO v_total
    FROM participacoes_espaco
    WHERE espaco_id = p_espaco_id AND situacao = 'Ativo';
    
    RETURN v_total;
END;
$$ LANGUAGE plpgsql;

-- Função 3: Verifica se um usuário é o coordenador de um espaço verde específico
CREATE OR REPLACE FUNCTION fn_verifica_coordenador(p_usuario_id INT, p_espaco_id INT)
RETURNS BOOLEAN AS $$
DECLARE
    v_encontrado INT;
BEGIN
    SELECT COUNT(*) INTO v_encontrado
    FROM espacos_verdes
    WHERE id = p_espaco_id AND coordenador_id = p_usuario_id;
    
    RETURN v_encontrado > 0;
END;
$$ LANGUAGE plpgsql;


-- -------------------------------------------------------------------------
-- 2. PROCEDURES (Procedimentos)
-- -------------------------------------------------------------------------

-- Procedure 1: Insere uma nova ocorrência de rega associada a uma rotina
CREATE OR REPLACE PROCEDURE prc_insere_ocorrencia_lote(
    p_rotina_id INT,
    p_data_prevista DATE,
    p_observacao TEXT
)
AS $$
BEGIN
    INSERT INTO ocorrencias_rega (rotina_id, data_prevista, situacao, observacao)
    VALUES (p_rotina_id, p_data_prevista, 'Pendente', p_observacao);
END;
$$ LANGUAGE plpgsql;

-- Procedure 2: Atualiza a situação de uma atividade pontual
CREATE OR REPLACE PROCEDURE prc_atualizar_situacao_atividade(
    p_ativ_id INT,
    p_nova_situacao VARCHAR
)
AS $$
BEGIN
    UPDATE atividades_pontuais
    SET situacao = p_nova_situacao
    WHERE id = p_ativ_id;
END;
$$ LANGUAGE plpgsql;

-- Procedure 3: Desativa uma rotina de rega alterando o status para falso
CREATE OR REPLACE PROCEDURE prc_desativar_rotina_rega(
    p_rotina_id INT
)
AS $$
BEGIN
    UPDATE rotinas_rega
    SET ativa = FALSE
    WHERE id = p_rotina_id;
END;
$$ LANGUAGE plpgsql;


-- -------------------------------------------------------------------------
-- 3. TRIGGERS E FUNÇÕES DE GATILHO (Triggers)
-- -------------------------------------------------------------------------

-- Função auxiliar para validar o coordenador do espaço verde antes de inserir/atualizar
CREATE OR REPLACE FUNCTION trg_fn_valida_coordenador_espaco()
RETURNS TRIGGER AS $$
BEGIN
    -- Verifica se o usuário informado na coluna coordenador_id possui estado de conta ativo
    IF NEW.coordenador_id IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM usuarios WHERE id = NEW.coordenador_id AND estado_conta = 'Ativo') THEN
            RAISE EXCEPTION 'O usuário selecionado não está ativo ou não existe para ser coordenador.';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger 1: Acionada antes de inserir ou atualizar um espaço verde
CREATE TRIGGER trg_valida_coordenador_espaco
BEFORE INSERT OR UPDATE ON espacos_verdes
FOR EACH ROW
EXECUTE FUNCTION trg_fn_valida_coordenador_espaco();


-- Função auxiliar para auditoria ou ajuste de datas em atividades
CREATE OR REPLACE FUNCTION trg_fn_audita_situacao_atividade()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.situacao <> NEW.situacao THEN
        -- Aqui podemos registrar log ou tratar eventos da mudança de situação
        RAISE NOTICE 'A atividade ID % alterou a situação de % para %', NEW.id, OLD.situacao, NEW.situacao;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger 2: Acionada após atualizar a situação de uma atividade pontual
CREATE TRIGGER trg_audita_alteracao_atividade
AFTER UPDATE ON atividades_pontuais
FOR EACH ROW
EXECUTE FUNCTION trg_fn_audita_situacao_atividade();


-- Função auxiliar para gerar a primeira ocorrência automática de rega
CREATE OR REPLACE FUNCTION trg_fn_gera_primeira_ocorrencia()
RETURNS TRIGGER AS $$
BEGIN
    -- Insere automaticamente a primeira ocorrência de rega para a data atual ao criar uma rotina
    INSERT INTO ocorrencias_rega (rotina_id, data_prevista, situacao, observacao)
    VALUES (NEW.id, CURRENT_DATE, 'Pendente', 'Gerado automaticamente ao criar a rotina de rega.');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger 3: Acionada após inserir uma nova rotina de rega
CREATE TRIGGER trg_gera_primeira_ocorrencia
AFTER INSERT ON rotinas_rega
FOR EACH ROW
EXECUTE FUNCTION trg_fn_gera_primeira_ocorrencia();