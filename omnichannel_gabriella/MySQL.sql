-- Exemplo de estrutura DDL e DCL no MySQL
CREATE DATABASE IF NOT EXISTS omnichannel_db;
USE omnichannel_db;

CREATE TABLE produtos (
id_produto INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(100) NOT NULL,
preco DECIMAL(10,2) NOT NULL,
estoque_atual INT NOT NULL DEFAULT 0
);

-- Criacao de usuario e concessao de acesso (DCL)
CREATE USER IF NOT EXISTS 'atendente_omni'@'localhost' IDENTIFIED BY 'Senha123!';
GRANT SELECT ON omnichannel_db.produtos TO 'atendente_omni'@'localhost';
FLUSH PRIVILEGES;
-- Exemplo de Povoamento DML
INSERT INTO produtos (nome, preco, estoque_atual) VALUES
('Smartphone Galaxy S23', 4500.00, 15),
('Notebook Dell Inspiron', 3800.00, 8),
('Fone de Ouvido Bluetooth', 250.00, 30);
-- Exemplo de Trigger de Auditoria de Preços no MySQL
DELIMITER //
CREATE TRIGGER trg_auditoria_preco
AFTER UPDATE ON produtos
FOR EACH ROW
BEGIN
IF OLD.preco <> NEW.preco THEN
INSERT INTO auditoria_preco (id_produto, preco_antigo, preco_novo, data_alteracao, usuario)
VALUES (OLD.id_produto, OLD.preco, NEW.preco, NOW(), USER());
END IF;
END //
DELIMITER ;