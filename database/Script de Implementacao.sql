-- =====================================================================
-- (i) SCRIPT DE IMPLEMENTAÇÃO DO BANCO DE DADOS RELACIONAL (DDL)
-- =====================================================================

CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    vinculo_ifrj VARCHAR(20) NOT NULL CHECK (vinculo_ifrj IN ('servidor', 'estudante', 'terceirizado', 'outro')),
    campus VARCHAR(80) NOT NULL,
    identificador VARCHAR(80) NOT NULL UNIQUE,
    credencial VARCHAR(255) NOT NULL,
    estado_conta VARCHAR(20) NOT NULL DEFAULT 'ativa' CHECK (estado_conta IN ('ativa', 'pendente', 'inativa', 'bloqueada')),
    identificador_validado BOOLEAN NOT NULL DEFAULT FALSE,
    data_cadastro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE espacos_verdes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    categoria VARCHAR(20) NOT NULL CHECK (categoria IN ('horta', 'jardim', 'outro')),
    localizacao VARCHAR(150) NOT NULL,
    descricao TEXT,
    culturas_plantios TEXT NOT NULL,
    coordenador_id INTEGER NOT NULL,
    contatos VARCHAR(150),
    area_m2 NUMERIC(8,2) CHECK (area_m2 > 0),
    CONSTRAINT fk_espaco_coordenador
        FOREIGN KEY (coordenador_id) REFERENCES usuarios (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE participacoes_espaco (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER NOT NULL,
    espaco_id INTEGER NOT NULL,
    papel VARCHAR(20) NOT NULL CHECK (papel IN ('coordenador', 'bolsista', 'voluntário')),
    data_inicio DATE NOT NULL,
    situacao VARCHAR(15) NOT NULL DEFAULT 'ativa' CHECK (situacao IN ('ativa', 'inativa')),
    CONSTRAINT fk_part_usuario
        FOREIGN KEY (usuario_id) REFERENCES usuarios (id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_part_espaco
        FOREIGN KEY (espaco_id) REFERENCES espacos_verdes (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT uq_usuario_espaco_papel UNIQUE (usuario_id, espaco_id, papel)
);

CREATE TABLE atividades_pontuais (
    id SERIAL PRIMARY KEY,
    espaco_id INTEGER NOT NULL,
    tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('plantio', 'semeadura', 'limpeza', 'manutenção', 'colheita', 'mutirão')),
    titulo VARCHAR(140) NOT NULL,
    descricao TEXT,
    data_hora TIMESTAMP NOT NULL,
    prioridade VARCHAR(15) NOT NULL DEFAULT 'média' CHECK (prioridade IN ('baixa', 'média', 'alta', 'urgente')),
    situacao VARCHAR(15) NOT NULL DEFAULT 'Pendente' CHECK (situacao IN ('Pendente', 'Aceita', 'Concluída', 'Cancelada')),
    CONSTRAINT fk_ativ_espaco
        FOREIGN KEY (espaco_id) REFERENCES espacos_verdes (id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE rotinas_rega (
    id SERIAL PRIMARY KEY,
    espaco_id INTEGER NOT NULL,
    dias_semana VARCHAR(80) NOT NULL,
    horario_turno VARCHAR(20) NOT NULL CHECK (horario_turno IN ('manhã', 'tarde', 'noite')),
    orientacoes TEXT NOT NULL,
    ativa BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_rotina_espaco
        FOREIGN KEY (espaco_id) REFERENCES espacos_verdes (id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE ocorrencias_rega (
    id SERIAL PRIMARY KEY,
    rotina_id INTEGER NOT NULL,
    data_prevista DATE NOT NULL,
    situacao VARCHAR(15) NOT NULL DEFAULT 'Pendente' CHECK (situacao IN ('Pendente', 'Concluída', 'Atrasada', 'Cancelada')),
    observacao VARCHAR(255),
    CONSTRAINT fk_ocorrencia_rotina
        FOREIGN KEY (rotina_id) REFERENCES rotinas_rega (id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

