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

COMMIT;