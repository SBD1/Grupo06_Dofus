BEGIN;

CREATE TYPE TIPO_NPC AS ENUM (
    'monstro', 'npc_missao', 'mercador'
);

CREATE TABLE mapa (
    id SERIAL PRIMARY KEY,
    coord_x INT NOT NULL,
    coord_y INT NOT NULL,
    descricao VARCHAR(255) NOT NULL,
    mapa_norte INT,
    mapa_sul INT,
    mapa_leste INT,
    mapa_oeste INT,

    CONSTRAINT mapa_norte_fk FOREIGN KEY(mapa_norte) REFERENCES mapa(id),
    CONSTRAINT mapa_sul_fk FOREIGN KEY(mapa_sul) REFERENCES mapa(id),
    CONSTRAINT mapa_leste_fk FOREIGN KEY(mapa_leste) REFERENCES mapa(id),
    CONSTRAINT mapa_oeste_fk FOREIGN KEY(mapa_oeste) REFERENCES mapa(id)
);

CREATE TABLE classe (
    id INT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    descricao VARCHAR(255) NOT NULL,
    vida_inicial INT NOT NULL
);

CREATE TABLE magias (
    id INT PRIMARY KEY,
    classe_id INT,
    nome VARCHAR(50) NOT NULL,
    descricao VARCHAR(255) NOT NULL,
    dano INT,
    cura INT,

    CONSTRAINT classe_id_fk FOREIGN KEY(classe_id) REFERENCES classe(id)
);

CREATE TABLE item (
  id SERIAL,
  nome VARCHAR(25) NOT NULL,
  descricao VARCHAR(255) NOT NULL DEFAULT '',
  valor_moedas INTEGER NOT NULL,

  CONSTRAINT item_pk PRIMARY KEY (id)
);

CREATE TABLE instancia_item (
  id SERIAL,
  id_item INT NOT NULL,
  CONSTRAINT instancia_item_pk PRIMARY KEY(id),
  CONSTRAINT instancia_item_fk FOREIGN KEY(id_item) REFERENCES item(id)
);

CREATE TABLE armadura (
  id INT PRIMARY KEY,
  id_item INT NOT NULL,
  vida INT NOT NULL,

  CONSTRAINT armadura_item_fk FOREIGN KEY(id_item) REFERENCES item(id)
);

CREATE TABLE arma (
  id int PRIMARY KEY,
  id_item INT NOT NULL,
  dano INT NOT NULL,

  CONSTRAINT arma_item_fk FOREIGN KEY(id_item) REFERENCES item(id)
);

CREATE TABLE personagens (
    id SERIAL PRIMARY KEY,
    id_classe INT,
    vida_maxima INT NOT NULL,
    moedas INT NOT NULL DEFAULT 0,
    CHECK(moedas >= 0),
    id_arma INT,
    id_armadura INT,
    id_mapa INT,

    CONSTRAINT classe_fk FOREIGN KEY(id_classe) REFERENCES classe(id),
    CONSTRAINT arma_fk FOREIGN KEY(id_arma) REFERENCES arma(id),
    CONSTRAINT armadura_fk FOREIGN KEY(id_armadura) REFERENCES armadura(id),
    CONSTRAINT mapa FOREIGN KEY(id_mapa) REFERENCES mapa(id)
);

CREATE TABLE mochila (
  id int PRIMARY KEY,
  id_personagem INT,
  id_instancia_item INT,

  CONSTRAINT mochila_instancia_item_fk FOREIGN KEY(id) REFERENCES instancia_item(id),
  CONSTRAINT mochila_personagem_fk FOREIGN KEY(id) REFERENCES personagens(id)
);

CREATE TABLE mercador (
    id INT PRIMARY KEY,
    nome VARCHAR(50),
    tipo_npc TIPO_NPC NOT NULL,
    descricao VARCHAR(255),
    id_mapa INT NOT NULL,

    CONSTRAINT mercador_mapa_fk FOREIGN KEY(id_mapa) REFERENCES mapa(id)
);

CREATE TABLE mercador_itens (
    id INT PRIMARY KEY,
    id_mercador INT NOT NULL,
    id_instancia_item INT NOT NULL,

    CONSTRAINT mercador_item_fk FOREIGN KEY(id_mercador) REFERENCES mapa(id),
    CONSTRAINT instancia_item_mercador_fk FOREIGN KEY(id_instancia_item) REFERENCES mapa(id)
);

CREATE TABLE npc_missao (
    id INT PRIMARY KEY,
    nome VARCHAR(50),
    tipo_npc TIPO_NPC NOT NULL,
    descricao VARCHAR(255) NOT NULL,
    id_mapa INT NOT NULL,

    CONSTRAINT npc_missao_mapa_fk FOREIGN KEY(id_mapa) REFERENCES mapa(id)
);

CREATE TABLE missao (
    id INT PRIMARY KEY,
    id_npc_missao INT NOT NULL,
    descricao VARCHAR(255),
    moedas INT NOT NULL DEFAULT 0,
    id_item_missao INT NOT NULL,
    id_item_recompensa INT,

    CONSTRAINT npc_missao_fk FOREIGN KEY(id_npc_missao) REFERENCES npc_missao(id),
    CONSTRAINT item_missao_fk FOREIGN KEY(id_item_missao) REFERENCES item(id),
    CONSTRAINT item_recompensa_missao_fk FOREIGN KEY(id_item_recompensa) REFERENCES item(id)
);

CREATE TABLE monstro (
    id INT PRIMARY KEY,
    nome VARCHAR(50),
    tipo_npc TIPO_NPC NOT NULL,
    descricao VARCHAR(255),
    moedas INT NOT NULL DEFAULT 0,
    vida_maxima INT NOT NULL,
    dano INT NOT NULL,
    id_item_recompensa INT,
    id_mapa INT NOT NULL,

    CONSTRAINT item_recompensa_monstro_fk FOREIGN KEY(id_item_recompensa) REFERENCES item(id),
    CONSTRAINT mosntro_mapa_fk FOREIGN KEY(id_mapa) REFERENCES mapa(id)
);

COMMIT;
