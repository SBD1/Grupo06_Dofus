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


-- procedure para checar especializacao amuleto
CREATE OR REPLACE FUNCTION check_especializacao_amuleto() RETURNS TRIGGER AS $check_especializacao_amuleto$
DECLARE 
    _tipo_item TIPO_ITEM;
BEGIN

    SELECT tipo_item INTO _tipo_item FROM item WHERE item.id = NEW.id_item;

    IF _tipo_item <> 'amuleto' THEN
			RAISE EXCEPTION 'Apenas items do tipo amuleto pode ser inseridos nessa tabela.';
    END IF;

    PERFORM * FROM amuleto WHERE id_item = NEW.id_item;
    IF FOUND THEN 
			RAISE EXCEPTION 'Já existe uma amuleto com esse id_item';
    END IF;
    RETURN NEW;

END;
$check_especializacao_amuleto$ LANGUAGE plpgsql;

CREATE TRIGGER check_amuleto
BEFORE UPDATE OR INSERT ON amuleto
FOR EACH ROW EXECUTE PROCEDURE check_especializacao_amuleto();

-- procedure para checar especializacao armadura
CREATE OR REPLACE FUNCTION check_especializacao_armadura() RETURNS TRIGGER AS $check_especializacao_armadura$
DECLARE 
    _tipo_item TIPO_ITEM;
BEGIN

    SELECT tipo_item INTO _tipo_item FROM item WHERE item.id = NEW.id_item;

    IF _tipo_item <> 'armadura' THEN
			RAISE EXCEPTION 'Apenas items do tipo armadura pode ser inseridos nessa tabela.';
    END IF;

    PERFORM * FROM armadura WHERE id_item = NEW.id_item;
    IF FOUND THEN 
			RAISE EXCEPTION 'Já existe uma armadura com esse id_item';
    END IF;
    RETURN NEW;

END;
$check_especializacao_armadura$ LANGUAGE plpgsql;

CREATE TRIGGER check_armadura
BEFORE UPDATE OR INSERT ON armadura
FOR EACH ROW EXECUTE PROCEDURE check_especializacao_armadura();


-- procedure para checar especializacao arma
CREATE OR REPLACE FUNCTION check_especializacao_arma() RETURNS TRIGGER AS $check_especializacao_arma$
DECLARE 
    _tipo_item TIPO_ITEM;
BEGIN

    SELECT tipo_item INTO _tipo_item FROM item WHERE item.id = NEW.id_item;

    IF _tipo_item <> 'arma' THEN
			RAISE EXCEPTION 'Apenas items do tipo arma pode ser inseridos nessa tabela.';
    END IF;

    PERFORM * FROM arma WHERE id_item = NEW.id_item;
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
 				PERFORM * FROM armadura WHERE id_item = NEW.id;
    		IF NOT FOUND THEN 
					RAISE EXCEPTION 'Não pode ser criado um item do tipo armadura sem adicionar na tabela armadura';
    		END IF;
    END IF;

    RETURN NEW;

END;
$check_item$ LANGUAGE plpgsql;

-- DROP TRIGGER check_items ON item;

CREATE  CONSTRAINT TRIGGER check_items
AFTER UPDATE OR INSERT ON item
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW EXECUTE PROCEDURE check_item();
 
-- checar npc
CREATE OR REPLACE FUNCTION check_npc() RETURNS TRIGGER AS $check_npc$
BEGIN
		IF NEW.tipo_npc = 'monstro' THEN
 				PERFORM * FROM monstro WHERE id_npc_monstro = NEW.id;
    		IF NOT FOUND THEN 
					RAISE EXCEPTION 'Não pode ser criado um npc do tipo monstro sem adicionar na tabela monstro';
    		END IF;
    END IF;

    RETURN NEW;

END;
$check_npc$ LANGUAGE plpgsql;

--DROP TRIGGER check_npcs ON npc;
CREATE  CONSTRAINT TRIGGER check_npcs
AFTER UPDATE OR INSERT ON npc
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW EXECUTE PROCEDURE check_npc();
 
