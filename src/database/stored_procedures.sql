-- PROCEDURE DA GENERALIZACAO DE MONSTRO

CREATE OR REPLACE FUNCTION check_especializacao_monstro() RETURNS TRIGGER AS $check_especializacao_monstro$
DECLARE 
    _tipo_npc TIPO_NPC;
BEGIN

    SELECT tipo_npc INTO _tipo_npc FROM npc WHERE npc.id = NEW.id_npc_monstro;

    IF _tipo_npc <> 'monstro' THEN
			RAISE EXCEPTION 'Apenas NPCS do tipo monstro pode ser inseridos nessa tabela.';
    END IF;

    PERFORM * FROM monstro WHERE id_npc_monstro = NEW.id_npc_monstro;
    IF FOUND THEN 
			RAISE EXCEPTION 'Já existe um monstro com esse id_npc_monstro';
    END IF;
    RETURN NEW;

END;
$check_especializacao_monstro$ LANGUAGE plpgsql;

CREATE TRIGGER check_monstro
BEFORE UPDATE OR INSERT ON monstro
FOR EACH ROW EXECUTE PROCEDURE check_especializacao_monstro();



-- procedure para checar especializacao arma

CREATE OR REPLACE FUNCTION check_especializacao_arma() RETURNS TRIGGER AS $check_especializacao_arma$
DECLARE 
    _tipo_item TIPO_ITEM;
BEGIN

    SELECT tipo_item INTO _tipo_item FROM item WHERE item.id = NEW.id_item;

    IF _tipo_item <> 'arma' THEN
			RAISE EXCEPTION 'Apenas items do tipo arma pode ser inseridos nessa tabela.';
    END IF;

    PERFORM * FROM arma WHERE id_item = NEW.id_npc_monstro;
    IF FOUND THEN 
			RAISE EXCEPTION 'Já existe uma arma com esse id_item';
    END IF;
    RETURN NEW;

END;
$check_especializacao_arma$ LANGUAGE plpgsql;

CREATE TRIGGER check_arma
BEFORE UPDATE OR INSERT ON arma
FOR EACH ROW EXECUTE PROCEDURE check_especializacao_arma();




-- procedure para checar item
CREATE OR REPLACE FUNCTION check_item() RETURNS TRIGGER AS $check_item$
DECLARE 
    _tipo_item TIPO_ITEM;
BEGIN


		IF NEW.tipo_item = 'arma' THEN
 				PERFORM * FROM arma WHERE id_item = NEW.id;
    		IF NOT FOUND THEN 
					RAISE EXCEPTION 'Não pode ser criado um item do tipo arma sem adicionar na tabela arma';
    		END IF;
    END IF;

		IF NEW.tipo_item = 'amuleto' THEN
 				PERFORM * FROM amuleto WHERE id_item = NEW.id;
    		IF NOT FOUND THEN 
					RAISE EXCEPTION 'Não pode ser criado um item do tipo amuleto sem adicionar na tabela amuleto';
    		END IF;
    END IF;

		IF NEW.tipo_item = 'armadura' THEN
 				PERFORM * FROM amuleto WHERE id_item = NEW.id;
    		IF NOT FOUND THEN 
					RAISE EXCEPTION 'Não pode ser criado um item do tipo armadura sem adicionar na tabela armadura';
    		END IF;
    END IF;

    RETURN NEW;

END;
$check_item$ LANGUAGE plpgsql;

CREATE TRIGGER check_items
BEFORE UPDATE OR INSERT ON item
FOR EACH ROW EXECUTE PROCEDURE check_item();
 
-- Procedure de criação de nova arma
CREATE OR REPLACE PROCEDURE cria_nova_arma (_nome_arma VARCHAR, _descricao_arma VARCHAR, _valor_arma INTEGER, _arma_dano INTEGER)
AS $$
  DECLARE
    _id_item INTEGER;
  BEGIN
    INSERT INTO item (nome, tipo_item, descricao, valor_moedas) 
    VALUES (_nome_arma, 'arma', _descricao_arma, _valor_arma) RETURNING id INTO [_id_item],

    INSERT INTO arma(id_item, dano) VALUES
    (_id_item, _arma_dano),
  END;
$$ LANGUAGE plpgsql;

-- Procedure de criação de nova armadura
CREATE OR REPLACE PROCEDURE cria_nova_armadura (_nome_armadura VARCHAR, _descricao_armadura VARCHAR, _valor_armadura INTEGER, _armadura_dano INTEGER)
AS $$
  DECLARE
    _id_item INTEGER;
  BEGIN
    INSERT INTO item (nome, tipo_item, descricao, valor_moedas) 
    VALUES (_nome_armadura, 'armadura', _descricao_armadura, _valor_armadura) RETURNING id INTO [_id_item],

    INSERT INTO armadura(id_item, dano) VALUES
    (_id_item, _armadura_dano),
  END;
$$ LANGUAGE plpgsql;

-- Procedure de criação de novo amuleto
CREATE OR REPLACE PROCEDURE cria_nova_amuleto (_nome_amuleto VARCHAR, _descricao_amuleto VARCHAR, _valor_amuleto INTEGER, _amuleto_dano INTEGER)
AS $$
  DECLARE
    _id_item INTEGER;
  BEGIN
    INSERT INTO item (nome, tipo_item, descricao, valor_moedas) 
    VALUES (_nome_amuleto, 'amuleto', _descricao_amuleto, _valor_amuleto) RETURNING id INTO [_id_item],

    INSERT INTO amuleto(id_item, dano) VALUES
    (_id_item, _amuleto_dano),
  END;
$$ LANGUAGE plpgsql;