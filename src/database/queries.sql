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

-- List all items
SELECT * FROM item

-- Lista armas
SELECT * FROM armas

-- Lista armadura
SELECT * FROM armaduras

-- query para listar todos os itens de um personagem
SELECT * FROM instancia_item
	INNER JOIN mochila ON instancia_item.id = mochila.id_instancia_item
WHERE mochila.id_personagem = 1;

-- query para listar todos os itens de um personagem e suas quantidade
SELECT I.nome, I.tipo_item, I.descricao, I.valor_moedas, count(I.id) as qnt FROM item I
	INNER JOIN instancia_item J ON I.id = J.id_item
  INNER JOIN mochila M ON M.id_instancia_item = J.id
  INNER JOIN personagens P ON p.id = M.id_personagem
WHERE P.id = 1 
GROUP BY I.id


