BEGIN;

INSERT INTO mapa (coord_x, coord_y, descricao, mapa_norte, mapa_sul, mapa_leste, mapa_oeste) VALUES
(0, 0, 'Seja bem vinda jovem alma, você acaba de incarnar no mundo dos Doze. Você se encontra em um templo de pedras claras, com detalhes em branco, e dourado. Algumas pedras flutuam a sua volta.', NULL, NULL, NULL, 2),
(1, 0, 'Você se encontra na saída do templo de pedras, em suas costas há uma grande porta de madeira, e em sua frente um vasto campo de trigos, um tapete dourado. Entre eles uma estrada, o chamado caminho das almas.', NULL, NULL, 3, NULL),
(2, 0, 'Você se encontra em um uma espécie de feira, há várias pessoas comprando os mais diversos produtos. há algumas estradas que vão para todas as direções. No sul, uma floresta escura, no norte, um campo dourado.', 4, 5, NULL, 2),
(2, 1, 'Você se encontra em um grande pasto dourado, há algumas plantações distantes, e alguns papatudos com a lâ branca, quase prateada, a sua volta.', NULL, 3, NULL, NULL),
(2, -1, 'Você se encontra nos limítes da floresta sombria, mas não exatamente dentro dela. Ainda há bastante luz entre as árvores de folhas escuras, mas você já consegue ouvir lobos uivando.', 3, NULL, NULL, NULL),
(2, -1, 'Você se encontra em um lago bem azul, cercado pela grama dourada. Você vê alguns peixes nadando, e algumas pessoas pescando.', NULL, NULL, NULL, 3)

-- ITEM
INSERT INTO item (nome, descricao, valor_moedas) VALUES  
('Armadura de Papatudo Real', 'Armadura forjada com pelos de Papatudo Real, está armadura aveludada não é muito cheirosa, mas carrega a gloria dos campos de Astrub', 288)
('Armadura do Aventureiro', 'Todo grande guerreiro tem um ponto de partida, essa armadura é o que você precisa para iniciar suas expedições', 25)
('Armadura de Piwi', 'A nobreza de um guerreiro está no coração, está armadura de penas não muito elegante carrega o poder da aura pura dos Piwis de Astrub', 90)
('Armadura de Prespic', 'Armadura feita com os espinhos, unhas, e pelos de Prespics selvagens, conferindo imensa resistência ao barbaro guerreiro que a usa', 25)
('Armadura de Girassol', 'Está armadura é leve, feita para guerreiros de porte pequeno, com brancinhos de girassol, apesar de singela ela carrega o poder das magias solares.', 144)
('Arco de Bwork', 'Alcance alidado à força bruta, arco dos selvagens Bworks das grutas de Astrub.', 402)
('Espada de Iop', 'Essa espada foi roubada de um lendário Iop que pereceu nas grandes batalhas do calabouço de Incarnan', 750)
('Lança de Chefer', 'Lança retirada em espedições no calabouço de Incarnan, confeccionada com restos de ossos de Chefers malucos', 489)
('Pá de Cortes Sombrios ', 'Esta pá serve para enterrar objetos, mortos ou vivos.', 500)
('Espatula Corta Guloso', 'Esta espátula gigante é uma ferramenta de trabalho muito completa. Com ela, é possível preparar quantidades enormes de doces de chocolate deliciosos e, depois, fatiar sem dó nem piedade os gulosos que tentarem comer o seu bolo sem a sua permissão.', 333)
('Semente de Gergilim', 'Esta semente extremamente rica em proteína é um ingrediente seleto para a fabricação de pão saboroso, mas o cultivo de gergelim é especialmente delicado em nosso clima dofusiano. Como resultado, uma semente muito rara e cara.', 9)
('Pelo de Rato', 'Restos de pelo coletados dos esgotos de Astrub, cuidado com o odor.', 14)
('Testiculo de Lobo', 'Esferas de carne removidas de grandes lobos selvagens das planices de Incarnan', 40)
('Pedregulho de Rochedo', 'Pedregulho retirado das chamines dos anões mineradores dos arredores de Astrub', 25)

INSERT INTO armadura(id_item, dano) VALUES
(1, 200)
(2, 41)
(3, 120)
(4, 63)
(5,160)

INSERT INTO arma(id_item, dano) VALUES
(6, 202)
(7, 350)
(8, 228)
(9, 250)
(10,149)

INSERT INTO instancia_item(id_item) VALUES
(1)
(6)
(11)
(12)
(13)
(14)

COMMIT;
