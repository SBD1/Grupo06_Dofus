-- query para pegar todas magias de um personagem
SELECT magias.nome, magias.descricao, magias.dano, magias.cura FROM magias 
	INNER JOIN classe ON magias.classe_id = classe.id
WHERE classe.id = 
	(SELECT id_classe FROM personagens 
	INNER JOIN classe ON personagens.id_classe = classe.id
	WHERE personagens.id = 1);

-- versão reduzida
SELECT M.nome, M.descricao, M.dano, M.cura FROM magias M
	INNER JOIN classe C ON M.classe_id = C.id
WHERE C.id = 
	(SELECT id_classe FROM personagens P
	INNER JOIN classe C ON P.id_classe = C.id
	WHERE P.id = 1);

SELECT * FROM instancia_item
	INNER JOIN mochila ON instancia_item.id = mochila.id_instancia_item
WHERE mochila.id = 
	(SELECT id_personagem FROM mochila
	INNER JOIN personagens ON personagens.id = mochila.id_personagem
	WHERE personagens.id = 1);

-- query para pegar o monstro de um mapa
SELECT * FROM monstro WHERE monstro.id_mapa = 3;

-- List intens dos mais caros aos mais baratos
SELECT * FROM item ORDER BY valor_moedas

-- Lista armas ordenando da mais poderosa para mais fraca
SELECT * FROM arma ORDER BY dano DESC

-- Lista armadura ordenando da mais poderosa para mais fraca
SELECT * FROM armadura ORDER BY vida DESC

-- Lista amuletos ordenando do com mais sorte para menos sorte
SELECT * FROM amuleto ORDER BY sorte DESC

-- query para listar todos os itens de um personagem
SELECT * FROM instancia_item
	INNER JOIN mochila ON instancia_item.id = mochila.id_instancia_item
WHERE mochila.id_personagem = 1;

-- query para listar todos os itens de um personagem e suas quantidade e suas informacoes
SELECT I.id, I.nome, I.tipo_item, I.descricao, I.valor_moedas, count(I.id) as qnt FROM item I
	INNER JOIN instancia_item J ON I.id = J.id_item
 	INNER JOIN mochila M ON M.id_instancia_item = J.id
  	INNER JOIN personagens P ON p.id = M.id_personagem
WHERE P.id = 1 
GROUP BY I.id

-- equipar arma no personagem
START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	SELECT I.id FROM instancia_item I 
		JOIN mochila M on I.id = M.id_instancia_item 
		WHERE I.id_item = 1 
 		AND M.id_personagem = 1 
		AND I.tipo_item = 'arma'
 	LIMIT 1;

	DELETE FROM mochila  WHERE id_instancia_item = I.id and id_personagem = 1;

	UPDATE personagem SET id_arma = I.id WHERE id_personagem = 1;
COMMIT;


-- vender item para mercador
START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	SELECT I.id, J.valor_moedas FROM instancia_item I 
		JOIN mochila M on I.id = M.id_instancia_item 
		JOIN item J On I.id_item = J.id
		WHERE I.id_item = 1 
 		AND M.id_personagem = 1 
 	LIMIT 1;

	DELETE FROM mochila  WHERE id_instancia_item = I.id and id_personagem = 1;

	UPDATE personagem SET moedas = J.valor_moedas WHERE id_personagem = 1;
COMMIT;

-- equipar amuleto no personagem
START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	SELECT I.id FROM instancia_item I 
		JOIN mochila M on I.id = M.id_instancia_item 
		WHERE I.id_item = 1 
 		AND M.id_personagem = 1 
		AND I.tipo_item = 'amuleto'
 	LIMIT 1;

	UPDATE personagem SET id_arma = I.id WHERE id_personagem = 1;

	DELETE FROM mochila  WHERE id_instancia_item = I.id and id_personagem = 1;

COMMIT;

-- equipar armadura no personagem
START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	SELECT I.id FROM instancia_item I 
		JOIN mochila M on I.id = M.id_instancia_item 
		WHERE I.id_item = 1 
 		AND M.id_personagem = 1 
		AND I.tipo_item = 'armadura'
 	LIMIT 1;

	DELETE FROM mochila  WHERE id_instancia_item = I.id and id_personagem = 1;

	UPDATE personagem SET id_arma = I.id WHERE id_personagem = 1;
COMMIT;


START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	SELECT equipar_armadura(1, 1);
COMMIT;

CREATE OR REPLACE FUNCTION equipar_armadura(personagem NUMERIC, item NUMERIC) RETURNS void AS $equipar_armadura$
  DECLARE
  id_instancia_armadura INTEGER;
  BEGIN

    	--- SELECIONA O ID DA INSTANCIA DA ARMADURA
      SELECT I.id, J.descricao INTO id_instancia_armadura
        FROM instancia_item I 
        JOIN mochila M on I.id = M.id_instancia_item 
        JOIN 	item J on I.id_item = J.id
        WHERE I.id_item = item 
        AND M.id_personagem = personagem
        AND J.tipo_item = 'armadura'
      LIMIT 1;
      
    --- DELETA A INSTANCIA DE ARMADURA DA MOCHILA
      DELETE FROM mochila WHERE id_instancia_item = id_instancia_armadura AND id_personagem = personagem;

    --- EQUIPA A INSTANCIA DA ARMADURA NO PERSONAGEM
      UPDATE personagens SET id_armadura = id_instancia_armadura  WHERE id = personagem;
    
