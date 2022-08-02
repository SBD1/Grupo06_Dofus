BEGIN;

INSERT INTO mapa (coord_x, coord_y, descricao, mapa_norte, mapa_sul, mapa_leste, mapa_oeste) VALUES
(0, 0, 'Seja bem vinda jovem alma, você acaba de incarnar no mundo dos Doze. Você se encontra em um templo de pedras claras, com detalhes em branco, e dourado. Algumas pedras flutuam a sua volta.', NULL, NULL, NULL, 2),
(1, 0, 'Você se encontra na saída do templo de pedras, em suas costas há uma grande porta de madeira, e em sua frente um vasto campo de trigos, um tapete dourado. Entre eles uma estrada, o chamado caminho das almas.', NULL, NULL, 3, NULL),
(2, 0, 'Você se encontra em um uma espécie de feira, há várias pessoas comprando os mais diversos produtos. há algumas estradas que vão para todas as direções. No sul, uma floresta escura, no norte, um campo dourado.', 4, 5, NULL, 2),
(2, 1, 'Você se encontra em um grande pasto dourado, há algumas plantações distantes, e alguns papatudos com a lâ branca, quase prateada, a sua volta.', NULL, 3, NULL, NULL),
(2, -1, 'Você se encontra nos limítes da floresta sombria, mas não exatamente dentro dela. Ainda há bastante luz entre as árvores de folhas escuras, mas você já consegue ouvir lobos uivando.', 3, NULL, NULL, NULL),
(2, -1, 'Você se encontra em um lago bem azul, cercado pela grama dourada. Você vê alguns peixes nadando, e algumas pessoas pescando.', NULL, NULL, NULL, 3);

INSERT INTO classe (nome, descricao, vida_inicial) VALUES
('Eniripsa', 'Os Eniripsas são curandeiros capazes de curar com uma simples palavra. Eles usam o poder das palavras para aliviar o sofrimento dos seus aliados, mas também para ferir seus inimigos.', 3000),
('Iop', 'Os Iops são guerreiros intrépidos e temerários! Uma coisa é certa: os Iops sabem usar suas armas como ninguém. Para eles, entrar em uma briga ao menos uma vez por dia é sinal de boa saúde.', 3000),
('Sacrier', 'Os Sacriers são berserkers capazes de multiplicar sua força cada vez que são atacados! Como não têm medo de receber golpes nem de se expor ao perigo, eles costumam ficar na linha de frente, prontos para derramar o sangue dos inimigos!', 5000),
('Ecaflip', 'Os Ecaflips são guerreiros apostadores que vivem enfiados em lugares onde é possível ganhar uma grana preta e perder tudo... Um bom Ecaflip joga sem parar e sempre aposta no tudo ou nada.', 1500),
('Feca', 'Os Fecas são protetores leais e ficam sempre na defensiva. Eles são muito apreciados pelos grupos de aventureiros graças às suas armaduras elementares capazes de suportar até mesmo os golpes mais fortes.', 8000);

INSERT INTO magias (classe_id, nome, descricao, dano, cura) VALUES
(1, 'Palavra que fere', 'Uma magia que causa danos em seus inimigos através da palavra.', 200, 0),
(1, 'Palavra de regeneração', 'Uma magia que cura até os ferimentos mais profundos.', 0, 500),

(2, 'Concentração', 'Um golpe com as proprias mãos cheias de fúria.',250, 100),
(2, 'Ira de Iop', 'Uma magia de ataque poderosa, criada pelo próprio Deus Iop.', 500, 0),

(3, 'Absorção', 'Uma magia que absorve o sangue dos inimigos.', 150, 100),
(3, 'Punição','Um golpe ultimato do sacrier.', 300, 0),

(4, 'Moeda do Ecaflip', 'Às vezes apostas podem curar.',0, 400),
(4, 'Rekop', 'Uma magia ancestral dos Ecaflip', 750, 0),

(5, 'Ataque natural', 'Um ataque das forças da terra.', 200, 50),
(5, 'Ataque tempestuoso', 'Um ataque das forças das núvens.',250, 0);