-- Procedure de criação de nova arma
CREATE OR REPLACE PROCEDURE cria_nova_arma (_nome_arma VARCHAR, _descricao_arma VARCHAR, _valor_arma INTEGER, _arma_dano INTEGER)
AS $cria_nova_arma$
  DECLARE
    _id_item INTEGER;
  BEGIN
    INSERT INTO item (nome, tipo_item, descricao, valor_moedas) 
    VALUES (_nome_arma, 'arma', _descricao_arma, _valor_arma) RETURNING id INTO _id_item;

    INSERT INTO arma(id_item, dano) VALUES
    (_id_item, _arma_dano);
  END;
$cria_nova_arma$ LANGUAGE plpgsql;

-- Procedure de criação de nova armadura
CREATE OR REPLACE PROCEDURE cria_nova_armadura (_nome_armadura VARCHAR, _descricao_armadura VARCHAR, _valor_armadura INTEGER, _armadura_vida INTEGER)
AS $cria_nova_armadura$
  DECLARE
    _id_item INTEGER;
  BEGIN
    INSERT INTO item (nome, tipo_item, descricao, valor_moedas) 
    VALUES (_nome_armadura, 'armadura', _descricao_armadura, _valor_armadura) RETURNING id INTO _id_item;

    INSERT INTO armadura(id_item, vida) VALUES
    (_id_item, _armadura_vida);
  END;
$cria_nova_armadura$ LANGUAGE plpgsql;

-- Procedure de criação de novo amuleto
CREATE OR REPLACE PROCEDURE cria_novo_amuleto (_nome_amuleto VARCHAR, _descricao_amuleto VARCHAR, _valor_amuleto INTEGER, _amuleto_sorte INTEGER)
AS $cria_nova_amuleto$
  DECLARE
    _id_item INTEGER;
  BEGIN
    INSERT INTO item (nome, tipo_item, descricao, valor_moedas) 
    VALUES (_nome_amuleto, 'amuleto', _descricao_amuleto, _valor_amuleto) RETURNING id INTO _id_item;

    INSERT INTO amuleto(id_item, sorte) VALUES
    (_id_item, _amuleto_sorte);
  END;
$cria_nova_amuleto$ LANGUAGE plpgsql;

-- Procedure de criação de novo monstro
CREATE OR REPLACE PROCEDURE cria_novo_monstro (_nome_monstro VARCHAR, _descricao_monstro VARCHAR, _id_mapa_monstro INTEGER, _moedas_monstro INTEGER, _vida_maxima_monstro INTEGER, _dano_monstro INTEGER, id_item_recompensa_monstro INTEGER)
AS $cria_novo_monstro$
  DECLARE
    _id_npc INTEGER;
  BEGIN
    INSERT INTO npc (nome, tipo_npc, descricao, id_mapa) 
    VALUES (_nome_monstro, 'monstro', _descricao_monstro, _id_mapa_monstro) RETURNING id INTO _id_npc;

    INSERT INTO monstro(id_npc_monstro, moedas, vida_maxima, dano, id_item_recompensa) 
    VALUES (_id_npc, _moedas_monstro, _vida_maxima_monstro, _dano_monstro, id_item_recompensa_monstro);
  END;
$cria_novo_monstro$ LANGUAGE plpgsql;

-- procedure que calcula a vida maxima
CREATE OR REPLACE FUNCTION calcula_vida_maxima() RETURNS TRIGGER AS $calcula_vida_maxima$
DECLARE 
    _vida_nova_armadura INTEGER;
    _vida_antiga_armadura INTEGER;
    _tipo_item TIPO_ITEM;
BEGIN
    SELECT J.tipo_item INTO _tipo_item FROM instancia_item I
     LEFT JOIN item J ON J.id = I.id_item
    WHERE I.id_item = NEW.id_armadura;

    IF _tipo_item <> 'armadura' THEN
    			RAISE EXCEPTION 'Apenas itens do tipo armadura podem ser equipados como armadura.';
    END IF;

		IF OLD.id_armadura IS NOT NULL THEN
      SELECT A.vida INTO _vida_nova_armadura FROM armadura A
      LEFT JOIN instancia_item I ON I.id = NEW.id_armadura
      WHERE A.id_item = I.id_item;

      SELECT A.vida INTO _vida_antiga_armadura FROM armadura A
      LEFT JOIN instancia_item I ON I.id = OLD.id_armadura
      WHERE A.id_item = I.id_item;

      NEW.vida_maxima := _vida_nova_armadura - _vida_antiga_armadura + OLD.vida_maxima;

    END IF;
    
    IF OLD.id_armadura IS NULL THEN
      SELECT A.vida INTO _vida_nova_armadura FROM armadura A
      LEFT JOIN instancia_item I ON I.id = NEW.id_armadura
      WHERE A.id_item = I.id_item;
      
      NEW.vida_maxima := _vida_nova_armadura + OLD.vida_maxima;

    END IF;
      	RETURN NEW;

