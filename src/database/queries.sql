SELECT A.dano, I.nome AS nome_arma, P.sorte_total, P.vida_maxima FROM personagens P 
      LEFT JOIN instancia_item J ON P.id_arma = J.id
      LEFT JOIN item I ON I.id = J.id_item
      LEFT JOIN arma A ON A.id_item = I.id
      WHERE P.id = ${this.idPersonagem};

SELECT M.moedas, M.vida_maxima, M.dano, M.id_item_recompensa, N.nome, N.descricao, I.nome as nome_item_recompensa FROM monstro M 
JOIN npc N ON N.id = M.id_npc_monstro 
LEFT JOIN item I ON i.id = M.id_item_recompensa
WHERE id_npc_monstro = ${idNPC};
    
SELECT magias.nome, magias.descricao, magias.dano, magias.cura FROM magias 
      INNER JOIN classe ON magias.classe_id = classe.id
      WHERE classe.id = 
      (SELECT id_classe FROM personagens 
      INNER JOIN classe ON personagens.id_classe = classe.id
      WHERE personagens.id = ${this.idPersonagem});

UPDATE personagens SET moedas = moedas + ${monsterStats.moedas};

SELECT * FROM classe;

UPDATE personagens SET id_classe = ${classe.id}, vida_maxima = ${classe.vida_inicial} + vida_maxima, sorte_total = ${classe.sorte} + sorte_total WHERE id = ${this.idPersonagem};

SELECT id_classe FROM personagens WHERE id = ${this.idPersonagem};

SELECT M.id, M.coord_x, M.coord_y, M.descricao, M.mapa_norte, M.mapa_sul, M.mapa_leste, M.mapa_oeste, M.nome
         from mapa M 
         INNER JOIN personagens 
         p ON m.id = p.id_mapa WHERE p.id = ${this.idPersonagem};

SELECT P.vida_maxima, C.nome as nome_classe, P.sorte_total, P.moedas FROM personagens P JOIN classe C ON C.id = P.id_classe WHERE P.id = ${this.idPersonagem};

SELECT N.id, N.nome, N.tipo_npc, N.descricao, n.id_mapa
        FROM npc N 
        JOIN mapa M ON M.id = N.id_mapa 
        WHERE M.id = ${currentMap.id};  

UPDATE personagens SET id_mapa = ${availableChoices.mapChoices[answer].mapa_id} WHERE id = ${this.idPersonagem};

SELECT I.id, I.nome, I.tipo_item, I.descricao, I.valor_moedas, A.dano, B.vida, C.sorte, count(I.id) as qnt FROM item I
      INNER JOIN instancia_item J ON I.id = J.id_item
      INNER JOIN mochila M ON M.id_instancia_item = J.id
      INNER JOIN personagens P ON p.id = M.id_personagem
      LEFT JOIN arma A ON A.id_item = I.id
      LEFT JOIN armadura B ON B.id_item = i.id
      LEFT JOIN amuleto C ON C.id_item = I.id
      WHERE P.id = ${this.idPersonagem}
      GROUP BY I.id, A.dano, B.vida, C.sorte;

SELECT * FROM npc WHERE id = ${idNpc};

SELECT I.id, I.nome, I.tipo_item, I.descricao, I.valor_moedas, count(I.id) as qnt, A.dano, B.vida, C.sorte FROM item I
      INNER JOIN instancia_item J ON I.id = J.id_item
      INNER JOIN mochila M ON M.id_instancia_item = J.id
      INNER JOIN personagens P ON p.id = M.id_personagem
      LEFT JOIN arma A ON A.id_item = I.id
      LEFT JOIN armadura B ON B.id_item = I.id
      LEFT JOIN amuleto C ON C.id_item = I.id
      WHERE P.id = ${this.idPersonagem}
      GROUP BY I.id, A.dano, B.vida, C.sorte;

SELECT I.id, I.nome,I.descricao, I.valor_moedas, count(I.id) as qnt, A.dano, B.vida, C.sorte FROM item I
      INNER JOIN instancia_item J ON I.id = J.id_item
      INNER JOIN npc_mercador_itens M ON M.id_instancia_item = J.id
      INNER JOIN npc P ON p.id = M.id_npc_mercador
      LEFT JOIN arma A ON A.id_item = I.id
      LEFT JOIN armadura B ON B.id_item = I.id
      LEFT JOIN amuleto C ON C.id_item = I.id
      WHERE P.id = ${merchant.id}
      GROUP BY I.id, A.dano, B.vida, C.sorte;

SELECT moedas FROM personagens WHERE id = ${this.idPersonagem};

SELECT * FROM npc WHERE id = ${id_npc};

SELECT * FROM missao WHERE id_npc_missao = ${id_npc} AND id = (
      SELECT M.id_missao_desbloqueada FROM personagens P 
      LEFT JOIN missao M ON M.id = P.id_ultima_missao
      WHERE P.id = ${this.idPersonagem};

SELECT id_ultima_missao FROM personagens WHERE id = ${this.idPersonagem};

SELECT * FROM missao WHERE id_npc_missao = ${id_npc} AND id = 1;

SELECT nome FROM item WHERE id = ${currentQuest.id_item_recompensa};

SELECT I.id FROM instancia_item I
LEFT JOIN mochila M ON M.id_instancia_item = I.id 
WHERE I.id_item = ${currentQuest.id_item_missao} AND M.id_personagem = ${this.idPersonagem} LIMIT 1;