INSERT INTO item (nome, descricao, valor_moedas) VALUES  
('Armadura de Papatudo Real', 'Armadura forjada com pelos de Papatudo Real, está armadura aveludada não é muito cheirosa, mas carrega a gloria dos campos de Astrub', 288),
('Armadura do Aventureiro', 'Todo grande guerreiro tem um ponto de partida, essa armadura é o que você precisa para iniciar suas expedições', 25),
('Armadura de Piwi', 'A nobreza de um guerreiro está no coração, está armadura de penas não muito elegante carrega o poder da aura pura dos Piwis de Astrub', 90),
('Armadura de Prespic', 'Armadura feita com os espinhos, unhas, e pelos de Prespics selvagens, conferindo imensa resistência ao barbaro guerreiro que a usa', 25),
('Armadura de Girassol', 'Está armadura é leve, feita para guerreiros de porte pequeno, com brancinhos de girassol, apesar de singela ela carrega o poder das magias solares.', 144),
('Arco de Bwork', 'Alcance alidado à força bruta, arco dos selvagens Bworks das grutas de Astrub.', 402),
('Espada de Iop', 'Essa espada foi roubada de um lendário Iop que pereceu nas grandes batalhas do calabouço de Incarnan', 750),
('Lança de Chefer', 'Lança retirada em espedições no calabouço de Incarnan, confeccionada com restos de ossos de Chefers malucos', 489),
('Pá de Cortes Sombrios ', 'Esta pá serve para enterrar objetos, mortos ou vivos.', 500),
('Espatula Corta Guloso', 'Esta espátula gigante é uma ferramenta de trabalho muito completa. Com ela, é possível preparar quantidades enormes de doces de chocolate deliciosos e, depois, fatiar sem dó nem piedade os gulosos que tentarem comer o seu bolo sem a sua permissão.', 333),
('Semente de Gergelim', 'Esta semente extremamente rica em proteína é um ingrediente seleto para a fabricação de pão saboroso, mas o cultivo de gergelim é especialmente delicado em nosso clima dofusiano. Como resultado, uma semente muito rara e cara.', 9),
('Pelo de Rato', 'Restos de pelo coletados dos esgotos de Astrub, cuidado com o odor.', 14),
('Testiculo de Lobo', 'Esferas de carne removidas de grandes lobos selvagens das planices de Incarnan', 40),
('Lã de papatudo', 'Papatudo são criaturas que tem uma lã platinada fofinha.', 80),
('Pedregulho de Rochedo', 'Pedregulho retirado das chamines dos anões mineradores dos arredores de Astrub', 25);

INSERT INTO armadura(id_item, vida) VALUES
(1, 200),
(2, 41),
(3, 120),
(4, 63),
(5,160);

INSERT INTO arma(id_item, dano) VALUES
(6, 202),
(7, 350),
(8, 228),
(9, 250),
(10,149);

INSERT INTO instancia_item(id_item) VALUES
(1),
(6),
(11),
(12),
(13),
(14);

INSERT INTO personagens (id_class, moedas, id_arma, id_armadura, id_mapa) VALUES
(1, 40, NULL, NULL, 1);

INSERT INTO mochila (id_personagem, id_instancia_item) VALUES
(1, 4),
(1, 5),
(1, 6);

INSERT INTO npc_missao (nome, tipo_npc, descricao, id_mapa) VALUES
('Maurí Sioserrano', 'npc_missao', 'Maurí é um guerreiro experiente, que possui várias cicatrizes de batalha, você sente que ele pode te ensinar sobre magia.', 6);

INSERT INTO missao (id_npc_missao, descricao, moedas, id_item_missao, id_item_recompensa) VALUES
(1, 'Encontre uma semente de gergelim para completar essa missão, geralmente os Piwis gostam muito dessas sementes.', 40, 11, NULL),
(1, 'Encontre um pelo de rato, esse animais gostam de lugares escuros.', 200, 12, 3),
(1, 'Encontre o testículo de um lobo raivoso.', 500, 13, NULL),
(1, 'Encontre um pouco de lã de papatudo, geralmente eles gostam de ficar nos campos.', 200, 14, NULL),
(1, 'Encontre pedregulho do rochedo.', 5000, 15, NULL);

INSERT INTO mercador (nome, tipo_npc, descricao, id_mapa) VALUES
('Afonso', 'mercador', 'O maior varegista de Astrub', 2);

INSERT INTO mercador_itens(id_mercador, id_instancia_item) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4), 
(1, 5);

INSERT INTO monstro (nome, tipo_npc, descricao, moedas, vida_maxima, dano, id_item_recompensa, id_mapa) VALUES
('Chupa Cabra', 'monstro', 'Criatura sanguinaria destruidora de vilas', 23, 599, 59, 1, 3),
('Papatudo', 'monstro', 'Essa criatura é reponsável por proteger os campos de Astrub e Incarnan', 28, 455, 24, 2, 3),
('Piwi', 'monstro', 'Pequenina ave colorida, porem poderosa', 30, 504, 30, 3, 3),
('Lobo', 'monstro', 'Criatura uivante maluca e assassina', 30, 444, 40, 4, 3),
('Prespic', 'monstro', 'Espinhoso monstro venenoso', 30, 401, 20, 5, 3);

COMMIT;
