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

-- Lista armas ordenando da mais poderosa para mais fraca
SELECT * FROM arma ORDER BY dano DESC

-- Lista armadura
SELECT * FROM armaduras

-- Lista armadura ordenando da mais poderosa para mais fraca
SELECT * FROM armadura ORDER BY vida DESC

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

-- equipar item no personagem
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
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
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	SELECT I.id FROM instancia_item I 
		JOIN mochila M on I.id = M.id_instancia_item 
		JOIN item J On I.id_item = J.id
		WHERE I.id_item = 1 
 		AND M.id_personagem = 1 
 	LIMIT 1;

	DELETE FROM mochila  WHERE id_instancia_item = I.id and id_personagem = 1;

	UPDATE personagem SET moedas = J.valor_moedas WHERE id_personagem = 1;
COMMIT;