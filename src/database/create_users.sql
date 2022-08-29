-- Create a read only user
CREATE ROLE dofus_read_only_user LOGIN PASSWORD 'readonly_secret';

GRANT CONNECT ON DATABASE dofus TO dofus_read_only_user;
GRANT USAGE ON SCHEMA public TO dofus_read_only_user;

GRANT SELECT ON public."amuleto" TO dofus_read_only_user;
GRANT SELECT ON public."arma" TO dofus_read_only_user;
GRANT SELECT ON public."armadura" TO dofus_read_only_user;
GRANT SELECT ON public."classe" TO dofus_read_only_user;
GRANT SELECT ON public."conquistas" TO dofus_read_only_user;
GRANT SELECT ON public."conquistas_personagem" TO dofus_read_only_user;
GRANT SELECT ON public."instancia_item" TO dofus_read_only_user;
GRANT SELECT ON public."item" TO dofus_read_only_user;
GRANT SELECT ON public."magias" TO dofus_read_only_user;
GRANT SELECT ON public."mapa" TO dofus_read_only_user;
GRANT SELECT ON public."missao" TO dofus_read_only_user;
GRANT SELECT ON public."mochila" TO dofus_read_only_user;
GRANT SELECT ON public."monstro" TO dofus_read_only_user;
GRANT SELECT ON public."npc" TO dofus_read_only_user;
GRANT SELECT ON public."npc_mercador_itens" TO dofus_read_only_user;
GRANT SELECT ON public."personagens" TO dofus_read_only_user;

