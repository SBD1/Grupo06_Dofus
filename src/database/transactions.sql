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
       

 START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
          DELETE FROM mochila WHERE id_personagem = ${this.idPersonagem};
          UPDATE personagens SET id_mapa = 1 WHERE id = ${this.idPersonagem};
          UPDATE personagens SET moedas = 0  WHERE id = ${this.idPersonagem};
        COMMIT;

START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    DO
    $$
      DECLARE
      id_instancia_armadura_nova INTEGER;
      id_instancia_armadura_antiga INTEGER;
      id_item_mochila INTEGER;
      BEGIN
  
      SELECT id_armadura INTO id_instancia_armadura_antiga
        FROM personagens WHERE id = ${this.idPersonagem};
  
          --- SELECIONA O ID DA INSTANCIA DA ARMADURA
          SELECT I.id, M.id INTO id_instancia_armadura_nova, id_item_mochila
            FROM instancia_item I 
            JOIN mochila M on I.id = M.id_instancia_item 
            JOIN 	item J on I.id_item = J.id
            WHERE I.id_item = ${item.id} 
            AND M.id_personagem = ${this.idPersonagem}
            AND J.tipo_item = 'armadura'
          LIMIT 1;
  
        --- DELETA A INSTANCIA DE ARMADURA DA MOCHILA
          DELETE FROM mochila WHERE id = id_item_mochila;
  
        --- EQUIPA A INSTANCIA DA ARMADURA NO PERSONAGEM
          UPDATE personagens SET id_armadura = id_instancia_armadura_nova  WHERE id = ${this.idPersonagem};
  
      --- SE JA POSSUIR ARMADURA, RETIRA A ARMADURA ANTIGA E COLOCA NA MOCHILA
      IF (id_instancia_armadura_antiga IS NOT NULL) THEN
        UPDATE personagens SET id_armadura = NULL  WHERE id = 1;
        INSERT INTO mochila (id_personagem, id_instancia_item) VALUES (${this.idPersonagem}, id_instancia_armadura_antiga);
      END IF;
  
      END;  
    $$;
  COMMIT;



  START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
  DO
  $$
    DECLARE
      id_instancia_amuleto_nova INTEGER;
	    id_instancia_amuleto_antiga INTEGER;
      id_item_mochila INTEGER;
    BEGIN

		SELECT id_amuleto INTO id_instancia_amuleto_antiga
			FROM personagens WHERE id = ${this.idPersonagem};

    --- SELECIONA O ID DA INSTANCIA DO AMULETO
        SELECT I.id INTO id_instancia_amuleto_nova
          FROM instancia_item I 
          JOIN mochila M on I.id = M.id_instancia_item 
          JOIN 	item J on I.id_item = J.id
          WHERE I.id_item = ${item.id}
          AND M.id_personagem = ${this.idPersonagem}
          AND J.tipo_item = 'amuleto'
        LIMIT 1;

      --- DELETA A INSTANCIA DE AMULETO DA MOCHILA
      DELETE FROM mochila WHERE id = id_item_mochila;

      --- EQUIPA A INSTANCIA DA AMULETO NO PERSONAGEM
        UPDATE personagens SET id_amuleto = id_instancia_amuleto_nova  WHERE id = ${this.idPersonagem};

		--- SE JA POSSUIR AMULETO, RETIRA O AMULETO ANTIGO E COLOCA NA MOCHILA
		IF (id_instancia_amuleto_antiga IS NOT NULL) THEN
			UPDATE personagens SET id_amuleto = NULL  WHERE id = ${this.idPersonagem};
			INSERT INTO mochila (id_personagem, id_instancia_item) VALUES (${this.idPersonagem}, id_instancia_amuleto_antiga);
		END IF;

    
    END;  
  $$;
COMMIT;



START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
DO
$$
  DECLARE
    id_instancia_arma_nova INTEGER;
    id_instancia_arma_antiga INTEGER;
    id_item_mochila INTEGER;
  BEGIN

  SELECT id_arma INTO id_instancia_arma_antiga
    FROM personagens WHERE id = ${this.idPersonagem};

      --- SELECIONA O ID DA INSTANCIA DO ARMA
      SELECT I.id INTO id_instancia_arma_nova
        FROM instancia_item I 
        JOIN mochila M on I.id = M.id_instancia_item 
        JOIN 	item J on I.id_item = J.id
        WHERE I.id_item = ${item.id}
        AND M.id_personagem = ${this.idPersonagem}
        AND J.tipo_item = 'arma'
      LIMIT 1;

    --- DELETA A INSTANCIA DE ARMA DA MOCHILA
    DELETE FROM mochila WHERE id = id_item_mochila;

    --- EQUIPA A INSTANCIA DA ARMA NO PERSONAGEM
      UPDATE personagens SET id_arma = id_instancia_arma_nova  WHERE id = ${this.idPersonagem};

  --- SE JA POSSUIR ARMA, RETIRA A ARMA ANTIGA E COLOCA NA MOCHILA
  IF (id_instancia_arma_antiga IS NOT NULL) THEN
    UPDATE personagens SET id_arma = NULL  WHERE id = ${this.idPersonagem};
    INSERT INTO mochila (id_personagem, id_instancia_item) VALUES (${this.idPersonagem}, id_instancia_arma_antiga);
  END IF;

  END;  
$$;
COMMIT;


START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    DO
    $$
      DECLARE
        _id_instancia_item INTEGER;
      BEGIN
        SELECT I.id INTO _id_instancia_item FROM instancia_item I
            LEFT JOIN npc_mercador_itens M ON M.id_instancia_item = I.id 
            WHERE I.id_item = ${item.id} AND M.id_npc_mercador = ${merchant.id}
            LIMIT 1;
        
        DELETE FROM npc_mercador_itens WHERE id_instancia_item = _id_instancia_item;

        INSERT INTO mochila (id_personagem, id_instancia_item) VALUES (${this.idPersonagem}, _id_instancia_item);
        UPDATE personagens SET moedas = moedas - ${item.valor_moedas};
      END;  
    $$;
    COMMIT;
    
  START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    DO
    $$
      DECLARE
        _id_instancia_item INTEGER;
      BEGIN
        SELECT I.id INTO _id_instancia_item FROM instancia_item I
            LEFT JOIN mochila M ON M.id_instancia_item = I.id 
            WHERE I.id_item = ${item.id} AND M.id_personagem = ${this.idPersonagem};
        
        DELETE FROM mochila WHERE id_instancia_item = _id_instancia_item AND id_personagem = ${this.idPersonagem};
        DELETE FROM instancia_item WHERE id = _id_instancia_item;
        UPDATE personagens SET moedas = moedas + ${item.valor_moedas};
      END;  
    $$;
    COMMIT;
  

   START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    DO
    $$
      DECLARE
        _id_instancia_item INTEGER;
      BEGIN
        INSERT INTO instancia_item (id_item) VALUES (${currentQuest.id_item_recompensa});
        SELECT currval(pg_get_serial_sequence('instancia_item','id')) INTO _id_instancia_item;
        INSERT INTO mochila (id_personagem, id_instancia_item) VALUES (${this.idPersonagem}, _id_instancia_item);
        
        UPDATE personagens SET moedas = moedas + ${currentQuest.moedas};
        UPDATE personagens SET id_ultima_missao = ${currentQuest.id};

        DELETE FROM mochila WHERE id_instancia_item = ${hasItem.id} AND id_personagem = ${this.idPersonagem};
        DELETE FROM instancia_item WHERE id = ${hasItem.id};
      END;  
    $$;
    COMMIT;
   