END;  
$equipar_armadura$ LANGUAGE plpgsql;



START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
  DO
  $$
    DECLARE
      id_instancia_armadura INTEGER;
	  id_instancia_armadura_antiga INTEGER;
    BEGIN

		SELECT id_armadura INTO id_instancia_armadura_antiga
			FROM personagens WHERE id = 1;

		--- SE JA POSSUIR ARMADURA, RETIRA A ARMADURA ANTIGA E COLOCA NA MOCHILA
		IF (id_instancia_armadura_antiga <> NULL) THEN
			UPDATE personagens SET id_armadura = NULL  WHERE id = 1;
			INSERT INTO mochila (id_personagem, id_instancia_item) VALUES (1, id_instancia_armadura_antiga);
		END IF;

        --- SELECIONA O ID DA INSTANCIA DA ARMADURA
        SELECT I.id, J.descricao INTO id_instancia_armadura
          FROM instancia_item I 
          JOIN mochila M on I.id = M.id_instancia_item 
          JOIN 	item J on I.id_item = J.id
          WHERE I.id_item = 1 
          AND M.id_personagem = 1
          AND J.tipo_item = 'armadura'
        LIMIT 1;

      --- DELETA A INSTANCIA DE ARMADURA DA MOCHILA
        DELETE FROM mochila WHERE id_instancia_item = id_instancia_armadura AND id_personagem = 1;

      --- EQUIPA A INSTANCIA DA ARMADURA NO PERSONAGEM
        UPDATE personagens SET id_armadura = id_instancia_armadura  WHERE id = 1;
    END;  
  $$;
COMMIT;

START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
  DO
  $$
    DECLARE
      id_instancia_amuleto INTEGER;
	  id_instancia_amuleto_antiga INTEGER;
    BEGIN

		SELECT id_amuleto INTO id_instancia_amuleto_antiga
			FROM personagens WHERE id = 1;

		--- SE JA POSSUIR AMULETO, RETIRA O AMULETO ANTIGO E COLOCA NA MOCHILA
		IF (id_instancia_amuleto_antiga <> NULL) THEN
			UPDATE personagens SET id_amuleto = NULL  WHERE id = 1;
			INSERT INTO mochila (id_personagem, id_instancia_item) VALUES (1, id_instancia_amuleto_antiga);
		END IF;

        --- SELECIONA O ID DA INSTANCIA DO AMULETO
        SELECT I.id, J.descricao INTO id_instancia_amuleto
          FROM instancia_item I 
          JOIN mochila M on I.id = M.id_instancia_item 
          JOIN 	item J on I.id_item = J.id
          WHERE I.id_item = 1 
          AND M.id_personagem = 1
          AND J.tipo_item = 'amuleto'
        LIMIT 1;

      --- DELETA A INSTANCIA DE AMULETO DA MOCHILA
        DELETE FROM mochila WHERE id_instancia_item = id_instancia_amuleto AND id_personagem = 1;

      --- EQUIPA A INSTANCIA DA AMULETO NO PERSONAGEM
        UPDATE personagens SET id_amuleto = id_instancia_amuleto  WHERE id = 1;
    END;  
  $$;
COMMIT;

START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
  DO
  $$
    DECLARE
      id_instancia_arma INTEGER;
	  id_instancia_arma_antiga INTEGER;
    BEGIN

		SELECT id_arma INTO id_instancia_arma_antiga
			FROM personagens WHERE id = 1;

		--- SE JA POSSUIR ARMA, RETIRA A ARMA ANTIGA E COLOCA NA MOCHILA
		IF (id_instancia_arma_antiga <> NULL) THEN
			UPDATE personagens SET id_arma = NULL  WHERE id = 1;
			INSERT INTO mochila (id_personagem, id_instancia_item) VALUES (1, id_instancia_arma_antiga);
		END IF;

        --- SELECIONA O ID DA INSTANCIA DO ARMA
        SELECT I.id, J.descricao INTO id_instancia_arma
          FROM instancia_item I 
          JOIN mochila M on I.id = M.id_instancia_item 
          JOIN 	item J on I.id_item = J.id
          WHERE I.id_item = 1 
          AND M.id_personagem = 1
          AND J.tipo_item = 'arma'
        LIMIT 1;

      --- DELETA A INSTANCIA DE ARMA DA MOCHILA
        DELETE FROM mochila WHERE id_instancia_item = id_instancia_arma AND id_personagem = 1;

      --- EQUIPA A INSTANCIA DA ARMA NO PERSONAGEM
        UPDATE personagens SET id_arma = id_instancia_arma  WHERE id = 1;
    END;  
  $$;
