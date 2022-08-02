CREATE TYPE tipo_npc AS ENUM (
    'monstro', 'npc_missao', 'mercador'
);

CREATE TABLE personagens (
    id SERIAL PRIMARY KEY,
    id_classe INT,
    vida_maxima INT NOT NULL DEFAULT 50,
    moedas INT NOT NULL DEFAULT 0,
    CHECK(moedas >= 0)
    id_arma INT NOT NULL,
    id_armadura INT NOT NULL,
    id_mapa INT,

    CONSTRAINT id_classe_fk FOREIGN KEY(id_classe) REFERENCES classe(id)
    CONSTRAINT id_arma_fk FOREIGN KEY(id_arma) REFERENCES arma(id)
    CONSTRAINT id_armadura_fk FOREIGN KEY(id_armadura) REFERENCES armadura(id)
    CONSTRAINT id_mapa FOREIGN KEY(id_mapa) REFERENCES mapa(id)
);

CREATE TABLE mapa (
  id INT PRIMARY KEY,
  coord_x INT,
  coord_y INT,
  descricao VARCHAR(140),
  mapa_norte INT,
  mapa_sul INT,
  mapa_leste INT,
  mapa_oeste INT
);

CREATE TABLE magias (
  id INT PRIMARY KEY,
  classe_id INT,
  nome VARCHAR,
  descricao VARCHAR,
  dano INT,
  cura INT
);

CREATE TABLE classe (
  id INT PRIMARY KEY,
  nome VARCHAR,
  descricao VARCHAR,
  vida_inicial INT
);

CREATE TABLE item (
  id INT PRIMARY KEY,
  nome VARCHAR,
  descricao VARCHAR,
  valor_moedas INT
);

CREATE TABLE instancia_item (
  id INT PRIMARY KEY,
  id_item INT
);

CREATE TABLE mochila (
  id INT PRIMARY KEY,
  id_personagem INT,
  id_instancia_item INT
);

CREATE TABLE armadura (
  id INT PRIMARY KEY,
  id_item INT,
  nome VARCHAR,
  vida INT
);

CREATE TABLE arma (
  id INT PRIMARY KEY,
  id_item INT,
  nome VARCHAR,
  dano INT
);

CREATE TABLE missao (
  id INT PRIMARY KEY,
  id_npc_missao INT,
  descricao VARCHAR,
  moedas INT,
  id_item_missao INT,
  id_item_reconpensa INT
);

CREATE TABLE monstro (
  id INT PRIMARY KEY,
  nome VARCHAR,
  tipo_npc enum,
  descricao VARCHAR,
  moedas INT,
  vida_maxima INT,
  dano INT,
  id_item_reconpensa INT,
  id_mapa INT
);

CREATE TABLE mercador (
  id INT PRIMARY KEY,
  nome VARCHAR,
  tipo_npc enum,
  descricao VARCHAR,
  id_mapa INT
);

CREATE TABLE mercador_itens (
  id INT PRIMARY KEY,
  id_mercador INT,
  id_instancia_item INT
);

CREATE TABLE npc_missao (
  id INT PRIMARY KEY,
  nome VARCHAR,
  tipo_npc enum,
  descricao VARCHAR,
  id_mapa INT
);

ALTER TABLE personagens ADD FOREIGN KEY (id_classe) REFERENCES classe (id);

ALTER TABLE personagens ADD FOREIGN KEY (id_arma) REFERENCES arma (id);

ALTER TABLE personagens ADD FOREIGN KEY (id_armadura) REFERENCES armadura (id);

ALTER TABLE personagens ADD FOREIGN KEY (id_mapa) REFERENCES mapa (id);

ALTER TABLE mapa ADD FOREIGN KEY (mapa_norte) REFERENCES mapa (id);

ALTER TABLE mapa ADD FOREIGN KEY (mapa_sul) REFERENCES mapa (id);

ALTER TABLE mapa ADD FOREIGN KEY (mapa_leste) REFERENCES mapa (id);

ALTER TABLE mapa ADD FOREIGN KEY (mapa_oeste) REFERENCES mapa (id);

ALTER TABLE magias ADD FOREIGN KEY (classe_id) REFERENCES classe (id);

ALTER TABLE instancia_item ADD FOREIGN KEY (id_item) REFERENCES item (id);

ALTER TABLE mochila ADD FOREIGN KEY (id_personagem) REFERENCES personagens (id);

ALTER TABLE mochila ADD FOREIGN KEY (id_instancia_item) REFERENCES instancia_item (id);

ALTER TABLE armadura ADD FOREIGN KEY (id_item) REFERENCES item (id);

ALTER TABLE arma ADD FOREIGN KEY (id_item) REFERENCES item (id);

ALTER TABLE missao ADD FOREIGN KEY (id_npc_missao) REFERENCES npc_missao (id);

ALTER TABLE missao ADD FOREIGN KEY (id_item_missao) REFERENCES item (id);

ALTER TABLE missao ADD FOREIGN KEY (id_item_reconpensa) REFERENCES item (id);

ALTER TABLE monstro ADD FOREIGN KEY (id_item_reconpensa) REFERENCES item (id);

ALTER TABLE monstro ADD FOREIGN KEY (id_mapa) REFERENCES mapa (id);

ALTER TABLE mercador ADD FOREIGN KEY (id_mapa) REFERENCES mapa (id);

ALTER TABLE mercador_itens ADD FOREIGN KEY (id_mercador) REFERENCES mercador (id);

ALTER TABLE mercador_itens ADD FOREIGN KEY (id_instancia_item) REFERENCES instancia_item (id);

ALTER TABLE npc_missao ADD FOREIGN KEY (id_mapa) REFERENCES mapa (id);