BEGIN;

CREATE TYPE TIPO_NPC AS ENUM (
    'monstro', 'npc_missao', 'mercador'
);

CREATE TYPE TIPO_ITEM AS ENUM (
    'arma', 'armadura', 'nao_equipavel', 'amuleto'
);

CREATE TYPE TIPO_CONQUISTA AS ENUM (
    'combate', 'exploração', 'geral'
);

CREATE TABLE mapa (
    id SERIAL PRIMARY KEY,
    coord_x INT NOT NULL,
    coord_y INT NOT NULL,
    nome VARCHAR(50) NOT NULL,
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

CREATE TABLE npc (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50),
    tipo_npc TIPO_NPC NOT NULL,
    descricao VARCHAR(255),
    id_mapa INT NOT NULL,

    CONSTRAINT mercador_mapa_fk FOREIGN KEY(id_mapa) REFERENCES mapa(id)
);

CREATE TABLE classe (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    descricao VARCHAR(255) NOT NULL,
    sorte INT NOT NULL,
    vida_inicial INT NOT NULL
);

CREATE TABLE magias (
    id SERIAL PRIMARY KEY,
    classe_id INT NOT NULL,
    nome VARCHAR(50) NOT NULL,
    descricao VARCHAR(255) NOT NULL,
    dano INT,
    cura INT,

    CONSTRAINT classe_id_fk FOREIGN KEY(classe_id) REFERENCES classe(id)
);

CREATE TABLE item (
  id SERIAL,
  nome VARCHAR(25) NOT NULL,
  tipo_item TIPO_ITEM NOT NULL,
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
  id SERIAL,
  id_item INT NOT NULL,
  vida INT NOT NULL,

  CONSTRAINT armadura_pk PRIMARY KEY(id),
  CONSTRAINT armadura_item_fk FOREIGN KEY(id_item) REFERENCES item(id)
);

CREATE TABLE arma (
  id SERIAL,
  id_item INT NOT NULL,
  dano INT NOT NULL,

  CONSTRAINT arma_pk PRIMARY KEY(id),
  CONSTRAINT arma_item_fk FOREIGN KEY(id_item) REFERENCES item(id)
);

CREATE TABLE amuleto (
  id SERIAL,
  id_item INT NOT NULL,
  sorte INT NOT NULL,

  CONSTRAINT amuleto_pk PRIMARY KEY(id),
  CONSTRAINT amuleto_item_fk FOREIGN KEY(id_item) REFERENCES item(id)
);

CREATE TABLE missao (
    id SERIAL PRIMARY KEY,
    id_npc_missao INT NOT NULL,
    descricao VARCHAR(255),
    moedas INT NOT NULL DEFAULT 0,
    id_item_missao INT NOT NULL,
    id_item_recompensa INT,
    id_missao_desbloqueada INT,

    CONSTRAINT npc_missao_fk FOREIGN KEY(id_npc_missao) REFERENCES npc(id),
    CONSTRAINT missao_desbloqueada_fk FOREIGN KEY(id_missao_desbloqueada) REFERENCES missao(id),
    CONSTRAINT item_missao_fk FOREIGN KEY(id_item_missao) REFERENCES item(id),
    CONSTRAINT item_recompensa_missao_fk FOREIGN KEY(id_item_recompensa) REFERENCES item(id)
);

CREATE TABLE personagens (
    id SERIAL PRIMARY KEY,
    id_classe INT,
    moedas INT NOT NULL DEFAULT 0,
    CHECK(moedas >= 0),
    id_arma INT,
    id_armadura INT,
    id_amuleto INT,
    id_mapa INT NOT NULL,
    id_ultima_missao INT,
    sorte_total INT NOT NULL DEFAULT 0,
    vida_maxima INT NOT NULL DEFAULT 0,

    CONSTRAINT classe_fk FOREIGN KEY(id_classe) REFERENCES classe(id),
    CONSTRAINT ultima_missao_fk FOREIGN KEY(id_ultima_missao) REFERENCES missao(id),
    CONSTRAINT arma_fk FOREIGN KEY(id_arma) REFERENCES instancia_item(id),
    CONSTRAINT armadura_fk FOREIGN KEY(id_armadura) REFERENCES instancia_item(id),
    CONSTRAINT amuleto_fk FOREIGN KEY(id_amuleto) REFERENCES instancia_item(id),
    CONSTRAINT mapa FOREIGN KEY(id_mapa) REFERENCES mapa(id)
);

CREATE TABLE conquistas (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(25) NOT NULL,
  tipo_conquista TIPO_CONQUISTA NOT NULL,
  descricao VARCHAR(255) NOT NULL
);

CREATE TABLE conquistas_personagem (
    id SERIAL PRIMARY KEY,
    id_personagem INT NOT NULL,
    id_conquista INT NOT NULL,

    CONSTRAINT personagem_fk FOREIGN KEY(id_personagem) REFERENCES personagens(id),
    CONSTRAINT conquista_fk FOREIGN KEY(id_conquista) REFERENCES conquistas(id)
);

CREATE TABLE mochila (
  id SERIAL PRIMARY KEY,
  id_personagem INT,
  id_instancia_item INT,

  CONSTRAINT mochila_personagem_fk FOREIGN KEY(id_personagem) REFERENCES personagens(id),
  CONSTRAINT mochila_instancia_item_fk FOREIGN KEY(id_instancia_item) REFERENCES instancia_item(id)
);

CREATE TABLE npc_mercador_itens (
    id SERIAL PRIMARY KEY,
    id_npc_mercador INT NOT NULL,
    id_instancia_item INT NOT NULL,

    CONSTRAINT mercador_item_fk FOREIGN KEY(id_npc_mercador) REFERENCES npc(id),
    CONSTRAINT instancia_item_mercador_fk FOREIGN KEY(id_instancia_item) REFERENCES mapa(id)
);

CREATE TABLE monstro (
    id SERIAL,
    id_npc_monstro INT NOT NULL,
    moedas INT NOT NULL DEFAULT 0,
    vida_maxima INT NOT NULL,
    dano INT NOT NULL,
    id_item_recompensa INT,

    CONSTRAINT monstro_pk PRIMARY KEY(id),
    CONSTRAINT npc_monstro_fk FOREIGN KEY(id_npc_monstro) REFERENCES npc(id),
    CONSTRAINT item_recompensa_monstro_fk FOREIGN KEY(id_item_recompensa) REFERENCES item(id)
);

COMMIT;