END;
$calcula_vida_maxima$ LANGUAGE plpgsql;

--DROP TRIGGER calcula_vida ON personagens;
CREATE TRIGGER calcula_vida
BEFORE UPDATE OF id_armadura ON personagens
FOR EACH ROW EXECUTE PROCEDURE calcula_vida_maxima();

-- calcula sorte
CREATE OR REPLACE FUNCTION calcula_sorte_maxima() RETURNS TRIGGER AS $calcula_sorte_maxima$
DECLARE 
    _sorte_novo_amuleto INTEGER;
    _sorte_antigo_amuleto INTEGER;
    _tipo_item TIPO_ITEM;
BEGIN

    SELECT J.tipo_item INTO _tipo_item FROM instancia_item I
     LEFT JOIN item J ON J.id = I.id_item
    WHERE I.id_item = NEW.id_armadura;

    IF _tipo_item <> 'amuleto' THEN
    			RAISE EXCEPTION 'Apenas itens do tipo amuleto podem ser equipados como amuleto.';
    END IF;


		IF OLD.id_amuleto IS NOT NULL THEN
      SELECT A.sorte INTO _sorte_novo_amuleto FROM amuleto A
      LEFT JOIN instancia_item I ON I.id = NEW.id_amuleto
      WHERE A.id_item = I.id_item;

      SELECT A.sorte INTO _sorte_antigo_amuleto FROM amuleto A
      LEFT JOIN instancia_item I ON I.id = OLD.id_amuleto
      WHERE A.id_item = I.id_item;

      NEW.sorte_maxima := _sorte_novo_amuleto - _sorte_antigo_amuleto + OLD.sorte_maxima;

    END IF;
    
    IF OLD.id_amuleto IS NULL THEN
      SELECT A.sorte INTO _sorte_novo_amuleto FROM amuleto A
      LEFT JOIN instancia_item I ON I.id = NEW.id_amuleto
      WHERE A.id_item = I.id_item;
      
      NEW.sorte_maxima := _sorte_novo_amuleto + OLD.sorte_maxima;

    END IF;
      	RETURN NEW;

END;
$calcula_sorte_maxima$ LANGUAGE plpgsql;

--DROP TRIGGER calcula_sorte ON personagens;
CREATE TRIGGER calcula_sorte
BEFORE UPDATE OF id_amuleto ON personagens
FOR EACH ROW EXECUTE PROCEDURE calcula_sorte_maxima();

-- procedure para escolha de classe
CREATE OR REPLACE PROCEDURE seleciona_classe (_id_personagem INTEGER, _id_classe INTEGER)
AS $seleciona_classe$
  DECLARE
    _sorte INTEGER;
    _vida INTEGER;
  BEGIN
    
    SELECT vida_inicial, sorte INTO _vida, _sorte FROM classe WHERE id = _id_classe;

		UPDATE personagens SET id_classe = _id_classe, sorte_total = sorte_total + _sorte, vida_maxima = vida_maxima + _vida
    WHERE id = _id_personagem;

  END;
$seleciona_classe$ LANGUAGE plpgsql;




-- nao deixa equipar arma se nao for do tipo arma
CREATE OR REPLACE FUNCTION check_arma() RETURNS TRIGGER AS $check_arma$
DECLARE 
    _sorte_novo_amuleto INTEGER;
    _sorte_antigo_amuleto INTEGER;
    _tipo_item INTEGER;
BEGIN

 
    SELECT J.tipo_item INTO _tipo_item FROM instancia_item I
     LEFT JOIN item J ON J.id = I.id_item
    WHERE I.id_item = NEW.id_armadura;

    IF _tipo_item <> 'arma' THEN
    			RAISE EXCEPTION 'Apenas itens do tipo arma podem ser equipados como arma.';
    END IF;

 
      	RETURN NEW;

END;
$check_arma$ LANGUAGE plpgsql;

CREATE TRIGGER check_equip_arma
BEFORE UPDATE OF id_arma ON personagens
FOR EACH ROW EXECUTE PROCEDURE check_arma();