COMMIT;


--- transaction se o personagem morre em combate
START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	DELETE FROM mochila WHERE id_personagem = 1;

	UPDATE personagens SET id_arma = NULL  WHERE id = 1;
	UPDATE personagens SET id_amuleto = NULL  WHERE id = 1;
	UPDATE personagens SET id_armadura = NULL  WHERE id = 1;
	UPDATE personagens SET moedas = 0  WHERE id = 1;
COMMIT;


-- todo
-- CREATE OR REPLACE FUNCTION check_armadura() RETURNS trigger AS $check_armadura$
-- 	DECLARE
-- 		discs_prof INTEGER;
-- 	BEGIN
-- 		SELECT COUNT(*) INTO discs_prof
-- 			FROM DISCIPLINA
-- 			WHERE Professor = NEW.Aluno AND
-- 			Sigla = NEW.Sigla;
-- 			IF discs_prof > 0 THEN
-- 				RAISE EXCEPTION 'Um professor não pode se matricular em disciplinas que ele mesmo
-- 				ministra';
-- 			END IF;
-- 		RETURN NEW; --- retorna a tupla para prosseguir com a operação
-- 	END;
-- $check_armadura$ LANGUAGE plpgsql;

-- DROP TRIGGER check_generalizacao_armadura ON armadura;
-- CREATE TRIGGER check_generalizacao_armadura
-- BEFORE INSERT ON armadura

-- FOR EACH ROW EXECUTE PROCEDURE check_armadura();


-- todo
-- CREATE OR REPLACE FUNCTION calcular_vida_maxima() RETURNS trigger AS $calcular_vida_maxima$
-- 	DECLARE
-- 		vida_armadura INTEGER;
-- 	BEGIN
-- 		SELECT id_armadura INTO vida_armadura
-- 			FROM DISCIPLINA
-- 			WHERE Professor = NEW.Aluno AND
-- 			Sigla = NEW.Sigla;
-- 			IF discs_prof > 0 THEN
-- 				RAISE EXCEPTION 'Um professor não pode se matricular em disciplinas que ele mesmo
-- 				ministra';
-- 			END IF;
-- 		RETURN NEW; --- retorna a tupla para prosseguir com a operação
-- 	END;
-- $calcular_vida_maxima$ LANGUAGE plpgsql;

-- DROP TRIGGER calcular_vida_maxima_personagens ON personagens;
-- CREATE TRIGGER calcular_vida_maxima_personagens
-- BEFORE INSERT ON personagens

-- FOR EACH ROW EXECUTE PROCEDURE calcular_vida_maxima();


-- query para ver em qual mapa o personagem esta
    SELECT M.id, M.coord_x, M.coord_y, M.descricao, M.mapa_norte, M.mapa_sul, M.mapa_leste, M.mapa_oeste, M.nome
         from mapa M 
         INNER JOIN personagens 
         p ON m.id = p.id_mapa WHERE p.id = 1;

-- query para pegar stats do personagem
SELECT P.vida_maxima, C.nome as nome_classe, P.sorte_total FROM personagens P JOIN classe C ON C.id = P.id_classe WHERE P.id = ${this.idPersonagem}

-- query para pegar todos npcs de um mapa
SELECT N.id, N.nome, N.tipo_npc, N.descricao, n.id_mapa
        FROM npc N 
        JOIN mapa M ON M.id = N.id_mapa 
        WHERE M.id = ${currentMap.id};  

-- update do mapa
UPDATE personagens SET id_mapa = ${availableChoices.mapChoices[answer].mapa_id} WHERE id = ${this.idPersonagem};

-- pegar informacoes do personagem batalha
SELECT A.dano, I.nome AS nome_arma, P.sorte_total, P.vida_maxima FROM personagens P 
  JOIN instancia_item J ON P.id_arma = J.id
  JOIN item I ON I.id = J.id_item
  JOIN arma A ON A.id_item = I.id
  WHERE P.id = 1;

  -- pegar informacoes do monstro para batalha
  --left join no item pra caso seja null
      SELECT M.moedas, M.vida_maxima, M.dano, M.id_item_recompensa, N.nome, N.descricao, I.nome as nome_item_recompensa FROM monstro M 
      JOIN npc N ON N.id = M.id_npc_monstro 
      LEFT JOIN item I ON i.id = M.id_item_recompensa
      WHERE id_npc_monstro = ${idNPC}


-- receber o item apos matar monstro
   START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
        DO
        $$
          DECLARE
            id_instancia_item INTEGER;
          BEGIN
            INSERT INTO instancia_item (id_item) VALUES (${monsterStats.id_item_recompensa});
            SELECT currval(pg_get_serial_sequence('instancia_item','id')) INTO id_instancia_item;
            INSERT INTO mochila (id_personagem, id_instancia_item) VALUES (${this.idPersonagem}, id_instancia_item);
            UPDATE personagens SET moedas = moedas + ${monsterStats.moedas};
          END;  
        $$;
        COMMIT;