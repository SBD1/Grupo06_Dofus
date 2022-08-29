-- PROCEDURE DA GENERALIZACAO DE MONSTRO

CREATE OR REPLACE FUNCTION check_especializacao_monstro() RETURNS TRIGGER AS $check_especializacao_monstro$
DECLARE 
    _tipo_npc TIPO_NPC;
BEGIN

    SELECT tipo_npc INTO _tipo_npc FROM npc WHERE npc.id = NEW.id_npc_monstro;

    IF _tipo_npc <> 'monstro' THEN
			RAISE EXCEPTION 'Apenas NPCS do tipo monstro pode ser inseridos nessa tabela.';
    END IF;

    PERFORM * FROM monstro WHERE id_npc_monstro = NEW.id_npc_monstro;
    IF FOUND THEN 
			RAISE EXCEPTION 'Já existe um monstro com esse id_npc_monstro';
    END IF;
    RETURN NEW;

END;
$check_especializacao_monstro$ LANGUAGE plpgsql;

CREATE TRIGGER check_monstro
BEFORE UPDATE OR INSERT ON monstro
FOR EACH ROW EXECUTE PROCEDURE check_especializacao_monstro();
