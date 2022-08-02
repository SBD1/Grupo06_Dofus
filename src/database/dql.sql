-- query para pegar todas magias de um personagem
SELECT * FROM magias 
	INNER JOIN classe ON magias.classe_id = classe.id
WHERE classe.id = 
	(SELECT id_classe FROM personagens 
	INNER JOIN classe ON personagens.id_classe = classe.id
	WHERE personagens.id = 1);

-- query para pegar o monstro de um mapa
SELECT * FROM monstro WHERE monstro.id_mapa = 3;