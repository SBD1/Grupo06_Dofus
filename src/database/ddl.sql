CREATE TABLE "personagens" (
  "id" SERIAL PRIMARY KEY,
  "id_classe" int,
  "vida_maxia" int,
  "moedas" int,
  "id_arma" int,
  "id_armadura" int,
  "id_mapa" int
);

CREATE TABLE "mapa" (
  "id" int PRIMARY KEY,
  "coord_x" int,
  "coord_y" int,
  "descricao" varchar,
  "mapa_norte" int,
  "mapa_sul" int,
  "mapa_leste" int,
  "mapa_oeste" int
);

CREATE TABLE "magias" (
  "id" int PRIMARY KEY,
  "classe_id" int,
  "nome" varchar,
  "descricao" varchar,
  "dano" int,
  "cura" int
);

CREATE TABLE "classe" (
  "id" int PRIMARY KEY,
  "nome" varchar,
  "descricao" varchar,
  "vida_inicial" int
);

CREATE TABLE "item" (
  "id" int PRIMARY KEY,
  "nome" varchar,
  "descricao" varchar,
  "valor_moedas" int
);

CREATE TABLE "instancia_item" (
  "id" int PRIMARY KEY,
  "id_item" int
);

CREATE TABLE "mochila" (
  "id" int PRIMARY KEY,
  "id_personagem" int,
  "id_instancia_item" int
);

CREATE TABLE "armadura" (
  "id" int PRIMARY KEY,
  "id_item" int,
  "nome" varchar,
  "vida" int
);

CREATE TABLE "arma" (
  "id" int PRIMARY KEY,
  "id_item" int,
  "nome" varchar,
  "dano" int
);

CREATE TABLE "missao" (
  "id" int PRIMARY KEY,
  "id_npc_missao" int,
  "descricao" varchar,
  "moedas" int,
  "id_item_missao" int,
  "id_item_reconpensa" int
);

CREATE TABLE "monstro" (
  "id" int PRIMARY KEY,
  "nome" varchar,
  "tipo_npc" enum,
  "descricao" varchar,
  "moedas" int,
  "vida_maxima" int,
  "dano" int,
  "id_item_reconpensa" int,
  "id_mapa" int
);

CREATE TABLE "mercador" (
  "id" int PRIMARY KEY,
  "nome" varchar,
  "tipo_npc" enum,
  "descricao" varchar,
  "id_mapa" int
);

CREATE TABLE "mercador_itens" (
  "id" int PRIMARY KEY,
  "id_mercador" int,
  "id_instancia_item" int
);

CREATE TABLE "npc_missao" (
  "id" int PRIMARY KEY,
  "nome" varchar,
  "tipo_npc" enum,
  "descricao" varchar,
  "id_mapa" int
);

ALTER TABLE "personagens" ADD FOREIGN KEY ("id_classe") REFERENCES "classe" ("id");

ALTER TABLE "personagens" ADD FOREIGN KEY ("id_arma") REFERENCES "arma" ("id");

ALTER TABLE "personagens" ADD FOREIGN KEY ("id_armadura") REFERENCES "armadura" ("id");

ALTER TABLE "personagens" ADD FOREIGN KEY ("id_mapa") REFERENCES "mapa" ("id");

ALTER TABLE "mapa" ADD FOREIGN KEY ("mapa_norte") REFERENCES "mapa" ("id");

ALTER TABLE "mapa" ADD FOREIGN KEY ("mapa_sul") REFERENCES "mapa" ("id");

ALTER TABLE "mapa" ADD FOREIGN KEY ("mapa_leste") REFERENCES "mapa" ("id");

ALTER TABLE "mapa" ADD FOREIGN KEY ("mapa_oeste") REFERENCES "mapa" ("id");

ALTER TABLE "magias" ADD FOREIGN KEY ("classe_id") REFERENCES "classe" ("id");

ALTER TABLE "instancia_item" ADD FOREIGN KEY ("id_item") REFERENCES "item" ("id");

ALTER TABLE "mochila" ADD FOREIGN KEY ("id_personagem") REFERENCES "personagens" ("id");

ALTER TABLE "mochila" ADD FOREIGN KEY ("id_instancia_item") REFERENCES "instancia_item" ("id");

ALTER TABLE "armadura" ADD FOREIGN KEY ("id_item") REFERENCES "item" ("id");

ALTER TABLE "arma" ADD FOREIGN KEY ("id_item") REFERENCES "item" ("id");

ALTER TABLE "missao" ADD FOREIGN KEY ("id_npc_missao") REFERENCES "npc_missao" ("id");

ALTER TABLE "missao" ADD FOREIGN KEY ("id_item_missao") REFERENCES "item" ("id");

ALTER TABLE "missao" ADD FOREIGN KEY ("id_item_reconpensa") REFERENCES "item" ("id");

ALTER TABLE "monstro" ADD FOREIGN KEY ("id_item_reconpensa") REFERENCES "item" ("id");

ALTER TABLE "monstro" ADD FOREIGN KEY ("id_mapa") REFERENCES "mapa" ("id");

ALTER TABLE "mercador" ADD FOREIGN KEY ("id_mapa") REFERENCES "mapa" ("id");

ALTER TABLE "mercador_itens" ADD FOREIGN KEY ("id_mercador") REFERENCES "mercador" ("id");

ALTER TABLE "mercador_itens" ADD FOREIGN KEY ("id_instancia_item") REFERENCES "instancia_item" ("id");

ALTER TABLE "npc_missao" ADD FOREIGN KEY ("id_mapa") REFERENCES "mapa" ("id");