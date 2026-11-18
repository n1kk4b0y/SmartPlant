-- =========================================================================
-- APD3: POLÍTICAS DE ADMINISTRAÇÃO, SEGURANÇA E INTEGRIDADE
-- =========================================================================

-- 1. Criação dos Papéis (Roles) personalizados
CREATE ROLE admin_horta;
CREATE ROLE coordenador_horta;
CREATE ROLE usuario_comum;

-- 2. Criação de usuários de teste associados aos papéis 
CREATE USER davi_admin WITH PASSWORD 'admin123';
CREATE USER fabio_coordenador WITH PASSWORD 'coord123';
CREATE USER joao_usuario WITH PASSWORD 'user123';

-- Atribuindo os papéis aos respectivos usuários
GRANT admin_horta TO davi_admin;
GRANT coordenador_horta TO fabio_coordenador;
GRANT usuario_comum TO joao_usuario;


-- 3. Concessão de Privilégios (GRANT / REVOKE)

-- Permissões para o Administrador (Acesso total)
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin_horta;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin_horta;

-- Permissões para o Coordenador (Gerenciamento de atividades e rotinas)
GRANT SELECT, INSERT, UPDATE ON espacos_verdes, atividades_pontuais, rotinas_rega, ocorrencias_rega TO coordenador_horta;
GRANT SELECT ON usuarios, participacoes_espaco TO coordenador_horta;

-- Permissões para o Usuário Comum (Visualização e participação restrita)
GRANT SELECT ON espacos_verdes, atividades_pontuais TO usuario_comum;
GRANT SELECT, INSERT, UPDATE, DELETE ON participacoes_espaco TO usuario_comum;
