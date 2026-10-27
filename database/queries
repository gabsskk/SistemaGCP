-- =========================================
-- PROJETO INTEGRADO - SISTEMA DE PASTAS
-- =========================================

-- 1. Conferir quantidade total de pastas
SELECT COUNT(*) AS Total
FROM pasta;


-- 2. Conferir distribuição dos status
SELECT 
    s.nome AS Status,
    COUNT(*) AS Quantidade
FROM pasta p
JOIN status s 
    ON p.Status_idStatus = s.idStatus
GROUP BY s.idStatus, s.nome
ORDER BY s.idStatus;


-- 3. Visualizar todas as pastas
SELECT
    p.idPasta AS ID,
    e.nome AS Empresa,
    c.nome AS Categoria,
    s.nome AS Status,
    p.dataAbertura AS `Data Abertura`,
    p.dataArquivoMorto AS `Data Arquivo Morto`,
    p.dataEntrega AS `Data Entrega`,
    p.observacao AS Observacao
FROM pasta p
JOIN empresa e
    ON p.Empresa_idEmpresa = e.idEmpresa
JOIN status s
    ON p.Status_idStatus = s.idStatus
JOIN categoria c
    ON p.Categoria_idCategoria = c.idCategoria
ORDER BY p.idPasta;


-- 4. Quantidade de pastas por empresa
SELECT
    e.nome AS Empresa,
    COUNT(*) AS Quantidade
FROM pasta p
JOIN empresa e
    ON p.Empresa_idEmpresa = e.idEmpresa
GROUP BY e.idEmpresa, e.nome
ORDER BY Quantidade DESC;


-- 5. Quantidade por categoria
SELECT
    c.nome AS Categoria,
    COUNT(*) AS Quantidade
FROM pasta p
JOIN categoria c
    ON p.Categoria_idCategoria = c.idCategoria
GROUP BY c.idCategoria, c.nome
ORDER BY Quantidade DESC;